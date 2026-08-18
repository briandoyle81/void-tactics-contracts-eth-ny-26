// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderAft1SelfTest {
    string private constant PART_1 = '<path d="M181 96 L186 96 L187 99 L190 100 L191 96 L200 96 L202 98 L202 101 L205 101 L206 97 L211 97 L213 100 L213 104 L216 104 L216 102 L229 102 L234 109 L234 113 L244 113 L251 116 L253 122 L253 130 L250 133 L245 133 L245 136 L250 136 L253 139 L253 148 L250 153 L245 153 L245 156 L250 156 L252 158 L252 171 L249 173 L243 175 L232 175 L225 177 L209 178 L207 180 L201 180 L199 180 L193 180 L190 178 L190 180 L184 180 L180 180 L174 180 L170 177 L165 174 L161 169 L161 167 L154 167 L154 156 L160 149 L160 142 L159 141 L159 130 L162 127 L164 127 L164 118 L169 118 L169 106 L171 106 L171 102 L176 102 L176 100 L179 98 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M181 105 L211 105 L213 107 L217 109 L220 110 L221 112 L232 113 L233 110 L234 113 L243 113 L242 116 L239 116 L239 131 L237 127 L237 117 L234 116 L233 135 L237 136 L233 137 L233 142 L232 142 L232 115 L214 116 L204 115 L204 150 L207 151 L204 152 L203 154 L208 154 L209 155 L209 171 L206 171 L205 175 L182 175 L182 173 L172 173 L167 167 L167 160 L171 155 L177 156 L182 155 L184 151 L179 149 L174 144 L172 142 L172 120 L175 119 L174 116 L174 108 L181 107 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M181 96 L186 96 L187 99 L190 100 L191 96 L200 96 L202 98 L202 101 L205 101 L206 97 L211 97 L213 100 L213 104 L216 104 L216 102 L229 102 L234 109 L232 113 L219 113 L219 110 L217 109 L216 113 L215 108 L211 107 L211 105 L201 106 L201 107 L174 108 L174 116 L176 117 L173 120 L173 142 L176 145 L176 147 L180 149 L188 150 L184 152 L182 155 L176 157 L171 156 L168 160 L168 167 L172 171 L172 173 L182 173 L182 175 L187 175 L187 162 L188 162 L188 175 L205 175 L205 159 L206 159 L206 171 L209 171 L208 155 L203 154 L204 151 L225 151 L221 154 L221 152 L219 152 L218 158 L212 155 L212 166 L216 165 L218 162 L218 171 L225 171 L225 163 L226 163 L226 168 L230 168 L230 160 L231 160 L232 165 L235 169 L237 169 L238 159 L239 159 L239 169 L243 168 L245 166 L245 173 L243 175 L232 175 L225 177 L209 178 L207 180 L201 180 L199 180 L193 180 L190 178 L190 180 L184 180 L180 180 L174 180 L170 177 L165 174 L161 169 L161 167 L154 167 L154 156 L160 149 L160 142 L159 141 L159 130 L162 127 L164 127 L164 118 L169 118 L169 106 L171 106 L171 102 L176 102 L176 100 L179 98 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M181 105 L211 105 L213 107 L215 107 L213 113 L202 115 L202 147 L189 147 L189 145 L198 144 L199 143 L199 135 L191 134 L191 132 L187 133 L188 131 L193 129 L192 120 L183 121 L179 125 L179 136 L176 136 L175 140 L172 140 L172 120 L175 119 L174 116 L174 108 L181 107 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M204 151 L225 151 L221 154 L221 152 L219 152 L218 158 L212 155 L212 166 L216 165 L218 162 L218 171 L225 171 L225 163 L226 163 L226 168 L230 168 L230 160 L231 160 L232 165 L235 169 L237 169 L238 159 L239 159 L239 169 L243 168 L245 166 L245 173 L243 175 L232 175 L225 177 L209 178 L207 180 L201 180 L199 180 L193 180 L190 178 L190 180 L184 180 L180 180 L174 180 L170 177 L166 175 L166 172 L169 173 L169 175 L181 175 L182 173 L182 175 L187 175 L187 162 L188 162 L188 175 L205 175 L205 159 L206 159 L206 171 L209 171 L208 155 L203 154 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M181 96 L186 96 L187 99 L190 100 L191 96 L200 96 L202 98 L202 101 L205 101 L206 97 L211 97 L213 100 L213 104 L216 104 L216 102 L229 102 L234 109 L232 113 L219 113 L219 110 L217 109 L216 113 L215 108 L211 107 L211 105 L201 106 L201 107 L174 108 L173 117 L171 116 L169 106 L171 106 L171 102 L176 102 L176 100 L179 98 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M215 115 L232 115 L231 127 L231 145 L228 147 L214 147 L214 117 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M243 113 L251 116 L253 122 L253 130 L250 133 L245 133 L245 136 L250 136 L253 139 L253 148 L250 153 L244 153 L243 145 L241 146 L240 141 L241 137 L239 137 L239 142 L237 139 L237 137 L233 135 L233 115 L238 117 L238 127 L239 116 L242 115 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M183 120 L192 120 L192 126 L194 127 L194 130 L189 132 L191 132 L191 134 L199 134 L200 135 L200 143 L198 145 L189 145 L189 147 L199 147 L200 145 L200 147 L202 148 L181 148 L175 141 L176 136 L178 135 L178 125 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M182 154 L187 154 L187 175 L182 175 L182 173 L172 173 L167 167 L167 160 L171 155 L177 156 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M188 155 L199 155 L205 156 L205 175 L188 175 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M181 105 L211 105 L213 107 L215 107 L213 113 L210 114 L181 115 L174 116 L174 108 L181 107 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M211 153 L216 154 L214 156 L212 155 L212 166 L216 165 L218 162 L218 171 L225 171 L225 163 L226 163 L226 168 L230 168 L230 160 L231 160 L232 165 L235 169 L237 169 L238 159 L239 159 L239 169 L243 168 L245 166 L245 173 L243 175 L232 175 L225 177 L211 177 L210 174 L212 172 L210 171 L210 154 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M204 115 L213 115 L213 129 L211 130 L213 131 L213 148 L206 148 L204 147 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M206 97 L211 97 L213 100 L213 104 L216 104 L216 102 L229 102 L234 109 L232 113 L219 113 L219 110 L217 109 L216 113 L215 108 L211 107 L211 103 L189 103 L190 101 L198 100 L202 99 L202 101 L205 101 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M215 108 L220 109 L221 112 L232 113 L233 110 L234 113 L243 113 L242 116 L239 116 L239 131 L237 127 L237 117 L234 116 L233 135 L237 136 L233 137 L233 142 L232 142 L232 115 L214 116 L181 115 L181 114 L213 113 L214 109 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M188 155 L199 155 L205 156 L205 171 L189 171 L189 170 L201 170 L200 159 L190 160 L189 169 L188 169 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M171 155 L177 156 L181 155 L181 160 L174 160 L173 161 L173 167 L174 168 L181 168 L181 173 L172 173 L167 167 L167 160 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M187 134 L199 134 L200 135 L200 143 L196 145 L196 140 L190 140 L190 142 L194 143 L187 144 L185 143 L185 135 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M218 120 L227 120 L228 121 L228 129 L223 134 L221 134 L221 132 L219 132 L217 129 L217 121 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M228 154 L230 154 L230 168 L226 168 L225 171 L222 171 L222 155 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M245 137 L251 137 L253 139 L253 148 L252 151 L245 152 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M174 108 L190 108 L190 113 L181 113 L181 115 L174 116 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M170 154 L181 154 L177 157 L171 156 L168 160 L168 167 L172 171 L172 173 L181 173 L181 175 L169 175 L167 173 L164 173 L163 170 L166 170 L166 158 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M183 120 L192 120 L192 126 L194 127 L194 130 L191 131 L191 125 L184 127 L181 128 L181 130 L178 130 L178 125 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M212 155 L216 155 L217 157 L221 155 L221 166 L217 165 L212 166 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M178 115 L202 115 L202 116 L180 117 L179 119 L177 119 L177 121 L175 122 L175 136 L174 140 L172 140 L172 120 L175 119 L176 116 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M169 109 L171 111 L172 116 L174 113 L174 116 L176 117 L173 120 L172 125 L171 125 L171 119 L165 119 L167 123 L167 139 L166 139 L165 130 L161 128 L164 127 L164 118 L169 118 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M233 115 L238 117 L238 126 L237 131 L237 135 L233 135 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M182 154 L187 154 L187 171 L182 171 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M189 154 L208 154 L209 155 L209 171 L206 171 L205 156 L189 155 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M172 140 L176 141 L176 143 L180 145 L183 147 L202 148 L202 150 L180 150 L175 145 L172 142 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M211 153 L216 154 L214 156 L212 155 L212 166 L216 167 L216 173 L215 175 L210 175 L212 172 L210 171 L210 154 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M177 119 L179 119 L180 124 L179 125 L179 136 L176 136 L174 140 L174 122 L177 121 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M216 107 L229 107 L230 108 L230 113 L219 113 L219 110 L217 109 L216 113 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M199 161 L200 161 L200 169 L191 169 L190 168 L190 162 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M202 115 L204 115 L204 147 L202 147 L201 142 L201 129 Z" style="fill:';
    string private constant PART_38 = ';"/>';
    string private constant COLOR_1 = 'hsl(270, 2%, 21%)';
    string private constant COLOR_2 = 'hsl(213, 14%, 12%)';
    string private constant COLOR_3 = 'hsl(213, 11%, 15%)';
    string private constant COLOR_4 = 'hsl(38, 6%, 39%)';
    string private constant COLOR_5 = 'hsl(213, 16%, 11%)';
    string private constant COLOR_6 = 'hsl(216, 6%, 17%)';
    string private constant COLOR_7 = 'hsl(36, 3%, 36%)';
    string private constant COLOR_8 = 'hsl(12, 9%, 22%)';
    string private constant COLOR_9 = 'hsl(60, 1%, 36%)';
    string private constant COLOR_10 = 'hsl(300, 1%, 21%)';
    string private constant COLOR_11 = 'hsl(218, 9%, 17%)';
    string private constant COLOR_12 = 'hsl(21, 24%, 39%)';
    string private constant COLOR_13 = 'hsl(220, 9%, 14%)';
    string private constant COLOR_14 = 'hsl(37, 4%, 37%)';
    string private constant COLOR_15 = 'hsl(220, 8%, 15%)';
    string private constant COLOR_16 = 'hsl(214, 14%, 10%)';
    string private constant COLOR_17 = 'hsl(36, 3%, 38%)';
    string private constant COLOR_18 = 'hsl(240, 1%, 32%)';
    string private constant COLOR_19 = 'hsl(218, 7%, 21%)';
    string private constant COLOR_20 = 'hsl(230, 5%, 22%)';
    string private constant COLOR_21 = 'hsl(22, 16%, 34%)';
    string private constant COLOR_22 = 'hsl(20, 22%, 34%)';
    string private constant COLOR_23 = 'hsl(21, 32%, 47%)';
    string private constant COLOR_24 = 'hsl(220, 6%, 20%)';
    string private constant COLOR_25 = 'hsl(204, 5%, 20%)';
    string private constant COLOR_26 = 'hsl(180, 1%, 28%)';
    string private constant COLOR_27 = 'hsl(24, 3%, 34%)';
    string private constant COLOR_28 = 'hsl(213, 16%, 11%)';
    string private constant COLOR_29 = 'hsl(214, 7%, 20%)';
    string private constant COLOR_30 = 'hsl(30, 1%, 38%)';
    string private constant COLOR_31 = 'hsl(225, 3%, 26%)';
    string private constant COLOR_32 = 'hsl(218, 8%, 20%)';
    string private constant COLOR_33 = 'hsl(222, 11%, 18%)';
    string private constant COLOR_34 = 'hsl(38, 5%, 44%)';
    string private constant COLOR_35 = 'hsl(36, 3%, 36%)';
    string private constant COLOR_36 = 'hsl(228, 4%, 26%)';
    string private constant COLOR_37 = 'hsl(210, 2%, 23%)';

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
