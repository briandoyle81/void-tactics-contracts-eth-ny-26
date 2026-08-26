// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Commit-reveal randomness. `requestRandomness` commits to a request at the
// current block; `revealRandomness` can only reveal it once block.prevrandao
// has actually CHANGED from whatever it was at commit time — not merely
// once a later block number is reached. This distinction matters
// concretely on Base: block.prevrandao there is relayed from Ethereum L1's
// own RANDAO output, so it only updates roughly every 6 L2 blocks (~12s,
// matching L1's block time), not every L2 block (confirmed empirically
// against live Base Sepolia blocks — see docs/pre-audit.md's C-01/C-02
// remediation addendum). A plain "block.number > commit block" check would
// let a reveal land in a LATER L2 block that still shares the SAME,
// already-public prevrandao the requester could see before ever deciding
// whether to submit — checking for an actual change closes that regardless
// of how many L2 blocks a chain happens to share one prevrandao value
// across, present or future.
// `fulfillRandomRequest` — the name/shape consumers like Ships.sol have
// always called — reads back that already-revealed result, so a future
// provider swap (e.g. a real VRF) only needs to keep that one function's
// signature stable, not anything about how reveal actually works.
//
// This closes the "call the provider with a forged/arbitrary id to preview
// a result and revert if unfavorable" gap the previous mock version had
// (see docs/pre-audit.md C-01/C-02): every id must have genuinely been
// issued by requestRandomness, and each can only be revealed once.
//
// Residual risk: block.prevrandao on Base is relayed from L1 Ethereum's
// RANDAO, not chosen by Base's sequencer directly — but whoever proposes
// that L1 block still has the usual (much more limited, much more
// decentralized) L1 RANDAO-grinding options available to any L1 validator.
// Separately, Base's sequencer does still fully control block.timestamp
// and transaction ordering/inclusion, so a sequencer specifically
// targeting a single high-value reveal retains some influence there. A
// real VRF (e.g. Chainlink VRF) is the only way to remove trust assumptions
// like these entirely; this is a pragmatic middle ground given the current
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
    mapping(uint => Request) private requests;

    error RequestNotFound();
    error AlreadyRevealed();
    error TooSoonToReveal();
    error NotYetRevealed();

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

    // Reveal step: locks in a result for `_requestId`, permanently, the
    // first time this is called for it. Deliberately callable by anyone
    // (no access control) and deliberately separate from consumption (see
    // fulfillRandomRequest) — a consumer that computed-and-consumed in one
    // call could wrap itself in a revert-if-unfavorable check and simply
    // retry in a later block for a fresh roll, completely defeating the
    // delay below. Splitting reveal from consumption means that trick no
    // longer works: by the time a consumer can see the result (via a
    // later, separate call to fulfillRandomRequest), the reveal
    // transaction that produced it is already final and can't be un-mined
    // by the consumer reverting.
    function revealRandomness(uint _requestId) external returns (uint64) {
        if (_requestId == 0 || _requestId > requestCount) revert RequestNotFound();
        Request storage request = requests[_requestId];
        if (request.revealed) revert AlreadyRevealed();
        if (block.number <= request.blockNumber) revert TooSoonToReveal();
        // The real protection: block.prevrandao must have genuinely
        // changed since commit, not merely "some later block number was
        // reached" — see the header comment for why those aren't the same
        // thing on Base.
        if (block.prevrandao == request.prevRandaoAtCommit) revert TooSoonToReveal();

        // Truncates to 64 bits, same as before.
        uint64 result = uint64(
            uint(
                keccak256(
                    abi.encodePacked(block.prevrandao, block.timestamp, _requestId)
                )
            )
        );

        request.revealed = true;
        request.result = result;

        emit RandomnessRevealed(_requestId, result);
        return result;
    }

    // Consumption step — same name/shape Ships.sol has always called.
    // Reverts (rather than revealing inline) if revealRandomness hasn't
    // been called yet for this id — callers must do that first, in its
    // own transaction. See revealRandomness's comment for why.
    function fulfillRandomRequest(uint _requestId) external view returns (uint64) {
        if (_requestId == 0 || _requestId > requestCount) revert RequestNotFound();
        Request storage request = requests[_requestId];
        if (!request.revealed) revert NotYetRevealed();
        return request.result;
    }

    // Lets a caller (e.g. the frontend, before submitting revealRandomness)
    // check whether a reveal would currently succeed, instead of guessing
    // how many blocks to wait or eating a revert. False for an unknown or
    // already-revealed id, or one whose prevrandao window hasn't rolled
    // over yet — poll this rather than assuming any fixed block count.
    function canReveal(uint _requestId) external view returns (bool) {
        if (_requestId == 0 || _requestId > requestCount) return false;
        Request storage request = requests[_requestId];
        if (request.revealed) return false;
        return block.prevrandao != request.prevRandaoAtCommit;
    }
}
