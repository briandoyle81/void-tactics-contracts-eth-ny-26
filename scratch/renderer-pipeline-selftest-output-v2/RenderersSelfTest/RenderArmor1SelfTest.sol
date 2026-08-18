// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderArmor1SelfTest {
    string private constant PART_1 = '<path d="M132 103 L170 103 L178 111 L178 117 L177 118 L176 149 L172 153 L170 160 L163 168 L162 171 L132 171 L129 165 L128 164 L116 163 L111 157 L104 156 L103 159 L91 159 L89 157 L81 155 L81 120 L89 113 L94 112 L97 109 L115 109 L118 113 L123 114 L125 110 L129 106 L131 106 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M123 118 L173 118 L171 123 L169 123 L169 128 L167 128 L167 131 L169 131 L169 146 L168 148 L123 148 L123 146 L115 146 L115 124 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M97 109 L115 109 L117 115 L113 117 L118 118 L118 120 L112 121 L112 126 L111 127 L113 128 L114 131 L114 144 L108 145 L110 149 L107 151 L83 151 L83 121 L86 117 L88 117 L89 113 L94 112 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M132 103 L170 103 L173 106 L172 108 L169 106 L169 104 L167 104 L168 108 L166 107 L166 105 L134 105 L132 109 L129 112 L125 112 L125 117 L123 118 L118 123 L116 124 L116 148 L114 148 L114 150 L111 152 L107 152 L107 155 L104 154 L102 152 L101 155 L99 155 L98 153 L98 155 L103 156 L103 157 L90 158 L81 155 L81 120 L87 114 L91 115 L88 115 L88 117 L84 121 L83 151 L107 150 L109 149 L107 144 L114 144 L113 128 L110 127 L111 122 L112 120 L118 120 L118 118 L113 118 L112 116 L116 114 L117 112 L123 114 L125 110 L129 106 L131 106 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M97 109 L115 109 L117 115 L113 117 L118 118 L118 120 L108 122 L92 120 L91 125 L86 130 L84 141 L83 141 L83 121 L86 117 L88 117 L89 113 L94 112 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M92 120 L101 120 L110 121 L112 122 L111 127 L113 128 L114 131 L114 144 L108 145 L110 149 L107 151 L83 151 L83 141 L86 141 L86 143 L88 143 L90 146 L101 147 L101 145 L105 143 L106 138 L107 140 L107 137 L107 135 L110 135 L110 133 L107 132 L106 134 L106 128 L102 128 L102 125 L92 124 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M136 104 L148 104 L166 105 L167 108 L161 109 L160 116 L159 117 L144 117 L143 109 L141 109 L141 113 L136 113 L137 117 L127 117 L128 112 L134 105 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M123 118 L173 118 L171 123 L141 123 L140 125 L140 123 L125 124 L122 124 L124 121 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M126 155 L133 155 L135 161 L136 162 L141 162 L141 159 L134 159 L134 155 L144 155 L145 156 L152 156 L157 155 L159 162 L161 163 L161 165 L134 166 L131 163 L130 161 L128 161 L126 158 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M122 119 L125 122 L123 124 L126 126 L124 127 L123 140 L128 141 L126 142 L126 147 L130 148 L123 148 L123 146 L115 146 L115 124 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M90 120 L92 124 L100 124 L102 125 L102 128 L106 128 L107 132 L111 133 L110 135 L107 135 L107 137 L110 138 L111 140 L107 140 L105 144 L101 145 L101 147 L95 148 L89 146 L88 143 L86 143 L84 140 L84 133 L88 126 L91 125 Z M93 126 L87 130 L85 134 L86 140 L89 144 L98 145 L100 143 L99 140 L96 136 L103 136 L101 134 L104 134 L102 129 L97 126 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M125 123 L157 123 L157 125 L155 125 L154 127 L154 125 L144 126 L140 128 L137 127 L137 125 L133 125 L135 131 L130 136 L128 141 L123 140 L123 127 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M173 118 L175 119 L175 146 L170 152 L167 152 L169 131 L166 132 L165 130 L167 130 L167 128 L169 128 L169 123 L171 123 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M165 131 L169 131 L169 146 L168 148 L155 148 L154 144 L160 137 L161 135 L163 135 L163 133 L165 133 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M143 118 L173 118 L171 123 L141 123 L141 122 L152 122 L152 119 L143 119 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M136 104 L148 104 L148 105 L137 107 L137 109 L141 109 L141 113 L136 113 L137 117 L127 117 L128 112 L134 105 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M167 155 L169 156 L169 161 L162 167 L131 168 L130 163 L133 163 L135 165 L161 164 L163 160 L164 156 L166 156 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M88 115 L96 115 L96 116 L91 117 L91 119 L100 119 L100 120 L92 120 L91 125 L86 130 L84 141 L83 141 L83 121 L86 117 L88 117 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M97 111 L116 111 L117 115 L110 117 L100 117 L97 114 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M87 114 L91 115 L88 115 L88 117 L84 121 L83 152 L89 152 L89 153 L82 153 L81 155 L81 120 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M93 126 L99 127 L99 128 L92 128 L91 131 L89 131 L89 139 L92 141 L100 140 L100 144 L98 145 L89 144 L85 138 L86 131 L91 127 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M96 152 L101 152 L99 153 L99 155 L102 152 L106 153 L105 154 L107 155 L107 152 L115 152 L112 153 L111 157 L104 156 L103 159 L91 159 L91 156 L91 155 L98 155 L98 153 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M126 155 L133 155 L135 161 L139 163 L160 164 L160 165 L134 166 L131 163 L130 161 L128 161 L126 158 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M125 123 L157 123 L157 125 L155 125 L154 127 L154 125 L144 126 L140 128 L137 127 L137 125 L133 125 L133 128 L130 126 L124 125 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M84 140 L86 141 L86 143 L88 143 L92 147 L92 150 L101 150 L101 151 L83 151 L83 141 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M132 124 L139 124 L137 125 L139 126 L139 128 L137 128 L139 133 L135 139 L131 139 L130 134 L133 131 L134 130 L133 126 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M174 108 L178 111 L178 117 L177 118 L176 146 L175 146 L175 130 L169 130 L169 129 L175 129 L174 119 L169 118 L173 117 L174 113 L174 111 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M116 155 L117 158 L116 160 L124 159 L124 156 L126 156 L128 161 L130 161 L129 165 L128 164 L116 163 L112 159 L112 157 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M167 104 L169 104 L172 107 L174 107 L176 113 L173 114 L172 116 L167 117 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M92 120 L101 120 L110 121 L109 124 L100 125 L92 124 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M90 133 L95 133 L96 134 L103 135 L103 136 L96 136 L98 140 L93 141 L90 139 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M123 118 L142 118 L142 119 L127 120 L126 122 L140 122 L140 123 L125 124 L122 124 L124 121 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M132 103 L133 105 L131 110 L129 112 L125 112 L125 117 L123 118 L121 120 L122 114 L126 109 L129 106 L131 106 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M97 109 L115 109 L114 112 L97 112 L93 114 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M155 155 L157 155 L157 159 L155 160 L145 160 L145 156 L152 156 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M110 122 L112 122 L111 127 L110 128 L102 128 L101 124 L109 123 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M157 123 L168 123 L165 125 L161 127 L160 130 L154 129 L156 128 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M87 139 L92 141 L100 140 L100 144 L98 145 L89 144 Z" style="fill:';
    string private constant PART_39 = ';"/><path d="M116 112 L122 114 L121 121 L117 120 L118 118 L113 118 L112 116 L116 114 Z" style="fill:';
    string private constant PART_40 = ';"/><path d="M97 111 L105 112 L107 117 L100 117 L97 114 Z" style="fill:';
    string private constant PART_41 = ';"/><path d="M117 145 L123 146 L123 148 L125 149 L121 153 L115 146 Z" style="fill:';
    string private constant PART_42 = ';"/><path d="M96 112 L99 113 L100 118 L91 118 L89 116 L91 115 L89 113 L95 113 Z" style="fill:';
    string private constant PART_43 = ';"/><path d="M154 119 L168 119 L168 122 L156 123 L156 121 L154 121 Z" style="fill:';
    string private constant PART_44 = ';"/><path d="M88 115 L96 115 L96 116 L91 117 L91 119 L100 119 L100 120 L92 120 L91 122 L91 120 L85 120 L86 117 L88 117 Z" style="fill:';
    string private constant PART_45 = ';"/>';
    string private constant COLOR_1 = 'hsl(214, 10%, 14%)';
    string private constant COLOR_2 = 'hsl(140, 2%, 37%)';
    string private constant COLOR_3 = 'hsl(220, 7%, 16%)';
    string private constant COLOR_4 = 'hsl(218, 14%, 15%)';
    string private constant COLOR_5 = 'hsl(214, 6%, 25%)';
    string private constant COLOR_6 = 'hsl(225, 3%, 25%)';
    string private constant COLOR_7 = 'hsl(150, 1%, 37%)';
    string private constant COLOR_8 = 'hsl(60, 3%, 45%)';
    string private constant COLOR_9 = 'hsl(210, 4%, 27%)';
    string private constant COLOR_10 = 'hsl(75, 2%, 39%)';
    string private constant COLOR_11 = 'hsl(240, 6%, 14%)';
    string private constant COLOR_12 = 'hsl(140, 2%, 33%)';
    string private constant COLOR_13 = 'hsl(223, 6%, 22%)';
    string private constant COLOR_14 = 'hsl(120, 1%, 39%)';
    string private constant COLOR_15 = 'hsl(67, 5%, 70%)';
    string private constant COLOR_16 = 'hsl(195, 3%, 31%)';
    string private constant COLOR_17 = 'hsl(220, 10%, 18%)';
    string private constant COLOR_18 = 'hsl(150, 1%, 34%)';
    string private constant COLOR_19 = 'hsl(216, 7%, 30%)';
    string private constant COLOR_20 = 'hsl(210, 8%, 10%)';
    string private constant COLOR_21 = 'hsl(204, 3%, 35%)';
    string private constant COLOR_22 = 'hsl(225, 17%, 9%)';
    string private constant COLOR_23 = 'hsl(218, 5%, 31%)';
    string private constant COLOR_24 = 'hsl(60, 2%, 20%)';
    string private constant COLOR_25 = 'hsl(204, 3%, 29%)';
    string private constant COLOR_26 = 'hsl(140, 1%, 41%)';
    string private constant COLOR_27 = 'hsl(220, 14%, 9%)';
    string private constant COLOR_28 = 'hsl(223, 14%, 10%)';
    string private constant COLOR_29 = 'hsl(223, 6%, 24%)';
    string private constant COLOR_30 = 'hsl(195, 3%, 31%)';
    string private constant COLOR_31 = 'hsl(22, 21%, 28%)';
    string private constant COLOR_32 = 'hsl(67, 6%, 71%)';
    string private constant COLOR_33 = 'hsl(220, 11%, 11%)';
    string private constant COLOR_34 = 'hsl(220, 7%, 8%)';
    string private constant COLOR_35 = 'hsl(21, 16%, 28%)';
    string private constant COLOR_36 = 'hsl(218, 7%, 21%)';
    string private constant COLOR_37 = 'hsl(80, 2%, 30%)';
    string private constant COLOR_38 = 'hsl(210, 4%, 29%)';
    string private constant COLOR_39 = 'hsl(223, 8%, 17%)';
    string private constant COLOR_40 = 'hsl(206, 22%, 65%)';
    string private constant COLOR_41 = 'hsl(218, 7%, 22%)';
    string private constant COLOR_42 = 'hsl(200, 2%, 32%)';
    string private constant COLOR_43 = 'hsl(60, 4%, 48%)';
    string private constant COLOR_44 = 'hsl(73, 6%, 69%)';

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
            PART_45
        );
        return result;
    }
}
