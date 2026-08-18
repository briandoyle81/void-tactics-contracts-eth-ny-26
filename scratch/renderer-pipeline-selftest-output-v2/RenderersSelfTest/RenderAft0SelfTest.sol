// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderAft0SelfTest {
    string private constant PART_1 = '<path d="M188 96 L193 97 L193 100 L196 100 L197 96 L205 96 L205 100 L208 100 L209 103 L227 102 L231 105 L232 110 L242 110 L242 112 L247 113 L248 124 L249 128 L248 129 L247 137 L245 137 L245 139 L242 139 L242 141 L234 142 L230 143 L230 145 L226 145 L226 147 L230 148 L234 147 L235 150 L235 158 L234 165 L224 168 L215 169 L214 171 L207 173 L202 172 L197 173 L197 171 L194 173 L189 172 L184 173 L184 171 L176 171 L171 168 L171 166 L169 166 L169 151 L174 146 L174 112 L166 112 L166 107 L178 107 L178 104 L184 102 L184 100 L188 100 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M188 96 L193 97 L193 100 L196 100 L197 96 L205 96 L205 100 L208 100 L209 103 L227 102 L231 105 L232 110 L242 110 L242 112 L247 113 L248 124 L249 128 L248 129 L247 137 L245 137 L245 139 L242 139 L242 141 L234 142 L230 143 L232 142 L232 114 L214 114 L214 127 L212 140 L193 140 L193 133 L195 131 L195 138 L207 138 L207 132 L197 132 L197 130 L191 131 L192 135 L192 140 L188 138 L184 134 L182 135 L182 120 L189 114 L198 113 L198 112 L214 112 L213 111 L192 111 L185 114 L183 118 L179 117 L179 106 L187 106 L187 104 L182 103 L184 102 L184 100 L188 100 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M211 146 L215 147 L216 148 L223 148 L223 165 L216 164 L215 153 L214 167 L210 167 L208 167 L208 169 L176 169 L172 167 L175 167 L175 165 L173 165 L173 153 L175 148 L177 147 L178 147 L190 147 L192 147 L209 147 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M189 114 L212 114 L212 140 L193 140 L193 133 L195 131 L195 138 L207 138 L207 132 L197 132 L197 130 L191 131 L192 135 L192 140 L188 138 L184 134 L182 135 L182 120 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M198 116 L206 116 L206 123 L205 126 L200 128 L193 131 L191 131 L192 135 L192 140 L188 138 L183 134 L184 121 L188 120 L190 120 L191 119 L197 119 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M223 149 L224 149 L225 156 L225 164 L231 162 L233 156 L234 156 L234 165 L224 168 L215 169 L214 171 L207 173 L202 172 L197 173 L197 171 L194 173 L189 172 L184 173 L184 171 L176 171 L174 168 L208 169 L208 167 L210 166 L212 163 L212 167 L214 167 L214 153 L216 150 L216 164 L223 165 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M183 103 L187 104 L187 106 L179 106 L180 115 L179 117 L184 116 L183 114 L192 110 L214 110 L214 112 L208 113 L208 114 L189 115 L183 120 L182 122 L180 122 L180 124 L175 124 L174 112 L166 112 L166 107 L178 107 L178 104 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M234 112 L240 112 L245 115 L244 118 L237 115 L237 117 L235 117 L235 119 L241 120 L245 124 L246 136 L242 138 L238 138 L238 132 L237 133 L237 139 L234 138 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M189 102 L206 102 L205 105 L214 106 L213 111 L192 111 L185 114 L183 118 L179 117 L180 107 L193 107 L202 106 L193 105 L193 103 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M188 96 L193 97 L193 100 L196 100 L197 96 L204 97 L204 102 L193 103 L193 105 L203 105 L202 107 L192 108 L186 107 L185 109 L180 107 L180 114 L179 114 L179 106 L187 106 L187 104 L182 103 L184 102 L184 100 L188 100 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M223 129 L228 129 L228 142 L214 142 L214 133 L218 132 L222 131 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M214 114 L228 114 L228 125 L226 124 L219 125 L215 125 L214 125 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M189 114 L208 114 L207 119 L206 116 L198 117 L197 119 L190 121 L188 122 L188 120 L184 121 L184 129 L183 135 L182 135 L182 120 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M232 113 L234 114 L235 138 L237 139 L236 132 L238 132 L238 138 L242 138 L243 136 L246 136 L245 129 L247 129 L247 137 L245 137 L245 139 L242 139 L242 141 L234 142 L230 143 L232 142 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M226 122 L228 125 L228 129 L223 129 L221 133 L218 133 L216 134 L214 133 L214 125 L216 123 L219 124 L226 124 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M234 150 L235 150 L235 158 L233 157 L231 163 L225 164 L224 152 L227 151 L232 152 L232 155 L234 155 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M192 147 L208 147 L208 166 L206 167 L205 164 L205 150 L191 150 Z M204 165 L205 167 L197 167 L197 166 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M234 112 L240 112 L245 115 L244 118 L237 115 L237 117 L235 117 L235 119 L241 120 L244 123 L244 125 L238 126 L236 129 L234 129 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M224 102 L228 103 L230 106 L230 111 L217 111 L217 105 L223 105 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M189 102 L206 102 L205 105 L214 106 L213 111 L206 111 L206 107 L202 106 L193 105 L193 103 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M229 114 L232 114 L232 142 L229 141 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M193 151 L204 151 L205 152 L205 157 L194 157 L194 160 L192 160 L192 152 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M212 149 L214 149 L214 167 L210 167 L209 167 L209 150 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M173 155 L179 156 L180 163 L176 164 L178 165 L177 166 L180 167 L180 169 L172 168 L175 167 L175 165 L173 165 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M183 103 L187 104 L187 106 L179 106 L180 115 L178 115 L178 109 L167 109 L167 111 L175 111 L176 114 L174 114 L174 112 L166 112 L166 107 L178 107 L178 104 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M185 128 L188 128 L192 133 L192 140 L188 138 L183 134 L183 129 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M194 157 L205 157 L205 163 L203 162 L195 162 L192 162 L192 160 L194 160 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M180 107 L185 107 L185 109 L187 109 L187 111 L189 112 L185 114 L183 118 L179 117 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M205 152 L206 152 L206 164 L205 165 L193 165 L187 164 L187 163 L195 161 L203 162 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M193 120 L195 120 L195 122 L194 123 L197 123 L198 129 L191 131 L191 128 L189 127 L192 125 L190 125 L192 121 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M221 137 L225 137 L225 139 L227 139 L228 137 L228 142 L214 142 L214 140 L220 139 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M178 147 L190 147 L190 150 L179 152 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M237 115 L243 116 L245 118 L245 123 L241 121 L235 119 L235 117 L237 117 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M176 147 L177 151 L181 152 L180 156 L177 157 L173 155 L175 148 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M194 131 L195 131 L195 138 L207 138 L208 140 L193 140 L193 133 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M188 115 L188 118 L186 121 L184 121 L184 129 L183 135 L182 135 L182 120 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M184 152 L189 152 L189 163 L188 163 L187 156 L183 158 L181 157 L182 153 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M229 114 L232 114 L232 126 L229 128 Z" style="fill:';
    string private constant PART_39 = ';"/><path d="M167 109 L178 109 L179 116 L175 117 L175 112 L167 111 Z" style="fill:';
    string private constant PART_40 = ';"/>';
    string private constant COLOR_1 = 'hsl(218, 11%, 15%)';
    string private constant COLOR_2 = 'hsl(220, 9%, 13%)';
    string private constant COLOR_3 = 'hsl(228, 5%, 20%)';
    string private constant COLOR_4 = 'hsl(120, 1%, 37%)';
    string private constant COLOR_5 = 'hsl(195, 3%, 27%)';
    string private constant COLOR_6 = 'hsl(223, 11%, 12%)';
    string private constant COLOR_7 = 'hsl(300, 3%, 15%)';
    string private constant COLOR_8 = 'hsl(270, 4%, 22%)';
    string private constant COLOR_9 = 'hsl(20, 42%, 46%)';
    string private constant COLOR_10 = 'hsl(260, 3%, 21%)';
    string private constant COLOR_11 = 'hsl(100, 2%, 37%)';
    string private constant COLOR_12 = 'hsl(60, 2%, 39%)';
    string private constant COLOR_13 = 'hsl(53, 4%, 44%)';
    string private constant COLOR_14 = 'hsl(228, 9%, 11%)';
    string private constant COLOR_15 = 'hsl(210, 5%, 25%)';
    string private constant COLOR_16 = 'hsl(24, 36%, 42%)';
    string private constant COLOR_17 = 'hsl(210, 4%, 29%)';
    string private constant COLOR_18 = 'hsl(45, 2%, 37%)';
    string private constant COLOR_19 = 'hsl(210, 1%, 31%)';
    string private constant COLOR_20 = 'hsl(21, 16%, 38%)';
    string private constant COLOR_21 = 'hsl(180, 1%, 33%)';
    string private constant COLOR_22 = 'hsl(45, 4%, 44%)';
    string private constant COLOR_23 = 'hsl(180, 1%, 33%)';
    string private constant COLOR_24 = 'hsl(220, 8%, 21%)';
    string private constant COLOR_25 = 'hsl(228, 9%, 10%)';
    string private constant COLOR_26 = 'hsl(75, 2%, 38%)';
    string private constant COLOR_27 = 'hsl(214, 6%, 25%)';
    string private constant COLOR_28 = 'hsl(19, 29%, 34%)';
    string private constant COLOR_29 = 'hsl(218, 10%, 16%)';
    string private constant COLOR_30 = 'hsl(60, 2%, 40%)';
    string private constant COLOR_31 = 'hsl(200, 2%, 26%)';
    string private constant COLOR_32 = 'hsl(218, 6%, 25%)';
    string private constant COLOR_33 = 'hsl(214, 6%, 25%)';
    string private constant COLOR_34 = 'hsl(80, 2%, 37%)';
    string private constant COLOR_35 = 'hsl(210, 1%, 35%)';
    string private constant COLOR_36 = 'hsl(43, 6%, 53%)';
    string private constant COLOR_37 = 'hsl(34, 7%, 40%)';
    string private constant COLOR_38 = 'hsl(75, 2%, 37%)';
    string private constant COLOR_39 = 'hsl(206, 6%, 23%)';

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
            PART_40
        );
        return result;
    }
}
