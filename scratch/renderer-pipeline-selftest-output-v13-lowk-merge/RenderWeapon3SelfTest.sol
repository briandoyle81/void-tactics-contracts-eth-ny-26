// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderWeapon3SelfTest {
    string private constant PART_1 = '<path d="M135 76L135 78L129 78L121 81L118 83L124 87L117 91L129 96L140 97L139 100L134 101L133 103L156 103L156 100L153 98L153 96L161 96L161 93L164 96L168 96L169 93L172 91L172 83L169 82L168 78L164 77L161 81L161 78L139 78L139 76Z" fill-rule="evenodd" style="fill:';
    string private constant PART_2 = ';"/><path d="M135 76L136 79L138 78L139 76ZM163 77L167 79L163 80L167 80L168 77ZM129 78L132 79L136 78ZM155 78L158 79L161 78ZM126 80L121 82L121 84L126 85L126 80ZM127 80L127 84L128 81ZM129 80L129 85L130 82L132 83L138 84L137 81ZM139 80L139 84L140 81ZM142 80L141 82L143 84L147 82L146 84L149 84L150 81L150 84L153 83L155 86L154 82L160 82L161 80ZM161 83L161 85L164 85L161 87L163 88L163 87L166 89L171 88L169 86L171 86L170 83ZM142 88L141 89L143 91L143 89L145 89L144 91L148 91L149 89L151 91L155 92L154 90L159 88ZM123 88L120 91L126 91L126 88ZM131 88L131 90L134 92L137 89L138 90L138 88ZM150 93L150 96L148 95L148 97L150 97L152 95ZM145 94L145 96L147 95L147 94Z" fill-rule="evenodd" style="fill:';
    string private constant PART_3 = ';"/><path d="M126 80L121 82L121 84L126 85L126 80ZM164 83L167 84L170 83ZM123 88L120 91L126 91L126 88Z" fill-rule="evenodd" style="fill:';
    string private constant PART_4 = ';"/><path d="M125 81L122 83L124 83L125 81ZM164 83L167 84L170 83Z" fill-rule="evenodd" style="fill:';
    string private constant PART_5 = ';"/><path d="M125 81L122 83L124 83L125 81Z" fill-rule="evenodd" style="fill:';
    string private constant PART_6 = ';"/>';
    string private constant COLOR_1 = 'hsl(210, 5%, 16%)';
    string private constant COLOR_2 = 'hsl(60, 3%, 37%)';
    string private constant COLOR_3 = 'hsl(9, 52%, 43%)';
    string private constant COLOR_4 = 'hsl(57, 9%, 61%)';
    string private constant COLOR_5 = 'hsl(14, 65%, 59%)';

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
            PART_6
        );
        return result;
    }
}
