# Single-Player Frontend Integration

What the contracts side just finished, and what the frontend needs to build against it. Single-player reuses the exact same `Lobbies`/`Game` flow as PvP — the only new pieces are `SinglePlayerMatch.sol` (an on-chain AI opponent) and `AIEncounters.sol` (admin-curated AI fleet content). If you already have PvP working, most of this is additive, not a rewrite.

## The mental model

A human plays single-player by creating a `Lobbies` lobby *reserved for `SinglePlayerMatch`'s address* instead of an open lobby or a specific human opponent. `SinglePlayerMatch` then plays the joiner side through the same `Lobbies`/`Game` machinery a human joiner would use — same fees, same fleet-creation flow, same `Game.moveShip` for every ship move. There is no separate "single-player game" data structure; it's a regular `Game` session where one side happens to be a contract instead of a wallet.

The one genuinely new interaction pattern: **`SinglePlayerMatch.takeAITurn` moves exactly one AI ship per call.** The frontend is responsible for calling it repeatedly — once per AI ship that still needs to move this round — until the turn actually returns to the player. This mirrors how the player already fires one `moveShip` transaction per ship; the AI just needs the same thing done on its behalf, one call at a time, instead of doing its whole round in one contract call.

## Full flow, in order

1. **Human reserves a lobby for the AI.**
   ```
   Lobbies.createLobby(
     costLimit,
     turnTime,
     creatorGoesFirst,   // true — human is creator
     selectedMapId,       // see "which map" below
     maxScore,
     reservedJoiner: <SinglePlayerMatch address>
   )
   ```
   Same fees/limits as reserving a specific human opponent — nothing special here.

2. **Accept the match.** Anyone can trigger this (no funds/state at risk):
   ```
   SinglePlayerMatch.acceptMatch(lobbyId)  // -> Lobbies.acceptGame(lobbyId)
   ```

3. **Human creates their fleet**, same as PvP:
   ```
   Lobbies.createFleet(lobbyId, shipIds, startingPositions)
   ```

4. **AI fleet gets built.** Anyone can trigger this too:
   ```
   SinglePlayerMatch.setupAIFleet(lobbyId)
   ```
   This mints a fresh AI fleet from the selected map's configured `AIEncounters` placements and calls `Lobbies.createFleet` on the AI's behalf. **Fleet size is dynamic** — it's whatever the map's admin configured (1 to 8 ships), not a fixed number. Don't assume 3.

   Reverts with `NoAIPlacementsConfigured` if the selected map has no AI content configured (including `selectedMapId == 0`). See "which map" below — right now only map id `1` is guaranteed to work.

5. **Game starts automatically** once both fleets are set (`Lobbies` calls `SinglePlayerMatch.startGame`, which forwards to core `Game.startGame`). Poll `Game.getGame(lobbyId)` (the game id == the lobby id) to know when this has happened — `metadata.ended == false` and `turnState.currentTurn` will be set.

6. **Turn loop.** On the human's turn:
   ```
   Game.moveShip(gameId, shipId, destRow, destCol, actionType, actionTarget)
   ```
   exactly like PvP. After it confirms, check `Game.getGame(gameId).turnState.currentTurn` — if it's now `SinglePlayerMatch`'s address, the AI needs to act.

7. **AI turn loop — the part that's new:**
   ```js
   while (true) {
     const game = await Game.read.getGame([gameId]);
     if (game.metadata.ended) break;
     if (game.turnState.currentTurn !== singlePlayerMatchAddress) break; // back to human
     await SinglePlayerMatch.write.takeAITurn([gameId]);
   }
   ```
   Each `takeAITurn` call moves exactly one AI ship and returns. If the AI's side has more unmoved ships than the human's (common with the dynamic fleet sizes above), the turn *stays* with the AI across several consecutive `takeAITurn` calls before coming back to the human — same alternation rule PvP already has (a side keeps the turn across consecutive ship-moves once the other side runs out of unmoved ships for the round). Bound the loop defensively (e.g. cap at ~10 iterations) as a safety net — it should never actually run that long since `AIEncounters.MAX_PLACEMENTS_PER_MAP = 8`.

   `takeAITurn` is permissionless — anyone can call it, same as `acceptMatch`/`setupAIFleet`. It reverts with `NotAITurn` if called when it isn't actually the AI's turn, and `GameEnded` if the game already ended — check `currentTurn`/`ended` before calling rather than relying on catching those.

   Listen for `SinglePlayerMatch.AITurnTaken(gameId, shipId, actionType, targetShipId)` if you want to show what the AI did (e.g. animate a shot) — it fires once per `takeAITurn` call. `actionType` is the same `ActionType` enum PvP already uses: `Pass=0, Shoot=1, Retreat=2, Assist=3(unused), Special=4, FactionAbility=5`.

   The AI never gets "stuck" from your side's perspective — `_takeShipTurn` wraps its move in a revert-safety net internally, so even if the AI's heuristic decides on something that turns out illegal, that one ship just Passes instead of the transaction reverting. You don't need extra error handling for "the AI made a bad move."

8. **Repeat 6-7** until `Game.getGame(gameId).metadata.ended`.

## Which map to use

A fresh deployment now seeds exactly one usable single-player map: **id `1`**, with one AI ship per behavior archetype (Grunt/Aggressor/Sniper/Support/Turtle/Rammer) and a single scoring tile. This is placeholder content, not final game design — more maps will get added over time by whoever holds map-editor rights.

Don't hardcode `1` forever. Before offering a map as a single-player option, check:
```
AIEncounters.mapHasPlacements(mapId)  // bool
```
Any map where this is false will make `setupAIFleet` revert. If you want to list all AI-configured maps, `AIEncounters.getMapPlacements(mapId)` returns the full `(positions[], configIds[])` for a given map — combine with `Maps.getAllPresetMapIds()` and filter.

## What's *not* new for you

- Combat, movement, scoring, round/turn advancement, win conditions — all identical to PvP, same `Game.sol` code path. If your PvP UI already renders these correctly, single-player renders the same way once you're driving the human side.
- `Game.getGame`, `Game.getShipAttributes`, `Game.getShipPosition` — same read APIs, same shapes.
- Ship rendering — AI ships are real `Ship` NFTs (owned by the `SinglePlayerMatch` contract), same metadata/image pipeline as any other ship.

## New contract surface, for reference

- `SinglePlayerMatch.acceptMatch(lobbyId)`, `.setupAIFleet(lobbyId)`, `.takeAITurn(gameId)` — all permissionless.
- `SinglePlayerMatch.aiShipInfo(shipId)` → `{archetype, variant, special}` if you ever want to show "what kind of AI ship is this" in the UI (e.g. an icon per archetype).
- `Types.Archetype` enum: `Grunt=0, Aggressor=1, Sniper=2, Support=3, Turtle=4, Rammer=5`.
- `AIEncounters.getAIShipConfig(configId)` / `getAllAIShipConfigs()` — read-only, useful if you want to preview a map's AI fleet before a match starts.

## Open item on our end

Real single-player map/encounter content beyond the one seeded starter map is still to be designed — flag if you need more than one playable map before this ships to real users.
