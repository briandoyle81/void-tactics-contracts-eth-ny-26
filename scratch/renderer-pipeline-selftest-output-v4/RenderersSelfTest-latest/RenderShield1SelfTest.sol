// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderShield1SelfTest {
    string private constant PART_1 = '<path d="M126 103 L164 103 L167 106 L167 108 L170 106 L176 106 L181 111 L183 113 L183 141 L176 148 L175 156 L168 163 L161 165 L126 165 L124 162 L111 161 L106 156 L104 154 L99 154 L97 156 L83 156 L83 153 L78 153 L78 113 L88 111 L93 106 L107 106 L110 110 L119 110 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M154 106 L156 106 L158 108 L158 112 L166 112 L168 108 L170 106 L176 106 L181 111 L183 113 L183 141 L176 148 L175 156 L168 163 L161 165 L126 165 L124 162 L111 161 L106 156 L104 154 L99 154 L97 156 L83 156 L83 153 L78 153 L78 120 L80 119 L82 116 L83 143 L107 143 L108 121 L109 121 L110 146 L118 147 L119 143 L119 147 L125 147 L125 149 L127 149 L127 151 L129 151 L129 153 L148 152 L154 150 L153 152 L155 153 L156 150 L156 153 L159 152 L160 150 L155 149 L156 144 L158 139 L160 141 L159 146 L161 146 L161 144 L164 143 L165 145 L167 145 L168 142 L169 125 L171 128 L171 145 L169 145 L169 147 L175 146 L179 140 L181 140 L181 122 L179 121 L181 121 L181 119 L171 119 L169 123 L167 114 L163 114 L163 121 L160 123 L162 114 L153 115 L128 114 L128 116 L126 116 L128 112 L132 111 L155 112 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M167 116 L169 117 L170 121 L171 119 L181 119 L181 140 L177 144 L175 147 L169 147 L169 145 L171 145 L170 128 L169 142 L165 146 L163 145 L161 144 L161 146 L159 146 L159 141 L158 140 L156 145 L156 148 L160 150 L159 153 L152 153 L152 151 L148 153 L129 153 L129 151 L127 151 L127 149 L125 149 L125 147 L119 147 L119 136 L123 136 L124 138 L125 129 L128 124 L125 123 L125 121 L129 121 L132 119 L132 122 L138 118 L147 118 L154 122 L156 121 L160 125 L163 137 L166 137 L163 136 L163 131 L167 131 L167 127 L163 126 L167 125 L167 118 L165 117 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M126 103 L164 103 L168 108 L166 112 L158 112 L156 111 L156 106 L155 107 L155 112 L131 112 L127 114 L126 116 L128 116 L128 114 L162 114 L162 120 L162 121 L163 114 L167 114 L167 125 L164 126 L167 127 L166 133 L163 133 L163 136 L167 137 L165 138 L163 137 L162 139 L159 125 L156 123 L155 122 L152 122 L147 119 L138 119 L131 123 L131 120 L128 123 L125 121 L127 125 L124 131 L123 135 L119 135 L119 120 L124 120 L119 118 L119 113 L121 112 L123 108 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M137 121 L147 121 L153 125 L157 132 L158 140 L153 145 L147 149 L137 149 L130 143 L128 137 L129 129 L135 122 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M81 116 L82 116 L83 143 L107 143 L108 121 L109 121 L110 146 L118 147 L119 143 L119 147 L125 147 L123 148 L123 152 L108 152 L104 154 L99 154 L97 156 L83 156 L83 153 L78 153 L78 120 L80 119 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M93 106 L107 106 L110 110 L118 111 L117 117 L112 119 L108 119 L108 121 L82 121 L81 119 L78 120 L78 113 L88 111 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M126 103 L164 103 L168 108 L166 112 L158 112 L156 111 L156 106 L155 107 L155 112 L131 112 L127 114 L126 118 L120 119 L119 118 L119 113 L121 112 L123 108 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M138 118 L147 118 L152 121 L151 124 L147 122 L137 122 L131 127 L129 132 L130 139 L132 144 L137 148 L147 148 L153 144 L157 139 L157 144 L156 148 L160 150 L159 153 L152 153 L152 151 L148 153 L129 153 L129 151 L127 151 L127 149 L125 149 L125 147 L119 147 L119 136 L123 136 L124 138 L125 129 L128 124 L125 123 L125 121 L129 121 L132 119 L132 122 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M143 122 L144 126 L144 132 L149 132 L150 128 L152 129 L151 133 L151 136 L148 136 L148 145 L142 144 L142 147 L134 147 L133 145 L138 145 L137 142 L132 141 L132 139 L130 138 L130 135 L132 134 L131 130 L134 131 L136 127 L138 127 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M167 116 L169 117 L169 142 L165 146 L163 145 L161 144 L161 146 L159 146 L158 139 L156 132 L152 125 L153 122 L156 121 L160 125 L163 137 L166 137 L163 136 L163 131 L167 131 L167 127 L163 126 L167 125 L167 118 L165 117 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M133 155 L137 155 L157 155 L157 165 L138 165 L136 164 L136 160 L133 160 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M109 120 L118 120 L118 125 L111 125 L111 123 L116 123 L110 122 L111 126 L117 126 L118 127 L118 141 L118 143 L118 147 L110 147 L109 146 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M105 113 L112 113 L112 119 L108 119 L108 121 L82 121 L82 116 L84 114 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M119 136 L123 136 L124 142 L127 143 L129 147 L135 150 L145 150 L145 152 L155 147 L160 150 L159 153 L152 153 L152 151 L148 153 L129 153 L129 151 L127 151 L127 149 L125 149 L125 147 L119 147 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M83 122 L106 122 L106 143 L103 144 L83 144 Z M85 124 L84 125 L84 141 L103 141 L104 140 L104 124 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M82 145 L105 146 L107 147 L107 151 L96 152 L87 152 L91 154 L83 156 L83 153 L78 153 L81 151 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M152 150 L154 151 L153 152 L162 154 L158 155 L158 163 L161 163 L161 165 L157 165 L157 155 L137 155 L136 157 L133 155 L133 160 L136 160 L136 164 L138 165 L126 165 L124 162 L111 161 L111 160 L124 160 L125 157 L127 158 L127 164 L132 164 L132 155 L127 155 L127 153 L148 152 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M137 121 L147 121 L153 125 L149 127 L146 124 L146 122 L140 125 L137 128 L133 132 L133 135 L130 135 L130 138 L133 139 L137 141 L138 145 L132 145 L130 143 L128 137 L129 129 L135 122 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M103 124 L104 124 L104 140 L103 140 L102 131 L100 138 L91 140 L87 139 L85 140 L85 128 L86 132 L90 133 L91 137 L98 134 L99 135 L99 130 L93 127 L94 125 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M127 104 L163 104 L163 107 L129 107 L129 111 L126 112 L126 109 L125 108 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M171 119 L181 119 L181 121 L179 121 L180 123 L180 132 L177 129 L175 129 L174 126 L174 135 L173 135 L172 141 L171 141 L170 128 L169 123 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M143 122 L144 126 L144 132 L149 132 L150 128 L152 129 L151 133 L151 136 L148 136 L148 145 L142 144 L139 146 L139 138 L136 137 L138 136 L144 137 L140 127 L142 127 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M123 148 L127 149 L127 151 L129 151 L129 153 L127 153 L127 155 L132 155 L132 164 L127 164 L125 160 L123 160 L123 157 L119 157 L119 153 L124 153 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M109 120 L118 120 L118 125 L111 125 L111 123 L116 123 L110 122 L111 127 L111 143 L118 143 L118 147 L110 147 L109 146 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M108 119 L113 119 L109 121 Z M82 121 L108 121 L108 143 L105 143 L105 140 L106 122 L83 122 L83 143 L82 143 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M167 116 L169 117 L169 142 L167 145 L165 145 L164 137 L163 136 L163 131 L167 131 L167 127 L163 126 L167 125 L167 118 L165 117 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M128 137 L130 139 L132 144 L137 148 L147 148 L153 144 L157 139 L157 144 L153 149 L147 152 L145 152 L145 150 L135 151 L132 150 L129 146 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M108 121 L109 121 L110 147 L83 146 L84 144 L107 143 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M170 108 L177 108 L177 111 L180 112 L180 118 L171 118 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M83 147 L102 147 L102 151 L83 151 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M133 155 L137 155 L139 155 L139 157 L153 156 L154 160 L133 160 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M131 115 L159 115 L158 118 L150 117 L149 118 L151 120 L142 119 L136 119 L135 117 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M147 106 L155 107 L155 111 L137 111 L137 107 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M131 130 L133 130 L136 136 L140 140 L140 145 L142 145 L142 147 L134 147 L133 145 L138 145 L137 142 L132 141 L132 139 L130 138 L130 135 L132 134 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M102 129 L103 129 L103 141 L84 141 L84 132 L85 132 L86 137 L88 139 L100 138 Z" style="fill:';
    string private constant PART_37 = ';"/>';
    string private constant COLOR_1 = 'hsl(196, 14%, 15%)';
    string private constant COLOR_2 = 'hsl(216, 10%, 10%)';
    string private constant COLOR_3 = 'hsl(0, 0%, 20%)';
    string private constant COLOR_4 = 'hsl(75, 2%, 32%)';
    string private constant COLOR_5 = 'hsl(200, 78%, 48%)';
    string private constant COLOR_6 = 'hsl(210, 14%, 8%)';
    string private constant COLOR_7 = 'hsl(200, 3%, 18%)';
    string private constant COLOR_8 = 'hsl(195, 4%, 21%)';
    string private constant COLOR_9 = 'hsl(206, 40%, 22%)';
    string private constant COLOR_10 = 'hsl(192, 83%, 54%)';
    string private constant COLOR_11 = 'hsl(205, 24%, 21%)';
    string private constant COLOR_12 = 'hsl(204, 7%, 14%)';
    string private constant COLOR_13 = 'hsl(75, 3%, 30%)';
    string private constant COLOR_14 = 'hsl(60, 4%, 32%)';
    string private constant COLOR_15 = 'hsl(201, 12%, 23%)';
    string private constant COLOR_16 = 'hsl(60, 2%, 32%)';
    string private constant COLOR_17 = 'hsl(210, 10%, 12%)';
    string private constant COLOR_18 = 'hsl(210, 19%, 6%)';
    string private constant COLOR_19 = 'hsl(205, 79%, 41%)';
    string private constant COLOR_20 = 'hsl(195, 9%, 9%)';
    string private constant COLOR_21 = 'hsl(52, 7%, 44%)';
    string private constant COLOR_22 = 'hsl(45, 2%, 32%)';
    string private constant COLOR_23 = 'hsl(186, 92%, 63%)';
    string private constant COLOR_24 = 'hsl(200, 8%, 15%)';
    string private constant COLOR_25 = 'hsl(90, 2%, 25%)';
    string private constant COLOR_26 = 'hsl(200, 5%, 13%)';
    string private constant COLOR_27 = 'hsl(180, 3%, 19%)';
    string private constant COLOR_28 = 'hsl(208, 73%, 30%)';
    string private constant COLOR_29 = 'hsl(210, 21%, 5%)';
    string private constant COLOR_30 = 'hsl(120, 1%, 29%)';
    string private constant COLOR_31 = 'hsl(206, 8%, 18%)';
    string private constant COLOR_32 = 'hsl(45, 3%, 29%)';
    string private constant COLOR_33 = 'hsl(54, 5%, 38%)';
    string private constant COLOR_34 = 'hsl(75, 3%, 31%)';
    string private constant COLOR_35 = 'hsl(196, 80%, 51%)';
    string private constant COLOR_36 = 'hsl(210, 5%, 17%)';

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
            PART_37
        );
        return result;
    }
}
