// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderFore2SelfTest {
    string private constant PART_1 = '<path d="M52 99 L86 99 L89 103 L89 106 L91 106 L91 116 L87 120 L85 120 L84 149 L82 152 L81 159 L79 159 L77 163 L73 164 L41 164 L37 161 L37 159 L35 159 L31 154 L9 151 L4 151 L2 149 L2 146 L9 145 L13 145 L13 132 L10 128 L10 120 L13 119 L15 115 L23 113 L31 108 L44 108 L44 106 L47 103 L49 103 L49 101 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M32 109 L89 109 L87 113 L82 119 L81 145 L56 145 L56 141 L62 139 L64 128 L69 126 L70 124 L65 124 L63 122 L58 123 L55 121 L43 121 L43 123 L37 126 L36 125 L36 135 L41 137 L41 139 L48 141 L51 141 L55 141 L55 145 L33 145 L31 143 L30 128 L27 125 L16 125 L16 121 L14 121 L14 119 L19 119 L19 117 L24 116 L28 112 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M52 99 L86 99 L89 103 L89 106 L91 106 L91 116 L87 120 L85 120 L84 149 L82 152 L79 152 L80 147 L81 119 L89 109 L32 110 L27 114 L25 114 L24 117 L19 117 L19 119 L14 119 L14 121 L16 121 L16 125 L28 124 L28 126 L18 127 L24 128 L24 135 L22 137 L15 137 L14 132 L10 128 L10 120 L13 119 L15 115 L23 113 L31 108 L44 108 L44 106 L47 103 L49 103 L49 101 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M55 119 L58 122 L62 123 L63 120 L67 124 L68 122 L68 124 L70 124 L69 127 L65 128 L64 136 L63 140 L56 141 L55 145 L55 141 L49 142 L48 144 L48 141 L43 140 L41 139 L41 137 L36 135 L35 124 L38 125 L43 123 L43 121 L55 121 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M31 110 L39 111 L72 111 L74 112 L74 117 L34 117 L31 121 L29 121 L29 126 L27 125 L16 125 L16 121 L14 121 L14 119 L19 119 L19 117 L24 116 L28 112 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M32 109 L89 109 L87 113 L82 119 L80 128 L78 126 L71 125 L69 120 L64 119 L64 118 L74 118 L74 112 L38 112 L32 110 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M43 123 L57 123 L59 124 L59 126 L55 127 L60 127 L60 133 L55 134 L44 134 L44 136 L54 136 L54 137 L43 138 L40 135 L40 126 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M18 126 L29 126 L31 128 L31 143 L30 143 L29 135 L24 137 L23 139 L15 139 L16 144 L19 144 L19 146 L16 146 L16 151 L4 151 L2 149 L2 146 L9 145 L13 145 L14 130 L15 130 L15 137 L22 136 L23 135 L24 128 L17 128 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M24 112 L25 112 L25 117 L19 117 L19 119 L14 119 L14 121 L16 121 L16 125 L28 124 L28 126 L18 127 L24 128 L24 135 L22 137 L15 137 L14 132 L10 128 L10 120 L13 119 L15 115 L23 113 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M31 110 L38 111 L37 116 L34 117 L31 121 L29 121 L29 126 L27 125 L16 125 L16 121 L14 121 L14 119 L19 119 L19 117 L24 116 L28 112 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M39 152 L81 152 L81 159 L79 159 L77 163 L73 164 L64 164 L68 163 L67 155 L65 154 L40 154 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M53 100 L83 100 L81 102 L77 102 L76 104 L60 106 L56 108 L55 107 L46 108 L52 101 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M52 99 L85 99 L85 100 L53 101 L48 107 L55 106 L57 105 L58 107 L60 105 L79 105 L79 106 L61 106 L61 108 L78 108 L78 109 L32 110 L27 114 L25 114 L25 112 L31 108 L44 108 L44 106 L47 103 L49 103 L49 101 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M25 135 L29 135 L30 144 L31 148 L29 150 L22 151 L21 145 L20 148 L16 148 L16 146 L19 146 L19 144 L16 144 L15 139 L23 139 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M85 99 L89 103 L89 109 L78 109 L61 108 L61 106 L72 105 L76 104 L77 101 L83 100 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M32 109 L89 109 L88 112 L75 111 L75 116 L74 112 L38 112 L32 110 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M45 153 L65 153 L68 155 L68 158 L44 158 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M55 119 L62 125 L63 127 L61 134 L56 138 L48 138 L44 136 L44 134 L60 133 L60 129 L57 128 L55 127 L56 125 L59 126 L59 124 L43 123 L43 121 L55 121 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M29 133 L30 133 L30 143 L33 144 L35 149 L37 149 L36 151 L33 149 L32 154 L16 152 L16 148 L20 148 L21 144 L22 144 L23 150 L29 150 L30 145 L29 144 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M46 126 L55 126 L60 127 L60 133 L46 133 L45 127 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M60 111 L72 111 L74 112 L74 117 L56 117 L60 115 L62 115 L62 112 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M72 153 L80 153 L81 159 L75 160 L75 158 L73 158 L73 161 L69 161 L69 155 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M73 125 L78 125 L79 126 L79 134 L77 136 L73 136 L72 134 L72 127 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M16 128 L24 128 L24 135 L22 137 L16 137 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M62 120 L67 124 L68 122 L68 124 L70 124 L69 127 L65 128 L64 136 L63 140 L56 141 L62 134 L62 126 L60 123 L62 123 Z" style="fill:';
    string private constant PART_26 = ';"/>';
    string private constant COLOR_1 = 'hsl(223, 8%, 18%)';
    string private constant COLOR_2 = 'hsl(34, 4%, 34%)';
    string private constant COLOR_3 = 'hsl(222, 15%, 13%)';
    string private constant COLOR_4 = 'hsl(223, 9%, 16%)';
    string private constant COLOR_5 = 'hsl(35, 11%, 53%)';
    string private constant COLOR_6 = 'hsl(38, 7%, 42%)';
    string private constant COLOR_7 = 'hsl(20, 2%, 30%)';
    string private constant COLOR_8 = 'hsl(230, 7%, 16%)';
    string private constant COLOR_9 = 'hsl(213, 11%, 17%)';
    string private constant COLOR_10 = 'hsl(35, 8%, 46%)';
    string private constant COLOR_11 = 'hsl(216, 21%, 9%)';
    string private constant COLOR_12 = 'hsl(30, 5%, 40%)';
    string private constant COLOR_13 = 'hsl(220, 16%, 11%)';
    string private constant COLOR_14 = 'hsl(240, 2%, 26%)';
    string private constant COLOR_15 = 'hsl(228, 5%, 19%)';
    string private constant COLOR_16 = 'hsl(26, 4%, 31%)';
    string private constant COLOR_17 = 'hsl(240, 4%, 23%)';
    string private constant COLOR_18 = 'hsl(220, 13%, 14%)';
    string private constant COLOR_19 = 'hsl(216, 17%, 11%)';
    string private constant COLOR_20 = 'hsl(30, 5%, 38%)';
    string private constant COLOR_21 = 'hsl(33, 14%, 58%)';
    string private constant COLOR_22 = 'hsl(223, 8%, 18%)';
    string private constant COLOR_23 = 'hsl(240, 3%, 21%)';
    string private constant COLOR_24 = 'hsl(195, 37%, 33%)';
    string private constant COLOR_25 = 'hsl(240, 3%, 23%)';

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
            PART_26
        );
        return result;
    }
}
