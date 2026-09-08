// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderArmor1SelfTest {
    string private constant PART_1 = '<path d="M97 111 L112 111 L110 117 L110 119 L118 119 L118 120 L110 121 L112 122 L111 125 L98 124 L92 124 L91 120 L85 120 L86 117 L88 117 L88 115 L95 113 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M167 104 L169 104 L172 107 L174 107 L176 113 L174 114 L172 118 L126 118 L125 117 L125 112 L128 113 L127 117 L136 116 L136 113 L141 113 L141 109 L137 108 L143 108 L144 109 L144 117 L160 116 L160 109 L161 108 L168 108 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M157 123 L169 123 L169 128 L166 130 L168 132 L167 134 L161 135 L159 139 L153 141 L149 139 L148 141 L146 140 L146 138 L144 137 L147 137 L148 135 L150 136 L151 133 L153 133 L152 130 L155 125 L157 125 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M92 129 L97 129 L93 130 L92 138 L95 138 L95 141 L105 137 L107 135 L107 137 L110 138 L111 140 L107 140 L107 145 L110 146 L109 150 L107 148 L104 148 L100 149 L90 147 L88 143 L96 145 L96 143 L99 143 L98 142 L92 142 L88 138 L89 131 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M118 117 L121 118 L118 123 L116 124 L116 147 L120 151 L126 153 L126 158 L121 155 L120 157 L119 155 L117 159 L128 159 L128 161 L130 161 L129 164 L116 163 L112 159 L112 157 L115 156 L116 152 L114 151 L115 149 L111 148 L113 147 L113 145 L110 144 L114 144 L113 130 L111 123 L110 121 L112 120 L118 120 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M123 118 L173 118 L171 123 L141 123 L141 122 L153 121 L152 120 L143 119 L143 121 L133 120 L124 120 L123 123 L124 122 L140 122 L140 123 L125 124 L124 125 L115 125 L119 121 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M145 126 L152 126 L148 129 L146 129 L146 131 L151 130 L152 133 L150 136 L146 138 L146 140 L151 142 L148 143 L147 145 L145 144 L146 142 L139 146 L134 145 L135 140 L139 136 L140 130 L144 131 Z M149 140 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M168 146 L174 146 L172 150 L170 152 L140 152 L140 149 L135 150 L126 150 L124 151 L125 148 L168 148 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M117 124 L126 125 L124 126 L123 132 L125 133 L124 137 L125 139 L124 142 L115 143 L115 125 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M173 118 L175 119 L175 129 L171 129 L175 130 L175 146 L169 146 L169 131 L165 130 L169 128 L169 123 L171 123 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M149 107 L167 107 L167 108 L161 109 L161 117 L144 117 L144 110 L148 109 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M168 131 L169 131 L169 146 L168 148 L150 148 L154 144 L155 147 L159 143 L162 142 L161 141 L157 140 L161 135 L163 135 L164 133 L167 134 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M88 126 L91 126 L91 128 L87 131 L86 138 L90 145 L90 147 L102 148 L107 146 L108 150 L107 151 L83 151 L83 145 L84 140 L84 133 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M134 155 L147 155 L157 156 L157 161 L142 162 L141 163 L136 163 L134 161 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M132 103 L170 103 L173 106 L172 108 L169 106 L168 105 L167 108 L166 105 L134 105 L132 109 L129 112 L125 112 L126 118 L124 118 L124 116 L120 114 L123 114 L125 110 L129 106 L131 106 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M101 128 L104 128 L105 134 L107 134 L107 132 L111 133 L110 135 L106 135 L105 138 L95 141 L95 138 L92 138 L93 130 L99 130 L101 131 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M130 137 L133 138 L133 144 L132 146 L149 147 L149 148 L124 148 L123 147 L115 146 L115 143 L120 143 L121 141 L124 142 L124 140 L129 140 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M164 164 L164 167 L162 171 L132 171 L132 167 L162 166 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M125 123 L140 123 L141 128 L137 127 L137 125 L134 125 L133 128 L128 126 L126 130 L128 130 L128 128 L135 129 L135 131 L130 136 L126 140 L124 139 L123 134 L123 132 L124 124 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M142 126 L145 127 L145 132 L141 131 L140 136 L135 143 L139 145 L137 147 L132 146 L132 139 L130 138 L130 141 L126 141 L127 137 L136 134 L137 128 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M107 144 L113 145 L115 151 L114 152 L107 152 L107 155 L104 155 L103 157 L90 158 L89 155 L92 155 L92 153 L99 153 L83 152 L83 151 L107 150 L109 149 L109 146 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M146 152 L169 152 L170 154 L168 156 L163 156 L162 160 L159 161 L157 159 L157 156 L152 156 L151 159 L151 156 L145 155 Z M107 152 L116 152 L115 157 L104 156 L103 159 L91 159 L92 157 L103 157 L104 154 L107 155 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M134 105 L154 105 L154 106 L137 107 L137 109 L141 109 L141 113 L136 113 L137 117 L127 117 L128 112 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M81 121 L82 121 L83 129 L83 152 L106 152 L106 153 L99 153 L98 155 L98 153 L96 153 L95 155 L95 153 L92 153 L92 155 L83 156 L81 155 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M162 155 L168 155 L169 156 L169 161 L162 167 L158 166 L159 165 L143 163 L143 162 L157 162 L158 159 L162 160 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M106 128 L113 128 L114 130 L114 144 L107 144 L106 143 L106 138 L107 140 L107 137 L107 135 L110 135 L110 133 L107 132 L106 134 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M174 108 L178 111 L178 117 L177 118 L176 149 L172 153 L170 160 L169 160 L169 152 L174 146 L175 130 L168 130 L172 128 L175 129 L174 119 L172 117 L174 113 L174 111 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M149 139 L153 139 L153 141 L157 140 L165 140 L162 144 L157 145 L157 147 L155 147 L154 147 L149 148 L139 147 L144 142 L146 142 L147 145 L148 142 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M90 120 L92 124 L105 123 L112 124 L112 128 L106 128 L106 134 L104 130 L104 128 L102 129 L101 132 L93 129 L93 128 L98 127 L91 126 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M124 119 L138 119 L143 121 L143 119 L152 119 L154 122 L141 122 L141 125 L145 125 L144 128 L140 126 L140 122 L124 123 L121 123 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M115 146 L123 146 L125 150 L126 149 L140 149 L140 152 L120 152 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M91 126 L98 126 L99 128 L92 130 L89 131 L89 138 L92 141 L99 141 L99 143 L96 143 L96 145 L90 144 L86 140 L85 134 L88 129 L91 128 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M84 120 L90 120 L91 126 L88 126 L86 130 L85 133 L85 144 L83 145 L83 121 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M114 111 L118 113 L124 116 L122 120 L119 121 L120 118 L118 117 L118 119 L109 120 L109 117 L111 112 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M97 109 L115 109 L114 112 L97 112 L94 115 L88 115 L88 117 L84 121 L83 129 L82 129 L81 120 L89 113 L94 112 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M130 157 L136 162 L141 162 L142 161 L157 161 L157 162 L148 163 L160 164 L160 165 L135 165 L130 160 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M118 153 L121 155 L125 156 L126 155 L133 155 L132 159 L131 160 L130 163 L130 161 L128 161 L128 159 L121 160 L116 159 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M141 123 L157 123 L157 125 L155 125 L153 131 L152 133 L149 131 L146 131 L146 129 L150 127 L141 125 Z" style="fill:';
    string private constant PART_39 = ';"/><path d="M131 162 L135 164 L159 165 L158 167 L131 168 L129 163 Z" style="fill:';
    string private constant PART_40 = ';"/><path d="M154 105 L166 105 L166 107 L149 107 L148 111 L143 109 L135 107 L135 106 Z" style="fill:';
    string private constant PART_41 = ';"/><path d="M133 151 L146 152 L145 155 L134 155 L134 160 L133 160 L133 155 L126 155 L125 152 Z" style="fill:';
    string private constant PART_42 = ';"/><path d="M132 124 L139 124 L137 125 L139 126 L139 128 L137 128 L136 134 L134 134 L133 136 L130 136 L132 132 L135 131 L130 130 L130 128 L128 128 L128 130 L126 130 L127 125 L131 126 L133 127 L134 125 Z" style="fill:';
    string private constant PART_43 = ';"/>';
    string private constant COLOR_1 = 'hsl(203, 4%, 41%)';
    string private constant COLOR_2 = 'hsl(214, 7%, 19%)';
    string private constant COLOR_3 = 'hsl(160, 2%, 35%)';
    string private constant COLOR_4 = 'hsl(223, 9%, 15%)';
    string private constant COLOR_5 = 'hsl(228, 9%, 11%)';
    string private constant COLOR_6 = 'hsl(80, 3%, 64%)';
    string private constant COLOR_7 = 'hsl(150, 1%, 38%)';
    string private constant COLOR_8 = 'hsl(223, 9%, 15%)';
    string private constant COLOR_9 = 'hsl(150, 1%, 36%)';
    string private constant COLOR_10 = 'hsl(214, 6%, 22%)';
    string private constant COLOR_11 = 'hsl(160, 2%, 32%)';
    string private constant COLOR_12 = 'hsl(120, 1%, 40%)';
    string private constant COLOR_13 = 'hsl(210, 3%, 25%)';
    string private constant COLOR_14 = 'hsl(0, 2%, 24%)';
    string private constant COLOR_15 = 'hsl(220, 9%, 13%)';
    string private constant COLOR_16 = 'hsl(16, 10%, 21%)';
    string private constant COLOR_17 = 'hsl(120, 1%, 41%)';
    string private constant COLOR_18 = 'hsl(223, 12%, 11%)';
    string private constant COLOR_19 = 'hsl(200, 2%, 29%)';
    string private constant COLOR_20 = 'hsl(160, 2%, 35%)';
    string private constant COLOR_21 = 'hsl(214, 15%, 18%)';
    string private constant COLOR_22 = 'hsl(220, 9%, 13%)';
    string private constant COLOR_23 = 'hsl(200, 2%, 32%)';
    string private constant COLOR_24 = 'hsl(220, 12%, 10%)';
    string private constant COLOR_25 = 'hsl(214, 8%, 18%)';
    string private constant COLOR_26 = 'hsl(240, 1%, 26%)';
    string private constant COLOR_27 = 'hsl(228, 11%, 9%)';
    string private constant COLOR_28 = 'hsl(160, 2%, 33%)';
    string private constant COLOR_29 = 'hsl(223, 7%, 20%)';
    string private constant COLOR_30 = 'hsl(90, 2%, 45%)';
    string private constant COLOR_31 = 'hsl(214, 7%, 20%)';
    string private constant COLOR_32 = 'hsl(180, 2%, 32%)';
    string private constant COLOR_33 = 'hsl(160, 2%, 34%)';
    string private constant COLOR_34 = 'hsl(210, 6%, 20%)';
    string private constant COLOR_35 = 'hsl(220, 9%, 13%)';
    string private constant COLOR_36 = 'hsl(160, 2%, 36%)';
    string private constant COLOR_37 = 'hsl(223, 7%, 21%)';
    string private constant COLOR_38 = 'hsl(210, 3%, 23%)';
    string private constant COLOR_39 = 'hsl(214, 8%, 17%)';
    string private constant COLOR_40 = 'hsl(105, 2%, 47%)';
    string private constant COLOR_41 = 'hsl(220, 11%, 11%)';
    string private constant COLOR_42 = 'hsl(120, 1%, 41%)';

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
