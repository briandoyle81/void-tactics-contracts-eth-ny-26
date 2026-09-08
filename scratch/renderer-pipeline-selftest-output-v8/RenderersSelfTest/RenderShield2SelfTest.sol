// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderShield2SelfTest {
    string private constant PART_1 = '<path d="M128 115 L130 115 L130 143 L135 143 L135 115 L143 115 L141 116 L141 143 L144 143 L144 115 L147 115 L147 143 L153 143 L153 131 L154 131 L155 138 L157 129 L159 130 L160 124 L161 124 L163 142 L164 144 L122 144 L122 143 L128 143 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M164 106 L167 107 L169 111 L181 111 L181 145 L176 147 L176 149 L173 149 L172 152 L172 149 L170 148 L172 148 L173 145 L177 141 L179 141 L180 133 L174 133 L173 132 L173 125 L175 123 L180 123 L180 117 L172 117 L171 114 L171 116 L166 116 L166 142 L164 142 L164 115 L156 115 L156 114 L164 114 L164 112 L157 112 L157 111 L164 111 Z M165 111 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M171 112 L172 112 L172 117 L180 117 L180 118 L172 118 L172 140 L167 140 L167 148 L176 149 L176 147 L180 146 L177 152 L175 152 L175 158 L164 158 L164 160 L161 159 L163 157 L163 153 L161 151 L163 151 L163 149 L152 149 L151 151 L146 150 L145 148 L166 148 L164 142 L166 142 L166 116 L171 116 L171 114 L166 114 L166 113 Z M167 117 L167 139 L171 139 L171 117 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M96 106 L112 107 L113 111 L120 112 L120 115 L113 117 L112 119 L104 119 L103 116 L91 117 L89 116 L89 118 L87 118 L87 116 L85 115 L103 115 L103 112 L93 112 L83 111 L83 110 L95 109 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M114 115 L123 115 L122 144 L164 144 L164 145 L124 145 L124 148 L120 148 L119 139 L112 141 L113 122 L115 122 L115 138 L119 138 L119 117 L113 117 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M111 138 L113 140 L114 139 L119 139 L119 145 L108 145 L96 146 L85 145 L85 141 L89 142 L89 144 L93 142 L93 141 L87 140 L87 139 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M123 115 L128 115 L128 143 L122 143 L122 116 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M81 142 L83 145 L84 147 L102 148 L102 151 L109 151 L109 152 L101 153 L100 154 L86 154 L85 151 L79 151 L79 143 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M165 143 L166 143 L166 148 L145 148 L145 150 L142 150 L145 152 L137 152 L135 160 L131 159 L130 158 L130 149 L142 147 L143 146 L161 145 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M147 115 L152 115 L152 143 L147 143 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M130 115 L135 115 L135 143 L130 143 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M82 111 L93 111 L93 112 L84 113 L83 114 L83 121 L86 122 L85 139 L82 139 L81 143 L79 143 L79 113 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M98 122 L111 122 L112 123 L112 138 L111 139 L98 139 L98 132 L95 131 L98 131 Z M99 124 L99 138 L109 138 L108 136 L102 136 L102 133 L107 132 L108 128 L110 132 L111 125 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M97 105 L112 105 L115 107 L115 109 L117 110 L157 111 L157 112 L124 112 L124 114 L155 114 L155 115 L115 116 L115 115 L120 115 L120 112 L113 111 L112 108 L98 107 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M136 157 L163 157 L162 161 L160 161 L160 163 L153 163 L149 163 L149 161 L136 161 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M82 139 L94 140 L94 143 L89 144 L87 143 L87 141 L85 142 L85 144 L97 145 L108 145 L108 148 L84 148 L82 145 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M159 115 L164 115 L164 143 L162 142 L161 129 L160 143 L159 143 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M130 105 L157 105 L157 111 L152 111 L152 108 L136 109 L133 109 L127 110 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M136 150 L137 152 L157 152 L157 157 L136 157 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M87 112 L103 112 L103 115 L87 116 L87 118 L89 118 L89 116 L103 116 L103 119 L84 119 L84 114 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M93 124 L98 124 L98 138 L90 138 L93 135 L92 130 L90 135 L88 135 L88 125 L92 126 L93 127 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M99 124 L111 125 L110 132 L108 129 L106 133 L102 133 L102 136 L109 136 L109 138 L99 138 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M87 120 L112 120 L113 122 L113 138 L112 138 L111 123 L87 122 L87 139 L85 139 L85 122 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M116 149 L129 149 L129 157 L117 157 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M128 104 L164 104 L164 111 L157 111 L157 105 L130 105 L128 109 L126 111 L122 110 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M115 156 L127 157 L131 159 L135 160 L136 157 L136 161 L149 161 L150 163 L154 162 L153 165 L144 165 L143 164 L142 166 L139 166 L138 164 L134 165 L132 164 L132 162 L127 160 L126 159 L115 158 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M113 117 L119 117 L119 138 L115 138 L115 122 L113 122 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M142 149 L163 149 L164 157 L157 157 L157 152 L150 152 L149 154 L149 152 L139 151 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M167 117 L171 117 L171 139 L167 139 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M172 118 L180 118 L180 123 L174 125 L174 132 L179 134 L178 138 L172 139 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M175 133 L180 133 L180 139 L175 145 L172 148 L167 148 L167 140 L178 137 L179 134 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M143 115 L144 115 L144 143 L141 143 L141 116 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M87 122 L98 122 L98 124 L93 124 L93 127 L88 125 L88 135 L90 135 L91 129 L93 130 L93 135 L95 136 L92 137 L98 138 L98 139 L87 139 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M124 112 L164 112 L164 114 L155 115 L124 114 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M108 141 L109 145 L119 145 L119 148 L110 148 L114 149 L115 154 L110 153 L109 152 L102 151 L102 148 L108 148 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M84 112 L87 113 L85 114 L84 119 L104 118 L112 119 L113 117 L113 122 L112 120 L83 121 L84 127 L83 138 L82 138 L82 114 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M124 145 L161 145 L161 146 L143 147 L142 148 L124 148 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M155 115 L159 115 L159 130 L157 132 L156 143 L155 143 Z" style="fill:';
    string private constant PART_39 = ';"/><path d="M127 103 L165 103 L169 106 L168 111 L166 107 L164 106 L164 104 L128 105 L122 111 L116 111 L116 110 L122 108 Z M165 111 L167 112 Z" style="fill:';
    string private constant PART_40 = ';"/><path d="M119 143 L120 143 L120 148 L135 148 L135 149 L130 149 L131 160 L127 158 L129 157 L129 149 L116 149 L117 157 L113 156 L112 154 L115 154 L115 152 L113 151 L114 149 L111 149 L110 151 L110 148 L119 148 Z" style="fill:';
    string private constant PART_41 = ';"/><path d="M152 115 L155 115 L155 138 L154 138 L153 143 L152 143 Z" style="fill:';
    string private constant PART_42 = ';"/><path d="M134 107 L138 108 L152 108 L152 111 L126 111 L130 109 Z" style="fill:';
    string private constant PART_43 = ';"/>';
    string private constant COLOR_1 = 'hsl(199, 80%, 38%)';
    string private constant COLOR_2 = 'hsl(205, 22%, 19%)';
    string private constant COLOR_3 = 'hsl(206, 14%, 10%)';
    string private constant COLOR_4 = 'hsl(47, 5%, 35%)';
    string private constant COLOR_5 = 'hsl(206, 54%, 17%)';
    string private constant COLOR_6 = 'hsl(60, 1%, 24%)';
    string private constant COLOR_7 = 'hsl(193, 63%, 49%)';
    string private constant COLOR_8 = 'hsl(204, 11%, 9%)';
    string private constant COLOR_9 = 'hsl(210, 5%, 17%)';
    string private constant COLOR_10 = 'hsl(193, 61%, 51%)';
    string private constant COLOR_11 = 'hsl(192, 64%, 51%)';
    string private constant COLOR_12 = 'hsl(204, 10%, 10%)';
    string private constant COLOR_13 = 'hsl(210, 19%, 10%)';
    string private constant COLOR_14 = 'hsl(204, 17%, 12%)';
    string private constant COLOR_15 = 'hsl(204, 8%, 13%)';
    string private constant COLOR_16 = 'hsl(210, 7%, 17%)';
    string private constant COLOR_17 = 'hsl(190, 67%, 56%)';
    string private constant COLOR_18 = 'hsl(42, 5%, 37%)';
    string private constant COLOR_19 = 'hsl(50, 4%, 31%)';
    string private constant COLOR_20 = 'hsl(44, 7%, 44%)';
    string private constant COLOR_21 = 'hsl(200, 3%, 18%)';
    string private constant COLOR_22 = 'hsl(199, 36%, 24%)';
    string private constant COLOR_23 = 'hsl(46, 6%, 46%)';
    string private constant COLOR_24 = 'hsl(204, 6%, 15%)';
    string private constant COLOR_25 = 'hsl(60, 2%, 26%)';
    string private constant COLOR_26 = 'hsl(204, 14%, 7%)';
    string private constant COLOR_27 = 'hsl(44, 6%, 34%)';
    string private constant COLOR_28 = 'hsl(180, 1%, 17%)';
    string private constant COLOR_29 = 'hsl(45, 5%, 33%)';
    string private constant COLOR_30 = 'hsl(45, 5%, 32%)';
    string private constant COLOR_31 = 'hsl(180, 1%, 22%)';
    string private constant COLOR_32 = 'hsl(193, 64%, 52%)';
    string private constant COLOR_33 = 'hsl(210, 14%, 9%)';
    string private constant COLOR_34 = 'hsl(40, 2%, 25%)';
    string private constant COLOR_35 = 'hsl(204, 7%, 14%)';
    string private constant COLOR_36 = 'hsl(210, 5%, 17%)';
    string private constant COLOR_37 = 'hsl(90, 2%, 25%)';
    string private constant COLOR_38 = 'hsl(193, 63%, 52%)';
    string private constant COLOR_39 = 'hsl(204, 16%, 6%)';
    string private constant COLOR_40 = 'hsl(216, 12%, 8%)';
    string private constant COLOR_41 = 'hsl(199, 83%, 37%)';
    string private constant COLOR_42 = 'hsl(45, 5%, 35%)';

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
