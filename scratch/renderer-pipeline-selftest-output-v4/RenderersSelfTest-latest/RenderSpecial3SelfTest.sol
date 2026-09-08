// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderSpecial3SelfTest {
    string private constant PART_1 = '<path d="M112 3 L114 3 L119 22 L122 23 L122 21 L127 23 L129 23 L135 19 L137 19 L138 23 L137 27 L135 27 L135 30 L140 28 L140 31 L149 30 L148 32 L146 32 L144 37 L142 41 L148 44 L152 45 L153 47 L151 47 L151 49 L158 50 L159 52 L149 53 L151 56 L147 58 L143 58 L145 64 L140 66 L142 69 L141 71 L134 70 L133 75 L127 74 L126 84 L126 88 L124 88 L118 78 L115 78 L115 81 L113 81 L109 77 L106 78 L104 82 L102 81 L102 75 L99 74 L97 71 L90 74 L88 74 L88 77 L85 78 L86 74 L90 66 L86 65 L86 60 L86 58 L82 56 L81 54 L76 54 L76 52 L71 52 L71 50 L78 50 L78 48 L84 48 L85 45 L81 44 L81 42 L87 41 L85 38 L86 34 L91 33 L94 34 L91 28 L91 25 L98 26 L99 22 L102 22 L100 19 L100 15 L104 16 L109 21 L110 16 L112 16 Z M99 27 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M73 173 L74 173 L75 182 L77 189 L77 191 L79 191 L79 189 L86 190 L87 193 L96 188 L101 184 L103 184 L101 188 L98 192 L96 201 L97 204 L105 205 L104 210 L100 211 L100 213 L105 213 L111 216 L116 217 L114 219 L105 221 L103 222 L100 221 L97 222 L99 226 L96 228 L94 228 L96 235 L98 241 L88 237 L88 235 L85 237 L83 241 L80 241 L78 241 L76 242 L74 240 L71 247 L69 247 L69 252 L67 252 L66 244 L63 239 L61 242 L59 242 L55 236 L52 236 L47 237 L44 240 L39 241 L42 233 L44 233 L44 228 L46 226 L44 224 L44 220 L42 220 L42 218 L37 218 L27 214 L25 212 L31 210 L37 210 L37 208 L41 207 L40 204 L42 204 L42 202 L49 201 L44 192 L43 189 L48 190 L54 193 L55 189 L56 186 L61 188 L64 186 L68 190 L69 184 L72 176 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M220 4 L222 4 L221 20 L223 20 L223 23 L228 21 L226 25 L228 25 L234 21 L237 21 L236 29 L239 29 L241 33 L241 38 L238 40 L241 41 L241 43 L248 43 L253 44 L253 46 L245 49 L243 50 L246 52 L245 55 L243 55 L244 61 L241 63 L236 63 L236 69 L230 69 L232 75 L234 79 L234 84 L232 83 L232 81 L228 79 L227 74 L222 74 L218 76 L215 73 L213 77 L210 84 L207 83 L205 73 L199 74 L197 66 L192 69 L186 71 L182 71 L182 69 L185 66 L185 64 L187 63 L188 57 L190 56 L182 56 L183 54 L186 54 L186 51 L182 52 L173 49 L173 46 L182 44 L185 44 L183 38 L181 33 L186 35 L186 33 L191 33 L191 31 L189 29 L189 24 L187 24 L186 17 L191 18 L196 21 L198 24 L203 23 L204 18 L208 18 L212 22 L214 17 L216 17 L216 10 L219 7 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M171 183 L173 183 L175 191 L175 196 L178 196 L183 197 L187 199 L189 198 L192 201 L191 206 L197 208 L194 214 L202 215 L203 218 L194 222 L196 228 L191 229 L191 233 L193 233 L195 239 L193 241 L187 239 L184 237 L183 240 L180 241 L179 243 L175 242 L174 241 L170 250 L168 250 L168 247 L166 247 L165 242 L159 244 L157 241 L153 243 L153 245 L148 247 L149 238 L145 238 L145 233 L147 230 L135 228 L135 224 L139 222 L142 222 L138 218 L139 213 L142 212 L141 209 L144 207 L139 200 L139 197 L136 196 L139 195 L151 201 L152 196 L156 196 L158 192 L161 193 L162 195 L166 196 L169 190 Z M175 198 Z M183 199 L182 201 L184 201 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M218 17 L219 19 L218 22 L221 22 L220 30 L224 32 L228 33 L226 33 L227 38 L231 34 L235 34 L234 37 L232 38 L230 43 L228 43 L229 46 L233 47 L234 44 L236 44 L236 46 L241 46 L239 48 L232 48 L233 53 L236 53 L237 58 L231 60 L231 61 L226 61 L227 68 L224 68 L219 66 L219 69 L215 68 L212 69 L212 75 L210 75 L209 77 L207 75 L207 68 L208 66 L206 67 L205 71 L201 72 L203 67 L201 67 L202 62 L197 64 L196 61 L193 62 L194 55 L192 51 L186 50 L187 47 L190 45 L189 43 L192 40 L200 40 L197 31 L194 27 L195 25 L199 27 L199 30 L205 32 L206 26 L209 26 L210 29 L214 30 L216 23 L217 18 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M114 19 L116 23 L118 31 L122 29 L122 34 L126 33 L128 34 L128 39 L135 39 L133 43 L131 43 L131 45 L129 45 L129 48 L137 48 L140 49 L140 47 L143 48 L141 51 L144 52 L143 55 L136 57 L139 59 L139 61 L134 60 L134 62 L136 63 L131 64 L131 70 L129 72 L125 72 L124 76 L120 75 L119 71 L114 72 L110 73 L110 70 L108 70 L107 76 L103 78 L105 68 L102 68 L102 64 L98 64 L98 60 L101 59 L100 55 L95 53 L95 48 L92 47 L93 45 L96 45 L97 42 L95 40 L97 39 L102 40 L103 38 L101 38 L101 35 L99 34 L106 34 L107 32 L105 31 L106 26 L108 26 L109 30 L112 30 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M71 188 L73 188 L74 197 L80 197 L79 202 L82 201 L84 204 L84 207 L87 208 L87 210 L84 210 L84 212 L91 213 L95 214 L96 216 L90 217 L90 219 L87 220 L88 222 L85 224 L87 228 L85 229 L80 227 L80 230 L77 230 L77 228 L72 229 L72 233 L68 235 L66 230 L63 233 L63 225 L61 225 L56 226 L56 224 L53 223 L55 221 L58 219 L59 216 L54 215 L54 213 L58 213 L58 211 L60 211 L60 209 L58 208 L58 204 L55 203 L56 201 L61 203 L62 201 L66 202 L68 199 L68 196 L70 196 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M73 173 L74 173 L75 182 L77 189 L77 191 L79 191 L79 189 L86 190 L87 193 L96 188 L101 184 L103 184 L101 188 L98 192 L96 201 L97 204 L105 205 L104 210 L100 211 L100 213 L105 213 L111 216 L116 217 L114 219 L105 221 L103 222 L100 221 L97 222 L99 226 L96 228 L94 228 L96 235 L98 241 L88 237 L88 235 L85 237 L83 241 L80 241 L78 241 L76 242 L74 240 L71 247 L69 247 L69 252 L67 252 L66 244 L64 242 L64 237 L66 236 L65 241 L69 242 L72 237 L75 232 L77 232 L77 234 L81 234 L82 232 L90 232 L91 227 L88 226 L88 225 L93 225 L94 222 L96 222 L97 217 L99 215 L95 214 L95 212 L93 211 L98 208 L89 208 L89 205 L87 204 L88 202 L90 202 L91 197 L84 197 L83 199 L81 193 L76 195 L75 193 L75 186 L73 186 L73 184 L71 184 L69 191 L68 187 L72 176 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M171 183 L173 183 L175 191 L175 196 L178 196 L183 197 L187 199 L189 198 L192 201 L191 206 L197 208 L194 214 L202 215 L203 218 L194 222 L196 228 L191 229 L191 233 L193 233 L195 239 L193 241 L187 239 L184 237 L183 240 L180 241 L179 243 L175 242 L174 241 L172 244 L170 244 L173 235 L175 235 L179 234 L181 230 L183 230 L184 225 L186 224 L184 220 L189 218 L185 215 L187 215 L186 213 L185 214 L180 214 L183 208 L179 208 L176 210 L178 203 L175 203 L173 198 L172 192 L171 194 L169 194 L169 196 L167 196 L169 189 Z M175 198 Z M183 199 L182 201 L184 201 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M216 35 L217 37 L216 41 L220 42 L221 40 L226 39 L225 47 L229 47 L229 54 L231 55 L227 55 L223 60 L225 65 L222 65 L219 63 L215 64 L215 66 L213 66 L212 68 L207 65 L205 60 L206 56 L196 59 L196 55 L201 55 L201 53 L203 53 L203 50 L201 50 L198 44 L206 43 L205 40 L209 36 L215 36 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M71 184 L73 184 L73 186 L75 186 L76 193 L78 193 L81 193 L83 198 L89 196 L91 197 L90 202 L88 202 L89 208 L92 207 L99 207 L96 210 L94 211 L95 215 L89 215 L88 213 L84 212 L84 210 L87 210 L84 207 L84 204 L82 203 L79 202 L78 198 L74 197 L73 192 L73 188 L71 188 L70 196 L68 196 L69 200 L65 203 L65 201 L62 201 L61 204 L56 202 L59 206 L60 211 L58 211 L58 213 L54 213 L54 215 L59 216 L59 221 L54 223 L56 224 L56 226 L63 223 L64 227 L57 230 L50 231 L49 234 L46 233 L49 228 L51 226 L51 221 L49 221 L50 216 L48 216 L47 212 L49 204 L53 204 L52 196 L58 197 L60 192 L63 193 L63 195 L65 195 L66 190 L69 190 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M109 34 L112 35 L113 37 L115 34 L117 36 L117 39 L123 38 L124 41 L128 44 L127 48 L135 49 L135 52 L128 53 L128 56 L130 56 L132 61 L127 59 L124 58 L124 62 L122 61 L122 59 L120 59 L121 63 L117 60 L117 54 L114 54 L113 61 L110 60 L109 58 L104 57 L105 54 L107 54 L105 52 L101 52 L101 49 L99 49 L99 46 L101 46 L101 43 L103 43 L104 38 L109 39 L108 36 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M169 204 L171 207 L170 209 L176 207 L178 209 L179 215 L183 216 L179 220 L178 221 L180 222 L181 227 L176 230 L172 229 L167 233 L167 230 L165 230 L164 232 L164 229 L158 233 L156 233 L157 228 L159 228 L159 225 L150 224 L153 221 L155 221 L156 218 L155 213 L153 212 L159 211 L159 213 L161 213 L162 207 L167 208 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M60 73 L62 73 L61 79 L58 86 L60 86 L60 84 L62 85 L60 88 L66 91 L67 89 L69 90 L69 92 L62 94 L63 99 L61 99 L60 102 L56 104 L54 103 L53 109 L51 105 L48 102 L43 106 L41 105 L44 101 L44 99 L40 98 L42 94 L40 91 L44 90 L43 84 L48 87 L47 84 L51 82 L53 84 L56 79 Z M51 103 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M190 42 L194 42 L194 45 L197 46 L192 47 L192 49 L197 50 L200 53 L197 57 L196 59 L205 55 L207 56 L206 61 L210 66 L213 66 L215 66 L215 64 L218 63 L220 61 L220 64 L224 65 L222 58 L227 54 L229 54 L229 51 L227 50 L229 50 L229 47 L233 47 L234 44 L236 44 L236 46 L241 46 L239 48 L232 48 L233 53 L236 53 L237 58 L231 60 L231 61 L226 61 L227 68 L224 68 L219 66 L219 69 L215 68 L212 69 L212 75 L210 75 L209 77 L207 75 L207 68 L208 66 L206 67 L205 71 L201 72 L203 67 L201 67 L202 62 L197 64 L196 61 L193 62 L194 55 L192 51 L186 50 L187 47 L190 45 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M114 19 L116 23 L118 31 L122 29 L122 34 L126 33 L128 34 L128 39 L135 39 L133 43 L131 43 L131 45 L129 45 L127 49 L126 45 L126 43 L121 39 L117 39 L115 35 L113 39 L112 35 L109 36 L110 40 L106 39 L104 38 L103 43 L101 43 L101 46 L99 46 L99 49 L101 49 L101 52 L103 52 L104 50 L107 52 L107 54 L105 55 L105 57 L110 58 L109 61 L105 60 L101 61 L100 64 L98 64 L98 60 L101 59 L100 55 L95 53 L95 48 L92 47 L93 45 L96 45 L97 42 L95 40 L97 39 L102 40 L103 38 L101 38 L101 35 L99 34 L106 34 L107 32 L105 31 L106 26 L108 26 L109 30 L112 30 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M148 53 L151 56 L147 58 L143 58 L145 64 L140 66 L142 69 L141 71 L134 70 L133 75 L127 74 L126 84 L126 88 L124 88 L118 78 L115 78 L115 81 L113 81 L109 77 L106 78 L104 82 L102 81 L103 77 L106 76 L108 70 L110 70 L110 73 L113 72 L115 70 L120 71 L120 75 L124 76 L123 73 L126 70 L130 70 L131 64 L135 63 L134 60 L139 61 L139 59 L134 57 L134 56 L143 55 L147 54 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M169 197 L173 199 L174 204 L177 204 L177 202 L179 203 L177 208 L170 209 L169 205 L167 208 L162 207 L161 213 L159 213 L159 211 L155 213 L157 219 L155 219 L155 221 L152 223 L159 225 L159 228 L157 230 L155 232 L155 230 L153 230 L152 226 L146 225 L149 219 L141 217 L141 216 L149 214 L151 209 L146 206 L144 202 L147 201 L147 203 L155 205 L157 204 L159 198 L162 198 L162 202 L164 202 L165 204 L167 204 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M180 206 L185 208 L181 213 L187 212 L188 216 L190 219 L184 220 L187 225 L184 227 L183 230 L179 234 L176 236 L173 236 L171 242 L170 244 L172 245 L170 247 L168 245 L169 243 L167 243 L166 238 L163 237 L162 240 L160 239 L159 235 L155 238 L153 237 L154 233 L161 230 L165 230 L169 230 L171 230 L172 228 L176 229 L178 227 L180 226 L180 222 L177 221 L182 216 L179 215 L178 208 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M249 33 L254 33 L254 36 L252 36 L252 38 L247 38 L247 35 L249 35 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M191 78 L194 79 L192 84 L188 85 L190 79 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M131 212 L135 214 L135 217 L130 217 L130 215 L128 214 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M194 192 L198 192 L198 194 L196 194 L195 198 L192 197 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M150 61 L154 62 L157 65 L157 67 L152 65 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M251 52 L255 53 L255 57 L250 55 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M171 25 L176 27 L177 31 L173 30 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M245 24 L249 25 L248 27 L246 27 L246 29 L242 29 L244 25 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M109 201 L114 201 L110 205 L108 205 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M72 58 L75 59 L73 62 L69 61 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M72 27 L77 28 L79 29 L79 31 L75 30 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M202 225 L207 226 L208 228 L203 228 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M85 179 L87 179 L87 183 L83 184 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M34 194 L38 195 L40 198 L36 197 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M76 39 L79 40 L79 42 L74 42 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M140 10 L141 14 L138 16 L139 11 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M35 230 L36 233 L32 235 L34 231 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M102 223 L106 223 L105 226 L102 225 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M107 228 L111 229 L111 231 L107 230 Z" style="fill:';
    string private constant PART_39 = ';"/><path d="M179 72 L181 74 L178 77 L178 74 Z" style="fill:';
    string private constant PART_40 = ';"/><path d="M226 9 L228 9 L227 13 L225 12 Z" style="fill:';
    string private constant PART_41 = ';"/><path d="M183 243 L186 244 L186 246 L183 246 Z" style="fill:';
    string private constant PART_42 = ';"/><path d="M49 244 L52 244 L51 247 L49 247 Z" style="fill:';
    string private constant PART_43 = ';"/><path d="M135 233 L138 234 L136 234 L136 236 L133 235 Z" style="fill:';
    string private constant PART_44 = ';"/><path d="M207 84 L208 88 L206 89 Z" style="fill:';
    string private constant PART_45 = ';"/><path d="M246 71 L250 73 L247 74 Z" style="fill:';
    string private constant PART_46 = ';"/><path d="M176 63 L178 63 L177 66 L174 67 L174 65 L176 65 Z" style="fill:';
    string private constant PART_47 = ';"/><path d="M196 241 L200 243 L199 245 Z" style="fill:';
    string private constant PART_48 = ';"/><path d="M51 183 L54 185 L53 188 Z" style="fill:';
    string private constant PART_49 = ';"/><path d="M198 78 L200 78 L198 82 L197 80 Z" style="fill:';
    string private constant PART_50 = ';"/><path d="M81 68 L82 70 L81 72 L79 72 Z" style="fill:';
    string private constant PART_51 = ';"/><path d="M176 42 L180 43 L176 44 Z" style="fill:';
    string private constant PART_52 = ';"/><path d="M39 224 L43 225 L39 225 Z" style="fill:';
    string private constant PART_53 = ';"/><path d="M28 221 L30 221 L30 223 L26 222 Z" style="fill:';
    string private constant PART_54 = ';"/><path d="M38 181 L41 183 L40 185 Z" style="fill:';
    string private constant PART_55 = ';"/><path d="M168 45 L171 45 L171 47 L168 47 Z" style="fill:';
    string private constant PART_56 = ';"/><path d="M88 18 L91 20 L90 22 Z" style="fill:';
    string private constant PART_57 = ';"/><path d="M123 17 L125 17 L125 20 L123 20 Z" style="fill:';
    string private constant PART_58 = ';"/><path d="M242 14 L244 14 L244 16 L241 17 Z" style="fill:';
    string private constant PART_59 = ';"/><path d="M148 190 L150 191 L149 194 Z" style="fill:';
    string private constant PART_60 = ';"/><path d="M65 99 L68 99 L68 101 L65 100 Z" style="fill:';
    string private constant PART_61 = ';"/><path d="M71 88 L75 89 L73 90 Z" style="fill:';
    string private constant PART_62 = ';"/><path d="M93 83 L94 86 L92 86 Z" style="fill:';
    string private constant PART_63 = ';"/><path d="M141 72 L144 73 L141 74 Z" style="fill:';
    string private constant PART_64 = ';"/><path d="M145 22 L147 23 L144 25 Z" style="fill:';
    string private constant PART_65 = ';"/><path d="M225 17 L227 17 L226 20 Z" style="fill:';
    string private constant PART_66 = ';"/><path d="M81 16 L83 17 L83 19 L81 19 Z" style="fill:';
    string private constant PART_67 = ';"/><path d="M203 10 L205 10 L204 13 Z" style="fill:';
    string private constant PART_68 = ';"/><path d="M194 7 L196 7 L195 10 Z" style="fill:';
    string private constant PART_69 = ';"/><path d="M130 225 L132 225 L132 227 L130 227 Z" style="fill:';
    string private constant PART_70 = ';"/><path d="M31 204 L33 204 L33 206 L31 206 Z" style="fill:';
    string private constant PART_71 = ';"/><path d="M203 200 L205 201 L202 201 Z" style="fill:';
    string private constant PART_72 = ';"/><path d="M180 191 L180 194 Z" style="fill:';
    string private constant PART_73 = ';"/><path d="M48 104 L48 107 Z" style="fill:';
    string private constant PART_74 = ';"/><path d="M111 82 L113 82 L113 84 L111 84 Z" style="fill:';
    string private constant PART_75 = ';"/><path d="M40 82 L43 83 L40 83 Z" style="fill:';
    string private constant PART_76 = ';"/><path d="M214 81 L214 84 Z" style="fill:';
    string private constant PART_77 = ';"/><path d="M44 78 L46 78 L46 80 L44 80 Z" style="fill:';
    string private constant PART_78 = ';"/><path d="M196 70 L196 73 Z" style="fill:';
    string private constant PART_79 = ';"/><path d="M146 70 L148 70 L148 72 L146 72 Z" style="fill:';
    string private constant PART_80 = ';"/><path d="M160 52 L162 52 L162 54 L160 54 Z" style="fill:';
    string private constant PART_81 = ';"/><path d="M78 244 Z" style="fill:';
    string private constant PART_82 = ';"/><path d="M142 230 L143 232 L141 231 Z" style="fill:';
    string private constant PART_83 = ';"/><path d="M205 215 L208 216 Z" style="fill:';
    string private constant PART_84 = ';"/><path d="M98 201 L101 202 Z" style="fill:';
    string private constant PART_85 = ';"/><path d="M163 188 Z" style="fill:';
    string private constant PART_86 = ';"/><path d="M118 89 Z" style="fill:';
    string private constant PART_87 = ';"/><path d="M34 89 L37 90 Z" style="fill:';
    string private constant PART_88 = ';"/><path d="M62 82 L64 83 L62 84 Z" style="fill:';
    string private constant PART_89 = ';"/><path d="M240 77 L242 79 L240 79 Z" style="fill:';
    string private constant PART_90 = ';"/><path d="M146 78 L148 78 L147 80 Z" style="fill:';
    string private constant PART_91 = ';"/><path d="M97 77 L98 79 L96 78 Z" style="fill:';
    string private constant PART_92 = ';"/><path d="M70 75 L71 77 L69 76 Z" style="fill:';
    string private constant PART_93 = ';"/><path d="M152 37 L153 39 L151 38 Z" style="fill:';
    string private constant PART_94 = ';"/><path d="M150 25 L152 26 L150 27 Z" style="fill:';
    string private constant PART_95 = ';"/><path d="M131 14 Z" style="fill:';
    string private constant PART_96 = ';"/><path d="M119 13 Z" style="fill:';
    string private constant PART_97 = ';"/><path d="M147 247 Z" style="fill:';
    string private constant PART_98 = ';"/><path d="M158 246 Z" style="fill:';
    string private constant PART_99 = ';"/><path d="M89 245 Z" style="fill:';
    string private constant PART_100 = ';"/><path d="M58 244 Z" style="fill:';
    string private constant PART_101 = ';"/><path d="M34 243 Z" style="fill:';
    string private constant PART_102 = ';"/><path d="M53 239 Z" style="fill:';
    string private constant PART_103 = ';"/><path d="M136 221 L138 222 Z" style="fill:';
    string private constant PART_104 = ';"/><path d="M35 221 L37 222 Z" style="fill:';
    string private constant PART_105 = ';"/><path d="M40 220 L42 221 Z" style="fill:';
    string private constant PART_106 = ';"/><path d="M135 205 Z" style="fill:';
    string private constant PART_107 = ';"/><path d="M37 204 L39 205 Z" style="fill:';
    string private constant PART_108 = ';"/><path d="M26 199 Z" style="fill:';
    string private constant PART_109 = ';"/><path d="M105 195 L107 196 Z" style="fill:';
    string private constant PART_110 = ';"/><path d="M133 193 L135 194 Z" style="fill:';
    string private constant PART_111 = ';"/><path d="M86 189 L88 190 Z" style="fill:';
    string private constant PART_112 = ';"/><path d="M91 185 Z" style="fill:';
    string private constant PART_113 = ';"/><path d="M62 182 Z" style="fill:';
    string private constant PART_114 = ';"/><path d="M173 180 Z" style="fill:';
    string private constant PART_115 = ';"/><path d="M66 85 Z" style="fill:';
    string private constant PART_116 = ';"/><path d="M238 68 L240 69 Z" style="fill:';
    string private constant PART_117 = ';"/><path d="M181 60 Z" style="fill:';
    string private constant PART_118 = ';"/><path d="M146 60 L148 61 Z" style="fill:';
    string private constant PART_119 = ';"/><path d="M185 57 L187 58 Z" style="fill:';
    string private constant PART_120 = ';"/><path d="M176 57 L178 58 Z" style="fill:';
    string private constant PART_121 = ';"/><path d="M179 55 L181 56 Z" style="fill:';
    string private constant PART_122 = ';"/><path d="M244 39 Z" style="fill:';
    string private constant PART_123 = ';"/><path d="M71 38 L73 39 Z" style="fill:';
    string private constant PART_124 = ';"/><path d="M188 29 Z" style="fill:';
    string private constant PART_125 = ';"/><path d="M187 27 Z" style="fill:';
    string private constant PART_126 = ';"/><path d="M129 20 Z" style="fill:';
    string private constant PART_127 = ';"/><path d="M95 16 Z" style="fill:';
    string private constant PART_128 = ';"/><path d="M106 15 Z" style="fill:';
    string private constant PART_129 = ';"/><path d="M182 11 Z" style="fill:';
    string private constant PART_130 = ';"/><path d="M177 247 Z" style="fill:';
    string private constant PART_131 = ';"/><path d="M102 244 Z" style="fill:';
    string private constant PART_132 = ';"/><path d="M101 243 Z" style="fill:';
    string private constant PART_133 = ';"/><path d="M87 242 Z" style="fill:';
    string private constant PART_134 = ';"/><path d="M142 241 Z" style="fill:';
    string private constant PART_135 = ';"/><path d="M143 240 Z" style="fill:';
    string private constant PART_136 = ';"/><path d="M199 235 Z" style="fill:';
    string private constant PART_137 = ';"/><path d="M198 234 Z" style="fill:';
    string private constant PART_138 = ';"/><path d="M102 233 Z" style="fill:';
    string private constant PART_139 = ';"/><path d="M99 231 Z" style="fill:';
    string private constant PART_140 = ';"/><path d="M98 230 Z" style="fill:';
    string private constant PART_141 = ';"/><path d="M199 223 Z" style="fill:';
    string private constant PART_142 = ';"/><path d="M117 218 Z" style="fill:';
    string private constant PART_143 = ';"/><path d="M140 210 Z" style="fill:';
    string private constant PART_144 = ';"/><path d="M107 210 Z" style="fill:';
    string private constant PART_145 = ';"/><path d="M139 209 Z" style="fill:';
    string private constant PART_146 = ';"/><path d="M197 205 Z" style="fill:';
    string private constant PART_147 = ';"/><path d="M191 198 Z" style="fill:';
    string private constant PART_148 = ';"/><path d="M42 198 Z" style="fill:';
    string private constant PART_149 = ';"/><path d="M107 194 Z" style="fill:';
    string private constant PART_150 = ';"/><path d="M198 191 Z" style="fill:';
    string private constant PART_151 = ';"/><path d="M80 186 Z" style="fill:';
    string private constant PART_152 = ';"/><path d="M41 185 Z" style="fill:';
    string private constant PART_153 = ';"/><path d="M107 180 Z" style="fill:';
    string private constant PART_154 = ';"/><path d="M49 178 Z" style="fill:';
    string private constant PART_155 = ';"/><path d="M59 105 Z" style="fill:';
    string private constant PART_156 = ';"/><path d="M58 104 Z" style="fill:';
    string private constant PART_157 = ';"/><path d="M61 102 Z" style="fill:';
    string private constant PART_158 = ';"/><path d="M39 99 Z" style="fill:';
    string private constant PART_159 = ';"/><path d="M187 89 Z" style="fill:';
    string private constant PART_160 = ';"/><path d="M102 85 Z" style="fill:';
    string private constant PART_161 = ';"/><path d="M224 79 Z" style="fill:';
    string private constant PART_162 = ';"/><path d="M174 78 Z" style="fill:';
    string private constant PART_163 = ';"/><path d="M145 77 Z" style="fill:';
    string private constant PART_164 = ';"/><path d="M134 77 Z" style="fill:';
    string private constant PART_165 = ';"/><path d="M68 77 Z" style="fill:';
    string private constant PART_166 = ';"/><path d="M98 76 Z" style="fill:';
    string private constant PART_167 = ';"/><path d="M99 75 Z" style="fill:';
    string private constant PART_168 = ';"/><path d="M237 71 Z" style="fill:';
    string private constant PART_169 = ';"/><path d="M63 70 Z" style="fill:';
    string private constant PART_170 = ';"/><path d="M240 69 Z" style="fill:';
    string private constant PART_171 = ';"/><path d="M236 69 Z" style="fill:';
    string private constant PART_172 = ';"/><path d="M81 65 Z" style="fill:';
    string private constant PART_173 = ';"/><path d="M83 64 Z" style="fill:';
    string private constant PART_174 = ';"/><path d="M78 57 Z" style="fill:';
    string private constant PART_175 = ';"/><path d="M61 48 Z" style="fill:';
    string private constant PART_176 = ';"/><path d="M146 39 Z" style="fill:';
    string private constant PART_177 = ';"/><path d="M154 36 Z" style="fill:';
    string private constant PART_178 = ';"/><path d="M155 35 Z" style="fill:';
    string private constant PART_179 = ';"/><path d="M83 34 Z" style="fill:';
    string private constant PART_180 = ';"/><path d="M82 33 Z" style="fill:';
    string private constant PART_181 = ';"/><path d="M85 29 Z" style="fill:';
    string private constant PART_182 = ';"/><path d="M143 25 Z" style="fill:';
    string private constant PART_183 = ';"/><path d="M152 24 Z" style="fill:';
    string private constant PART_184 = ';"/><path d="M230 19 Z" style="fill:';
    string private constant PART_185 = ';"/><path d="M83 19 Z" style="fill:';
    string private constant PART_186 = ';"/><path d="M239 18 Z" style="fill:';
    string private constant PART_187 = ';"/><path d="M201 18 Z" style="fill:';
    string private constant PART_188 = ';"/><path d="M150 18 Z" style="fill:';
    string private constant PART_189 = ';"/><path d="M185 15 Z" style="fill:';
    string private constant PART_190 = ';"/><path d="M80 15 Z" style="fill:';
    string private constant PART_191 = ';"/><path d="M79 14 Z" style="fill:';
    string private constant PART_192 = ';"/><path d="M231 10 Z" style="fill:';
    string private constant PART_193 = ';"/>';
    string private constant COLOR_1 = 'hsl(14, 68%, 28%)';
    string private constant COLOR_2 = 'hsl(12, 67%, 27%)';
    string private constant COLOR_3 = 'hsl(12, 64%, 25%)';
    string private constant COLOR_4 = 'hsl(11, 63%, 23%)';
    string private constant COLOR_5 = 'hsl(27, 83%, 49%)';
    string private constant COLOR_6 = 'hsl(23, 82%, 43%)';
    string private constant COLOR_7 = 'hsl(35, 87%, 57%)';
    string private constant COLOR_8 = 'hsl(10, 57%, 22%)';
    string private constant COLOR_9 = 'hsl(11, 61%, 24%)';
    string private constant COLOR_10 = 'hsl(40, 92%, 61%)';
    string private constant COLOR_11 = 'hsl(19, 82%, 41%)';
    string private constant COLOR_12 = 'hsl(44, 94%, 63%)';
    string private constant COLOR_13 = 'hsl(38, 92%, 58%)';
    string private constant COLOR_14 = 'hsl(24, 72%, 44%)';
    string private constant COLOR_15 = 'hsl(18, 80%, 40%)';
    string private constant COLOR_16 = 'hsl(30, 87%, 50%)';
    string private constant COLOR_17 = 'hsl(9, 54%, 21%)';
    string private constant COLOR_18 = 'hsl(21, 83%, 44%)';
    string private constant COLOR_19 = 'hsl(19, 81%, 42%)';
    string private constant COLOR_20 = 'hsl(23, 68%, 48%)';
    string private constant COLOR_21 = 'hsl(25, 72%, 44%)';
    string private constant COLOR_22 = 'hsl(19, 62%, 43%)';
    string private constant COLOR_23 = 'hsl(11, 53%, 32%)';
    string private constant COLOR_24 = 'hsl(17, 62%, 39%)';
    string private constant COLOR_25 = 'hsl(22, 76%, 39%)';
    string private constant COLOR_26 = 'hsl(25, 69%, 45%)';
    string private constant COLOR_27 = 'hsl(14, 65%, 36%)';
    string private constant COLOR_28 = 'hsl(13, 60%, 31%)';
    string private constant COLOR_29 = 'hsl(21, 71%, 45%)';
    string private constant COLOR_30 = 'hsl(13, 60%, 32%)';
    string private constant COLOR_31 = 'hsl(19, 74%, 40%)';
    string private constant COLOR_32 = 'hsl(12, 51%, 34%)';
    string private constant COLOR_33 = 'hsl(10, 49%, 30%)';
    string private constant COLOR_34 = 'hsl(10, 51%, 26%)';
    string private constant COLOR_35 = 'hsl(16, 65%, 39%)';
    string private constant COLOR_36 = 'hsl(16, 58%, 43%)';
    string private constant COLOR_37 = 'hsl(22, 55%, 53%)';
    string private constant COLOR_38 = 'hsl(15, 58%, 43%)';
    string private constant COLOR_39 = 'hsl(17, 59%, 36%)';
    string private constant COLOR_40 = 'hsl(6, 48%, 19%)';
    string private constant COLOR_41 = 'hsl(12, 67%, 34%)';
    string private constant COLOR_42 = 'hsl(5, 63%, 12%)';
    string private constant COLOR_43 = 'hsl(20, 65%, 44%)';
    string private constant COLOR_44 = 'hsl(10, 54%, 29%)';
    string private constant COLOR_45 = 'hsl(12, 70%, 33%)';
    string private constant COLOR_46 = 'hsl(14, 62%, 33%)';
    string private constant COLOR_47 = 'hsl(14, 53%, 38%)';
    string private constant COLOR_48 = 'hsl(13, 55%, 38%)';
    string private constant COLOR_49 = 'hsl(8, 42%, 24%)';
    string private constant COLOR_50 = 'hsl(8, 55%, 22%)';
    string private constant COLOR_51 = 'hsl(12, 61%, 29%)';
    string private constant COLOR_52 = 'hsl(9, 49%, 34%)';
    string private constant COLOR_53 = 'hsl(23, 76%, 58%)';
    string private constant COLOR_54 = 'hsl(8, 53%, 27%)';
    string private constant COLOR_55 = 'hsl(12, 68%, 31%)';
    string private constant COLOR_56 = 'hsl(19, 52%, 44%)';
    string private constant COLOR_57 = 'hsl(3, 58%, 14%)';
    string private constant COLOR_58 = 'hsl(8, 71%, 20%)';
    string private constant COLOR_59 = 'hsl(9, 61%, 19%)';
    string private constant COLOR_60 = 'hsl(18, 52%, 50%)';
    string private constant COLOR_61 = 'hsl(12, 61%, 40%)';
    string private constant COLOR_62 = 'hsl(14, 49%, 40%)';
    string private constant COLOR_63 = 'hsl(9, 45%, 36%)';
    string private constant COLOR_64 = 'hsl(17, 54%, 50%)';
    string private constant COLOR_65 = 'hsl(9, 57%, 31%)';
    string private constant COLOR_66 = 'hsl(11, 61%, 28%)';
    string private constant COLOR_67 = 'hsl(11, 37%, 29%)';
    string private constant COLOR_68 = 'hsl(7, 48%, 30%)';
    string private constant COLOR_69 = 'hsl(14, 37%, 48%)';
    string private constant COLOR_70 = 'hsl(11, 59%, 22%)';
    string private constant COLOR_71 = 'hsl(14, 69%, 33%)';
    string private constant COLOR_72 = 'hsl(13, 54%, 45%)';
    string private constant COLOR_73 = 'hsl(14, 56%, 58%)';
    string private constant COLOR_74 = 'hsl(19, 52%, 45%)';
    string private constant COLOR_75 = 'hsl(22, 69%, 46%)';
    string private constant COLOR_76 = 'hsl(7, 41%, 29%)';
    string private constant COLOR_77 = 'hsl(9, 72%, 21%)';
    string private constant COLOR_78 = 'hsl(26, 66%, 56%)';
    string private constant COLOR_79 = 'hsl(15, 40%, 42%)';
    string private constant COLOR_80 = 'hsl(10, 55%, 37%)';
    string private constant COLOR_81 = 'hsl(15, 33%, 36%)';
    string private constant COLOR_82 = 'hsl(12, 61%, 29%)';
    string private constant COLOR_83 = 'hsl(12, 49%, 41%)';
    string private constant COLOR_84 = 'hsl(22, 45%, 47%)';
    string private constant COLOR_85 = 'hsl(11, 41%, 40%)';
    string private constant COLOR_86 = 'hsl(16, 39%, 54%)';
    string private constant COLOR_87 = 'hsl(14, 91%, 30%)';
    string private constant COLOR_88 = 'hsl(20, 70%, 66%)';
    string private constant COLOR_89 = 'hsl(4, 54%, 20%)';
    string private constant COLOR_90 = 'hsl(14, 66%, 36%)';
    string private constant COLOR_91 = 'hsl(14, 30%, 50%)';
    string private constant COLOR_92 = 'hsl(13, 44%, 42%)';
    string private constant COLOR_93 = 'hsl(7, 77%, 15%)';
    string private constant COLOR_94 = 'hsl(6, 43%, 38%)';
    string private constant COLOR_95 = 'hsl(11, 66%, 35%)';
    string private constant COLOR_96 = 'hsl(14, 34%, 54%)';
    string private constant COLOR_97 = 'hsl(3, 62%, 23%)';
    string private constant COLOR_98 = 'hsl(22, 83%, 55%)';
    string private constant COLOR_99 = 'hsl(12, 73%, 25%)';
    string private constant COLOR_100 = 'hsl(19, 56%, 55%)';
    string private constant COLOR_101 = 'hsl(11, 56%, 56%)';
    string private constant COLOR_102 = 'hsl(22, 65%, 68%)';
    string private constant COLOR_103 = 'hsl(13, 17%, 50%)';
    string private constant COLOR_104 = 'hsl(12, 81%, 28%)';
    string private constant COLOR_105 = 'hsl(6, 84%, 7%)';
    string private constant COLOR_106 = 'hsl(8, 44%, 48%)';
    string private constant COLOR_107 = 'hsl(9, 66%, 23%)';
    string private constant COLOR_108 = 'hsl(14, 45%, 35%)';
    string private constant COLOR_109 = 'hsl(23, 74%, 53%)';
    string private constant COLOR_110 = 'hsl(11, 52%, 52%)';
    string private constant COLOR_111 = 'hsl(10, 38%, 30%)';
    string private constant COLOR_112 = 'hsl(12, 43%, 34%)';
    string private constant COLOR_113 = 'hsl(16, 92%, 25%)';
    string private constant COLOR_114 = 'hsl(7, 51%, 41%)';
    string private constant COLOR_115 = 'hsl(8, 48%, 59%)';
    string private constant COLOR_116 = 'hsl(8, 35%, 51%)';
    string private constant COLOR_117 = 'hsl(8, 47%, 28%)';
    string private constant COLOR_118 = 'hsl(2, 81%, 12%)';
    string private constant COLOR_119 = 'hsl(0, 34%, 43%)';
    string private constant COLOR_120 = 'hsl(9, 43%, 55%)';
    string private constant COLOR_121 = 'hsl(12, 51%, 44%)';
    string private constant COLOR_122 = 'hsl(12, 70%, 26%)';
    string private constant COLOR_123 = 'hsl(17, 42%, 48%)';
    string private constant COLOR_124 = 'hsl(16, 46%, 46%)';
    string private constant COLOR_125 = 'hsl(9, 46%, 30%)';
    string private constant COLOR_126 = 'hsl(6, 41%, 10%)';
    string private constant COLOR_127 = 'hsl(15, 46%, 45%)';
    string private constant COLOR_128 = 'hsl(9, 41%, 44%)';
    string private constant COLOR_129 = 'hsl(11, 88%, 26%)';
    string private constant COLOR_130 = 'hsl(28, 73%, 65%)';
    string private constant COLOR_131 = 'hsl(0, 100%, 11%)';
    string private constant COLOR_132 = 'hsl(12, 41%, 40%)';
    string private constant COLOR_133 = 'hsl(1, 80%, 20%)';
    string private constant COLOR_134 = 'hsl(26, 44%, 48%)';
    string private constant COLOR_135 = 'hsl(21, 49%, 60%)';
    string private constant COLOR_136 = 'hsl(10, 64%, 54%)';
    string private constant COLOR_137 = 'hsl(10, 57%, 50%)';
    string private constant COLOR_138 = 'hsl(13, 51%, 48%)';
    string private constant COLOR_139 = 'hsl(14, 58%, 59%)';
    string private constant COLOR_140 = 'hsl(358, 41%, 40%)';
    string private constant COLOR_141 = 'hsl(15, 45%, 57%)';
    string private constant COLOR_142 = 'hsl(13, 37%, 38%)';
    string private constant COLOR_143 = 'hsl(20, 38%, 49%)';
    string private constant COLOR_144 = 'hsl(7, 30%, 51%)';
    string private constant COLOR_145 = 'hsl(9, 78%, 25%)';
    string private constant COLOR_146 = 'hsl(21, 59%, 54%)';
    string private constant COLOR_147 = 'hsl(0, 100%, 3%)';
    string private constant COLOR_148 = 'hsl(9, 39%, 39%)';
    string private constant COLOR_149 = 'hsl(24, 56%, 55%)';
    string private constant COLOR_150 = 'hsl(357, 49%, 30%)';
    string private constant COLOR_151 = 'hsl(19, 100%, 17%)';
    string private constant COLOR_152 = 'hsl(6, 64%, 26%)';
    string private constant COLOR_153 = 'hsl(14, 45%, 44%)';
    string private constant COLOR_154 = 'hsl(12, 72%, 31%)';
    string private constant COLOR_155 = 'hsl(21, 78%, 53%)';
    string private constant COLOR_156 = 'hsl(21, 69%, 55%)';
    string private constant COLOR_157 = 'hsl(18, 68%, 54%)';
    string private constant COLOR_158 = 'hsl(4, 84%, 15%)';
    string private constant COLOR_159 = 'hsl(8, 44%, 46%)';
    string private constant COLOR_160 = 'hsl(11, 42%, 50%)';
    string private constant COLOR_161 = 'hsl(13, 57%, 44%)';
    string private constant COLOR_162 = 'hsl(18, 84%, 33%)';
    string private constant COLOR_163 = 'hsl(8, 87%, 25%)';
    string private constant COLOR_164 = 'hsl(4, 56%, 38%)';
    string private constant COLOR_165 = 'hsl(20, 43%, 54%)';
    string private constant COLOR_166 = 'hsl(22, 42%, 35%)';
    string private constant COLOR_167 = 'hsl(23, 64%, 69%)';
    string private constant COLOR_168 = 'hsl(17, 95%, 63%)';
    string private constant COLOR_169 = 'hsl(10, 80%, 27%)';
    string private constant COLOR_170 = 'hsl(13, 77%, 27%)';
    string private constant COLOR_171 = 'hsl(8, 39%, 40%)';
    string private constant COLOR_172 = 'hsl(7, 72%, 17%)';
    string private constant COLOR_173 = 'hsl(15, 49%, 25%)';
    string private constant COLOR_174 = 'hsl(10, 66%, 72%)';
    string private constant COLOR_175 = 'hsl(10, 23%, 44%)';
    string private constant COLOR_176 = 'hsl(5, 49%, 51%)';
    string private constant COLOR_177 = 'hsl(18, 67%, 52%)';
    string private constant COLOR_178 = 'hsl(19, 51%, 50%)';
    string private constant COLOR_179 = 'hsl(10, 46%, 53%)';
    string private constant COLOR_180 = 'hsl(14, 40%, 51%)';
    string private constant COLOR_181 = 'hsl(8, 39%, 30%)';
    string private constant COLOR_182 = 'hsl(4, 32%, 28%)';
    string private constant COLOR_183 = 'hsl(13, 34%, 54%)';
    string private constant COLOR_184 = 'hsl(13, 70%, 50%)';
    string private constant COLOR_185 = 'hsl(357, 32%, 38%)';
    string private constant COLOR_186 = 'hsl(19, 69%, 31%)';
    string private constant COLOR_187 = 'hsl(16, 72%, 44%)';
    string private constant COLOR_188 = 'hsl(10, 59%, 52%)';
    string private constant COLOR_189 = 'hsl(10, 70%, 15%)';
    string private constant COLOR_190 = 'hsl(11, 98%, 23%)';
    string private constant COLOR_191 = 'hsl(12, 55%, 43%)';
    string private constant COLOR_192 = 'hsl(17, 47%, 45%)';

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
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_53) : COLOR_53,
            PART_54,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_54) : COLOR_54,
            PART_55,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_55) : COLOR_55,
            PART_56,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_56) : COLOR_56
        );
        result = string.concat(
            result,
            PART_57,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_57) : COLOR_57,
            PART_58,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_58) : COLOR_58,
            PART_59,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_59) : COLOR_59,
            PART_60
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_60) : COLOR_60,
            PART_61,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_61) : COLOR_61,
            PART_62,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_62) : COLOR_62,
            PART_63,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_63) : COLOR_63
        );
        result = string.concat(
            result,
            PART_64,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_64) : COLOR_64,
            PART_65,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_65) : COLOR_65,
            PART_66,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_66) : COLOR_66,
            PART_67
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_67) : COLOR_67,
            PART_68,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_68) : COLOR_68,
            PART_69,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_69) : COLOR_69,
            PART_70,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_70) : COLOR_70
        );
        result = string.concat(
            result,
            PART_71,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_71) : COLOR_71,
            PART_72,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_72) : COLOR_72,
            PART_73,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_73) : COLOR_73,
            PART_74
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_74) : COLOR_74,
            PART_75,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_75) : COLOR_75,
            PART_76,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_76) : COLOR_76,
            PART_77,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_77) : COLOR_77
        );
        result = string.concat(
            result,
            PART_78,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_78) : COLOR_78,
            PART_79,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_79) : COLOR_79,
            PART_80,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_80) : COLOR_80,
            PART_81
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_81) : COLOR_81,
            PART_82,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_82) : COLOR_82,
            PART_83,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_83) : COLOR_83,
            PART_84,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_84) : COLOR_84
        );
        result = string.concat(
            result,
            PART_85,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_85) : COLOR_85,
            PART_86,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_86) : COLOR_86,
            PART_87,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_87) : COLOR_87,
            PART_88
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_88) : COLOR_88,
            PART_89,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_89) : COLOR_89,
            PART_90,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_90) : COLOR_90,
            PART_91,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_91) : COLOR_91
        );
        result = string.concat(
            result,
            PART_92,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_92) : COLOR_92,
            PART_93,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_93) : COLOR_93,
            PART_94,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_94) : COLOR_94,
            PART_95
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_95) : COLOR_95,
            PART_96,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_96) : COLOR_96,
            PART_97,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_97) : COLOR_97,
            PART_98,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_98) : COLOR_98
        );
        result = string.concat(
            result,
            PART_99,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_99) : COLOR_99,
            PART_100,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_100) : COLOR_100,
            PART_101,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_101) : COLOR_101,
            PART_102
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_102) : COLOR_102,
            PART_103,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_103) : COLOR_103,
            PART_104,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_104) : COLOR_104,
            PART_105,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_105) : COLOR_105
        );
        result = string.concat(
            result,
            PART_106,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_106) : COLOR_106,
            PART_107,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_107) : COLOR_107,
            PART_108,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_108) : COLOR_108,
            PART_109
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_109) : COLOR_109,
            PART_110,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_110) : COLOR_110,
            PART_111,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_111) : COLOR_111,
            PART_112,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_112) : COLOR_112
        );
        result = string.concat(
            result,
            PART_113,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_113) : COLOR_113,
            PART_114,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_114) : COLOR_114,
            PART_115,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_115) : COLOR_115,
            PART_116
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_116) : COLOR_116,
            PART_117,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_117) : COLOR_117,
            PART_118,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_118) : COLOR_118,
            PART_119,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_119) : COLOR_119
        );
        result = string.concat(
            result,
            PART_120,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_120) : COLOR_120,
            PART_121,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_121) : COLOR_121,
            PART_122,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_122) : COLOR_122,
            PART_123
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_123) : COLOR_123,
            PART_124,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_124) : COLOR_124,
            PART_125,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_125) : COLOR_125,
            PART_126,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_126) : COLOR_126
        );
        result = string.concat(
            result,
            PART_127,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_127) : COLOR_127,
            PART_128,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_128) : COLOR_128,
            PART_129,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_129) : COLOR_129,
            PART_130
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_130) : COLOR_130,
            PART_131,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_131) : COLOR_131,
            PART_132,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_132) : COLOR_132,
            PART_133,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_133) : COLOR_133
        );
        result = string.concat(
            result,
            PART_134,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_134) : COLOR_134,
            PART_135,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_135) : COLOR_135,
            PART_136,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_136) : COLOR_136,
            PART_137
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_137) : COLOR_137,
            PART_138,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_138) : COLOR_138,
            PART_139,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_139) : COLOR_139,
            PART_140,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_140) : COLOR_140
        );
        result = string.concat(
            result,
            PART_141,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_141) : COLOR_141,
            PART_142,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_142) : COLOR_142,
            PART_143,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_143) : COLOR_143,
            PART_144
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_144) : COLOR_144,
            PART_145,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_145) : COLOR_145,
            PART_146,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_146) : COLOR_146,
            PART_147,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_147) : COLOR_147
        );
        result = string.concat(
            result,
            PART_148,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_148) : COLOR_148,
            PART_149,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_149) : COLOR_149,
            PART_150,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_150) : COLOR_150,
            PART_151
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_151) : COLOR_151,
            PART_152,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_152) : COLOR_152,
            PART_153,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_153) : COLOR_153,
            PART_154,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_154) : COLOR_154
        );
        result = string.concat(
            result,
            PART_155,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_155) : COLOR_155,
            PART_156,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_156) : COLOR_156,
            PART_157,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_157) : COLOR_157,
            PART_158
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_158) : COLOR_158,
            PART_159,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_159) : COLOR_159,
            PART_160,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_160) : COLOR_160,
            PART_161,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_161) : COLOR_161
        );
        result = string.concat(
            result,
            PART_162,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_162) : COLOR_162,
            PART_163,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_163) : COLOR_163,
            PART_164,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_164) : COLOR_164,
            PART_165
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_165) : COLOR_165,
            PART_166,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_166) : COLOR_166,
            PART_167,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_167) : COLOR_167,
            PART_168,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_168) : COLOR_168
        );
        result = string.concat(
            result,
            PART_169,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_169) : COLOR_169,
            PART_170,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_170) : COLOR_170,
            PART_171,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_171) : COLOR_171,
            PART_172
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_172) : COLOR_172,
            PART_173,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_173) : COLOR_173,
            PART_174,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_174) : COLOR_174,
            PART_175,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_175) : COLOR_175
        );
        result = string.concat(
            result,
            PART_176,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_176) : COLOR_176,
            PART_177,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_177) : COLOR_177,
            PART_178,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_178) : COLOR_178,
            PART_179
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_179) : COLOR_179,
            PART_180,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_180) : COLOR_180,
            PART_181,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_181) : COLOR_181,
            PART_182,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_182) : COLOR_182
        );
        result = string.concat(
            result,
            PART_183,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_183) : COLOR_183,
            PART_184,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_184) : COLOR_184,
            PART_185,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_185) : COLOR_185,
            PART_186
        );
        result = string.concat(
            result,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_186) : COLOR_186,
            PART_187,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_187) : COLOR_187,
            PART_188,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_188) : COLOR_188,
            PART_189,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_189) : COLOR_189
        );
        result = string.concat(
            result,
            PART_190,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_190) : COLOR_190,
            PART_191,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_191) : COLOR_191,
            PART_192,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_192) : COLOR_192,
            PART_193
        );
        return result;
    }
}
