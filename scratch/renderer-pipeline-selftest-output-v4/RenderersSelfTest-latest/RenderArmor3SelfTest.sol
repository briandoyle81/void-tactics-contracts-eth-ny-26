// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderArmor3SelfTest {
    string private constant PART_1 = '<path d="M127 103 L160 103 L163 107 L174 108 L174 119 L178 121 L178 133 L177 134 L176 157 L175 159 L168 160 L168 172 L160 172 L157 176 L151 176 L150 180 L130 180 L123 172 L110 171 L107 164 L107 161 L99 161 L98 167 L86 167 L83 163 L83 161 L79 160 L78 159 L78 119 L82 114 L90 113 L96 106 L110 106 L112 108 L112 114 L119 112 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M141 104 L160 104 L163 107 L163 111 L166 111 L166 109 L172 109 L173 110 L173 118 L172 120 L175 120 L176 122 L176 132 L174 136 L171 136 L170 148 L168 151 L164 151 L164 136 L166 134 L163 130 L162 139 L152 139 L152 151 L135 151 L135 140 L142 138 L135 139 L123 139 L122 131 L122 121 L125 120 L151 120 L149 117 L147 119 L139 119 L138 118 L138 105 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M96 106 L110 106 L112 108 L112 111 L110 111 L110 114 L100 114 L100 116 L110 116 L112 116 L120 115 L121 117 L121 128 L120 128 L119 123 L118 127 L116 127 L115 131 L116 130 L119 129 L120 132 L121 133 L121 151 L120 153 L120 159 L119 160 L113 160 L109 157 L108 144 L100 143 L99 126 L96 123 L83 122 L81 122 L79 126 L79 120 L83 116 L97 115 L92 114 L93 110 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M122 121 L160 121 L161 128 L158 133 L159 135 L155 137 L155 139 L152 140 L152 151 L135 151 L135 140 L142 138 L135 139 L123 139 L122 131 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M134 122 L135 122 L135 139 L143 137 L141 140 L135 140 L135 151 L144 150 L152 151 L152 140 L144 140 L144 139 L152 139 L152 123 L153 123 L153 139 L162 139 L162 157 L159 160 L125 160 L122 157 L122 131 L123 131 L123 139 L134 139 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M127 103 L160 103 L160 104 L138 105 L139 118 L147 118 L148 117 L149 105 L150 105 L151 120 L122 121 L123 157 L126 160 L132 162 L132 174 L127 174 L126 170 L124 170 L123 168 L119 168 L118 163 L117 169 L113 169 L113 161 L119 161 L120 153 L117 152 L120 151 L120 133 L118 133 L119 129 L116 132 L114 131 L116 127 L118 127 L119 118 L120 115 L112 116 L111 119 L110 117 L100 116 L100 114 L110 114 L110 111 L112 111 L112 114 L119 112 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M135 127 L147 127 L150 127 L152 127 L152 151 L135 151 L135 140 L142 138 L135 139 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M91 112 L92 114 L98 114 L97 116 L83 117 L80 120 L80 122 L83 120 L83 122 L96 122 L99 126 L99 152 L97 148 L96 149 L86 149 L90 147 L83 146 L81 144 L82 141 L83 142 L83 141 L92 140 L92 131 L96 132 L96 140 L96 141 L97 128 L95 126 L83 126 L80 128 L80 142 L81 147 L81 157 L84 157 L87 159 L84 160 L83 163 L83 161 L79 160 L78 159 L78 119 L82 114 L90 113 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M165 121 L175 121 L176 122 L176 132 L174 136 L171 136 L170 148 L168 151 L164 151 L164 136 L166 134 L163 130 L163 124 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M119 134 L120 134 L121 141 L121 151 L120 153 L120 159 L119 160 L113 160 L109 157 L109 139 L118 139 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M163 108 L174 108 L174 119 L178 121 L178 133 L177 134 L176 157 L174 158 L167 158 L165 151 L168 150 L169 148 L170 138 L171 136 L174 135 L175 128 L175 120 L172 120 L172 110 L166 109 L166 111 L163 111 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M83 125 L95 125 L98 128 L97 141 L93 143 L95 140 L95 134 L94 131 L93 132 L93 138 L90 141 L84 142 L82 143 L81 138 L83 138 L83 132 L81 131 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M133 161 L149 161 L149 169 L148 173 L133 173 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M80 127 L82 127 L81 131 L84 132 L83 138 L81 138 L83 145 L94 146 L93 148 L98 147 L96 153 L94 155 L83 155 L82 152 L80 152 L80 145 L79 142 L79 128 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M127 105 L136 105 L136 117 L135 119 L125 119 L123 116 L123 110 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M97 150 L98 154 L98 158 L91 158 L91 160 L97 160 L97 166 L85 166 L84 160 L86 159 L84 158 L82 160 L80 155 L80 152 L82 152 L83 154 L94 154 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M100 125 L108 125 L108 144 L100 143 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M122 121 L125 122 L123 127 L134 127 L134 139 L123 139 L122 131 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M138 105 L148 105 L149 117 L147 119 L139 119 L138 118 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M96 106 L110 106 L112 108 L112 111 L110 111 L110 114 L92 114 L93 110 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M91 112 L92 114 L98 114 L97 116 L83 117 L80 120 L79 126 L81 127 L80 128 L80 142 L81 147 L81 157 L84 157 L87 159 L84 160 L83 163 L83 161 L79 160 L78 159 L78 119 L82 114 L90 113 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M150 105 L159 105 L159 110 L155 110 L161 114 L161 119 L151 119 L150 117 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M122 140 L134 140 L134 151 L123 151 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M99 125 L100 125 L100 143 L107 143 L108 125 L109 125 L110 157 L111 159 L109 160 L109 163 L107 163 L107 161 L99 161 L99 160 L106 160 L106 158 L102 157 L107 156 L108 146 L102 146 L100 145 L100 156 L98 157 L97 153 L98 152 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M118 116 L121 117 L121 128 L120 128 L119 123 L118 127 L116 127 L114 132 L110 131 L110 122 L113 119 L113 117 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M110 140 L117 140 L121 142 L121 151 L118 150 L117 151 L111 151 L110 149 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M153 140 L162 140 L162 151 L153 151 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M125 120 L161 120 L162 121 L162 139 L155 139 L157 133 L160 128 L160 121 L125 121 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M168 134 L171 135 L170 148 L168 151 L164 151 L164 138 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M163 108 L174 108 L174 119 L178 121 L178 133 L174 141 L171 140 L171 136 L174 135 L175 128 L175 120 L172 120 L172 110 L166 109 L166 111 L163 111 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M152 161 L159 161 L159 172 L154 173 L151 168 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M125 121 L152 121 L152 122 L134 122 L134 127 L132 128 L123 127 L124 122 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M131 176 L149 176 L150 178 L149 180 L130 180 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M84 160 L97 160 L97 166 L85 166 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M117 129 L119 129 L120 132 L121 133 L121 141 L118 140 L110 139 L110 133 L116 132 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M100 145 L108 146 L108 156 L102 156 L100 154 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M144 130 L146 130 L145 134 L147 134 L148 131 L152 132 L152 139 L141 140 L141 137 L143 134 L142 132 L144 132 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M83 125 L94 125 L96 131 L91 128 L86 128 L85 130 L90 129 L91 131 L86 132 L85 137 L87 140 L83 138 L83 132 L81 131 Z" style="fill:';
    string private constant PART_39 = ';"/><path d="M126 160 L146 160 L146 161 L133 161 L134 175 L130 176 L128 178 L123 172 L123 162 L124 162 L124 170 L126 170 L127 168 L127 174 L132 174 L131 162 L126 161 Z" style="fill:';
    string private constant PART_40 = ';"/><path d="M172 149 L175 149 L175 157 L174 158 L167 158 L165 151 Z" style="fill:';
    string private constant PART_41 = ';"/><path d="M166 109 L172 109 L173 110 L173 118 L172 119 L166 119 Z" style="fill:';
    string private constant PART_42 = ';"/><path d="M141 104 L160 104 L163 107 L162 112 L160 114 L155 111 L154 109 L159 110 L159 105 L149 105 L149 116 L148 116 L148 105 L141 105 Z" style="fill:';
    string private constant PART_43 = ';"/>';
    string private constant COLOR_1 = 'hsl(222, 14%, 14%)';
    string private constant COLOR_2 = 'hsl(218, 11%, 14%)';
    string private constant COLOR_3 = 'hsl(210, 1%, 29%)';
    string private constant COLOR_4 = 'hsl(48, 4%, 44%)';
    string private constant COLOR_5 = 'hsl(214, 7%, 21%)';
    string private constant COLOR_6 = 'hsl(223, 9%, 16%)';
    string private constant COLOR_7 = 'hsl(51, 4%, 39%)';
    string private constant COLOR_8 = 'hsl(218, 13%, 16%)';
    string private constant COLOR_9 = 'hsl(30, 1%, 35%)';
    string private constant COLOR_10 = 'hsl(214, 7%, 21%)';
    string private constant COLOR_11 = 'hsl(222, 13%, 15%)';
    string private constant COLOR_12 = 'hsl(240, 2%, 27%)';
    string private constant COLOR_13 = 'hsl(220, 5%, 24%)';
    string private constant COLOR_14 = 'hsl(220, 5%, 23%)';
    string private constant COLOR_15 = 'hsl(0, 0%, 35%)';
    string private constant COLOR_16 = 'hsl(213, 13%, 16%)';
    string private constant COLOR_17 = 'hsl(240, 1%, 30%)';
    string private constant COLOR_18 = 'hsl(40, 3%, 38%)';
    string private constant COLOR_19 = 'hsl(60, 2%, 38%)';
    string private constant COLOR_20 = 'hsl(210, 1%, 32%)';
    string private constant COLOR_21 = 'hsl(220, 18%, 10%)';
    string private constant COLOR_22 = 'hsl(30, 1%, 35%)';
    string private constant COLOR_23 = 'hsl(30, 1%, 34%)';
    string private constant COLOR_24 = 'hsl(216, 22%, 9%)';
    string private constant COLOR_25 = 'hsl(42, 4%, 50%)';
    string private constant COLOR_26 = 'hsl(45, 2%, 38%)';
    string private constant COLOR_27 = 'hsl(30, 1%, 33%)';
    string private constant COLOR_28 = 'hsl(30, 4%, 30%)';
    string private constant COLOR_29 = 'hsl(30, 1%, 31%)';
    string private constant COLOR_30 = 'hsl(213, 15%, 12%)';
    string private constant COLOR_31 = 'hsl(214, 6%, 23%)';
    string private constant COLOR_32 = 'hsl(43, 7%, 52%)';
    string private constant COLOR_33 = 'hsl(218, 8%, 20%)';
    string private constant COLOR_34 = 'hsl(213, 11%, 20%)';
    string private constant COLOR_35 = 'hsl(45, 2%, 39%)';
    string private constant COLOR_36 = 'hsl(213, 11%, 20%)';
    string private constant COLOR_37 = 'hsl(60, 3%, 43%)';
    string private constant COLOR_38 = 'hsl(40, 4%, 54%)';
    string private constant COLOR_39 = 'hsl(213, 24%, 9%)';
    string private constant COLOR_40 = 'hsl(213, 9%, 21%)';
    string private constant COLOR_41 = 'hsl(0, 1%, 34%)';
    string private constant COLOR_42 = 'hsl(223, 8%, 18%)';

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
