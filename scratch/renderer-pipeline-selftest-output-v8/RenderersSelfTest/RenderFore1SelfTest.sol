// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderFore1SelfTest {
    string private constant PART_1 = '<path d="M11 130 L19 130 L19 139 L18 140 L12 140 L12 142 L24 142 L24 145 L24 151 L25 148 L29 150 L31 153 L27 153 L27 155 L12 153 L11 152 L10 145 L7 140 L9 135 L11 135 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M54 101 L72 101 L72 103 L75 104 L77 110 L87 110 L87 121 L86 122 L85 153 L84 153 L83 126 L82 126 L82 120 L85 117 L86 112 L76 113 L48 112 L47 114 L47 112 L32 113 L29 116 L29 113 L32 110 L47 110 L47 108 L49 108 L49 110 L71 110 L70 104 L55 104 L50 107 L52 103 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M32 112 L47 112 L47 114 L39 115 L35 118 L36 115 L32 117 L29 121 L32 122 L32 130 L31 131 L31 139 L33 139 L37 143 L37 145 L33 144 L33 146 L29 145 L25 142 L24 119 L26 117 L27 114 L31 115 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M54 145 L63 146 L63 153 L34 153 L34 147 L54 147 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M44 155 L66 155 L65 164 L44 164 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M33 145 L34 145 L34 153 L81 152 L84 155 L78 157 L77 156 L68 155 L67 158 L69 159 L67 159 L67 165 L38 165 L37 162 L43 164 L44 160 L44 164 L55 163 L64 163 L64 158 L66 158 L66 155 L35 155 L32 154 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M12 114 L26 114 L27 118 L25 119 L25 116 L12 117 L8 120 L7 128 L24 128 L24 120 L25 120 L26 147 L24 147 L24 145 L21 144 L23 143 L24 130 L20 130 L20 138 L19 138 L19 130 L11 130 L11 135 L9 135 L8 139 L7 131 L5 131 L4 128 L4 121 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M48 112 L81 112 L80 119 L78 119 L78 121 L71 121 L71 123 L68 123 L68 121 L65 120 L65 119 L72 119 L72 116 L68 116 L67 118 L62 117 L62 115 L48 114 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M55 121 L59 123 L61 123 L63 122 L67 124 L68 128 L66 130 L60 131 L60 140 L56 144 L39 144 L39 145 L54 146 L54 147 L34 147 L33 144 L37 145 L37 143 L33 141 L36 141 L56 142 L56 140 L58 140 L58 127 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M69 130 L72 134 L71 138 L78 137 L78 145 L72 145 L72 143 L68 145 L63 145 L63 137 L67 137 L67 134 L62 134 L62 136 L60 136 L60 131 L67 131 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M34 114 L37 115 L38 115 L39 114 L62 114 L63 116 L49 118 L48 120 L44 120 L43 122 L34 122 L32 122 L28 121 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M55 103 L70 103 L71 104 L71 110 L49 110 L48 107 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M70 143 L72 143 L73 145 L78 146 L79 149 L80 147 L82 147 L83 153 L63 153 L63 146 L68 146 L68 144 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M78 126 L82 127 L82 146 L73 146 L73 145 L78 145 L77 138 L71 138 L71 132 L76 132 L76 129 L72 128 L77 128 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M49 117 L61 117 L64 120 L63 123 L60 125 L57 123 L56 125 L53 123 L52 124 L34 124 L34 122 L43 122 L44 118 L44 120 L48 120 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M49 128 L54 128 L54 135 L52 137 L38 137 L37 136 L37 129 L39 129 L39 132 L41 132 L41 129 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M81 112 L86 112 L86 117 L83 120 L83 125 L84 125 L85 154 L82 153 L82 147 L80 147 L79 150 L78 146 L80 145 L82 146 L81 127 L79 127 L79 119 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M52 118 L53 118 L53 123 L56 124 L56 125 L36 126 L33 127 L34 131 L36 128 L49 128 L49 129 L41 129 L41 132 L39 132 L39 129 L38 131 L37 139 L32 137 L31 139 L30 130 L32 130 L32 121 L34 119 L34 124 L52 124 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M14 117 L18 118 L18 121 L20 121 L20 118 L25 117 L24 128 L9 128 L13 127 L14 125 L13 124 L13 122 L11 122 L12 119 L14 119 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M67 154 L77 155 L81 156 L80 161 L78 163 L67 165 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M62 134 L67 134 L67 137 L63 137 L63 145 L68 145 L68 146 L39 146 L39 143 L57 143 L60 136 L62 136 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M34 154 L50 156 L50 157 L44 157 L43 164 L36 163 L33 160 L29 159 L30 155 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M54 128 L57 129 L57 136 L56 139 L39 140 L52 141 L52 142 L36 142 L32 139 L32 137 L37 139 L38 136 L52 136 L53 131 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M78 119 L79 119 L79 126 L77 129 L76 132 L70 133 L69 131 L67 130 L69 123 L71 123 L71 121 L78 121 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M12 116 L25 116 L22 118 L20 118 L20 121 L18 121 L18 118 L14 117 L14 119 L11 122 L13 122 L13 124 L15 124 L14 126 L7 128 L7 120 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M36 125 L56 125 L57 129 L36 129 L35 134 L33 131 L33 127 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M25 142 L33 146 L33 152 L32 154 L34 155 L28 157 L27 153 L30 152 L25 148 L24 153 L20 152 L23 151 L24 147 L26 147 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M56 125 L59 127 L59 138 L58 140 L56 140 L56 142 L39 141 L38 139 L56 139 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M70 164 L73 165 L72 167 L40 167 L39 165 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M20 130 L24 130 L24 142 L12 142 L12 140 L19 138 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M67 115 L72 116 L72 119 L66 120 L69 123 L69 129 L67 132 L62 132 L62 130 L67 128 L66 124 L64 123 L61 118 L54 117 L54 116 L62 116 L67 118 Z" style="fill:';
    string private constant PART_32 = ';"/>';
    string private constant COLOR_1 = 'hsl(203, 19%, 24%)';
    string private constant COLOR_2 = 'hsl(218, 15%, 11%)';
    string private constant COLOR_3 = 'hsl(20, 2%, 35%)';
    string private constant COLOR_4 = 'hsl(223, 7%, 20%)';
    string private constant COLOR_5 = 'hsl(220, 5%, 22%)';
    string private constant COLOR_6 = 'hsl(218, 16%, 13%)';
    string private constant COLOR_7 = 'hsl(220, 13%, 14%)';
    string private constant COLOR_8 = 'hsl(30, 3%, 45%)';
    string private constant COLOR_9 = 'hsl(216, 4%, 24%)';
    string private constant COLOR_10 = 'hsl(30, 1%, 35%)';
    string private constant COLOR_11 = 'hsl(35, 5%, 55%)';
    string private constant COLOR_12 = 'hsl(240, 1%, 28%)';
    string private constant COLOR_13 = 'hsl(225, 8%, 20%)';
    string private constant COLOR_14 = 'hsl(228, 4%, 24%)';
    string private constant COLOR_15 = 'hsl(0, 1%, 36%)';
    string private constant COLOR_16 = 'hsl(20, 2%, 39%)';
    string private constant COLOR_17 = 'hsl(220, 5%, 22%)';
    string private constant COLOR_18 = 'hsl(228, 5%, 22%)';
    string private constant COLOR_19 = 'hsl(33, 4%, 48%)';
    string private constant COLOR_20 = 'hsl(214, 7%, 19%)';
    string private constant COLOR_21 = 'hsl(240, 1%, 30%)';
    string private constant COLOR_22 = 'hsl(214, 7%, 20%)';
    string private constant COLOR_23 = 'hsl(223, 7%, 20%)';
    string private constant COLOR_24 = 'hsl(300, 1%, 33%)';
    string private constant COLOR_25 = 'hsl(24, 2%, 39%)';
    string private constant COLOR_26 = 'hsl(27, 4%, 53%)';
    string private constant COLOR_27 = 'hsl(220, 11%, 16%)';
    string private constant COLOR_28 = 'hsl(222, 14%, 14%)';
    string private constant COLOR_29 = 'hsl(220, 8%, 16%)';
    string private constant COLOR_30 = 'hsl(240, 1%, 29%)';
    string private constant COLOR_31 = 'hsl(218, 9%, 17%)';

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
        return result;
    }
}
