// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderWeapon1SelfTest {
    string private constant PART_1 = '<path d="M148 78 L152 79 L163 81 L163 83 L170 85 L170 92 L165 95 L157 97 L152 99 L152 105 L137 105 L138 101 L140 96 L135 96 L133 94 L111 94 L110 93 L110 85 L111 84 L126 83 L127 82 L137 81 L147 79 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M148 78 L152 79 L163 81 L163 83 L170 85 L170 92 L165 95 L159 95 L161 87 L162 84 L162 82 L155 85 L155 83 L148 84 L145 85 L140 84 L141 91 L139 93 L137 92 L117 91 L117 90 L137 90 L137 88 L117 88 L117 87 L126 87 L126 85 L115 85 L115 91 L114 91 L114 85 L111 84 L126 83 L127 82 L137 81 L147 79 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M148 85 L150 85 L152 91 L153 94 L159 95 L156 98 L152 99 L152 105 L137 105 L138 101 L140 96 L135 96 L135 95 L143 94 L143 96 L147 95 L146 92 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M156 82 L162 82 L163 84 L163 92 L161 92 L159 95 L153 94 L150 89 L150 85 L148 85 L148 87 L145 87 L145 90 L140 91 L140 84 L147 84 L148 83 L155 83 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M137 81 L139 82 L138 83 L128 84 L127 86 L137 85 L140 83 L141 92 L139 93 L137 92 L117 91 L117 90 L137 90 L137 88 L117 88 L117 87 L126 87 L126 85 L115 85 L115 91 L114 91 L114 85 L111 84 L126 83 L127 82 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M148 83 L155 83 L155 85 L159 85 L159 87 L150 87 L150 85 L148 85 L148 87 L145 87 L145 90 L140 91 L140 84 L147 84 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M139 81 L146 81 L147 85 L139 84 L137 86 L127 86 L128 83 L138 82 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M164 84 L170 85 L170 92 L165 94 L164 93 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M145 87 L148 88 L147 94 L150 96 L143 96 L138 94 L137 92 L140 92 L143 89 L145 90 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M156 82 L162 82 L163 84 L163 92 L161 92 L159 95 L157 95 L159 85 L156 84 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M148 78 L152 79 L155 80 L155 82 L147 84 L146 81 L139 81 L139 80 L147 79 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M139 83 L141 87 L141 92 L139 93 L137 92 L117 91 L117 90 L138 90 L138 84 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M115 85 L126 85 L126 87 L117 87 L117 91 L115 91 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M150 83 L155 83 L155 85 L159 85 L159 87 L150 87 L149 84 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M166 85 L170 85 L170 92 L169 90 L166 89 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M137 85 L139 85 L139 91 L137 90 L137 88 L132 88 L133 86 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M133 91 L137 91 L139 95 L134 95 Z" style="fill:';
    string private constant PART_18 = ';"/>';
    string private constant COLOR_1 = 'hsl(3, 37%, 20%)';
    string private constant COLOR_2 = 'hsl(218, 19%, 8%)';
    string private constant COLOR_3 = 'hsl(213, 16%, 11%)';
    string private constant COLOR_4 = 'hsl(120, 1%, 27%)';
    string private constant COLOR_5 = 'hsl(207, 21%, 8%)';
    string private constant COLOR_6 = 'hsl(75, 2%, 32%)';
    string private constant COLOR_7 = 'hsl(105, 4%, 22%)';
    string private constant COLOR_8 = 'hsl(210, 12%, 13%)';
    string private constant COLOR_9 = 'hsl(202, 7%, 21%)';
    string private constant COLOR_10 = 'hsl(16, 15%, 26%)';
    string private constant COLOR_11 = 'hsl(197, 13%, 11%)';
    string private constant COLOR_12 = 'hsl(205, 38%, 6%)';
    string private constant COLOR_13 = 'hsl(90, 3%, 30%)';
    string private constant COLOR_14 = 'hsl(51, 3%, 41%)';
    string private constant COLOR_15 = 'hsl(210, 3%, 24%)';
    string private constant COLOR_16 = 'hsl(225, 6%, 14%)';
    string private constant COLOR_17 = 'hsl(207, 12%, 15%)';

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
        return result;
    }
}
