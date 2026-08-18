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
    string private constant PART_26 = ';"/><path d="M22 116 L23 118 L20 120 L28 120 L27 125 L16 125 L16 121 L14 121 L14 119 L19 119 L19 117 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M75 111 L86 111 L86 114 L83 117 L75 117 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M85 99 L87 101 L87 105 L72 105 L76 104 L77 101 L83 100 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M29 133 L30 133 L30 143 L33 144 L35 149 L37 149 L36 151 L33 149 L32 154 L22 153 L22 152 L31 152 L30 145 L29 144 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M43 123 L46 123 L44 133 L40 133 L40 126 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M46 123 L57 123 L59 124 L59 126 L45 127 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M25 135 L29 135 L27 140 L22 142 L22 140 L16 140 L16 139 L23 139 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M63 119 L69 119 L71 121 L70 125 L64 123 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M24 112 L25 112 L25 117 L19 117 L19 119 L15 118 L15 115 L23 113 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M72 153 L75 155 L73 161 L69 161 L69 155 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M35 124 L37 124 L37 126 L39 126 L39 136 L36 135 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M27 115 L28 117 L34 116 L31 121 L29 121 L29 126 L28 126 L26 117 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M43 139 L55 139 L55 141 L49 142 L48 144 L48 141 L43 140 Z" style="fill:';
    string private constant PART_39 = ';"/><path d="M16 129 L18 129 L18 132 L20 132 L20 136 L22 137 L16 137 Z" style="fill:';
    string private constant PART_40 = ';"/><path d="M46 126 L55 126 L60 127 L57 129 L55 132 L55 130 L52 131 L53 128 L46 127 Z" style="fill:';
    string private constant PART_41 = ';"/><path d="M31 108 L43 108 L43 109 L32 110 L27 114 L25 114 L25 112 Z" style="fill:';
    string private constant PART_42 = ';"/><path d="M15 139 L22 140 L20 144 L16 144 Z" style="fill:';
    string private constant PART_43 = ';"/><path d="M74 127 L78 127 L78 131 L78 133 L73 133 L73 128 Z" style="fill:';
    string private constant PART_44 = ';"/><path d="M23 116 L27 120 L27 121 L17 121 L21 118 L23 118 Z" style="fill:';
    string private constant PART_45 = ';"/><path d="M29 147 L31 148 L31 152 L22 152 L23 150 L29 150 Z" style="fill:';
    string private constant PART_46 = ';"/><path d="M51 103 L54 103 L54 107 L46 108 Z" style="fill:';
    string private constant PART_47 = ';"/><path d="M4 145 L9 145 L9 148 L2 149 L2 146 Z" style="fill:';
    string private constant PART_48 = ';"/><path d="M44 118 L50 118 L50 121 L43 121 Z" style="fill:';
    string private constant PART_49 = ';"/><path d="M62 120 L67 124 L68 122 L68 124 L70 124 L70 126 L65 126 L62 123 Z" style="fill:';
    string private constant PART_50 = ';"/><path d="M12 120 L16 121 L16 125 L13 126 L12 125 Z" style="fill:';
    string private constant PART_51 = ';"/><path d="M11 146 L15 146 L15 150 L10 149 Z" style="fill:';
    string private constant PART_52 = ';"/><path d="M56 129 L60 129 L60 133 L55 133 Z" style="fill:';
    string private constant PART_53 = ';"/>';
    string private constant COLOR_1 = 'hsl(223, 8%, 18%)';
    string private constant COLOR_2 = 'hsl(30, 5%, 35%)';
    string private constant COLOR_3 = 'hsl(222, 15%, 13%)';
    string private constant COLOR_4 = 'hsl(218, 20%, 11%)';
    string private constant COLOR_5 = 'hsl(35, 11%, 53%)';
    string private constant COLOR_6 = 'hsl(33, 5%, 36%)';
    string private constant COLOR_7 = 'hsl(225, 4%, 22%)';
    string private constant COLOR_8 = 'hsl(213, 15%, 14%)';
    string private constant COLOR_9 = 'hsl(215, 18%, 13%)';
    string private constant COLOR_10 = 'hsl(37, 9%, 47%)';
    string private constant COLOR_11 = 'hsl(216, 21%, 9%)';
    string private constant COLOR_12 = 'hsl(28, 6%, 41%)';
    string private constant COLOR_13 = 'hsl(220, 16%, 11%)';
    string private constant COLOR_14 = 'hsl(223, 7%, 20%)';
    string private constant COLOR_15 = 'hsl(223, 8%, 17%)';
    string private constant COLOR_16 = 'hsl(26, 4%, 31%)';
    string private constant COLOR_17 = 'hsl(240, 4%, 23%)';
    string private constant COLOR_18 = 'hsl(220, 13%, 14%)';
    string private constant COLOR_19 = 'hsl(213, 17%, 12%)';
    string private constant COLOR_20 = 'hsl(33, 6%, 37%)';
    string private constant COLOR_21 = 'hsl(33, 14%, 58%)';
    string private constant COLOR_22 = 'hsl(220, 12%, 15%)';
    string private constant COLOR_23 = 'hsl(223, 11%, 13%)';
    string private constant COLOR_24 = 'hsl(196, 38%, 27%)';
    string private constant COLOR_25 = 'hsl(240, 2%, 25%)';
    string private constant COLOR_26 = 'hsl(33, 5%, 35%)';
    string private constant COLOR_27 = 'hsl(34, 10%, 52%)';
    string private constant COLOR_28 = 'hsl(240, 2%, 24%)';
    string private constant COLOR_29 = 'hsl(218, 24%, 9%)';
    string private constant COLOR_30 = 'hsl(33, 5%, 42%)';
    string private constant COLOR_31 = 'hsl(20, 2%, 30%)';
    string private constant COLOR_32 = 'hsl(17, 3%, 40%)';
    string private constant COLOR_33 = 'hsl(20, 2%, 30%)';
    string private constant COLOR_34 = 'hsl(240, 3%, 20%)';
    string private constant COLOR_35 = 'hsl(225, 4%, 22%)';
    string private constant COLOR_36 = 'hsl(240, 2%, 22%)';
    string private constant COLOR_37 = 'hsl(35, 14%, 61%)';
    string private constant COLOR_38 = 'hsl(228, 5%, 21%)';
    string private constant COLOR_39 = 'hsl(194, 37%, 43%)';
    string private constant COLOR_40 = 'hsl(34, 7%, 46%)';
    string private constant COLOR_41 = 'hsl(216, 23%, 9%)';
    string private constant COLOR_42 = 'hsl(240, 2%, 25%)';
    string private constant COLOR_43 = 'hsl(30, 3%, 37%)';
    string private constant COLOR_44 = 'hsl(35, 12%, 59%)';
    string private constant COLOR_45 = 'hsl(220, 12%, 15%)';
    string private constant COLOR_46 = 'hsl(0, 1%, 32%)';
    string private constant COLOR_47 = 'hsl(345, 3%, 26%)';
    string private constant COLOR_48 = 'hsl(30, 4%, 38%)';
    string private constant COLOR_49 = 'hsl(216, 6%, 17%)';
    string private constant COLOR_50 = 'hsl(220, 3%, 23%)';
    string private constant COLOR_51 = 'hsl(8, 20%, 30%)';
    string private constant COLOR_52 = 'hsl(270, 1%, 29%)';

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
        return result;
    }
}
