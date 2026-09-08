// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderSpecial2SelfTest {
    string private constant PART_1 = '<path d="M69 39L64 43L68 47L69 47L67 44L69 43L66 44L66 42L69 41L73 42L71 40ZM55 43L54 44L55 46L58 45L58 43ZM53 46L51 48L52 49L54 47ZM48 52L49 54L51 53L51 52ZM101 58L97 60L100 60L103 58ZM91 59L93 62L95 62L92 59ZM112 203L112 207L113 204ZM100 205L102 206L103 205ZM90 213L90 216L89 219L91 217ZM104 219L100 222L100 225L102 221L104 222L104 219ZM96 221L98 222L99 221Z" fill-rule="evenodd" style="fill:';
    string private constant PART_2 = ';"/><path d="M58 29L58 31L60 31L59 29ZM67 38L67 40L70 39L70 38ZM59 46L62 49L62 48L61 46ZM72 47L72 49L74 50L73 47ZM47 50L48 52L50 52L50 50ZM101 56L98 58L100 58L101 56ZM101 59L101 61L104 61L104 60ZM108 209L107 211L108 212L109 209ZM105 219L104 221L106 221L106 219ZM114 220L114 224L115 221ZM105 222L102 224L105 226L105 222ZM109 227L106 229L108 229L109 227Z" fill-rule="evenodd" style="fill:';
    string private constant PART_3 = ';"/><path d="M53 33L52 37L54 37L54 33ZM56 43L55 45L57 45L54 47L56 46L57 43ZM63 43L62 45L64 47L64 43ZM99 53L98 56L99 57L100 53ZM101 57L98 59L100 59L101 57ZM112 206L110 210L113 207L113 206ZM109 210L109 212L111 212L111 210ZM105 217L104 219L105 220L105 218L108 222L110 219L107 220L107 218L110 217ZM95 221L92 224L94 224L96 221ZM102 221L101 223L103 223L103 221ZM86 222L86 226L88 224Z" fill-rule="evenodd" style="fill:';
    string private constant PART_4 = ';"/><path d="M51 33L52 36L53 35ZM71 34L70 36L72 37L72 34ZM58 44L58 45L62 47L61 45ZM93 60L95 61L98 60ZM109 209L108 211L109 212L110 209ZM105 210L105 214L106 211ZM89 222L91 223L90 225L92 224L91 222Z" fill-rule="evenodd" style="fill:';
    string private constant PART_5 = ';"/><path d="M96 211L96 212L100 215L97 211ZM110 213L110 214L109 217L111 215ZM99 216L96 218L98 218L99 216ZM112 220L112 222L114 225L114 221ZM115 224L114 226L116 226L116 224Z" fill-rule="evenodd" style="fill:';
    string private constant PART_6 = ';"/><path d="M63 29L65 30L66 29ZM90 210L90 214L91 211ZM104 221L105 223L107 222L107 221ZM92 224L89 226L91 226L92 224Z" fill-rule="evenodd" style="fill:';
    string private constant PART_7 = ';"/><path d="M63 37L63 41L64 38ZM90 52L91 56L92 54ZM103 211L104 214L105 214L105 211ZM92 217L94 221L96 221L98 218L95 219ZM102 217L102 220L104 219L103 217ZM87 224L84 226L86 226L87 224Z" fill-rule="evenodd" style="fill:';
    string private constant PART_8 = ';"/><path d="M100 53L100 55L102 56L103 54L101 55ZM104 53L104 55L106 54L106 53ZM112 211L109 213L110 214L112 211Z" fill-rule="evenodd" style="fill:';
    string private constant PART_9 = ';"/><path d="M61 29L60 31L67 31L63 29ZM57 34L59 35L62 34ZM66 37L66 42L67 39ZM53 45L50 47L52 47L53 45ZM93 219L92 221L94 221L94 219Z" fill-rule="evenodd" style="fill:';
    string private constant PART_10 = ';"/><path d="M49 31L50 33L51 33L51 31ZM95 57L97 59L98 58ZM103 210L102 212L104 213L104 210ZM104 216L103 218L105 218L105 216ZM109 226L106 228L108 228L109 226Z" fill-rule="evenodd" style="fill:';
    string private constant PART_11 = ';"/><path d="M60 31L62 32L65 31ZM92 58L94 59L97 58ZM100 218L99 220L101 220L101 218Z" fill-rule="evenodd" style="fill:';
    string private constant PART_12 = ';"/><path d="M63 40L62 42L63 43L64 42ZM95 53L96 57L97 55ZM102 213L103 216L104 215Z" fill-rule="evenodd" style="fill:';
    string private constant PART_13 = ';"/><path d="M111 213L111 217L112 214ZM108 214L107 216L109 216L109 214Z" fill-rule="evenodd" style="fill:';
    string private constant PART_14 = ';"/><path d="M103 206L105 208L106 207Z" fill-rule="evenodd" style="fill:';
    string private constant PART_15 = ';"/><path d="M61 32L61 34L63 34L62 32ZM99 207L96 209L100 208L101 207ZM98 210L99 213L102 214L102 211Z" fill-rule="evenodd" style="fill:';
    string private constant PART_16 = ';"/><path d="M90 54L90 58L91 55Z" fill-rule="evenodd" style="fill:';
    string private constant PART_17 = ';"/><path d="M91 214L91 218L92 215Z" fill-rule="evenodd" style="fill:';
    string private constant PART_18 = ';"/><path d="M64 31L64 32L67 33L66 31ZM94 51L93 53L97 52L97 51Z" fill-rule="evenodd" style="fill:';
    string private constant PART_19 = ';"/><path d="M56 32L58 33L61 32ZM94 209L93 211L96 210L96 209Z" fill-rule="evenodd" style="fill:';
    string private constant PART_20 = ';"/><path d="M56 39L58 41L60 40ZM92 55L94 57L95 56Z" fill-rule="evenodd" style="fill:';
    string private constant PART_21 = ';"/><path d="M58 37L58 39L60 39L60 37Z" fill-rule="evenodd" style="fill:';
    string private constant PART_22 = ';"/><path d="M61 38L58 40L60 40L61 38Z" fill-rule="evenodd" style="fill:';
    string private constant PART_23 = ';"/>';
    string private constant COLOR_1 = 'hsl(30, 5%, 8%)';
    string private constant COLOR_2 = 'hsl(30, 5%, 16%)';
    string private constant COLOR_3 = 'hsl(0, 0%, 12%)';
    string private constant COLOR_4 = 'hsl(60, 1%, 19%)';
    string private constant COLOR_5 = 'hsl(0, 0%, 24%)';
    string private constant COLOR_6 = 'hsl(15, 25%, 3%)';
    string private constant COLOR_7 = 'hsl(24, 60%, 18%)';
    string private constant COLOR_8 = 'hsl(120, 1%, 28%)';
    string private constant COLOR_9 = 'hsl(25, 74%, 10%)';
    string private constant COLOR_10 = 'hsl(25, 44%, 25%)';
    string private constant COLOR_11 = 'hsl(26, 64%, 36%)';
    string private constant COLOR_12 = 'hsl(25, 59%, 31%)';
    string private constant COLOR_13 = 'hsl(180, 1%, 36%)';
    string private constant COLOR_14 = 'hsl(25, 45%, 35%)';
    string private constant COLOR_15 = 'hsl(28, 59%, 43%)';
    string private constant COLOR_16 = 'hsl(25, 42%, 43%)';
    string private constant COLOR_17 = 'hsl(25, 41%, 51%)';
    string private constant COLOR_18 = 'hsl(28, 56%, 54%)';
    string private constant COLOR_19 = 'hsl(31, 75%, 63%)';
    string private constant COLOR_20 = 'hsl(210, 38%, 18%)';
    string private constant COLOR_21 = 'hsl(185, 98%, 65%)';
    string private constant COLOR_22 = 'hsl(198, 73%, 39%)';

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
            PART_23
        );
        return result;
    }
}
