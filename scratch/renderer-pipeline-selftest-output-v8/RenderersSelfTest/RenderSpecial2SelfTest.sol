// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderSpecial2SelfTest {
    string private constant PART_1 = '<path d="M94 211 L99 212 L100 217 L97 220 L103 219 L105 217 L110 217 L110 219 L115 220 L117 226 L114 231 L111 231 L111 229 L113 229 L112 224 L106 222 L106 224 L109 225 L108 231 L104 235 L102 235 L102 233 L104 233 L104 227 L103 224 L99 226 L96 226 L96 230 L94 230 L94 224 L87 227 L87 230 L89 232 L87 233 L83 229 L84 225 L86 222 L91 221 L88 220 L88 218 L92 218 L92 213 L93 215 L97 216 L97 214 L94 213 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M72 27 L75 28 L74 33 L71 41 L74 42 L74 44 L76 44 L74 50 L73 52 L71 52 L72 45 L68 44 L69 51 L67 56 L64 56 L65 51 L62 46 L61 44 L66 42 L66 35 L71 31 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M95 45 L98 45 L98 50 L100 49 L101 46 L104 46 L103 52 L102 54 L106 53 L106 55 L99 57 L98 59 L91 59 L90 57 L85 55 L84 50 L87 51 L87 54 L93 50 L96 50 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M56 25 L59 25 L60 28 L67 29 L69 33 L64 37 L63 35 L55 35 L54 39 L54 37 L48 36 L48 31 L51 31 L53 33 L56 30 L55 26 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M92 203 L95 203 L95 207 L99 205 L104 205 L106 207 L105 218 L101 221 L96 221 L100 215 L103 213 L100 209 L93 208 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M98 54 L102 57 L106 63 L104 66 L102 65 L101 61 L99 65 L96 65 L97 62 L93 62 L92 66 L91 61 L87 63 L86 65 L85 61 L86 59 L91 57 L91 59 L98 59 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M63 34 L66 36 L66 42 L64 43 L56 43 L54 42 L55 35 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M55 41 L63 43 L62 49 L60 49 L60 47 L56 47 L55 51 L57 52 L53 51 L53 49 L51 50 L51 54 L53 55 L50 55 L47 50 L50 45 L54 43 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M110 202 L113 203 L112 216 L111 217 L105 217 L105 210 L106 207 L108 207 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M92 208 L103 208 L101 209 L104 214 L100 215 L98 212 L95 213 L97 214 L97 216 L93 215 L93 219 L86 217 L85 215 L90 215 L90 209 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M82 207 Z" style="fill:';
    string private constant PART_12 = ';"/>';
    string private constant COLOR_1 = 'hsl(30, 7%, 17%)';
    string private constant COLOR_2 = 'hsl(25, 13%, 18%)';
    string private constant COLOR_3 = 'hsl(27, 31%, 27%)';
    string private constant COLOR_4 = 'hsl(27, 44%, 29%)';
    string private constant COLOR_5 = 'hsl(26, 51%, 28%)';
    string private constant COLOR_6 = 'hsl(30, 3%, 15%)';
    string private constant COLOR_7 = 'hsl(90, 4%, 29%)';
    string private constant COLOR_8 = 'hsl(25, 20%, 17%)';
    string private constant COLOR_9 = 'hsl(30, 10%, 23%)';
    string private constant COLOR_10 = 'hsl(30, 32%, 40%)';
    string private constant COLOR_11 = 'hsl(180, 1%, 36%)';

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
            PART_12
        );
        return result;
    }
}
