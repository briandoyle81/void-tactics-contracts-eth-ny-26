// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderWeapon3SelfTest {
    string private constant PART_1 = '<path d="M140 78 L154 78 L154 79 L140 80 Z M144 102 L148 103 Z M171 85 Z M145 99 L147 100 Z M153 98 Z M154 99 Z M146 95 Z M145 96 Z M140 88 Z M123 85 Z M124 86 Z M152 102 Z M142 102 Z M140 102 Z M155 101 Z M151 100 Z M134 100 Z M142 98 Z M140 97 Z M126 94 Z M162 93 Z M124 93 Z M126 92 Z M122 92 Z M119 91 Z M126 90 Z M121 88 Z M126 85 Z M120 84 Z M139 83 Z M170 82 Z M165 82 Z M162 82 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M134 102 L140 102 L140 103 L134 103 Z M151 101 L152 103 L148 102 Z M154 93 L159 93 L159 94 L154 94 Z M168 78 L169 82 Z M169 82 Z M126 86 L127 90 Z M153 102 L156 103 Z M146 86 L149 87 Z M135 86 L138 87 Z M131 86 L134 87 Z M140 82 Z M126 82 Z M140 98 Z M139 99 Z M140 92 Z M126 93 Z M125 94 Z M171 88 Z M154 86 Z M171 83 Z M163 82 L165 83 Z M137 79 L139 80 Z M143 102 Z M141 102 Z M155 100 Z M137 100 Z M149 99 Z M147 99 Z M144 99 Z M152 96 Z M150 96 Z M146 96 Z M168 94 Z M145 93 Z M121 92 Z M165 91 Z M163 91 Z M126 91 Z M119 89 Z M122 88 Z M124 87 Z M144 86 Z M140 86 Z M128 86 Z M119 82 Z M126 79 Z M154 78 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M140 94 L144 95 L143 97 L139 95 Z M144 94 Z M141 97 L143 98 Z M128 93 Z M127 94 Z M135 94 Z M128 95 L135 95 L135 96 L128 96 Z M151 94 L155 94 L155 96 L151 95 Z M156 95 L161 95 L161 96 L156 96 Z M166 91 L169 92 L167 94 Z M161 91 L163 92 L161 93 Z M159 93 L161 94 Z M167 80 Z M166 81 L169 83 L166 83 Z M140 85 Z M138 86 L140 87 Z M140 87 Z M140 99 Z M144 98 Z M142 99 L144 100 Z M149 85 L151 87 L149 87 Z M133 101 Z M135 100 L137 101 Z M150 99 L152 100 Z M146 97 Z M140 90 Z M142 86 L144 87 Z M128 85 Z M127 86 Z M162 79 Z M161 80 Z M135 79 L137 80 Z M127 79 L129 80 Z M143 101 Z M138 100 Z M148 99 Z M138 93 Z M130 93 Z M149 92 Z M164 91 Z M171 90 Z M118 90 Z M153 86 Z M145 86 Z M134 86 Z M130 86 Z M160 85 Z M121 84 Z M161 82 Z M167 78 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M130 83 Z M129 86 Z M155 90 L158 91 Z M138 83 Z M129 79 L132 80 Z M125 79 Z M126 80 Z M152 97 Z M151 98 Z M153 93 Z M128 91 Z M124 92 Z M125 93 Z M151 86 L153 87 Z M124 85 Z M125 86 Z M128 83 Z M143 100 Z M139 100 Z M153 99 Z M141 99 Z M148 97 Z M142 96 Z M140 96 Z M155 95 Z M149 95 Z M144 95 Z M164 94 Z M157 94 Z M151 93 Z M165 92 Z M162 92 Z M130 92 Z M149 91 Z M161 90 Z M159 90 Z M138 90 Z M170 89 Z M128 89 Z M141 86 Z M161 85 Z M158 85 Z M154 85 Z M149 84 Z M154 83 Z M167 81 Z M161 81 Z M140 80 Z M123 80 Z M167 79 Z M134 79 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M155 84 L158 86 L156 86 L155 88 Z M161 89 L164 89 L163 91 Z M160 90 Z M137 94 L139 95 L136 95 Z M166 89 L168 89 L167 91 Z M165 90 Z M158 94 L161 95 Z M128 80 Z M165 94 L167 95 Z M155 94 L157 95 Z M143 93 L145 94 Z M127 92 Z M163 92 L165 93 Z M138 91 Z M128 87 Z M160 84 Z M159 85 Z M132 79 L134 80 Z M146 101 Z M134 101 Z M152 99 Z M141 96 Z M139 96 Z M163 94 Z M141 94 Z M130 94 Z M152 93 Z M168 92 Z M166 92 Z M170 90 Z M158 90 Z M154 90 Z M149 90 Z M128 90 Z M138 87 Z M125 87 Z M123 87 Z M153 85 Z M135 85 Z M138 82 Z M140 81 Z M121 81 Z M138 80 Z M155 79 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M131 93 L138 93 L136 95 L131 95 Z M135 95 Z M150 92 L157 92 L157 93 L150 93 Z M163 93 L167 94 Z M167 94 Z M166 95 Z M168 89 L170 89 L171 92 L168 91 Z M143 85 L149 85 L149 86 L143 86 Z M149 100 L151 100 L151 102 L148 101 Z M147 98 L151 99 Z M164 89 L166 90 L164 91 Z M166 90 Z M131 85 L135 86 Z M147 94 L150 95 Z M142 93 L144 95 L142 95 Z M139 93 Z M138 95 Z M158 92 L161 93 Z M150 85 L153 86 Z M158 82 L161 83 Z M162 81 L165 82 Z M145 97 Z M129 93 Z M147 92 L149 93 Z M138 88 Z M136 85 L138 86 Z M155 82 L157 83 Z M152 101 Z M139 101 Z M135 101 Z M141 98 Z M145 92 Z M130 91 Z M127 91 Z M162 90 Z M158 89 Z M158 87 Z M156 87 Z M149 87 Z M141 85 Z M127 85 Z M122 85 Z M156 84 Z M149 83 Z M141 83 Z M138 81 Z M160 79 Z M135 78 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M130 89 Z M136 89 Z M137 90 L138 93 L131 93 L132 91 L137 92 Z M144 100 L149 100 L147 102 L144 102 Z M143 91 L145 93 L141 94 L141 92 Z M132 84 L138 84 L138 85 L132 85 Z M157 82 L158 84 L160 85 L156 84 Z M152 100 L155 100 L155 102 L152 101 Z M162 80 L166 80 L165 82 Z M141 79 L146 79 L146 80 L141 80 Z M141 100 L143 100 L143 102 L141 102 Z M150 87 L154 88 Z M156 79 L160 80 Z M163 95 L166 96 Z M159 87 Z M160 88 Z M156 86 L158 86 L157 88 Z M152 84 L154 85 Z M143 84 Z M142 85 Z M152 79 L154 80 Z M149 79 L151 80 Z M139 78 Z M136 101 Z M144 97 Z M136 96 Z M167 95 Z M128 94 Z M168 93 Z M157 92 Z M146 92 Z M139 92 Z M129 92 Z M152 91 Z M148 90 Z M127 90 Z M157 89 Z M155 89 Z M144 89 Z M130 87 Z M162 85 Z M139 85 Z M150 84 Z M146 84 Z M130 82 Z M147 79 Z M135 77 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M122 84 L126 84 L125 86 Z M120 89 Z M119 90 Z M120 91 L122 92 Z M120 82 L121 84 L119 83 Z M125 91 Z M123 91 Z M145 101 Z M127 83 Z M149 82 Z M124 80 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M158 86 L164 87 L165 89 L160 88 Z M143 90 Z M141 91 L143 92 Z M146 90 L149 92 L144 92 Z M129 87 Z M131 87 L138 87 L138 88 L131 88 Z M130 88 Z M143 87 L149 87 L149 88 L143 88 Z M151 96 L152 98 L149 97 Z M152 98 Z M146 93 L150 94 Z M144 96 Z M143 97 Z M134 91 L137 92 Z M158 83 L161 84 Z M151 83 L153 84 L151 85 Z M144 83 L146 83 L145 85 Z M131 83 L133 84 L131 85 Z M163 78 L166 79 Z M137 101 L139 102 Z M147 95 Z M137 96 L139 97 Z M157 91 L159 92 Z M139 90 Z M129 90 Z M131 90 Z M132 91 Z M169 86 L171 87 Z M170 83 Z M147 84 L149 85 Z M141 84 L143 85 Z M159 81 L161 82 Z M135 96 Z M155 91 Z M153 91 Z M150 91 Z M156 89 Z M149 89 Z M169 88 Z M167 88 Z M158 88 Z M141 87 Z M139 87 Z M127 87 Z M129 85 Z M136 83 Z M134 83 Z M118 83 Z M154 82 Z M129 82 Z M149 81 Z M120 81 Z M166 80 Z M141 80 Z M130 80 Z M154 79 Z M151 79 Z M148 79 Z M146 79 Z M160 78 Z M138 78 Z M131 78 Z M128 78 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M155 88 L157 89 Z M151 89 L155 90 L151 92 Z M166 85 L170 87 L168 89 Z M169 85 Z M170 88 Z M135 88 Z M132 89 L137 90 L133 92 Z M150 93 L152 96 L150 96 Z M148 96 L150 97 Z M147 97 Z M141 89 L143 91 L141 91 Z M143 89 Z M145 89 L146 91 L144 90 Z M135 76 L139 77 L138 79 L136 79 Z M166 77 L167 80 L163 79 L166 79 Z M162 86 L164 87 L162 88 Z M142 83 L144 84 Z M144 84 Z M158 80 L159 82 L157 81 Z M136 80 L138 80 L137 82 Z M146 94 Z M145 95 Z M159 91 L161 92 Z M159 88 Z M129 83 Z M146 82 Z M135 82 Z M133 78 L135 79 Z M156 91 Z M147 90 Z M139 89 Z M149 88 Z M137 88 Z M142 87 Z M139 84 Z M127 84 Z M155 83 Z M153 83 Z M150 83 Z M148 83 Z M137 83 Z M133 83 Z M155 81 Z M130 81 Z M160 80 Z M149 80 Z M134 80 Z M159 78 Z M155 78 Z M129 78 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M122 89 L126 91 L122 92 L120 90 Z M122 81 Z M121 82 L126 83 L126 84 L121 84 Z M148 95 Z M127 89 Z M124 88 Z M125 80 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M143 80 L149 80 L149 83 L141 83 L142 81 Z M132 80 L138 82 L135 83 L131 83 Z M150 80 L155 80 L154 83 L150 83 Z M132 88 Z M134 88 Z M136 88 Z M131 89 Z M133 89 Z M135 89 Z M137 89 Z M165 85 Z M164 87 Z M166 87 L167 89 L165 88 Z M146 89 L149 90 Z M150 88 L152 89 L150 90 Z M169 84 Z M168 85 Z M170 85 Z M139 80 Z M156 80 L158 81 L156 82 Z M156 78 L159 79 Z M163 77 L166 78 Z M129 88 Z M143 88 Z M142 89 Z M127 81 Z M137 77 L139 78 Z M154 91 Z M117 90 Z M157 88 Z M153 88 Z M161 86 Z M163 85 Z M161 84 Z M132 78 Z M130 78 Z M167 77 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M161 83 L170 83 L169 85 L165 85 L164 87 L164 85 L161 84 Z M144 88 L149 88 L149 89 L144 89 Z M141 88 L143 89 Z M142 80 Z M129 80 Z M145 94 Z M154 88 Z M152 88 Z M139 88 Z M133 88 Z M131 88 Z M127 88 Z M170 87 Z M154 84 Z M147 83 Z M159 80 Z M155 80 Z M151 80 Z M146 80 Z M135 80 Z M133 80 Z M131 80 Z M127 80 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M123 81 L126 81 L126 83 L122 82 Z M123 88 L126 88 L126 90 L123 90 Z M166 86 Z M165 87 Z M121 89 Z" style="fill:';
    string private constant PART_15 = ';"/>';
    string private constant COLOR_1 = 'hsl(216, 22%, 5%)';
    string private constant COLOR_2 = 'hsl(216, 15%, 6%)';
    string private constant COLOR_3 = 'hsl(218, 19%, 8%)';
    string private constant COLOR_4 = 'hsl(214, 13%, 11%)';
    string private constant COLOR_5 = 'hsl(214, 10%, 14%)';
    string private constant COLOR_6 = 'hsl(207, 10%, 17%)';
    string private constant COLOR_7 = 'hsl(210, 6%, 21%)';
    string private constant COLOR_8 = 'hsl(5, 41%, 25%)';
    string private constant COLOR_9 = 'hsl(204, 4%, 25%)';
    string private constant COLOR_10 = 'hsl(160, 2%, 29%)';
    string private constant COLOR_11 = 'hsl(8, 52%, 35%)';
    string private constant COLOR_12 = 'hsl(60, 3%, 36%)';
    string private constant COLOR_13 = 'hsl(54, 4%, 47%)';
    string private constant COLOR_14 = 'hsl(11, 50%, 51%)';

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
            PART_15
        );
        return result;
    }
}
