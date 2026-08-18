// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderArmor2SelfTest {
    string private constant PART_1 = '<path d="M129 103 L169 103 L173 107 L173 116 L177 118 L179 120 L179 146 L170 157 L169 171 L165 175 L156 177 L154 179 L136 179 L135 178 L130 178 L124 172 L109 169 L104 164 L99 164 L97 166 L81 166 L74 161 L67 160 L67 119 L75 116 L78 114 L85 113 L90 108 L107 108 L111 112 L111 114 L118 113 L121 112 L121 110 L123 110 L123 108 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M129 105 L169 105 L171 107 L171 115 L124 116 L124 127 L118 127 L118 123 L112 123 L111 124 L116 124 L116 150 L111 150 L110 152 L75 152 L75 127 L78 127 L75 126 L75 120 L78 116 L93 115 L87 115 L89 111 L90 108 L107 108 L111 112 L111 114 L118 113 L121 112 L121 110 L123 110 L124 108 L125 110 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M125 116 L130 116 L130 118 L133 118 L133 116 L135 116 L135 118 L138 118 L138 116 L142 116 L142 118 L145 118 L145 116 L148 116 L148 118 L151 118 L151 116 L154 116 L154 118 L157 118 L157 116 L175 116 L178 121 L177 123 L175 122 L175 138 L172 145 L165 153 L155 151 L154 149 L153 152 L157 152 L157 154 L148 154 L148 133 L132 134 L128 135 L129 137 L133 138 L133 135 L145 135 L147 136 L147 154 L118 154 L118 147 L125 147 L125 145 L118 145 L118 129 L125 129 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M173 116 L175 116 L178 121 L177 123 L175 122 L175 138 L172 145 L165 153 L155 151 L154 149 L153 152 L157 152 L157 154 L148 154 L148 133 L136 133 L137 126 L134 123 L136 120 L144 120 L144 124 L142 124 L141 129 L147 127 L150 127 L148 125 L149 122 L152 122 L157 123 L157 124 L163 125 L163 127 L158 127 L162 129 L164 129 L168 128 L164 128 L165 124 L170 126 L169 123 L164 123 L164 121 L172 120 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M88 110 L90 112 L88 114 L93 115 L94 111 L94 115 L105 115 L105 116 L78 117 L76 120 L75 126 L77 126 L77 121 L78 121 L78 127 L75 127 L75 152 L77 152 L77 128 L78 128 L78 152 L110 152 L110 128 L111 128 L111 153 L76 154 L77 158 L107 159 L114 160 L113 162 L107 162 L107 164 L110 167 L116 168 L116 169 L109 169 L104 164 L99 164 L97 166 L81 166 L74 161 L67 160 L67 119 L75 116 L78 114 L85 113 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M80 129 L104 129 L105 130 L105 149 L104 150 L80 150 L79 148 L79 131 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M127 160 L168 160 L168 169 L164 173 L136 173 L135 176 L129 177 L127 173 L127 171 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M175 117 L179 120 L179 146 L170 157 L169 171 L165 175 L156 177 L154 179 L136 179 L135 178 L130 178 L131 175 L135 176 L135 174 L131 173 L137 172 L164 172 L167 171 L168 160 L144 161 L132 161 L124 160 L119 160 L119 158 L168 158 L170 153 L177 145 L177 121 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M125 116 L130 116 L130 118 L133 118 L133 116 L135 116 L135 118 L138 118 L138 116 L142 116 L142 118 L145 118 L145 116 L148 116 L148 118 L151 118 L151 116 L154 116 L154 118 L157 118 L157 116 L173 116 L172 120 L164 121 L164 123 L169 122 L171 124 L170 128 L170 126 L165 125 L164 128 L168 128 L167 131 L167 129 L162 131 L161 129 L158 129 L158 127 L163 127 L163 125 L156 125 L155 123 L152 122 L151 124 L149 123 L149 125 L151 127 L149 129 L145 128 L141 129 L142 124 L144 124 L144 119 L135 120 L126 120 L126 130 L118 130 L118 129 L125 129 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M84 132 L98 133 L102 138 L101 144 L97 147 L92 147 L92 148 L92 149 L81 149 L82 139 L86 139 L85 142 L85 140 L83 140 L85 143 L88 143 L87 138 L82 138 L81 135 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M134 105 L169 105 L171 107 L171 115 L154 115 L154 112 L151 111 L151 109 L138 109 L138 107 L136 107 L136 109 L132 108 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M111 150 L116 150 L116 155 L113 155 L112 157 L110 157 L110 159 L77 159 L75 157 L76 153 L111 153 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M129 160 L132 160 L133 162 L158 163 L158 171 L131 171 L129 169 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M81 117 L102 117 L101 126 L78 126 L78 120 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M129 103 L169 103 L173 107 L173 116 L157 116 L157 118 L154 118 L154 116 L151 116 L151 118 L148 118 L148 116 L145 116 L145 118 L142 118 L142 116 L138 116 L138 118 L135 118 L135 116 L133 116 L133 118 L130 118 L130 116 L123 116 L123 115 L171 115 L170 107 L169 106 L129 105 L127 109 L124 111 L125 107 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M71 119 L74 120 L73 158 L69 158 L70 155 L68 154 L68 121 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M125 116 L130 116 L130 118 L133 118 L133 116 L135 116 L135 118 L138 118 L138 116 L142 116 L142 118 L145 118 L145 116 L148 116 L148 118 L151 118 L151 116 L154 116 L154 118 L157 118 L157 116 L173 116 L171 120 L126 120 L126 130 L118 130 L118 129 L125 129 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M136 172 L160 173 L155 178 L154 179 L136 179 L135 178 L130 178 L131 175 L135 176 L135 174 L131 173 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M133 160 L156 160 L165 161 L165 168 L162 171 L159 171 L158 169 L158 163 L133 163 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M84 132 L98 133 L102 138 L101 144 L97 145 L92 142 L93 137 L98 138 L97 143 L99 142 L99 137 L98 136 L91 136 L90 141 L91 144 L88 143 L87 138 L82 138 L81 135 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M164 124 L170 126 L169 132 L166 135 L163 136 L168 138 L164 140 L163 145 L161 144 L159 137 L154 140 L149 139 L149 137 L151 137 L152 135 L153 136 L155 134 L156 135 L157 133 L162 134 L163 130 L168 128 L164 128 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M111 126 L116 126 L116 150 L111 150 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M103 131 L105 131 L105 149 L104 150 L81 150 L81 149 L91 148 L89 145 L97 146 L100 144 L101 135 L101 132 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M136 120 L144 120 L144 124 L142 124 L141 129 L147 127 L148 130 L152 131 L150 133 L136 133 L137 126 L134 123 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M124 116 L125 116 L125 129 L118 129 L118 145 L125 145 L125 147 L118 147 L118 154 L127 154 L127 155 L122 156 L118 158 L117 158 L116 125 L111 124 L112 122 L118 123 L118 127 L124 127 L123 117 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M103 127 L109 127 L109 139 L107 139 L106 145 L109 146 L105 149 L104 130 L80 129 L79 131 L79 128 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M117 116 L124 116 L124 127 L118 127 L118 123 L112 123 L114 119 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M111 150 L116 150 L116 155 L113 155 L112 157 L93 157 L93 154 L98 155 L98 153 L111 153 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M81 117 L102 117 L102 119 L90 120 L86 119 L85 121 L84 122 L85 126 L78 126 L78 120 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M171 108 L172 108 L173 116 L157 116 L157 118 L154 118 L154 116 L151 116 L151 118 L148 118 L148 116 L145 116 L145 118 L142 118 L142 116 L138 116 L138 118 L135 118 L135 116 L133 116 L133 118 L130 118 L130 116 L123 116 L123 115 L171 115 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M106 161 L112 162 L112 165 L113 163 L116 163 L118 165 L126 165 L125 170 L116 170 L116 168 L110 168 L109 165 L106 164 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M163 105 L169 105 L171 107 L171 115 L163 115 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M80 129 L104 129 L105 131 L101 134 L102 138 L98 134 L91 133 L91 132 L80 132 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M109 127 L110 127 L110 152 L101 152 L101 150 L106 149 L106 145 L106 138 L109 139 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M175 122 L178 123 L178 144 L172 144 L174 138 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M103 117 L114 117 L110 122 L109 126 L103 126 Z" style="fill:';
    string private constant PART_37 = ';"/>';
    string private constant COLOR_1 = 'hsl(225, 9%, 18%)';
    string private constant COLOR_2 = 'hsl(240, 2%, 28%)';
    string private constant COLOR_3 = 'hsl(20, 2%, 36%)';
    string private constant COLOR_4 = 'hsl(0, 1%, 35%)';
    string private constant COLOR_5 = 'hsl(216, 18%, 11%)';
    string private constant COLOR_6 = 'hsl(213, 13%, 14%)';
    string private constant COLOR_7 = 'hsl(218, 12%, 17%)';
    string private constant COLOR_8 = 'hsl(213, 26%, 8%)';
    string private constant COLOR_9 = 'hsl(36, 3%, 39%)';
    string private constant COLOR_10 = 'hsl(215, 19%, 19%)';
    string private constant COLOR_11 = 'hsl(34, 3%, 44%)';
    string private constant COLOR_12 = 'hsl(222, 10%, 20%)';
    string private constant COLOR_13 = 'hsl(220, 4%, 29%)';
    string private constant COLOR_14 = 'hsl(60, 1%, 36%)';
    string private constant COLOR_15 = 'hsl(220, 11%, 11%)';
    string private constant COLOR_16 = 'hsl(216, 11%, 18%)';
    string private constant COLOR_17 = 'hsl(40, 4%, 48%)';
    string private constant COLOR_18 = 'hsl(218, 12%, 13%)';
    string private constant COLOR_19 = 'hsl(214, 6%, 22%)';
    string private constant COLOR_20 = 'hsl(206, 18%, 31%)';
    string private constant COLOR_21 = 'hsl(60, 1%, 30%)';
    string private constant COLOR_22 = 'hsl(0, 0%, 35%)';
    string private constant COLOR_23 = 'hsl(218, 11%, 14%)';
    string private constant COLOR_24 = 'hsl(20, 2%, 32%)';
    string private constant COLOR_25 = 'hsl(225, 3%, 24%)';
    string private constant COLOR_26 = 'hsl(0, 0%, 35%)';
    string private constant COLOR_27 = 'hsl(30, 3%, 43%)';
    string private constant COLOR_28 = 'hsl(222, 8%, 23%)';
    string private constant COLOR_29 = 'hsl(36, 2%, 49%)';
    string private constant COLOR_30 = 'hsl(216, 12%, 8%)';
    string private constant COLOR_31 = 'hsl(218, 11%, 19%)';
    string private constant COLOR_32 = 'hsl(0, 1%, 35%)';
    string private constant COLOR_33 = 'hsl(213, 20%, 9%)';
    string private constant COLOR_34 = 'hsl(228, 3%, 31%)';
    string private constant COLOR_35 = 'hsl(214, 5%, 25%)';
    string private constant COLOR_36 = 'hsl(30, 2%, 42%)';

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
            PART_37
        );
        return result;
    }
}
