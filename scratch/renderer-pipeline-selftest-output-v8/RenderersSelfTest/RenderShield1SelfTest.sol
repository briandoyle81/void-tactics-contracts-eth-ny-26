// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderShield1SelfTest {
    string private constant PART_1 = '<path d="M141 155 L167 155 L171 155 L173 155 L172 159 L168 163 L161 165 L138 165 L136 164 L137 162 L136 160 L154 160 L152 157 L140 157 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M167 116 L169 117 L170 120 L171 119 L181 119 L181 127 L179 127 L179 125 L172 127 L171 144 L177 142 L176 147 L170 147 L169 143 L167 143 L167 145 L161 144 L161 146 L159 146 L161 139 L163 139 L163 137 L166 137 L163 136 L163 131 L167 131 L167 118 L165 117 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M128 114 L162 114 L162 117 L156 118 L149 118 L151 120 L142 119 L136 119 L135 117 L131 116 L129 120 L125 121 L127 125 L124 131 L123 135 L119 135 L119 120 L124 120 L124 118 L126 118 L126 116 L128 116 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M93 106 L107 106 L112 113 L112 118 L109 118 L107 118 L107 120 L105 120 L105 114 L84 115 L82 116 L82 114 L80 114 L81 119 L78 119 L78 113 L88 111 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M130 149 L139 153 L137 154 L137 156 L139 157 L135 158 L133 157 L133 160 L148 161 L148 162 L137 163 L138 164 L138 165 L126 165 L123 160 L123 157 L116 157 L116 153 L124 153 L125 151 L126 152 L131 152 Z M124 157 L125 160 L126 157 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M134 106 L167 106 L168 109 L166 112 L158 112 L157 108 L157 112 L126 112 L125 108 L128 109 L129 107 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M142 122 L144 122 L148 127 L153 127 L153 129 L151 129 L152 136 L147 134 L147 137 L145 137 L145 140 L142 142 L140 146 L139 144 L139 138 L135 136 L134 131 L136 127 L140 127 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M80 114 L82 114 L82 121 L108 121 L108 143 L105 143 L105 131 L106 122 L82 122 L82 145 L81 145 L81 140 L78 140 L78 119 L81 119 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M83 122 L106 122 L106 143 L103 144 L92 144 L86 142 L86 141 L103 140 L103 125 L85 125 L85 143 L90 143 L90 144 L84 144 L83 143 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M160 131 L162 132 L162 139 L159 146 L161 146 L161 144 L164 143 L165 147 L162 148 L159 153 L155 154 L148 153 L138 153 L135 151 L145 150 L151 149 L156 144 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M163 114 L167 114 L167 131 L166 133 L163 133 L163 136 L167 137 L165 138 L163 137 L162 139 L159 125 L156 123 L156 121 L152 119 L151 117 L162 117 L161 122 L162 121 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M84 114 L104 114 L104 121 L82 121 L82 116 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M111 126 L117 126 L118 127 L118 142 L111 142 L111 143 L117 143 L117 146 L109 146 L109 128 L111 128 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M150 131 L153 132 L153 142 L149 144 L148 145 L144 144 L143 147 L134 147 L133 145 L137 145 L136 142 L133 141 L130 138 L130 135 L134 135 L139 138 L140 145 L143 140 L145 140 L145 137 L147 137 L147 134 L151 135 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M82 122 L83 122 L84 146 L86 147 L93 148 L96 147 L102 148 L102 151 L82 152 L78 153 L78 140 L81 140 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M109 120 L118 120 L120 126 L119 135 L123 135 L124 132 L125 142 L123 140 L123 136 L119 136 L119 146 L118 147 L110 147 L111 145 L117 146 L117 143 L110 144 L110 129 L111 129 L111 142 L118 142 L117 127 L111 126 L111 128 L109 128 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M111 111 L121 111 L128 112 L128 115 L126 116 L126 118 L119 119 L108 119 L108 121 L104 121 L104 114 L105 114 L105 120 L107 120 L107 118 L111 116 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M148 117 L152 118 L160 125 L161 131 L158 138 L157 138 L155 130 L151 124 L148 124 L147 120 L136 120 L138 118 L147 118 L148 118 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M127 104 L163 104 L163 107 L129 107 L128 110 L123 109 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M153 127 L156 130 L158 139 L156 139 L154 144 L149 148 L147 149 L137 149 L136 147 L143 147 L144 143 L146 143 L146 145 L148 145 L147 142 L151 142 L153 142 L152 138 L153 132 L151 132 L151 129 L153 129 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M119 136 L123 136 L124 142 L127 143 L128 147 L132 148 L135 151 L131 150 L132 153 L126 153 L123 150 L123 148 L119 147 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M162 147 L164 148 L165 149 L169 149 L169 156 L158 155 L158 163 L157 163 L157 155 L144 156 L137 155 L139 153 L149 152 L157 153 L160 151 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M157 108 L159 109 L158 112 L166 112 L167 110 L169 111 L170 115 L163 114 L163 121 L160 123 L162 114 L127 115 L126 113 L132 111 L157 112 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M114 118 L124 118 L124 120 L119 120 L118 124 L118 120 L109 120 L110 147 L83 146 L84 144 L107 143 L108 119 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M140 123 L142 124 L140 128 L136 128 L133 137 L132 135 L130 135 L130 138 L135 140 L138 143 L137 146 L132 146 L128 138 L129 129 L135 126 L139 125 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M103 124 L104 124 L104 140 L103 140 L102 135 L96 137 L93 136 L97 134 L98 128 L93 128 L89 130 L89 128 L91 128 L91 126 L87 125 Z M85 124 L87 124 L87 126 L91 126 L91 128 L89 128 L90 132 L89 133 L93 137 L97 139 L89 139 L87 138 L86 140 L84 140 L84 125 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M84 146 L105 146 L110 147 L110 151 L105 153 L91 153 L89 155 L86 152 L86 154 L84 153 L84 151 L102 151 L102 148 L95 148 L91 149 L90 147 L85 148 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M81 151 L85 152 L86 152 L88 153 L89 153 L89 152 L113 152 L113 157 L108 158 L104 154 L99 154 L97 156 L83 156 Z M118 146 L125 147 L123 148 L123 152 L108 152 L110 151 L110 147 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M181 116 L182 116 L183 123 L183 141 L176 147 L177 142 L181 140 L181 122 L179 121 L181 121 L181 119 L171 120 L170 140 L169 140 L169 117 L181 118 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M128 129 L129 132 L129 138 L132 144 L132 146 L137 148 L147 148 L153 144 L156 139 L158 140 L155 147 L148 151 L135 151 L129 147 L127 140 L127 131 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M171 122 L174 126 L173 129 L172 140 L175 139 L176 136 L173 135 L173 130 L175 130 L175 127 L178 127 L178 132 L180 135 L180 140 L176 143 L171 144 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M169 142 L170 146 L176 147 L175 156 L173 157 L173 155 L171 155 L170 158 L168 154 L169 149 L162 150 L165 145 L167 145 L167 143 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M123 150 L124 153 L116 153 L116 157 L123 157 L124 161 L111 161 L109 160 L109 157 L113 157 L113 152 L123 152 Z M124 157 L126 158 L124 160 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M125 121 L129 122 L131 121 L132 124 L130 126 L128 131 L128 140 L129 147 L125 142 L123 131 L126 124 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M170 108 L177 108 L178 111 L180 112 L180 118 L171 118 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M102 132 L103 132 L103 141 L91 142 L92 144 L85 143 L86 137 L93 138 L96 136 L101 135 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M137 121 L147 121 L153 125 L153 127 L147 128 L147 125 L144 124 L144 122 L140 123 L139 126 L133 128 L131 126 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M131 116 L137 117 L136 120 L147 120 L147 121 L137 122 L132 127 L131 129 L129 129 L130 124 L129 123 L127 122 L127 120 Z" style="fill:';
    string private constant PART_39 = ';"/><path d="M175 125 L179 125 L179 127 L181 127 L181 140 L180 140 L179 133 L175 132 L178 132 L178 127 L175 127 L175 130 L173 130 L173 135 L177 136 L175 140 L172 140 L172 128 Z" style="fill:';
    string private constant PART_40 = ';"/><path d="M126 103 L164 103 L166 106 L163 106 L163 104 L127 105 L124 108 L126 112 L119 111 L125 104 Z" style="fill:';
    string private constant PART_41 = ';"/><path d="M137 155 L141 156 L153 156 L154 160 L133 160 L133 157 L137 156 Z" style="fill:';
    string private constant PART_42 = ';"/><path d="M170 106 L176 106 L181 111 L183 113 L183 123 L182 123 L181 118 L180 118 L180 112 L176 111 L178 111 L177 109 L170 108 L171 117 L167 116 L169 114 L169 111 L167 111 L169 107 Z" style="fill:';
    string private constant PART_43 = ';"/><path d="M93 127 L98 128 L98 134 L92 137 L90 135 L88 137 L87 131 L91 129 Z" style="fill:';
    string private constant PART_44 = ';"/>';
    string private constant COLOR_1 = 'hsl(195, 6%, 14%)';
    string private constant COLOR_2 = 'hsl(180, 3%, 22%)';
    string private constant COLOR_3 = 'hsl(60, 3%, 35%)';
    string private constant COLOR_4 = 'hsl(180, 3%, 20%)';
    string private constant COLOR_5 = 'hsl(204, 8%, 12%)';
    string private constant COLOR_6 = 'hsl(140, 2%, 27%)';
    string private constant COLOR_7 = 'hsl(190, 87%, 58%)';
    string private constant COLOR_8 = 'hsl(210, 12%, 10%)';
    string private constant COLOR_9 = 'hsl(80, 2%, 32%)';
    string private constant COLOR_10 = 'hsl(204, 16%, 18%)';
    string private constant COLOR_11 = 'hsl(75, 2%, 32%)';
    string private constant COLOR_12 = 'hsl(72, 3%, 34%)';
    string private constant COLOR_13 = 'hsl(90, 1%, 30%)';
    string private constant COLOR_14 = 'hsl(195, 82%, 52%)';
    string private constant COLOR_15 = 'hsl(192, 6%, 15%)';
    string private constant COLOR_16 = 'hsl(180, 4%, 16%)';
    string private constant COLOR_17 = 'hsl(195, 5%, 16%)';
    string private constant COLOR_18 = 'hsl(206, 30%, 22%)';
    string private constant COLOR_19 = 'hsl(60, 4%, 44%)';
    string private constant COLOR_20 = 'hsl(204, 79%, 45%)';
    string private constant COLOR_21 = 'hsl(180, 2%, 24%)';
    string private constant COLOR_22 = 'hsl(210, 18%, 7%)';
    string private constant COLOR_23 = 'hsl(204, 10%, 10%)';
    string private constant COLOR_24 = 'hsl(204, 19%, 5%)';
    string private constant COLOR_25 = 'hsl(203, 79%, 45%)';
    string private constant COLOR_26 = 'hsl(210, 12%, 10%)';
    string private constant COLOR_27 = 'hsl(204, 9%, 11%)';
    string private constant COLOR_28 = 'hsl(204, 13%, 8%)';
    string private constant COLOR_29 = 'hsl(204, 17%, 6%)';
    string private constant COLOR_30 = 'hsl(207, 73%, 29%)';
    string private constant COLOR_31 = 'hsl(43, 5%, 29%)';
    string private constant COLOR_32 = 'hsl(204, 15%, 6%)';
    string private constant COLOR_33 = 'hsl(216, 14%, 7%)';
    string private constant COLOR_34 = 'hsl(203, 12%, 22%)';
    string private constant COLOR_35 = 'hsl(90, 1%, 29%)';
    string private constant COLOR_36 = 'hsl(192, 6%, 17%)';
    string private constant COLOR_37 = 'hsl(206, 79%, 40%)';
    string private constant COLOR_38 = 'hsl(206, 31%, 25%)';
    string private constant COLOR_39 = 'hsl(192, 5%, 18%)';
    string private constant COLOR_40 = 'hsl(200, 13%, 14%)';
    string private constant COLOR_41 = 'hsl(48, 3%, 30%)';
    string private constant COLOR_42 = 'hsl(210, 13%, 9%)';
    string private constant COLOR_43 = 'hsl(195, 22%, 29%)';

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
            PART_44
        );
        return result;
    }
}
