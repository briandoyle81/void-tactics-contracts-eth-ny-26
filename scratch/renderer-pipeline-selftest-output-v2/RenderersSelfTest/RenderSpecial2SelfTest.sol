// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderSpecial2SelfTest {
    string private constant PART_1 = '<path d="M110 202 L113 203 L112 216 L110 219 L115 220 L117 226 L114 231 L111 231 L111 229 L113 229 L112 224 L106 222 L106 224 L109 225 L108 231 L104 235 L102 235 L102 233 L104 233 L104 227 L103 224 L99 226 L96 226 L96 230 L94 230 L94 224 L87 227 L87 230 L89 232 L87 233 L83 229 L84 225 L86 222 L91 221 L88 220 L88 218 L85 215 L90 215 L90 209 L92 208 L92 203 L95 203 L95 207 L99 205 L104 205 L108 207 Z M90 218 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M56 25 L59 25 L60 28 L67 29 L71 31 L72 27 L75 28 L74 33 L71 41 L74 42 L74 44 L76 44 L74 50 L73 52 L71 52 L72 45 L68 44 L69 51 L67 56 L64 56 L65 51 L63 47 L62 49 L60 49 L60 47 L56 47 L55 51 L57 52 L53 51 L53 49 L51 50 L51 54 L53 55 L50 55 L47 50 L50 45 L54 43 L54 37 L48 36 L48 31 L51 31 L53 33 L56 30 L55 26 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M95 45 L98 45 L98 50 L100 49 L101 46 L104 46 L103 52 L102 54 L106 53 L106 55 L102 58 L105 61 L106 64 L102 66 L101 61 L99 65 L96 65 L97 62 L93 62 L92 66 L91 61 L87 63 L86 65 L85 61 L86 59 L89 58 L90 56 L85 55 L84 50 L87 51 L87 54 L93 50 L96 50 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M92 203 L95 203 L95 207 L99 205 L104 205 L107 207 L107 210 L105 210 L105 218 L103 218 L103 220 L96 221 L97 219 L99 219 L98 212 L95 213 L98 215 L98 217 L93 216 L92 218 L85 216 L85 215 L90 215 L90 209 L92 208 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M72 27 L75 28 L74 33 L71 41 L74 42 L74 44 L76 44 L74 50 L73 52 L71 52 L72 45 L68 44 L69 48 L66 47 L66 44 L64 43 L66 38 L64 38 L64 40 L60 42 L61 35 L64 34 L65 36 L71 31 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M56 25 L59 25 L60 28 L67 29 L69 33 L64 37 L63 35 L55 35 L54 39 L54 37 L48 36 L48 31 L51 31 L53 33 L56 30 L55 26 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M84 50 L87 51 L87 54 L93 50 L100 51 L98 59 L91 59 L90 56 L85 55 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M110 202 L113 203 L112 216 L111 217 L105 217 L105 210 L107 210 L108 207 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M99 205 L104 205 L107 207 L107 210 L105 210 L105 218 L103 218 L103 220 L96 221 L97 219 L99 219 L100 215 L103 213 L101 209 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M95 45 L98 45 L98 50 L100 49 L101 46 L104 46 L103 52 L102 54 L106 53 L106 55 L99 57 L99 52 L96 51 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M108 220 L115 220 L117 226 L114 231 L111 231 L111 229 L113 229 L112 224 L108 223 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M103 222 L108 224 L109 228 L106 234 L102 235 L102 233 L104 233 L104 227 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M86 222 L93 222 L91 226 L87 227 L87 230 L89 232 L87 233 L83 229 L84 225 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M72 27 L75 28 L74 33 L71 41 L67 40 L67 36 L69 36 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M56 25 L59 25 L60 28 L67 29 L67 32 L55 32 L55 29 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M105 217 L110 217 L110 220 L108 220 L108 222 L105 223 L103 222 L103 224 L100 225 L101 220 L103 220 L103 218 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M57 31 L69 31 L67 35 L64 37 L63 35 L61 35 L61 33 L55 33 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M55 35 L61 35 L62 39 L60 39 L60 42 L54 41 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M89 58 L96 59 L97 62 L93 62 L92 66 L91 61 L87 63 L86 65 L85 61 L86 59 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M100 208 L103 209 L101 209 L104 214 L100 215 L98 212 L92 211 L94 209 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M95 50 L100 51 L98 59 L91 59 L95 57 L95 54 L93 52 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M64 44 L66 44 L66 47 L69 48 L68 54 L67 56 L64 56 L65 51 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M67 42 L74 42 L74 44 L76 44 L74 50 L73 52 L71 52 L72 45 L67 43 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M106 211 L112 211 L112 216 L107 217 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M50 45 L52 46 L51 54 L53 55 L50 55 L47 50 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M100 215 L104 216 L101 221 L96 221 L97 219 L99 219 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M93 222 L95 222 L95 224 L99 225 L96 226 L96 230 L94 230 L94 224 L92 223 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M64 38 L66 38 L65 43 L56 43 L56 42 L64 40 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M63 34 L64 37 L66 38 L64 38 L64 40 L60 42 L61 35 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M100 59 L104 59 L106 64 L102 66 L101 61 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M108 220 L114 220 L113 223 L108 223 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M92 211 L95 212 L98 215 L98 217 L93 216 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M53 46 L56 47 L55 51 L57 52 L53 51 L53 49 L51 49 L51 47 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M82 207 Z" style="fill:';
    string private constant PART_35 = ';"/>';
    string private constant COLOR_1 = 'hsl(22, 13%, 17%)';
    string private constant COLOR_2 = 'hsl(23, 11%, 14%)';
    string private constant COLOR_3 = 'hsl(40, 4%, 15%)';
    string private constant COLOR_4 = 'hsl(26, 38%, 28%)';
    string private constant COLOR_5 = 'hsl(24, 22%, 9%)';
    string private constant COLOR_6 = 'hsl(24, 44%, 28%)';
    string private constant COLOR_7 = 'hsl(26, 29%, 23%)';
    string private constant COLOR_8 = 'hsl(26, 16%, 17%)';
    string private constant COLOR_9 = 'hsl(25, 54%, 25%)';
    string private constant COLOR_10 = 'hsl(26, 14%, 23%)';
    string private constant COLOR_11 = 'hsl(36, 6%, 17%)';
    string private constant COLOR_12 = 'hsl(33, 10%, 21%)';
    string private constant COLOR_13 = 'hsl(27, 9%, 19%)';
    string private constant COLOR_14 = 'hsl(26, 14%, 22%)';
    string private constant COLOR_15 = 'hsl(25, 33%, 16%)';
    string private constant COLOR_16 = 'hsl(210, 4%, 10%)';
    string private constant COLOR_17 = 'hsl(29, 54%, 43%)';
    string private constant COLOR_18 = 'hsl(196, 34%, 34%)';
    string private constant COLOR_19 = 'hsl(30, 3%, 13%)';
    string private constant COLOR_20 = 'hsl(28, 49%, 51%)';
    string private constant COLOR_21 = 'hsl(27, 53%, 38%)';
    string private constant COLOR_22 = 'hsl(32, 13%, 22%)';
    string private constant COLOR_23 = 'hsl(26, 14%, 20%)';
    string private constant COLOR_24 = 'hsl(120, 1%, 35%)';
    string private constant COLOR_25 = 'hsl(24, 27%, 24%)';
    string private constant COLOR_26 = 'hsl(25, 53%, 35%)';
    string private constant COLOR_27 = 'hsl(120, 2%, 12%)';
    string private constant COLOR_28 = 'hsl(25, 53%, 31%)';
    string private constant COLOR_29 = 'hsl(25, 33%, 17%)';
    string private constant COLOR_30 = 'hsl(60, 2%, 21%)';
    string private constant COLOR_31 = 'hsl(180, 1%, 22%)';
    string private constant COLOR_32 = 'hsl(189, 21%, 38%)';
    string private constant COLOR_33 = 'hsl(300, 4%, 11%)';
    string private constant COLOR_34 = 'hsl(50, 3%, 35%)';

    function render(Ship memory ship) external pure returns (string memory) {
        string memory result = string.concat(
            PART_1,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_1) : COLOR_1,
            PART_2,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_2) : COLOR_2,
            PART_3,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_3) : COLOR_3,
            PART_4
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_4) : COLOR_4,
            PART_5,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_5) : COLOR_5,
            PART_6,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_6) : COLOR_6,
            PART_7,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_7) : COLOR_7
        );
        result = string.concat(
            result,
            PART_8,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_8) : COLOR_8,
            PART_9,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_9) : COLOR_9,
            PART_10,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_10) : COLOR_10,
            PART_11
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_11) : COLOR_11,
            PART_12,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_12) : COLOR_12,
            PART_13,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_13) : COLOR_13,
            PART_14,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_14) : COLOR_14
        );
        result = string.concat(
            result,
            PART_15,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_15) : COLOR_15,
            PART_16,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_16) : COLOR_16,
            PART_17,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_17) : COLOR_17,
            PART_18
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_18) : COLOR_18,
            PART_19,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_19) : COLOR_19,
            PART_20,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_20) : COLOR_20,
            PART_21,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_21) : COLOR_21
        );
        result = string.concat(
            result,
            PART_22,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_22) : COLOR_22,
            PART_23,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_23) : COLOR_23,
            PART_24,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_24) : COLOR_24,
            PART_25
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_25) : COLOR_25,
            PART_26,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_26) : COLOR_26,
            PART_27,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_27) : COLOR_27,
            PART_28,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_28) : COLOR_28
        );
        result = string.concat(
            result,
            PART_29,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_29) : COLOR_29,
            PART_30,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_30) : COLOR_30,
            PART_31,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_31) : COLOR_31,
            PART_32
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_32) : COLOR_32,
            PART_33,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_33) : COLOR_33,
            PART_34,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_34) : COLOR_34,
            PART_35
        );
        return result;
    }
}
