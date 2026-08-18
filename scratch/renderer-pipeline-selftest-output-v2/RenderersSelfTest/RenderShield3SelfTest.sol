// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderShield3SelfTest {
    string private constant PART_1 = '<path d="M128 99 L164 99 L167 102 L167 104 L176 103 L177 116 L181 119 L181 155 L178 156 L176 160 L165 171 L162 172 L131 172 L128 171 L122 164 L117 159 L113 156 L110 159 L97 159 L92 154 L84 153 L81 150 L81 113 L82 112 L88 112 L88 109 L102 109 L105 109 L109 105 L118 104 L120 102 L127 101 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M145 108 L154 108 L157 111 L161 112 L163 116 L167 117 L169 121 L164 124 L169 125 L170 129 L168 131 L164 130 L165 133 L169 134 L170 138 L168 140 L164 140 L162 145 L157 144 L156 148 L155 150 L145 153 L144 148 L143 150 L139 150 L138 150 L137 153 L131 151 L131 148 L128 148 L126 142 L127 140 L125 140 L124 137 L125 133 L130 133 L130 130 L125 131 L124 126 L125 124 L130 124 L132 119 L137 118 L139 115 L143 115 L144 116 L145 111 L149 111 L145 110 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M111 117 L120 117 L119 122 L117 125 L116 141 L108 141 L109 142 L116 142 L119 145 L121 151 L85 152 L84 151 L84 144 L100 144 L86 143 L86 124 L88 125 L88 142 L104 142 L104 134 L95 135 L94 130 L95 128 L101 127 L100 126 L92 124 L93 122 L107 122 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M132 119 L137 120 L139 123 L143 124 L144 130 L145 128 L149 128 L151 133 L149 136 L145 137 L150 138 L152 142 L156 142 L157 147 L155 150 L145 153 L144 148 L143 150 L139 150 L138 150 L137 153 L131 151 L131 148 L128 148 L126 142 L127 140 L125 140 L124 137 L125 133 L130 133 L130 130 L125 131 L124 126 L125 124 L130 124 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M86 124 L88 125 L88 142 L105 141 L108 143 L109 142 L116 142 L119 145 L121 151 L85 152 L84 151 L84 144 L100 144 L86 143 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M145 128 L149 128 L151 133 L149 136 L145 137 L150 138 L152 142 L156 142 L157 147 L155 150 L145 153 L144 148 L143 150 L139 150 L137 145 L139 141 L137 138 L138 134 L143 133 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M159 128 L163 129 L165 133 L169 134 L170 138 L168 140 L164 140 L162 145 L157 144 L157 142 L151 143 L149 138 L144 138 L145 135 L151 134 L156 133 L158 129 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M164 140 L168 141 L167 152 L162 156 L156 159 L150 158 L149 154 L146 154 L146 152 L151 150 L155 150 L156 142 L158 144 L162 145 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M121 158 L128 164 L130 166 L164 167 L166 163 L171 159 L173 159 L171 163 L167 167 L165 167 L164 170 L130 170 L120 163 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M145 111 L149 112 L151 115 L155 115 L157 119 L155 122 L151 121 L151 124 L149 127 L145 127 L143 123 L138 121 L137 118 L139 115 L143 115 L144 116 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M132 119 L137 120 L139 123 L143 124 L144 129 L143 133 L137 135 L136 128 L129 131 L125 131 L124 126 L125 124 L130 124 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M122 128 L124 130 L129 130 L131 129 L131 134 L125 133 L125 140 L127 140 L128 148 L131 148 L131 151 L137 152 L137 147 L139 148 L139 150 L143 150 L144 147 L145 149 L145 156 L141 157 L132 154 L132 156 L128 154 L125 151 L126 149 L128 150 L122 139 L121 137 L121 129 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M137 108 L143 108 L144 109 L145 118 L143 117 L143 115 L139 116 L136 120 L132 119 L130 124 L126 123 L125 119 L130 114 L134 112 L135 109 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M85 116 L98 116 L97 120 L86 122 L85 144 L84 150 L82 149 L82 118 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M145 108 L154 108 L157 111 L161 112 L163 116 L167 117 L169 121 L165 123 L163 123 L161 120 L156 121 L155 115 L150 116 L149 111 L145 110 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M145 128 L149 128 L151 133 L149 136 L145 137 L150 138 L151 143 L149 145 L145 145 L143 140 L138 140 L137 135 L139 133 L143 133 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M93 122 L105 122 L105 134 L100 134 L95 135 L94 130 L95 128 L101 127 L100 126 L92 124 Z" style="fill:';
    string private constant PART_18 = ';"/>';
    string private constant COLOR_1 = 'hsl(210, 24%, 11%)';
    string private constant COLOR_2 = 'hsl(200, 86%, 28%)';
    string private constant COLOR_3 = 'hsl(180, 3%, 22%)';
    string private constant COLOR_4 = 'hsl(193, 84%, 37%)';
    string private constant COLOR_5 = 'hsl(100, 2%, 30%)';
    string private constant COLOR_6 = 'hsl(189, 70%, 45%)';
    string private constant COLOR_7 = 'hsl(194, 84%, 37%)';
    string private constant COLOR_8 = 'hsl(205, 88%, 20%)';
    string private constant COLOR_9 = 'hsl(90, 3%, 31%)';
    string private constant COLOR_10 = 'hsl(199, 86%, 34%)';
    string private constant COLOR_11 = 'hsl(197, 86%, 34%)';
    string private constant COLOR_12 = 'hsl(206, 79%, 20%)';
    string private constant COLOR_13 = 'hsl(208, 91%, 18%)';
    string private constant COLOR_14 = 'hsl(206, 7%, 21%)';
    string private constant COLOR_15 = 'hsl(208, 88%, 19%)';
    string private constant COLOR_16 = 'hsl(185, 72%, 51%)';
    string private constant COLOR_17 = 'hsl(199, 38%, 21%)';

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
