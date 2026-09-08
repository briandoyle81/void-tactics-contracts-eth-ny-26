// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderSpecial2SelfTest {
    string private constant PART_1 = '<path d="M110 202 L113 203 L112 216 L110 219 L115 220 L117 226 L114 231 L111 231 L111 229 L113 229 L112 224 L106 222 L106 224 L109 225 L108 231 L104 235 L102 235 L102 233 L104 233 L104 227 L103 224 L99 226 L96 226 L96 230 L94 230 L94 224 L87 227 L87 230 L89 232 L87 233 L83 229 L84 225 L86 222 L91 221 L88 220 L88 218 L85 215 L90 215 L90 209 L92 208 L92 203 L95 203 L95 207 L99 205 L104 205 L108 207 Z M90 218 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M56 25 L59 25 L60 28 L67 29 L71 31 L72 27 L75 28 L74 33 L71 41 L74 42 L74 44 L76 44 L74 50 L73 52 L71 52 L72 45 L68 44 L69 51 L67 56 L64 56 L65 51 L63 47 L62 49 L60 49 L60 47 L56 47 L55 51 L57 52 L53 51 L53 49 L51 50 L51 54 L53 55 L50 55 L47 50 L50 45 L54 43 L54 37 L48 36 L48 31 L51 31 L53 33 L56 30 L55 26 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M95 45 L98 45 L98 50 L100 49 L101 46 L104 46 L103 52 L102 54 L106 53 L106 55 L102 58 L105 61 L106 64 L102 66 L101 61 L99 65 L96 65 L97 62 L93 62 L92 66 L91 61 L87 63 L86 65 L85 61 L86 59 L89 58 L90 56 L85 55 L84 50 L87 51 L87 54 L93 50 L96 50 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M72 27 L75 28 L74 33 L71 41 L74 42 L74 44 L76 44 L74 50 L73 52 L71 52 L72 45 L68 44 L69 51 L67 56 L64 56 L65 51 L63 47 L62 49 L60 49 L60 47 L58 47 L57 43 L65 42 L66 38 L64 38 L64 40 L60 42 L61 35 L64 34 L65 36 L71 31 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M92 203 L95 203 L95 207 L99 205 L104 205 L107 207 L107 210 L105 210 L105 218 L103 218 L103 220 L96 221 L97 219 L99 219 L98 212 L95 213 L98 215 L98 217 L93 216 L92 218 L85 216 L85 215 L90 215 L90 209 L92 208 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M55 35 L61 35 L62 39 L60 39 L61 41 L64 40 L64 38 L66 38 L65 43 L57 43 L56 47 L55 51 L57 52 L53 51 L53 49 L51 50 L51 54 L53 55 L50 55 L47 50 L50 45 L54 43 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M84 50 L87 51 L87 54 L93 50 L100 51 L98 59 L91 59 L90 56 L85 55 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M65 42 L70 43 L68 44 L69 51 L67 56 L64 56 L65 51 L63 47 L62 49 L60 49 L60 47 L58 47 L57 43 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M110 202 L113 203 L112 216 L111 217 L105 217 L105 210 L107 210 L108 207 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M99 205 L104 205 L107 207 L107 210 L105 210 L105 218 L103 218 L103 220 L96 221 L97 219 L99 219 L100 215 L103 213 L101 209 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M95 45 L98 45 L98 50 L100 49 L101 46 L104 46 L103 52 L102 54 L106 53 L106 55 L99 57 L99 52 L96 51 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M108 220 L115 220 L117 226 L114 231 L111 231 L111 229 L113 229 L112 224 L108 223 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M86 222 L93 222 L91 226 L87 227 L87 230 L89 232 L87 233 L83 229 L84 225 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M72 27 L75 28 L74 33 L71 41 L67 40 L67 36 L69 36 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M103 222 L108 224 L109 228 L106 234 L102 235 L102 233 L104 233 L104 227 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M105 217 L110 217 L110 220 L108 220 L108 222 L100 225 L101 220 L103 220 L103 218 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M56 25 L59 25 L60 28 L67 29 L67 32 L55 32 L55 29 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M57 31 L69 31 L67 35 L64 37 L63 35 L61 35 L61 33 L55 33 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M55 35 L61 35 L62 39 L60 39 L60 42 L54 41 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M89 58 L96 59 L97 62 L93 62 L92 66 L91 61 L87 63 L86 65 L85 61 L86 59 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M100 208 L103 209 L101 209 L104 214 L100 215 L98 212 L92 211 L94 209 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M95 50 L100 51 L98 59 L91 59 L95 57 L95 54 L93 52 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M64 44 L66 44 L66 47 L69 48 L68 54 L67 56 L64 56 L65 51 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M67 42 L74 42 L74 44 L76 44 L74 50 L73 52 L71 52 L72 45 L67 43 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M106 211 L112 211 L112 216 L107 217 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M50 45 L52 46 L51 54 L53 55 L50 55 L47 50 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M100 215 L104 216 L101 221 L96 221 L97 219 L99 219 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M93 222 L95 222 L95 224 L99 225 L96 226 L96 230 L94 230 L94 224 L92 223 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M64 38 L66 38 L65 43 L56 43 L56 42 L64 40 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M92 221 L101 221 L100 225 L95 224 L95 222 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M100 59 L104 59 L106 64 L102 66 L101 61 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M63 34 L64 34 L64 40 L60 42 L61 35 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M108 220 L114 220 L113 223 L108 223 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M101 220 L107 221 L105 223 L100 225 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M92 211 L95 212 L98 215 L98 217 L93 216 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M53 46 L56 47 L55 51 L57 52 L53 51 L53 49 L51 49 L51 47 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M58 44 L62 45 L62 49 L60 49 L60 47 L58 47 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M58 36 L61 36 L62 39 L57 40 Z" style="fill:';
    string private constant PART_39 = ';"/><path d="M67 31 L69 31 L67 35 L64 37 L64 33 Z" style="fill:';
    string private constant PART_40 = ';"/><path d="M104 230 L107 230 L106 234 L102 235 L102 233 L104 233 Z" style="fill:';
    string private constant PART_41 = ';"/><path d="M83 227 L86 228 L89 232 L87 233 L83 229 Z" style="fill:';
    string private constant PART_42 = ';"/><path d="M110 202 L112 202 L112 207 L109 207 Z" style="fill:';
    string private constant PART_43 = ';"/><path d="M66 51 L69 52 L67 56 L64 56 Z" style="fill:';
    string private constant PART_44 = ';"/><path d="M61 29 L67 29 L67 32 L61 31 Z" style="fill:';
    string private constant PART_45 = ';"/><path d="M114 220 L116 224 L113 228 L112 223 Z" style="fill:';
    string private constant PART_46 = ';"/><path d="M92 203 L95 203 L96 208 L93 208 Z" style="fill:';
    string private constant PART_47 = ';"/><path d="M93 50 L95 51 L95 53 L95 56 L92 55 Z" style="fill:';
    string private constant PART_48 = ';"/><path d="M67 36 L71 38 L70 41 L67 40 Z" style="fill:';
    string private constant PART_49 = ';"/><path d="M99 205 L104 205 L105 207 L101 208 Z" style="fill:';
    string private constant PART_50 = ';"/><path d="M94 211 L98 211 L98 214 L94 213 Z" style="fill:';
    string private constant PART_51 = ';"/><path d="M72 27 L75 28 L75 31 L72 31 Z" style="fill:';
    string private constant PART_52 = ';"/><path d="M97 206 L101 207 L100 209 L97 209 Z" style="fill:';
    string private constant PART_53 = ';"/><path d="M56 25 L58 25 L57 29 L55 29 Z" style="fill:';
    string private constant PART_54 = ';"/><path d="M86 224 L87 227 L85 228 L83 226 Z" style="fill:';
    string private constant PART_55 = ';"/><path d="M98 212 L100 214 L100 217 L98 217 L97 214 Z" style="fill:';
    string private constant PART_56 = ';"/><path d="M95 214 L98 215 L98 217 L95 217 Z" style="fill:';
    string private constant PART_57 = ';"/><path d="M95 50 L98 52 L93 53 Z" style="fill:';
    string private constant PART_58 = ';"/><path d="M69 35 L72 36 L71 39 Z" style="fill:';
    string private constant PART_59 = ';"/><path d="M55 40 L57 42 L54 43 Z" style="fill:';
    string private constant PART_60 = ';"/><path d="M82 207 Z" style="fill:';
    string private constant PART_61 = ';"/>';
    string private constant COLOR_1 = 'hsl(25, 29%, 16%)';
    string private constant COLOR_2 = 'hsl(24, 44%, 28%)';
    string private constant COLOR_3 = 'hsl(40, 4%, 15%)';
    string private constant COLOR_4 = 'hsl(21, 36%, 9%)';
    string private constant COLOR_5 = 'hsl(26, 35%, 30%)';
    string private constant COLOR_6 = 'hsl(24, 7%, 14%)';
    string private constant COLOR_7 = 'hsl(24, 33%, 22%)';
    string private constant COLOR_8 = 'hsl(0, 0%, 10%)';
    string private constant COLOR_9 = 'hsl(0, 1%, 14%)';
    string private constant COLOR_10 = 'hsl(25, 54%, 27%)';
    string private constant COLOR_11 = 'hsl(26, 14%, 23%)';
    string private constant COLOR_12 = 'hsl(60, 1%, 20%)';
    string private constant COLOR_13 = 'hsl(20, 9%, 20%)';
    string private constant COLOR_14 = 'hsl(60, 1%, 18%)';
    string private constant COLOR_15 = 'hsl(26, 15%, 20%)';
    string private constant COLOR_16 = 'hsl(220, 5%, 12%)';
    string private constant COLOR_17 = 'hsl(30, 7%, 16%)';
    string private constant COLOR_18 = 'hsl(30, 56%, 44%)';
    string private constant COLOR_19 = 'hsl(208, 11%, 24%)';
    string private constant COLOR_20 = 'hsl(30, 3%, 13%)';
    string private constant COLOR_21 = 'hsl(28, 49%, 51%)';
    string private constant COLOR_22 = 'hsl(26, 57%, 33%)';
    string private constant COLOR_23 = 'hsl(28, 19%, 26%)';
    string private constant COLOR_24 = 'hsl(26, 14%, 20%)';
    string private constant COLOR_25 = 'hsl(120, 1%, 35%)';
    string private constant COLOR_26 = 'hsl(24, 27%, 24%)';
    string private constant COLOR_27 = 'hsl(25, 53%, 35%)';
    string private constant COLOR_28 = 'hsl(120, 2%, 12%)';
    string private constant COLOR_29 = 'hsl(25, 53%, 31%)';
    string private constant COLOR_30 = 'hsl(300, 1%, 17%)';
    string private constant COLOR_31 = 'hsl(60, 2%, 21%)';
    string private constant COLOR_32 = 'hsl(25, 29%, 18%)';
    string private constant COLOR_33 = 'hsl(180, 1%, 22%)';
    string private constant COLOR_34 = 'hsl(180, 3%, 8%)';
    string private constant COLOR_35 = 'hsl(33, 12%, 36%)';
    string private constant COLOR_36 = 'hsl(300, 4%, 11%)';
    string private constant COLOR_37 = 'hsl(24, 11%, 18%)';
    string private constant COLOR_38 = 'hsl(194, 54%, 51%)';
    string private constant COLOR_39 = 'hsl(26, 53%, 40%)';
    string private constant COLOR_40 = 'hsl(120, 1%, 23%)';
    string private constant COLOR_41 = 'hsl(30, 2%, 22%)';
    string private constant COLOR_42 = 'hsl(25, 37%, 26%)';
    string private constant COLOR_43 = 'hsl(60, 2%, 17%)';
    string private constant COLOR_44 = 'hsl(23, 84%, 10%)';
    string private constant COLOR_45 = 'hsl(27, 15%, 14%)';
    string private constant COLOR_46 = 'hsl(24, 27%, 18%)';
    string private constant COLOR_47 = 'hsl(32, 17%, 28%)';
    string private constant COLOR_48 = 'hsl(38, 12%, 17%)';
    string private constant COLOR_49 = 'hsl(25, 54%, 20%)';
    string private constant COLOR_50 = 'hsl(207, 8%, 21%)';
    string private constant COLOR_51 = 'hsl(24, 27%, 27%)';
    string private constant COLOR_52 = 'hsl(28, 55%, 36%)';
    string private constant COLOR_53 = 'hsl(28, 32%, 23%)';
    string private constant COLOR_54 = 'hsl(24, 27%, 15%)';
    string private constant COLOR_55 = 'hsl(20, 7%, 17%)';
    string private constant COLOR_56 = 'hsl(195, 56%, 40%)';
    string private constant COLOR_57 = 'hsl(29, 56%, 55%)';
    string private constant COLOR_58 = 'hsl(32, 13%, 29%)';
    string private constant COLOR_59 = 'hsl(23, 52%, 16%)';
    string private constant COLOR_60 = 'hsl(50, 3%, 35%)';

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
            PART_35,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_35) : COLOR_35
        );
        result = string.concat(
            result,
            PART_36,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_36) : COLOR_36,
            PART_37,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_37) : COLOR_37,
            PART_38,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_38) : COLOR_38,
            PART_39
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_39) : COLOR_39,
            PART_40,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_40) : COLOR_40,
            PART_41,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_41) : COLOR_41,
            PART_42,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_42) : COLOR_42
        );
        result = string.concat(
            result,
            PART_43,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_43) : COLOR_43,
            PART_44,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_44) : COLOR_44,
            PART_45,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_45) : COLOR_45,
            PART_46
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_46) : COLOR_46,
            PART_47,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_47) : COLOR_47,
            PART_48,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_48) : COLOR_48,
            PART_49,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_49) : COLOR_49
        );
        result = string.concat(
            result,
            PART_50,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_50) : COLOR_50,
            PART_51,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_51) : COLOR_51,
            PART_52,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_52) : COLOR_52,
            PART_53
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_53) : COLOR_53,
            PART_54,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_54) : COLOR_54,
            PART_55,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_55) : COLOR_55,
            PART_56,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_56) : COLOR_56
        );
        result = string.concat(
            result,
            PART_57,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_57) : COLOR_57,
            PART_58,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_58) : COLOR_58,
            PART_59,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_59) : COLOR_59,
            PART_60
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_60) : COLOR_60,
            PART_61
        );
        return result;
    }
}
