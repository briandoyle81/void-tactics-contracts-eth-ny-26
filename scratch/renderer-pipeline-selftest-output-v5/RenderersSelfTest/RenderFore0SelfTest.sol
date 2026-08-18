// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderFore0SelfTest {
    string private constant PART_1 = '<path d="M56 104 L75 104 L77 108 L77 113 L84 114 L84 153 L79 157 L75 162 L67 162 L67 164 L42 164 L38 158 L35 156 L35 154 L27 154 L21 152 L21 150 L12 152 L9 149 L10 145 L12 143 L21 143 L23 141 L18 141 L17 139 L16 130 L15 129 L15 122 L19 120 L21 116 L37 116 L38 113 L49 112 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M60 121 L63 124 L64 134 L69 132 L72 133 L68 135 L70 144 L64 144 L63 140 L64 142 L66 140 L63 139 L62 138 L61 140 L48 141 L46 139 L44 141 L36 142 L36 144 L24 144 L23 151 L27 151 L27 146 L28 150 L30 150 L31 147 L31 152 L25 153 L21 152 L21 150 L12 152 L9 149 L10 145 L12 143 L21 143 L23 141 L18 141 L17 139 L17 123 L19 122 L30 122 L30 125 L32 126 L30 131 L32 131 L33 136 L34 135 L39 135 L39 131 L34 132 L35 129 L42 129 L42 136 L44 136 L44 131 L47 131 L49 135 L59 135 L61 132 L59 134 L49 134 L49 127 L60 127 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M39 115 L72 115 L72 120 L70 120 L70 123 L72 123 L72 127 L64 127 L61 123 L61 130 L60 127 L49 127 L49 134 L59 134 L60 131 L62 133 L59 136 L49 136 L45 132 L44 136 L42 136 L42 129 L35 130 L36 130 L40 131 L39 135 L34 135 L33 137 L32 136 L32 131 L30 131 L31 126 L29 123 L19 123 L21 119 L22 118 L37 118 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M70 134 L72 134 L72 148 L67 148 L67 151 L63 151 L63 148 L40 148 L39 149 L49 149 L49 153 L56 154 L62 159 L62 161 L54 161 L51 163 L44 162 L39 155 L27 153 L31 152 L30 150 L23 151 L23 144 L27 143 L36 144 L35 141 L44 140 L47 138 L48 141 L51 140 L61 140 L62 136 L64 137 L63 139 L67 140 L67 142 L64 143 L70 144 L67 137 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M55 117 L59 118 L57 119 L61 123 L61 130 L60 127 L49 127 L49 134 L59 134 L60 131 L62 133 L59 136 L49 136 L45 132 L44 136 L42 136 L42 129 L35 130 L36 130 L40 131 L39 135 L34 135 L33 137 L32 136 L32 131 L30 131 L31 126 L29 123 L19 123 L21 119 L22 118 L35 118 L35 121 L31 122 L33 123 L34 127 L43 128 L46 122 L48 120 L55 120 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M73 115 L81 115 L83 116 L83 143 L81 143 L80 145 L79 145 L78 148 L74 147 L73 146 L73 132 L75 128 L73 126 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M70 134 L72 134 L72 148 L67 148 L67 151 L63 151 L63 148 L42 148 L43 146 L38 143 L37 141 L44 140 L47 138 L48 141 L51 140 L61 140 L62 136 L64 137 L63 139 L67 140 L67 142 L64 143 L70 144 L67 137 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M39 147 L63 148 L63 151 L58 151 L58 153 L62 155 L67 164 L42 164 L38 158 L35 156 L35 154 L27 154 L27 153 L36 153 L47 154 L47 155 L40 156 L44 160 L44 162 L53 162 L54 159 L54 161 L62 161 L58 156 L49 153 L49 149 L39 149 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M56 104 L75 104 L75 113 L63 114 L52 113 L53 108 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M29 137 L33 138 L33 140 L44 140 L44 141 L36 142 L36 144 L24 144 L23 151 L27 151 L27 146 L28 150 L30 150 L31 147 L31 152 L25 153 L21 152 L21 150 L12 152 L9 149 L10 145 L12 143 L21 143 L25 141 L29 141 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M71 105 L76 105 L77 113 L81 114 L81 115 L39 116 L37 119 L22 119 L18 123 L17 130 L15 129 L15 122 L19 120 L21 116 L37 116 L38 113 L49 112 L52 110 L52 113 L75 113 L75 106 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M59 152 L80 152 L78 159 L75 162 L64 163 L64 160 L60 154 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M22 118 L35 118 L35 121 L31 122 L33 123 L34 127 L43 128 L42 131 L42 129 L35 130 L36 130 L40 131 L39 135 L34 135 L33 137 L32 136 L32 131 L30 131 L31 126 L29 123 L19 123 L21 119 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M82 114 L84 114 L84 153 L79 156 L79 153 L71 152 L73 148 L78 147 L79 145 L77 144 L83 143 L83 116 L81 115 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M24 143 L36 144 L39 151 L38 152 L31 152 L30 150 L23 151 L23 144 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M70 134 L72 134 L72 145 L56 145 L57 141 L61 140 L62 136 L64 137 L63 139 L67 140 L67 142 L64 143 L70 144 L67 137 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M39 147 L63 148 L63 151 L58 151 L62 157 L61 159 L56 155 L49 153 L49 149 L39 149 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M12 143 L22 144 L22 150 L12 152 L9 149 L10 145 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M48 154 L56 154 L62 159 L62 161 L54 161 L51 163 L44 162 L44 161 L50 160 L50 155 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M73 115 L79 116 L80 121 L80 127 L74 127 L73 126 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M49 127 L59 127 L59 134 L49 134 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M65 117 L72 117 L72 120 L70 120 L70 123 L72 123 L72 127 L64 127 L63 120 L65 119 L67 120 L67 118 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M56 115 L72 115 L72 117 L67 118 L67 120 L64 120 L64 125 L59 121 L56 118 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M39 115 L55 115 L55 116 L44 117 L43 120 L38 120 L38 124 L31 124 L31 122 L35 121 L35 119 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M47 123 L59 123 L61 125 L61 130 L60 127 L49 127 L49 129 L45 129 L46 124 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M18 122 L24 123 L24 133 L20 132 L17 130 L17 123 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M72 155 L75 157 L79 156 L76 161 L75 162 L64 163 L64 160 L63 157 L65 157 L65 159 L68 159 L66 157 L72 157 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M46 138 L48 139 L47 144 L52 142 L55 142 L55 145 L40 145 L37 141 L44 140 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M56 145 L72 145 L72 148 L67 148 L67 151 L63 151 L63 148 L58 148 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M22 118 L35 118 L32 119 L32 121 L29 123 L19 123 L21 119 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M69 132 L72 133 L68 135 L70 144 L64 144 L63 140 L64 142 L66 140 L63 139 L65 133 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M39 121 L41 121 L41 123 L45 123 L44 129 L32 128 L33 124 L39 123 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M39 155 L50 155 L50 160 L52 161 L44 161 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M24 122 L25 122 L25 134 L28 134 L28 128 L29 128 L29 136 L19 134 L19 139 L17 139 L17 130 L21 132 L24 133 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M44 131 L47 131 L49 137 L46 137 L45 140 L34 140 L38 137 L44 136 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M61 106 L68 106 L68 113 L61 113 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M19 134 L24 135 L27 137 L27 142 L18 141 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M55 117 L59 118 L57 119 L61 123 L61 125 L48 123 L48 120 L55 120 Z" style="fill:';
    string private constant PART_39 = ';"/><path d="M73 140 L80 140 L79 147 L75 148 L73 146 Z" style="fill:';
    string private constant PART_40 = ';"/><path d="M35 129 L42 129 L42 136 L40 138 L40 139 L34 139 L36 135 L39 135 L39 131 L34 132 Z" style="fill:';
    string private constant PART_41 = ';"/><path d="M69 106 L75 106 L75 113 L69 113 Z" style="fill:';
    string private constant PART_42 = ';"/><path d="M80 133 L82 133 L83 135 L83 143 L81 143 L80 145 L79 141 L73 140 L74 138 L80 139 Z" style="fill:';
    string private constant PART_43 = ';"/><path d="M12 143 L22 144 L22 147 L12 148 L11 144 Z" style="fill:';
    string private constant PART_44 = ';"/><path d="M59 152 L64 152 L66 156 L72 155 L72 157 L68 158 L71 160 L65 159 L65 157 L61 155 Z" style="fill:';
    string private constant PART_45 = ';"/><path d="M45 135 L48 137 L60 137 L62 136 L61 140 L48 141 L45 137 Z" style="fill:';
    string private constant PART_46 = ';"/><path d="M25 123 L29 123 L28 134 L25 134 Z" style="fill:';
    string private constant PART_47 = ';"/>';
    string private constant COLOR_1 = 'hsl(225, 9%, 18%)';
    string private constant COLOR_2 = 'hsl(210, 8%, 20%)';
    string private constant COLOR_3 = 'hsl(33, 5%, 36%)';
    string private constant COLOR_4 = 'hsl(222, 10%, 19%)';
    string private constant COLOR_5 = 'hsl(204, 3%, 29%)';
    string private constant COLOR_6 = 'hsl(210, 5%, 26%)';
    string private constant COLOR_7 = 'hsl(320, 3%, 22%)';
    string private constant COLOR_8 = 'hsl(218, 13%, 12%)';
    string private constant COLOR_9 = 'hsl(216, 5%, 19%)';
    string private constant COLOR_10 = 'hsl(220, 15%, 12%)';
    string private constant COLOR_11 = 'hsl(225, 8%, 9%)';
    string private constant COLOR_12 = 'hsl(218, 7%, 24%)';
    string private constant COLOR_13 = 'hsl(196, 12%, 32%)';
    string private constant COLOR_14 = 'hsl(225, 13%, 12%)';
    string private constant COLOR_15 = 'hsl(213, 8%, 23%)';
    string private constant COLOR_16 = 'hsl(120, 1%, 36%)';
    string private constant COLOR_17 = 'hsl(218, 15%, 10%)';
    string private constant COLOR_18 = 'hsl(223, 8%, 18%)';
    string private constant COLOR_19 = 'hsl(216, 11%, 17%)';
    string private constant COLOR_20 = 'hsl(60, 3%, 42%)';
    string private constant COLOR_21 = 'hsl(7, 16%, 21%)';
    string private constant COLOR_22 = 'hsl(150, 1%, 31%)';
    string private constant COLOR_23 = 'hsl(45, 5%, 48%)';
    string private constant COLOR_24 = 'hsl(42, 5%, 49%)';
    string private constant COLOR_25 = 'hsl(49, 5%, 46%)';
    string private constant COLOR_26 = 'hsl(214, 5%, 25%)';
    string private constant COLOR_27 = 'hsl(214, 7%, 19%)';
    string private constant COLOR_28 = 'hsl(180, 1%, 35%)';
    string private constant COLOR_29 = 'hsl(216, 8%, 24%)';
    string private constant COLOR_30 = 'hsl(48, 4%, 45%)';
    string private constant COLOR_31 = 'hsl(200, 2%, 26%)';
    string private constant COLOR_32 = 'hsl(60, 1%, 42%)';
    string private constant COLOR_33 = 'hsl(222, 8%, 24%)';
    string private constant COLOR_34 = 'hsl(225, 14%, 11%)';
    string private constant COLOR_35 = 'hsl(218, 7%, 23%)';
    string private constant COLOR_36 = 'hsl(10, 4%, 32%)';
    string private constant COLOR_37 = 'hsl(210, 7%, 23%)';
    string private constant COLOR_38 = 'hsl(210, 1%, 32%)';
    string private constant COLOR_39 = 'hsl(180, 3%, 31%)';
    string private constant COLOR_40 = 'hsl(223, 10%, 14%)';
    string private constant COLOR_41 = 'hsl(220, 2%, 30%)';
    string private constant COLOR_42 = 'hsl(210, 7%, 22%)';
    string private constant COLOR_43 = 'hsl(180, 1%, 28%)';
    string private constant COLOR_44 = 'hsl(214, 5%, 26%)';
    string private constant COLOR_45 = 'hsl(223, 13%, 11%)';
    string private constant COLOR_46 = 'hsl(218, 6%, 26%)';

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
            PART_47
        );
        return result;
    }
}
