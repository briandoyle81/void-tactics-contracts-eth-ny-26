// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderFore0SelfTest {
    string private constant PART_1 = '<path d="M56 104 L75 104 L77 108 L77 113 L84 114 L84 153 L79 157 L75 162 L67 162 L67 164 L42 164 L38 158 L35 156 L35 154 L27 154 L21 152 L21 150 L12 152 L9 149 L10 145 L12 143 L21 143 L23 141 L18 141 L17 139 L16 130 L15 129 L15 122 L19 120 L21 116 L37 116 L38 113 L49 112 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M56 104 L75 104 L77 108 L77 113 L81 114 L81 115 L39 116 L37 119 L31 120 L22 119 L20 121 L19 125 L24 125 L25 122 L25 134 L28 134 L28 128 L29 128 L30 137 L32 139 L44 140 L44 141 L36 142 L36 144 L24 144 L23 151 L25 150 L25 148 L27 148 L28 145 L28 150 L30 150 L31 147 L31 152 L25 153 L21 152 L21 150 L12 152 L9 149 L10 145 L12 143 L21 143 L23 141 L18 141 L17 139 L16 130 L15 129 L15 122 L19 120 L21 116 L37 116 L38 113 L49 112 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M39 115 L77 115 L80 117 L81 121 L80 127 L74 127 L72 120 L69 120 L69 117 L67 118 L67 120 L65 122 L66 125 L69 123 L72 123 L72 127 L64 127 L61 122 L59 121 L61 125 L61 130 L60 127 L49 127 L49 134 L52 135 L48 135 L45 129 L46 124 L44 127 L43 129 L32 128 L31 136 L28 134 L25 134 L24 125 L19 125 L20 120 L23 118 L32 119 L37 118 Z M46 128 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M64 134 L72 134 L72 148 L67 148 L67 151 L63 151 L63 148 L43 148 L38 143 L37 141 L44 140 L47 138 L48 141 L51 140 L61 140 L62 136 L64 136 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M47 121 L47 124 L46 129 L49 135 L51 135 L49 134 L49 127 L60 127 L63 127 L63 132 L59 136 L48 138 L46 137 L45 140 L32 140 L29 136 L31 136 L30 132 L32 128 L38 127 L43 128 L45 123 Z M46 128 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M40 148 L63 148 L63 151 L60 153 L63 156 L62 160 L59 157 L55 158 L55 164 L42 164 L38 158 L35 156 L35 154 L27 154 L27 153 L36 153 L47 154 L47 155 L40 156 L44 160 L50 160 L50 155 L48 154 L49 149 L40 149 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M56 104 L75 104 L76 108 L75 113 L64 114 L61 113 L60 111 L59 112 L53 112 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M74 129 L76 129 L76 132 L81 132 L83 131 L83 148 L73 148 L73 132 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M56 115 L77 115 L80 117 L81 121 L80 127 L74 127 L72 120 L69 120 L69 117 L59 118 L56 117 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M22 118 L31 119 L33 120 L33 122 L32 123 L32 126 L31 131 L31 136 L28 134 L25 134 L24 125 L19 125 L20 120 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M82 114 L84 114 L84 153 L79 156 L79 153 L69 152 L72 151 L73 148 L82 147 L83 116 L81 115 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M61 151 L65 152 L80 152 L79 156 L74 158 L72 157 L66 157 L65 159 L65 157 L61 155 L59 152 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M47 123 L59 123 L61 125 L61 130 L60 127 L49 127 L49 134 L52 135 L48 135 L45 129 L46 124 Z M46 128 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M39 115 L55 115 L55 116 L46 117 L39 117 L38 125 L37 128 L32 128 L32 131 L30 131 L31 126 L31 124 L31 122 L33 122 L32 119 L37 118 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M24 143 L32 144 L32 147 L37 148 L39 151 L38 152 L31 152 L30 150 L28 150 L27 148 L25 148 L26 151 L23 151 L23 144 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M64 134 L72 134 L72 145 L67 145 L70 144 L68 139 L67 142 L64 142 L64 140 L62 140 L61 142 L62 136 L64 136 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M49 127 L59 127 L59 134 L49 134 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M12 143 L22 144 L22 147 L15 147 L15 152 L11 151 L9 149 L10 145 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M33 129 L35 131 L39 130 L40 132 L39 135 L36 136 L37 138 L34 138 L34 140 L30 138 L29 136 L31 136 L30 132 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M46 138 L48 139 L47 144 L52 142 L55 142 L55 145 L40 145 L37 141 L44 140 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M64 138 L69 138 L70 144 L67 145 L56 145 L57 141 L62 142 L62 140 L64 140 L64 142 L66 140 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M39 155 L50 155 L50 160 L52 161 L44 161 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M22 118 L31 119 L32 121 L29 123 L25 123 L24 125 L19 125 L20 120 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M18 122 L19 125 L24 125 L24 133 L20 132 L17 130 L17 123 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M55 115 L56 117 L61 118 L59 123 L48 123 L48 120 L55 120 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M21 116 L35 118 L31 120 L22 119 L18 123 L17 130 L15 129 L15 122 L19 120 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M61 106 L68 106 L68 113 L61 113 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M65 117 L69 117 L69 120 L73 119 L74 128 L72 127 L72 123 L70 125 L66 125 L64 121 L67 120 L67 118 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M19 134 L25 136 L27 137 L27 142 L18 141 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M75 108 L77 108 L77 113 L81 114 L81 115 L59 115 L63 113 L75 113 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M35 129 L42 129 L42 136 L40 138 L40 139 L34 139 L36 135 L39 135 L39 131 L34 132 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M69 106 L75 106 L75 113 L69 113 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M45 135 L48 137 L60 137 L62 136 L61 140 L48 141 L45 137 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M72 127 L76 128 L74 129 L75 132 L64 132 L64 128 L69 129 L69 131 L72 131 L72 129 L70 128 Z" style="fill:';
    string private constant PART_35 = ';"/>';
    string private constant COLOR_1 = 'hsl(213, 9%, 19%)';
    string private constant COLOR_2 = 'hsl(220, 10%, 12%)';
    string private constant COLOR_3 = 'hsl(48, 3%, 37%)';
    string private constant COLOR_4 = 'hsl(255, 3%, 23%)';
    string private constant COLOR_5 = 'hsl(206, 5%, 25%)';
    string private constant COLOR_6 = 'hsl(220, 15%, 12%)';
    string private constant COLOR_7 = 'hsl(225, 4%, 19%)';
    string private constant COLOR_8 = 'hsl(204, 4%, 27%)';
    string private constant COLOR_9 = 'hsl(47, 4%, 45%)';
    string private constant COLOR_10 = 'hsl(220, 5%, 24%)';
    string private constant COLOR_11 = 'hsl(218, 14%, 11%)';
    string private constant COLOR_12 = 'hsl(218, 6%, 25%)';
    string private constant COLOR_13 = 'hsl(52, 4%, 43%)';
    string private constant COLOR_14 = 'hsl(48, 4%, 49%)';
    string private constant COLOR_15 = 'hsl(218, 7%, 24%)';
    string private constant COLOR_16 = 'hsl(100, 2%, 37%)';
    string private constant COLOR_17 = 'hsl(7, 16%, 21%)';
    string private constant COLOR_18 = 'hsl(220, 2%, 25%)';
    string private constant COLOR_19 = 'hsl(198, 18%, 28%)';
    string private constant COLOR_20 = 'hsl(180, 1%, 35%)';
    string private constant COLOR_21 = 'hsl(200, 2%, 28%)';
    string private constant COLOR_22 = 'hsl(222, 8%, 24%)';
    string private constant COLOR_23 = 'hsl(49, 4%, 49%)';
    string private constant COLOR_24 = 'hsl(213, 8%, 23%)';
    string private constant COLOR_25 = 'hsl(120, 1%, 33%)';
    string private constant COLOR_26 = 'hsl(225, 6%, 14%)';
    string private constant COLOR_27 = 'hsl(10, 4%, 32%)';
    string private constant COLOR_28 = 'hsl(204, 4%, 24%)';
    string private constant COLOR_29 = 'hsl(214, 6%, 23%)';
    string private constant COLOR_30 = 'hsl(225, 9%, 9%)';
    string private constant COLOR_31 = 'hsl(223, 10%, 14%)';
    string private constant COLOR_32 = 'hsl(220, 2%, 30%)';
    string private constant COLOR_33 = 'hsl(223, 13%, 11%)';
    string private constant COLOR_34 = 'hsl(218, 12%, 13%)';

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
