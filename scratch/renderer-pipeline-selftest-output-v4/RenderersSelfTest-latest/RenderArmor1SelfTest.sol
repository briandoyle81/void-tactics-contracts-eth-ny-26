// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderArmor1SelfTest {
    string private constant PART_1 = '<path d="M132 103 L170 103 L178 111 L178 117 L177 118 L176 149 L172 153 L170 160 L163 168 L162 171 L132 171 L129 165 L128 164 L116 163 L111 157 L104 156 L103 159 L91 159 L89 157 L81 155 L81 120 L89 113 L94 112 L97 109 L115 109 L118 113 L123 114 L125 110 L129 106 L131 106 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M167 104 L169 104 L172 107 L174 107 L176 113 L175 114 L175 146 L171 150 L171 147 L168 146 L168 148 L123 148 L123 146 L115 146 L115 124 L123 118 L161 118 L160 117 L144 117 L143 109 L139 110 L138 111 L141 113 L136 113 L137 117 L127 117 L128 112 L134 105 L166 105 L167 106 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M174 108 L178 111 L178 117 L177 118 L176 149 L172 153 L170 160 L163 168 L162 171 L132 171 L129 165 L128 164 L116 163 L112 159 L112 157 L116 157 L116 153 L108 153 L107 155 L107 152 L115 151 L119 150 L123 151 L125 148 L168 148 L168 146 L172 147 L173 148 L174 146 L175 130 L169 130 L169 129 L175 129 L174 114 L174 111 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M97 111 L112 111 L111 115 L114 116 L108 117 L110 119 L118 119 L118 120 L110 121 L112 122 L112 128 L114 128 L114 144 L107 144 L106 143 L107 135 L110 135 L110 133 L107 132 L106 134 L106 128 L102 129 L104 134 L100 134 L103 136 L96 136 L99 140 L100 144 L98 145 L89 144 L90 146 L101 147 L101 145 L109 146 L109 150 L107 151 L83 151 L83 121 L86 116 L89 113 L95 113 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M167 104 L169 104 L172 107 L174 107 L176 113 L175 114 L175 146 L171 150 L171 147 L169 146 L169 131 L163 133 L163 135 L161 134 L160 130 L154 129 L156 128 L154 127 L154 125 L141 125 L141 123 L171 123 L173 118 L161 118 L160 117 L144 117 L143 109 L139 110 L138 111 L141 113 L136 113 L137 117 L127 117 L128 112 L134 105 L166 105 L167 106 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M174 108 L178 111 L178 117 L177 118 L176 149 L172 153 L170 160 L163 168 L162 171 L132 171 L130 165 L135 164 L161 165 L161 163 L157 161 L157 155 L152 156 L152 158 L155 158 L155 160 L150 159 L145 160 L148 159 L149 155 L150 152 L170 151 L174 146 L175 130 L169 130 L169 129 L175 129 L174 114 L174 111 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M134 105 L166 105 L167 108 L161 109 L160 117 L144 117 L143 109 L139 110 L138 111 L141 113 L136 113 L137 117 L127 117 L128 112 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M97 111 L112 111 L111 115 L114 116 L108 117 L110 119 L118 119 L118 120 L110 121 L109 124 L98 124 L94 125 L91 122 L91 120 L85 120 L87 114 L92 113 L96 112 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M123 118 L173 118 L171 123 L141 123 L141 122 L152 121 L152 120 L126 120 L126 122 L140 122 L140 123 L125 124 L124 125 L115 125 L119 121 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M137 155 L147 155 L149 159 L151 156 L152 159 L155 160 L155 158 L152 158 L152 156 L157 155 L159 162 L161 163 L161 165 L135 165 L130 163 L130 161 L128 161 L127 158 L133 156 L135 161 L139 163 L142 163 L142 159 L137 159 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M125 123 L140 123 L141 128 L138 127 L133 132 L128 138 L130 138 L132 142 L130 147 L126 147 L125 144 L127 142 L127 144 L129 144 L126 141 L124 140 L124 142 L121 143 L120 145 L119 144 L119 139 L122 140 L123 134 L127 130 L129 125 L124 125 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M117 124 L129 125 L127 133 L123 134 L123 141 L118 138 L118 143 L115 144 L115 125 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M136 128 L139 132 L138 138 L134 139 L132 147 L136 148 L123 148 L123 146 L115 146 L116 143 L118 143 L118 138 L120 139 L120 141 L124 142 L124 140 L129 142 L129 144 L126 145 L126 147 L130 146 L131 141 L127 137 L132 132 L135 131 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M168 146 L172 147 L170 152 L125 152 L126 149 L166 149 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M141 123 L169 123 L169 128 L166 128 L165 133 L163 133 L163 135 L161 134 L160 130 L154 129 L156 128 L154 127 L154 125 L141 125 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M139 107 L148 107 L149 111 L154 110 L154 112 L156 111 L156 108 L158 107 L167 107 L167 108 L161 109 L160 117 L144 117 L143 109 Z M148 112 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M132 103 L170 103 L173 106 L172 108 L169 106 L169 104 L167 104 L168 108 L166 107 L166 105 L142 106 L134 105 L132 109 L129 112 L125 112 L125 117 L122 116 L124 111 L129 106 L131 106 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M85 116 L87 117 L84 121 L83 153 L92 153 L92 155 L95 156 L100 157 L97 159 L91 159 L89 157 L81 155 L81 120 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M164 164 L164 167 L162 171 L132 171 L132 167 L162 166 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M97 111 L101 111 L101 113 L105 112 L107 117 L100 118 L100 120 L92 120 L91 122 L91 120 L85 120 L87 114 L92 113 L96 112 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M84 120 L90 120 L91 126 L88 126 L86 130 L85 133 L85 146 L88 148 L88 150 L101 150 L101 151 L83 151 L83 121 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M174 108 L178 111 L178 117 L177 118 L176 149 L172 153 L170 160 L169 160 L169 155 L165 156 L165 153 L171 150 L174 146 L175 130 L169 130 L169 129 L175 129 L174 114 L174 111 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M168 130 L175 130 L175 146 L171 150 L171 147 L169 146 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M125 119 L152 119 L152 122 L141 122 L141 125 L145 125 L144 128 L141 128 L140 122 L126 122 Z M138 126 L141 128 L140 131 L140 129 L137 128 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M115 150 L120 151 L122 154 L119 154 L117 153 L116 160 L126 159 L128 159 L128 161 L133 163 L132 165 L116 163 L112 159 L112 157 L116 157 L116 153 L108 153 L107 155 L107 152 L115 151 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M93 126 L99 127 L99 128 L92 130 L89 131 L89 139 L92 141 L100 140 L100 144 L98 145 L89 144 L85 138 L86 131 L91 127 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M143 105 L166 105 L166 107 L158 108 L156 112 L153 111 L149 112 L148 111 L148 106 L143 106 Z M148 112 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M163 162 L165 162 L163 166 L162 167 L131 168 L130 165 L135 164 L161 164 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M101 111 L112 111 L111 115 L114 116 L108 117 L110 119 L118 119 L118 120 L110 121 L109 124 L102 123 L102 122 L108 122 L108 120 L106 120 L105 117 L107 117 L105 112 L101 113 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M148 128 L153 129 L154 130 L160 130 L162 134 L159 139 L157 140 L156 136 L154 137 L152 133 L147 131 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M149 139 L156 139 L156 142 L154 145 L156 147 L155 148 L149 148 L144 145 L142 146 L142 143 L147 142 L147 144 L151 144 L148 140 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M165 131 L169 131 L169 146 L168 146 L168 138 L162 140 L158 142 L158 139 L161 135 L163 135 L163 133 L165 133 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M117 153 L126 155 L133 155 L130 158 L126 160 L116 160 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M118 138 L120 139 L120 141 L124 142 L124 140 L129 142 L129 144 L126 145 L126 147 L136 147 L136 148 L123 148 L123 146 L115 146 L116 143 L118 143 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M101 128 L106 128 L107 132 L111 133 L110 135 L107 135 L106 144 L102 143 L104 138 L102 137 L105 137 L105 135 L96 135 L100 133 L104 134 Z" style="fill:';
    string private constant PART_36 = ';"/>';
    string private constant COLOR_1 = 'hsl(223, 9%, 16%)';
    string private constant COLOR_2 = 'hsl(140, 2%, 37%)';
    string private constant COLOR_3 = 'hsl(218, 12%, 13%)';
    string private constant COLOR_4 = 'hsl(270, 2%, 22%)';
    string private constant COLOR_5 = 'hsl(220, 6%, 21%)';
    string private constant COLOR_6 = 'hsl(228, 7%, 15%)';
    string private constant COLOR_7 = 'hsl(160, 2%, 37%)';
    string private constant COLOR_8 = 'hsl(210, 5%, 25%)';
    string private constant COLOR_9 = 'hsl(60, 4%, 63%)';
    string private constant COLOR_10 = 'hsl(300, 1%, 30%)';
    string private constant COLOR_11 = 'hsl(150, 1%, 31%)';
    string private constant COLOR_12 = 'hsl(100, 2%, 36%)';
    string private constant COLOR_13 = 'hsl(140, 1%, 39%)';
    string private constant COLOR_14 = 'hsl(222, 11%, 18%)';
    string private constant COLOR_15 = 'hsl(100, 2%, 28%)';
    string private constant COLOR_16 = 'hsl(160, 2%, 32%)';
    string private constant COLOR_17 = 'hsl(214, 10%, 14%)';
    string private constant COLOR_18 = 'hsl(228, 10%, 10%)';
    string private constant COLOR_19 = 'hsl(223, 14%, 10%)';
    string private constant COLOR_20 = 'hsl(195, 5%, 54%)';
    string private constant COLOR_21 = 'hsl(200, 2%, 33%)';
    string private constant COLOR_22 = 'hsl(220, 14%, 9%)';
    string private constant COLOR_23 = 'hsl(218, 7%, 23%)';
    string private constant COLOR_24 = 'hsl(69, 3%, 45%)';
    string private constant COLOR_25 = 'hsl(220, 13%, 9%)';
    string private constant COLOR_26 = 'hsl(200, 4%, 32%)';
    string private constant COLOR_27 = 'hsl(120, 1%, 40%)';
    string private constant COLOR_28 = 'hsl(220, 9%, 19%)';
    string private constant COLOR_29 = 'hsl(207, 5%, 34%)';
    string private constant COLOR_30 = 'hsl(160, 2%, 34%)';
    string private constant COLOR_31 = 'hsl(160, 2%, 34%)';
    string private constant COLOR_32 = 'hsl(120, 1%, 41%)';
    string private constant COLOR_33 = 'hsl(218, 9%, 18%)';
    string private constant COLOR_34 = 'hsl(100, 1%, 44%)';
    string private constant COLOR_35 = 'hsl(225, 7%, 11%)';

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
