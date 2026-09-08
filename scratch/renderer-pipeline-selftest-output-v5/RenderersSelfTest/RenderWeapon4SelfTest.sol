// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderWeapon4SelfTest {
    string private constant PART_1 = '<path d="M139 66 L146 66 L153 68 L153 70 L158 71 L158 75 L168 76 L171 78 L171 82 L169 82 L168 90 L159 93 L157 93 L157 95 L155 95 L154 98 L159 99 L159 103 L135 103 L136 100 L143 97 L140 97 L140 93 L141 92 L133 91 L132 90 L121 90 L120 91 L105 93 L104 90 L106 90 L106 88 L108 88 L108 81 L106 81 L106 79 L104 79 L104 77 L110 77 L111 78 L120 79 L121 80 L132 80 L133 79 L140 78 L145 74 L143 72 L137 71 L138 67 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M104 77 L110 77 L111 78 L120 79 L121 80 L132 80 L133 79 L140 78 L141 77 L148 77 L147 80 L145 81 L145 88 L140 89 L139 90 L121 90 L120 91 L105 93 L104 90 L106 90 L106 88 L108 88 L108 81 L106 81 L106 79 L104 79 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M147 79 L148 81 L148 87 L154 89 L156 91 L154 94 L157 93 L157 95 L155 95 L154 98 L159 99 L159 103 L135 103 L136 100 L143 97 L140 97 L140 93 L141 92 L133 91 L133 90 L139 90 L140 87 L145 88 L144 80 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M139 66 L146 66 L153 68 L153 70 L158 71 L158 75 L168 76 L169 78 L148 79 L148 77 L142 77 L145 74 L143 72 L137 71 L138 67 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M141 77 L148 77 L147 80 L145 81 L145 88 L140 89 L139 85 L135 86 L134 86 L133 82 L133 79 L140 78 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M120 82 L132 82 L132 88 L120 88 L116 86 L116 83 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M146 88 L155 89 L155 92 L154 94 L157 93 L157 95 L155 95 L154 99 L148 98 L146 96 L146 92 L144 92 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M140 100 L159 100 L159 103 L135 103 L135 101 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M111 80 L119 80 L119 82 L116 83 L117 87 L111 88 L111 90 L109 89 L108 82 L110 81 L110 85 L115 86 L115 84 L111 84 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M148 80 L158 80 L159 81 L159 87 L155 88 L150 87 L150 85 L155 85 L155 83 L151 83 L151 81 L147 83 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M169 78 L171 78 L171 82 L169 82 L168 90 L159 91 L161 89 L165 87 L166 82 L163 81 L169 81 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M153 78 L169 78 L169 81 L163 81 L163 83 L165 83 L165 86 L162 86 L162 83 L160 83 L160 80 L153 79 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M108 87 L111 90 L111 88 L113 87 L119 87 L119 88 L114 89 L120 90 L120 91 L105 93 L104 90 L106 90 L106 88 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M152 75 L162 75 L169 77 L169 78 L153 78 L151 76 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M157 71 L158 75 L152 76 L153 78 L148 79 L148 77 L142 77 L146 75 L147 73 L155 73 L157 74 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M143 97 L151 97 L151 99 L159 99 L159 100 L136 101 L139 99 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M104 77 L110 77 L112 83 L115 84 L115 86 L110 85 L108 82 L106 81 L106 79 L104 79 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M149 81 L151 81 L151 83 L155 83 L155 85 L150 85 L150 87 L155 87 L155 88 L148 88 L147 83 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M143 90 L144 92 L146 92 L148 98 L143 96 L139 96 L141 92 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M146 88 L148 89 L147 91 L152 91 L150 96 L147 96 L146 92 L144 92 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M133 80 L139 80 L139 85 L135 86 L134 86 L133 82 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M163 82 L166 82 L166 87 L165 88 L160 88 L160 83 L162 83 L162 86 L165 86 L165 83 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M165 87 L168 87 L168 90 L159 91 L161 89 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M156 70 L157 74 L150 74 L149 72 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M142 81 L145 81 L145 86 L142 86 L142 83 L140 82 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M104 77 L110 77 L111 80 L104 79 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M140 93 L144 93 L142 97 L139 96 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M160 81 L163 81 L163 83 L165 83 L165 86 L162 86 L162 83 L160 83 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M146 88 L148 89 L147 96 L146 92 L144 92 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M142 77 L148 77 L147 80 L143 79 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M155 89 L157 89 L159 93 L154 94 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M143 71 L149 72 L150 74 L145 74 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M106 88 L108 92 L105 93 L104 90 L106 90 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M149 81 L151 81 L150 84 L148 84 L147 86 L148 82 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M139 82 L142 83 L142 86 L139 85 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M141 77 L143 78 L143 80 L140 80 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M108 87 L110 89 L107 90 Z" style="fill:';
    string private constant PART_38 = ';"/>';
    string private constant COLOR_1 = 'hsl(195, 6%, 14%)';
    string private constant COLOR_2 = 'hsl(207, 16%, 13%)';
    string private constant COLOR_3 = 'hsl(204, 11%, 9%)';
    string private constant COLOR_4 = 'hsl(210, 10%, 12%)';
    string private constant COLOR_5 = 'hsl(210, 6%, 12%)';
    string private constant COLOR_6 = 'hsl(183, 56%, 52%)';
    string private constant COLOR_7 = 'hsl(214, 13%, 11%)';
    string private constant COLOR_8 = 'hsl(195, 5%, 17%)';
    string private constant COLOR_9 = 'hsl(192, 11%, 27%)';
    string private constant COLOR_10 = 'hsl(60, 3%, 35%)';
    string private constant COLOR_11 = 'hsl(210, 6%, 13%)';
    string private constant COLOR_12 = 'hsl(47, 4%, 45%)';
    string private constant COLOR_13 = 'hsl(200, 12%, 10%)';
    string private constant COLOR_14 = 'hsl(180, 2%, 24%)';
    string private constant COLOR_15 = 'hsl(210, 13%, 9%)';
    string private constant COLOR_16 = 'hsl(204, 12%, 8%)';
    string private constant COLOR_17 = 'hsl(199, 19%, 16%)';
    string private constant COLOR_18 = 'hsl(150, 2%, 21%)';
    string private constant COLOR_19 = 'hsl(214, 18%, 8%)';
    string private constant COLOR_20 = 'hsl(204, 5%, 20%)';
    string private constant COLOR_21 = 'hsl(60, 5%, 36%)';
    string private constant COLOR_22 = 'hsl(180, 3%, 22%)';
    string private constant COLOR_23 = 'hsl(218, 11%, 14%)';
    string private constant COLOR_24 = 'hsl(214, 7%, 21%)';
    string private constant COLOR_25 = 'hsl(90, 2%, 32%)';
    string private constant COLOR_26 = 'hsl(195, 7%, 21%)';
    string private constant COLOR_27 = 'hsl(210, 9%, 13%)';
    string private constant COLOR_28 = 'hsl(72, 3%, 39%)';
    string private constant COLOR_29 = 'hsl(206, 9%, 16%)';
    string private constant COLOR_30 = 'hsl(80, 2%, 33%)';
    string private constant COLOR_31 = 'hsl(214, 10%, 14%)';
    string private constant COLOR_32 = 'hsl(214, 11%, 12%)';
    string private constant COLOR_33 = 'hsl(203, 17%, 19%)';
    string private constant COLOR_34 = 'hsl(60, 2%, 31%)';
    string private constant COLOR_35 = 'hsl(120, 1%, 21%)';
    string private constant COLOR_36 = 'hsl(60, 1%, 23%)';
    string private constant COLOR_37 = 'hsl(202, 22%, 10%)';

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
            PART_38
        );
        return result;
    }
}
