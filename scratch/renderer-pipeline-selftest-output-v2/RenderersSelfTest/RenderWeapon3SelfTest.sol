// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderWeapon3SelfTest {
    string private constant PART_1 = '<path d="M135 76 L139 76 L139 78 L161 78 L162 79 L163 77 L168 77 L169 82 L172 83 L172 91 L169 92 L168 96 L163 96 L162 94 L161 96 L153 96 L156 100 L156 103 L133 103 L134 100 L139 99 L140 97 L128 96 L117 91 L121 88 L123 87 L118 83 L123 80 L128 78 L135 78 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M171 83 L172 83 L172 91 L169 92 L168 96 L163 96 L162 94 L161 96 L153 96 L156 100 L156 103 L133 103 L134 100 L139 99 L141 97 L141 102 L143 102 L142 97 L145 97 L144 95 L141 95 L141 93 L149 92 L150 90 L150 92 L156 89 L171 89 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M135 76 L139 76 L140 83 L140 86 L138 87 L137 92 L130 92 L128 95 L124 94 L117 91 L121 88 L123 87 L118 83 L123 80 L128 78 L135 78 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M161 83 L171 83 L171 89 L155 90 L150 92 L141 93 L141 87 L154 87 L156 88 L156 86 L161 85 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M154 93 L161 93 L161 96 L153 96 L156 100 L156 103 L133 103 L134 100 L139 99 L141 97 L141 102 L143 102 L142 97 L145 97 L147 95 L149 99 L151 98 L151 94 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M155 78 L161 78 L161 82 L154 82 L155 85 L150 85 L149 86 L141 86 L141 79 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M135 76 L139 76 L140 83 L140 86 L131 85 L129 86 L128 78 L135 78 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M163 77 L168 77 L169 82 L171 83 L161 83 L162 86 L156 86 L155 88 L155 86 L150 86 L154 84 L154 82 L161 82 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M149 90 L150 92 L152 91 L161 91 L161 93 L152 95 L151 99 L147 99 L145 96 L141 95 L141 93 L149 92 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M140 78 L155 78 L155 79 L141 79 L141 86 L149 86 L150 84 L150 86 L155 86 L154 88 L141 87 L141 94 L140 94 L140 87 L130 87 L130 86 L140 86 L139 83 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M121 88 L127 88 L129 91 L128 95 L124 94 L117 91 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M127 87 L138 87 L137 92 L127 92 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M161 83 L171 83 L171 89 L165 89 L161 85 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M129 80 L138 80 L138 84 L131 85 L129 86 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M155 78 L161 78 L161 82 L151 83 L150 80 L155 80 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M123 80 L126 80 L126 85 L122 86 L118 83 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M146 93 L151 93 L152 98 L147 99 L145 94 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M162 85 L165 88 L161 90 L157 89 L156 86 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M140 94 L145 94 L146 99 L143 100 L143 102 L141 102 L141 97 L139 97 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M146 82 L149 83 L149 86 L141 86 L141 83 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M161 83 L169 83 L169 85 L165 85 L167 86 L167 88 L164 88 L161 85 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M142 80 L149 80 L148 84 L141 83 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M164 92 L169 92 L168 96 L163 96 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M150 88 L158 88 L156 90 L150 92 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M127 87 L136 87 L136 88 L130 88 L129 92 L127 92 Z" style="fill:';
    string private constant PART_26 = ';"/>';
    string private constant COLOR_1 = 'hsl(213, 10%, 17%)';
    string private constant COLOR_2 = 'hsl(206, 12%, 11%)';
    string private constant COLOR_3 = 'hsl(240, 4%, 14%)';
    string private constant COLOR_4 = 'hsl(160, 2%, 28%)';
    string private constant COLOR_5 = 'hsl(214, 14%, 10%)';
    string private constant COLOR_6 = 'hsl(180, 2%, 24%)';
    string private constant COLOR_7 = 'hsl(195, 4%, 22%)';
    string private constant COLOR_8 = 'hsl(206, 8%, 17%)';
    string private constant COLOR_9 = 'hsl(213, 10%, 18%)';
    string private constant COLOR_10 = 'hsl(210, 18%, 7%)';
    string private constant COLOR_11 = 'hsl(4, 37%, 22%)';
    string private constant COLOR_12 = 'hsl(100, 2%, 30%)';
    string private constant COLOR_13 = 'hsl(204, 3%, 30%)';
    string private constant COLOR_14 = 'hsl(80, 2%, 32%)';
    string private constant COLOR_15 = 'hsl(75, 2%, 32%)';
    string private constant COLOR_16 = 'hsl(7, 43%, 30%)';
    string private constant COLOR_17 = 'hsl(180, 1%, 24%)';
    string private constant COLOR_18 = 'hsl(200, 5%, 24%)';
    string private constant COLOR_19 = 'hsl(210, 11%, 14%)';
    string private constant COLOR_20 = 'hsl(206, 6%, 23%)';
    string private constant COLOR_21 = 'hsl(37, 9%, 46%)';
    string private constant COLOR_22 = 'hsl(53, 4%, 38%)';
    string private constant COLOR_23 = 'hsl(213, 11%, 16%)';
    string private constant COLOR_24 = 'hsl(75, 2%, 32%)';
    string private constant COLOR_25 = 'hsl(195, 3%, 24%)';

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
