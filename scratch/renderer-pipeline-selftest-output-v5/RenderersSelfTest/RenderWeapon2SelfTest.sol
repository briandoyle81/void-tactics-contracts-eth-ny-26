// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderWeapon2SelfTest {
    string private constant PART_1 = '<path d="M149 80 L157 80 L159 81 L172 82 L173 83 L181 84 L183 86 L183 92 L182 94 L177 96 L160 98 L155 100 L155 105 L135 105 L136 101 L136 100 L124 99 L74 98 L60 97 L59 92 L127 91 L126 90 L59 89 L60 84 L73 83 L74 82 L129 81 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M149 80 L157 80 L159 81 L172 82 L173 85 L178 86 L176 91 L171 92 L160 92 L160 88 L157 87 L157 95 L151 97 L138 97 L130 98 L129 97 L113 96 L113 94 L130 93 L134 92 L131 87 L74 86 L74 82 L129 81 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M172 83 L181 84 L183 86 L183 92 L182 94 L177 96 L160 98 L155 100 L155 105 L135 105 L136 101 L136 100 L124 99 L74 98 L74 95 L113 95 L129 97 L130 95 L130 98 L141 96 L151 96 L152 95 L157 95 L157 87 L161 88 L163 90 L160 90 L160 92 L170 92 L171 88 L171 92 L175 91 L178 86 L173 86 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M132 86 L144 86 L151 89 L154 89 L155 87 L157 87 L157 95 L151 97 L138 97 L130 98 L129 97 L113 96 L113 94 L130 93 L134 92 L132 89 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M73 83 L75 84 L74 86 L131 86 L134 88 L133 92 L133 90 L129 90 L128 92 L126 90 L59 89 L60 84 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M74 82 L136 82 L136 86 L131 87 L74 86 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M73 95 L113 95 L129 97 L130 95 L130 98 L141 96 L151 97 L153 102 L137 102 L137 104 L143 104 L143 105 L135 105 L136 101 L136 100 L124 99 L74 98 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M157 81 L172 82 L173 85 L178 86 L176 91 L171 92 L160 92 L160 88 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M84 86 L131 86 L134 88 L133 92 L133 90 L129 90 L128 92 L126 90 L105 89 L105 88 L84 87 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M172 83 L181 84 L183 86 L183 92 L182 94 L177 96 L171 96 L169 94 L175 94 L171 92 L175 91 L178 86 L173 86 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M155 87 L157 87 L157 95 L151 97 L147 97 L148 95 L150 96 L149 89 L154 89 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M59 85 L73 85 L73 88 L71 89 L59 89 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M153 100 L155 102 L155 105 L143 105 L137 104 L137 102 L153 102 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M170 88 L171 88 L171 93 L177 93 L173 95 L165 97 L160 97 L159 93 L170 93 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M157 81 L172 82 L170 83 L170 86 L159 86 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M59 92 L73 94 L73 97 L60 97 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M131 92 L133 92 L133 95 L129 95 L129 97 L113 96 L113 94 L130 93 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M120 86 L131 86 L134 88 L133 92 L133 90 L129 90 L128 92 L123 88 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M73 83 L75 84 L74 86 L83 86 L82 89 L71 89 L72 86 L60 85 L60 84 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M157 87 L161 88 L163 90 L160 90 L160 92 L170 92 L170 93 L157 94 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M132 86 L144 86 L149 88 L147 90 L138 89 L138 87 L132 87 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M129 82 L136 82 L136 86 L131 87 L128 85 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M133 92 L137 93 L137 97 L130 98 L130 95 L133 95 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M149 89 L154 90 L154 92 L152 92 L151 97 L147 97 L148 95 L150 96 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M144 85 L156 85 L156 86 L150 88 L145 88 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M139 90 L147 90 L146 92 L142 93 L141 95 L138 95 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M148 89 L149 89 L150 96 L144 95 L144 93 L146 93 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M179 86 L182 87 L182 94 L179 93 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M132 87 L138 87 L138 92 L134 92 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M150 97 L153 100 L152 102 L148 100 L140 99 L140 98 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M151 86 L157 86 L155 87 L154 90 L149 89 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M60 92 L73 94 L73 95 L60 95 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M172 87 L178 87 L176 91 L172 90 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M157 87 L161 88 L163 90 L160 90 L159 92 L157 91 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M177 88 L178 88 L178 93 L171 93 L175 91 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M157 94 L160 94 L160 98 L156 98 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M161 94 L168 94 L164 97 L161 96 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M130 95 L134 96 L135 98 L130 98 Z" style="fill:';
    string private constant PART_39 = ';"/><path d="M129 90 L133 90 L133 92 L129 94 Z" style="fill:';
    string private constant PART_40 = ';"/><path d="M151 96 L155 98 L151 100 Z" style="fill:';
    string private constant PART_41 = ';"/><path d="M156 91 L157 95 L153 94 Z" style="fill:';
    string private constant PART_42 = ';"/><path d="M153 100 L155 102 L155 105 L152 104 Z" style="fill:';
    string private constant PART_43 = ';"/><path d="M131 92 L133 92 L133 95 L129 94 Z" style="fill:';
    string private constant PART_44 = ';"/><path d="M131 84 L134 85 L131 87 L128 85 Z" style="fill:';
    string private constant PART_45 = ';"/><path d="M60 92 L63 93 L63 95 L60 95 Z" style="fill:';
    string private constant PART_46 = ';"/><path d="M179 86 L182 87 L179 90 Z" style="fill:';
    string private constant PART_47 = ';"/><path d="M148 93 L150 94 L150 96 L147 95 Z" style="fill:';
    string private constant PART_48 = ';"/>';
    string private constant COLOR_1 = 'hsl(0, 0%, 32%)';
    string private constant COLOR_2 = 'hsl(30, 2%, 39%)';
    string private constant COLOR_3 = 'hsl(215, 17%, 14%)';
    string private constant COLOR_4 = 'hsl(20, 1%, 42%)';
    string private constant COLOR_5 = 'hsl(218, 13%, 17%)';
    string private constant COLOR_6 = 'hsl(23, 4%, 44%)';
    string private constant COLOR_7 = 'hsl(216, 14%, 14%)';
    string private constant COLOR_8 = 'hsl(0, 2%, 38%)';
    string private constant COLOR_9 = 'hsl(215, 15%, 15%)';
    string private constant COLOR_10 = 'hsl(220, 8%, 14%)';
    string private constant COLOR_11 = 'hsl(240, 1%, 35%)';
    string private constant COLOR_12 = 'hsl(220, 5%, 22%)';
    string private constant COLOR_13 = 'hsl(220, 4%, 29%)';
    string private constant COLOR_14 = 'hsl(223, 25%, 11%)';
    string private constant COLOR_15 = 'hsl(220, 10%, 18%)';
    string private constant COLOR_16 = 'hsl(300, 1%, 31%)';
    string private constant COLOR_17 = 'hsl(0, 1%, 39%)';
    string private constant COLOR_18 = 'hsl(217, 17%, 15%)';
    string private constant COLOR_19 = 'hsl(222, 15%, 13%)';
    string private constant COLOR_20 = 'hsl(220, 8%, 22%)';
    string private constant COLOR_21 = 'hsl(215, 15%, 16%)';
    string private constant COLOR_22 = 'hsl(20, 3%, 46%)';
    string private constant COLOR_23 = 'hsl(210, 1%, 31%)';
    string private constant COLOR_24 = 'hsl(220, 2%, 29%)';
    string private constant COLOR_25 = 'hsl(225, 3%, 31%)';
    string private constant COLOR_26 = 'hsl(220, 3%, 22%)';
    string private constant COLOR_27 = 'hsl(0, 1%, 37%)';
    string private constant COLOR_28 = 'hsl(228, 4%, 26%)';
    string private constant COLOR_29 = 'hsl(260, 2%, 34%)';
    string private constant COLOR_30 = 'hsl(215, 31%, 11%)';
    string private constant COLOR_31 = 'hsl(24, 4%, 51%)';
    string private constant COLOR_32 = 'hsl(34, 3%, 45%)';
    string private constant COLOR_33 = 'hsl(330, 1%, 35%)';
    string private constant COLOR_34 = 'hsl(214, 6%, 23%)';
    string private constant COLOR_35 = 'hsl(223, 6%, 25%)';
    string private constant COLOR_36 = 'hsl(213, 11%, 16%)';
    string private constant COLOR_37 = 'hsl(220, 9%, 19%)';
    string private constant COLOR_38 = 'hsl(225, 2%, 33%)';
    string private constant COLOR_39 = 'hsl(218, 7%, 21%)';
    string private constant COLOR_40 = 'hsl(213, 11%, 20%)';
    string private constant COLOR_41 = 'hsl(225, 3%, 31%)';
    string private constant COLOR_42 = 'hsl(220, 2%, 24%)';
    string private constant COLOR_43 = 'hsl(15, 2%, 39%)';
    string private constant COLOR_44 = 'hsl(33, 4%, 48%)';
    string private constant COLOR_45 = 'hsl(240, 1%, 35%)';
    string private constant COLOR_46 = 'hsl(24, 2%, 43%)';
    string private constant COLOR_47 = 'hsl(240, 1%, 36%)';

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
            PART_41,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_41) : COLOR_41,
            PART_42,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_42) : COLOR_42
        );
        result = string.concat(
            result,
            PART_43,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_43) : COLOR_43,
            PART_44,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_44) : COLOR_44,
            PART_45,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_45) : COLOR_45,
            PART_46
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_46) : COLOR_46,
            PART_47,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_47) : COLOR_47,
            PART_48
        );
        return result;
    }
}
