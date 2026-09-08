// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderFore1SelfTest {
    string private constant PART_1 = '<path d="M54 101 L72 101 L72 103 L75 104 L77 110 L87 110 L87 121 L86 122 L85 154 L81 156 L80 161 L78 163 L73 165 L72 167 L40 167 L33 160 L29 159 L25 155 L12 153 L11 152 L10 145 L7 140 L7 131 L5 131 L4 128 L4 121 L12 114 L28 114 L32 110 L47 110 L49 106 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M54 101 L72 101 L72 103 L75 104 L77 110 L87 110 L87 121 L86 122 L85 154 L81 156 L80 161 L78 163 L73 165 L72 167 L40 167 L33 160 L29 159 L25 155 L12 153 L11 152 L10 145 L8 142 L7 131 L5 131 L4 128 L4 121 L12 114 L28 114 L32 110 L47 110 L49 106 Z M33 112 L31 113 L31 115 L27 117 L26 118 L25 116 L12 116 L7 120 L7 129 L11 130 L9 134 L10 143 L12 144 L24 143 L24 130 L19 129 L24 128 L25 145 L32 152 L34 153 L82 153 L83 145 L82 127 L80 126 L80 125 L82 125 L84 119 L86 115 L86 112 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M33 112 L86 112 L85 118 L83 120 L82 125 L80 125 L80 126 L82 127 L82 145 L80 145 L79 132 L76 129 L76 132 L71 132 L72 135 L71 138 L78 137 L79 141 L78 145 L72 145 L72 143 L68 145 L56 145 L59 140 L60 132 L69 131 L68 128 L66 129 L62 128 L62 125 L64 125 L62 123 L60 125 L57 122 L54 122 L53 119 L59 118 L62 120 L65 119 L72 119 L72 116 L68 116 L67 118 L62 117 L54 117 L50 118 L50 121 L52 121 L52 124 L34 124 L33 121 L33 127 L36 125 L56 125 L56 127 L58 128 L57 136 L55 135 L54 131 L53 136 L52 137 L38 137 L37 139 L33 137 L35 142 L36 144 L33 144 L33 146 L29 145 L26 143 L26 131 L26 129 L26 118 L29 115 L31 115 L31 113 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M48 112 L86 112 L85 118 L83 120 L82 125 L80 125 L80 126 L82 127 L82 145 L80 145 L79 132 L76 129 L76 132 L71 132 L72 135 L71 138 L78 137 L79 141 L78 145 L72 145 L72 143 L68 145 L56 145 L59 140 L60 132 L69 131 L69 123 L71 123 L71 121 L75 120 L77 115 L48 114 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M33 112 L47 112 L47 114 L77 114 L79 116 L75 120 L78 121 L71 121 L71 123 L68 123 L68 128 L66 129 L62 128 L62 125 L64 125 L62 123 L60 125 L57 122 L54 122 L53 119 L59 118 L62 120 L65 119 L72 119 L72 116 L68 116 L67 118 L62 117 L54 117 L50 118 L50 121 L52 121 L52 124 L34 124 L33 121 L28 122 L28 118 L29 115 L31 115 L31 113 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M12 116 L25 116 L24 128 L19 129 L24 130 L24 143 L11 144 L9 140 L9 134 L11 130 L7 129 L7 120 Z M7 140 L9 140 L8 142 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M67 115 L72 116 L72 119 L66 120 L62 121 L57 119 L54 120 L59 123 L61 123 L64 123 L64 125 L62 125 L62 128 L67 128 L68 123 L69 123 L69 131 L67 132 L60 132 L60 140 L55 146 L54 144 L43 144 L43 142 L36 142 L32 139 L32 133 L34 137 L37 139 L38 136 L52 136 L53 131 L54 128 L55 128 L56 135 L57 128 L56 125 L36 126 L32 128 L32 121 L34 119 L34 124 L52 124 L52 121 L50 121 L49 117 L54 116 L62 116 L67 118 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M27 117 L30 119 L29 121 L32 122 L34 131 L36 128 L42 128 L41 132 L39 132 L39 129 L38 131 L37 139 L33 137 L35 142 L36 144 L33 144 L33 146 L29 145 L26 143 L26 131 L26 129 L26 118 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M24 120 L25 120 L26 147 L25 148 L26 152 L28 153 L28 155 L12 153 L11 152 L10 145 L8 142 L10 140 L12 143 L24 143 L24 130 L20 130 L20 138 L19 138 L19 129 L17 128 L24 128 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M12 116 L25 116 L24 128 L7 128 L7 120 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M37 154 L43 155 L44 157 L62 157 L62 159 L65 160 L63 162 L57 161 L57 162 L45 163 L41 165 L37 164 L33 159 L35 159 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M66 114 L77 114 L79 116 L75 120 L78 121 L71 121 L71 123 L68 123 L68 128 L66 129 L62 128 L62 125 L64 125 L62 123 L60 125 L57 122 L54 122 L53 119 L59 118 L62 120 L65 119 L72 119 L72 116 L68 116 L67 118 L62 117 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M55 103 L70 103 L71 104 L71 110 L48 110 L49 108 L51 108 L53 104 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M48 112 L86 112 L85 118 L83 120 L82 125 L80 125 L80 119 L75 120 L77 115 L48 114 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M24 119 L26 119 L26 129 L28 130 L27 131 L27 143 L33 146 L33 144 L35 143 L33 140 L41 141 L44 142 L44 143 L54 144 L54 146 L35 147 L33 152 L26 146 L25 145 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M32 110 L35 112 L31 113 L31 115 L25 119 L25 116 L12 117 L8 120 L7 129 L12 129 L10 134 L9 140 L8 140 L7 131 L5 131 L4 128 L4 121 L12 114 L28 114 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M36 125 L56 125 L56 127 L58 128 L57 136 L55 135 L55 128 L36 129 L35 134 L33 131 L33 127 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M53 102 L55 102 L55 104 L49 109 L74 111 L74 112 L48 112 L47 114 L47 112 L35 112 L33 110 L47 110 L49 106 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M78 119 L79 119 L80 126 L82 127 L82 145 L80 145 L79 132 L78 132 L77 126 L71 126 L71 121 L78 121 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M55 118 L60 119 L68 121 L68 128 L66 129 L62 128 L62 125 L64 125 L62 123 L60 125 L57 122 L54 122 L53 119 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M20 130 L24 130 L24 142 L12 142 L12 140 L19 138 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M44 157 L62 157 L62 159 L65 160 L63 162 L59 161 L44 160 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M67 154 L77 154 L77 160 L68 161 L67 158 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M30 131 L31 131 L31 139 L33 139 L36 144 L33 144 L33 146 L29 145 L28 144 L28 133 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M43 118 L44 120 L48 120 L48 118 L50 118 L50 121 L52 121 L52 124 L34 124 L34 122 L43 122 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M60 132 L63 132 L63 134 L67 134 L67 137 L63 137 L62 145 L56 145 L59 140 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M32 110 L35 112 L31 113 L31 115 L25 119 L25 116 L11 117 L10 115 L12 114 L28 114 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M12 130 L18 130 L18 138 L17 139 L11 139 L12 136 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M27 117 L30 119 L29 121 L32 122 L31 129 L26 129 L26 118 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M44 155 L66 155 L66 158 L44 157 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M52 118 L53 118 L53 123 L56 124 L56 125 L36 126 L32 128 L32 121 L34 119 L34 124 L52 124 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M77 156 L78 156 L79 162 L74 164 L67 164 L68 160 L77 160 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M55 103 L70 103 L70 105 L55 105 L54 108 L50 109 L53 104 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M80 126 L82 127 L82 145 L80 145 L79 132 L79 129 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M32 114 L37 114 L35 120 L32 122 L28 121 L28 118 L29 115 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M37 129 L39 129 L39 132 L41 132 L41 129 L46 129 L42 130 L43 137 L38 137 L37 136 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M86 118 L87 121 L86 122 L85 153 L84 153 L84 119 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M81 112 L86 112 L85 118 L83 120 L82 125 L80 125 Z" style="fill:';
    string private constant PART_39 = ';"/><path d="M33 112 L47 112 L47 114 L39 115 L35 118 L36 115 L31 115 L31 113 Z" style="fill:';
    string private constant PART_40 = ';"/><path d="M36 128 L42 128 L41 132 L39 132 L39 129 L38 131 L37 139 L33 137 L33 135 L35 135 L35 129 Z" style="fill:';
    string private constant PART_41 = ';"/>';
    string private constant COLOR_1 = 'hsl(227, 8%, 21%)';
    string private constant COLOR_2 = 'hsl(220, 12%, 15%)';
    string private constant COLOR_3 = 'hsl(36, 3%, 36%)';
    string private constant COLOR_4 = 'hsl(30, 1%, 35%)';
    string private constant COLOR_5 = 'hsl(34, 6%, 53%)';
    string private constant COLOR_6 = 'hsl(206, 23%, 18%)';
    string private constant COLOR_7 = 'hsl(220, 6%, 19%)';
    string private constant COLOR_8 = 'hsl(240, 1%, 29%)';
    string private constant COLOR_9 = 'hsl(218, 10%, 16%)';
    string private constant COLOR_10 = 'hsl(30, 4%, 44%)';
    string private constant COLOR_11 = 'hsl(225, 7%, 21%)';
    string private constant COLOR_12 = 'hsl(33, 4%, 50%)';
    string private constant COLOR_13 = 'hsl(228, 4%, 23%)';
    string private constant COLOR_14 = 'hsl(34, 3%, 40%)';
    string private constant COLOR_15 = 'hsl(240, 3%, 26%)';
    string private constant COLOR_16 = 'hsl(218, 12%, 13%)';
    string private constant COLOR_17 = 'hsl(34, 3%, 49%)';
    string private constant COLOR_18 = 'hsl(206, 19%, 7%)';
    string private constant COLOR_19 = 'hsl(0, 1%, 30%)';
    string private constant COLOR_20 = 'hsl(0, 1%, 35%)';
    string private constant COLOR_21 = 'hsl(216, 3%, 29%)';
    string private constant COLOR_22 = 'hsl(240, 3%, 28%)';
    string private constant COLOR_23 = 'hsl(225, 7%, 23%)';
    string private constant COLOR_24 = 'hsl(20, 2%, 37%)';
    string private constant COLOR_25 = 'hsl(30, 3%, 39%)';
    string private constant COLOR_26 = 'hsl(300, 1%, 30%)';
    string private constant COLOR_27 = 'hsl(230, 7%, 17%)';
    string private constant COLOR_28 = 'hsl(199, 36%, 42%)';
    string private constant COLOR_29 = 'hsl(36, 3%, 38%)';
    string private constant COLOR_30 = 'hsl(218, 8%, 20%)';
    string private constant COLOR_31 = 'hsl(220, 8%, 16%)';
    string private constant COLOR_32 = 'hsl(216, 12%, 17%)';
    string private constant COLOR_33 = 'hsl(20, 1%, 39%)';
    string private constant COLOR_34 = 'hsl(228, 4%, 27%)';
    string private constant COLOR_35 = 'hsl(34, 6%, 56%)';
    string private constant COLOR_36 = 'hsl(24, 2%, 44%)';
    string private constant COLOR_37 = 'hsl(213, 20%, 11%)';
    string private constant COLOR_38 = 'hsl(240, 1%, 30%)';
    string private constant COLOR_39 = 'hsl(30, 4%, 38%)';
    string private constant COLOR_40 = 'hsl(0, 0%, 24%)';

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
            PART_41
        );
        return result;
    }
}
