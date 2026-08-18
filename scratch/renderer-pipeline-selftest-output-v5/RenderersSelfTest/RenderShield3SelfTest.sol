// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderShield3SelfTest {
    string private constant PART_1 = '<path d="M128 99 L164 99 L167 102 L167 104 L176 103 L177 116 L181 119 L181 155 L178 156 L176 160 L165 171 L162 172 L131 172 L128 171 L122 164 L117 159 L113 156 L110 159 L97 159 L92 154 L84 153 L81 150 L81 113 L82 112 L88 112 L88 109 L102 109 L105 109 L109 105 L118 104 L120 102 L127 101 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M128 99 L164 99 L167 102 L167 104 L176 103 L177 116 L181 119 L181 131 L175 132 L174 130 L173 140 L172 140 L171 129 L171 126 L173 123 L172 118 L166 111 L163 111 L162 108 L155 105 L143 104 L143 106 L136 106 L136 108 L131 110 L129 110 L124 115 L121 119 L119 125 L118 141 L121 141 L120 138 L120 129 L121 129 L123 139 L122 143 L121 146 L125 153 L115 153 L117 157 L113 156 L110 159 L97 159 L92 154 L84 153 L81 150 L81 113 L82 112 L88 112 L88 109 L102 109 L105 109 L109 105 L118 104 L120 102 L127 101 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M145 111 L149 112 L151 115 L155 115 L157 120 L161 119 L164 122 L164 124 L169 125 L170 129 L168 131 L164 130 L165 133 L169 134 L170 138 L168 140 L164 140 L162 145 L157 144 L156 148 L155 150 L150 152 L145 153 L144 148 L143 150 L139 150 L138 149 L137 153 L131 151 L130 149 L128 149 L126 142 L127 140 L125 140 L125 133 L130 133 L132 127 L130 122 L132 119 L137 118 L139 115 L143 115 L144 116 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M85 116 L98 116 L97 120 L85 120 L85 144 L86 143 L86 122 L108 122 L108 120 L99 120 L99 116 L111 116 L120 117 L119 121 L117 121 L117 141 L108 141 L109 142 L116 142 L119 145 L121 149 L122 152 L85 152 L82 149 L82 118 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M143 104 L155 104 L163 108 L164 110 L168 112 L173 118 L174 123 L171 127 L169 127 L168 125 L164 124 L161 120 L156 121 L155 115 L150 116 L148 112 L145 112 L145 118 L143 117 L143 115 L139 116 L136 120 L132 119 L131 124 L132 127 L136 128 L132 129 L131 134 L125 133 L125 140 L127 140 L128 149 L131 148 L131 151 L137 152 L137 147 L139 148 L139 150 L143 150 L144 147 L145 149 L145 152 L150 151 L155 150 L156 142 L158 144 L164 143 L168 142 L168 148 L167 150 L160 154 L157 154 L156 157 L150 159 L135 158 L128 153 L123 145 L121 138 L121 141 L118 141 L118 125 L122 116 L126 111 L131 108 L134 108 L134 106 L139 105 L143 106 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M133 111 L137 112 L139 116 L136 120 L132 119 L131 124 L132 127 L136 128 L132 129 L131 134 L125 133 L125 140 L127 140 L128 149 L131 148 L131 151 L137 152 L137 147 L139 148 L139 150 L143 150 L144 147 L145 149 L145 152 L150 151 L155 150 L156 142 L158 144 L164 143 L168 142 L168 148 L167 150 L160 154 L157 154 L156 157 L150 159 L135 158 L128 153 L123 145 L121 137 L121 129 L124 126 L126 123 L125 118 L130 116 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M121 142 L124 145 L128 151 L128 153 L132 155 L137 159 L130 158 L127 155 L126 156 L134 161 L134 167 L164 167 L166 163 L171 159 L173 159 L171 163 L167 168 L165 171 L162 172 L131 172 L128 171 L122 164 L117 159 L115 153 L124 152 L120 146 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M87 124 L105 124 L105 139 L104 142 L88 142 L87 141 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M173 126 L176 130 L181 131 L181 152 L180 152 L180 142 L176 143 L179 143 L179 151 L176 152 L173 151 L172 149 L168 154 L165 154 L165 157 L160 158 L157 161 L138 161 L138 159 L153 159 L163 154 L167 152 L168 142 L163 144 L164 140 L169 138 L168 134 L164 134 L163 129 L168 130 L172 128 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M99 116 L111 116 L120 117 L119 121 L117 121 L117 141 L108 141 L104 141 L105 139 L106 123 L86 123 L86 122 L108 122 L108 120 L99 120 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M142 102 L162 103 L167 102 L167 104 L176 103 L177 116 L181 119 L181 131 L175 132 L174 130 L173 140 L172 140 L171 129 L171 126 L173 123 L172 118 L166 111 L163 111 L162 108 L155 105 L141 104 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M145 128 L149 128 L151 133 L149 136 L145 137 L150 138 L152 142 L156 142 L157 147 L155 150 L150 152 L145 153 L144 148 L143 150 L139 150 L137 145 L139 141 L137 138 L138 134 L143 133 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M132 128 L136 128 L138 133 L139 140 L139 143 L138 149 L137 153 L131 151 L130 149 L128 149 L126 142 L127 140 L125 140 L125 133 L130 133 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M108 106 L117 106 L117 113 L123 112 L124 110 L127 111 L121 119 L119 125 L118 141 L121 141 L120 138 L120 129 L121 129 L123 139 L122 143 L121 146 L125 153 L115 153 L117 157 L113 156 L110 156 L112 151 L121 151 L120 149 L111 148 L111 147 L119 147 L116 143 L109 143 L107 144 L107 123 L108 123 L108 141 L116 140 L116 125 L117 121 L119 121 L119 118 L116 116 L121 116 L121 114 L113 114 L116 113 L116 110 L111 110 L111 108 L108 108 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M145 111 L149 112 L151 115 L155 115 L157 120 L161 119 L164 122 L164 124 L169 125 L170 129 L168 131 L164 130 L158 128 L157 131 L156 129 L155 123 L151 124 L149 119 L143 122 L144 116 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M141 108 L149 108 L151 108 L155 109 L157 111 L161 112 L163 116 L167 117 L168 122 L163 122 L161 120 L156 121 L155 115 L150 116 L148 112 L139 113 L138 109 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M156 142 L158 144 L164 143 L168 142 L168 148 L167 150 L160 154 L157 154 L156 157 L150 158 L149 154 L146 153 L151 150 L155 150 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M171 159 L173 159 L171 163 L167 168 L166 170 L130 170 L126 165 L127 163 L130 166 L164 167 L166 163 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M86 151 L112 151 L111 158 L110 159 L97 159 L92 153 L86 152 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M85 116 L98 116 L97 120 L85 120 L85 143 L84 150 L82 149 L82 118 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M133 111 L137 112 L139 116 L136 120 L132 119 L131 124 L132 127 L136 128 L129 131 L125 131 L124 126 L126 123 L125 118 L130 116 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M145 128 L149 128 L151 133 L149 136 L145 137 L150 138 L151 143 L149 145 L145 145 L143 140 L138 140 L137 135 L139 133 L143 133 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M171 153 L179 153 L177 159 L168 168 L166 167 L173 159 L167 163 L164 167 L159 167 L159 165 L162 164 L159 164 L159 161 L170 155 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M95 126 L100 126 L104 131 L104 139 L94 139 L92 134 L93 129 L95 127 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M138 99 L164 99 L166 103 L157 104 L138 103 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M88 109 L101 109 L101 111 L91 111 L91 113 L98 113 L98 114 L84 115 L83 117 L83 149 L85 151 L93 152 L93 153 L84 153 L81 150 L81 113 L82 112 L88 112 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M129 101 L132 101 L132 105 L128 106 L126 110 L124 110 L123 113 L117 113 L117 106 L109 106 L109 105 L119 104 L122 105 L122 103 L129 103 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M172 103 L176 103 L177 117 L173 116 L170 112 L170 110 L165 108 L164 105 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M98 116 L99 120 L108 120 L108 122 L86 122 L86 143 L106 143 L106 144 L85 144 L85 120 L97 119 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M99 116 L111 116 L120 117 L119 121 L117 121 L117 125 L115 124 L116 121 L111 121 L109 120 L99 120 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M145 111 L149 112 L151 115 L155 115 L157 119 L155 122 L151 121 L146 120 L143 122 L144 116 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M171 128 L172 128 L172 141 L173 144 L171 146 L171 144 L169 144 L168 147 L168 142 L163 144 L164 140 L169 138 L168 134 L164 134 L163 129 L168 130 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M126 163 L130 166 L151 167 L151 169 L149 170 L130 170 L126 165 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M155 149 L156 152 L163 151 L160 154 L157 154 L156 157 L150 158 L149 154 L146 153 L151 150 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M137 147 L139 148 L139 150 L143 150 L144 147 L145 149 L145 156 L141 157 L135 156 L131 151 L137 152 Z" style="fill:';
    string private constant PART_36 = ';"/>';
    string private constant COLOR_1 = 'hsl(212, 30%, 8%)';
    string private constant COLOR_2 = 'hsl(213, 22%, 10%)';
    string private constant COLOR_3 = 'hsl(195, 84%, 36%)';
    string private constant COLOR_4 = 'hsl(100, 2%, 29%)';
    string private constant COLOR_5 = 'hsl(211, 40%, 12%)';
    string private constant COLOR_6 = 'hsl(208, 83%, 14%)';
    string private constant COLOR_7 = 'hsl(210, 8%, 19%)';
    string private constant COLOR_8 = 'hsl(200, 10%, 11%)';
    string private constant COLOR_9 = 'hsl(213, 14%, 15%)';
    string private constant COLOR_10 = 'hsl(180, 3%, 22%)';
    string private constant COLOR_11 = 'hsl(215, 35%, 7%)';
    string private constant COLOR_12 = 'hsl(189, 70%, 45%)';
    string private constant COLOR_13 = 'hsl(194, 84%, 37%)';
    string private constant COLOR_14 = 'hsl(213, 35%, 6%)';
    string private constant COLOR_15 = 'hsl(203, 87%, 27%)';
    string private constant COLOR_16 = 'hsl(207, 89%, 18%)';
    string private constant COLOR_17 = 'hsl(204, 90%, 25%)';
    string private constant COLOR_18 = 'hsl(80, 2%, 30%)';
    string private constant COLOR_19 = 'hsl(210, 8%, 14%)';
    string private constant COLOR_20 = 'hsl(200, 6%, 21%)';
    string private constant COLOR_21 = 'hsl(205, 91%, 23%)';
    string private constant COLOR_22 = 'hsl(185, 72%, 51%)';
    string private constant COLOR_23 = 'hsl(210, 9%, 17%)';
    string private constant COLOR_24 = 'hsl(200, 43%, 19%)';
    string private constant COLOR_25 = 'hsl(213, 14%, 13%)';
    string private constant COLOR_26 = 'hsl(213, 41%, 5%)';
    string private constant COLOR_27 = 'hsl(213, 19%, 11%)';
    string private constant COLOR_28 = 'hsl(213, 22%, 10%)';
    string private constant COLOR_29 = 'hsl(213, 27%, 8%)';
    string private constant COLOR_30 = 'hsl(210, 8%, 20%)';
    string private constant COLOR_31 = 'hsl(202, 89%, 29%)';
    string private constant COLOR_32 = 'hsl(210, 79%, 15%)';
    string private constant COLOR_33 = 'hsl(70, 4%, 33%)';
    string private constant COLOR_34 = 'hsl(206, 89%, 21%)';
    string private constant COLOR_35 = 'hsl(204, 88%, 23%)';

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
