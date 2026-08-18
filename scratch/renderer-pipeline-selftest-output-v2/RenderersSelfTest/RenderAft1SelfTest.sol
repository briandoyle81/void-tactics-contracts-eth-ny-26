// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderAft1SelfTest {
    string private constant PART_1 = '<path d="M181 96 L186 96 L187 99 L190 100 L191 96 L200 96 L202 98 L202 101 L205 101 L206 97 L211 97 L213 100 L213 104 L216 104 L216 102 L229 102 L234 109 L234 113 L244 113 L251 116 L253 122 L253 130 L250 133 L245 133 L245 136 L250 136 L253 139 L253 148 L250 153 L245 153 L245 156 L250 156 L252 158 L252 171 L249 173 L243 175 L232 175 L225 177 L209 178 L207 180 L201 180 L199 180 L193 180 L190 178 L190 180 L184 180 L180 180 L174 180 L170 177 L165 174 L161 169 L161 167 L154 167 L154 156 L160 149 L160 142 L159 141 L159 130 L162 127 L164 127 L164 118 L169 118 L169 106 L171 106 L171 102 L176 102 L176 100 L179 98 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M181 96 L186 96 L187 99 L190 100 L191 96 L200 96 L202 98 L202 101 L205 101 L206 97 L211 97 L213 100 L212 105 L201 106 L201 107 L180 108 L174 107 L172 105 L172 116 L174 113 L179 114 L175 119 L173 120 L172 133 L171 133 L171 127 L168 127 L169 124 L168 124 L167 139 L166 139 L165 130 L161 128 L164 127 L164 118 L169 118 L169 106 L171 106 L171 102 L176 102 L176 100 L179 98 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M182 115 L202 115 L201 119 L200 120 L194 120 L196 127 L192 126 L192 120 L183 121 L179 125 L179 130 L181 130 L181 128 L185 125 L191 125 L192 132 L191 134 L187 135 L187 143 L188 147 L181 148 L174 140 L174 122 L177 119 L179 119 L180 116 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M217 103 L230 103 L234 109 L234 113 L244 113 L250 115 L250 116 L245 116 L245 131 L244 131 L243 126 L241 127 L241 116 L239 116 L239 128 L235 129 L237 117 L234 119 L233 134 L232 134 L232 115 L219 115 L220 113 L230 113 L229 108 L225 106 L216 105 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M181 105 L211 105 L212 107 L212 113 L181 113 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M172 105 L180 105 L181 113 L190 113 L191 109 L191 113 L201 113 L201 108 L202 108 L202 113 L210 113 L210 114 L182 115 L177 120 L175 122 L175 136 L173 136 L172 139 L172 120 L175 119 L176 116 L178 115 L174 115 L172 117 L171 116 L171 107 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M189 155 L205 156 L205 158 L200 158 L201 168 L200 171 L189 171 L188 169 L188 156 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M245 116 L251 116 L253 122 L253 130 L250 132 L250 129 L247 132 L245 132 Z" style="fill:';
    string private constant PART_9 = ';"/>';
    string private constant COLOR_1 = 'hsl(240, 2%, 23%)';
    string private constant COLOR_2 = 'hsl(216, 7%, 15%)';
    string private constant COLOR_3 = 'hsl(37, 6%, 41%)';
    string private constant COLOR_4 = 'hsl(214, 11%, 12%)';
    string private constant COLOR_5 = 'hsl(22, 29%, 46%)';
    string private constant COLOR_6 = 'hsl(19, 14%, 32%)';
    string private constant COLOR_7 = 'hsl(0, 1%, 32%)';
    string private constant COLOR_8 = 'hsl(19, 23%, 34%)';

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
            PART_9
        );
        return result;
    }
}
