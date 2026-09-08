// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderAft0SelfTest {
    string private constant PART_1 = '<path d="M188 96 L193 97 L193 100 L196 100 L197 96 L205 96 L205 100 L208 100 L209 103 L227 102 L231 105 L232 110 L242 110 L242 112 L247 113 L248 124 L249 128 L248 129 L247 137 L245 137 L245 139 L242 139 L242 141 L234 142 L230 143 L230 145 L226 145 L226 147 L230 148 L234 147 L235 150 L235 158 L234 165 L224 168 L215 169 L214 171 L207 173 L202 172 L197 173 L197 171 L194 173 L189 172 L184 173 L184 171 L176 171 L171 168 L171 166 L169 166 L169 151 L174 146 L174 112 L166 112 L166 107 L178 107 L178 104 L184 102 L184 100 L188 100 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M188 96 L193 97 L193 100 L196 100 L197 96 L205 96 L205 100 L208 100 L209 103 L215 103 L216 104 L216 111 L221 111 L221 113 L214 113 L214 141 L212 141 L212 114 L189 115 L183 120 L183 135 L188 139 L187 143 L187 145 L208 146 L208 147 L192 148 L191 150 L205 150 L204 152 L193 152 L192 163 L189 163 L189 152 L187 152 L187 150 L190 150 L190 147 L179 148 L177 151 L176 148 L174 153 L174 165 L175 167 L171 168 L171 166 L169 166 L169 151 L174 146 L174 112 L166 112 L166 107 L178 107 L178 104 L184 102 L184 100 L188 100 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M224 102 L228 103 L230 106 L230 112 L232 113 L232 142 L228 142 L214 142 L214 113 L221 113 L221 111 L216 111 L215 103 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M189 114 L212 114 L212 140 L193 140 L193 133 L195 131 L195 138 L207 138 L207 132 L197 132 L197 130 L191 131 L192 135 L192 139 L188 138 L184 134 L182 135 L182 120 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M229 105 L231 105 L232 110 L242 110 L242 112 L247 113 L248 124 L249 128 L248 129 L247 137 L245 137 L245 139 L242 139 L242 141 L234 142 L231 142 L232 113 L229 112 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M188 96 L192 96 L192 101 L199 101 L199 97 L204 97 L204 100 L206 101 L205 105 L214 106 L213 111 L192 111 L185 114 L184 117 L179 116 L179 106 L187 106 L187 104 L184 103 L185 101 L189 101 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M176 147 L178 148 L178 147 L190 147 L190 150 L187 150 L187 152 L189 152 L189 163 L192 163 L192 152 L193 151 L204 151 L205 152 L205 163 L203 162 L197 162 L197 164 L194 165 L196 166 L195 168 L190 167 L186 166 L187 165 L182 164 L185 163 L185 161 L187 161 L187 156 L183 158 L180 156 L177 157 L173 155 L175 148 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M224 102 L228 103 L230 106 L230 112 L232 113 L232 142 L229 141 L229 114 L214 114 L214 113 L221 113 L221 111 L216 111 L215 103 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M198 116 L206 116 L206 123 L205 126 L201 127 L200 129 L193 131 L188 130 L188 128 L185 128 L184 130 L184 121 L188 120 L190 120 L191 119 L197 119 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M197 129 L198 131 L207 132 L207 138 L195 138 L194 133 L193 140 L203 139 L208 140 L208 131 L209 131 L209 140 L212 140 L212 142 L189 143 L186 138 L183 136 L185 132 L185 136 L189 138 L192 139 L191 131 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M197 96 L205 96 L205 100 L208 100 L209 103 L215 103 L216 104 L216 111 L221 111 L221 113 L214 113 L214 141 L212 141 L212 114 L198 113 L198 112 L214 112 L214 106 L204 106 L206 101 L203 100 L204 97 L199 97 L199 101 L192 101 L193 97 L193 100 L196 100 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M189 114 L208 114 L208 115 L198 116 L197 119 L190 121 L188 122 L188 120 L184 121 L185 128 L188 128 L192 133 L192 139 L188 138 L184 134 L182 135 L182 120 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M231 147 L234 147 L235 150 L235 158 L233 157 L231 163 L224 164 L224 152 L225 148 L230 148 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M233 112 L240 112 L245 115 L245 123 L244 125 L238 126 L235 129 L234 127 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M216 148 L223 148 L223 168 L216 166 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M239 124 L245 124 L246 136 L235 139 L234 138 L234 127 L236 128 L238 125 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M188 96 L192 96 L192 101 L199 101 L199 97 L204 97 L204 100 L206 101 L206 104 L203 105 L187 105 L184 103 L185 101 L189 101 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M208 114 L212 114 L212 140 L209 140 L207 119 L206 116 L195 116 L195 115 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M214 114 L228 114 L225 116 L223 116 L222 118 L222 116 L220 117 L220 119 L226 119 L226 124 L219 125 L215 125 L214 125 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M192 147 L208 147 L208 166 L207 167 L197 167 L197 166 L204 165 L205 164 L205 150 L191 150 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M226 122 L227 125 L225 125 L225 129 L217 128 L216 129 L216 136 L215 139 L221 140 L221 137 L223 138 L228 142 L214 142 L214 125 L216 123 L219 124 L226 124 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M193 151 L204 151 L205 152 L205 157 L194 157 L193 161 L192 160 L192 152 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M229 114 L232 114 L232 142 L229 141 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M209 147 L215 147 L214 167 L210 167 L209 167 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M188 97 L189 101 L185 101 L185 103 L187 104 L187 106 L179 106 L180 115 L178 115 L178 109 L167 109 L167 111 L175 111 L176 114 L174 114 L174 112 L166 112 L166 107 L178 107 L178 104 L184 102 L184 100 L188 100 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M186 107 L206 107 L206 111 L187 111 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M173 155 L179 156 L180 163 L176 162 L176 164 L184 165 L183 167 L180 168 L173 165 Z" style="fill:';
    string private constant PART_28 = ';"/>';
    string private constant COLOR_1 = 'hsl(223, 10%, 14%)';
    string private constant COLOR_2 = 'hsl(220, 9%, 14%)';
    string private constant COLOR_3 = 'hsl(150, 1%, 34%)';
    string private constant COLOR_4 = 'hsl(120, 1%, 37%)';
    string private constant COLOR_5 = 'hsl(230, 10%, 12%)';
    string private constant COLOR_6 = 'hsl(17, 25%, 29%)';
    string private constant COLOR_7 = 'hsl(240, 1%, 29%)';
    string private constant COLOR_8 = 'hsl(210, 2%, 24%)';
    string private constant COLOR_9 = 'hsl(180, 1%, 30%)';
    string private constant COLOR_10 = 'hsl(200, 11%, 22%)';
    string private constant COLOR_11 = 'hsl(214, 13%, 10%)';
    string private constant COLOR_12 = 'hsl(53, 4%, 45%)';
    string private constant COLOR_13 = 'hsl(22, 32%, 34%)';
    string private constant COLOR_14 = 'hsl(60, 1%, 33%)';
    string private constant COLOR_15 = 'hsl(210, 4%, 22%)';
    string private constant COLOR_16 = 'hsl(260, 3%, 22%)';
    string private constant COLOR_17 = 'hsl(60, 1%, 32%)';
    string private constant COLOR_18 = 'hsl(120, 1%, 34%)';
    string private constant COLOR_19 = 'hsl(60, 2%, 41%)';
    string private constant COLOR_20 = 'hsl(206, 5%, 28%)';
    string private constant COLOR_21 = 'hsl(214, 6%, 24%)';
    string private constant COLOR_22 = 'hsl(45, 4%, 44%)';
    string private constant COLOR_23 = 'hsl(90, 1%, 35%)';
    string private constant COLOR_24 = 'hsl(210, 1%, 33%)';
    string private constant COLOR_25 = 'hsl(220, 11%, 11%)';
    string private constant COLOR_26 = 'hsl(20, 42%, 46%)';
    string private constant COLOR_27 = 'hsl(220, 8%, 23%)';

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
            PART_28
        );
        return result;
    }
}
