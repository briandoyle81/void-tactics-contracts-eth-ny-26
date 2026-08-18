// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderShield1SelfTest {
    string private constant PART_1 = '<path d="M126 103 L164 103 L167 106 L167 108 L170 106 L176 106 L181 111 L183 113 L183 141 L176 148 L175 156 L168 163 L161 165 L126 165 L124 162 L111 161 L106 156 L104 154 L99 154 L97 156 L83 156 L83 153 L78 153 L78 113 L88 111 L93 106 L107 106 L110 110 L119 110 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M93 106 L107 106 L110 110 L118 111 L114 113 L114 119 L109 120 L110 146 L118 147 L118 143 L111 143 L111 142 L117 141 L118 125 L120 126 L119 135 L123 135 L124 128 L128 124 L126 129 L125 138 L124 142 L123 136 L119 136 L119 147 L125 147 L123 148 L126 152 L159 152 L161 147 L165 147 L165 145 L167 145 L168 142 L169 127 L171 127 L171 145 L169 145 L169 147 L175 146 L179 140 L181 140 L181 122 L179 121 L181 121 L181 119 L172 119 L172 118 L180 118 L180 112 L176 111 L177 108 L170 108 L171 112 L168 113 L169 116 L167 116 L166 114 L160 113 L160 112 L166 112 L168 108 L170 106 L176 106 L181 111 L183 113 L183 141 L176 148 L175 156 L168 163 L161 165 L126 165 L124 162 L111 161 L106 156 L104 154 L99 154 L97 156 L83 156 L83 153 L78 153 L78 113 L88 111 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M83 112 L112 113 L112 119 L108 119 L108 121 L106 121 L106 143 L103 144 L83 144 L82 143 L81 133 L80 137 L78 137 L78 113 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M137 121 L147 121 L153 125 L157 132 L158 140 L155 147 L147 152 L145 152 L145 150 L135 151 L132 150 L129 146 L128 142 L128 132 L131 126 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M138 118 L147 118 L154 122 L156 121 L160 125 L163 137 L165 137 L166 143 L161 147 L160 152 L159 153 L126 153 L123 150 L123 148 L119 147 L119 136 L123 136 L124 138 L125 129 L129 125 L131 125 L133 121 Z M137 121 L130 127 L128 132 L128 142 L130 147 L133 150 L140 151 L145 150 L145 152 L151 150 L156 145 L158 138 L156 129 L151 123 L147 121 Z M161 139 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M170 108 L177 108 L177 111 L180 112 L180 118 L181 122 L181 140 L177 144 L175 147 L169 147 L169 145 L171 145 L171 127 L169 127 L169 142 L167 145 L165 145 L165 147 L160 147 L161 145 L163 145 L164 143 L165 142 L166 137 L163 136 L163 134 L166 134 L166 132 L163 131 L167 131 L167 118 L165 117 L168 115 L167 112 L170 111 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M170 106 L176 106 L181 111 L183 113 L183 141 L176 148 L175 156 L168 163 L161 164 L162 155 L158 155 L158 163 L157 163 L157 155 L137 155 L136 157 L134 154 L135 153 L149 152 L159 152 L161 147 L165 147 L165 145 L167 145 L168 142 L169 127 L171 127 L171 145 L169 145 L169 147 L175 146 L179 140 L181 140 L181 122 L179 121 L181 121 L181 119 L172 119 L172 118 L180 118 L180 112 L176 111 L177 108 L170 108 L171 112 L168 113 L169 116 L167 116 L166 114 L160 113 L160 112 L166 112 L168 108 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M128 114 L162 114 L162 120 L162 121 L163 114 L167 114 L167 131 L166 134 L163 134 L163 136 L167 137 L165 138 L163 137 L162 139 L159 125 L156 123 L155 122 L152 122 L147 119 L138 119 L132 123 L129 126 L126 126 L123 135 L119 135 L119 120 L124 120 L124 118 L126 118 L126 116 L128 116 Z M161 139 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M83 112 L112 113 L112 119 L108 119 L108 121 L106 122 L83 122 L83 143 L82 143 L81 133 L80 137 L78 137 L78 113 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M137 121 L147 121 L153 125 L149 127 L146 124 L146 122 L140 124 L138 128 L136 128 L134 132 L133 130 L133 134 L130 135 L130 138 L133 139 L137 141 L138 145 L134 146 L137 148 L147 148 L147 142 L151 142 L153 142 L152 138 L153 132 L151 132 L151 129 L153 129 L154 127 L157 132 L158 140 L155 147 L147 152 L145 152 L145 150 L135 151 L132 150 L129 146 L128 142 L128 132 L131 126 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M127 104 L163 104 L164 109 L162 111 L160 109 L158 112 L156 111 L156 106 L155 107 L155 112 L126 112 L121 111 L124 106 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M133 155 L137 155 L162 155 L161 165 L134 165 L133 161 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M85 124 L104 124 L104 140 L103 141 L96 141 L92 140 L91 137 L93 137 L94 134 L99 135 L99 130 L96 128 L93 128 L95 130 L93 130 L92 135 L89 132 L88 132 L89 138 L85 140 L84 125 Z M89 133 L90 137 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M109 120 L118 120 L118 125 L111 125 L111 126 L117 126 L118 127 L118 141 L118 143 L118 147 L110 147 L109 146 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M171 122 L173 126 L173 122 L181 122 L181 140 L177 144 L175 147 L169 147 L169 145 L171 145 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M137 121 L147 121 L153 125 L149 127 L146 124 L146 122 L140 124 L138 128 L136 128 L134 132 L133 130 L133 134 L130 135 L130 138 L133 139 L137 141 L138 145 L132 145 L130 143 L128 137 L129 129 L135 122 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M82 145 L85 147 L85 149 L88 147 L105 146 L107 147 L107 151 L94 152 L94 154 L91 154 L83 154 L78 153 L81 151 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M131 116 L137 117 L135 121 L129 126 L126 126 L123 135 L119 135 L119 120 L127 120 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M138 118 L147 118 L152 121 L151 124 L147 122 L137 122 L131 127 L129 132 L129 142 L131 148 L128 147 L125 142 L124 132 L127 126 L131 125 L133 121 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M119 136 L123 136 L124 142 L127 143 L129 147 L135 150 L135 152 L138 153 L126 153 L123 150 L123 148 L119 147 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M128 104 L163 104 L164 109 L162 111 L160 109 L158 112 L156 111 L156 106 L154 107 L129 107 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M84 114 L104 114 L104 120 L88 120 L88 116 L84 116 L83 120 L83 115 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M158 139 L160 141 L159 147 L161 147 L160 152 L159 153 L138 153 L135 151 L145 150 L145 152 L154 147 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M131 130 L133 130 L136 136 L140 140 L140 145 L144 143 L147 146 L147 149 L137 149 L133 145 L138 145 L137 142 L132 141 L132 139 L130 138 L130 135 L132 134 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M93 127 L98 128 L100 130 L100 135 L97 135 L94 135 L92 138 L96 141 L84 141 L84 132 L85 132 L86 137 L88 137 L87 131 L91 130 L92 132 L92 129 Z M89 133 L90 137 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M93 106 L107 106 L110 110 L110 112 L90 112 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M140 124 L142 124 L141 128 L145 137 L140 138 L134 135 L135 128 L139 126 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M153 127 L156 129 L158 140 L153 145 L148 148 L147 142 L151 142 L153 142 L152 138 L153 132 L151 132 L151 129 L153 129 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M170 108 L177 108 L177 111 L180 112 L180 118 L171 118 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M126 103 L164 103 L168 108 L166 112 L159 112 L160 108 L163 109 L163 104 L127 105 L124 105 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M83 112 L104 113 L104 114 L84 115 L88 116 L88 120 L104 120 L104 121 L82 121 L82 114 L78 113 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M136 161 L154 161 L154 165 L136 165 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M109 120 L118 120 L118 125 L111 125 L111 126 L117 126 L117 127 L112 127 L113 133 L112 140 L111 140 L111 128 L109 128 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M102 131 L103 131 L103 141 L96 141 L92 140 L91 137 L93 137 L94 134 L98 134 L98 136 L101 136 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M137 121 L147 121 L153 125 L149 127 L146 124 L146 122 L140 125 L135 127 L130 129 L132 125 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M109 128 L111 128 L111 143 L118 143 L118 147 L110 147 L109 146 Z" style="fill:';
    string private constant PART_37 = ';"/>';
    string private constant COLOR_1 = 'hsl(200, 5%, 13%)';
    string private constant COLOR_2 = 'hsl(210, 13%, 9%)';
    string private constant COLOR_3 = 'hsl(60, 2%, 32%)';
    string private constant COLOR_4 = 'hsl(191, 85%, 57%)';
    string private constant COLOR_5 = 'hsl(204, 23%, 21%)';
    string private constant COLOR_6 = 'hsl(180, 2%, 18%)';
    string private constant COLOR_7 = 'hsl(210, 16%, 7%)';
    string private constant COLOR_8 = 'hsl(60, 4%, 33%)';
    string private constant COLOR_9 = 'hsl(180, 1%, 15%)';
    string private constant COLOR_10 = 'hsl(208, 73%, 30%)';
    string private constant COLOR_11 = 'hsl(150, 3%, 29%)';
    string private constant COLOR_12 = 'hsl(180, 1%, 20%)';
    string private constant COLOR_13 = 'hsl(195, 7%, 11%)';
    string private constant COLOR_14 = 'hsl(60, 2%, 28%)';
    string private constant COLOR_15 = 'hsl(60, 2%, 25%)';
    string private constant COLOR_16 = 'hsl(204, 79%, 45%)';
    string private constant COLOR_17 = 'hsl(206, 9%, 16%)';
    string private constant COLOR_18 = 'hsl(135, 3%, 30%)';
    string private constant COLOR_19 = 'hsl(206, 45%, 22%)';
    string private constant COLOR_20 = 'hsl(192, 4%, 23%)';
    string private constant COLOR_21 = 'hsl(49, 7%, 43%)';
    string private constant COLOR_22 = 'hsl(53, 4%, 37%)';
    string private constant COLOR_23 = 'hsl(205, 23%, 18%)';
    string private constant COLOR_24 = 'hsl(199, 77%, 50%)';
    string private constant COLOR_25 = 'hsl(190, 18%, 25%)';
    string private constant COLOR_26 = 'hsl(180, 2%, 20%)';
    string private constant COLOR_27 = 'hsl(192, 83%, 54%)';
    string private constant COLOR_28 = 'hsl(205, 78%, 44%)';
    string private constant COLOR_29 = 'hsl(120, 1%, 29%)';
    string private constant COLOR_30 = 'hsl(180, 3%, 17%)';
    string private constant COLOR_31 = 'hsl(60, 1%, 23%)';
    string private constant COLOR_32 = 'hsl(200, 10%, 12%)';
    string private constant COLOR_33 = 'hsl(72, 3%, 32%)';
    string private constant COLOR_34 = 'hsl(197, 10%, 14%)';
    string private constant COLOR_35 = 'hsl(206, 80%, 38%)';
    string private constant COLOR_36 = 'hsl(180, 1%, 22%)';

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
