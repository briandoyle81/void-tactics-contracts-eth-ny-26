// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Commit-reveal randomness. `requestRandomness` commits to a request at the
// current block; the entropy can only be locked in once block.prevrandao has
// actually CHANGED from whatever it was at commit time — not merely once a
// later block number is reached. This distinction matters concretely on
// Base: block.prevrandao there is relayed from Ethereum L1's own RANDAO
// output, so it only updates roughly every 6 L2 blocks (~12s, matching L1's
// block time), not every L2 block (confirmed empirically against live Base
// Sepolia blocks — see docs/pre-audit.md's C-01/C-02 remediation addendum).
// A plain "block.number > commit block" check would let a reveal land in a
// LATER L2 block that still shares the SAME, already-public prevrandao the
// requester could see before ever deciding whether to submit — checking for
// an actual change closes that regardless of how many L2 blocks a chain
// happens to share one prevrandao value across, present or future.
//
// `fulfillRandomRequest` — the name/shape consumers like Ships.sol have
// always called — is the single consumer-facing entry point: it reveals on
// first call (if the entropy window has opened) and simply returns the
// already-locked result on every call after that, so a caller like
// Ships.constructShip never needs a separate prior reveal transaction at
// all. `revealRandomness`/`revealRandomnessBatch` still exist purely as an
// optional pre-warming path (e.g. a keeper wanting to front-load the
// SSTORE-heavy first-reveal cost into its own transaction, ahead of a
// player's own batched construct call) — nothing requires them to be called.
//
// Deliberately NOT mixing block.timestamp into the result (see the addendum
// dated 2026-08-27 in docs/pre-audit.md): pulling live Base blocks showed
// timestamps advance on a perfectly rigid, zero-jitter 2-second grid, with
// no exceptions across ~600 consecutive block pairs sampled over a full day.
// Since block.prevrandao is stable for ~6 consecutive L2 blocks (one L1
// epoch) and every block's timestamp within that epoch is then a fully
// deterministic function of when the epoch started, mixing timestamp into
// the hash contributed no real entropy — it just handed anyone 6 exactly-
// computable candidate outcomes per epoch instead of 1, a ~6x weakening of
// the "must wait for a fresh epoch" protection this scheme depends on.
// Result now depends only on block.prevrandao (genuinely not derivable in
// advance) and the request id.
//
// This closes the "call the provider with a forged/arbitrary id to preview
// a result and revert if unfavorable" gap the original pre-fix mock version
// had (see docs/pre-audit.md C-01/C-02): every id must have genuinely been
// issued by requestRandomness, and each can only be locked in once.
//
// Residual risk (unchanged by the above, and inherent to any scheme built
// on caller-timed reveal rather than an external oracle): a sufficiently
// patient caller can still choose WHEN to trigger the reveal, and since
// block.prevrandao for the current epoch is public the instant that epoch
// begins, they can preview (off-chain, for free) what a reveal submitted
// right now would produce and simply decline to submit if unfavorable,
// waiting for the next ~12s epoch to check again — this works whether
// reveal happens via a dedicated call or, as here, inline inside
// fulfillRandomRequest/constructShip, since the exposure is about WHEN the
// caller chooses to trigger the one-time lock-in, not which function does
// it. Separately, block.prevrandao on Base is relayed from L1 Ethereum's
// RANDAO, not chosen by Base's sequencer directly — but whoever proposes
// that L1 block still has the usual (much more limited, much more
// decentralized) L1 RANDAO-grinding options available to any L1 validator,
// and Base's sequencer separately retains some influence over which block a
// submitted reveal/construct transaction actually lands in. A real VRF
// (e.g. Chainlink VRF) is the only way to remove trust assumptions like
// these entirely; this is a pragmatic middle ground given the current
// deploy target (Base) has no on-chain unpredictable-randomness precompile
// the way Flow's Cadence Arch does (see CadenceArchCaller.sol, unused).
contract RandomManager {
    struct Request {
        uint blockNumber;
        uint prevRandaoAtCommit;
        bool revealed;
        uint64 result;
    }

    uint public requestCount;
    // Public so a read-only caller (frontend, test) can inspect an already-
    // locked-in result (.result, .revealed) without paying gas on a
    // non-view fulfillRandomRequest call — the same data is also emitted
    // via RandomnessRevealed, this is just a more convenient lookup by id.
    mapping(uint => Request) public requests;

    error RequestNotFound();
    error TooSoonToReveal();

    event RandomnessRequested(uint indexed requestId, uint blockNumber);
    event RandomnessRevealed(uint indexed requestId, uint64 result);

    function requestRandomness() external returns (uint requestId) {
        requestCount++;
        requestId = requestCount;
        requests[requestId] = Request({
            blockNumber: block.number,
            prevRandaoAtCommit: block.prevrandao,
            revealed: false,
            result: 0
        });
        emit RandomnessRequested(requestId, block.number);
    }

    // Consumption step — same name/shape Ships.sol has always called. Reveals
    // (locks in a result, permanently, the first time this is called for a
    // given id) if it hasn't been already, then returns the result either
    // way. This is what makes the mint -> construct flow exactly two
    // transactions: Ships.constructShip calls this directly, with no
    // separate prior reveal transaction required.
    function fulfillRandomRequest(uint _requestId) external returns (uint64) {
        if (_requestId == 0 || _requestId > requestCount) revert RequestNotFound();
        Request storage request = requests[_requestId];
        if (request.revealed) {
            return request.result;
        }
        return _revealRandomness(_requestId);
    }

    // Optional pre-warming path: locks in a result for `_requestId` early,
    // in its own transaction, ahead of whenever the ship actually gets
    // constructed. Nothing requires calling this — fulfillRandomRequest
    // (called by Ships.constructShip) does the same lock-in automatically
    // on first use. This exists only for a caller (e.g. a keeper) who wants
    // to pay the first-reveal SSTORE cost separately from a large batched
    // construct call, or who wants the result available for preview (see
    // GenerateNewShip.generateShip) before committing to construct.
    function revealRandomness(uint _requestId) external returns (uint64) {
        if (_requestId == 0 || _requestId > requestCount) revert RequestNotFound();
        Request storage request = requests[_requestId];
        if (request.revealed) {
            return request.result;
        }
        return _revealRandomness(_requestId);
    }

    // Batch form of revealRandomness — lets a caller who requested N ships'
    // worth of randomness in one mint transaction pre-warm all N in a single
    // transaction. Every request from the same mint tx shares the same
    // commit block (and therefore the same prevRandaoAtCommit), so they all
    // become revealable at the exact same moment — there's no per-request
    // staggering to work around.
    //
    // An already-revealed id is skipped (its stored result is returned)
    // rather than reverting the whole batch. This is deliberate, not an
    // oversight: reveal is intentionally permissionless, which means ANY
    // outside address — not just a cooperating keeper — can lock in a
    // single id from your pending batch before your batch transaction
    // lands. Assume that will be done with hostile intent, for free (gas
    // only, no funds extracted), for the sole purpose of making this call
    // revert and force the victim back to one-at-a-time reveals — i.e.
    // treat it as griefing, not a benign race. Reverting the whole batch
    // over one already-done id would hand that attack real teeth for zero
    // cost; skipping it costs the attacker their gas and achieves nothing.
    // `RequestNotFound`/`TooSoonToReveal` are NOT given the same treatment:
    // both depend only on values the caller supplied or global chain state,
    // not on anything a third party can selectively trigger against this
    // specific caller's batch, so they still revert the whole batch (a real
    // invalid id or genuinely early call is a caller-side bug/timing issue,
    // not an attack surface).
    function revealRandomnessBatch(
        uint[] calldata _requestIds
    ) external returns (uint64[] memory results) {
        results = new uint64[](_requestIds.length);
        for (uint i = 0; i < _requestIds.length; i++) {
            uint requestId = _requestIds[i];
            if (requestId == 0 || requestId > requestCount) revert RequestNotFound();
            if (requests[requestId].revealed) {
                results[i] = requests[requestId].result;
                continue;
            }
            results[i] = _revealRandomness(requestId);
        }
    }

    function _revealRandomness(uint _requestId) internal returns (uint64) {
        Request storage request = requests[_requestId];
        if (block.number <= request.blockNumber) revert TooSoonToReveal();
        // The real protection: block.prevrandao must have genuinely
        // changed since commit, not merely "some later block number was
        // reached" — see the header comment for why those aren't the same
        // thing on Base.
        if (block.prevrandao == request.prevRandaoAtCommit) revert TooSoonToReveal();

        // Truncates to 64 bits, same as before. Deliberately does NOT mix
        // in block.timestamp — see the header comment for why that would
        // weaken, not strengthen, this.
        uint64 result = uint64(
            uint(keccak256(abi.encodePacked(block.prevrandao, _requestId)))
        );

        request.revealed = true;
        request.result = result;

        emit RandomnessRevealed(_requestId, result);
        return result;
    }

    // Lets a caller (e.g. the frontend, before submitting constructShip)
    // check whether fulfillRandomRequest would currently succeed, instead
    // of guessing how many blocks to wait or eating a TooSoonToReveal
    // revert. True if already revealed (fulfillRandomRequest would just
    // return the cached result) or if the prevrandao window has rolled
    // over since commit. False for an unknown id or one that still needs
    // to reveal but isn't ready yet.
    function canFulfill(uint _requestId) external view returns (bool) {
        return _canFulfill(_requestId);
    }

    function canFulfillBatch(
        uint[] calldata _requestIds
    ) external view returns (bool) {
        for (uint i = 0; i < _requestIds.length; i++) {
            if (!_canFulfill(_requestIds[i])) return false;
        }
        return true;
    }

    function _canFulfill(uint _requestId) internal view returns (bool) {
        if (_requestId == 0 || _requestId > requestCount) return false;
        Request storage request = requests[_requestId];
        if (request.revealed) return true;
        return block.prevrandao != request.prevRandaoAtCommit;
    }

    // True if calling revealRandomnessBatch with this exact array would
    // currently succeed. An already-revealed id does NOT make this false —
    // revealRandomnessBatch tolerates (skips) those by design, see its
    // comment — so this only checks for a genuinely invalid id or one that
    // still needs to reveal but isn't ready yet. Poll this before calling
    // revealRandomnessBatch instead of guessing whether separately-minted
    // groups of ships (which may have different commit blocks) have all
    // cleared their wait.
    function canRevealBatch(
        uint[] calldata _requestIds
    ) external view returns (bool) {
        for (uint i = 0; i < _requestIds.length; i++) {
            uint requestId = _requestIds[i];
            if (requestId == 0 || requestId > requestCount) return false;
            Request storage request = requests[requestId];
            if (request.revealed) continue;
            if (block.prevrandao == request.prevRandaoAtCommit) return false;
        }
        return true;
    }
}
