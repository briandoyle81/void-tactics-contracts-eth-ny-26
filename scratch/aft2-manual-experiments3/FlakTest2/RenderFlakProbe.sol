// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderFlakProbe {
    string private constant PART_1 = '<path d="M73 173 L74 173 L75 182 L76 187 L73 186 L73 184 L71 184 L71 192 L70 196 L68 196 L67 201 L64 200 L62 193 L59 191 L59 198 L50 195 L52 197 L53 204 L50 206 L46 206 L46 204 L44 204 L48 208 L49 210 L42 212 L39 211 L40 214 L47 216 L47 218 L49 219 L48 221 L51 224 L51 228 L49 228 L48 232 L46 233 L50 232 L58 229 L61 228 L62 231 L60 237 L66 234 L68 236 L67 241 L69 242 L73 233 L77 232 L77 234 L80 235 L81 236 L82 232 L90 232 L90 229 L88 228 L88 225 L92 223 L88 221 L94 219 L96 219 L96 217 L102 217 L100 216 L100 214 L95 213 L94 210 L98 208 L89 208 L88 204 L92 199 L92 196 L94 196 L93 193 L87 197 L82 198 L81 193 L76 195 L75 194 L75 188 L77 189 L77 191 L79 191 L79 189 L86 190 L87 193 L96 188 L101 184 L103 184 L101 188 L98 192 L96 201 L97 204 L105 205 L104 210 L100 211 L100 213 L105 213 L111 216 L116 217 L114 219 L105 221 L103 222 L100 221 L97 222 L99 226 L96 228 L94 228 L96 235 L98 241 L88 237 L88 235 L85 237 L83 241 L80 241 L78 241 L76 242 L74 240 L71 247 L69 247 L69 252 L67 252 L66 244 L63 239 L61 242 L59 242 L55 236 L52 236 L47 237 L44 240 L39 241 L42 233 L44 233 L44 228 L46 226 L44 224 L44 220 L42 220 L42 218 L37 218 L27 214 L25 212 L31 210 L37 210 L37 208 L41 207 L40 204 L42 204 L42 202 L49 201 L44 192 L43 189 L48 190 L54 193 L55 189 L56 186 L61 188 L64 186 L68 190 L69 184 L72 176 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M91 25 L94 26 L95 32 L97 32 L98 36 L94 38 L95 40 L91 38 L91 36 L87 36 L91 40 L91 42 L93 42 L93 44 L89 45 L91 49 L90 51 L85 52 L85 54 L89 53 L94 55 L96 55 L95 58 L90 60 L92 62 L95 62 L94 66 L98 67 L100 63 L103 62 L104 60 L106 60 L106 62 L109 62 L108 66 L106 66 L107 72 L108 70 L110 70 L111 72 L116 73 L117 70 L119 70 L120 75 L123 75 L122 72 L124 69 L129 67 L130 63 L135 65 L135 61 L139 62 L139 60 L134 56 L136 55 L139 56 L140 54 L145 54 L145 51 L142 50 L144 45 L141 45 L140 47 L140 43 L136 44 L137 39 L140 39 L140 36 L144 35 L143 32 L145 30 L149 31 L146 32 L144 37 L142 41 L148 44 L152 45 L153 47 L151 47 L151 49 L158 50 L159 52 L149 53 L151 56 L147 58 L143 58 L145 64 L140 66 L142 69 L141 71 L134 70 L133 75 L127 74 L126 84 L126 88 L124 88 L118 78 L115 78 L115 81 L113 81 L109 77 L106 78 L104 82 L102 81 L102 75 L99 74 L97 71 L90 74 L88 74 L88 77 L85 78 L86 74 L90 66 L86 65 L86 60 L86 58 L82 56 L81 54 L76 54 L76 52 L71 52 L71 50 L78 50 L78 48 L84 48 L85 45 L81 44 L81 42 L87 41 L85 38 L86 34 L91 33 L94 34 L91 28 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M114 19 L116 23 L118 31 L122 29 L122 35 L125 30 L130 35 L128 36 L129 39 L131 37 L131 39 L135 39 L135 41 L133 41 L131 47 L133 48 L134 46 L135 48 L137 48 L136 54 L130 54 L130 56 L132 56 L133 59 L131 62 L127 61 L127 64 L122 63 L122 69 L119 69 L119 66 L116 65 L117 62 L115 62 L113 68 L110 69 L108 70 L107 73 L106 69 L106 66 L108 66 L109 62 L104 61 L100 64 L98 64 L98 60 L101 60 L99 56 L100 55 L94 53 L95 48 L92 47 L93 45 L95 45 L96 43 L100 42 L95 41 L96 38 L97 40 L101 39 L101 35 L99 35 L100 33 L106 34 L105 33 L106 26 L108 26 L109 32 L111 32 L113 25 Z M109 34 L108 37 L110 37 L110 40 L106 41 L110 42 L111 44 L108 43 L105 45 L106 47 L104 47 L105 51 L107 54 L105 54 L104 57 L107 58 L110 57 L112 60 L112 57 L114 57 L114 54 L117 54 L117 59 L120 59 L120 53 L122 53 L122 56 L127 56 L124 54 L125 51 L124 50 L127 51 L127 48 L122 46 L123 38 L121 38 L118 42 L115 34 L113 37 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M71 187 L73 188 L74 195 L74 199 L79 197 L80 201 L82 199 L85 200 L85 198 L88 198 L88 201 L86 201 L84 207 L88 209 L85 210 L85 212 L91 212 L92 215 L96 214 L96 216 L92 218 L90 217 L89 219 L85 218 L84 220 L84 223 L87 226 L86 229 L80 227 L80 230 L77 230 L77 228 L72 229 L72 233 L68 235 L67 229 L66 228 L64 233 L63 233 L63 227 L58 225 L58 228 L55 227 L55 224 L53 223 L54 221 L58 221 L58 219 L52 219 L51 217 L54 216 L52 216 L48 216 L48 211 L58 210 L53 209 L53 206 L58 207 L53 200 L57 199 L59 200 L61 194 L64 195 L65 200 L67 200 L68 196 L70 196 Z M60 204 L61 208 L63 209 L63 212 L59 212 L57 213 L57 215 L64 216 L59 222 L64 221 L67 219 L68 223 L70 226 L73 220 L73 222 L79 223 L77 219 L75 216 L82 216 L81 213 L78 213 L77 209 L80 207 L80 205 L76 206 L75 208 L73 207 L70 204 L68 205 L67 208 L66 206 L62 205 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M216 24 L218 25 L217 35 L214 36 L213 41 L206 40 L208 45 L205 45 L207 51 L205 52 L208 55 L211 53 L212 62 L212 59 L213 56 L216 55 L216 57 L218 57 L218 53 L224 52 L223 48 L220 48 L222 44 L224 44 L224 40 L221 40 L220 42 L216 41 L217 36 L220 32 L222 33 L222 34 L225 34 L225 32 L228 33 L226 33 L227 38 L232 34 L235 34 L234 37 L232 38 L230 43 L227 46 L232 48 L231 53 L233 53 L234 57 L228 57 L227 60 L224 60 L225 66 L221 66 L218 65 L213 66 L212 71 L209 70 L209 66 L209 64 L207 64 L207 62 L205 62 L205 59 L197 60 L194 60 L194 58 L196 56 L199 53 L199 51 L197 51 L197 49 L190 48 L190 47 L197 47 L197 45 L194 45 L195 42 L195 40 L200 40 L199 33 L197 29 L204 32 L207 30 L206 26 L209 28 L209 30 L214 30 Z M169 199 L172 199 L173 206 L175 204 L178 203 L177 209 L180 208 L180 206 L182 206 L182 208 L184 209 L181 213 L184 214 L184 216 L188 216 L187 219 L183 218 L183 220 L180 221 L182 230 L180 230 L180 228 L176 230 L173 231 L171 230 L169 236 L167 236 L165 234 L163 232 L164 230 L160 232 L156 233 L157 228 L158 227 L156 226 L156 224 L150 226 L147 223 L151 221 L154 221 L152 215 L150 213 L151 208 L154 208 L160 207 L160 204 L163 203 L166 206 L168 203 Z M164 210 L161 213 L159 214 L159 217 L160 219 L159 220 L158 222 L162 223 L160 227 L164 226 L166 223 L166 228 L169 228 L169 224 L173 226 L173 223 L175 221 L179 217 L177 216 L176 213 L170 214 L169 211 L167 212 L166 210 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M171 183 L173 183 L175 191 L175 196 L178 196 L183 197 L187 199 L189 198 L192 201 L191 206 L197 208 L194 214 L202 215 L203 218 L194 222 L196 228 L191 229 L191 233 L193 233 L195 239 L193 241 L187 239 L184 237 L183 240 L180 241 L179 243 L175 242 L172 240 L172 236 L181 235 L182 233 L186 233 L187 236 L189 236 L188 233 L185 230 L185 227 L183 226 L185 225 L187 226 L184 222 L184 220 L189 219 L192 216 L188 217 L187 212 L183 211 L185 207 L187 207 L186 204 L180 204 L180 202 L174 203 L172 194 L172 191 L169 190 Z M175 198 Z M183 199 L182 201 L184 201 Z M169 191 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M144 206 L148 207 L148 211 L150 212 L150 214 L143 217 L149 219 L148 222 L146 222 L145 224 L143 223 L143 225 L151 226 L152 230 L155 231 L153 239 L155 239 L155 237 L158 237 L158 235 L161 234 L161 239 L162 238 L166 237 L167 241 L167 243 L169 243 L172 240 L173 243 L170 250 L168 250 L168 247 L166 247 L165 242 L159 244 L157 241 L153 243 L153 245 L148 247 L149 238 L145 238 L145 233 L147 230 L135 228 L135 224 L139 222 L142 222 L138 218 L139 213 L142 212 L141 209 L144 207 Z M116 19 L118 19 L120 23 L122 23 L122 21 L127 23 L129 23 L135 19 L137 19 L138 23 L137 27 L135 27 L135 30 L140 28 L140 31 L143 32 L143 34 L134 36 L134 34 L132 33 L129 31 L131 31 L133 25 L128 27 L124 28 L122 27 L123 25 L120 26 L118 28 Z M143 31 Z M147 247 Z M129 20 Z M191 198 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M109 34 L113 37 L115 34 L118 42 L121 38 L123 39 L122 46 L128 49 L126 51 L125 51 L124 54 L127 56 L122 56 L122 53 L120 53 L120 59 L117 59 L117 54 L114 54 L114 57 L112 57 L111 60 L109 57 L106 58 L104 56 L105 54 L107 54 L104 51 L104 47 L106 47 L105 44 L109 43 L111 43 L106 42 L107 40 L110 40 L110 37 L108 36 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M216 35 L217 37 L217 40 L221 40 L225 39 L225 44 L221 46 L220 48 L223 48 L226 52 L219 54 L218 58 L213 56 L213 61 L214 63 L211 62 L210 54 L207 58 L207 54 L204 51 L207 51 L207 49 L205 48 L203 43 L207 44 L205 40 L210 39 L213 41 L214 36 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M60 204 L64 206 L66 206 L67 208 L69 204 L72 205 L73 208 L75 208 L78 205 L80 205 L80 207 L77 210 L78 213 L82 214 L82 216 L75 216 L79 221 L79 223 L73 222 L72 223 L69 226 L67 221 L66 220 L63 222 L59 221 L64 216 L57 215 L58 212 L60 213 L63 212 L63 209 L60 206 Z M177 247 Z M99 75 Z M78 57 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M220 4 L222 4 L221 20 L223 20 L223 23 L228 21 L226 25 L228 25 L234 21 L237 21 L236 30 L237 33 L231 36 L227 39 L225 35 L226 33 L223 33 L223 30 L219 30 L220 24 L221 22 L218 23 L218 16 L216 16 L216 10 L219 7 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M247 44 L253 44 L253 46 L245 49 L243 50 L246 52 L245 55 L243 55 L244 61 L241 63 L236 63 L236 69 L228 69 L227 72 L223 70 L224 64 L226 61 L231 62 L230 59 L237 58 L236 50 L239 49 L240 47 L247 46 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M49 83 L54 88 L56 87 L55 92 L60 91 L59 95 L59 98 L59 100 L55 102 L55 99 L52 99 L51 102 L47 103 L43 106 L41 105 L44 101 L44 99 L40 98 L42 94 L40 91 L44 90 L43 84 L48 87 L47 84 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M96 214 L100 214 L100 216 L104 218 L96 217 L97 220 L93 221 L92 222 L93 224 L88 225 L88 228 L91 229 L92 234 L82 232 L82 237 L80 237 L77 234 L77 232 L73 233 L72 237 L70 244 L67 241 L67 236 L72 232 L71 228 L77 228 L77 230 L80 230 L79 225 L80 227 L86 228 L87 226 L83 224 L82 219 L89 218 L96 216 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M216 64 L222 64 L224 69 L227 71 L228 68 L231 71 L232 75 L234 79 L234 84 L232 83 L232 81 L228 79 L227 74 L222 74 L218 76 L215 73 L213 77 L210 84 L207 83 L205 74 L206 72 L208 72 L210 75 L213 66 Z M207 84 L208 88 L206 89 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M186 50 L191 50 L195 55 L193 62 L202 61 L201 67 L203 67 L203 69 L205 69 L205 66 L208 66 L207 72 L201 74 L199 74 L197 66 L192 69 L186 71 L182 71 L182 69 L185 66 L185 64 L187 63 L188 57 L190 56 L182 56 L183 54 L186 54 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M134 53 L136 55 L136 57 L140 60 L139 62 L136 62 L135 66 L134 64 L131 64 L129 68 L127 69 L125 68 L123 73 L124 76 L120 75 L119 70 L116 73 L111 73 L109 68 L113 66 L114 61 L117 62 L117 65 L119 66 L119 69 L122 69 L122 63 L127 64 L126 60 L131 61 L132 56 L130 56 L130 54 Z M154 224 L156 224 L156 226 L159 227 L157 231 L156 233 L160 231 L162 229 L164 230 L165 233 L167 233 L167 236 L169 236 L170 230 L173 230 L177 231 L178 235 L174 237 L172 236 L172 241 L170 241 L169 244 L166 241 L166 238 L163 238 L162 240 L160 239 L160 235 L158 235 L158 237 L155 237 L155 239 L153 239 L153 234 L154 231 L152 230 L151 225 Z M171 191 L173 194 L175 202 L178 201 L179 203 L172 207 L171 200 L169 201 L168 205 L166 208 L165 204 L160 204 L161 208 L153 209 L152 208 L151 213 L147 211 L147 207 L144 204 L144 202 L147 201 L148 203 L156 205 L154 203 L155 199 L157 203 L160 197 L165 201 L168 197 L170 197 Z M193 58 L194 60 L201 59 L205 59 L205 62 L207 62 L207 64 L209 64 L212 73 L209 76 L207 70 L208 66 L205 66 L205 69 L203 69 L203 67 L201 67 L200 64 L201 62 L198 62 L197 64 L197 62 L193 62 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M190 26 L193 27 L193 29 L196 28 L197 33 L195 33 L195 35 L197 36 L196 39 L191 37 L190 43 L190 46 L184 49 L186 51 L182 52 L173 49 L173 46 L182 44 L185 44 L183 38 L181 33 L186 35 L186 33 L191 33 L191 31 L189 27 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M164 210 L166 210 L167 212 L170 212 L170 214 L176 213 L177 216 L179 218 L175 221 L173 224 L172 226 L169 225 L169 228 L166 227 L166 223 L162 227 L160 226 L162 222 L158 221 L161 220 L159 219 L160 215 L159 213 L163 212 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M87 36 L91 36 L95 40 L100 42 L99 44 L96 43 L95 46 L92 47 L96 48 L94 53 L101 54 L100 57 L101 60 L98 60 L98 64 L100 64 L99 66 L94 68 L93 65 L93 62 L90 62 L90 60 L95 57 L96 55 L93 56 L87 54 L85 54 L85 52 L89 49 L91 49 L88 45 L93 44 L93 42 L91 42 L87 38 Z M59 191 L63 193 L61 195 L60 201 L54 200 L58 205 L58 207 L54 208 L59 210 L59 211 L49 212 L47 207 L44 206 L44 204 L46 204 L46 206 L51 204 L52 201 L50 197 L50 194 L58 197 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M170 191 L171 194 L170 197 L168 197 L166 202 L160 198 L158 204 L155 203 L158 206 L148 204 L144 202 L145 206 L140 202 L139 197 L136 196 L139 195 L151 201 L152 196 L156 196 L158 192 L161 193 L162 195 L166 196 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M112 3 L114 3 L117 13 L117 19 L115 18 L115 14 L113 14 L113 23 L111 28 L110 25 L106 24 L104 23 L104 26 L102 27 L104 29 L102 29 L101 32 L96 30 L95 26 L93 25 L98 26 L99 22 L102 22 L100 19 L100 15 L104 16 L109 21 L110 16 L112 16 Z M99 27 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M133 24 L134 26 L131 31 L133 31 L134 36 L144 33 L144 35 L140 36 L140 39 L135 40 L130 39 L127 39 L128 35 L127 34 L125 31 L122 36 L121 34 L121 30 L119 35 L117 31 L116 27 L121 25 L123 25 L124 26 L127 27 L131 25 Z M145 214 L152 214 L154 216 L153 217 L155 219 L154 221 L148 224 L150 225 L149 227 L142 226 L143 223 L148 221 L149 219 L141 217 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M113 14 L115 14 L118 23 L117 26 L115 23 L114 27 L112 31 L109 32 L109 30 L107 29 L108 26 L106 26 L105 33 L107 34 L104 35 L100 34 L101 35 L102 41 L93 38 L94 36 L97 35 L97 32 L95 32 L94 26 L99 30 L101 31 L102 28 L101 26 L104 26 L104 23 L111 25 L111 23 L113 23 L112 17 Z M116 26 Z M58 225 L63 227 L64 225 L64 230 L66 227 L69 228 L68 235 L64 236 L60 237 L61 230 L58 229 L57 231 L50 233 L45 234 L46 232 L48 232 L49 228 L55 227 L58 228 Z M179 202 L180 204 L186 203 L187 207 L185 207 L184 211 L188 211 L189 216 L184 216 L184 214 L180 213 L183 209 L182 206 L180 206 L180 208 L176 210 L177 205 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M197 31 L200 34 L201 40 L196 41 L197 43 L195 43 L194 45 L197 45 L197 47 L192 48 L197 49 L197 51 L199 51 L200 54 L196 58 L194 58 L193 54 L191 51 L182 49 L186 47 L190 45 L189 41 L191 37 L196 39 L195 33 L197 33 Z M71 184 L73 184 L73 186 L76 187 L76 194 L81 193 L82 198 L87 197 L85 198 L85 200 L82 200 L80 202 L78 199 L74 199 L72 188 L70 189 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M217 15 L219 16 L219 22 L221 22 L220 29 L224 30 L225 34 L222 34 L222 36 L220 35 L220 33 L217 36 L217 25 L214 30 L209 30 L207 28 L208 31 L203 33 L202 31 L203 28 L205 28 L206 24 L210 23 L212 26 L213 21 L215 23 L217 17 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M93 192 L94 196 L90 203 L89 208 L91 207 L99 207 L96 210 L94 210 L96 214 L92 215 L90 213 L85 212 L85 210 L87 209 L84 207 L86 201 L88 201 L87 196 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M47 210 L48 210 L48 216 L52 216 L53 214 L56 217 L52 218 L58 219 L58 221 L54 221 L55 223 L58 224 L56 224 L56 227 L51 229 L51 224 L47 222 L47 218 L40 215 L38 214 L39 211 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M136 39 L138 41 L136 41 L136 44 L140 43 L141 45 L144 45 L145 48 L143 48 L143 50 L146 53 L145 55 L140 55 L136 56 L137 48 L134 49 L130 47 L132 43 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M190 216 L192 216 L191 219 L187 221 L184 220 L187 224 L187 226 L184 226 L186 232 L189 233 L189 236 L187 236 L183 232 L182 234 L178 235 L176 229 L178 227 L180 228 L180 226 L179 220 L183 220 L183 218 L188 217 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M246 43 L248 44 L247 46 L244 46 L243 48 L240 47 L239 50 L237 52 L237 58 L231 60 L232 64 L230 62 L224 63 L224 60 L227 59 L227 56 L232 56 L231 54 L230 50 L232 48 L237 47 L237 45 L246 45 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M216 16 L218 18 L215 24 L211 27 L210 24 L206 25 L205 28 L203 28 L202 31 L199 29 L199 27 L196 26 L196 24 L203 23 L204 18 L208 18 L212 22 L214 17 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M60 73 L62 73 L61 79 L58 86 L60 86 L60 84 L62 85 L60 88 L60 91 L55 92 L55 88 L52 88 L50 88 L50 82 L53 84 L56 79 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M66 89 L69 90 L69 92 L62 94 L63 99 L61 99 L60 102 L56 104 L54 103 L53 109 L51 105 L49 104 L49 101 L51 101 L52 99 L55 99 L56 101 L59 96 L56 94 L59 93 L60 90 L66 91 Z M51 103 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M186 17 L191 18 L196 21 L197 26 L199 27 L199 29 L202 30 L199 31 L195 29 L193 29 L192 27 L189 27 L189 24 L187 24 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M235 34 L239 35 L239 37 L236 37 L235 43 L238 47 L237 48 L229 48 L226 47 L228 43 L230 42 L232 37 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M238 29 L241 33 L241 38 L238 40 L241 41 L241 43 L246 43 L246 45 L239 46 L233 43 L235 42 L234 39 L236 39 L236 37 L239 37 L238 35 L235 33 L237 33 L236 30 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M249 33 L254 33 L254 36 L252 36 L252 38 L247 38 L247 35 L249 35 Z" style="fill:';
    string private constant PART_39 = ';"/><path d="M191 78 L194 79 L192 84 L188 85 L190 79 Z" style="fill:';
    string private constant PART_40 = ';"/><path d="M131 212 L135 214 L135 217 L130 217 L130 215 L128 214 Z" style="fill:';
    string private constant PART_41 = ';"/><path d="M194 192 L198 192 L198 194 L196 194 L195 198 L192 197 Z M198 191 Z" style="fill:';
    string private constant PART_42 = ';"/><path d="M150 61 L154 62 L157 65 L157 67 L152 65 Z" style="fill:';
    string private constant PART_43 = ';"/><path d="M251 52 L255 53 L255 57 L250 55 Z" style="fill:';
    string private constant PART_44 = ';"/><path d="M171 25 L176 27 L177 31 L173 30 Z" style="fill:';
    string private constant PART_45 = ';"/><path d="M245 24 L249 25 L248 27 L246 27 L246 29 L242 29 L244 25 Z" style="fill:';
    string private constant PART_46 = ';"/><path d="M109 201 L114 201 L110 205 L108 205 Z" style="fill:';
    string private constant PART_47 = ';"/><path d="M72 58 L75 59 L73 62 L69 61 Z" style="fill:';
    string private constant PART_48 = ';"/><path d="M72 27 L77 28 L79 29 L79 31 L75 30 Z" style="fill:';
    string private constant PART_49 = ';"/><path d="M202 225 L207 226 L208 228 L203 228 Z" style="fill:';
    string private constant PART_50 = ';"/><path d="M85 179 L87 179 L87 183 L83 184 Z" style="fill:';
    string private constant PART_51 = ';"/><path d="M34 194 L38 195 L40 198 L36 197 Z" style="fill:';
    string private constant PART_52 = ';"/><path d="M76 39 L79 40 L79 42 L74 42 Z" style="fill:';
    string private constant PART_53 = ';"/><path d="M140 10 L141 14 L138 16 L139 11 Z" style="fill:';
    string private constant PART_54 = ';"/><path d="M35 230 L36 233 L32 235 L34 231 Z" style="fill:';
    string private constant PART_55 = ';"/><path d="M102 223 L106 223 L105 226 L102 225 Z" style="fill:';
    string private constant PART_56 = ';"/><path d="M107 228 L111 229 L111 231 L107 230 Z" style="fill:';
    string private constant PART_57 = ';"/><path d="M179 72 L181 74 L178 77 L178 74 Z" style="fill:';
    string private constant PART_58 = ';"/><path d="M226 9 L228 9 L227 13 L225 12 Z" style="fill:';
    string private constant PART_59 = ';"/><path d="M49 244 L52 244 L51 247 L49 247 Z M198 78 L200 78 L198 82 L197 80 Z M123 17 L125 17 L125 20 L123 20 Z M242 14 L244 14 L244 16 L241 17 Z M148 190 L150 191 L149 194 Z M240 77 L242 79 L240 79 Z M152 37 L153 39 L151 38 Z M62 182 Z M181 60 Z M146 60 L148 61 Z M182 11 Z M102 244 Z M87 242 Z M139 209 Z M80 186 Z M41 185 Z M39 99 Z M145 77 Z M63 70 Z M240 69 Z M81 65 Z M83 64 Z M85 29 Z M143 25 Z M185 15 Z M80 15 Z" style="fill:';
    string private constant PART_60 = ';"/><path d="M183 243 L186 244 L186 246 L183 246 Z" style="fill:';
    string private constant PART_61 = ';"/><path d="M135 233 L138 234 L136 234 L136 236 L133 235 Z" style="fill:';
    string private constant PART_62 = ';"/><path d="M246 71 L250 73 L247 74 Z" style="fill:';
    string private constant PART_63 = ';"/><path d="M176 63 L178 63 L177 66 L174 67 L174 65 L176 65 Z" style="fill:';
    string private constant PART_64 = ';"/><path d="M196 241 L200 243 L199 245 Z" style="fill:';
    string private constant PART_65 = ';"/><path d="M51 183 L54 185 L53 188 Z" style="fill:';
    string private constant PART_66 = ';"/><path d="M81 68 L82 70 L81 72 L79 72 Z" style="fill:';
    string private constant PART_67 = ';"/><path d="M176 42 L180 43 L176 44 Z" style="fill:';
    string private constant PART_68 = ';"/><path d="M39 224 L43 225 L39 225 Z" style="fill:';
    string private constant PART_69 = ';"/><path d="M28 221 L30 221 L30 223 L26 222 Z" style="fill:';
    string private constant PART_70 = ';"/><path d="M38 181 L41 183 L40 185 Z" style="fill:';
    string private constant PART_71 = ';"/><path d="M168 45 L171 45 L171 47 L168 47 Z" style="fill:';
    string private constant PART_72 = ';"/><path d="M88 18 L91 20 L90 22 Z" style="fill:';
    string private constant PART_73 = ';"/><path d="M65 99 L68 99 L68 101 L65 100 Z" style="fill:';
    string private constant PART_74 = ';"/><path d="M71 88 L75 89 L73 90 Z" style="fill:';
    string private constant PART_75 = ';"/><path d="M93 83 L94 86 L92 86 Z" style="fill:';
    string private constant PART_76 = ';"/><path d="M141 72 L144 73 L141 74 Z" style="fill:';
    string private constant PART_77 = ';"/><path d="M145 22 L147 23 L144 25 Z" style="fill:';
    string private constant PART_78 = ';"/><path d="M225 17 L227 17 L226 20 Z" style="fill:';
    string private constant PART_79 = ';"/><path d="M81 16 L83 17 L83 19 L81 19 Z M194 7 L196 7 L195 10 Z" style="fill:';
    string private constant PART_80 = ';"/><path d="M203 10 L205 10 L204 13 Z" style="fill:';
    string private constant PART_81 = ';"/><path d="M130 225 L132 225 L132 227 L130 227 Z M146 70 L148 70 L148 72 L146 72 Z M150 25 L152 26 L150 27 Z M152 24 Z" style="fill:';
    string private constant PART_82 = ';"/><path d="M31 204 L33 204 L33 206 L31 206 Z" style="fill:';
    string private constant PART_83 = ';"/><path d="M203 200 L205 201 L202 201 Z M34 89 L37 90 Z M146 78 L148 78 L147 80 Z M198 234 Z M49 178 Z M224 79 Z M174 78 Z M134 77 Z M230 19 Z M239 18 Z M201 18 Z M79 14 Z" style="fill:';
    string private constant PART_84 = ';"/><path d="M180 191 L180 194 Z" style="fill:';
    string private constant PART_85 = ';"/><path d="M48 104 L48 107 Z" style="fill:';
    string private constant PART_86 = ';"/><path d="M214 81 L214 84 Z M26 199 Z M86 189 L88 190 Z M91 185 Z" style="fill:';
    string private constant PART_87 = ';"/><path d="M111 82 L113 82 L113 84 L111 84 Z" style="fill:';
    string private constant PART_88 = ';"/><path d="M40 82 L43 83 L40 83 Z" style="fill:';
    string private constant PART_89 = ';"/><path d="M44 78 L46 78 L46 80 L44 80 Z" style="fill:';
    string private constant PART_90 = ';"/><path d="M196 70 L196 73 Z" style="fill:';
    string private constant PART_91 = ';"/><path d="M160 52 L162 52 L162 54 L160 54 Z" style="fill:';
    string private constant PART_92 = ';"/><path d="M78 244 Z" style="fill:';
    string private constant PART_93 = ';"/><path d="M142 230 L143 232 L141 231 Z" style="fill:';
    string private constant PART_94 = ';"/><path d="M205 215 L208 216 Z" style="fill:';
    string private constant PART_95 = ';"/><path d="M98 201 L101 202 Z M135 205 Z M133 193 L135 194 Z M185 57 L187 58 Z M101 243 Z M142 241 Z M143 240 Z M199 235 Z M102 233 Z M99 231 Z M98 230 Z M199 223 Z M117 218 Z M140 210 Z M107 210 Z M42 198 Z M107 194 Z M107 180 Z M187 89 Z M102 85 Z M236 69 Z M61 48 Z M146 39 Z M155 35 Z M83 34 Z M82 33 Z M83 19 Z M150 18 Z M231 10 Z" style="fill:';
    string private constant PART_96 = ';"/><path d="M163 188 Z" style="fill:';
    string private constant PART_97 = ';"/><path d="M118 89 Z" style="fill:';
    string private constant PART_98 = ';"/><path d="M62 82 L64 83 L62 84 Z" style="fill:';
    string private constant PART_99 = ';"/><path d="M97 77 L98 79 L96 78 Z M98 76 Z" style="fill:';
    string private constant PART_100 = ';"/><path d="M70 75 L71 77 L69 76 Z M68 77 Z" style="fill:';
    string private constant PART_101 = ';"/><path d="M131 14 Z" style="fill:';
    string private constant PART_102 = ';"/><path d="M119 13 Z" style="fill:';
    string private constant PART_103 = ';"/><path d="M158 246 Z M105 195 L107 196 Z M197 205 Z M59 105 Z M58 104 Z M61 102 Z M237 71 Z M154 36 Z" style="fill:';
    string private constant PART_104 = ';"/><path d="M89 245 Z M35 221 L37 222 Z M37 204 L39 205 Z M244 39 Z M187 27 Z" style="fill:';
    string private constant PART_105 = ';"/><path d="M58 244 Z M53 239 Z M66 85 Z M238 68 L240 69 Z M71 38 L73 39 Z" style="fill:';
    string private constant PART_106 = ';"/><path d="M34 243 Z M173 180 Z M179 55 L181 56 Z M106 15 Z" style="fill:';
    string private constant PART_107 = ';"/><path d="M136 221 L138 222 Z M176 57 L178 58 Z" style="fill:';
    string private constant PART_108 = ';"/><path d="M40 220 L42 221 Z" style="fill:';
    string private constant PART_109 = ';"/><path d="M188 29 Z" style="fill:';
    string private constant PART_110 = ';"/><path d="M95 16 Z" style="fill:';
    string private constant PART_111 = ';"/>';
    string private constant COLOR_1 = 'hsl(10, 60%, 22%)';
    string private constant COLOR_2 = 'hsl(11, 61%, 22%)';
    string private constant COLOR_3 = 'hsl(31, 85%, 51%)';
    string private constant COLOR_4 = 'hsl(30, 85%, 51%)';
    string private constant COLOR_5 = 'hsl(30, 85%, 51%)';
    string private constant COLOR_6 = 'hsl(10, 60%, 21%)';
    string private constant COLOR_7 = 'hsl(9, 58%, 22%)';
    string private constant COLOR_8 = 'hsl(47, 92%, 70%)';
    string private constant COLOR_9 = 'hsl(47, 91%, 69%)';
    string private constant COLOR_10 = 'hsl(47, 93%, 70%)';
    string private constant COLOR_11 = 'hsl(12, 65%, 26%)';
    string private constant COLOR_12 = 'hsl(13, 64%, 25%)';
    string private constant COLOR_13 = 'hsl(28, 74%, 48%)';
    string private constant COLOR_14 = 'hsl(17, 77%, 38%)';
    string private constant COLOR_15 = 'hsl(12, 60%, 24%)';
    string private constant COLOR_16 = 'hsl(11, 60%, 22%)';
    string private constant COLOR_17 = 'hsl(16, 77%, 38%)';
    string private constant COLOR_18 = 'hsl(10, 59%, 23%)';
    string private constant COLOR_19 = 'hsl(46, 91%, 69%)';
    string private constant COLOR_20 = 'hsl(16, 77%, 38%)';
    string private constant COLOR_21 = 'hsl(11, 60%, 22%)';
    string private constant COLOR_22 = 'hsl(10, 59%, 22%)';
    string private constant COLOR_23 = 'hsl(16, 77%, 38%)';
    string private constant COLOR_24 = 'hsl(16, 77%, 37%)';
    string private constant COLOR_25 = 'hsl(16, 77%, 37%)';
    string private constant COLOR_26 = 'hsl(17, 77%, 38%)';
    string private constant COLOR_27 = 'hsl(16, 77%, 38%)';
    string private constant COLOR_28 = 'hsl(17, 77%, 38%)';
    string private constant COLOR_29 = 'hsl(18, 78%, 39%)';
    string private constant COLOR_30 = 'hsl(18, 78%, 38%)';
    string private constant COLOR_31 = 'hsl(16, 76%, 37%)';
    string private constant COLOR_32 = 'hsl(9, 58%, 21%)';
    string private constant COLOR_33 = 'hsl(17, 73%, 38%)';
    string private constant COLOR_34 = 'hsl(16, 70%, 36%)';
    string private constant COLOR_35 = 'hsl(15, 69%, 30%)';
    string private constant COLOR_36 = 'hsl(18, 78%, 39%)';
    string private constant COLOR_37 = 'hsl(9, 56%, 22%)';
    string private constant COLOR_38 = 'hsl(27, 74%, 46%)';
    string private constant COLOR_39 = 'hsl(24, 71%, 44%)';
    string private constant COLOR_40 = 'hsl(23, 72%, 42%)';
    string private constant COLOR_41 = 'hsl(14, 60%, 31%)';
    string private constant COLOR_42 = 'hsl(22, 65%, 39%)';
    string private constant COLOR_43 = 'hsl(23, 75%, 39%)';
    string private constant COLOR_44 = 'hsl(26, 74%, 44%)';
    string private constant COLOR_45 = 'hsl(17, 64%, 36%)';
    string private constant COLOR_46 = 'hsl(13, 58%, 31%)';
    string private constant COLOR_47 = 'hsl(23, 75%, 42%)';
    string private constant COLOR_48 = 'hsl(19, 69%, 36%)';
    string private constant COLOR_49 = 'hsl(18, 74%, 39%)';
    string private constant COLOR_50 = 'hsl(13, 53%, 32%)';
    string private constant COLOR_51 = 'hsl(16, 54%, 28%)';
    string private constant COLOR_52 = 'hsl(12, 61%, 27%)';
    string private constant COLOR_53 = 'hsl(21, 73%, 39%)';
    string private constant COLOR_54 = 'hsl(20, 64%, 39%)';
    string private constant COLOR_55 = 'hsl(26, 52%, 50%)';
    string private constant COLOR_56 = 'hsl(20, 67%, 40%)';
    string private constant COLOR_57 = 'hsl(22, 58%, 40%)';
    string private constant COLOR_58 = 'hsl(10, 53%, 23%)';
    string private constant COLOR_59 = 'hsl(9, 58%, 21%)';
    string private constant COLOR_60 = 'hsl(15, 76%, 35%)';
    string private constant COLOR_61 = 'hsl(18, 55%, 43%)';
    string private constant COLOR_62 = 'hsl(14, 74%, 33%)';
    string private constant COLOR_63 = 'hsl(13, 58%, 33%)';
    string private constant COLOR_64 = 'hsl(20, 54%, 36%)';
    string private constant COLOR_65 = 'hsl(14, 51%, 36%)';
    string private constant COLOR_66 = 'hsl(10, 53%, 24%)';
    string private constant COLOR_67 = 'hsl(13, 61%, 29%)';
    string private constant COLOR_68 = 'hsl(13, 60%, 30%)';
    string private constant COLOR_69 = 'hsl(34, 76%, 56%)';
    string private constant COLOR_70 = 'hsl(11, 56%, 28%)';
    string private constant COLOR_71 = 'hsl(18, 75%, 34%)';
    string private constant COLOR_72 = 'hsl(25, 59%, 44%)';
    string private constant COLOR_73 = 'hsl(23, 71%, 44%)';
    string private constant COLOR_74 = 'hsl(19, 66%, 38%)';
    string private constant COLOR_75 = 'hsl(14, 41%, 44%)';
    string private constant COLOR_76 = 'hsl(13, 49%, 34%)';
    string private constant COLOR_77 = 'hsl(24, 60%, 43%)';
    string private constant COLOR_78 = 'hsl(14, 72%, 31%)';
    string private constant COLOR_79 = 'hsl(12, 55%, 29%)';
    string private constant COLOR_80 = 'hsl(11, 39%, 35%)';
    string private constant COLOR_81 = 'hsl(12, 37%, 39%)';
    string private constant COLOR_82 = 'hsl(10, 49%, 27%)';
    string private constant COLOR_83 = 'hsl(16, 77%, 37%)';
    string private constant COLOR_84 = 'hsl(21, 67%, 43%)';
    string private constant COLOR_85 = 'hsl(24, 44%, 50%)';
    string private constant COLOR_86 = 'hsl(11, 42%, 33%)';
    string private constant COLOR_87 = 'hsl(21, 57%, 45%)';
    string private constant COLOR_88 = 'hsl(25, 69%, 46%)';
    string private constant COLOR_89 = 'hsl(12, 65%, 25%)';
    string private constant COLOR_90 = 'hsl(32, 70%, 54%)';
    string private constant COLOR_91 = 'hsl(15, 65%, 39%)';
    string private constant COLOR_92 = 'hsl(29, 47%, 37%)';
    string private constant COLOR_93 = 'hsl(13, 55%, 35%)';
    string private constant COLOR_94 = 'hsl(15, 61%, 40%)';
    string private constant COLOR_95 = 'hsl(13, 34%, 45%)';
    string private constant COLOR_96 = 'hsl(11, 46%, 29%)';
    string private constant COLOR_97 = 'hsl(29, 41%, 45%)';
    string private constant COLOR_98 = 'hsl(36, 69%, 59%)';
    string private constant COLOR_99 = 'hsl(25, 39%, 45%)';
    string private constant COLOR_100 = 'hsl(14, 43%, 43%)';
    string private constant COLOR_101 = 'hsl(14, 73%, 32%)';
    string private constant COLOR_102 = 'hsl(27, 49%, 51%)';
    string private constant COLOR_103 = 'hsl(30, 86%, 51%)';
    string private constant COLOR_104 = 'hsl(13, 70%, 29%)';
    string private constant COLOR_105 = 'hsl(31, 61%, 54%)';
    string private constant COLOR_106 = 'hsl(15, 54%, 41%)';
    string private constant COLOR_107 = 'hsl(35, 44%, 45%)';
    string private constant COLOR_108 = 'hsl(10, 58%, 21%)';
    string private constant COLOR_109 = 'hsl(9, 57%, 23%)';
    string private constant COLOR_110 = 'hsl(25, 76%, 36%)';

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
            PART_111
        );
        return result;
    }
}
