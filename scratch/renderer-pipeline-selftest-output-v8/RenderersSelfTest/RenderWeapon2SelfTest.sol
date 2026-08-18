// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderWeapon2SelfTest {
    string private constant PART_1 = '<path d="M157 93 L160 94 L160 98 L155 100 L155 105 L135 105 L136 101 L136 100 L124 99 L74 98 L74 97 L129 97 L130 95 L130 98 L141 96 L151 96 L152 95 L157 95 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M59 92 L127 92 L127 93 L112 94 L112 96 L74 96 L73 97 L60 97 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M74 82 L150 82 L150 84 L156 85 L156 86 L150 88 L145 88 L144 87 L131 87 L117 85 L113 84 L99 84 L95 85 L74 85 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M132 86 L144 86 L149 88 L147 90 L138 90 L138 92 L131 93 L130 94 L113 94 L113 96 L124 96 L124 97 L73 97 L74 95 L100 95 L112 96 L112 94 L109 93 L129 92 L130 87 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M163 82 L172 82 L173 83 L181 84 L183 86 L183 92 L182 92 L181 87 L174 86 L171 86 L171 93 L181 93 L177 96 L160 97 L159 93 L170 93 L170 86 L168 86 L168 83 L163 83 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M138 89 L151 89 L150 96 L141 97 L137 97 L137 93 L130 94 L131 92 L136 91 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M154 82 L158 82 L159 86 L170 86 L170 92 L160 92 L160 88 L155 87 L154 91 L149 89 L151 86 L148 84 L154 84 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M99 83 L127 83 L127 86 L74 86 L74 85 L95 84 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M83 86 L115 87 L115 89 L73 89 L74 87 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M84 86 L131 86 L131 89 L129 90 L128 92 L126 90 L115 89 L115 87 L84 87 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M73 83 L75 84 L74 86 L83 86 L83 87 L74 88 L73 89 L59 89 L60 84 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M174 85 L181 86 L182 87 L182 94 L171 93 L171 86 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M155 87 L160 87 L163 90 L160 90 L160 92 L170 92 L170 93 L157 93 L157 95 L151 97 L147 97 L148 95 L150 96 L149 92 L150 90 L154 90 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M149 80 L157 80 L168 83 L168 86 L159 86 L158 82 L154 82 L154 84 L150 84 L150 82 L129 82 L129 81 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M132 93 L137 93 L137 97 L130 98 L129 97 L113 96 L113 94 Z" style="fill:';
    string private constant PART_16 = ';"/>';
    string private constant COLOR_1 = 'hsl(220, 11%, 15%)';
    string private constant COLOR_2 = 'hsl(300, 1%, 33%)';
    string private constant COLOR_3 = 'hsl(15, 2%, 41%)';
    string private constant COLOR_4 = 'hsl(218, 7%, 22%)';
    string private constant COLOR_5 = 'hsl(216, 15%, 13%)';
    string private constant COLOR_6 = 'hsl(0, 1%, 36%)';
    string private constant COLOR_7 = 'hsl(26, 3%, 45%)';
    string private constant COLOR_8 = 'hsl(24, 4%, 50%)';
    string private constant COLOR_9 = 'hsl(218, 13%, 17%)';
    string private constant COLOR_10 = 'hsl(215, 16%, 15%)';
    string private constant COLOR_11 = 'hsl(220, 9%, 19%)';
    string private constant COLOR_12 = 'hsl(300, 1%, 32%)';
    string private constant COLOR_13 = 'hsl(216, 4%, 28%)';
    string private constant COLOR_14 = 'hsl(228, 4%, 23%)';
    string private constant COLOR_15 = 'hsl(300, 1%, 35%)';

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
            PART_16
        );
        return result;
    }
}
