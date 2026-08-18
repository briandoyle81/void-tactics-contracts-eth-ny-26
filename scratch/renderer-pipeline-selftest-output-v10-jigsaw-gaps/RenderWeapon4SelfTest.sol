// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderWeapon4SelfTest {
    string private constant PART_1 = '<path d="M145 66L146 68L141 69L149 69L149 68ZM140 70L143 71L147 70ZM150 71L152 72L153 71ZM148 74L148 75L151 77L152 75L150 76L150 74ZM163 76L165 77L168 76ZM141 78L136 80L138 81L142 78ZM111 79L111 80L114 83L113 80L116 79ZM118 79L118 80L121 81L120 79ZM145 80L147 81L148 80ZM165 81L166 88L167 83ZM159 85L160 89L158 90L157 87L154 90L147 90L148 88L146 87L145 88L147 91L154 91L153 94L157 90L160 93L159 90L162 89L160 88ZM156 88L154 92L157 89L157 88ZM143 90L143 90L140 94L145 93L146 97L146 93ZM111 90L110 92L113 91L113 90ZM114 90L116 91L117 90ZM157 92L156 94L157 95L158 92ZM151 96L147 100L151 100L151 98L153 101L153 97ZM144 97L139 100L146 100L147 97L145 99L143 99L144 97ZM136 100L135 102L136 103L137 100Z" fill-rule="evenodd" style="fill:';
    string private constant PART_2 = ';"/><path d="M139 66L137 69L139 68L139 70L141 69L139 67L144 66ZM149 68L151 69L152 68ZM144 71L145 74L147 72L151 75L154 75L148 72ZM154 73L154 75L157 75L157 74ZM162 75L157 77L157 78L162 78L162 75ZM148 77L150 78L151 77ZM152 77L154 78L155 77ZM115 79L117 80L118 79ZM119 80L119 82L121 82L120 80ZM132 80L134 82L135 81ZM143 80L145 82L146 85L146 81ZM115 82L117 83L118 82ZM113 84L114 86L115 86L115 84ZM145 85L144 87L147 87L146 85ZM141 86L140 90L143 91L142 89L145 92L147 92L145 88L142 88ZM113 87L111 90L114 91L114 87ZM166 87L162 88L162 90L166 88L166 87ZM147 89L149 90L152 89ZM152 89L152 90L155 91L154 89ZM142 93L143 95L145 94L145 93ZM147 95L148 96L153 97L152 95ZM155 100L158 101L157 103L159 103L159 100ZM152 102L154 103L155 102Z" fill-rule="evenodd" style="fill:';
    string private constant PART_3 = ';"/><path d="M143 69L147 71L145 71L147 74L149 74L146 71L150 69ZM145 76L148 77L151 76ZM152 79L154 80L155 79ZM146 82L146 87L147 84ZM157 83L157 89L158 85ZM137 86L136 90L138 88ZM140 86L140 90L141 87ZM165 86L166 88L163 90L165 90L168 87ZM155 89L156 91L154 92L154 94L156 94L157 91ZM109 90L104 92L109 92L109 90ZM143 94L140 96L142 96L143 94ZM147 96L149 98L151 96ZM145 97L144 99L147 99L146 97ZM153 100L153 102L159 102L155 100ZM143 102L146 103L149 102ZM149 102L151 103L152 102Z" fill-rule="evenodd" style="fill:';
    string private constant PART_4 = ';"/><path d="M142 67L144 68L147 67ZM140 69L142 70L143 69ZM149 69L147 71L152 71L152 70ZM149 72L152 74L155 74L152 72ZM107 80L109 81L110 80ZM139 83L139 85L141 86L142 86ZM111 85L111 89L113 88L112 85ZM114 88L115 90L119 89L120 88ZM133 88L135 90L136 89Z" fill-rule="evenodd" style="fill:';
    string private constant PART_5 = ';"/><path d="M152 72L154 73L155 72ZM111 81L111 83L113 87L113 82ZM115 81L117 82L118 81ZM164 81L163 83L165 82L166 85L166 82ZM136 86L135 88L133 87L133 90L136 88L137 89L137 86ZM138 86L138 90L139 87ZM161 86L163 88L165 86ZM115 88L113 90L120 90L119 89ZM148 91L148 92L151 93L150 91ZM150 100L147 102L152 102L153 100Z" fill-rule="evenodd" style="fill:';
    string private constant PART_6 = ';"/><path d="M144 75L147 76L150 75ZM167 76L167 77L171 80L168 76ZM105 77L108 78L111 77ZM170 80L166 82L169 82L170 80ZM128 88L130 89L133 88ZM140 89L133 91L142 91L142 90ZM160 91L162 92L165 91ZM153 93L155 95L156 94ZM137 100L139 101L140 100Z" fill-rule="evenodd" style="fill:';
    string private constant PART_7 = ';"/><path d="M145 78L144 80L148 79L148 78ZM157 81L158 88L159 83ZM148 84L148 88L151 88L149 85L150 84ZM140 101L139 102L147 102L148 100Z" fill-rule="evenodd" style="fill:';
    string private constant PART_8 = ';"/><path d="M107 79L109 80L110 79ZM164 79L161 81L163 81L164 79ZM160 83L160 86L162 85L162 83ZM155 84L155 86L150 86L151 88L156 88L156 84ZM164 84L163 86L165 86L165 84Z" fill-rule="evenodd" style="fill:';
    string private constant PART_9 = ';"/><path d="M164 79L163 81L166 80L167 79ZM113 80L112 82L115 81L115 80ZM149 81L149 85L150 82ZM152 81L152 83L155 83L157 88L157 82L155 83L155 81ZM115 83L114 87L116 85Z" fill-rule="evenodd" style="fill:';
    string private constant PART_10 = ';"/><path d="M145 82L142 85L144 85L145 83Z" fill-rule="evenodd" style="fill:';
    string private constant PART_11 = ';"/><path d="M148 80L147 82L148 83L149 80ZM150 85L152 86L155 85Z" fill-rule="evenodd" style="fill:';
    string private constant PART_12 = ';"/><path d="M121 81L127 82L133 81ZM121 88L124 89L128 88Z" fill-rule="evenodd" style="fill:';
    string private constant PART_13 = ';"/><path d="M149 80L153 81L157 80Z" fill-rule="evenodd" style="fill:';
    string private constant PART_14 = ';"/><path d="M121 82L120 84L122 84L123 82ZM124 82L125 83L132 84L131 82Z" fill-rule="evenodd" style="fill:';
    string private constant PART_15 = ';"/><path d="M121 87L123 88L124 87ZM125 87L128 88L132 87Z" fill-rule="evenodd" style="fill:';
    string private constant PART_16 = ';"/><path d="M121 86L126 87L131 86Z" fill-rule="evenodd" style="fill:';
    string private constant PART_17 = ';"/><path d="M123 82L122 84L126 84L126 83ZM127 83L129 84L130 83Z" fill-rule="evenodd" style="fill:';
    string private constant PART_18 = ';"/><path d="M161 78L163 79L164 78Z" fill-rule="evenodd" style="fill:';
    string private constant PART_19 = ';"/><path d="M121 85L125 86L130 85Z" fill-rule="evenodd" style="fill:';
    string private constant PART_20 = ';"/><path d="M164 78L166 79L169 78Z" fill-rule="evenodd" style="fill:';
    string private constant PART_21 = ';"/><path d="M120 84L123 85L127 84Z" fill-rule="evenodd" style="fill:';
    string private constant PART_22 = ';"/><path d="M117 86L119 87L122 86Z" fill-rule="evenodd" style="fill:';
    string private constant PART_23 = ';"/>';
    string private constant COLOR_1 = 'hsl(210, 14%, 8%)';
    string private constant COLOR_2 = 'hsl(210, 11%, 11%)';
    string private constant COLOR_3 = 'hsl(206, 9%, 15%)';
    string private constant COLOR_4 = 'hsl(210, 6%, 18%)';
    string private constant COLOR_5 = 'hsl(206, 7%, 21%)';
    string private constant COLOR_6 = 'hsl(204, 19%, 5%)';
    string private constant COLOR_7 = 'hsl(180, 2%, 24%)';
    string private constant COLOR_8 = 'hsl(120, 1%, 28%)';
    string private constant COLOR_9 = 'hsl(90, 3%, 31%)';
    string private constant COLOR_10 = 'hsl(75, 2%, 34%)';
    string private constant COLOR_11 = 'hsl(60, 3%, 45%)';
    string private constant COLOR_12 = 'hsl(212, 68%, 7%)';
    string private constant COLOR_13 = 'hsl(51, 6%, 51%)';
    string private constant COLOR_14 = 'hsl(185, 64%, 47%)';
    string private constant COLOR_15 = 'hsl(183, 67%, 56%)';
    string private constant COLOR_16 = 'hsl(187, 80%, 36%)';
    string private constant COLOR_17 = 'hsl(183, 64%, 48%)';
    string private constant COLOR_18 = 'hsl(57, 9%, 61%)';
    string private constant COLOR_19 = 'hsl(178, 75%, 61%)';
    string private constant COLOR_20 = 'hsl(51, 8%, 67%)';
    string private constant COLOR_21 = 'hsl(175, 89%, 76%)';
    string private constant COLOR_22 = 'hsl(188, 86%, 34%)';

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
            PART_23
        );
        return result;
    }
}
