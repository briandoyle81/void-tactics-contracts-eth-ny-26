// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderWeapon3SelfTest {
    string private constant PART_1 = '<path d="M135 76 L139 76 L139 78 L161 78 L162 79 L163 77 L168 77 L169 82 L172 83 L172 91 L169 92 L168 96 L163 96 L162 94 L161 96 L153 96 L156 100 L156 103 L133 103 L134 100 L139 99 L140 97 L128 96 L117 91 L121 88 L123 87 L118 83 L123 80 L128 78 L135 78 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M135 76 L139 76 L140 83 L140 95 L139 97 L128 96 L117 91 L121 88 L123 87 L118 83 L123 80 L128 78 L135 78 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M161 83 L172 83 L172 91 L169 92 L168 96 L163 96 L162 94 L154 94 L152 95 L151 99 L147 99 L145 94 L141 95 L141 87 L154 87 L156 88 L156 86 L161 85 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M155 78 L161 78 L161 82 L154 82 L155 85 L150 85 L149 86 L141 86 L141 79 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M161 83 L171 83 L171 89 L158 90 L161 92 L150 92 L150 88 L156 88 L156 86 L161 85 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M135 76 L139 76 L140 83 L140 86 L127 86 L127 80 L128 78 L135 78 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M141 87 L149 87 L149 93 L151 93 L152 98 L147 99 L145 94 L141 95 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M163 77 L168 77 L169 82 L171 83 L161 83 L162 86 L156 86 L155 88 L155 86 L150 86 L154 84 L154 82 L161 82 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M138 87 L140 87 L140 95 L139 97 L128 96 L130 88 L134 91 L136 91 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M125 79 L129 79 L129 85 L127 86 L130 86 L131 83 L131 87 L123 88 L120 85 L118 83 L123 80 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M140 78 L155 78 L155 79 L141 79 L141 86 L149 86 L150 84 L150 86 L155 86 L154 88 L141 87 L141 94 L140 94 L140 87 L131 87 L131 86 L140 86 L139 83 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M127 80 L138 80 L138 84 L131 85 L127 86 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M162 83 L171 83 L171 89 L165 89 L164 84 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M127 87 L138 87 L137 90 L133 92 L131 90 L129 92 L127 92 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M154 93 L161 93 L161 96 L153 96 L155 99 L155 102 L152 102 L151 94 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M161 83 L164 84 L165 89 L159 90 L156 88 L156 86 L161 85 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M123 80 L126 80 L126 85 L122 86 L118 83 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M141 87 L149 87 L148 91 L141 90 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M142 80 L149 80 L148 84 L146 83 L142 84 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M163 77 L168 77 L166 82 L162 82 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M141 98 L143 102 L133 103 L134 100 L141 100 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M143 93 L146 94 L146 99 L143 99 L143 97 L139 97 L140 94 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M146 82 L149 83 L149 86 L141 86 L142 83 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M130 88 L134 91 L136 91 L137 89 L138 93 L131 93 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M138 80 L140 84 L140 86 L131 86 L132 84 L138 84 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M167 78 L169 78 L169 82 L171 83 L161 83 L162 80 L162 82 L166 81 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M164 92 L169 92 L168 96 L163 96 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M150 80 L158 80 L157 82 L150 83 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M155 78 L161 78 L161 82 L157 81 L155 80 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M147 94 L150 94 L151 99 L147 99 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M139 88 L140 88 L140 95 L139 97 L135 97 L136 94 L139 94 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M131 88 L137 88 L136 91 L133 92 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M129 92 L131 92 L132 94 L135 96 L128 96 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M121 88 L126 88 L126 90 L120 91 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M135 76 L139 76 L140 83 L139 79 L136 79 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M161 91 L169 91 L167 94 L167 92 L162 94 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M152 98 L155 99 L155 102 L152 102 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M161 83 L164 84 L163 88 L161 86 Z" style="fill:';
    string private constant PART_39 = ';"/><path d="M123 80 L126 80 L126 83 L122 82 Z" style="fill:';
    string private constant PART_40 = ';"/><path d="M156 86 L160 87 L158 89 L156 88 Z" style="fill:';
    string private constant PART_41 = ';"/>';
    string private constant COLOR_1 = 'hsl(216, 11%, 9%)';
    string private constant COLOR_2 = 'hsl(356, 23%, 15%)';
    string private constant COLOR_3 = 'hsl(210, 11%, 15%)';
    string private constant COLOR_4 = 'hsl(180, 2%, 24%)';
    string private constant COLOR_5 = 'hsl(120, 1%, 30%)';
    string private constant COLOR_6 = 'hsl(195, 4%, 18%)';
    string private constant COLOR_7 = 'hsl(200, 5%, 24%)';
    string private constant COLOR_8 = 'hsl(210, 9%, 17%)';
    string private constant COLOR_9 = 'hsl(207, 11%, 16%)';
    string private constant COLOR_10 = 'hsl(260, 6%, 10%)';
    string private constant COLOR_11 = 'hsl(210, 18%, 7%)';
    string private constant COLOR_12 = 'hsl(80, 2%, 32%)';
    string private constant COLOR_13 = 'hsl(37, 4%, 38%)';
    string private constant COLOR_14 = 'hsl(180, 2%, 25%)';
    string private constant COLOR_15 = 'hsl(210, 22%, 9%)';
    string private constant COLOR_16 = 'hsl(206, 6%, 25%)';
    string private constant COLOR_17 = 'hsl(4, 40%, 24%)';
    string private constant COLOR_18 = 'hsl(75, 2%, 33%)';
    string private constant COLOR_19 = 'hsl(60, 3%, 37%)';
    string private constant COLOR_20 = 'hsl(210, 3%, 25%)';
    string private constant COLOR_21 = 'hsl(210, 9%, 14%)';
    string private constant COLOR_22 = 'hsl(210, 12%, 13%)';
    string private constant COLOR_23 = 'hsl(206, 6%, 22%)';
    string private constant COLOR_24 = 'hsl(200, 5%, 22%)';
    string private constant COLOR_25 = 'hsl(213, 10%, 17%)';
    string private constant COLOR_26 = 'hsl(214, 19%, 7%)';
    string private constant COLOR_27 = 'hsl(213, 11%, 16%)';
    string private constant COLOR_28 = 'hsl(53, 5%, 36%)';
    string private constant COLOR_29 = 'hsl(180, 2%, 27%)';
    string private constant COLOR_30 = 'hsl(240, 2%, 20%)';
    string private constant COLOR_31 = 'hsl(210, 8%, 20%)';
    string private constant COLOR_32 = 'hsl(70, 3%, 34%)';
    string private constant COLOR_33 = 'hsl(213, 15%, 12%)';
    string private constant COLOR_34 = 'hsl(8, 53%, 37%)';
    string private constant COLOR_35 = 'hsl(120, 1%, 30%)';
    string private constant COLOR_36 = 'hsl(210, 26%, 7%)';
    string private constant COLOR_37 = 'hsl(0, 0%, 16%)';
    string private constant COLOR_38 = 'hsl(105, 2%, 34%)';
    string private constant COLOR_39 = 'hsl(10, 47%, 45%)';
    string private constant COLOR_40 = 'hsl(210, 8%, 20%)';

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
            PART_37,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_37) : COLOR_37,
            PART_38,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_38) : COLOR_38,
            PART_39
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_39) : COLOR_39,
            PART_40,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_40) : COLOR_40,
            PART_41
        );
        return result;
    }
}
