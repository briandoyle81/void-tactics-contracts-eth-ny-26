// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderFore2SelfTest {
    string private constant PART_1 = '<path d="M52 99 L86 99 L89 103 L89 106 L91 106 L91 116 L87 120 L85 120 L84 149 L82 152 L81 159 L79 159 L77 163 L73 164 L41 164 L37 161 L37 159 L35 159 L31 154 L9 151 L4 151 L2 149 L2 146 L9 145 L13 145 L13 132 L10 128 L10 120 L13 119 L15 115 L23 113 L31 108 L44 108 L44 106 L47 103 L49 103 L49 101 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M32 109 L89 109 L87 113 L82 119 L81 145 L69 146 L68 145 L56 145 L56 141 L63 136 L65 127 L69 126 L70 124 L65 124 L63 122 L58 123 L55 121 L43 121 L43 123 L37 126 L37 124 L35 124 L36 126 L36 135 L33 131 L32 142 L31 142 L30 128 L28 126 L27 121 L14 121 L14 119 L19 119 L19 117 L24 116 L28 112 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M89 106 L91 106 L91 116 L87 120 L85 120 L84 149 L82 152 L81 159 L79 159 L77 163 L73 164 L41 164 L38 162 L39 159 L43 162 L68 163 L68 153 L40 154 L33 146 L33 145 L39 145 L40 143 L40 145 L55 145 L55 141 L48 143 L48 141 L43 140 L43 139 L58 138 L62 134 L62 126 L60 123 L62 123 L63 120 L67 124 L68 122 L68 124 L70 124 L69 127 L65 127 L64 136 L58 141 L56 141 L56 145 L69 144 L69 146 L71 145 L81 145 L81 119 L89 109 L84 109 L84 108 L89 108 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M55 119 L62 125 L63 126 L63 134 L58 139 L44 140 L49 142 L55 141 L55 145 L33 145 L30 143 L30 128 L34 130 L35 126 L35 124 L38 125 L43 123 L43 121 L55 121 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M31 110 L37 111 L37 115 L39 111 L72 111 L74 112 L74 119 L72 119 L72 121 L63 120 L62 123 L57 122 L55 121 L43 121 L43 123 L37 126 L37 124 L35 124 L36 126 L36 135 L33 131 L32 142 L31 142 L30 128 L28 126 L27 121 L14 121 L14 119 L19 119 L19 117 L24 116 L28 112 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M16 128 L24 128 L24 135 L29 135 L30 144 L32 147 L32 154 L9 151 L4 151 L2 149 L2 146 L9 145 L13 145 L13 132 L12 129 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M89 106 L91 106 L91 116 L87 120 L85 120 L84 149 L82 152 L81 159 L79 159 L77 163 L73 164 L41 164 L38 162 L39 159 L43 162 L68 163 L68 153 L40 154 L39 152 L79 152 L80 147 L81 119 L89 109 L84 109 L84 108 L89 108 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M32 148 L41 153 L68 153 L68 163 L43 163 L39 160 L37 161 L37 159 L35 159 L32 156 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M39 111 L72 111 L74 112 L74 117 L36 117 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M73 125 L78 125 L79 126 L79 137 L81 145 L69 146 L68 145 L56 145 L56 141 L64 136 L70 140 L74 142 L75 139 L77 139 L77 137 L73 136 L72 134 L72 127 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M85 99 L87 101 L87 105 L60 106 L56 108 L55 107 L46 108 L52 101 L53 100 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M35 124 L37 124 L37 126 L39 126 L39 137 L41 137 L41 139 L48 141 L51 141 L55 141 L55 145 L33 145 L30 143 L30 128 L34 130 L35 126 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M43 123 L57 123 L59 124 L59 126 L55 127 L60 127 L56 128 L60 129 L60 133 L55 134 L45 134 L40 133 L40 126 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M25 135 L29 135 L27 142 L26 146 L29 146 L29 150 L22 150 L21 145 L21 149 L16 148 L16 146 L19 146 L19 144 L14 143 L14 139 L23 139 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M31 110 L37 111 L36 116 L31 121 L29 121 L29 126 L28 126 L27 121 L14 121 L14 119 L19 119 L19 117 L24 116 L28 112 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M10 121 L12 121 L12 126 L29 126 L30 127 L30 143 L33 144 L35 149 L39 151 L36 151 L31 147 L29 144 L29 135 L23 136 L24 128 L11 129 L10 128 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M32 109 L89 109 L88 112 L75 111 L75 116 L74 112 L39 112 L37 116 L36 114 L37 111 L32 110 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M70 125 L72 126 L74 136 L77 137 L75 142 L72 142 L69 141 L64 137 L64 129 L65 127 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M39 155 L44 156 L68 156 L68 158 L64 158 L64 161 L42 161 L42 158 L38 157 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M15 115 L22 116 L19 117 L19 119 L14 119 L14 121 L28 120 L28 126 L12 126 L12 121 L10 120 L13 119 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M34 116 L56 116 L58 117 L74 118 L72 119 L72 121 L63 120 L62 123 L57 122 L55 121 L50 121 L50 118 L33 119 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M37 155 L38 158 L42 158 L42 161 L46 160 L64 161 L64 158 L68 158 L68 163 L43 163 L39 160 L37 161 L36 157 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M69 153 L80 153 L80 157 L78 157 L77 163 L74 163 L73 158 L73 161 L69 161 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M46 126 L55 126 L60 127 L56 128 L60 129 L60 133 L51 133 L47 133 L45 129 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M60 111 L72 111 L74 112 L74 117 L56 117 L60 115 L62 115 L62 112 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M87 112 L89 112 L88 116 L84 121 L83 145 L81 145 L81 119 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M40 133 L60 133 L58 134 L58 137 L56 138 L43 138 L40 135 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M53 100 L83 100 L81 102 L77 104 L69 103 L53 102 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M73 125 L78 125 L79 126 L79 134 L77 136 L73 136 L72 134 L72 127 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M16 128 L24 128 L24 135 L22 137 L16 137 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M41 123 L43 124 L41 126 L41 135 L43 137 L58 137 L58 134 L62 133 L62 127 L63 127 L63 134 L58 139 L41 139 L41 137 L39 137 L38 125 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M62 120 L67 124 L68 122 L68 124 L70 124 L69 127 L65 127 L64 136 L58 141 L56 140 L62 134 L62 126 L60 123 L62 123 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M75 111 L86 111 L86 114 L83 117 L75 117 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M31 110 L37 111 L36 116 L28 117 L28 115 L25 116 L25 114 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M52 101 L60 102 L58 108 L56 107 L55 107 L46 108 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M27 120 L28 120 L28 125 L16 125 L16 121 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M28 137 L29 137 L30 144 L32 148 L31 152 L24 152 L22 150 L29 150 L29 146 L26 146 L26 140 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M21 144 L22 144 L22 151 L31 152 L32 148 L32 154 L16 152 L17 148 L20 148 Z" style="fill:';
    string private constant PART_39 = ';"/><path d="M34 116 L56 116 L56 119 L55 121 L50 121 L50 118 L33 119 Z" style="fill:';
    string private constant PART_40 = ';"/><path d="M25 135 L29 135 L27 140 L22 141 L15 141 L15 139 L23 139 Z" style="fill:';
    string private constant PART_41 = ';"/><path d="M43 123 L46 123 L44 133 L40 133 L40 126 Z" style="fill:';
    string private constant PART_42 = ';"/><path d="M63 119 L69 119 L71 121 L71 124 L73 124 L72 127 L67 124 L63 122 Z" style="fill:';
    string private constant PART_43 = ';"/>';
    string private constant COLOR_1 = 'hsl(218, 12%, 13%)';
    string private constant COLOR_2 = 'hsl(36, 6%, 35%)';
    string private constant COLOR_3 = 'hsl(223, 7%, 19%)';
    string private constant COLOR_4 = 'hsl(225, 11%, 14%)';
    string private constant COLOR_5 = 'hsl(30, 5%, 38%)';
    string private constant COLOR_6 = 'hsl(230, 7%, 17%)';
    string private constant COLOR_7 = 'hsl(218, 23%, 9%)';
    string private constant COLOR_8 = 'hsl(225, 9%, 17%)';
    string private constant COLOR_9 = 'hsl(35, 11%, 53%)';
    string private constant COLOR_10 = 'hsl(26, 4%, 33%)';
    string private constant COLOR_11 = 'hsl(330, 1%, 27%)';
    string private constant COLOR_12 = 'hsl(20, 2%, 30%)';
    string private constant COLOR_13 = 'hsl(30, 1%, 28%)';
    string private constant COLOR_14 = 'hsl(220, 6%, 21%)';
    string private constant COLOR_15 = 'hsl(36, 11%, 55%)';
    string private constant COLOR_16 = 'hsl(215, 20%, 12%)';
    string private constant COLOR_17 = 'hsl(30, 5%, 31%)';
    string private constant COLOR_18 = 'hsl(33, 5%, 36%)';
    string private constant COLOR_19 = 'hsl(260, 2%, 24%)';
    string private constant COLOR_20 = 'hsl(240, 3%, 21%)';
    string private constant COLOR_21 = 'hsl(34, 4%, 36%)';
    string private constant COLOR_22 = 'hsl(220, 12%, 15%)';
    string private constant COLOR_23 = 'hsl(223, 8%, 18%)';
    string private constant COLOR_24 = 'hsl(33, 5%, 40%)';
    string private constant COLOR_25 = 'hsl(33, 14%, 58%)';
    string private constant COLOR_26 = 'hsl(225, 10%, 16%)';
    string private constant COLOR_27 = 'hsl(220, 11%, 17%)';
    string private constant COLOR_28 = 'hsl(30, 7%, 48%)';
    string private constant COLOR_29 = 'hsl(240, 3%, 21%)';
    string private constant COLOR_30 = 'hsl(195, 37%, 33%)';
    string private constant COLOR_31 = 'hsl(224, 20%, 11%)';
    string private constant COLOR_32 = 'hsl(240, 3%, 23%)';
    string private constant COLOR_33 = 'hsl(34, 10%, 52%)';
    string private constant COLOR_34 = 'hsl(34, 8%, 49%)';
    string private constant COLOR_35 = 'hsl(20, 2%, 33%)';
    string private constant COLOR_36 = 'hsl(26, 4%, 32%)';
    string private constant COLOR_37 = 'hsl(223, 8%, 17%)';
    string private constant COLOR_38 = 'hsl(215, 23%, 10%)';
    string private constant COLOR_39 = 'hsl(32, 8%, 31%)';
    string private constant COLOR_40 = 'hsl(20, 3%, 39%)';
    string private constant COLOR_41 = 'hsl(33, 5%, 42%)';
    string private constant COLOR_42 = 'hsl(20, 2%, 30%)';

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
            PART_43
        );
        return result;
    }
}
