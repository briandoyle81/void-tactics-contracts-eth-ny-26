// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderBaseBodySelfTest {
    string private constant PART_1 = '<path d="M134 145 L135 145 L136 151 L138 153 L133 154 L132 156 L130 156 L130 163 L135 161 L140 161 L141 164 L161 165 L161 167 L155 168 L153 171 L149 170 L149 168 L147 168 L147 171 L139 171 L137 171 L132 170 L132 167 L128 165 L128 163 L126 163 L127 159 L128 157 L126 156 L129 155 L129 153 L121 154 L119 153 L118 155 L110 153 L110 156 L117 155 L122 156 L118 159 L119 158 L120 161 L115 162 L109 157 L108 152 L120 151 L120 146 L121 146 L121 151 L125 150 L134 150 Z M165 106 L167 106 L167 112 L169 112 L169 114 L153 114 L145 113 L145 111 L165 111 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M98 105 L113 105 L116 109 L116 112 L122 112 L122 113 L109 114 L84 114 L85 121 L98 121 L98 115 L99 115 L99 121 L115 121 L115 122 L86 123 L85 127 L83 127 L82 113 L83 112 L93 112 L95 108 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M126 134 L146 134 L146 137 L152 137 L152 139 L149 140 L152 141 L151 144 L149 145 L126 145 L126 140 L129 142 L133 141 L132 137 L126 139 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M137 111 L145 111 L145 113 L153 113 L166 115 L166 118 L130 118 L130 120 L134 119 L135 120 L135 125 L133 125 L132 133 L147 133 L147 134 L127 134 L131 133 L129 126 L131 125 L129 122 L129 118 L125 118 L126 115 L130 116 L138 114 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M124 134 L126 134 L126 139 L132 137 L134 141 L133 144 L128 142 L127 141 L126 145 L134 145 L134 150 L120 151 L107 150 L104 146 L112 145 L125 145 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M115 122 L116 125 L125 125 L124 127 L116 127 L116 139 L119 140 L116 140 L116 144 L96 145 L97 151 L84 151 L83 150 L83 138 L84 138 L85 124 L86 124 L86 143 L115 143 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M87 124 L91 125 L88 125 L88 127 L94 126 L93 129 L89 129 L89 136 L92 136 L96 135 L97 141 L99 141 L97 137 L97 131 L98 131 L98 136 L100 136 L101 131 L100 130 L99 127 L103 126 L103 128 L108 128 L110 132 L109 137 L107 138 L108 132 L104 132 L104 137 L102 137 L102 140 L110 141 L110 142 L87 142 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M175 116 L177 119 L177 145 L175 145 L175 147 L171 151 L169 151 L169 157 L166 156 L167 153 L139 153 L135 151 L136 150 L163 150 L163 142 L164 142 L164 151 L169 149 L172 146 L174 142 L174 126 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M157 120 L165 120 L166 129 L162 130 L159 130 L155 131 L157 133 L151 133 L149 132 L148 138 L145 137 L146 134 L143 132 L149 129 L153 127 L153 124 L155 124 L155 122 L157 122 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M82 114 L83 114 L83 127 L85 127 L85 144 L84 144 L84 150 L92 151 L92 155 L101 155 L101 158 L87 158 L86 154 L82 154 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M138 144 L163 145 L163 150 L135 150 L135 145 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M131 105 L163 105 L163 107 L148 108 L146 111 L127 111 L127 109 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M84 114 L106 114 L103 115 L102 119 L107 120 L107 121 L84 122 Z M116 127 L123 127 L123 137 L121 137 L121 135 L119 135 L120 141 L117 141 L116 139 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M167 125 L170 126 L166 133 L160 136 L163 137 L163 139 L161 140 L164 142 L159 143 L154 144 L155 141 L157 141 L157 139 L154 138 L157 137 L157 135 L151 136 L148 136 L149 132 L154 132 L156 130 L158 130 L160 128 L162 128 L162 130 L165 128 L165 126 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M174 133 L175 133 L175 143 L171 148 L168 151 L164 151 L164 142 L166 141 L167 135 L174 135 Z M142 153 L156 154 L158 156 L154 157 L158 158 L158 161 L137 161 L140 158 L141 159 L142 157 L136 156 L136 154 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M91 124 L113 124 L113 142 L110 141 L110 131 L108 129 L102 127 L96 128 L90 127 L88 127 L88 125 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M94 127 L99 127 L101 129 L103 130 L101 132 L100 136 L98 137 L99 141 L97 141 L95 136 L93 140 L91 140 L91 137 L88 136 L89 129 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M110 153 L118 154 L122 153 L129 153 L129 155 L127 156 L127 160 L126 163 L116 163 L120 161 L117 159 L116 156 L110 156 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M124 120 L129 120 L131 121 L132 126 L130 127 L131 128 L131 133 L124 134 L124 127 L125 125 L116 125 L120 123 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M127 112 L129 112 L129 114 L148 114 L148 115 L132 116 L129 117 L126 116 L125 118 L129 118 L128 121 L122 121 L121 124 L116 124 L115 121 L116 118 L122 118 L122 116 L120 115 L127 114 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M153 120 L157 120 L157 122 L155 122 L155 124 L153 124 L153 127 L157 128 L150 129 L148 131 L143 133 L140 133 L138 127 L138 124 L143 123 L145 125 L144 127 L149 126 L152 125 L152 122 L149 121 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M86 144 L115 144 L112 146 L105 147 L107 149 L113 150 L113 151 L97 151 L96 145 L86 145 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M106 114 L119 114 L119 117 L116 117 L116 121 L107 121 L101 120 L103 115 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M138 152 L158 152 L167 153 L167 157 L163 157 L162 155 L161 157 L162 160 L158 161 L158 158 L152 158 L156 155 L136 154 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M167 119 L175 119 L175 133 L172 136 L168 135 L167 132 L169 132 L169 130 L172 131 L170 131 L170 133 L173 132 L172 128 L172 127 L169 127 L166 126 L165 120 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M171 125 L173 125 L174 132 L170 133 L169 132 L168 135 L166 142 L160 140 L163 139 L163 137 L159 138 L160 135 L162 133 L166 133 L167 129 L168 127 L171 126 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M126 107 L130 108 L127 109 L127 111 L137 111 L138 114 L129 114 L129 112 L127 112 L127 114 L122 116 L122 118 L116 118 L119 117 L119 114 L109 114 L109 113 L122 112 L124 109 L126 109 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M132 153 L136 154 L136 156 L151 157 L151 158 L145 159 L145 160 L140 160 L138 160 L133 163 L130 163 L130 156 L132 156 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M135 120 L153 120 L152 125 L148 128 L144 127 L143 124 L135 123 Z M135 123 L140 123 L139 128 L141 130 L140 133 L132 133 L132 127 L133 125 L135 125 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M164 104 L166 106 L165 111 L146 111 L148 107 L163 107 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M130 118 L170 118 L167 120 L130 120 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M85 123 L113 123 L113 124 L87 124 L87 142 L113 142 L113 143 L86 143 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M130 103 L163 103 L164 105 L131 106 L128 107 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M162 154 L163 157 L169 157 L169 163 L163 165 L158 165 L157 163 L158 161 L161 159 L161 157 L159 156 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M169 112 L175 112 L175 114 L177 114 L177 119 L168 120 L166 118 L166 115 L159 115 L159 114 L169 114 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M155 160 L158 161 L158 165 L141 165 L140 161 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M123 126 L124 126 L125 145 L115 145 L116 140 L119 141 L119 135 L121 135 L121 137 L123 137 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M86 122 L115 122 L115 143 L113 143 L113 123 L86 123 Z" style="fill:';
    string private constant PART_39 = ';"/><path d="M92 151 L114 151 L114 152 L108 152 L108 154 L101 156 L97 155 L96 157 L96 155 L92 155 Z" style="fill:';
    string private constant PART_40 = ';"/><path d="M109 130 L111 131 L111 141 L102 141 L100 139 L102 139 L103 132 L106 131 L108 132 L108 137 L109 132 Z" style="fill:';
    string private constant PART_41 = ';"/><path d="M149 135 L157 135 L157 137 L155 138 L157 139 L157 141 L154 144 L160 142 L163 143 L163 145 L149 145 L152 141 L148 140 L152 139 L152 137 L148 138 Z" style="fill:';
    string private constant PART_42 = ';"/>';
    string private constant COLOR_1 = 'hsl(223, 11%, 12%)';
    string private constant COLOR_2 = 'hsl(220, 6%, 19%)';
    string private constant COLOR_3 = 'hsl(75, 2%, 39%)';
    string private constant COLOR_4 = 'hsl(220, 6%, 20%)';
    string private constant COLOR_5 = 'hsl(218, 7%, 24%)';
    string private constant COLOR_6 = 'hsl(220, 5%, 22%)';
    string private constant COLOR_7 = 'hsl(218, 12%, 13%)';
    string private constant COLOR_8 = 'hsl(223, 13%, 11%)';
    string private constant COLOR_9 = 'hsl(60, 2%, 40%)';
    string private constant COLOR_10 = 'hsl(223, 11%, 13%)';
    string private constant COLOR_11 = 'hsl(220, 5%, 22%)';
    string private constant COLOR_12 = 'hsl(47, 4%, 47%)';
    string private constant COLOR_13 = 'hsl(60, 2%, 39%)';
    string private constant COLOR_14 = 'hsl(60, 2%, 38%)';
    string private constant COLOR_15 = 'hsl(180, 1%, 31%)';
    string private constant COLOR_16 = 'hsl(230, 12%, 10%)';
    string private constant COLOR_17 = 'hsl(210, 3%, 26%)';
    string private constant COLOR_18 = 'hsl(220, 6%, 20%)';
    string private constant COLOR_19 = 'hsl(120, 1%, 35%)';
    string private constant COLOR_20 = 'hsl(51, 3%, 44%)';
    string private constant COLOR_21 = 'hsl(90, 1%, 35%)';
    string private constant COLOR_22 = 'hsl(214, 8%, 17%)';
    string private constant COLOR_23 = 'hsl(60, 2%, 39%)';
    string private constant COLOR_24 = 'hsl(223, 8%, 17%)';
    string private constant COLOR_25 = 'hsl(220, 2%, 25%)';
    string private constant COLOR_26 = 'hsl(150, 1%, 32%)';
    string private constant COLOR_27 = 'hsl(223, 9%, 16%)';
    string private constant COLOR_28 = 'hsl(223, 7%, 20%)';
    string private constant COLOR_29 = 'hsl(60, 2%, 40%)';
    string private constant COLOR_30 = 'hsl(120, 1%, 34%)';
    string private constant COLOR_31 = 'hsl(38, 9%, 61%)';
    string private constant COLOR_32 = 'hsl(50, 3%, 45%)';
    string private constant COLOR_33 = 'hsl(223, 12%, 11%)';
    string private constant COLOR_34 = 'hsl(223, 10%, 14%)';
    string private constant COLOR_35 = 'hsl(150, 1%, 31%)';
    string private constant COLOR_36 = 'hsl(218, 7%, 22%)';
    string private constant COLOR_37 = 'hsl(90, 1%, 35%)';
    string private constant COLOR_38 = 'hsl(40, 7%, 58%)';
    string private constant COLOR_39 = 'hsl(223, 14%, 10%)';
    string private constant COLOR_40 = 'hsl(200, 25%, 34%)';
    string private constant COLOR_41 = 'hsl(210, 1%, 30%)';

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
            PART_42
        );
        return result;
    }
}
