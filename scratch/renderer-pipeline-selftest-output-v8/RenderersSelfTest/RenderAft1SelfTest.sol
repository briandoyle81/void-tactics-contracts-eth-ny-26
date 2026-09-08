// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderAft1SelfTest {
    string private constant PART_1 = '<path d="M233 137 L238 137 L240 153 L241 156 L235 156 L235 167 L237 167 L237 165 L239 165 L240 174 L233 174 L230 176 L224 177 L224 175 L222 175 L221 171 L221 161 L219 160 L221 160 L221 153 L219 152 L224 152 L225 148 L228 147 L229 145 L232 145 Z M224 154 L222 155 L222 171 L225 171 L226 168 L230 167 L230 154 Z M242 151 Z M241 154 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M181 105 L212 105 L213 107 L214 107 L215 117 L213 120 L213 114 L201 113 L190 113 L174 114 L174 107 L181 107 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M243 137 L249 137 L250 141 L245 140 L245 149 L252 148 L251 152 L250 153 L245 153 L245 156 L250 156 L249 158 L245 157 L245 173 L243 175 L233 175 L233 174 L239 173 L239 165 L237 165 L237 167 L235 167 L235 156 L242 154 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M195 118 L202 118 L202 141 L200 142 L199 135 L186 135 L181 134 L181 128 L185 125 L191 125 L192 129 L194 119 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M233 114 L239 114 L241 115 L241 119 L243 119 L244 116 L244 127 L241 142 L241 148 L239 148 L239 136 L233 135 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M205 160 L206 160 L206 175 L208 175 L209 178 L207 180 L201 180 L199 180 L193 180 L190 178 L190 180 L184 180 L180 180 L174 180 L170 177 L166 175 L167 173 L169 173 L169 175 L181 175 L182 173 L182 175 L205 175 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M206 97 L211 97 L213 100 L213 104 L216 104 L216 102 L229 102 L234 109 L233 113 L232 115 L214 115 L215 113 L230 113 L229 108 L216 107 L216 112 L215 112 L215 107 L212 108 L211 103 L203 103 L203 101 L205 101 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M181 155 L182 155 L183 167 L182 171 L186 170 L187 173 L172 173 L167 167 L168 164 L171 165 L172 161 L174 159 L180 159 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M169 151 L178 151 L182 152 L186 153 L187 151 L192 152 L206 152 L209 155 L209 173 L208 175 L206 175 L205 160 L204 155 L189 155 L188 175 L182 175 L182 173 L187 173 L187 154 L181 155 L170 155 L165 159 L166 154 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M171 103 L172 107 L171 116 L176 116 L175 119 L173 120 L172 140 L175 141 L171 143 L174 149 L170 150 L166 150 L166 147 L168 147 L168 141 L170 140 L171 127 L168 127 L168 124 L169 123 L171 119 L165 119 L165 124 L167 124 L167 145 L166 145 L165 130 L161 128 L164 127 L164 118 L169 118 L169 106 L171 106 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M179 135 L186 135 L187 145 L198 144 L202 143 L202 148 L181 148 L175 141 L176 136 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M171 102 L176 102 L176 104 L181 105 L201 106 L201 107 L180 108 L174 107 L174 114 L178 113 L190 113 L191 111 L191 113 L201 113 L201 108 L202 108 L202 113 L210 113 L213 115 L171 116 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M191 96 L200 96 L203 101 L203 103 L211 103 L211 104 L179 104 L182 98 L187 99 L190 100 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M164 150 L165 154 L162 156 L163 157 L164 170 L162 171 L161 167 L154 167 L154 156 L159 151 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M204 115 L213 115 L213 129 L211 130 L207 131 L204 131 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M227 131 L230 131 L231 133 L231 140 L228 143 L226 146 L225 147 L218 147 L218 145 L221 145 L221 143 L218 144 L219 138 L222 137 L223 133 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M213 120 L214 120 L215 148 L218 148 L224 148 L225 151 L180 151 L180 150 L202 150 L202 147 L213 147 L212 132 L210 128 L213 129 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M211 153 L221 153 L221 156 L218 156 L218 165 L214 166 L214 168 L212 168 L212 171 L210 171 L209 154 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M218 120 L227 120 L228 121 L228 129 L224 133 L219 132 L217 129 L217 121 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M202 115 L204 115 L204 147 L202 147 L202 143 L196 145 L196 140 L190 140 L189 143 L189 139 L197 139 L197 136 L187 135 L187 134 L199 134 L201 141 L201 129 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M245 116 L251 116 L253 122 L253 130 L251 132 L245 132 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M161 142 L162 142 L162 147 L165 147 L165 145 L167 145 L166 150 L173 149 L171 143 L175 144 L176 147 L180 149 L180 151 L186 151 L186 153 L172 153 L169 152 L165 157 L161 156 L164 154 L164 151 L160 151 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M190 159 L200 159 L200 161 L190 162 L191 168 L200 169 L197 171 L205 171 L205 175 L188 175 L189 160 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M180 116 L202 116 L202 118 L195 119 L194 126 L192 126 L192 120 L183 121 L179 125 L175 125 L177 121 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M224 154 L230 154 L230 167 L226 168 L225 171 L222 171 L222 155 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M163 157 L168 158 L168 167 L172 171 L172 173 L181 173 L181 175 L169 175 L169 173 L165 174 L163 170 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M245 157 L251 157 L252 158 L252 171 L249 173 L245 173 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M160 129 L165 129 L166 130 L166 145 L165 147 L162 147 L162 142 L159 141 L159 130 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M244 119 L245 119 L245 132 L250 132 L250 133 L245 133 L245 136 L250 136 L252 138 L251 142 L250 139 L245 139 L243 137 L243 151 L241 155 L239 153 L239 148 L241 148 L240 141 L243 127 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M214 107 L229 107 L230 108 L230 113 L225 114 L214 114 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M231 115 L232 115 L232 145 L229 147 L225 148 L225 150 L220 149 L217 150 L214 147 L223 146 L226 145 L228 142 L230 142 L230 133 L226 132 L228 127 L230 127 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M188 158 L205 158 L205 171 L202 172 L189 171 L189 170 L201 170 L200 159 L190 160 L189 169 L188 169 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M186 135 L198 135 L197 139 L189 139 L190 140 L196 140 L196 145 L187 145 L186 143 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M165 119 L171 119 L171 123 L170 125 L168 124 L168 127 L171 127 L171 142 L169 141 L168 147 L167 147 L167 124 L165 124 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M209 155 L210 155 L210 171 L213 171 L213 173 L215 174 L216 175 L217 168 L218 171 L222 171 L222 175 L224 175 L224 177 L208 177 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M232 111 L233 113 L244 113 L250 115 L250 116 L245 116 L244 119 L241 119 L241 115 L235 115 L233 114 L233 135 L240 135 L239 145 L238 145 L238 137 L233 137 L233 143 L232 143 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M170 154 L181 154 L181 160 L174 160 L171 165 L168 165 L167 158 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M183 120 L192 120 L192 126 L194 127 L191 131 L191 125 L184 127 L181 128 L181 130 L179 130 L178 134 L178 125 Z M174 141 L176 141 L176 143 L180 145 L182 147 L202 148 L202 150 L180 150 L175 145 L173 142 Z" style="fill:';
    string private constant PART_39 = ';"/><path d="M215 127 L216 130 L218 132 L218 135 L220 135 L221 138 L219 138 L220 141 L219 143 L221 143 L221 145 L218 145 L218 147 L214 147 L214 128 Z" style="fill:';
    string private constant PART_40 = ';"/><path d="M195 161 L201 161 L201 170 L191 169 L190 168 L190 162 Z" style="fill:';
    string private constant PART_41 = ';"/><path d="M178 115 L202 115 L202 116 L180 117 L175 122 L174 140 L172 140 L172 120 L175 119 L176 116 Z" style="fill:';
    string private constant PART_42 = ';"/><path d="M218 156 L221 156 L221 171 L217 171 L216 175 L210 175 L213 173 L212 168 L214 168 L214 166 L217 165 Z" style="fill:';
    string private constant PART_43 = ';"/><path d="M177 119 L179 120 L175 125 L178 124 L179 130 L181 130 L183 133 L186 135 L184 136 L176 136 L174 140 L174 122 Z" style="fill:';
    string private constant PART_44 = ';"/><path d="M214 118 L228 118 L227 120 L218 121 L218 129 L219 132 L223 134 L223 138 L220 137 L220 135 L218 135 L215 130 L214 128 Z" style="fill:';
    string private constant PART_45 = ';"/><path d="M182 154 L187 154 L187 171 L182 171 Z" style="fill:';
    string private constant PART_46 = ';"/><path d="M215 115 L231 115 L231 125 L230 127 L228 127 L227 119 L214 118 Z" style="fill:';
    string private constant PART_47 = ';"/><path d="M206 135 L212 136 L210 143 L212 144 L211 148 L204 147 L204 137 L206 137 Z" style="fill:';
    string private constant PART_48 = ';"/><path d="M187 151 L225 151 L224 153 L219 153 L216 154 L208 155 L208 153 L188 153 Z" style="fill:';
    string private constant PART_49 = ';"/><path d="M207 130 L213 131 L213 147 L212 144 L209 143 L211 137 L210 138 L209 136 L204 137 L204 131 Z" style="fill:';
    string private constant PART_50 = ';"/><path d="M181 96 L186 96 L185 99 L182 98 L181 102 L180 103 L211 104 L211 105 L174 105 L176 104 L176 100 L179 98 Z" style="fill:';
    string private constant PART_51 = ';"/><path d="M189 154 L204 154 L205 158 L188 158 Z" style="fill:';
    string private constant PART_52 = ';"/><path d="M252 139 L253 143 L253 148 L251 149 L245 149 L245 140 L251 141 Z" style="fill:';
    string private constant PART_53 = ';"/>';
    string private constant COLOR_1 = 'hsl(223, 9%, 15%)';
    string private constant COLOR_2 = 'hsl(22, 26%, 44%)';
    string private constant COLOR_3 = 'hsl(220, 3%, 21%)';
    string private constant COLOR_4 = 'hsl(34, 4%, 36%)';
    string private constant COLOR_5 = 'hsl(216, 5%, 20%)';
    string private constant COLOR_6 = 'hsl(218, 14%, 11%)';
    string private constant COLOR_7 = 'hsl(214, 9%, 15%)';
    string private constant COLOR_8 = 'hsl(240, 2%, 23%)';
    string private constant COLOR_9 = 'hsl(223, 8%, 17%)';
    string private constant COLOR_10 = 'hsl(218, 12%, 13%)';
    string private constant COLOR_11 = 'hsl(30, 2%, 35%)';
    string private constant COLOR_12 = 'hsl(330, 2%, 17%)';
    string private constant COLOR_13 = 'hsl(220, 7%, 18%)';
    string private constant COLOR_14 = 'hsl(218, 14%, 11%)';
    string private constant COLOR_15 = 'hsl(37, 4%, 38%)';
    string private constant COLOR_16 = 'hsl(40, 3%, 36%)';
    string private constant COLOR_17 = 'hsl(223, 8%, 18%)';
    string private constant COLOR_18 = 'hsl(228, 5%, 21%)';
    string private constant COLOR_19 = 'hsl(228, 4%, 23%)';
    string private constant COLOR_20 = 'hsl(220, 6%, 20%)';
    string private constant COLOR_21 = 'hsl(21, 23%, 33%)';
    string private constant COLOR_22 = 'hsl(213, 18%, 10%)';
    string private constant COLOR_23 = 'hsl(214, 8%, 17%)';
    string private constant COLOR_24 = 'hsl(32, 6%, 46%)';
    string private constant COLOR_25 = 'hsl(20, 14%, 34%)';
    string private constant COLOR_26 = 'hsl(223, 8%, 16%)';
    string private constant COLOR_27 = 'hsl(21, 23%, 32%)';
    string private constant COLOR_28 = 'hsl(225, 3%, 23%)';
    string private constant COLOR_29 = 'hsl(223, 10%, 13%)';
    string private constant COLOR_30 = 'hsl(30, 1%, 31%)';
    string private constant COLOR_31 = 'hsl(220, 2%, 28%)';
    string private constant COLOR_32 = 'hsl(30, 1%, 33%)';
    string private constant COLOR_33 = 'hsl(210, 9%, 26%)';
    string private constant COLOR_34 = 'hsl(225, 4%, 22%)';
    string private constant COLOR_35 = 'hsl(218, 13%, 12%)';
    string private constant COLOR_36 = 'hsl(218, 17%, 9%)';
    string private constant COLOR_37 = 'hsl(20, 2%, 35%)';
    string private constant COLOR_38 = 'hsl(220, 6%, 21%)';
    string private constant COLOR_39 = 'hsl(34, 4%, 39%)';
    string private constant COLOR_40 = 'hsl(225, 3%, 25%)';
    string private constant COLOR_41 = 'hsl(30, 1%, 33%)';
    string private constant COLOR_42 = 'hsl(220, 2%, 25%)';
    string private constant COLOR_43 = 'hsl(36, 5%, 44%)';
    string private constant COLOR_44 = 'hsl(0, 1%, 32%)';
    string private constant COLOR_45 = 'hsl(24, 3%, 38%)';
    string private constant COLOR_46 = 'hsl(33, 4%, 42%)';
    string private constant COLOR_47 = 'hsl(36, 3%, 35%)';
    string private constant COLOR_48 = 'hsl(220, 18%, 10%)';
    string private constant COLOR_49 = 'hsl(34, 4%, 38%)';
    string private constant COLOR_50 = 'hsl(218, 17%, 9%)';
    string private constant COLOR_51 = 'hsl(33, 5%, 44%)';
    string private constant COLOR_52 = 'hsl(22, 27%, 43%)';

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
            PART_48,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_48) : COLOR_48,
            PART_49,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_49) : COLOR_49
        );
        result = string.concat(
            result,
            PART_50,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_50) : COLOR_50,
            PART_51,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_51) : COLOR_51,
            PART_52,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_52) : COLOR_52,
            PART_53
        );
        return result;
    }
}
