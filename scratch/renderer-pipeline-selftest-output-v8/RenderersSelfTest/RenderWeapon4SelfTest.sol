// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderWeapon4SelfTest {
    string private constant PART_1 = '<path d="M149 78 L171 78 L171 82 L169 82 L168 90 L159 93 L154 94 L156 89 L149 89 L147 87 L147 81 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M147 79 L148 81 L148 87 L149 88 L156 89 L154 94 L157 93 L157 95 L155 95 L154 98 L159 99 L159 100 L146 100 L146 96 L146 92 L144 92 L142 87 L140 89 L139 83 L142 83 L142 85 L144 84 L145 80 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M111 79 L120 79 L121 80 L132 80 L133 79 L140 79 L137 81 L135 80 L135 82 L133 82 L134 84 L139 85 L139 90 L121 90 L120 91 L105 93 L104 90 L106 90 L106 88 L109 87 L111 90 L112 87 L132 88 L132 82 L115 83 L119 82 L119 80 L112 81 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M139 66 L146 66 L153 68 L153 70 L157 70 L157 74 L147 74 L143 72 L137 71 L138 67 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M120 82 L132 82 L132 88 L120 88 L116 86 L116 83 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M104 77 L110 77 L113 80 L119 80 L119 82 L116 83 L117 87 L112 88 L111 90 L109 89 L108 87 L108 81 L106 81 L106 79 L104 79 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M157 71 L158 75 L168 76 L169 78 L148 79 L148 77 L142 77 L145 74 L144 72 L150 73 L157 74 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M139 85 L143 87 L144 92 L146 92 L148 98 L146 98 L146 100 L136 101 L139 99 L144 96 L140 97 L140 93 L141 92 L133 91 L137 89 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M141 77 L148 77 L147 80 L145 80 L144 85 L142 85 L142 83 L139 83 L139 85 L135 86 L134 86 L133 82 L135 82 L135 80 L140 80 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M140 100 L159 100 L159 103 L135 103 L135 101 Z" style="fill:';
    string private constant PART_11 = ';"/>';
    string private constant COLOR_1 = 'hsl(150, 2%, 25%)';
    string private constant COLOR_2 = 'hsl(204, 8%, 13%)';
    string private constant COLOR_3 = 'hsl(210, 15%, 13%)';
    string private constant COLOR_4 = 'hsl(200, 9%, 13%)';
    string private constant COLOR_5 = 'hsl(183, 56%, 52%)';
    string private constant COLOR_6 = 'hsl(192, 8%, 24%)';
    string private constant COLOR_7 = 'hsl(200, 4%, 16%)';
    string private constant COLOR_8 = 'hsl(210, 13%, 9%)';
    string private constant COLOR_9 = 'hsl(80, 2%, 30%)';
    string private constant COLOR_10 = 'hsl(210, 7%, 17%)';

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
        return result;
    }
}
