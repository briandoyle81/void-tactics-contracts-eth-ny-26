// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderWeapon1SelfTest {
    string private constant PART_1 = '<path d="M148 78 L152 79 L163 81 L163 83 L170 85 L170 92 L165 95 L159 95 L161 87 L162 84 L162 82 L155 85 L155 83 L148 84 L144 84 L139 84 L137 86 L127 86 L128 83 L138 82 L139 80 L147 79 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M148 85 L150 85 L151 88 L154 91 L153 94 L159 95 L156 98 L152 99 L152 104 L138 104 L139 102 L149 101 L149 98 L135 96 L135 95 L143 94 L144 95 L145 87 L148 87 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M116 86 L117 88 L137 88 L137 91 L140 92 L142 87 L144 88 L142 95 L134 95 L133 94 L111 94 L110 92 L114 92 L115 88 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M137 81 L139 82 L138 83 L128 84 L127 86 L137 85 L140 83 L141 92 L139 93 L137 92 L117 91 L117 90 L137 90 L137 88 L117 88 L117 87 L126 87 L127 82 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M156 82 L162 82 L163 84 L163 92 L161 92 L159 95 L153 94 L153 90 L150 87 L159 87 L159 85 L156 84 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M140 83 L147 84 L148 83 L155 83 L155 85 L159 85 L159 87 L150 87 L150 85 L148 85 L148 87 L145 87 L145 96 L143 96 L143 88 L142 87 L141 91 L140 87 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M140 97 L150 97 L149 102 L139 103 L152 104 L152 105 L137 105 L138 101 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M111 84 L126 84 L126 87 L117 87 L114 92 L110 92 L110 85 Z" style="fill:';
    string private constant PART_9 = ';"/>';
    string private constant COLOR_1 = 'hsl(204, 7%, 15%)';
    string private constant COLOR_2 = 'hsl(210, 11%, 14%)';
    string private constant COLOR_3 = 'hsl(0, 25%, 18%)';
    string private constant COLOR_4 = 'hsl(207, 20%, 9%)';
    string private constant COLOR_5 = 'hsl(18, 7%, 27%)';
    string private constant COLOR_6 = 'hsl(60, 2%, 35%)';
    string private constant COLOR_7 = 'hsl(213, 19%, 9%)';
    string private constant COLOR_8 = 'hsl(11, 9%, 24%)';

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
            PART_9
        );
        return result;
    }
}
