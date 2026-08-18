// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderFore2SelfTest {
    string private constant PART_1 = '<path d="M52 99 L86 99 L89 103 L89 106 L91 106 L91 116 L87 120 L85 120 L84 149 L82 152 L81 159 L79 159 L77 163 L73 164 L41 164 L37 161 L37 159 L35 159 L31 154 L9 151 L4 151 L2 149 L2 146 L9 145 L13 145 L13 132 L10 128 L10 120 L13 119 L15 115 L23 113 L31 108 L44 108 L44 106 L47 103 L49 103 L49 101 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M32 109 L89 109 L87 113 L82 119 L81 145 L78 144 L77 140 L80 139 L78 134 L78 126 L71 125 L69 120 L63 120 L60 121 L60 118 L55 117 L34 117 L33 119 L35 118 L50 118 L50 121 L43 121 L43 123 L37 126 L36 135 L41 137 L41 139 L48 141 L51 141 L55 141 L55 145 L33 145 L30 143 L29 127 L27 121 L14 121 L14 119 L19 119 L19 117 L24 116 L28 112 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M34 116 L56 116 L74 117 L74 118 L60 118 L60 121 L63 119 L69 119 L71 121 L71 125 L78 125 L79 126 L79 135 L80 139 L78 140 L79 145 L69 146 L68 145 L56 145 L56 140 L62 134 L62 126 L55 121 L50 121 L50 118 L33 119 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M55 119 L62 125 L63 126 L63 134 L57 140 L57 147 L55 148 L55 141 L48 143 L48 141 L43 140 L41 139 L41 137 L36 135 L36 124 L38 125 L43 123 L43 121 L55 121 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M31 110 L37 111 L36 116 L33 119 L35 118 L50 118 L50 121 L43 121 L43 123 L37 126 L36 135 L41 137 L41 139 L48 141 L51 141 L55 141 L55 145 L33 145 L30 143 L29 127 L27 121 L14 121 L14 119 L19 119 L19 117 L24 116 L28 112 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M87 112 L89 112 L88 116 L84 121 L83 151 L82 152 L81 159 L79 159 L77 163 L73 164 L41 164 L36 159 L37 157 L42 158 L42 161 L46 160 L64 161 L64 158 L68 158 L68 153 L40 154 L39 152 L79 152 L80 147 L81 119 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M39 111 L72 111 L74 112 L74 117 L36 117 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M85 99 L87 101 L87 105 L60 106 L56 108 L55 107 L46 108 L52 101 L53 100 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M16 128 L24 128 L24 135 L29 135 L27 142 L26 144 L21 144 L21 149 L16 148 L16 146 L19 146 L19 144 L14 143 L14 132 L12 129 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M43 123 L57 123 L59 124 L59 126 L55 127 L60 127 L60 133 L55 134 L45 134 L40 133 L40 126 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M34 116 L56 116 L74 117 L74 118 L60 118 L60 121 L63 119 L69 119 L71 121 L70 126 L65 127 L64 136 L58 141 L56 140 L62 134 L62 126 L55 121 L50 121 L50 118 L33 119 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M14 130 L15 130 L15 143 L19 144 L19 146 L16 146 L17 148 L21 149 L21 144 L22 144 L22 150 L29 150 L30 147 L32 148 L33 155 L35 155 L34 157 L31 154 L9 151 L4 151 L2 149 L2 146 L9 145 L13 145 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M30 128 L32 132 L35 131 L35 135 L39 136 L41 137 L41 139 L48 141 L51 141 L55 141 L55 145 L33 145 L30 143 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M31 110 L37 111 L36 116 L31 121 L29 121 L29 126 L28 126 L27 121 L14 121 L14 119 L19 119 L19 117 L24 116 L28 112 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M32 109 L89 109 L88 112 L75 111 L75 116 L74 112 L39 112 L37 116 L36 114 L37 111 L32 110 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M44 156 L68 156 L68 158 L64 158 L64 161 L42 161 L41 157 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M87 112 L89 112 L88 116 L84 121 L83 151 L79 152 L80 147 L81 119 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M69 153 L80 153 L80 157 L78 157 L77 163 L74 163 L73 161 L69 161 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M60 111 L72 111 L74 112 L74 117 L56 117 L60 115 L62 115 L62 112 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M73 125 L78 125 L79 126 L79 134 L77 136 L73 136 L72 134 L72 127 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M16 128 L24 128 L24 135 L22 137 L16 137 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M21 144 L22 144 L22 150 L29 150 L30 147 L32 148 L33 155 L35 155 L34 157 L31 154 L16 152 L17 148 L21 149 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M53 100 L83 100 L81 102 L78 102 L78 104 L73 104 L73 103 L53 102 Z" style="fill:';
    string private constant PART_24 = ';"/>';
    string private constant COLOR_1 = 'hsl(223, 8%, 17%)';
    string private constant COLOR_2 = 'hsl(32, 6%, 41%)';
    string private constant COLOR_3 = 'hsl(34, 4%, 34%)';
    string private constant COLOR_4 = 'hsl(218, 10%, 15%)';
    string private constant COLOR_5 = 'hsl(33, 5%, 37%)';
    string private constant COLOR_6 = 'hsl(220, 16%, 11%)';
    string private constant COLOR_7 = 'hsl(35, 11%, 53%)';
    string private constant COLOR_8 = 'hsl(0, 1%, 30%)';
    string private constant COLOR_9 = 'hsl(214, 5%, 26%)';
    string private constant COLOR_10 = 'hsl(26, 4%, 36%)';
    string private constant COLOR_11 = 'hsl(24, 3%, 28%)';
    string private constant COLOR_12 = 'hsl(300, 4%, 16%)';
    string private constant COLOR_13 = 'hsl(15, 2%, 32%)';
    string private constant COLOR_14 = 'hsl(34, 9%, 52%)';
    string private constant COLOR_15 = 'hsl(30, 5%, 31%)';
    string private constant COLOR_16 = 'hsl(240, 2%, 25%)';
    string private constant COLOR_17 = 'hsl(225, 10%, 16%)';
    string private constant COLOR_18 = 'hsl(220, 7%, 18%)';
    string private constant COLOR_19 = 'hsl(33, 14%, 58%)';
    string private constant COLOR_20 = 'hsl(240, 3%, 21%)';
    string private constant COLOR_21 = 'hsl(195, 37%, 33%)';
    string private constant COLOR_22 = 'hsl(218, 19%, 12%)';
    string private constant COLOR_23 = 'hsl(32, 8%, 49%)';

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
            PART_24
        );
        return result;
    }
}
