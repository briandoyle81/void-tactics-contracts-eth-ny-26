// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderFore0SelfTest {
    string private constant PART_1 = '<path d="M56 104 L75 104 L77 108 L77 113 L84 114 L84 153 L79 157 L75 162 L67 162 L67 164 L42 164 L38 158 L35 156 L35 154 L27 154 L21 152 L21 150 L12 152 L9 149 L10 145 L12 143 L21 143 L23 141 L18 141 L17 139 L16 130 L15 129 L15 122 L19 120 L21 116 L37 116 L38 113 L49 112 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M39 115 L77 115 L80 117 L80 127 L74 127 L72 120 L69 119 L67 118 L67 120 L65 122 L69 123 L72 123 L72 127 L64 127 L61 134 L59 136 L51 136 L51 138 L47 137 L48 141 L51 140 L61 140 L62 136 L64 136 L65 133 L72 132 L72 148 L67 148 L67 151 L63 151 L63 148 L40 148 L38 146 L39 151 L38 152 L31 152 L30 150 L23 151 L23 144 L27 143 L36 144 L35 141 L30 138 L29 141 L25 142 L18 141 L19 134 L28 135 L28 132 L25 133 L24 125 L19 125 L20 120 L22 118 L37 118 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M56 104 L75 104 L77 108 L77 113 L81 114 L81 116 L83 116 L83 144 L79 145 L78 148 L74 147 L73 146 L73 140 L73 138 L73 132 L75 127 L79 125 L79 117 L77 116 L39 116 L37 119 L22 119 L20 121 L19 125 L24 125 L25 122 L26 132 L28 132 L29 128 L29 136 L24 135 L23 137 L22 135 L19 134 L19 139 L17 139 L16 130 L15 129 L15 122 L19 120 L21 116 L37 116 L38 113 L49 112 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M39 115 L77 115 L80 117 L80 127 L74 127 L72 120 L69 119 L67 118 L67 120 L65 122 L69 123 L72 123 L72 127 L64 127 L61 123 L61 130 L60 127 L49 127 L50 135 L47 134 L45 132 L44 136 L42 136 L42 129 L35 130 L33 136 L32 136 L32 131 L30 131 L31 126 L29 123 L25 123 L24 125 L19 125 L20 120 L22 118 L37 118 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M82 114 L84 114 L84 153 L79 156 L79 153 L60 153 L63 156 L66 162 L62 160 L59 157 L53 156 L53 153 L49 153 L49 149 L38 150 L37 145 L40 147 L63 148 L65 150 L67 151 L67 148 L72 148 L71 133 L65 134 L64 136 L62 136 L61 140 L48 141 L45 137 L46 135 L51 138 L51 136 L59 135 L62 131 L63 125 L64 127 L72 127 L72 123 L66 124 L64 121 L67 120 L67 118 L65 117 L70 118 L73 119 L74 126 L76 129 L74 129 L75 132 L73 132 L74 138 L77 140 L73 140 L75 147 L78 147 L79 145 L81 145 L82 143 L83 116 L81 115 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M39 115 L77 115 L80 117 L80 127 L74 127 L72 120 L69 119 L69 118 L59 118 L55 117 L55 120 L48 121 L45 125 L43 129 L32 128 L33 126 L31 122 L35 121 L35 119 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M77 115 L83 116 L83 144 L79 145 L78 148 L74 147 L73 146 L73 140 L73 138 L73 132 L75 127 L79 125 L79 117 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M56 104 L75 104 L75 113 L63 114 L52 113 L53 108 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M59 152 L80 152 L78 159 L75 162 L61 163 L54 161 L54 157 L59 156 L64 160 L60 154 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M69 132 L72 133 L72 145 L56 145 L57 141 L61 140 L62 136 L64 136 L65 133 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M37 145 L40 147 L63 148 L63 151 L58 151 L58 153 L62 155 L66 162 L62 160 L59 157 L53 156 L53 153 L49 153 L49 149 L38 150 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M56 115 L77 115 L80 117 L80 127 L74 127 L72 120 L69 119 L69 118 L59 118 L56 117 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M82 114 L84 114 L84 153 L79 156 L79 153 L71 152 L73 148 L78 147 L79 145 L81 145 L82 143 L83 116 L81 115 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M18 122 L19 125 L24 125 L25 122 L26 132 L28 132 L29 128 L29 136 L24 135 L23 137 L22 135 L19 134 L19 139 L17 139 L17 123 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M59 152 L80 152 L79 156 L74 158 L72 157 L68 158 L71 160 L65 159 L65 157 L61 155 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M12 143 L22 144 L22 150 L12 152 L9 149 L10 145 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M29 137 L32 139 L44 140 L44 141 L36 142 L36 144 L24 144 L23 151 L27 151 L27 146 L28 150 L30 150 L31 147 L31 152 L25 153 L21 152 L21 143 L25 141 L29 141 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M47 123 L59 123 L61 125 L61 130 L60 127 L49 127 L50 135 L47 134 L46 129 L45 126 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M39 149 L49 149 L49 153 L53 154 L36 154 L27 153 L27 152 L38 151 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M49 127 L59 127 L59 134 L49 134 Z" style="fill:';
    string private constant PART_21 = ';"/>';
    string private constant COLOR_1 = 'hsl(220, 11%, 16%)';
    string private constant COLOR_2 = 'hsl(210, 7%, 24%)';
    string private constant COLOR_3 = 'hsl(225, 8%, 9%)';
    string private constant COLOR_4 = 'hsl(60, 1%, 35%)';
    string private constant COLOR_5 = 'hsl(214, 8%, 17%)';
    string private constant COLOR_6 = 'hsl(37, 4%, 42%)';
    string private constant COLOR_7 = 'hsl(210, 5%, 26%)';
    string private constant COLOR_8 = 'hsl(240, 2%, 24%)';
    string private constant COLOR_9 = 'hsl(218, 8%, 19%)';
    string private constant COLOR_10 = 'hsl(180, 1%, 32%)';
    string private constant COLOR_11 = 'hsl(220, 15%, 12%)';
    string private constant COLOR_12 = 'hsl(48, 4%, 45%)';
    string private constant COLOR_13 = 'hsl(218, 13%, 12%)';
    string private constant COLOR_14 = 'hsl(218, 9%, 17%)';
    string private constant COLOR_15 = 'hsl(218, 6%, 25%)';
    string private constant COLOR_16 = 'hsl(210, 3%, 23%)';
    string private constant COLOR_17 = 'hsl(218, 14%, 11%)';
    string private constant COLOR_18 = 'hsl(47, 4%, 45%)';
    string private constant COLOR_19 = 'hsl(216, 10%, 19%)';
    string private constant COLOR_20 = 'hsl(7, 16%, 21%)';

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
            PART_21
        );
        return result;
    }
}
