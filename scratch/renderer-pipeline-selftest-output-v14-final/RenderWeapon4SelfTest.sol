// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderWeapon4SelfTest {
    string private constant PART_1 = '<path d="M139 66L137 68L137 71L142 71L146 74L139 79L133 79L132 81L121 81L120 79L111 79L110 77L104 77L104 79L108 81L108 87L104 91L105 93L113 91L120 91L121 89L132 89L133 91L142 91L139 95L141 97L144 95L145 96L142 99L136 101L135 103L159 103L159 99L154 99L153 98L159 92L163 92L168 90L169 82L171 82L171 78L167 76L158 75L158 71L153 70L153 68L147 68L146 66Z" fill-rule="evenodd" style="fill:';
    string private constant PART_2 = ';"/><path d="M157 70L154 72L157 73L157 70ZM152 75L151 77L160 76L161 75ZM142 77L140 80L147 79L148 77ZM105 78L110 80L113 82L120 80L112 80L110 78ZM152 78L156 79L157 81L148 81L148 88L156 88L158 82L159 87L158 79L160 82L160 87L165 86L165 82L163 83L163 81L169 81L169 78ZM170 79L170 83L171 80ZM136 80L133 83L133 86L137 83L137 80ZM138 80L138 82L135 86L139 86L139 83L141 83L142 86L145 86L145 81L140 82ZM109 81L108 84L109 88L110 84ZM113 83L111 85L115 84L115 86L112 86L109 91L113 87L132 88L132 82ZM150 83L149 86L154 84L155 85L155 83ZM140 100L139 102L147 102L148 100Z" fill-rule="evenodd" style="fill:';
    string private constant PART_3 = ';"/><path d="M152 75L151 77L160 76L160 75ZM153 78L161 79L170 78ZM148 80L147 82L148 83L148 81L155 81L156 80ZM160 81L162 82L163 81ZM121 82L116 83L116 87L122 88L132 88L132 82ZM133 82L135 83L138 82ZM150 85L152 86L155 85Z" fill-rule="evenodd" style="fill:';
    string private constant PART_4 = ';"/><path d="M121 82L116 83L116 87L122 88L132 88L132 82Z" fill-rule="evenodd" style="fill:';
    string private constant PART_5 = ';"/><path d="M116 83L116 87L133 87L118 85L133 85L130 84Z" fill-rule="evenodd" style="fill:';
    string private constant PART_6 = ';"/><path d="M118 84L125 85L133 84Z" fill-rule="evenodd" style="fill:';
    string private constant PART_7 = ';"/>';
    string private constant COLOR_1 = 'hsl(210, 9%, 13%)';
    string private constant COLOR_2 = 'hsl(120, 2%, 32%)';
    string private constant COLOR_3 = 'hsl(55, 5%, 54%)';
    string private constant COLOR_4 = 'hsl(183, 61%, 52%)';
    string private constant COLOR_5 = 'hsl(187, 76%, 36%)';
    string private constant COLOR_6 = 'hsl(175, 83%, 77%)';

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
