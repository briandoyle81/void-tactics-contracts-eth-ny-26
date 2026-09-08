// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderShield3SelfTest {
    string private constant PART_1 = '<path d="M128 99 L164 99 L167 102 L167 104 L176 103 L177 116 L181 119 L181 155 L178 156 L176 160 L165 171 L162 172 L131 172 L128 171 L122 164 L117 159 L113 156 L110 159 L97 159 L92 154 L84 153 L81 150 L81 113 L82 112 L88 112 L88 109 L102 109 L105 109 L109 105 L118 104 L120 102 L127 101 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M128 99 L164 99 L167 102 L167 104 L176 103 L177 116 L181 119 L181 132 L180 137 L178 137 L177 139 L180 138 L180 140 L177 140 L176 142 L174 130 L173 140 L172 140 L171 129 L168 125 L164 124 L161 120 L156 121 L155 115 L150 116 L148 112 L145 112 L145 118 L143 117 L143 115 L138 115 L136 112 L132 113 L130 117 L125 118 L126 123 L128 124 L125 124 L124 129 L122 129 L122 137 L123 143 L121 141 L119 137 L119 145 L116 143 L109 143 L107 144 L107 123 L108 123 L108 141 L116 140 L116 125 L117 121 L119 121 L119 118 L111 118 L108 122 L86 122 L86 143 L106 143 L106 144 L85 144 L85 120 L97 119 L98 116 L85 117 L82 118 L83 149 L86 151 L113 151 L123 153 L124 156 L119 161 L113 156 L110 159 L97 159 L92 154 L84 153 L81 150 L81 113 L82 112 L88 112 L88 109 L102 109 L105 109 L109 105 L118 104 L120 102 L127 101 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M145 111 L149 112 L151 115 L155 115 L157 120 L161 119 L164 122 L164 124 L169 125 L170 129 L168 131 L164 130 L165 133 L169 134 L170 138 L168 140 L164 140 L162 145 L157 144 L156 148 L155 150 L150 152 L145 153 L144 148 L143 150 L139 150 L138 149 L137 153 L131 151 L130 149 L128 149 L126 142 L127 140 L125 140 L125 133 L130 133 L132 127 L130 122 L132 119 L137 118 L139 115 L143 115 L144 116 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M85 116 L98 116 L97 120 L85 120 L85 144 L86 143 L86 122 L108 122 L110 118 L111 117 L120 117 L119 121 L117 121 L117 141 L108 141 L109 142 L116 142 L119 145 L121 149 L122 152 L85 152 L82 149 L82 118 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M133 111 L137 112 L139 116 L136 120 L132 119 L131 124 L132 127 L136 128 L132 129 L131 134 L125 133 L125 140 L127 140 L128 149 L131 148 L131 151 L137 152 L137 147 L139 148 L139 150 L143 150 L144 147 L145 149 L145 152 L150 151 L155 150 L156 142 L158 144 L164 143 L168 142 L168 148 L167 150 L160 154 L157 154 L156 157 L150 159 L137 158 L137 159 L130 158 L123 151 L119 145 L118 137 L119 129 L120 129 L122 141 L121 137 L121 129 L124 126 L126 123 L125 118 L130 116 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M85 116 L98 116 L97 120 L85 120 L85 144 L86 143 L86 123 L106 123 L106 140 L105 140 L105 124 L87 124 L88 141 L105 141 L108 143 L109 142 L116 142 L119 145 L121 149 L122 152 L85 152 L82 149 L82 118 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M142 104 L155 104 L165 109 L170 114 L171 119 L173 122 L172 127 L169 127 L168 125 L164 124 L161 120 L156 121 L155 115 L150 116 L148 112 L145 112 L145 118 L143 117 L143 115 L138 115 L136 112 L132 113 L130 117 L126 118 L127 114 L131 110 L129 109 L133 106 L139 105 L142 106 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M124 155 L134 161 L134 167 L164 167 L166 163 L171 159 L173 159 L171 163 L167 168 L165 171 L162 172 L131 172 L128 171 L122 164 L120 163 L121 158 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M145 128 L149 128 L151 133 L149 136 L145 137 L150 138 L152 142 L156 142 L157 147 L155 150 L150 152 L145 153 L144 148 L143 150 L139 150 L137 145 L139 141 L137 138 L138 134 L143 133 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M173 126 L175 130 L177 140 L180 140 L177 139 L179 135 L181 132 L181 152 L173 151 L172 149 L168 154 L165 154 L165 157 L160 158 L159 160 L153 160 L156 158 L164 153 L167 152 L168 142 L163 144 L164 140 L169 138 L168 134 L164 134 L163 129 L168 130 L172 128 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M171 153 L179 153 L177 159 L168 168 L166 167 L173 159 L167 163 L164 167 L134 167 L134 162 L157 162 L166 157 L170 154 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M86 123 L106 123 L106 140 L105 140 L105 124 L87 124 L88 141 L105 141 L108 143 L109 142 L116 142 L119 145 L121 149 L122 152 L85 152 L84 148 L108 149 L106 143 L86 143 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M132 128 L136 128 L138 133 L139 140 L139 143 L138 149 L137 153 L131 151 L130 149 L128 149 L126 142 L127 140 L125 140 L125 133 L130 133 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M86 151 L113 151 L123 153 L124 156 L119 161 L113 156 L110 159 L97 159 L92 153 L86 152 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M145 111 L149 112 L151 115 L155 115 L157 120 L161 119 L164 122 L164 124 L169 125 L170 129 L168 131 L164 130 L158 128 L157 131 L156 129 L155 123 L151 124 L149 119 L143 122 L144 116 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M87 124 L105 124 L105 130 L103 131 L99 127 L95 129 L93 129 L93 136 L95 138 L104 139 L104 142 L88 142 L87 141 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M172 106 L175 106 L175 116 L179 118 L181 119 L181 132 L180 137 L178 137 L177 139 L180 138 L180 140 L177 140 L176 142 L174 130 L173 140 L172 140 L171 129 L171 126 L172 122 L169 116 L172 116 L176 124 L176 121 L172 115 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M141 108 L149 108 L151 108 L155 109 L157 111 L161 112 L163 116 L168 118 L169 121 L168 122 L163 122 L161 120 L156 121 L155 115 L150 116 L148 112 L139 113 L138 109 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M156 142 L158 144 L164 143 L168 142 L168 148 L167 150 L160 154 L157 154 L156 157 L150 158 L149 154 L146 153 L151 150 L155 150 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M171 159 L173 159 L171 163 L167 168 L166 170 L130 170 L126 165 L127 163 L130 166 L164 167 L166 163 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M133 111 L137 112 L139 116 L136 120 L132 119 L131 124 L132 127 L136 128 L129 131 L125 131 L124 126 L126 123 L125 118 L130 116 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M145 128 L149 128 L151 133 L149 136 L145 137 L150 138 L151 143 L149 145 L145 145 L143 140 L138 140 L137 135 L139 133 L143 133 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M95 126 L100 126 L105 130 L105 139 L94 139 L92 134 L93 129 L95 127 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M164 161 L164 164 L159 165 L159 167 L134 167 L134 162 L159 162 L163 162 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M85 116 L98 116 L97 120 L85 120 L85 141 L83 141 L82 133 L82 118 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M88 109 L101 109 L101 111 L91 111 L91 113 L96 113 L96 114 L84 115 L83 117 L83 149 L85 151 L93 152 L93 153 L84 153 L81 150 L81 113 L82 112 L88 112 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M98 116 L99 120 L105 120 L105 118 L111 117 L108 122 L86 122 L86 143 L106 143 L106 144 L85 144 L85 120 L97 119 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M86 151 L112 151 L112 154 L109 155 L109 153 L106 153 L106 155 L103 155 L103 153 L100 153 L100 157 L109 157 L109 158 L96 158 L92 153 L86 152 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M119 129 L120 129 L122 141 L127 150 L128 153 L132 155 L137 159 L130 158 L123 151 L119 145 L118 137 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M145 111 L149 112 L151 115 L155 115 L157 119 L155 122 L151 121 L146 120 L143 122 L144 116 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M171 128 L172 128 L172 141 L173 144 L171 146 L171 144 L169 144 L168 147 L168 142 L163 144 L164 140 L169 138 L168 134 L164 134 L163 129 L168 130 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M99 114 L121 114 L121 116 L105 118 L105 120 L99 120 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M138 99 L157 99 L158 103 L138 103 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M107 123 L108 123 L108 141 L116 140 L116 125 L119 123 L119 145 L116 143 L109 143 L107 144 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M126 163 L130 166 L151 167 L151 169 L149 170 L130 170 L126 165 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M155 149 L156 152 L163 151 L160 154 L157 154 L156 157 L150 158 L149 154 L146 153 L151 150 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M137 147 L139 148 L139 150 L143 150 L144 147 L145 149 L145 156 L141 157 L135 156 L131 151 L137 152 Z" style="fill:';
    string private constant PART_38 = ';"/>';
    string private constant COLOR_1 = 'hsl(212, 43%, 7%)';
    string private constant COLOR_2 = 'hsl(212, 29%, 9%)';
    string private constant COLOR_3 = 'hsl(195, 84%, 36%)';
    string private constant COLOR_4 = 'hsl(195, 4%, 22%)';
    string private constant COLOR_5 = 'hsl(208, 83%, 14%)';
    string private constant COLOR_6 = 'hsl(195, 3%, 24%)';
    string private constant COLOR_7 = 'hsl(210, 45%, 11%)';
    string private constant COLOR_8 = 'hsl(214, 7%, 19%)';
    string private constant COLOR_9 = 'hsl(189, 70%, 45%)';
    string private constant COLOR_10 = 'hsl(210, 15%, 15%)';
    string private constant COLOR_11 = 'hsl(207, 10%, 17%)';
    string private constant COLOR_12 = 'hsl(75, 2%, 32%)';
    string private constant COLOR_13 = 'hsl(194, 84%, 37%)';
    string private constant COLOR_14 = 'hsl(214, 8%, 17%)';
    string private constant COLOR_15 = 'hsl(203, 87%, 27%)';
    string private constant COLOR_16 = 'hsl(200, 10%, 11%)';
    string private constant COLOR_17 = 'hsl(215, 24%, 10%)';
    string private constant COLOR_18 = 'hsl(207, 89%, 18%)';
    string private constant COLOR_19 = 'hsl(204, 90%, 25%)';
    string private constant COLOR_20 = 'hsl(80, 2%, 30%)';
    string private constant COLOR_21 = 'hsl(205, 91%, 23%)';
    string private constant COLOR_22 = 'hsl(185, 72%, 51%)';
    string private constant COLOR_23 = 'hsl(201, 42%, 19%)';
    string private constant COLOR_24 = 'hsl(213, 17%, 12%)';
    string private constant COLOR_25 = 'hsl(206, 7%, 21%)';
    string private constant COLOR_26 = 'hsl(213, 41%, 5%)';
    string private constant COLOR_27 = 'hsl(210, 23%, 9%)';
    string private constant COLOR_28 = 'hsl(210, 14%, 11%)';
    string private constant COLOR_29 = 'hsl(210, 14%, 20%)';
    string private constant COLOR_30 = 'hsl(202, 89%, 29%)';
    string private constant COLOR_31 = 'hsl(210, 79%, 15%)';
    string private constant COLOR_32 = 'hsl(210, 15%, 16%)';
    string private constant COLOR_33 = 'hsl(213, 12%, 15%)';
    string private constant COLOR_34 = 'hsl(216, 36%, 5%)';
    string private constant COLOR_35 = 'hsl(70, 4%, 33%)';
    string private constant COLOR_36 = 'hsl(206, 89%, 21%)';
    string private constant COLOR_37 = 'hsl(204, 88%, 23%)';

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
            PART_38
        );
        return result;
    }
}
