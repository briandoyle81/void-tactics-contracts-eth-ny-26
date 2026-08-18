// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderWeapon2SelfTest {
    string private constant PART_1 = '<path d="M64 86L64 88L66 88L65 86ZM68 86L68 88L74 88L94 89L94 87L84 87L73 88L72 86ZM118 86L117 87L95 87L95 89L115 89L129 89L128 91L131 90L129 89L130 86L126 87L125 88ZM174 90L176 92L177 91ZM153 95L154 97L155 97L155 95ZM137 97L140 98L143 97ZM130 98L133 99L136 98Z" fill-rule="evenodd" style="fill:';
    string private constant PART_2 = ';"/><path d="M144 85L144 87L146 86L146 85ZM147 85L147 88L149 88L149 85ZM155 87L154 91L156 88ZM172 87L172 92L174 91L174 87ZM169 88L167 91L169 91L170 88ZM71 92L75 93L80 92ZM95 92L98 93L102 92ZM103 92L106 93L109 92ZM109 92L112 93L115 92ZM118 92L120 93L121 92ZM122 92L124 93L127 92ZM141 92L140 93L141 95L144 95L144 92ZM146 92L145 97L147 97L147 95L150 96L148 93ZM132 93L130 97L131 95L134 98L134 93ZM152 93L152 95L154 94L154 93ZM122 95L122 96L126 97L127 95Z" fill-rule="evenodd" style="fill:';
    string private constant PART_3 = ';"/><path d="M113 82L112 84L114 85L114 82ZM150 82L150 84L153 84L152 82ZM154 82L154 83L158 88L156 83ZM140 83L142 84L143 83ZM75 84L77 85L78 84ZM95 84L97 85L100 84ZM103 84L107 85L112 84ZM120 84L122 85L125 84ZM151 87L150 89L155 89L154 87ZM160 87L162 88L165 87ZM165 87L165 88L168 89L168 87ZM171 87L171 92L174 92L172 90ZM156 88L154 92L155 93L157 89ZM169 89L169 93L170 90ZM148 90L147 92L149 93L149 90ZM160 91L161 92L164 92L165 90ZM137 93L137 97L138 94ZM139 95L140 96L145 97L145 95Z" fill-rule="evenodd" style="fill:';
    string private constant PART_4 = ';"/><path d="M162 85L164 86L165 85ZM65 86L66 88L64 89L73 89L75 86L72 86L73 88L68 88L68 86ZM79 86L81 87L84 86ZM85 86L90 87L95 86ZM100 86L103 87L107 86ZM107 86L110 87L113 86ZM113 86L115 87L114 90L118 87L118 86ZM121 86L121 87L125 88L126 86ZM140 86L141 87L144 88L147 89L144 86ZM130 87L130 89L132 90L131 87ZM178 89L178 94L179 91ZM157 96L159 97L160 96Z" fill-rule="evenodd" style="fill:';
    string private constant PART_5 = ';"/><path d="M149 80L148 82L156 81L161 84L164 82L158 82L157 80ZM129 81L135 82L141 81ZM143 81L145 82L148 81ZM65 84L69 85L73 84ZM160 93L160 97L161 94ZM177 93L179 94L182 93ZM157 95L154 99L155 100L159 95ZM124 98L127 99L131 98ZM153 102L154 105L155 104Z" fill-rule="evenodd" style="fill:';
    string private constant PART_6 = ';"/><path d="M74 82L76 83L77 82ZM85 82L87 83L88 82ZM92 82L94 83L95 82ZM96 82L98 83L99 82ZM104 82L109 83L114 82ZM116 82L118 83L121 82ZM121 82L123 83L124 82ZM125 82L127 83L128 82ZM143 83L145 84L148 83ZM84 84L88 85L92 84ZM92 84L94 85L95 84ZM117 84L119 85L120 84ZM129 84L129 85L133 88L130 84Z" fill-rule="evenodd" style="fill:';
    string private constant PART_7 = ';"/><path d="M158 92L160 93L163 92ZM75 96L79 97L84 96ZM91 96L95 97L100 96ZM152 96L152 97L151 100L153 100L154 97ZM126 97L128 98L129 97ZM144 97L146 98L147 97ZM145 99L147 100L148 99Z" fill-rule="evenodd" style="fill:';
    string private constant PART_8 = ';"/><path d="M149 85L149 87L151 86L151 85ZM180 88L180 93L181 90ZM151 92L151 94L149 93L150 96L147 97L151 97L152 93ZM86 95L90 96L95 95ZM101 95L103 96L106 95ZM127 95L126 97L129 97L128 95Z" fill-rule="evenodd" style="fill:';
    string private constant PART_9 = ';"/><path d="M129 90L129 92L132 91L133 90ZM157 91L157 93L159 92L159 91ZM162 92L166 93L170 92ZM63 93L65 94L66 93ZM68 93L71 94L74 93ZM77 93L79 94L80 93ZM82 93L84 94L87 93ZM87 93L89 94L90 93ZM113 93L115 94L116 93ZM108 96L110 97L111 96ZM117 96L119 97L120 96ZM137 103L139 104L140 103Z" fill-rule="evenodd" style="fill:';
    string private constant PART_10 = ';"/><path d="M140 81L142 82L143 81ZM171 82L171 83L175 86L172 82ZM180 84L179 86L182 86L181 84ZM62 87L63 89L64 89L64 87ZM143 91L145 92L146 91ZM144 100L140 102L146 102L146 101Z" fill-rule="evenodd" style="fill:';
    string private constant PART_11 = ';"/><path d="M164 84L166 85L169 84ZM138 89L138 93L139 90ZM142 90L144 91L145 90ZM127 92L127 94L129 94L129 92ZM133 94L134 96L135 96L135 94ZM136 94L136 98L137 95ZM153 94L155 95L158 94ZM74 95L77 96L80 95ZM130 96L130 98L132 98L131 96Z" fill-rule="evenodd" style="fill:';
    string private constant PART_12 = ';"/><path d="M181 88L181 92L182 89ZM110 93L110 94L113 95L113 93ZM61 95L66 96L72 95ZM140 99L140 101L142 101L141 99ZM143 103L143 105L148 105L148 103ZM149 103L149 105L151 105L151 103Z" fill-rule="evenodd" style="fill:';
    string private constant PART_13 = ';"/><path d="M158 87L157 90L157 91L159 90L160 93L159 88ZM135 89L137 90L138 89ZM139 90L141 91L142 90ZM93 93L95 94L98 93ZM100 93L105 94L110 93ZM121 93L124 94L128 93ZM144 99L144 101L146 101L145 99Z" fill-rule="evenodd" style="fill:';
    string private constant PART_14 = ';"/><path d="M132 82L134 83L137 82ZM94 83L97 84L100 83ZM102 83L105 84L108 83ZM108 83L110 84L111 83ZM114 83L118 84L122 83ZM122 83L125 84L128 83ZM141 84L143 85L144 84Z" fill-rule="evenodd" style="fill:';
    string private constant PART_15 = ';"/><path d="M163 88L164 89L167 90L166 88ZM107 94L109 95L110 94ZM120 94L123 95L126 94Z" fill-rule="evenodd" style="fill:';
    string private constant PART_16 = ';"/><path d="M159 83L161 85L162 84ZM161 93L167 94L173 93ZM138 98L140 99L143 98ZM149 100L149 101L153 102L152 100Z" fill-rule="evenodd" style="fill:';
    string private constant PART_17 = ';"/><path d="M133 83L133 86L137 86L137 85ZM70 94L72 95L73 94ZM101 94L103 95L104 94Z" fill-rule="evenodd" style="fill:';
    string private constant PART_18 = ';"/><path d="M130 83L133 84L132 86L133 86L135 83ZM136 83L136 85L139 84L139 83ZM138 85L140 86L141 85Z" fill-rule="evenodd" style="fill:';
    string private constant PART_19 = ';"/><path d="M79 92L81 93L82 92ZM90 92L93 93L96 92Z" fill-rule="evenodd" style="fill:';
    string private constant PART_20 = ';"/><path d="M75 97L78 98L81 97ZM82 97L86 98L90 97ZM101 97L104 98L107 97ZM109 97L111 98L112 97Z" fill-rule="evenodd" style="fill:';
    string private constant PART_21 = ';"/><path d="M144 82L146 83L147 82Z" fill-rule="evenodd" style="fill:';
    string private constant PART_22 = ';"/><path d="M163 83L165 84L166 83ZM85 85L87 86L88 85ZM89 85L91 86L94 85Z" fill-rule="evenodd" style="fill:';
    string private constant PART_23 = ';"/><path d="M59 86L59 90L60 87Z" fill-rule="evenodd" style="fill:';
    string private constant PART_24 = ';"/><path d="M75 85L77 86L78 85Z" fill-rule="evenodd" style="fill:';
    string private constant PART_25 = ';"/><path d="M182 89L182 93L183 90ZM106 97L108 98L109 97Z" fill-rule="evenodd" style="fill:';
    string private constant PART_26 = ';"/><path d="M139 82L141 83L142 82Z" fill-rule="evenodd" style="fill:';
    string private constant PART_27 = ';"/><path d="M172 95L174 96L175 95ZM130 99L133 100L137 99Z" fill-rule="evenodd" style="fill:';
    string private constant PART_28 = ';"/><path d="M163 86L165 87L168 86ZM172 86L175 87L179 86Z" fill-rule="evenodd" style="fill:';
    string private constant PART_29 = ';"/><path d="M135 88L137 89L138 88ZM139 89L141 90L144 89Z" fill-rule="evenodd" style="fill:';
    string private constant PART_30 = ';"/><path d="M176 84L178 85L179 84Z" fill-rule="evenodd" style="fill:';
    string private constant PART_31 = ';"/>';
    string private constant COLOR_1 = 'hsl(218, 13%, 17%)';
    string private constant COLOR_2 = 'hsl(300, 1%, 35%)';
    string private constant COLOR_3 = 'hsl(330, 1%, 37%)';
    string private constant COLOR_4 = 'hsl(217, 17%, 15%)';
    string private constant COLOR_5 = 'hsl(215, 21%, 11%)';
    string private constant COLOR_6 = 'hsl(12, 3%, 39%)';
    string private constant COLOR_7 = 'hsl(216, 10%, 20%)';
    string private constant COLOR_8 = 'hsl(225, 2%, 33%)';
    string private constant COLOR_9 = 'hsl(214, 6%, 23%)';
    string private constant COLOR_10 = 'hsl(216, 16%, 13%)';
    string private constant COLOR_11 = 'hsl(228, 3%, 30%)';
    string private constant COLOR_12 = 'hsl(223, 6%, 25%)';
    string private constant COLOR_13 = 'hsl(210, 3%, 27%)';
    string private constant COLOR_14 = 'hsl(24, 4%, 49%)';
    string private constant COLOR_15 = 'hsl(30, 3%, 46%)';
    string private constant COLOR_16 = 'hsl(215, 35%, 10%)';
    string private constant COLOR_17 = 'hsl(26, 3%, 45%)';
    string private constant COLOR_18 = 'hsl(15, 2%, 42%)';
    string private constant COLOR_19 = 'hsl(30, 2%, 34%)';
    string private constant COLOR_20 = 'hsl(213, 69%, 3%)';
    string private constant COLOR_21 = 'hsl(27, 4%, 52%)';
    string private constant COLOR_22 = 'hsl(22, 5%, 55%)';
    string private constant COLOR_23 = 'hsl(218, 19%, 8%)';
    string private constant COLOR_24 = 'hsl(23, 6%, 58%)';
    string private constant COLOR_25 = 'hsl(235, 58%, 4%)';
    string private constant COLOR_26 = 'hsl(30, 8%, 60%)';
    string private constant COLOR_27 = 'hsl(48, 5%, 20%)';
    string private constant COLOR_28 = 'hsl(37, 10%, 55%)';
    string private constant COLOR_29 = 'hsl(27, 10%, 65%)';
    string private constant COLOR_30 = 'hsl(230, 19%, 6%)';

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
            PART_31
        );
        return result;
    }
}
