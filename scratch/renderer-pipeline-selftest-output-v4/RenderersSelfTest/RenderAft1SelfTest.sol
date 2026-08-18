// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderAft1SelfTest {
    string private constant PART_1 = '<path d="M181 96 L186 96 L187 99 L190 100 L191 96 L200 96 L202 98 L202 101 L205 101 L206 97 L211 97 L213 100 L213 104 L216 104 L216 102 L229 102 L234 109 L234 113 L244 113 L251 116 L253 122 L253 130 L250 133 L245 133 L245 136 L250 136 L253 139 L253 148 L250 153 L245 153 L245 156 L250 156 L252 158 L252 171 L249 173 L243 175 L232 175 L225 177 L209 178 L207 180 L201 180 L199 180 L193 180 L190 178 L190 180 L184 180 L180 180 L174 180 L170 177 L165 174 L161 169 L161 167 L154 167 L154 156 L160 149 L160 142 L159 141 L159 130 L162 127 L164 127 L164 118 L169 118 L169 106 L171 106 L171 102 L176 102 L176 100 L179 98 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M181 105 L211 105 L213 107 L229 107 L230 108 L230 113 L225 114 L232 115 L232 145 L228 149 L226 150 L204 150 L204 148 L181 148 L174 140 L174 135 L173 140 L172 140 L172 120 L175 119 L176 116 L178 115 L174 115 L174 108 L181 107 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M243 113 L251 116 L253 122 L253 130 L250 133 L245 133 L245 136 L250 136 L253 139 L253 148 L250 153 L245 153 L245 156 L250 156 L252 158 L252 171 L249 173 L243 175 L233 175 L233 174 L239 173 L238 169 L236 171 L232 171 L231 171 L231 154 L238 153 L238 143 L237 152 L233 152 L233 115 L238 116 L238 128 L234 129 L237 129 L237 131 L235 131 L234 134 L238 133 L239 115 L243 115 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M181 96 L186 96 L187 99 L190 100 L191 96 L200 96 L202 98 L202 101 L205 101 L206 97 L211 97 L213 100 L213 104 L216 104 L216 102 L229 102 L234 109 L233 112 L230 113 L229 108 L212 108 L211 105 L201 106 L201 107 L174 108 L175 114 L179 115 L173 120 L174 123 L175 140 L176 143 L180 145 L183 147 L204 148 L204 150 L210 149 L213 150 L214 147 L214 150 L225 150 L225 151 L197 152 L203 153 L203 154 L189 155 L188 175 L182 175 L182 173 L187 173 L187 154 L181 155 L181 153 L173 153 L169 152 L165 157 L163 157 L166 147 L170 145 L171 123 L168 123 L168 120 L165 119 L167 123 L167 146 L165 145 L165 130 L161 128 L164 127 L164 118 L169 118 L169 106 L171 106 L171 102 L176 102 L176 100 L179 98 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M165 119 L170 119 L168 120 L168 123 L171 123 L171 145 L169 147 L166 147 L165 154 L163 157 L168 152 L169 151 L178 151 L182 154 L187 154 L187 173 L181 173 L181 175 L169 175 L167 173 L164 173 L161 169 L161 167 L154 167 L154 156 L160 149 L160 142 L159 141 L159 130 L160 129 L165 129 L166 130 L166 145 L167 146 L166 124 L165 124 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M181 105 L211 105 L213 107 L214 110 L213 113 L190 113 L187 114 L202 115 L202 118 L180 119 L180 124 L179 125 L179 130 L181 130 L181 128 L185 125 L191 125 L192 130 L196 129 L194 134 L185 135 L185 143 L187 143 L188 147 L181 148 L174 140 L174 135 L173 140 L172 140 L172 120 L175 119 L176 116 L178 115 L174 115 L174 108 L181 107 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M215 115 L232 115 L232 145 L228 149 L226 150 L214 150 L214 117 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M169 109 L171 111 L172 116 L176 117 L173 120 L174 123 L175 140 L176 143 L180 145 L183 147 L204 148 L204 150 L210 149 L213 150 L214 147 L214 150 L225 150 L225 151 L197 152 L203 153 L203 154 L189 155 L188 175 L182 175 L182 173 L187 173 L187 154 L181 155 L181 153 L173 153 L169 152 L165 157 L163 157 L166 147 L170 145 L171 123 L168 123 L168 120 L165 119 L167 123 L167 146 L165 145 L165 130 L161 128 L164 127 L164 118 L169 118 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M189 154 L208 154 L209 155 L209 171 L206 171 L205 175 L188 175 L188 155 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M219 152 L225 153 L226 155 L230 154 L230 172 L227 173 L227 175 L222 175 L221 171 L217 172 L216 175 L210 175 L209 154 L211 153 L218 153 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M243 113 L251 116 L253 122 L253 130 L250 133 L245 133 L245 136 L250 136 L253 139 L253 148 L251 151 L251 149 L245 150 L244 139 L243 150 L241 150 L240 141 L242 133 L242 118 L241 133 L239 133 L239 115 L243 115 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M182 154 L187 154 L187 173 L172 173 L167 167 L167 160 L171 155 L177 156 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M204 115 L213 115 L213 148 L206 148 L204 147 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M181 105 L211 105 L213 107 L214 110 L213 113 L190 113 L179 115 L174 115 L174 108 L181 107 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M165 119 L170 119 L168 120 L168 123 L171 123 L171 145 L169 147 L166 147 L165 154 L162 155 L160 149 L160 142 L159 141 L159 130 L160 129 L165 129 L166 130 L166 145 L167 146 L166 124 L165 124 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M173 123 L174 123 L175 140 L176 143 L180 145 L183 147 L204 148 L204 150 L210 149 L213 150 L214 147 L214 150 L225 150 L225 151 L197 152 L203 153 L203 154 L189 155 L188 175 L182 175 L182 173 L187 173 L187 154 L182 154 L186 153 L186 151 L180 151 L173 143 L172 140 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M178 115 L202 115 L202 118 L180 119 L180 124 L179 125 L178 132 L177 132 L177 127 L175 127 L175 135 L174 135 L173 140 L172 140 L172 120 L175 119 L176 116 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M187 134 L199 134 L200 135 L200 143 L198 145 L187 145 L187 143 L185 143 L185 135 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M228 154 L230 154 L230 172 L227 173 L227 175 L222 175 L222 158 L223 156 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M214 127 L216 127 L216 132 L218 133 L218 135 L220 135 L224 140 L224 142 L227 142 L227 140 L229 140 L228 147 L214 147 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M171 155 L177 156 L181 155 L181 160 L174 160 L173 161 L173 167 L174 168 L181 168 L181 173 L172 173 L167 167 L167 160 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M204 115 L213 115 L213 129 L207 131 L204 130 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M233 115 L238 116 L238 128 L234 129 L237 129 L237 131 L235 131 L234 134 L241 133 L241 117 L243 118 L243 133 L241 138 L233 137 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M188 155 L199 155 L205 156 L204 171 L189 171 L189 170 L201 170 L200 159 L190 160 L189 169 L188 169 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M218 120 L227 120 L228 121 L228 129 L222 133 L219 132 L217 129 L217 121 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M245 157 L251 157 L252 158 L252 171 L249 173 L245 173 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M171 102 L176 102 L176 105 L201 106 L201 107 L174 108 L175 114 L179 115 L172 117 L169 109 L169 106 L171 106 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M173 123 L174 123 L175 140 L176 143 L180 145 L183 147 L202 148 L202 150 L180 150 L175 145 L172 142 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M231 115 L232 115 L232 145 L228 149 L226 150 L214 150 L214 147 L218 147 L219 145 L219 147 L227 146 L228 142 L230 140 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M245 137 L251 137 L253 139 L253 148 L251 151 L251 149 L245 150 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M189 154 L208 154 L209 155 L209 171 L204 171 L204 158 L205 156 L189 155 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M183 120 L192 120 L192 126 L194 127 L192 131 L191 127 L191 125 L184 127 L181 128 L181 130 L179 130 L178 132 L178 125 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M212 155 L220 156 L221 161 L221 169 L217 166 L212 166 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M170 154 L181 154 L177 157 L171 156 L168 160 L168 167 L172 171 L172 173 L181 173 L181 175 L169 175 L166 171 L166 158 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M216 107 L229 107 L230 108 L230 113 L219 113 L219 110 L217 109 L216 113 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M190 162 L200 162 L200 169 L190 169 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M243 156 L244 156 L244 172 L242 169 L241 173 L244 174 L243 175 L233 175 L233 174 L239 173 L239 160 L242 160 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M185 135 L198 135 L197 139 L189 139 L189 143 L185 143 Z" style="fill:';
    string private constant PART_39 = ';"/><path d="M182 154 L187 154 L187 166 L184 169 L184 171 L182 171 Z" style="fill:';
    string private constant PART_40 = ';"/><path d="M171 155 L177 156 L181 155 L181 160 L174 160 L170 165 L168 165 L167 160 Z" style="fill:';
    string private constant PART_41 = ';"/><path d="M204 115 L213 115 L213 120 L209 121 L208 125 L206 124 L204 121 Z" style="fill:';
    string private constant PART_42 = ';"/>';
    string private constant COLOR_1 = 'hsl(216, 19%, 11%)';
    string private constant COLOR_2 = 'hsl(40, 2%, 27%)';
    string private constant COLOR_3 = 'hsl(220, 6%, 18%)';
    string private constant COLOR_4 = 'hsl(220, 8%, 15%)';
    string private constant COLOR_5 = 'hsl(216, 16%, 13%)';
    string private constant COLOR_6 = 'hsl(33, 5%, 38%)';
    string private constant COLOR_7 = 'hsl(30, 2%, 36%)';
    string private constant COLOR_8 = 'hsl(216, 17%, 11%)';
    string private constant COLOR_9 = 'hsl(218, 9%, 17%)';
    string private constant COLOR_10 = 'hsl(220, 10%, 18%)';
    string private constant COLOR_11 = 'hsl(16, 12%, 25%)';
    string private constant COLOR_12 = 'hsl(270, 2%, 22%)';
    string private constant COLOR_13 = 'hsl(40, 3%, 36%)';
    string private constant COLOR_14 = 'hsl(22, 28%, 45%)';
    string private constant COLOR_15 = 'hsl(218, 8%, 20%)';
    string private constant COLOR_16 = 'hsl(220, 13%, 14%)';
    string private constant COLOR_17 = 'hsl(34, 6%, 44%)';
    string private constant COLOR_18 = 'hsl(207, 19%, 21%)';
    string private constant COLOR_19 = 'hsl(18, 12%, 29%)';
    string private constant COLOR_20 = 'hsl(36, 3%, 38%)';
    string private constant COLOR_21 = 'hsl(214, 5%, 26%)';
    string private constant COLOR_22 = 'hsl(34, 4%, 36%)';
    string private constant COLOR_23 = 'hsl(218, 9%, 17%)';
    string private constant COLOR_24 = 'hsl(30, 3%, 40%)';
    string private constant COLOR_25 = 'hsl(223, 6%, 22%)';
    string private constant COLOR_26 = 'hsl(20, 24%, 32%)';
    string private constant COLOR_27 = 'hsl(240, 2%, 20%)';
    string private constant COLOR_28 = 'hsl(214, 6%, 21%)';
    string private constant COLOR_29 = 'hsl(220, 5%, 25%)';
    string private constant COLOR_30 = 'hsl(21, 24%, 37%)';
    string private constant COLOR_31 = 'hsl(225, 3%, 26%)';
    string private constant COLOR_32 = 'hsl(210, 4%, 20%)';
    string private constant COLOR_33 = 'hsl(240, 1%, 29%)';
    string private constant COLOR_34 = 'hsl(220, 6%, 20%)';
    string private constant COLOR_35 = 'hsl(36, 3%, 36%)';
    string private constant COLOR_36 = 'hsl(228, 4%, 26%)';
    string private constant COLOR_37 = 'hsl(0, 0%, 27%)';
    string private constant COLOR_38 = 'hsl(220, 5%, 26%)';
    string private constant COLOR_39 = 'hsl(30, 2%, 39%)';
    string private constant COLOR_40 = 'hsl(40, 2%, 37%)';
    string private constant COLOR_41 = 'hsl(37, 6%, 41%)';

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
            PART_42
        );
        return result;
    }
}
