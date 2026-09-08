// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderShield2SelfTest {
    string private constant PART_1 = '<path d="M127 103 L165 103 L169 106 L169 111 L181 111 L181 145 L177 152 L175 152 L175 158 L164 158 L164 160 L160 161 L160 163 L153 165 L144 165 L143 164 L142 166 L139 166 L138 164 L134 165 L132 164 L132 162 L127 160 L126 159 L115 158 L110 153 L101 153 L100 154 L86 154 L85 151 L79 151 L79 113 L83 110 L95 109 L97 105 L112 105 L115 107 L115 109 L121 109 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M81 112 L82 112 L83 121 L86 122 L85 139 L84 144 L84 146 L84 148 L108 148 L108 141 L109 145 L119 145 L120 143 L120 148 L123 148 L122 144 L164 144 L164 145 L143 145 L143 148 L166 148 L167 145 L167 148 L172 148 L173 145 L177 141 L179 141 L180 133 L174 133 L173 132 L173 125 L175 123 L180 123 L180 118 L181 118 L181 145 L177 152 L175 152 L175 158 L164 158 L164 160 L160 161 L160 163 L153 165 L144 165 L143 164 L142 166 L139 166 L138 164 L134 165 L132 164 L132 162 L127 160 L126 159 L115 158 L110 153 L101 153 L100 154 L86 154 L85 151 L79 151 L79 113 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M123 115 L166 115 L166 142 L165 144 L121 144 L120 142 L120 116 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M81 112 L82 112 L83 121 L86 122 L85 139 L84 144 L84 146 L84 148 L108 148 L108 141 L109 141 L109 148 L118 148 L116 149 L117 154 L129 155 L129 157 L127 158 L115 158 L110 153 L101 153 L100 154 L86 154 L85 151 L79 151 L79 113 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M180 118 L181 118 L181 145 L177 152 L175 152 L175 158 L164 158 L164 160 L159 161 L163 157 L164 153 L162 153 L163 149 L149 150 L140 149 L143 147 L166 148 L167 145 L167 148 L172 148 L173 145 L177 141 L179 141 L180 133 L174 133 L173 132 L173 125 L175 123 L180 123 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M87 122 L111 122 L112 123 L112 136 L110 132 L111 125 L108 125 L109 133 L107 129 L107 127 L101 127 L101 125 L99 125 L100 133 L99 138 L109 138 L110 136 L111 139 L87 139 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M82 111 L93 111 L103 112 L103 115 L88 116 L89 116 L103 116 L103 119 L112 120 L113 122 L113 138 L112 138 L111 123 L87 122 L87 139 L85 139 L85 122 L83 121 L83 138 L82 138 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M130 105 L164 105 L164 111 L126 111 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M155 115 L164 115 L164 143 L159 143 L158 128 L156 143 L155 143 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M130 149 L138 149 L138 151 L157 152 L157 157 L136 157 L135 160 L131 159 L130 158 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M99 125 L101 125 L101 127 L107 127 L108 128 L108 125 L111 125 L111 132 L112 140 L87 140 L87 139 L109 138 L99 138 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M127 103 L165 103 L168 107 L164 106 L164 104 L128 105 L123 111 L125 112 L124 114 L132 114 L132 115 L115 116 L115 115 L120 115 L120 112 L113 111 L112 108 L97 107 L97 105 L112 105 L115 107 L115 109 L121 109 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M130 115 L135 115 L135 143 L130 143 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M147 115 L152 115 L152 143 L147 143 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M99 107 L112 107 L113 111 L120 112 L120 115 L112 116 L112 119 L104 119 L104 112 L99 111 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M82 139 L101 140 L101 144 L99 144 L99 148 L84 148 L82 145 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M123 115 L128 115 L128 143 L126 143 L126 128 L124 128 L124 143 L123 143 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M87 112 L103 112 L103 115 L88 116 L89 116 L103 116 L103 119 L84 119 L84 114 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M135 156 L136 156 L136 161 L154 160 L156 162 L154 162 L153 165 L144 165 L143 164 L142 166 L139 166 L138 164 L134 165 L132 164 L132 162 L127 160 L131 159 L135 160 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M155 115 L160 115 L160 143 L159 143 L158 128 L156 143 L155 143 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M113 117 L119 117 L119 138 L115 138 L115 121 L113 121 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M180 118 L181 118 L181 140 L179 141 L180 133 L174 133 L173 132 L173 125 L175 123 L180 123 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M172 118 L180 118 L180 123 L174 125 L174 132 L179 134 L178 138 L177 139 L172 139 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M167 117 L171 117 L171 139 L167 139 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M175 133 L180 133 L180 139 L175 145 L172 148 L167 148 L167 140 L177 138 L179 134 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M120 116 L123 116 L123 144 L121 144 L120 142 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M143 115 L144 115 L144 143 L141 143 L141 118 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M97 122 L111 122 L112 123 L112 136 L110 132 L111 125 L108 125 L109 133 L107 129 L107 127 L101 127 L101 125 L98 126 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M178 146 L180 147 L177 152 L175 152 L175 158 L167 158 L167 149 L176 149 L176 147 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M96 106 L99 107 L99 111 L105 111 L104 115 L106 116 L104 116 L103 118 L103 116 L91 117 L89 116 L89 118 L85 116 L85 115 L103 115 L103 112 L93 112 L83 111 L83 110 L95 109 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M165 143 L166 143 L166 148 L143 148 L143 145 L164 144 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M94 125 L98 125 L98 133 L94 135 L92 130 L90 135 L92 135 L92 138 L88 138 L89 127 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M136 157 L157 157 L153 159 L153 161 L136 161 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M158 152 L164 153 L163 158 L160 161 L160 163 L154 163 L153 160 L151 158 L157 157 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M116 149 L129 149 L129 154 L116 154 Z" style="fill:';
    string private constant PART_36 = ';"/>';
    string private constant COLOR_1 = 'hsl(180, 2%, 18%)';
    string private constant COLOR_2 = 'hsl(206, 9%, 15%)';
    string private constant COLOR_3 = 'hsl(200, 81%, 37%)';
    string private constant COLOR_4 = 'hsl(204, 10%, 10%)';
    string private constant COLOR_5 = 'hsl(200, 15%, 8%)';
    string private constant COLOR_6 = 'hsl(210, 12%, 10%)';
    string private constant COLOR_7 = 'hsl(48, 5%, 36%)';
    string private constant COLOR_8 = 'hsl(45, 7%, 36%)';
    string private constant COLOR_9 = 'hsl(195, 64%, 46%)';
    string private constant COLOR_10 = 'hsl(60, 1%, 26%)';
    string private constant COLOR_11 = 'hsl(201, 27%, 25%)';
    string private constant COLOR_12 = 'hsl(197, 15%, 9%)';
    string private constant COLOR_13 = 'hsl(192, 64%, 51%)';
    string private constant COLOR_14 = 'hsl(193, 62%, 51%)';
    string private constant COLOR_15 = 'hsl(44, 7%, 42%)';
    string private constant COLOR_16 = 'hsl(216, 5%, 18%)';
    string private constant COLOR_17 = 'hsl(191, 70%, 55%)';
    string private constant COLOR_18 = 'hsl(44, 8%, 45%)';
    string private constant COLOR_19 = 'hsl(200, 15%, 8%)';
    string private constant COLOR_20 = 'hsl(190, 71%, 59%)';
    string private constant COLOR_21 = 'hsl(42, 6%, 34%)';
    string private constant COLOR_22 = 'hsl(0, 2%, 16%)';
    string private constant COLOR_23 = 'hsl(45, 5%, 32%)';
    string private constant COLOR_24 = 'hsl(51, 4%, 33%)';
    string private constant COLOR_25 = 'hsl(200, 3%, 22%)';
    string private constant COLOR_26 = 'hsl(203, 85%, 32%)';
    string private constant COLOR_27 = 'hsl(193, 65%, 52%)';
    string private constant COLOR_28 = 'hsl(210, 18%, 9%)';
    string private constant COLOR_29 = 'hsl(214, 11%, 13%)';
    string private constant COLOR_30 = 'hsl(48, 4%, 22%)';
    string private constant COLOR_31 = 'hsl(204, 4%, 23%)';
    string private constant COLOR_32 = 'hsl(200, 3%, 19%)';
    string private constant COLOR_33 = 'hsl(210, 13%, 13%)';
    string private constant COLOR_34 = 'hsl(204, 5%, 18%)';
    string private constant COLOR_35 = 'hsl(214, 8%, 17%)';

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
            PART_36
        );
        return result;
    }
}
