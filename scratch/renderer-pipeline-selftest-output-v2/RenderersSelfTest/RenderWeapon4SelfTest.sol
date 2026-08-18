// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderWeapon4SelfTest {
    string private constant PART_1 = '<path d="M139 66 L146 66 L153 68 L153 70 L158 71 L158 75 L168 76 L171 78 L171 82 L169 82 L168 90 L159 93 L157 93 L157 95 L155 95 L154 98 L159 99 L159 103 L135 103 L136 100 L143 97 L140 97 L140 93 L141 92 L133 91 L132 90 L121 90 L120 91 L105 93 L104 90 L106 90 L106 88 L108 88 L108 81 L106 81 L106 79 L104 79 L104 77 L110 77 L111 78 L120 79 L121 80 L132 80 L133 79 L140 78 L145 74 L143 72 L137 71 L138 67 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M169 78 L171 78 L171 82 L169 82 L168 90 L159 93 L157 93 L157 95 L155 95 L154 98 L159 99 L159 103 L135 103 L136 100 L143 97 L140 97 L140 93 L141 92 L133 91 L133 90 L139 90 L139 85 L145 86 L145 81 L143 81 L144 79 L148 79 L148 87 L156 87 L157 82 L160 81 L160 83 L162 83 L162 86 L165 86 L165 83 L163 83 L163 81 L169 81 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M104 77 L110 77 L111 78 L120 79 L121 80 L133 80 L135 82 L133 82 L134 84 L139 86 L139 90 L121 90 L120 91 L105 93 L104 90 L106 90 L106 88 L108 88 L108 81 L106 81 L106 79 L104 79 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M141 77 L148 77 L147 80 L143 81 L145 81 L145 86 L135 86 L134 86 L133 82 L133 79 L140 78 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M120 82 L132 82 L132 88 L120 88 L116 86 L116 83 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M148 80 L158 80 L159 81 L159 87 L156 88 L148 88 L147 87 L147 81 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M104 77 L110 77 L113 80 L119 80 L119 82 L116 83 L117 87 L111 88 L112 86 L115 86 L115 84 L110 84 L110 86 L108 86 L108 81 L106 81 L106 79 L104 79 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M158 99 L159 103 L135 103 L135 101 L140 100 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M153 78 L169 78 L169 81 L163 81 L163 83 L165 83 L165 86 L162 86 L162 83 L160 83 L160 80 L153 79 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M146 88 L148 89 L147 91 L152 91 L153 95 L150 98 L146 96 L146 92 L144 91 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M169 78 L171 78 L171 82 L169 82 L169 86 L165 88 L160 88 L160 83 L162 83 L162 86 L165 86 L165 83 L163 83 L163 81 L169 81 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M152 75 L162 75 L169 77 L169 78 L153 78 L151 76 Z M153 76 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M149 81 L151 81 L151 83 L155 83 L155 85 L150 85 L151 88 L147 87 L148 82 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M133 80 L139 80 L139 86 L135 85 L134 86 L133 82 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M104 77 L110 77 L111 78 L111 83 L106 81 L106 79 L104 79 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M146 88 L148 89 L147 91 L152 91 L147 96 L146 92 L144 91 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M110 84 L115 84 L115 86 L112 87 L110 91 L108 87 L110 86 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M156 70 L157 74 L150 74 L149 72 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M142 81 L145 81 L145 86 L142 86 L142 83 L140 82 Z" style="fill:';
    string private constant PART_20 = ';"/>';
    string private constant COLOR_1 = 'hsl(216, 8%, 12%)';
    string private constant COLOR_2 = 'hsl(200, 12%, 10%)';
    string private constant COLOR_3 = 'hsl(207, 17%, 13%)';
    string private constant COLOR_4 = 'hsl(120, 1%, 22%)';
    string private constant COLOR_5 = 'hsl(183, 56%, 52%)';
    string private constant COLOR_6 = 'hsl(60, 3%, 35%)';
    string private constant COLOR_7 = 'hsl(193, 10%, 28%)';
    string private constant COLOR_8 = 'hsl(200, 3%, 17%)';
    string private constant COLOR_9 = 'hsl(60, 3%, 43%)';
    string private constant COLOR_10 = 'hsl(210, 12%, 13%)';
    string private constant COLOR_11 = 'hsl(195, 4%, 18%)';
    string private constant COLOR_12 = 'hsl(180, 2%, 24%)';
    string private constant COLOR_13 = 'hsl(90, 2%, 24%)';
    string private constant COLOR_14 = 'hsl(60, 5%, 35%)';
    string private constant COLOR_15 = 'hsl(202, 11%, 19%)';
    string private constant COLOR_16 = 'hsl(210, 6%, 19%)';
    string private constant COLOR_17 = 'hsl(192, 15%, 19%)';
    string private constant COLOR_18 = 'hsl(214, 7%, 21%)';
    string private constant COLOR_19 = 'hsl(90, 2%, 32%)';

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
            PART_20
        );
        return result;
    }
}
