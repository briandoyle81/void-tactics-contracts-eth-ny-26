// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderArmor3SelfTest {
    string private constant PART_1 = '<path d="M165 121 L175 121 L177 123 L177 134 L172 136 L171 138 L170 148 L168 151 L164 151 L164 136 L166 134 L164 130 L166 127 L165 126 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M125 121 L160 121 L161 128 L155 127 L153 128 L152 139 L141 140 L141 137 L143 134 L142 132 L144 132 L145 128 L141 127 L141 125 L145 124 L145 123 L139 122 L140 127 L135 127 L133 123 L126 123 L123 127 L124 122 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M83 116 L98 116 L100 119 L100 116 L108 116 L108 121 L109 123 L108 129 L105 130 L105 128 L101 128 L102 134 L101 138 L103 139 L100 139 L99 126 L96 123 L83 123 L79 126 L79 120 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M83 125 L94 125 L96 131 L93 132 L93 138 L90 141 L85 141 L85 143 L82 143 L79 140 L79 128 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M134 122 L135 122 L135 139 L143 137 L141 140 L135 140 L135 161 L149 161 L149 163 L135 163 L134 166 L133 161 L125 160 L124 157 L122 157 L122 141 L123 141 L124 151 L134 152 L134 140 L122 140 L122 131 L123 131 L123 139 L134 139 Z M109 124 L110 124 L111 131 L114 133 L110 133 L110 139 L118 139 L119 134 L120 134 L121 142 L120 148 L119 148 L119 141 L110 140 L111 151 L117 151 L118 149 L120 149 L121 157 L119 160 L113 160 L109 157 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M80 152 L82 152 L84 155 L94 156 L98 157 L100 154 L107 154 L106 160 L99 160 L98 167 L86 167 L84 164 L84 160 L86 159 L83 158 L82 160 L80 158 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M175 134 L176 134 L176 157 L175 159 L164 159 L163 158 L163 152 L168 150 L169 148 L170 138 L172 135 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M123 121 L125 122 L126 122 L133 122 L134 123 L134 139 L123 139 L122 131 L122 122 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M135 140 L152 140 L152 151 L135 151 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M94 125 L99 128 L99 141 L97 146 L93 148 L85 148 L80 144 L79 140 L82 141 L82 143 L85 143 L85 141 L92 140 L92 131 L96 131 L94 128 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M101 128 L107 128 L108 129 L108 144 L102 144 L102 146 L108 146 L108 156 L102 156 L100 153 L100 139 L101 134 Z M152 161 L159 161 L159 172 L156 175 L152 175 L151 173 L151 163 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M123 159 L134 160 L134 169 L135 173 L142 172 L150 173 L149 177 L131 177 L142 178 L142 179 L129 179 L128 174 L132 174 L131 162 L127 161 L127 175 L123 172 L122 160 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M96 106 L110 106 L112 108 L112 114 L119 112 L125 106 L127 106 L126 111 L124 111 L124 118 L121 119 L121 117 L115 118 L113 117 L113 119 L118 119 L118 120 L111 121 L109 120 L109 122 L104 122 L108 121 L108 116 L102 115 L102 114 L110 114 L110 108 L96 108 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M133 163 L149 163 L149 173 L133 173 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M159 106 L163 107 L163 110 L166 111 L166 118 L166 121 L166 126 L167 128 L165 128 L165 130 L163 130 L162 122 L155 120 L151 119 L151 115 L158 115 L154 109 L159 110 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M127 105 L136 105 L136 117 L135 119 L125 119 L124 118 L124 111 L126 111 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M91 112 L92 114 L102 114 L110 115 L110 116 L100 116 L101 124 L99 120 L98 116 L83 117 L80 120 L80 124 L83 122 L96 122 L99 126 L98 128 L95 126 L83 126 L79 128 L78 127 L78 119 L82 114 L90 113 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M152 123 L153 123 L153 139 L162 139 L162 140 L153 140 L153 160 L146 160 L145 159 L138 158 L140 155 L141 154 L140 152 L152 152 L152 140 L144 140 L144 139 L152 139 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M138 105 L148 105 L149 117 L147 119 L139 119 L138 118 Z M110 140 L117 140 L121 142 L121 151 L118 150 L117 151 L111 151 L110 149 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M160 159 L167 160 L167 163 L161 164 L162 168 L167 168 L168 172 L160 172 L157 176 L151 176 L150 179 L149 173 L149 161 L135 161 L135 160 Z M152 161 L151 163 L151 173 L152 175 L156 175 L159 172 L159 161 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M122 140 L134 140 L134 152 L124 152 L123 151 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M80 147 L82 148 L97 148 L99 155 L98 158 L84 156 L82 152 L80 152 Z M127 161 L132 162 L132 174 L128 174 L127 176 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M139 122 L146 122 L145 126 L141 125 L141 127 L147 127 L144 132 L142 136 L140 139 L135 139 L135 127 L140 127 L138 126 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M162 122 L163 122 L164 130 L165 133 L167 134 L165 136 L164 158 L170 159 L168 160 L168 169 L161 169 L160 164 L161 163 L167 163 L167 160 L162 160 L161 157 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M149 105 L150 105 L151 119 L155 120 L125 121 L123 122 L122 132 L118 133 L119 129 L116 132 L114 131 L116 127 L118 127 L119 118 L122 118 L136 118 L139 118 L147 118 L148 117 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M127 103 L160 103 L162 107 L149 105 L149 116 L148 116 L148 105 L138 105 L138 117 L136 119 L135 117 L136 105 L125 106 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M121 132 L122 132 L122 157 L124 157 L122 161 L113 161 L113 171 L109 170 L107 163 L109 159 L119 159 L120 153 L118 152 L120 151 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M118 116 L121 117 L121 128 L120 128 L119 123 L118 127 L116 127 L114 132 L110 131 L110 121 L113 119 L113 117 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M95 108 L110 108 L110 114 L92 114 L93 110 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M113 161 L123 161 L123 171 L113 171 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M153 140 L162 140 L162 151 L153 151 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M99 125 L100 125 L101 153 L99 157 L97 153 L96 149 L82 149 L81 148 L79 151 L80 144 L85 147 L93 147 L97 143 L98 141 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M125 120 L161 120 L162 121 L162 139 L155 139 L157 133 L160 132 L160 121 L125 121 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M109 120 L111 121 L110 124 L110 157 L111 159 L109 160 L109 163 L107 163 L107 161 L99 161 L99 160 L106 160 L106 158 L102 157 L107 156 L108 146 L102 146 L102 144 L107 143 L108 123 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M150 105 L159 105 L159 110 L155 110 L158 113 L158 115 L151 115 L150 117 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M153 151 L162 151 L162 157 L160 160 L153 160 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M117 129 L119 129 L120 132 L121 133 L121 141 L118 140 L110 139 L110 133 L116 132 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M163 108 L174 108 L174 119 L178 121 L178 133 L177 133 L176 123 L175 122 L166 121 L164 118 L172 118 L172 110 L166 109 L166 111 L161 110 Z" style="fill:';
    string private constant PART_39 = ';"/><path d="M138 150 L152 151 L152 152 L140 152 L144 154 L140 156 L140 158 L146 158 L146 160 L135 160 L135 151 Z" style="fill:';
    string private constant PART_40 = ';"/><path d="M166 109 L172 109 L173 110 L173 118 L172 119 L166 119 Z" style="fill:';
    string private constant PART_41 = ';"/><path d="M154 126 L160 127 L161 132 L158 133 L159 135 L155 137 L155 139 L153 139 L153 128 Z" style="fill:';
    string private constant PART_42 = ';"/><path d="M131 176 L149 176 L150 180 L130 180 Z" style="fill:';
    string private constant PART_43 = ';"/><path d="M78 127 L79 127 L80 151 L81 158 L82 158 L83 156 L88 158 L84 160 L83 163 L83 161 L79 160 L78 159 Z" style="fill:';
    string private constant PART_44 = ';"/>';
    string private constant COLOR_1 = 'hsl(60, 1%, 34%)';
    string private constant COLOR_2 = 'hsl(48, 4%, 47%)';
    string private constant COLOR_3 = 'hsl(60, 1%, 36%)';
    string private constant COLOR_4 = 'hsl(60, 1%, 34%)';
    string private constant COLOR_5 = 'hsl(214, 7%, 21%)';
    string private constant COLOR_6 = 'hsl(220, 11%, 15%)';
    string private constant COLOR_7 = 'hsl(213, 11%, 17%)';
    string private constant COLOR_8 = 'hsl(50, 3%, 40%)';
    string private constant COLOR_9 = 'hsl(60, 3%, 39%)';
    string private constant COLOR_10 = 'hsl(214, 7%, 20%)';
    string private constant COLOR_11 = 'hsl(214, 6%, 21%)';
    string private constant COLOR_12 = 'hsl(216, 17%, 12%)';
    string private constant COLOR_13 = 'hsl(214, 7%, 19%)';
    string private constant COLOR_14 = 'hsl(204, 4%, 25%)';
    string private constant COLOR_15 = 'hsl(220, 6%, 21%)';
    string private constant COLOR_16 = 'hsl(60, 1%, 35%)';
    string private constant COLOR_17 = 'hsl(216, 16%, 13%)';
    string private constant COLOR_18 = 'hsl(223, 7%, 19%)';
    string private constant COLOR_19 = 'hsl(45, 2%, 38%)';
    string private constant COLOR_20 = 'hsl(216, 18%, 11%)';
    string private constant COLOR_21 = 'hsl(120, 1%, 33%)';
    string private constant COLOR_22 = 'hsl(216, 4%, 24%)';
    string private constant COLOR_23 = 'hsl(50, 3%, 40%)';
    string private constant COLOR_24 = 'hsl(210, 10%, 16%)';
    string private constant COLOR_25 = 'hsl(218, 11%, 14%)';
    string private constant COLOR_26 = 'hsl(214, 10%, 14%)';
    string private constant COLOR_27 = 'hsl(216, 14%, 14%)';
    string private constant COLOR_28 = 'hsl(42, 4%, 49%)';
    string private constant COLOR_29 = 'hsl(60, 1%, 33%)';
    string private constant COLOR_30 = 'hsl(218, 9%, 18%)';
    string private constant COLOR_31 = 'hsl(0, 0%, 33%)';
    string private constant COLOR_32 = 'hsl(220, 16%, 11%)';
    string private constant COLOR_33 = 'hsl(60, 1%, 30%)';
    string private constant COLOR_34 = 'hsl(216, 20%, 10%)';
    string private constant COLOR_35 = 'hsl(45, 2%, 39%)';
    string private constant COLOR_36 = 'hsl(213, 9%, 20%)';
    string private constant COLOR_37 = 'hsl(60, 2%, 39%)';
    string private constant COLOR_38 = 'hsl(216, 17%, 11%)';
    string private constant COLOR_39 = 'hsl(214, 6%, 22%)';
    string private constant COLOR_40 = 'hsl(60, 1%, 34%)';
    string private constant COLOR_41 = 'hsl(51, 3%, 40%)';
    string private constant COLOR_42 = 'hsl(220, 5%, 22%)';
    string private constant COLOR_43 = 'hsl(213, 23%, 9%)';

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
