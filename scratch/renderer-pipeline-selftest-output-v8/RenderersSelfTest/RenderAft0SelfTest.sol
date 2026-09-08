// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderAft0SelfTest {
    string private constant PART_1 = '<path d="M212 115 L214 115 L215 142 L218 143 L218 145 L214 146 L215 149 L213 151 L212 156 L211 156 L211 147 L209 147 L208 150 L207 147 L195 147 L185 145 L186 142 L183 141 L184 138 L189 141 L189 143 L191 142 L209 141 L212 142 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M188 96 L193 97 L193 100 L196 100 L197 96 L205 96 L205 100 L208 100 L209 104 L206 104 L206 102 L185 103 L187 104 L203 105 L203 106 L192 108 L179 106 L180 115 L178 115 L178 109 L167 109 L171 110 L177 111 L176 114 L174 114 L174 112 L166 112 L166 107 L178 107 L178 104 L184 102 L184 100 L188 100 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M208 150 L209 150 L210 156 L209 167 L211 167 L211 157 L212 157 L212 169 L214 169 L214 171 L207 173 L202 172 L197 173 L197 171 L194 173 L189 172 L185 172 L185 170 L176 169 L176 166 L182 168 L183 166 L187 167 L193 166 L196 167 L207 166 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M193 120 L195 120 L195 122 L194 123 L197 123 L199 128 L196 131 L195 138 L208 138 L208 140 L193 140 L193 132 L192 135 L192 139 L188 138 L185 136 L184 130 L186 128 L188 128 L191 122 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M213 103 L221 103 L221 104 L216 104 L216 111 L223 111 L224 113 L213 114 L213 112 L195 112 L195 114 L188 116 L183 120 L181 123 L181 120 L177 121 L177 124 L175 124 L175 117 L184 116 L186 112 L193 110 L213 111 L214 106 L204 106 L205 104 Z M224 111 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M176 126 L177 129 L179 129 L179 131 L176 131 L176 134 L182 134 L184 138 L179 137 L179 135 L177 135 L178 143 L181 143 L184 145 L181 145 L181 147 L179 149 L186 150 L205 150 L204 152 L193 152 L192 163 L189 163 L189 152 L179 152 L177 151 L176 148 L171 150 L174 146 L175 128 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M214 114 L228 114 L228 125 L224 124 L224 126 L217 125 L214 125 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M223 149 L224 149 L225 155 L225 163 L231 162 L233 156 L234 156 L234 165 L224 168 L214 169 L214 156 L218 158 L218 160 L222 160 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M231 147 L234 147 L235 150 L235 158 L233 157 L231 163 L225 164 L224 163 L224 152 L225 148 L230 148 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M234 112 L240 112 L245 115 L245 123 L244 125 L238 126 L235 129 L234 127 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M177 135 L179 135 L179 137 L184 138 L184 141 L187 141 L187 145 L195 146 L192 150 L181 151 L178 149 L178 147 L181 147 L181 144 L178 144 L177 143 Z M184 137 L188 139 L185 139 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M226 122 L228 125 L228 129 L224 130 L220 132 L216 136 L215 139 L220 139 L221 137 L223 138 L226 142 L214 142 L214 125 L216 123 L224 126 L224 124 L226 124 Z M173 155 L175 155 L176 164 L205 164 L206 157 L208 158 L208 166 L207 167 L195 168 L190 167 L182 168 L175 166 L173 162 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M205 152 L206 152 L206 164 L205 165 L178 165 L180 163 L186 164 L187 162 L192 163 L193 160 L194 157 L205 157 Z M175 155 L178 155 L180 156 L181 159 L186 159 L187 156 L189 160 L189 163 L180 164 L176 164 L175 162 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M239 124 L245 124 L246 136 L238 138 L238 132 L237 133 L237 138 L234 138 L234 127 L236 128 L238 125 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M207 116 L208 116 L208 122 L209 124 L211 125 L212 126 L212 140 L209 140 L209 130 L208 138 L207 138 L207 132 L197 132 L198 129 L201 126 L205 126 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M189 114 L208 114 L207 119 L206 116 L198 117 L197 119 L190 121 L188 122 L188 120 L184 121 L184 134 L182 135 L182 120 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M215 142 L230 142 L230 145 L226 145 L226 147 L228 148 L225 148 L224 152 L223 149 L222 151 L216 150 L216 157 L214 156 L214 147 L213 145 L218 145 L218 143 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M225 128 L228 129 L228 141 L224 140 L221 137 L220 140 L215 139 L215 134 L220 131 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M179 106 L187 106 L187 111 L189 112 L185 114 L184 117 L175 117 L176 112 L167 111 L167 109 L178 109 L178 115 L179 114 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M173 149 L174 153 L174 162 L176 168 L188 169 L185 170 L186 173 L184 173 L184 171 L176 171 L171 168 L171 166 L169 166 L169 151 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M185 102 L206 102 L205 105 L214 106 L213 111 L206 111 L206 107 L198 107 L198 106 L187 105 L184 103 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M224 102 L228 103 L230 106 L230 111 L223 112 L216 111 L216 104 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M176 147 L177 151 L189 152 L189 160 L187 158 L184 160 L180 159 L179 156 L176 156 L173 155 L175 148 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M234 110 L242 110 L242 112 L247 113 L248 124 L249 128 L248 129 L247 137 L245 137 L245 139 L240 138 L241 136 L246 136 L245 134 L244 123 L245 115 L241 114 L234 112 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M208 128 L210 131 L209 140 L212 140 L212 142 L189 143 L186 138 L183 136 L185 132 L185 136 L189 138 L192 139 L191 132 L193 132 L194 139 L203 139 L208 140 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M229 105 L231 105 L232 110 L234 110 L234 114 L229 114 L230 137 L232 142 L226 142 L228 141 L228 114 L214 114 L214 113 L224 112 L225 111 L230 111 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M232 114 L234 114 L235 138 L236 138 L236 132 L238 132 L238 138 L243 138 L242 141 L234 142 L230 143 L232 142 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M198 116 L206 116 L206 123 L205 123 L205 117 L198 118 L198 120 L197 121 L198 125 L197 123 L194 123 L193 126 L193 122 L195 122 L195 120 L190 125 L189 130 L186 129 L184 130 L184 121 L188 120 L190 120 L191 119 L197 119 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M195 112 L213 112 L214 115 L212 115 L212 126 L210 125 L209 126 L207 122 L208 114 L195 114 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M193 151 L204 151 L205 152 L205 157 L194 157 L193 161 L192 160 L192 152 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M209 147 L211 147 L213 150 L214 151 L214 169 L212 169 L211 167 L209 167 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M197 129 L198 131 L207 132 L207 138 L195 138 L195 131 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M186 107 L206 107 L206 111 L187 111 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M229 114 L232 114 L232 140 L229 137 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M177 120 L181 120 L182 123 L182 134 L176 134 L176 131 L179 131 L179 129 L175 128 L176 121 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M200 117 L205 117 L205 126 L201 126 L200 129 L198 128 L197 122 L196 120 L198 120 L198 118 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M222 148 L223 148 L223 161 L218 160 L216 157 L216 150 L222 151 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M207 146 L208 146 L208 158 L206 157 L205 150 L192 150 L192 147 Z" style="fill:';
    string private constant PART_39 = ';"/>';
    string private constant COLOR_1 = 'hsl(223, 12%, 12%)';
    string private constant COLOR_2 = 'hsl(228, 6%, 15%)';
    string private constant COLOR_3 = 'hsl(218, 10%, 16%)';
    string private constant COLOR_4 = 'hsl(80, 2%, 36%)';
    string private constant COLOR_5 = 'hsl(240, 5%, 12%)';
    string private constant COLOR_6 = 'hsl(223, 12%, 11%)';
    string private constant COLOR_7 = 'hsl(75, 2%, 38%)';
    string private constant COLOR_8 = 'hsl(220, 10%, 12%)';
    string private constant COLOR_9 = 'hsl(22, 31%, 35%)';
    string private constant COLOR_10 = 'hsl(60, 1%, 34%)';
    string private constant COLOR_11 = 'hsl(214, 7%, 19%)';
    string private constant COLOR_12 = 'hsl(210, 5%, 25%)';
    string private constant COLOR_13 = 'hsl(214, 7%, 20%)';
    string private constant COLOR_14 = 'hsl(330, 2%, 22%)';
    string private constant COLOR_15 = 'hsl(60, 2%, 39%)';
    string private constant COLOR_16 = 'hsl(47, 4%, 46%)';
    string private constant COLOR_17 = 'hsl(214, 11%, 12%)';
    string private constant COLOR_18 = 'hsl(90, 1%, 36%)';
    string private constant COLOR_19 = 'hsl(16, 18%, 29%)';
    string private constant COLOR_20 = 'hsl(223, 11%, 12%)';
    string private constant COLOR_21 = 'hsl(21, 12%, 37%)';
    string private constant COLOR_22 = 'hsl(210, 1%, 29%)';
    string private constant COLOR_23 = 'hsl(27, 6%, 36%)';
    string private constant COLOR_24 = 'hsl(214, 10%, 14%)';
    string private constant COLOR_25 = 'hsl(210, 5%, 23%)';
    string private constant COLOR_26 = 'hsl(225, 6%, 14%)';
    string private constant COLOR_27 = 'hsl(214, 13%, 10%)';
    string private constant COLOR_28 = 'hsl(210, 5%, 23%)';
    string private constant COLOR_29 = 'hsl(240, 1%, 23%)';
    string private constant COLOR_30 = 'hsl(60, 3%, 44%)';
    string private constant COLOR_31 = 'hsl(120, 1%, 33%)';
    string private constant COLOR_32 = 'hsl(199, 15%, 20%)';
    string private constant COLOR_33 = 'hsl(20, 43%, 46%)';
    string private constant COLOR_34 = 'hsl(90, 1%, 36%)';
    string private constant COLOR_35 = 'hsl(220, 8%, 16%)';
    string private constant COLOR_36 = 'hsl(180, 1%, 32%)';
    string private constant COLOR_37 = 'hsl(180, 1%, 28%)';
    string private constant COLOR_38 = 'hsl(200, 2%, 30%)';

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
        return result;
    }
}
