// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderShield2SelfTest {
    string private constant PART_1 = '<path d="M127 103 L165 103 L169 106 L169 111 L181 111 L181 145 L177 152 L175 152 L175 158 L164 158 L164 160 L160 161 L160 163 L153 165 L144 165 L143 164 L142 166 L139 166 L138 164 L134 165 L132 164 L132 162 L127 160 L126 159 L115 158 L110 153 L101 153 L100 154 L86 154 L85 151 L79 151 L79 113 L83 110 L95 109 L97 105 L112 105 L115 107 L115 109 L121 109 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M81 112 L82 112 L83 121 L86 122 L85 139 L87 139 L87 122 L111 122 L115 122 L116 137 L119 138 L119 117 L113 117 L115 115 L120 116 L121 144 L164 144 L164 145 L124 145 L124 148 L132 148 L130 149 L130 155 L135 155 L135 149 L133 148 L143 147 L166 148 L167 145 L167 148 L172 146 L177 141 L179 141 L180 133 L174 133 L173 132 L173 125 L174 124 L179 124 L181 126 L181 145 L177 152 L175 152 L175 158 L164 158 L164 160 L160 161 L160 163 L153 165 L144 165 L143 164 L142 166 L139 166 L138 164 L134 165 L132 164 L132 162 L127 160 L126 159 L115 158 L110 153 L101 153 L100 154 L86 154 L85 151 L79 151 L79 113 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M123 115 L166 115 L166 142 L165 144 L121 144 L120 142 L120 116 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M87 122 L111 122 L112 123 L113 140 L114 139 L119 139 L119 145 L109 145 L108 148 L84 148 L82 145 L82 139 L87 139 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M174 124 L179 124 L181 126 L181 145 L177 152 L175 152 L175 158 L164 158 L164 160 L160 161 L160 163 L153 165 L149 164 L151 162 L136 161 L131 159 L130 155 L135 155 L135 149 L133 148 L143 147 L166 148 L167 145 L167 148 L172 146 L177 141 L179 141 L180 133 L174 133 L173 132 L173 125 Z M153 160 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M97 107 L112 107 L113 111 L120 112 L120 115 L114 116 L119 117 L119 138 L115 138 L115 122 L113 122 L113 138 L112 138 L111 123 L87 122 L87 139 L85 139 L85 122 L83 121 L83 138 L82 138 L82 111 L83 110 L97 109 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M174 124 L179 124 L181 126 L181 145 L177 152 L175 152 L175 158 L164 158 L164 160 L160 161 L163 157 L164 153 L161 152 L163 151 L163 149 L152 149 L151 151 L147 150 L145 152 L137 152 L135 151 L135 149 L133 148 L143 147 L166 148 L167 145 L167 148 L172 146 L177 141 L179 141 L180 133 L174 133 L173 132 L173 125 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M143 115 L152 115 L152 143 L141 143 L141 118 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M87 122 L111 122 L112 123 L112 136 L110 132 L111 125 L108 125 L109 133 L107 129 L107 127 L101 127 L99 138 L109 138 L110 136 L111 139 L87 139 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M127 103 L165 103 L168 107 L164 106 L130 105 L128 109 L127 110 L159 111 L159 112 L124 112 L123 114 L123 112 L115 112 L113 111 L112 108 L97 107 L97 109 L95 109 L97 105 L112 105 L115 107 L115 109 L121 109 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M97 107 L112 107 L113 111 L120 112 L120 115 L85 115 L85 113 L87 112 L83 110 L97 109 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M130 105 L164 105 L163 109 L162 107 L161 110 L159 111 L126 111 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M103 112 L104 115 L107 114 L114 115 L114 116 L119 117 L119 138 L115 138 L115 122 L112 122 L112 120 L92 120 L92 119 L103 119 L103 116 L91 117 L89 116 L89 118 L85 116 L85 115 L103 115 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M155 115 L164 115 L164 143 L162 142 L161 126 L160 143 L159 143 L158 128 L156 143 L155 143 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M108 125 L111 125 L111 132 L112 140 L87 140 L87 139 L109 138 L99 138 L100 127 L102 126 L107 127 L108 128 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M147 149 L163 149 L162 152 L164 153 L164 157 L158 157 L158 155 L136 155 L136 150 L137 152 L139 150 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M147 115 L152 115 L152 143 L147 143 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M130 115 L135 115 L135 143 L130 143 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M123 115 L128 115 L128 143 L126 143 L125 124 L124 143 L122 143 L122 116 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M96 124 L98 124 L98 138 L88 138 L88 125 L94 125 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M166 145 L168 149 L167 157 L171 158 L164 158 L164 160 L160 161 L163 157 L164 153 L161 152 L163 151 L163 149 L152 149 L151 151 L147 150 L145 152 L137 152 L135 151 L135 149 L133 148 L143 147 L166 148 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M129 154 L131 158 L136 159 L136 161 L153 161 L150 164 L144 165 L143 164 L142 166 L139 166 L138 164 L134 165 L132 164 L132 162 L127 160 L126 159 L115 158 L115 157 L129 157 Z M153 160 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M116 149 L129 149 L130 154 L129 157 L117 157 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M103 112 L104 115 L107 114 L114 115 L113 122 L112 120 L92 120 L92 119 L103 119 L103 116 L91 117 L89 116 L89 118 L85 116 L85 115 L103 115 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M172 118 L180 118 L180 123 L174 125 L174 132 L179 134 L178 138 L172 139 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M167 117 L171 117 L171 139 L167 139 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M175 133 L180 133 L180 139 L175 145 L171 148 L167 148 L167 140 L178 137 L179 134 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M143 115 L144 115 L144 143 L141 143 L141 118 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M160 115 L164 115 L164 143 L162 142 L161 126 L160 124 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M157 155 L158 157 L163 157 L160 163 L153 165 L149 164 L151 162 L150 160 L152 160 L153 157 L157 157 Z M153 160 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M136 150 L137 152 L157 152 L157 155 L136 155 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M99 124 L107 125 L109 128 L109 133 L107 129 L107 127 L101 127 L99 138 L109 138 L110 136 L111 139 L97 139 L98 132 L95 131 L98 131 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M152 115 L155 115 L155 139 L152 143 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M128 104 L164 104 L164 105 L130 105 L128 109 L126 111 L123 111 L125 107 L127 107 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M85 139 L99 140 L99 148 L98 144 L89 144 L89 142 L85 141 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M87 112 L103 112 L103 115 L85 115 L85 113 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M99 107 L111 107 L111 111 L99 111 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M165 143 L166 143 L166 148 L154 148 L154 147 L143 146 L143 145 L164 144 Z" style="fill:';
    string private constant PART_39 = ';"/><path d="M147 153 L148 155 L157 155 L157 157 L136 157 L136 155 L147 155 Z" style="fill:';
    string private constant PART_40 = ';"/><path d="M87 149 L102 149 L100 150 L100 152 L94 153 L87 154 Z" style="fill:';
    string private constant PART_41 = ';"/><path d="M83 121 L86 122 L85 139 L83 143 L82 138 Z" style="fill:';
    string private constant PART_42 = ';"/><path d="M113 117 L119 117 L119 125 L115 124 L115 122 L113 122 Z" style="fill:';
    string private constant PART_43 = ';"/><path d="M114 139 L119 139 L119 145 L109 145 L113 144 Z" style="fill:';
    string private constant PART_44 = ';"/><path d="M172 112 L179 112 L180 117 L172 117 Z" style="fill:';
    string private constant PART_45 = ';"/>';
    string private constant COLOR_1 = 'hsl(192, 6%, 17%)';
    string private constant COLOR_2 = 'hsl(210, 15%, 11%)';
    string private constant COLOR_3 = 'hsl(201, 81%, 35%)';
    string private constant COLOR_4 = 'hsl(210, 6%, 19%)';
    string private constant COLOR_5 = 'hsl(214, 10%, 14%)';
    string private constant COLOR_6 = 'hsl(44, 6%, 36%)';
    string private constant COLOR_7 = 'hsl(220, 4%, 14%)';
    string private constant COLOR_8 = 'hsl(200, 83%, 39%)';
    string private constant COLOR_9 = 'hsl(210, 17%, 7%)';
    string private constant COLOR_10 = 'hsl(195, 10%, 8%)';
    string private constant COLOR_11 = 'hsl(44, 6%, 35%)';
    string private constant COLOR_12 = 'hsl(42, 7%, 37%)';
    string private constant COLOR_13 = 'hsl(35, 7%, 32%)';
    string private constant COLOR_14 = 'hsl(190, 71%, 59%)';
    string private constant COLOR_15 = 'hsl(200, 28%, 25%)';
    string private constant COLOR_16 = 'hsl(210, 4%, 18%)';
    string private constant COLOR_17 = 'hsl(193, 62%, 51%)';
    string private constant COLOR_18 = 'hsl(192, 64%, 51%)';
    string private constant COLOR_19 = 'hsl(191, 65%, 53%)';
    string private constant COLOR_20 = 'hsl(200, 4%, 17%)';
    string private constant COLOR_21 = 'hsl(210, 14%, 9%)';
    string private constant COLOR_22 = 'hsl(210, 15%, 8%)';
    string private constant COLOR_23 = 'hsl(218, 10%, 16%)';
    string private constant COLOR_24 = 'hsl(38, 9%, 25%)';
    string private constant COLOR_25 = 'hsl(51, 4%, 32%)';
    string private constant COLOR_26 = 'hsl(51, 4%, 33%)';
    string private constant COLOR_27 = 'hsl(210, 2%, 22%)';
    string private constant COLOR_28 = 'hsl(193, 65%, 52%)';
    string private constant COLOR_29 = 'hsl(192, 62%, 53%)';
    string private constant COLOR_30 = 'hsl(214, 11%, 13%)';
    string private constant COLOR_31 = 'hsl(43, 4%, 37%)';
    string private constant COLOR_32 = 'hsl(210, 18%, 11%)';
    string private constant COLOR_33 = 'hsl(200, 82%, 38%)';
    string private constant COLOR_34 = 'hsl(120, 1%, 19%)';
    string private constant COLOR_35 = 'hsl(210, 8%, 16%)';
    string private constant COLOR_36 = 'hsl(43, 10%, 53%)';
    string private constant COLOR_37 = 'hsl(44, 5%, 43%)';
    string private constant COLOR_38 = 'hsl(200, 2%, 26%)';
    string private constant COLOR_39 = 'hsl(180, 1%, 21%)';
    string private constant COLOR_40 = 'hsl(206, 10%, 14%)';
    string private constant COLOR_41 = 'hsl(60, 3%, 12%)';
    string private constant COLOR_42 = 'hsl(48, 5%, 37%)';
    string private constant COLOR_43 = 'hsl(60, 1%, 27%)';
    string private constant COLOR_44 = 'hsl(43, 8%, 36%)';

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
