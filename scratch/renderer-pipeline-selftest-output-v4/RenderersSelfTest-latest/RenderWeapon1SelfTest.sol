// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderWeapon1SelfTest {
    string private constant PART_1 = '<path d="M148 78 L152 79 L163 81 L163 83 L170 85 L170 92 L165 95 L157 97 L152 99 L152 105 L137 105 L138 101 L140 96 L135 96 L133 94 L111 94 L110 93 L110 85 L111 84 L126 83 L127 82 L137 81 L147 79 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M139 83 L141 87 L141 92 L138 93 L143 94 L143 96 L147 95 L146 92 L148 85 L150 85 L151 88 L154 91 L153 94 L159 95 L156 98 L152 99 L152 105 L137 105 L138 101 L140 96 L135 96 L133 94 L111 94 L110 93 L110 85 L111 84 L126 84 L126 85 L115 85 L115 91 L117 91 L117 88 L137 88 L138 90 L138 84 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M139 83 L141 87 L141 92 L138 93 L139 95 L134 95 L133 94 L111 94 L110 93 L110 85 L111 84 L126 84 L126 85 L115 85 L115 91 L117 91 L117 88 L137 88 L138 90 L138 84 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M148 78 L152 79 L163 81 L163 83 L170 85 L170 92 L165 95 L159 95 L161 87 L162 84 L162 82 L156 85 L151 85 L146 83 L146 81 L139 81 L139 80 L147 79 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M156 82 L162 82 L163 84 L163 92 L161 92 L159 95 L153 94 L153 90 L150 88 L150 85 L148 85 L148 87 L145 86 L148 83 L156 84 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M140 84 L145 84 L148 88 L147 94 L150 96 L143 96 L138 94 L137 92 L140 91 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M139 99 L142 100 L150 101 L151 99 L152 105 L137 105 L138 101 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M148 78 L152 79 L155 80 L155 85 L147 84 L146 81 L139 81 L139 80 L147 79 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M148 85 L150 85 L151 88 L154 91 L153 94 L156 95 L147 95 L146 92 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M156 82 L162 82 L163 84 L163 92 L161 92 L159 95 L157 95 L159 85 L156 84 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M164 84 L170 85 L170 92 L164 93 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M142 94 L143 96 L149 96 L150 98 L142 99 L140 101 L140 96 L135 96 L135 95 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M119 91 L137 91 L139 95 L134 95 L133 92 L119 92 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M145 87 L148 88 L147 94 L150 96 L143 96 L144 91 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M115 85 L126 85 L126 87 L117 87 L117 91 L115 91 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M110 85 L114 85 L114 92 L110 92 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M140 84 L145 84 L146 86 L144 92 L143 88 L140 86 Z M140 87 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M147 81 L155 81 L155 85 L150 84 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M156 94 L159 96 L152 99 L150 95 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M160 86 L161 86 L161 92 L159 95 L157 95 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M148 85 L150 85 L151 89 L147 89 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M161 87 L162 87 L163 94 L160 93 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M145 87 L148 88 L146 92 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M150 89 L154 90 L152 93 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M141 87 L144 88 L140 91 Z" style="fill:';
    string private constant PART_26 = ';"/>';
    string private constant COLOR_1 = 'hsl(160, 4%, 16%)';
    string private constant COLOR_2 = 'hsl(216, 17%, 11%)';
    string private constant COLOR_3 = 'hsl(0, 33%, 14%)';
    string private constant COLOR_4 = 'hsl(213, 31%, 7%)';
    string private constant COLOR_5 = 'hsl(60, 3%, 35%)';
    string private constant COLOR_6 = 'hsl(207, 9%, 21%)';
    string private constant COLOR_7 = 'hsl(206, 11%, 13%)';
    string private constant COLOR_8 = 'hsl(206, 16%, 8%)';
    string private constant COLOR_9 = 'hsl(213, 17%, 12%)';
    string private constant COLOR_10 = 'hsl(180, 4%, 23%)';
    string private constant COLOR_11 = 'hsl(210, 6%, 19%)';
    string private constant COLOR_12 = 'hsl(210, 22%, 9%)';
    string private constant COLOR_13 = 'hsl(207, 12%, 15%)';
    string private constant COLOR_14 = 'hsl(210, 9%, 21%)';
    string private constant COLOR_15 = 'hsl(90, 3%, 30%)';
    string private constant COLOR_16 = 'hsl(4, 21%, 28%)';
    string private constant COLOR_17 = 'hsl(90, 1%, 30%)';
    string private constant COLOR_18 = 'hsl(165, 4%, 20%)';
    string private constant COLOR_19 = 'hsl(213, 20%, 9%)';
    string private constant COLOR_20 = 'hsl(13, 48%, 31%)';
    string private constant COLOR_21 = 'hsl(200, 19%, 9%)';
    string private constant COLOR_22 = 'hsl(333, 15%, 12%)';
    string private constant COLOR_23 = 'hsl(160, 3%, 23%)';
    string private constant COLOR_24 = 'hsl(203, 8%, 19%)';
    string private constant COLOR_25 = 'hsl(204, 4%, 24%)';

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
            PART_26
        );
        return result;
    }
}
