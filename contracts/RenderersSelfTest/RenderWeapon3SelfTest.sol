// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderWeapon3SelfTest {
    string private constant PART_1 = '<path d="M135 76L135 78L129 78L121 81L118 83L124 87L117 91L129 96L140 97L139 100L134 101L133 103L156 103L156 100L153 98L153 96L161 96L161 93L164 96L168 96L169 93L172 91L172 83L169 82L168 78L164 77L161 81L161 78L139 78L139 76Z" fill-rule="evenodd" style="fill:';
    string private constant PART_2 = ';"/><path d="M135 76L135 78L129 79L136 79L139 79L139 84L140 81L139 76ZM163 77L163 79L162 82L166 82L168 77ZM155 78L156 80L141 79L142 86L149 85L161 84L162 86L156 86L156 88L141 87L141 94L146 93L143 98L144 99L147 94L150 94L151 98L149 95L147 95L147 100L149 97L149 99L153 99L151 93L149 93L149 90L151 92L160 93L161 91L154 91L155 90L162 89L171 89L171 83L160 83L161 78ZM125 80L122 82L120 81L120 84L123 85L126 85L126 80ZM127 80L127 86L128 82ZM129 80L129 87L131 83L131 85L138 85L138 80ZM155 82L154 84L157 83L157 82ZM127 87L127 92L128 89ZM129 87L129 94L131 91L131 93L138 93L138 87ZM139 87L139 94L140 90ZM124 88L119 90L121 92L126 93L126 88ZM163 95L166 96L169 95ZM135 96L137 97L140 96ZM141 100L141 102L143 102L143 100ZM144 100L144 102L150 102L149 100ZM152 100L153 102L155 102L155 100ZM136 101L138 102L141 101Z" fill-rule="evenodd" style="fill:';
    string private constant PART_3 = ';"/><path d="M126 80L121 82L121 84L126 84L126 80ZM127 80L127 84L128 81ZM131 80L131 83L138 83L136 80ZM142 80L141 82L143 82L147 82L147 84L149 83L149 80ZM150 80L151 83L153 82L157 81L158 80ZM161 83L164 86L164 88L166 89L167 86L165 87L165 85L169 85L169 83ZM123 88L120 91L126 91L126 88ZM131 88L132 89L138 90L137 88ZM141 88L142 89L149 90L149 88ZM152 88L154 89L155 88Z" fill-rule="evenodd" style="fill:';
    string private constant PART_4 = ';"/><path d="M126 80L121 82L121 84L126 84L126 80ZM164 83L167 84L170 83ZM123 88L120 91L126 91L126 88Z" fill-rule="evenodd" style="fill:';
    string private constant PART_5 = ';"/><path d="M125 81L122 83L124 83L125 81ZM164 83L167 84L170 83Z" fill-rule="evenodd" style="fill:';
    string private constant PART_6 = ';"/><path d="M125 81L122 83L124 83L125 81Z" fill-rule="evenodd" style="fill:';
    string private constant PART_7 = ';"/>';
    string private constant COLOR_1 = 'hsl(214, 14%, 10%)';
    string private constant COLOR_2 = 'hsl(60, 1%, 26%)';
    string private constant COLOR_3 = 'hsl(54, 5%, 43%)';
    string private constant COLOR_4 = 'hsl(9, 52%, 44%)';
    string private constant COLOR_5 = 'hsl(56, 8%, 60%)';
    string private constant COLOR_6 = 'hsl(14, 65%, 59%)';

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
            PART_7
        );
        return result;
    }
}
