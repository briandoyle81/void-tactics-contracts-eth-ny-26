// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderAft1SelfTest {
    string private constant PART_1 = '<path d="M181 96 L186 96 L187 99 L190 100 L191 96 L200 96 L202 98 L202 101 L205 101 L206 97 L211 97 L213 100 L213 104 L216 104 L216 102 L229 102 L234 109 L234 113 L244 113 L251 116 L253 122 L253 130 L250 133 L245 133 L245 136 L250 136 L253 139 L253 148 L250 153 L245 153 L245 156 L250 156 L252 158 L252 171 L249 173 L243 175 L232 175 L225 177 L209 178 L207 180 L201 180 L199 180 L193 180 L190 178 L190 180 L184 180 L180 180 L174 180 L170 177 L165 174 L161 169 L161 167 L154 167 L154 156 L160 149 L160 142 L159 141 L159 130 L162 127 L164 127 L164 118 L169 118 L169 106 L171 106 L171 102 L176 102 L176 100 L179 98 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M171 102 L176 102 L176 105 L211 105 L213 107 L214 107 L214 112 L210 114 L215 115 L232 115 L232 145 L228 149 L225 151 L180 151 L174 144 L172 144 L174 149 L173 150 L166 150 L166 124 L165 124 L165 119 L171 119 L172 120 L170 111 L169 106 L171 106 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M181 96 L186 96 L187 99 L190 100 L191 96 L200 96 L202 98 L202 101 L205 101 L206 97 L211 97 L213 100 L213 104 L216 104 L216 102 L229 102 L231 104 L231 107 L216 107 L216 113 L232 113 L233 111 L233 135 L240 135 L238 138 L233 137 L234 148 L235 152 L237 152 L237 143 L239 142 L240 154 L230 156 L230 154 L225 156 L225 153 L221 154 L221 152 L217 154 L211 154 L208 155 L189 155 L188 175 L208 175 L209 178 L207 180 L201 180 L199 180 L193 180 L190 178 L190 180 L184 180 L180 180 L174 180 L170 177 L165 174 L161 169 L161 167 L154 167 L154 156 L160 149 L160 142 L159 141 L159 130 L162 127 L164 127 L164 118 L169 118 L169 109 L171 111 L173 120 L172 142 L171 142 L171 119 L165 119 L167 123 L167 147 L166 150 L173 149 L171 143 L175 144 L176 147 L180 149 L180 151 L225 150 L230 147 L231 145 L232 115 L213 116 L181 115 L181 114 L210 113 L213 112 L212 108 L211 105 L176 105 L176 100 L179 98 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M181 96 L186 96 L187 99 L190 100 L191 96 L200 96 L202 98 L202 101 L205 101 L206 97 L211 97 L213 100 L213 104 L216 104 L216 102 L229 102 L231 104 L231 107 L216 107 L216 113 L232 113 L233 111 L233 135 L240 135 L238 138 L233 137 L234 148 L235 152 L237 152 L237 143 L239 142 L240 154 L230 156 L230 154 L225 156 L225 153 L221 154 L221 152 L217 154 L211 154 L208 155 L189 155 L188 175 L208 175 L209 178 L207 180 L201 180 L199 180 L193 180 L190 178 L190 180 L184 180 L180 180 L174 180 L170 177 L166 175 L167 171 L169 175 L181 175 L181 173 L187 173 L187 154 L182 154 L186 152 L188 151 L225 150 L230 147 L231 145 L232 115 L213 116 L181 115 L181 114 L210 113 L213 112 L212 108 L211 105 L176 105 L176 100 L179 98 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M193 119 L194 119 L194 125 L197 125 L197 130 L199 131 L200 127 L202 127 L202 148 L186 148 L188 147 L187 143 L185 143 L185 135 L181 134 L181 130 L179 130 L178 132 L178 125 L183 120 L192 120 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M231 106 L234 109 L234 113 L244 113 L251 116 L253 122 L253 130 L250 133 L245 133 L245 136 L250 136 L253 139 L253 148 L252 151 L245 152 L245 139 L248 138 L243 137 L243 142 L241 140 L241 125 L243 127 L244 119 L241 119 L241 115 L235 115 L234 119 L232 113 L216 113 L216 107 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M189 154 L208 154 L209 155 L209 171 L206 171 L205 175 L188 175 L188 155 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M182 115 L202 115 L202 127 L200 127 L199 131 L196 130 L197 125 L194 125 L192 121 L183 121 L179 125 L179 130 L181 130 L181 134 L186 134 L185 143 L187 143 L188 147 L181 148 L174 140 L174 122 L177 119 L179 119 L180 116 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M181 96 L186 96 L187 99 L190 100 L191 96 L200 96 L202 98 L202 101 L205 101 L206 97 L211 97 L213 100 L213 104 L216 104 L216 102 L229 102 L231 104 L231 107 L212 108 L211 105 L176 105 L176 100 L179 98 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M182 154 L187 154 L187 173 L172 173 L167 167 L167 160 L171 155 L177 156 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M215 115 L231 115 L231 118 L218 119 L218 129 L219 132 L223 131 L227 129 L229 126 L231 129 L231 140 L228 143 L226 143 L226 145 L224 145 L224 143 L221 145 L218 145 L218 147 L214 147 L214 117 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M181 105 L211 105 L213 107 L214 107 L214 112 L210 114 L181 115 L174 116 L174 108 L181 107 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M204 115 L213 115 L213 148 L206 148 L204 147 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M238 114 L241 115 L241 119 L244 119 L244 132 L243 132 L242 127 L241 146 L239 146 L238 143 L237 152 L233 152 L233 137 L238 137 L239 136 L233 135 L233 115 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M231 115 L232 115 L232 145 L231 147 L227 148 L214 148 L218 147 L218 145 L224 143 L224 145 L226 145 L226 143 L230 140 L230 129 L228 129 L222 133 L219 132 L217 129 L217 118 L231 118 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M212 154 L216 154 L218 156 L220 157 L221 161 L221 171 L217 172 L216 177 L208 177 L209 175 L210 155 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M228 154 L231 155 L237 154 L238 156 L238 169 L236 171 L232 171 L230 168 L226 168 L225 171 L222 171 L222 158 L223 156 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M171 102 L176 102 L176 105 L201 106 L201 107 L174 108 L174 116 L182 115 L177 120 L175 122 L175 136 L174 140 L172 140 L172 117 L169 109 L169 106 L171 106 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M169 151 L178 151 L181 153 L181 155 L176 157 L171 156 L168 160 L168 167 L172 171 L172 173 L181 173 L181 175 L169 175 L167 173 L164 173 L163 169 L163 157 L165 157 L167 153 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M187 134 L199 134 L200 135 L200 143 L198 145 L187 145 L187 143 L185 143 L185 135 Z" style="fill:';
    string private constant PART_21 = ';"/>';
    string private constant COLOR_1 = 'hsl(340, 3%, 18%)';
    string private constant COLOR_2 = 'hsl(218, 8%, 20%)';
    string private constant COLOR_3 = 'hsl(216, 14%, 14%)';
    string private constant COLOR_4 = 'hsl(213, 17%, 10%)';
    string private constant COLOR_5 = 'hsl(40, 2%, 32%)';
    string private constant COLOR_6 = 'hsl(20, 13%, 27%)';
    string private constant COLOR_7 = 'hsl(240, 1%, 27%)';
    string private constant COLOR_8 = 'hsl(38, 5%, 40%)';
    string private constant COLOR_9 = 'hsl(220, 8%, 15%)';
    string private constant COLOR_10 = 'hsl(300, 1%, 29%)';
    string private constant COLOR_11 = 'hsl(36, 3%, 37%)';
    string private constant COLOR_12 = 'hsl(22, 27%, 41%)';
    string private constant COLOR_13 = 'hsl(37, 4%, 37%)';
    string private constant COLOR_14 = 'hsl(220, 6%, 21%)';
    string private constant COLOR_15 = 'hsl(225, 3%, 26%)';
    string private constant COLOR_16 = 'hsl(220, 5%, 22%)';
    string private constant COLOR_17 = 'hsl(20, 8%, 28%)';
    string private constant COLOR_18 = 'hsl(240, 1%, 24%)';
    string private constant COLOR_19 = 'hsl(223, 8%, 18%)';
    string private constant COLOR_20 = 'hsl(208, 11%, 23%)';

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
            PART_21
        );
        return result;
    }
}
