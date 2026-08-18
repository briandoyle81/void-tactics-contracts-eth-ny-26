// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderFore1SelfTest {
    string private constant PART_1 = '<path d="M54 101 L72 101 L72 103 L75 104 L77 110 L87 110 L87 121 L86 122 L85 154 L81 156 L80 161 L78 163 L73 165 L72 167 L40 167 L33 160 L29 159 L25 155 L12 153 L11 152 L10 145 L7 140 L7 131 L5 131 L4 128 L4 121 L12 114 L28 114 L32 110 L47 110 L49 106 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M54 101 L72 101 L72 103 L75 104 L77 110 L87 110 L87 121 L86 122 L85 153 L84 153 L84 120 L85 119 L86 112 L82 112 L83 115 L81 117 L81 112 L76 113 L48 112 L47 114 L47 112 L31 113 L31 115 L29 116 L27 120 L26 130 L31 130 L28 133 L28 131 L26 131 L27 143 L30 145 L34 145 L34 153 L80 152 L84 155 L81 156 L80 161 L78 163 L73 165 L72 167 L40 167 L33 160 L29 159 L25 155 L12 153 L11 152 L10 145 L7 140 L7 131 L5 131 L4 128 L4 121 L12 114 L28 114 L32 110 L47 110 L49 106 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M33 112 L81 112 L80 119 L78 119 L78 121 L71 121 L71 123 L68 123 L68 128 L66 129 L62 128 L62 125 L64 125 L62 123 L60 125 L57 122 L54 122 L53 119 L59 118 L62 120 L65 119 L72 119 L72 116 L68 116 L67 118 L62 117 L54 117 L50 118 L50 121 L52 121 L52 124 L34 124 L33 121 L33 127 L36 125 L56 125 L57 129 L54 129 L54 135 L52 137 L38 137 L36 140 L32 137 L35 142 L37 143 L37 145 L33 144 L33 146 L29 145 L26 143 L26 131 L30 131 L26 130 L26 119 L29 115 L31 115 L31 113 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M54 101 L72 101 L72 103 L75 104 L77 110 L87 110 L87 121 L86 122 L85 153 L84 153 L84 120 L85 119 L86 112 L82 112 L83 115 L81 117 L81 112 L76 113 L48 112 L47 114 L47 112 L31 113 L31 115 L29 116 L27 120 L26 130 L31 130 L28 133 L28 131 L26 131 L27 143 L33 146 L33 152 L26 146 L25 145 L24 119 L25 116 L12 117 L8 120 L7 129 L9 130 L7 132 L5 131 L4 128 L4 121 L12 114 L28 114 L32 110 L47 110 L49 106 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M28 118 L30 119 L29 121 L32 122 L33 127 L36 125 L56 125 L57 129 L54 129 L54 135 L52 137 L38 137 L36 140 L32 137 L35 142 L37 143 L37 145 L33 144 L33 146 L29 145 L26 143 L26 131 L30 131 L26 130 L26 119 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M12 116 L25 116 L24 128 L19 129 L24 130 L24 143 L11 144 L9 137 L9 133 L7 132 L7 129 L7 120 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M67 115 L72 116 L72 119 L66 120 L62 121 L57 119 L54 120 L59 123 L61 123 L64 123 L64 125 L62 125 L62 128 L67 128 L68 123 L69 123 L69 129 L67 132 L60 132 L60 140 L58 142 L56 142 L35 141 L32 139 L32 137 L36 139 L38 136 L52 136 L53 131 L54 128 L56 128 L56 125 L36 126 L32 128 L32 121 L34 119 L34 124 L52 124 L52 121 L50 121 L49 117 L54 116 L62 116 L67 118 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M67 154 L77 154 L79 160 L75 161 L70 161 L67 163 L66 162 L65 164 L40 164 L35 162 L33 159 L35 159 L36 155 L66 155 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M71 122 L77 122 L78 123 L78 129 L76 129 L76 132 L71 132 L72 135 L71 138 L78 137 L78 145 L73 145 L69 144 L68 146 L39 146 L39 143 L52 143 L56 142 L57 140 L59 140 L60 132 L67 132 L69 123 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M12 116 L25 116 L24 128 L7 128 L7 120 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M36 155 L66 155 L66 158 L61 158 L61 160 L43 160 L43 164 L36 163 L33 159 L35 159 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M56 125 L59 127 L59 138 L58 140 L56 140 L56 142 L35 141 L32 139 L32 137 L36 139 L38 136 L52 136 L53 131 L54 128 L56 128 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M82 112 L86 112 L86 119 L83 127 L82 146 L80 146 L79 134 L78 133 L77 123 L72 123 L71 121 L78 121 L78 119 L80 119 L80 117 L82 117 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M55 103 L70 103 L71 104 L71 110 L48 110 L49 108 L51 108 L53 104 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M12 145 L24 145 L25 148 L29 150 L31 153 L28 153 L28 155 L12 153 L11 151 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M24 120 L25 120 L26 145 L32 152 L28 150 L24 149 L24 145 L19 145 L19 151 L18 151 L18 145 L12 145 L12 151 L11 151 L9 144 L7 140 L8 133 L10 137 L11 143 L24 143 L24 130 L20 130 L20 138 L19 138 L19 129 L12 129 L12 128 L24 128 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M70 132 L72 135 L71 138 L78 137 L78 145 L73 145 L69 144 L68 145 L63 145 L63 137 L68 137 L68 133 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M37 129 L39 129 L39 132 L41 132 L41 129 L50 129 L50 132 L52 132 L51 129 L53 129 L54 135 L52 137 L38 137 L37 136 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M32 114 L37 114 L37 116 L39 114 L46 115 L43 122 L34 122 L32 122 L28 121 L28 118 L29 115 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M48 112 L81 112 L80 119 L73 120 L77 115 L48 114 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M26 131 L30 131 L31 131 L31 139 L33 139 L37 143 L37 145 L33 144 L33 146 L29 145 L26 143 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M62 134 L67 134 L67 137 L63 137 L63 145 L68 145 L68 146 L39 146 L39 143 L52 143 L56 142 L57 140 L57 144 L62 145 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M72 128 L77 128 L80 134 L80 145 L79 146 L73 146 L73 145 L78 145 L77 138 L71 138 L71 132 L76 132 L76 129 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M36 125 L56 125 L57 129 L36 129 L35 134 L33 131 L33 127 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M79 152 L84 154 L83 156 L81 156 L80 161 L78 163 L74 163 L75 160 L78 160 L77 154 L67 154 L66 158 L66 154 L47 154 L47 153 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M67 154 L77 154 L79 160 L75 161 L70 161 L67 163 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M55 118 L60 119 L68 121 L68 128 L66 129 L62 128 L62 125 L64 125 L62 123 L60 125 L57 122 L54 122 L53 119 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M20 130 L24 130 L24 142 L12 142 L12 140 L19 138 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M54 128 L57 129 L57 136 L56 139 L52 139 L37 139 L38 136 L52 136 L53 131 Z" style="fill:';
    string private constant PART_30 = ';"/>';
    string private constant COLOR_1 = 'hsl(220, 9%, 21%)';
    string private constant COLOR_2 = 'hsl(220, 12%, 15%)';
    string private constant COLOR_3 = 'hsl(33, 4%, 46%)';
    string private constant COLOR_4 = 'hsl(214, 10%, 14%)';
    string private constant COLOR_5 = 'hsl(30, 1%, 31%)';
    string private constant COLOR_6 = 'hsl(202, 30%, 28%)';
    string private constant COLOR_7 = 'hsl(228, 5%, 19%)';
    string private constant COLOR_8 = 'hsl(218, 8%, 20%)';
    string private constant COLOR_9 = 'hsl(60, 1%, 34%)';
    string private constant COLOR_10 = 'hsl(30, 4%, 44%)';
    string private constant COLOR_11 = 'hsl(223, 6%, 23%)';
    string private constant COLOR_12 = 'hsl(218, 15%, 14%)';
    string private constant COLOR_13 = 'hsl(240, 2%, 26%)';
    string private constant COLOR_14 = 'hsl(240, 1%, 28%)';
    string private constant COLOR_15 = 'hsl(225, 7%, 21%)';
    string private constant COLOR_16 = 'hsl(220, 16%, 11%)';
    string private constant COLOR_17 = 'hsl(40, 2%, 35%)';
    string private constant COLOR_18 = 'hsl(36, 2%, 40%)';
    string private constant COLOR_19 = 'hsl(32, 6%, 55%)';
    string private constant COLOR_20 = 'hsl(43, 3%, 40%)';
    string private constant COLOR_21 = 'hsl(30, 1%, 35%)';
    string private constant COLOR_22 = 'hsl(270, 1%, 28%)';
    string private constant COLOR_23 = 'hsl(225, 4%, 22%)';
    string private constant COLOR_24 = 'hsl(33, 4%, 53%)';
    string private constant COLOR_25 = 'hsl(218, 18%, 12%)';
    string private constant COLOR_26 = 'hsl(225, 7%, 22%)';
    string private constant COLOR_27 = 'hsl(0, 1%, 35%)';
    string private constant COLOR_28 = 'hsl(216, 3%, 29%)';
    string private constant COLOR_29 = 'hsl(210, 6%, 21%)';

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
            PART_30
        );
        return result;
    }
}
