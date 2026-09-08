// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderArmor3SelfTest {
    string private constant PART_1 = '<path d="M127 103 L160 103 L163 107 L174 108 L174 119 L178 121 L178 133 L177 134 L176 157 L175 159 L168 160 L168 172 L160 172 L157 176 L151 176 L150 180 L130 180 L123 172 L110 171 L107 164 L107 161 L99 161 L98 167 L86 167 L83 163 L83 161 L79 160 L78 159 L78 119 L82 114 L90 113 L96 106 L110 106 L112 108 L112 114 L119 112 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M145 104 L160 104 L163 107 L174 108 L174 119 L178 121 L178 133 L177 134 L176 157 L175 157 L175 149 L168 151 L164 151 L164 136 L166 134 L165 131 L163 131 L163 151 L162 151 L162 139 L152 139 L152 151 L138 151 L135 152 L123 151 L122 141 L122 121 L125 120 L139 119 L138 118 L138 105 Z M149 105 L148 118 L151 118 L150 105 Z M147 118 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M163 131 L165 131 L165 133 L167 134 L165 136 L164 151 L172 149 L175 149 L175 159 L168 160 L168 172 L160 172 L157 176 L151 176 L150 180 L130 180 L123 172 L110 171 L107 163 L109 159 L119 159 L120 153 L118 152 L122 151 L124 158 L125 159 L161 159 L162 151 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M127 103 L160 103 L160 104 L138 105 L139 118 L147 119 L147 120 L122 121 L123 151 L137 151 L139 150 L152 151 L152 140 L144 140 L144 139 L152 139 L152 123 L153 123 L153 139 L162 139 L162 157 L159 160 L125 160 L122 157 L121 151 L120 133 L118 133 L119 129 L116 132 L114 131 L116 127 L118 127 L119 118 L119 117 L115 118 L113 117 L113 119 L118 119 L118 120 L111 120 L110 113 L112 112 L112 114 L119 112 Z M149 105 L150 105 L151 118 L148 118 Z M147 118 Z M120 151 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M122 121 L160 121 L161 128 L155 127 L153 128 L152 140 L152 151 L138 151 L135 152 L123 151 L122 141 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M80 127 L82 127 L81 131 L84 132 L84 138 L87 140 L91 140 L92 138 L92 131 L96 132 L96 140 L96 141 L97 144 L96 149 L94 149 L94 151 L82 151 L81 150 L80 152 L82 152 L84 155 L97 155 L98 167 L86 167 L83 163 L83 161 L79 160 L78 159 L78 143 L79 128 Z M98 136 L99 140 Z M97 140 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M117 129 L119 129 L120 132 L121 133 L121 151 L120 153 L120 159 L119 160 L113 160 L109 156 L109 139 L110 133 L116 132 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M125 121 L160 121 L161 128 L155 127 L152 127 L140 128 L135 127 L134 139 L130 137 L126 132 L124 131 L123 123 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M122 121 L125 122 L124 127 L124 131 L127 132 L132 138 L134 139 L134 122 L135 122 L135 139 L143 137 L141 140 L135 140 L136 150 L137 152 L123 151 L122 141 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M83 125 L95 125 L98 128 L99 136 L97 141 L93 143 L95 140 L95 134 L94 131 L93 132 L93 138 L91 141 L85 140 L83 138 L83 132 L81 131 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M133 161 L149 161 L149 174 L133 174 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M165 121 L175 121 L177 124 L176 157 L175 157 L175 149 L169 150 L170 138 L171 136 L174 135 L175 130 L170 130 L169 128 L165 128 L165 130 L163 130 L163 124 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M100 146 L108 146 L108 156 L102 156 L102 154 L100 154 L98 158 L96 157 L96 156 L84 156 L82 152 L80 152 L81 149 L82 150 L96 150 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M102 116 L110 116 L111 120 L113 119 L113 117 L119 116 L121 117 L121 128 L120 128 L119 123 L118 127 L116 127 L114 132 L110 131 L109 123 L107 124 L102 123 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M167 127 L173 128 L176 129 L175 135 L171 136 L170 148 L168 151 L164 151 L164 136 L166 134 L164 130 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M131 105 L136 105 L136 117 L135 119 L125 119 L123 116 L123 110 L126 107 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M125 120 L161 120 L162 121 L162 139 L153 139 L153 128 L155 126 L160 127 L160 121 L125 121 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M100 125 L108 125 L108 144 L101 143 L100 142 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M96 106 L110 106 L112 108 L111 113 L110 114 L92 114 L93 110 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M138 105 L148 105 L149 117 L147 119 L139 119 L138 118 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M83 116 L98 116 L100 120 L99 126 L96 123 L83 123 L79 126 L79 120 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M150 105 L159 105 L159 110 L155 110 L159 112 L161 112 L161 119 L151 119 L150 117 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M122 140 L134 140 L134 151 L123 151 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M152 161 L159 161 L159 171 L154 176 L151 176 L151 163 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M110 140 L117 140 L121 142 L121 151 L118 150 L117 151 L111 151 L110 149 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M153 140 L162 140 L162 151 L153 151 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M170 149 L175 149 L175 159 L165 159 L163 153 L165 153 L165 151 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M84 160 L97 160 L98 167 L86 167 L84 164 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M124 127 L134 127 L134 139 L130 137 L126 132 L124 131 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M131 176 L149 176 L151 177 L150 180 L130 180 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M83 125 L94 125 L96 131 L91 128 L86 128 L85 130 L90 129 L91 131 L86 132 L85 137 L87 140 L83 138 L83 132 L81 131 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M98 108 L110 108 L110 114 L99 114 L99 110 L97 109 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M135 163 L147 163 L149 165 L149 168 L135 168 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M122 121 L125 122 L124 127 L124 131 L127 132 L132 139 L123 139 L122 130 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M102 116 L110 116 L112 121 L107 124 L102 123 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M128 163 L132 164 L132 174 L130 176 L127 176 L127 164 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M80 149 L82 150 L97 150 L95 154 L94 155 L83 155 L82 152 L80 152 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M117 129 L119 129 L120 132 L121 133 L121 141 L112 139 L114 132 L116 132 Z" style="fill:';
    string private constant PART_39 = ';"/><path d="M165 109 L171 109 L171 118 L166 118 L165 114 L163 117 L163 111 L165 111 Z" style="fill:';
    string private constant PART_40 = ';"/><path d="M142 109 L147 110 L147 117 L142 118 L139 117 L139 111 Z" style="fill:';
    string private constant PART_41 = ';"/><path d="M165 121 L175 121 L176 122 L176 128 L175 126 L165 126 Z" style="fill:';
    string private constant PART_42 = ';"/><path d="M100 116 L102 116 L102 123 L108 123 L110 121 L111 131 L114 133 L110 133 L110 139 L109 139 L109 125 L99 125 Z" style="fill:';
    string private constant PART_43 = ';"/><path d="M83 116 L97 116 L96 120 L83 120 L79 123 L80 119 Z" style="fill:';
    string private constant PART_44 = ';"/><path d="M126 107 L132 108 L132 111 L128 113 L128 118 L124 118 L123 116 L123 110 Z" style="fill:';
    string private constant PART_45 = ';"/><path d="M110 133 L114 134 L112 139 L118 139 L119 134 L120 134 L121 142 L120 148 L119 148 L119 141 L110 140 L110 149 L109 149 L109 139 Z" style="fill:';
    string private constant PART_46 = ';"/><path d="M164 122 L165 126 L175 126 L177 124 L177 134 L175 134 L175 130 L170 130 L169 128 L165 128 L165 130 L163 130 L163 124 Z" style="fill:';
    string private constant PART_47 = ';"/><path d="M80 127 L82 127 L81 131 L84 132 L83 140 L84 143 L82 143 L81 139 L79 139 L79 128 Z" style="fill:';
    string private constant PART_48 = ';"/><path d="M153 121 L160 121 L161 128 L155 127 L153 128 Z" style="fill:';
    string private constant PART_49 = ';"/><path d="M160 163 L168 163 L168 170 L160 167 Z" style="fill:';
    string private constant PART_50 = ';"/><path d="M100 125 L108 125 L107 129 L105 130 L105 128 L101 128 L102 134 L101 138 L103 139 L100 139 Z" style="fill:';
    string private constant PART_51 = ';"/><path d="M150 105 L159 105 L159 110 L150 110 Z" style="fill:';
    string private constant PART_52 = ';"/>';
    string private constant COLOR_1 = 'hsl(216, 17%, 11%)';
    string private constant COLOR_2 = 'hsl(220, 13%, 14%)';
    string private constant COLOR_3 = 'hsl(216, 14%, 14%)';
    string private constant COLOR_4 = 'hsl(218, 9%, 18%)';
    string private constant COLOR_5 = 'hsl(43, 3%, 40%)';
    string private constant COLOR_6 = 'hsl(216, 13%, 15%)';
    string private constant COLOR_7 = 'hsl(213, 9%, 20%)';
    string private constant COLOR_8 = 'hsl(47, 6%, 48%)';
    string private constant COLOR_9 = 'hsl(0, 0%, 24%)';
    string private constant COLOR_10 = 'hsl(240, 2%, 26%)';
    string private constant COLOR_11 = 'hsl(216, 10%, 20%)';
    string private constant COLOR_12 = 'hsl(218, 15%, 14%)';
    string private constant COLOR_13 = 'hsl(213, 11%, 19%)';
    string private constant COLOR_14 = 'hsl(42, 4%, 50%)';
    string private constant COLOR_15 = 'hsl(0, 0%, 32%)';
    string private constant COLOR_16 = 'hsl(60, 1%, 38%)';
    string private constant COLOR_17 = 'hsl(40, 3%, 34%)';
    string private constant COLOR_18 = 'hsl(210, 3%, 23%)';
    string private constant COLOR_19 = 'hsl(210, 4%, 26%)';
    string private constant COLOR_20 = 'hsl(45, 3%, 46%)';
    string private constant COLOR_21 = 'hsl(210, 7%, 21%)';
    string private constant COLOR_22 = 'hsl(180, 1%, 30%)';
    string private constant COLOR_23 = 'hsl(30, 1%, 34%)';
    string private constant COLOR_24 = 'hsl(218, 7%, 21%)';
    string private constant COLOR_25 = 'hsl(45, 2%, 38%)';
    string private constant COLOR_26 = 'hsl(30, 1%, 33%)';
    string private constant COLOR_27 = 'hsl(210, 10%, 19%)';
    string private constant COLOR_28 = 'hsl(218, 11%, 19%)';
    string private constant COLOR_29 = 'hsl(51, 3%, 41%)';
    string private constant COLOR_30 = 'hsl(218, 8%, 20%)';
    string private constant COLOR_31 = 'hsl(40, 4%, 54%)';
    string private constant COLOR_32 = 'hsl(40, 2%, 37%)';
    string private constant COLOR_33 = 'hsl(240, 1%, 31%)';
    string private constant COLOR_34 = 'hsl(30, 2%, 33%)';
    string private constant COLOR_35 = 'hsl(120, 1%, 35%)';
    string private constant COLOR_36 = 'hsl(225, 7%, 24%)';
    string private constant COLOR_37 = 'hsl(216, 3%, 29%)';
    string private constant COLOR_38 = 'hsl(60, 2%, 41%)';
    string private constant COLOR_39 = 'hsl(20, 2%, 37%)';
    string private constant COLOR_40 = 'hsl(220, 2%, 27%)';
    string private constant COLOR_41 = 'hsl(34, 3%, 45%)';
    string private constant COLOR_42 = 'hsl(214, 9%, 16%)';
    string private constant COLOR_43 = 'hsl(40, 5%, 51%)';
    string private constant COLOR_44 = 'hsl(220, 2%, 28%)';
    string private constant COLOR_45 = 'hsl(0, 0%, 26%)';
    string private constant COLOR_46 = 'hsl(240, 1%, 23%)';
    string private constant COLOR_47 = 'hsl(240, 1%, 26%)';
    string private constant COLOR_48 = 'hsl(37, 5%, 49%)';
    string private constant COLOR_49 = 'hsl(223, 6%, 24%)';
    string private constant COLOR_50 = 'hsl(30, 2%, 48%)';
    string private constant COLOR_51 = 'hsl(37, 3%, 45%)';

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
            PART_45,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_45) : COLOR_45,
            PART_46
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_46) : COLOR_46,
            PART_47,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_47) : COLOR_47,
            PART_48,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_48) : COLOR_48,
            PART_49,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_49) : COLOR_49
        );
        result = string.concat(
            result,
            PART_50,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_50) : COLOR_50,
            PART_51,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_51) : COLOR_51,
            PART_52
        );
        return result;
    }
}
