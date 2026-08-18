// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderSpecial3SelfTest {
    string private constant PART_1 = '<path d="M112 3 L114 3 L119 22 L122 23 L122 21 L127 23 L129 23 L135 19 L137 19 L138 23 L137 27 L135 27 L135 30 L140 28 L140 31 L149 30 L148 32 L146 32 L144 37 L142 41 L148 44 L152 45 L153 47 L151 47 L151 49 L158 50 L159 52 L149 53 L151 56 L147 58 L143 58 L145 64 L140 66 L142 69 L141 71 L134 70 L133 75 L127 74 L126 84 L126 88 L124 88 L118 78 L115 78 L115 81 L113 81 L109 77 L106 78 L104 82 L102 81 L102 75 L99 74 L97 71 L90 74 L88 74 L88 77 L85 78 L86 74 L90 66 L86 65 L86 60 L86 58 L82 56 L81 54 L76 54 L76 52 L71 52 L71 50 L78 50 L78 48 L84 48 L85 45 L81 44 L81 42 L87 41 L85 38 L86 34 L91 33 L94 34 L91 28 L91 25 L98 26 L99 22 L102 22 L100 19 L100 15 L104 16 L109 21 L110 16 L112 16 Z M99 27 Z M129 20 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M73 173 L74 173 L75 182 L77 189 L77 191 L79 191 L79 189 L86 190 L87 193 L96 188 L101 184 L103 184 L101 188 L98 192 L96 201 L97 204 L105 205 L104 210 L100 211 L100 213 L105 213 L111 216 L116 217 L114 219 L105 221 L103 222 L100 221 L97 222 L99 226 L96 228 L94 228 L96 235 L98 241 L88 237 L88 235 L85 237 L83 241 L80 241 L78 241 L76 242 L74 240 L71 247 L69 247 L69 252 L67 252 L66 244 L63 239 L61 242 L59 242 L55 236 L52 236 L47 237 L44 240 L39 241 L42 233 L44 233 L44 228 L46 226 L44 224 L44 220 L42 220 L42 218 L37 218 L27 214 L25 212 L31 210 L37 210 L37 208 L41 207 L40 204 L42 204 L42 202 L49 201 L44 192 L43 189 L48 190 L54 193 L55 189 L56 186 L61 188 L64 186 L68 190 L69 184 L72 176 Z M40 220 L42 221 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M220 4 L222 4 L221 20 L223 20 L223 23 L228 21 L226 25 L228 25 L234 21 L237 21 L236 29 L239 29 L241 33 L241 38 L238 40 L241 41 L241 43 L248 43 L253 44 L253 46 L245 49 L243 50 L246 52 L245 55 L243 55 L244 61 L241 63 L236 63 L236 69 L230 69 L232 75 L234 79 L234 84 L232 83 L232 81 L228 79 L227 74 L222 74 L218 76 L215 73 L213 77 L210 84 L207 83 L205 73 L199 74 L197 66 L192 69 L186 71 L182 71 L182 69 L185 66 L185 64 L187 63 L188 57 L190 56 L182 56 L183 54 L186 54 L186 51 L182 52 L173 49 L173 46 L182 44 L185 44 L183 38 L181 33 L186 35 L186 33 L191 33 L191 31 L189 29 L189 24 L187 24 L186 17 L191 18 L196 21 L198 24 L203 23 L204 18 L208 18 L212 22 L214 17 L216 17 L216 10 L219 7 Z M207 84 L208 88 L206 89 Z M188 29 Z M187 27 Z M236 69 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M171 183 L173 183 L175 191 L175 196 L178 196 L183 197 L187 199 L189 198 L192 201 L191 206 L197 208 L194 214 L202 215 L203 218 L194 222 L196 228 L191 229 L191 233 L193 233 L195 239 L193 241 L187 239 L184 237 L183 240 L180 241 L179 243 L175 242 L174 241 L170 250 L168 250 L168 247 L166 247 L165 242 L159 244 L157 241 L153 243 L153 245 L148 247 L149 238 L145 238 L145 233 L147 230 L135 228 L135 224 L139 222 L142 222 L138 218 L139 213 L142 212 L141 209 L144 207 L139 200 L139 197 L136 196 L139 195 L151 201 L152 196 L156 196 L158 192 L161 193 L162 195 L166 196 L169 190 Z M175 198 Z M183 199 L182 201 L184 201 Z M147 247 Z M191 198 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M60 73 L62 73 L61 79 L58 86 L60 86 L60 84 L62 85 L60 88 L66 91 L67 89 L69 90 L69 92 L62 94 L63 99 L61 99 L60 102 L56 104 L54 103 L53 109 L51 105 L48 102 L43 106 L41 105 L44 101 L44 99 L40 98 L42 94 L40 91 L44 90 L43 84 L48 87 L47 84 L51 82 L53 84 L56 79 Z M51 103 Z M40 82 L43 83 L40 83 Z M59 105 Z M58 104 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M249 33 L254 33 L254 36 L252 36 L252 38 L247 38 L247 35 L249 35 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M191 78 L194 79 L192 84 L188 85 L190 79 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M131 212 L135 214 L135 217 L130 217 L130 215 L128 214 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M194 192 L198 192 L198 194 L196 194 L195 198 L192 197 Z M198 191 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M150 61 L154 62 L157 65 L157 67 L152 65 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M251 52 L255 53 L255 57 L250 55 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M171 25 L176 27 L177 31 L173 30 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M245 24 L249 25 L248 27 L246 27 L246 29 L242 29 L244 25 Z M71 88 L75 89 L73 90 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M109 201 L114 201 L110 205 L108 205 Z M205 215 L208 216 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M72 58 L75 59 L73 62 L69 61 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M72 27 L77 28 L79 29 L79 31 L75 30 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M202 225 L207 226 L208 228 L203 228 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M85 179 L87 179 L87 183 L83 184 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M34 194 L38 195 L40 198 L36 197 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M76 39 L79 40 L79 42 L74 42 Z M226 9 L228 9 L227 13 L225 12 Z M49 244 L52 244 L51 247 L49 247 Z M198 78 L200 78 L198 82 L197 80 Z M81 68 L82 70 L81 72 L79 72 Z M123 17 L125 17 L125 20 L123 20 Z M242 14 L244 14 L244 16 L241 17 Z M148 190 L150 191 L149 194 Z M225 17 L227 17 L226 20 Z M194 7 L196 7 L195 10 Z M31 204 L33 204 L33 206 L31 206 Z M203 200 L205 201 L202 201 Z M44 78 L46 78 L46 80 L44 80 Z M142 230 L143 232 L141 231 Z M34 89 L37 90 Z M240 77 L242 79 L240 79 Z M152 37 L153 39 L151 38 Z M89 245 Z M35 221 L37 222 Z M37 204 L39 205 Z M26 199 Z M86 189 L88 190 Z M62 182 Z M181 60 Z M146 60 L148 61 Z M185 57 L187 58 Z M244 39 Z M182 11 Z M102 244 Z M101 243 Z M87 242 Z M98 230 Z M117 218 Z M139 209 Z M42 198 Z M80 186 Z M41 185 Z M49 178 Z M39 99 Z M174 78 Z M134 77 Z M63 70 Z M81 65 Z M83 64 Z M61 48 Z M85 29 Z M143 25 Z M239 18 Z M185 15 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M140 10 L141 14 L138 16 L139 11 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M35 230 L36 233 L32 235 L34 231 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M102 223 L106 223 L105 226 L102 225 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M107 228 L111 229 L111 231 L107 230 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M179 72 L181 74 L178 77 L178 74 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M183 243 L186 244 L186 246 L183 246 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M135 233 L138 234 L136 234 L136 236 L133 235 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M246 71 L250 73 L247 74 Z M180 191 L180 194 Z M214 81 L214 84 Z M160 52 L162 52 L162 54 L160 54 Z M146 78 L148 78 L147 80 Z M145 77 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M176 63 L178 63 L177 66 L174 67 L174 65 L176 65 Z M146 70 L148 70 L148 72 L146 72 Z M70 75 L71 77 L69 76 Z M150 25 L152 26 L150 27 Z M91 185 Z M173 180 Z M106 15 Z M68 77 Z M152 24 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M196 241 L200 243 L199 245 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M51 183 L54 185 L53 188 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M176 42 L180 43 L176 44 Z M81 16 L83 17 L83 19 L81 19 Z M83 19 Z M80 15 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M39 224 L43 225 L39 225 Z M38 181 L41 183 L40 185 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M28 221 L30 221 L30 223 L26 222 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M168 45 L171 45 L171 47 L168 47 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M88 18 L91 20 L90 22 Z M118 89 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M65 99 L68 99 L68 101 L65 100 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M93 83 L94 86 L92 86 Z M141 72 L144 73 L141 74 Z" style="fill:';
    string private constant PART_39 = ';"/><path d="M145 22 L147 23 L144 25 Z" style="fill:';
    string private constant PART_40 = ';"/><path d="M203 10 L205 10 L204 13 Z" style="fill:';
    string private constant PART_41 = ';"/><path d="M130 225 L132 225 L132 227 L130 227 Z M196 70 L196 73 Z" style="fill:';
    string private constant PART_42 = ';"/><path d="M48 104 L48 107 Z" style="fill:';
    string private constant PART_43 = ';"/><path d="M111 82 L113 82 L113 84 L111 84 Z" style="fill:';
    string private constant PART_44 = ';"/><path d="M78 244 Z M163 188 Z M119 13 Z M238 68 L240 69 Z M240 69 Z" style="fill:';
    string private constant PART_45 = ';"/><path d="M98 201 L101 202 Z M158 246 Z M135 205 Z M105 195 L107 196 Z M133 193 L135 194 Z M179 55 L181 56 Z M142 241 Z M199 235 Z M198 234 Z M102 233 Z M99 231 Z M199 223 Z M140 210 Z M107 210 Z M197 205 Z M107 194 Z M107 180 Z M61 102 Z M187 89 Z M102 85 Z M224 79 Z M237 71 Z M146 39 Z M154 36 Z M155 35 Z M83 34 Z M82 33 Z M230 19 Z M201 18 Z M150 18 Z M79 14 Z M231 10 Z" style="fill:';
    string private constant PART_46 = ';"/><path d="M62 82 L64 83 L62 84 Z" style="fill:';
    string private constant PART_47 = ';"/><path d="M97 77 L98 79 L96 78 Z M98 76 Z" style="fill:';
    string private constant PART_48 = ';"/><path d="M131 14 Z" style="fill:';
    string private constant PART_49 = ';"/><path d="M58 244 Z M34 243 Z M53 239 Z M66 85 Z" style="fill:';
    string private constant PART_50 = ';"/><path d="M136 221 L138 222 Z M176 57 L178 58 Z M71 38 L73 39 Z M95 16 Z" style="fill:';
    string private constant PART_51 = ';"/><path d="M177 247 Z M143 240 Z M99 75 Z M78 57 Z" style="fill:';
    string private constant PART_52 = ';"/>';
    string private constant COLOR_1 = 'hsl(25, 67%, 38%)';
    string private constant COLOR_2 = 'hsl(24, 69%, 37%)';
    string private constant COLOR_3 = 'hsl(24, 67%, 38%)';
    string private constant COLOR_4 = 'hsl(23, 68%, 37%)';
    string private constant COLOR_5 = 'hsl(26, 73%, 45%)';
    string private constant COLOR_6 = 'hsl(25, 75%, 43%)';
    string private constant COLOR_7 = 'hsl(26, 73%, 44%)';
    string private constant COLOR_8 = 'hsl(24, 74%, 41%)';
    string private constant COLOR_9 = 'hsl(15, 68%, 27%)';
    string private constant COLOR_10 = 'hsl(23, 75%, 39%)';
    string private constant COLOR_11 = 'hsl(22, 77%, 37%)';
    string private constant COLOR_12 = 'hsl(26, 73%, 45%)';
    string private constant COLOR_13 = 'hsl(22, 77%, 37%)';
    string private constant COLOR_14 = 'hsl(19, 72%, 31%)';
    string private constant COLOR_15 = 'hsl(25, 77%, 45%)';
    string private constant COLOR_16 = 'hsl(17, 63%, 28%)';
    string private constant COLOR_17 = 'hsl(23, 78%, 40%)';
    string private constant COLOR_18 = 'hsl(20, 73%, 33%)';
    string private constant COLOR_19 = 'hsl(16, 60%, 27%)';
    string private constant COLOR_20 = 'hsl(11, 63%, 24%)';
    string private constant COLOR_21 = 'hsl(22, 77%, 38%)';
    string private constant COLOR_22 = 'hsl(25, 74%, 42%)';
    string private constant COLOR_23 = 'hsl(29, 68%, 50%)';
    string private constant COLOR_24 = 'hsl(26, 74%, 44%)';
    string private constant COLOR_25 = 'hsl(22, 66%, 34%)';
    string private constant COLOR_26 = 'hsl(19, 73%, 32%)';
    string private constant COLOR_27 = 'hsl(24, 80%, 44%)';
    string private constant COLOR_28 = 'hsl(17, 71%, 30%)';
    string private constant COLOR_29 = 'hsl(21, 76%, 35%)';
    string private constant COLOR_30 = 'hsl(23, 66%, 36%)';
    string private constant COLOR_31 = 'hsl(25, 69%, 40%)';
    string private constant COLOR_32 = 'hsl(15, 68%, 27%)';
    string private constant COLOR_33 = 'hsl(15, 69%, 28%)';
    string private constant COLOR_34 = 'hsl(30, 77%, 53%)';
    string private constant COLOR_35 = 'hsl(21, 58%, 31%)';
    string private constant COLOR_36 = 'hsl(30, 62%, 45%)';
    string private constant COLOR_37 = 'hsl(24, 79%, 42%)';
    string private constant COLOR_38 = 'hsl(20, 74%, 33%)';
    string private constant COLOR_39 = 'hsl(27, 70%, 46%)';
    string private constant COLOR_40 = 'hsl(17, 70%, 28%)';
    string private constant COLOR_41 = 'hsl(28, 67%, 46%)';
    string private constant COLOR_42 = 'hsl(29, 75%, 51%)';
    string private constant COLOR_43 = 'hsl(27, 63%, 40%)';
    string private constant COLOR_44 = 'hsl(28, 54%, 38%)';
    string private constant COLOR_45 = 'hsl(25, 82%, 47%)';
    string private constant COLOR_46 = 'hsl(37, 84%, 59%)';
    string private constant COLOR_47 = 'hsl(24, 56%, 35%)';
    string private constant COLOR_48 = 'hsl(22, 78%, 39%)';
    string private constant COLOR_49 = 'hsl(34, 79%, 56%)';
    string private constant COLOR_50 = 'hsl(33, 52%, 45%)';
    string private constant COLOR_51 = 'hsl(44, 93%, 66%)';

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
            PART_52
        );
        return result;
    }
}
