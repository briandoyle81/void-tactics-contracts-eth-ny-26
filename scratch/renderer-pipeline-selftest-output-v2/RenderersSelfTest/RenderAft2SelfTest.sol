// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderAft2SelfTest {
    string private constant PART_1 = '<path d="M201 67 L202 67 L202 88 L211 88 L212 89 L212 96 L219 96 L220 95 L228 95 L229 91 L229 95 L236 96 L236 99 L240 101 L240 105 L249 105 L253 109 L253 133 L248 138 L239 139 L236 143 L243 143 L247 147 L247 161 L246 163 L244 163 L244 165 L235 166 L248 169 L249 171 L249 188 L246 191 L238 192 L236 193 L230 193 L231 194 L231 202 L230 204 L221 205 L219 207 L189 207 L184 205 L178 205 L176 201 L171 199 L171 197 L169 197 L169 195 L165 194 L160 189 L160 187 L156 187 L156 193 L154 195 L146 198 L132 198 L131 197 L108 197 L107 196 L107 185 L108 184 L114 184 L113 182 L104 181 L102 179 L102 169 L104 167 L115 166 L121 161 L127 160 L163 159 L165 156 L166 145 L175 136 L176 116 L168 116 L168 104 L169 102 L181 102 L182 97 L187 95 L188 88 L196 88 L196 83 L197 83 L197 88 L201 88 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M201 67 L202 67 L202 88 L211 88 L212 89 L212 96 L219 96 L220 95 L228 95 L229 91 L229 95 L234 95 L234 98 L233 104 L226 103 L225 105 L224 110 L220 109 L220 111 L223 112 L218 112 L218 114 L198 114 L195 114 L191 116 L190 124 L184 126 L183 115 L178 116 L177 128 L176 128 L176 116 L168 116 L168 104 L169 102 L181 102 L182 97 L187 95 L188 88 L196 88 L196 83 L197 83 L197 88 L201 88 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M218 98 L232 98 L231 103 L226 103 L225 105 L224 110 L220 109 L220 111 L223 112 L218 112 L218 114 L198 114 L195 114 L191 116 L190 124 L185 125 L185 113 L191 107 L212 106 L212 100 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M201 67 L202 67 L202 88 L211 88 L212 89 L211 96 L206 97 L204 100 L203 105 L194 104 L188 100 L188 102 L190 102 L190 104 L185 105 L185 99 L190 97 L188 94 L188 88 L196 88 L196 83 L197 83 L197 88 L201 88 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M242 143 L247 147 L247 161 L246 163 L244 163 L244 165 L235 165 L235 146 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M218 98 L232 98 L231 103 L226 103 L225 105 L224 110 L220 109 L207 109 L201 108 L201 107 L212 106 L212 100 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M189 94 L196 94 L195 96 L203 97 L203 94 L207 94 L206 98 L204 100 L203 105 L194 104 L188 100 L188 102 L190 102 L190 104 L185 105 L185 99 L190 97 Z" style="fill:';
    string private constant PART_8 = ';"/>';
    string private constant COLOR_1 = 'hsl(214, 9%, 16%)';
    string private constant COLOR_2 = 'hsl(214, 10%, 14%)';
    string private constant COLOR_3 = 'hsl(60, 2%, 34%)';
    string private constant COLOR_4 = 'hsl(204, 5%, 19%)';
    string private constant COLOR_5 = 'hsl(20, 33%, 26%)';
    string private constant COLOR_6 = 'hsl(30, 4%, 29%)';
    string private constant COLOR_7 = 'hsl(26, 24%, 33%)';

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
            PART_8
        );
        return result;
    }
}
