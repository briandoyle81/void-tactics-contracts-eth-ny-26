// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderAft2Probe {
    string private constant PART_1 = '<path d="M201 67 L202 67 L202 88 L211 88 L212 89 L212 96 L219 96 L220 95 L228 95 L229 91 L229 95 L236 96 L236 99 L240 101 L240 105 L249 105 L253 109 L253 133 L248 138 L239 139 L236 143 L243 143 L247 147 L247 161 L246 163 L244 163 L244 165 L235 166 L248 169 L249 171 L249 188 L246 191 L238 192 L236 193 L230 193 L231 194 L231 202 L230 204 L221 205 L219 207 L189 207 L184 205 L178 205 L176 201 L171 199 L171 197 L169 197 L169 195 L165 194 L160 189 L160 187 L156 187 L156 193 L154 195 L146 198 L132 198 L131 197 L108 197 L107 196 L107 185 L108 184 L114 184 L113 182 L104 181 L102 179 L102 169 L104 167 L115 166 L121 161 L127 160 L163 159 L165 156 L166 145 L175 136 L176 116 L168 116 L168 104 L169 102 L181 102 L182 97 L187 95 L188 88 L196 88 L196 83 L197 83 L197 88 L201 88 Z M159 173 L162 174 L163 183 L166 183 L167 187 L169 187 L171 185 L176 186 L176 181 L180 178 L180 189 L187 189 L187 184 L192 181 L193 188 L200 189 L206 188 L208 189 L208 187 L212 186 L210 185 L212 185 L213 181 L216 181 L220 185 L222 186 L223 183 L225 181 L227 180 L228 187 L235 185 L236 180 L239 179 L241 182 L241 190 L236 193 L230 193 L231 194 L231 202 L230 204 L221 205 L219 207 L189 207 L184 205 L178 205 L176 201 L171 199 L171 197 L169 197 L169 195 L165 194 L160 189 L160 187 L156 187 L156 193 L154 195 L146 198 L132 198 L131 197 L108 197 L107 196 L107 185 L108 184 L114 184 L113 182 L104 181 L104 180 L112 179 L115 176 L119 177 L121 180 L123 177 L123 184 L126 184 L127 182 L127 184 L129 183 L130 180 L132 181 L134 183 L134 178 L143 178 L143 179 L135 179 L135 183 L139 182 L151 181 L153 177 L153 182 L156 182 L156 174 Z M159 175 L159 177 L161 176 Z M219 186 Z M188 190 Z M234 184 Z M201 187 Z M184 188 Z M195 201 L198 202 L197 207 L189 207 L194 202 Z M194 203 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M201 67 L202 67 L202 88 L211 88 L212 89 L212 96 L219 96 L220 95 L228 95 L229 91 L229 95 L236 96 L236 99 L240 101 L240 105 L249 105 L253 109 L253 130 L250 129 L250 132 L241 133 L241 114 L239 114 L239 128 L237 128 L235 135 L233 137 L226 137 L225 134 L228 134 L227 111 L226 112 L226 119 L222 119 L221 119 L221 129 L218 128 L218 121 L217 121 L215 122 L213 121 L212 123 L211 121 L206 121 L202 123 L200 119 L197 119 L196 117 L195 124 L191 125 L189 130 L187 131 L186 126 L185 125 L185 113 L191 107 L207 106 L207 103 L205 105 L194 105 L188 100 L188 102 L190 102 L188 107 L185 107 L185 103 L183 103 L182 97 L187 95 L188 88 L196 88 L196 83 L197 83 L197 88 L201 88 Z M218 114 Z M219 115 Z M214 116 Z M215 117 Z M244 130 L245 132 Z M217 129 Z M216 132 Z M121 161 Z M120 162 Z M119 163 Z M117 164 L119 165 L117 167 L116 176 L113 177 L112 171 L108 170 L108 168 L106 168 L106 170 L103 170 L103 179 L102 179 L102 169 L104 167 L115 166 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M201 67 L202 67 L202 88 L211 88 L212 89 L212 100 L214 100 L214 106 L224 107 L224 110 L219 110 L222 112 L222 115 L198 115 L196 117 L195 124 L191 125 L189 130 L187 131 L186 126 L185 125 L185 113 L191 107 L207 106 L207 103 L205 105 L194 105 L188 100 L188 102 L190 102 L188 107 L185 107 L185 103 L183 103 L182 97 L187 95 L188 88 L196 88 L196 83 L197 83 L197 88 L201 88 Z M202 115 Z M199 115 L204 116 L205 115 L212 115 L217 120 L215 122 L213 121 L212 123 L211 121 L206 121 L202 123 L200 119 L197 119 L197 116 Z M214 115 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M171 164 L183 165 L184 169 L180 173 L179 178 L177 178 L176 186 L171 186 L169 189 L169 187 L167 187 L166 190 L166 165 Z M178 171 L177 173 L179 173 Z M184 169 L191 169 L189 173 L191 175 L191 182 L188 187 L188 190 L182 190 L180 189 L180 174 Z M189 176 Z M184 188 Z M196 172 L212 172 L212 181 L208 183 L198 183 L197 181 L193 183 L192 176 Z M192 174 Z M191 175 Z M211 182 Z M188 190 Z M196 117 L197 119 L201 118 L202 121 L206 120 L211 120 L216 121 L217 121 L217 127 L215 130 L213 130 L213 132 L205 132 L202 131 L204 133 L199 133 L196 129 Z M186 124 L188 125 L187 129 L190 129 L192 136 L193 138 L189 139 L185 134 L185 125 Z M192 124 L195 124 L197 131 L199 133 L220 134 L220 137 L209 138 L201 137 L201 141 L198 140 L197 141 L193 136 L191 135 L191 125 Z M224 107 L236 107 L239 110 L239 128 L236 127 L235 111 L233 109 L226 108 L226 119 L222 119 L220 115 L222 115 L222 113 L218 111 L219 109 L224 109 Z M198 114 L218 114 L221 119 L221 129 L218 128 L218 121 L214 116 L205 116 L201 116 L197 115 Z M202 115 Z M217 129 Z M216 132 Z M227 123 L228 123 L228 134 L225 133 L226 132 Z M237 129 L239 129 L239 134 L237 137 L235 137 L234 141 L221 141 L221 136 L225 134 L226 137 L233 136 L236 134 Z M244 106 L249 107 L251 109 L250 112 L245 113 L243 114 Z M249 106 Z M241 107 L243 108 L243 111 L241 111 Z M240 111 Z M190 155 L191 158 L195 157 L196 155 L195 164 L191 165 Z M225 109 L226 112 L226 119 L222 119 L221 115 L222 113 L220 112 L223 112 Z M131 188 L132 188 L133 195 L131 194 Z M133 189 L141 190 L140 194 L133 193 Z M141 189 Z M224 120 L226 120 L226 131 L223 129 L223 121 Z M224 121 Z M222 131 L224 133 L221 132 Z M224 131 Z M219 179 L223 180 L223 187 L218 184 Z M219 180 Z M219 186 Z M194 197 Z M192 198 L195 199 L194 203 L190 204 L189 199 Z M194 203 Z M189 204 Z M188 205 Z M190 144 L196 144 L198 145 L196 149 L195 146 L190 147 Z M232 171 L236 171 L235 175 L234 173 L232 173 L232 176 L230 176 L230 172 Z M227 103 L232 103 L232 106 L225 106 Z M217 198 L218 198 L218 203 L213 202 L213 199 Z M136 166 L142 166 L141 169 L136 169 Z M187 144 L189 144 L189 146 L183 148 L184 145 Z M182 148 Z M181 149 Z M183 149 L185 150 Z M185 151 L186 155 L184 159 L182 159 L183 155 Z M224 145 L229 146 L228 149 L224 147 Z M111 191 L115 191 L114 194 L111 194 Z M187 156 L189 156 L189 161 L186 159 Z M168 149 L171 150 L171 153 L168 153 Z M131 179 L134 179 L134 183 L131 182 Z M182 110 L186 110 L186 112 L183 113 Z M132 166 L135 166 L135 169 L132 168 Z M179 132 L181 132 L182 135 L178 134 Z M232 146 L235 147 L234 149 L232 149 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M191 107 L224 107 L224 110 L219 110 L222 112 L222 115 L198 115 L196 117 L195 124 L191 125 L189 130 L187 131 L186 126 L185 125 L185 113 Z M202 115 Z M199 115 L204 116 L205 115 L212 115 L217 120 L215 122 L213 121 L212 123 L211 121 L206 121 L202 123 L200 119 L197 119 L197 116 Z M214 115 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M205 144 L213 144 L214 146 L218 146 L219 144 L229 146 L229 156 L225 156 L224 159 L221 159 L219 157 L219 150 L217 150 L218 153 L216 154 L215 153 L212 160 L209 160 L207 156 L206 157 L205 160 L201 159 L201 161 L197 160 L197 152 L200 149 L205 149 Z M213 151 Z M200 153 L201 155 L203 154 Z M210 155 Z M211 156 Z M208 157 Z M191 146 L195 146 L196 148 L199 148 L197 152 L195 157 L191 158 L190 154 L192 153 L190 152 L190 148 Z M192 151 Z M202 160 Z M206 160 Z M188 174 L191 175 L191 182 L188 187 L188 190 L182 190 L180 189 L181 185 L183 185 L184 180 L186 183 L187 175 Z M189 176 Z M184 188 Z M192 174 Z M191 175 Z M192 176 Z M188 190 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M181 98 L183 101 L183 103 L185 103 L185 107 L188 105 L190 104 L190 102 L188 102 L188 100 L191 101 L194 104 L205 104 L207 101 L207 103 L209 104 L207 104 L208 107 L191 108 L186 113 L185 118 L184 132 L177 130 L177 114 L174 111 L174 103 L180 102 Z M215 102 L219 104 L219 106 L222 105 L223 108 L213 107 Z M229 197 L231 200 L230 204 L228 204 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M154 169 L156 169 L156 182 L153 182 L152 182 L143 183 L139 182 L138 184 L135 183 L135 179 L131 178 L131 170 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M226 108 L233 108 L236 111 L236 134 L233 137 L226 137 L225 134 L228 134 L227 115 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M244 106 L249 107 L251 109 L250 114 L250 132 L241 133 L240 111 L242 107 L243 108 Z M244 130 L245 132 Z M249 106 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M191 107 L224 107 L224 110 L219 110 L222 112 L222 115 L206 114 L204 113 L196 113 L192 116 L193 112 L187 116 L186 113 Z M187 113 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M228 91 L229 95 L236 96 L236 99 L240 101 L240 104 L238 104 L238 106 L236 105 L235 103 L227 104 L222 106 L217 105 L215 102 L216 97 L220 95 L228 95 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M193 169 L212 170 L212 172 L192 172 Z M212 172 L215 172 L215 182 L213 183 L212 181 Z M197 180 L198 183 L205 182 L211 182 L212 186 L211 188 L208 187 L209 190 L205 190 L204 188 L198 190 L193 188 L193 183 Z M201 187 Z M211 181 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M196 172 L212 172 L212 181 L208 183 L198 183 L197 181 L193 183 L192 177 Z M211 182 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M241 169 L245 169 L245 191 L240 191 L240 185 L236 181 L231 182 L230 176 L232 176 L232 173 L236 174 L239 171 L241 171 Z M234 180 Z M200 89 L203 90 L203 92 L200 92 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M196 83 L197 83 L197 88 L210 89 L210 91 L208 91 L208 94 L203 94 L203 97 L192 97 L196 95 L189 94 L189 96 L191 97 L185 98 L183 96 L187 95 L188 88 L196 88 Z M182 97 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M133 185 L146 185 L147 187 L150 186 L150 188 L153 188 L154 192 L147 194 L146 193 L138 194 L133 193 L132 195 L131 194 L131 188 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M118 165 L122 165 L123 168 L125 167 L129 168 L130 175 L125 178 L122 181 L117 178 L116 176 L116 167 Z M217 150 L219 150 L220 156 L223 158 L223 163 L219 165 L219 159 L217 159 L216 154 Z M200 153 L203 154 L200 154 Z M214 154 L216 155 L216 160 L213 163 L211 162 L213 155 Z M200 155 L201 159 L203 160 L200 160 Z M206 155 L208 156 L209 159 L210 162 L207 162 L205 157 Z M210 155 Z M211 156 Z M208 157 L210 158 Z M204 159 L206 160 L206 163 L211 163 L210 165 L205 164 L202 161 Z M197 160 Z M198 161 L201 161 L201 163 L203 163 L202 165 Z M222 164 Z M203 165 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M232 146 L240 146 L241 147 L241 160 L240 161 L232 161 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M169 102 L180 102 L180 103 L174 103 L176 105 L176 113 L178 114 L177 130 L176 130 L176 116 L168 116 L168 104 Z M248 173 L249 173 L249 188 L245 191 L245 181 L247 182 L247 175 Z M242 143 L247 147 L247 156 L246 156 L245 151 L244 156 L243 156 Z M211 96 L217 96 L215 105 L214 105 L214 100 L212 100 L211 102 Z M217 97 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M166 165 L174 165 L176 167 L179 168 L177 173 L176 177 L166 178 Z M167 169 L167 170 L172 170 L172 169 Z M173 169 Z M179 168 Z M178 169 Z M205 151 L207 153 L204 153 Z M203 153 L205 155 L203 155 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M177 114 L183 114 L184 118 L184 132 L177 130 Z M106 168 L108 168 L108 170 L113 170 L113 179 L112 180 L103 180 L103 170 L106 170 Z M184 180 L185 180 L186 185 L188 189 L185 190 L180 189 L181 185 L183 185 Z M184 188 Z M188 190 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M191 146 L195 146 L196 148 L199 148 L197 152 L195 157 L191 158 L190 154 L192 153 L190 152 L190 148 Z M192 151 Z M200 149 Z M199 150 L203 151 L198 152 Z M205 150 Z M204 151 Z M206 151 L211 151 L211 152 L206 152 Z M197 152 Z M202 152 L204 153 Z M211 152 Z M213 152 Z M204 153 Z M206 153 L211 153 L213 159 L210 161 L207 158 L206 156 L204 155 Z M210 155 Z M208 157 Z M212 153 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M201 149 L205 149 L204 152 L202 151 Z M206 149 L211 149 L211 151 L206 151 Z M212 149 L217 149 L218 153 L216 154 L216 152 L212 153 L211 151 Z M200 150 Z M205 151 L211 152 L211 153 L205 154 Z M198 152 L202 153 L201 155 L201 161 L197 160 L197 153 Z M202 153 L205 154 L206 160 L201 159 Z M211 153 Z M213 153 L215 154 L212 157 Z M202 160 Z M206 160 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M183 97 L192 98 L192 100 L204 100 L203 103 L196 104 L193 102 L191 103 L188 100 L188 102 L190 102 L188 107 L185 107 L185 103 L183 103 L182 98 Z M205 100 L211 100 L211 102 L207 103 L205 105 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M202 115 Z M199 115 L204 116 L205 115 L212 115 L217 120 L215 122 L213 121 L212 123 L211 121 L206 121 L202 123 L200 119 L197 119 Z M214 115 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M196 172 L212 172 L212 177 L193 177 L195 173 Z M192 177 Z M166 165 L172 165 L172 169 L166 170 Z M173 165 L176 168 L176 170 L173 169 Z M176 167 Z M172 169 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M218 170 L223 170 L223 187 L218 184 Z M219 186 Z M109 185 L112 186 L110 186 L110 191 L107 192 L107 186 Z M112 186 L118 187 L118 192 L116 192 L114 194 L111 194 L111 187 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M211 93 Z M189 94 L197 94 L196 96 L203 97 L203 94 L211 94 L211 96 L206 97 L203 100 L192 100 L192 98 L189 97 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M198 114 L218 114 L221 119 L221 129 L218 128 L218 121 L214 116 L205 116 L201 116 L197 115 Z M202 115 Z M220 115 Z M217 129 Z M216 132 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M242 173 L245 174 L245 191 L240 191 L241 174 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M235 144 L242 144 L243 146 L243 161 L241 161 L241 165 L235 165 L235 161 L240 160 L240 147 L235 147 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M187 111 Z M186 112 Z M185 113 L187 115 L190 114 L190 129 L187 131 L186 126 L185 125 Z M187 113 Z M137 172 L152 172 L154 174 L138 175 L136 173 Z M135 174 Z M132 175 L135 176 Z M196 117 Z M200 118 L202 120 L203 127 L199 127 L197 127 L197 119 Z M129 172 L130 175 L127 174 Z M123 174 L128 176 L123 180 Z M209 107 L224 107 L224 110 L209 108 Z M187 151 L189 151 L189 155 L186 155 Z M215 149 L217 149 L218 153 L216 154 L216 152 L214 152 Z M171 103 L173 103 L173 107 L170 107 Z M194 89 L196 89 L196 92 L192 92 L192 90 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M180 174 L187 176 L187 183 L185 186 L183 187 L183 185 L180 186 Z M218 98 L224 98 L224 106 L219 106 L217 105 L217 99 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M206 120 L211 120 L213 124 L213 127 L211 128 L205 128 L204 127 L204 122 Z M210 126 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M164 164 L165 168 L165 184 L163 185 L162 183 L162 166 Z M194 109 L197 109 L197 111 L194 112 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M200 153 L203 154 L200 154 Z M200 155 L201 159 L203 160 L200 160 Z M206 155 L208 156 L209 159 L210 162 L207 162 L205 157 Z M208 157 L210 158 Z M204 159 L206 160 L207 164 L202 162 Z M197 160 Z M198 161 L201 161 L201 163 L203 163 L202 165 Z M203 165 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M124 167 L129 168 L130 175 L125 178 L123 180 L123 174 L127 174 L127 171 L125 171 L125 173 L123 173 L123 168 Z M220 107 L225 108 L224 110 L220 109 Z" style="fill:';
    string private constant PART_39 = ';"/><path d="M201 150 L203 151 L199 152 Z M205 150 Z M204 151 Z M206 151 L211 151 L211 152 L206 152 Z M202 152 L204 153 Z M211 152 Z M213 152 Z M204 153 Z M206 153 L211 153 L213 159 L210 161 L207 158 L206 156 L204 155 Z M210 155 Z M208 157 Z M212 153 Z" style="fill:';
    string private constant PART_40 = ';"/><path d="M205 100 L214 100 L214 106 L207 108 L207 103 L205 105 Z" style="fill:';
    string private constant PART_41 = ';"/><path d="M186 146 L189 146 L189 155 L185 154 L182 156 L182 149 Z M183 149 Z M182 147 Z M119 168 L122 169 L122 175 L117 178 L116 174 L117 169 Z" style="fill:';
    string private constant PART_42 = ';"/><path d="M244 149 L246 151 L247 161 L246 163 L244 163 L244 165 L241 165 L241 161 L243 161 Z" style="fill:';
    string private constant PART_43 = ';"/><path d="M180 115 L183 117 L184 118 L183 126 L179 125 L178 128 L178 116 Z" style="fill:';
    string private constant PART_44 = ';"/><path d="M204 111 L222 111 L222 115 L206 114 Z" style="fill:';
    string private constant PART_45 = ';"/><path d="M127 175 L130 175 L130 183 L126 184 L123 184 L124 178 Z M193 169 L212 170 L212 172 L192 172 Z M212 172 Z M230 147 L231 147 L232 153 L231 156 L229 156 Z M225 156 L229 156 L229 164 L228 161 L224 162 Z M201 198 L203 198 L203 204 L198 206 L198 202 L196 202 L197 199 Z M177 195 L181 196 L184 197 L184 201 L177 200 Z M123 163 L128 163 L128 165 L130 166 L130 171 L129 168 L123 168 Z M128 164 Z M118 165 L122 165 L122 169 L117 169 L117 174 L116 174 L116 167 Z M122 169 Z M220 157 L223 158 L223 163 L219 165 L219 158 Z M222 164 Z" style="fill:';
    string private constant PART_46 = ';"/><path d="M172 149 L180 149 L180 155 L173 156 L172 155 Z M207 97 L212 97 L211 100 L205 100 Z" style="fill:';
    string private constant PART_47 = ';"/><path d="M228 91 L229 95 L233 95 L233 97 L219 97 L220 95 L228 95 Z M216 97 L218 99 L217 104 L215 102 Z M218 97 Z" style="fill:';
    string private constant PART_48 = ';"/><path d="M227 172 L229 172 L229 188 L227 187 L227 180 L224 183 L224 176 L226 177 Z" style="fill:';
    string private constant PART_49 = ';"/><path d="M185 169 L191 169 L189 173 L186 176 L181 175 L183 171 Z" style="fill:';
    string private constant PART_50 = ';"/><path d="M221 146 L223 146 L223 158 L221 159 L219 157 L219 147 Z" style="fill:';
    string private constant PART_51 = ';"/><path d="M224 147 L229 149 L229 156 L225 156 L224 159 Z M209 115 L213 116 L211 117 L211 119 L209 118 Z" style="fill:';
    string private constant PART_52 = ';"/><path d="M235 150 L241 150 L240 157 L235 158 Z" style="fill:';
    string private constant PART_53 = ';"/><path d="M232 173 L236 174 L236 181 L231 182 L230 176 L232 176 Z M234 180 Z M106 168 L108 168 L108 170 L113 170 L112 175 L104 174 L103 170 L106 170 Z M112 175 Z" style="fill:';
    string private constant PART_54 = ';"/><path d="M206 149 L211 149 L211 151 L206 151 Z M212 149 L217 149 L218 153 L216 154 L216 152 L212 153 L211 151 Z M207 152 L211 153 Z M211 153 Z M213 153 L215 154 L212 157 Z" style="fill:';
    string private constant PART_55 = ';"/><path d="M190 108 L194 109 L189 110 Z M188 110 L200 111 L196 113 L192 116 L193 112 L187 116 L186 113 Z M187 113 Z" style="fill:';
    string private constant PART_56 = ';"/><path d="M225 98 L232 98 L232 103 L225 105 Z M189 89 L196 89 L196 92 L189 92 Z" style="fill:';
    string private constant PART_57 = ';"/><path d="M171 103 L173 103 L173 112 L168 112 L168 105 Z" style="fill:';
    string private constant PART_58 = ';"/><path d="M192 100 L204 100 L203 103 L196 104 L192 102 Z" style="fill:';
    string private constant PART_59 = ';"/><path d="M224 196 L226 196 L226 198 L228 198 L228 204 L223 204 L223 197 Z" style="fill:';
    string private constant PART_60 = ';"/><path d="M242 173 L245 174 L245 182 L241 182 L241 174 Z" style="fill:';
    string private constant PART_61 = ';"/><path d="M104 167 L111 167 L113 168 L113 170 L108 170 L108 168 L106 168 L106 170 L103 170 L103 179 L102 179 L102 169 Z" style="fill:';
    string private constant PART_62 = ';"/><path d="M188 88 L196 88 L196 89 L189 89 L189 92 L192 93 L189 94 L189 96 L191 97 L185 98 L183 96 L187 95 Z M182 97 Z" style="fill:';
    string private constant PART_63 = ';"/><path d="M224 107 L235 107 L235 110 L233 109 L225 109 Z M219 109 L224 110 L223 113 L218 111 Z M224 109 Z" style="fill:';
    string private constant PART_64 = ';"/><path d="M205 151 L207 153 L204 153 Z M203 153 L206 156 L205 160 L201 159 L202 155 Z M202 160 Z M206 160 Z" style="fill:';
    string private constant PART_65 = ';"/><path d="M176 106 L180 106 L180 113 L176 113 Z" style="fill:';
    string private constant PART_66 = ';"/><path d="M206 101 L207 103 L209 104 L207 104 L208 107 L192 107 L192 106 L202 105 L205 104 Z" style="fill:';
    string private constant PART_67 = ';"/><path d="M235 96 L236 99 L240 101 L240 104 L238 104 L238 106 L236 105 L234 97 Z" style="fill:';
    string private constant PART_68 = ';"/><path d="M230 180 L231 182 L236 181 L235 186 L230 187 Z M234 184 Z M234 180 Z M218 153 L220 157 L219 159 L217 159 L217 154 Z M220 156 Z" style="fill:';
    string private constant PART_69 = ';"/><path d="M194 176 L212 177 L212 178 L199 178 L198 180 L198 178 L193 179 Z M231 118 Z M232 119 L234 121 L231 123 Z M232 123 Z" style="fill:';
    string private constant PART_70 = ';"/><path d="M188 100 L191 101 L194 104 L202 105 L202 106 L192 106 L189 107 L188 104 L190 104 L190 102 L188 102 Z" style="fill:';
    string private constant PART_71 = ';"/><path d="M205 144 L213 144 L212 147 L205 148 Z M209 146 Z" style="fill:';
    string private constant PART_72 = ';"/><path d="M240 160 L241 160 L241 165 L235 165 L235 161 Z" style="fill:';
    string private constant PART_73 = ';"/><path d="M191 107 L199 107 L197 111 L194 112 L189 111 L192 109 Z M221 146 L223 146 L223 151 L219 151 L219 147 Z" style="fill:';
    string private constant PART_74 = ';"/><path d="M218 98 L224 98 L223 103 L220 103 L217 99 Z M199 115 L204 117 L203 120 L197 119 Z M202 115 Z M201 120 Z" style="fill:';
    string private constant PART_75 = ';"/><path d="M240 154 L241 154 L241 160 L240 161 L235 161 L235 158 L240 157 Z" style="fill:';
    string private constant PART_76 = ';"/><path d="M236 146 L241 147 L241 150 L235 150 Z" style="fill:';
    string private constant PART_77 = ';"/><path d="M225 111 L227 111 L228 115 L228 122 L226 122 L225 119 Z" style="fill:';
    string private constant PART_78 = ';"/><path d="M205 115 L209 115 L208 119 L203 120 Z M202 120 Z" style="fill:';
    string private constant PART_79 = ';"/><path d="M183 97 L188 97 L185 103 L183 103 L182 98 Z" style="fill:';
    string private constant PART_80 = ';"/><path d="M202 89 L210 89 L210 91 L203 92 Z" style="fill:';
    string private constant PART_81 = ';"/><path d="M209 146 Z M211 146 L214 147 L214 149 L212 149 L211 151 L211 149 L205 150 L206 147 Z" style="fill:';
    string private constant PART_82 = ';"/><path d="M188 124 L190 124 L190 129 L187 131 L186 126 Z" style="fill:';
    string private constant PART_83 = ';"/><path d="M186 101 L190 102 L188 107 L185 107 Z" style="fill:';
    string private constant PART_84 = ';"/><path d="M241 182 L245 182 L245 186 L241 187 Z" style="fill:';
    string private constant PART_85 = ';"/><path d="M241 171 L245 172 L244 174 L242 174 L241 182 L240 182 L240 172 Z" style="fill:';
    string private constant PART_86 = ';"/><path d="M181 175 L186 175 L187 177 L185 180 L183 180 L183 176 Z" style="fill:';
    string private constant PART_87 = ';"/><path d="M241 169 L245 169 L245 172 L241 171 Z M239 171 L241 172 L239 175 Z" style="fill:';
    string private constant PART_88 = ';"/><path d="M200 144 L204 144 L204 148 L200 148 Z" style="fill:';
    string private constant PART_89 = ';"/><path d="M245 111 L250 112 L249 116 L244 115 Z" style="fill:';
    string private constant PART_90 = ';"/><path d="M224 196 L226 196 L226 198 L228 198 L228 200 L223 200 Z" style="fill:';
    string private constant PART_91 = ';"/><path d="M223 194 L228 194 L228 198 L226 198 L226 196 L223 197 Z" style="fill:';
    string private constant PART_92 = ';"/><path d="M232 156 L235 156 L235 161 L232 161 Z" style="fill:';
    string private constant PART_93 = ';"/><path d="M105 170 Z M107 170 L108 172 L110 173 L107 174 L104 174 L104 172 Z" style="fill:';
    string private constant PART_94 = ';"/><path d="M119 188 L122 190 L121 194 L119 193 Z" style="fill:';
    string private constant PART_95 = ';"/><path d="M241 179 L245 179 L245 182 L241 182 Z" style="fill:';
    string private constant PART_96 = ';"/><path d="M107 187 L110 188 L109 191 L107 192 Z" style="fill:';
    string private constant PART_97 = ';"/><path d="M251 109 L253 109 L252 111 Z M250 110 L252 112 L251 115 L249 113 Z" style="fill:';
    string private constant PART_98 = ';"/><path d="M194 176 L198 178 L193 179 Z M198 176 Z" style="fill:';
    string private constant PART_99 = ';"/><path d="M242 173 L245 174 L245 176 L241 176 Z" style="fill:';
    string private constant PART_100 = ';"/>';
    string private constant COLOR_1 = 'hsl(215, 25%, 9%)';
    string private constant COLOR_2 = 'hsl(218, 19%, 11%)';
    string private constant COLOR_3 = 'hsl(0, 6%, 19%)';
    string private constant COLOR_4 = 'hsl(213, 10%, 17%)';
    string private constant COLOR_5 = 'hsl(150, 1%, 29%)';
    string private constant COLOR_6 = 'hsl(216, 12%, 16%)';
    string private constant COLOR_7 = 'hsl(216, 16%, 12%)';
    string private constant COLOR_8 = 'hsl(214, 8%, 17%)';
    string private constant COLOR_9 = 'hsl(0, 0%, 25%)';
    string private constant COLOR_10 = 'hsl(213, 10%, 18%)';
    string private constant COLOR_11 = 'hsl(120, 1%, 31%)';
    string private constant COLOR_12 = 'hsl(210, 16%, 13%)';
    string private constant COLOR_13 = 'hsl(214, 7%, 19%)';
    string private constant COLOR_14 = 'hsl(26, 5%, 28%)';
    string private constant COLOR_15 = 'hsl(214, 7%, 19%)';
    string private constant COLOR_16 = 'hsl(216, 16%, 13%)';
    string private constant COLOR_17 = 'hsl(220, 6%, 20%)';
    string private constant COLOR_18 = 'hsl(213, 11%, 16%)';
    string private constant COLOR_19 = 'hsl(17, 11%, 24%)';
    string private constant COLOR_20 = 'hsl(215, 26%, 9%)';
    string private constant COLOR_21 = 'hsl(120, 1%, 31%)';
    string private constant COLOR_22 = 'hsl(210, 9%, 18%)';
    string private constant COLOR_23 = 'hsl(180, 1%, 29%)';
    string private constant COLOR_24 = 'hsl(120, 1%, 31%)';
    string private constant COLOR_25 = 'hsl(120, 1%, 30%)';
    string private constant COLOR_26 = 'hsl(48, 2%, 40%)';
    string private constant COLOR_27 = 'hsl(180, 1%, 27%)';
    string private constant COLOR_28 = 'hsl(210, 6%, 20%)';
    string private constant COLOR_29 = 'hsl(20, 2%, 24%)';
    string private constant COLOR_30 = 'hsl(210, 13%, 16%)';
    string private constant COLOR_31 = 'hsl(17, 40%, 19%)';
    string private constant COLOR_32 = 'hsl(300, 1%, 19%)';
    string private constant COLOR_33 = 'hsl(180, 1%, 27%)';
    string private constant COLOR_34 = 'hsl(180, 1%, 27%)';
    string private constant COLOR_35 = 'hsl(195, 3%, 24%)';
    string private constant COLOR_36 = 'hsl(195, 3%, 24%)';
    string private constant COLOR_37 = 'hsl(213, 11%, 15%)';
    string private constant COLOR_38 = 'hsl(120, 1%, 30%)';
    string private constant COLOR_39 = 'hsl(50, 3%, 42%)';
    string private constant COLOR_40 = 'hsl(17, 20%, 20%)';
    string private constant COLOR_41 = 'hsl(180, 1%, 28%)';
    string private constant COLOR_42 = 'hsl(213, 19%, 12%)';
    string private constant COLOR_43 = 'hsl(150, 1%, 30%)';
    string private constant COLOR_44 = 'hsl(60, 2%, 41%)';
    string private constant COLOR_45 = 'hsl(213, 11%, 17%)';
    string private constant COLOR_46 = 'hsl(213, 10%, 17%)';
    string private constant COLOR_47 = 'hsl(206, 8%, 18%)';
    string private constant COLOR_48 = 'hsl(210, 8%, 19%)';
    string private constant COLOR_49 = 'hsl(214, 7%, 20%)';
    string private constant COLOR_50 = 'hsl(150, 1%, 30%)';
    string private constant COLOR_51 = 'hsl(180, 1%, 28%)';
    string private constant COLOR_52 = 'hsl(24, 57%, 53%)';
    string private constant COLOR_53 = 'hsl(150, 1%, 29%)';
    string private constant COLOR_54 = 'hsl(180, 2%, 25%)';
    string private constant COLOR_55 = 'hsl(52, 3%, 46%)';
    string private constant COLOR_56 = 'hsl(60, 1%, 34%)';
    string private constant COLOR_57 = 'hsl(210, 9%, 17%)';
    string private constant COLOR_58 = 'hsl(23, 50%, 49%)';
    string private constant COLOR_59 = 'hsl(16, 38%, 20%)';
    string private constant COLOR_60 = 'hsl(27, 72%, 62%)';
    string private constant COLOR_61 = 'hsl(213, 18%, 12%)';
    string private constant COLOR_62 = 'hsl(213, 22%, 10%)';
    string private constant COLOR_63 = 'hsl(210, 6%, 21%)';
    string private constant COLOR_64 = 'hsl(150, 1%, 28%)';
    string private constant COLOR_65 = 'hsl(204, 5%, 21%)';
    string private constant COLOR_66 = 'hsl(215, 24%, 10%)';
    string private constant COLOR_67 = 'hsl(210, 14%, 14%)';
    string private constant COLOR_68 = 'hsl(213, 11%, 16%)';
    string private constant COLOR_69 = 'hsl(60, 2%, 38%)';
    string private constant COLOR_70 = 'hsl(216, 13%, 15%)';
    string private constant COLOR_71 = 'hsl(90, 1%, 31%)';
    string private constant COLOR_72 = 'hsl(13, 28%, 19%)';
    string private constant COLOR_73 = 'hsl(180, 1%, 26%)';
    string private constant COLOR_74 = 'hsl(50, 3%, 42%)';
    string private constant COLOR_75 = 'hsl(18, 53%, 34%)';
    string private constant COLOR_76 = 'hsl(19, 54%, 37%)';
    string private constant COLOR_77 = 'hsl(213, 19%, 11%)';
    string private constant COLOR_78 = 'hsl(90, 1%, 34%)';
    string private constant COLOR_79 = 'hsl(204, 4%, 23%)';
    string private constant COLOR_80 = 'hsl(90, 1%, 33%)';
    string private constant COLOR_81 = 'hsl(213, 16%, 14%)';
    string private constant COLOR_82 = 'hsl(22, 16%, 26%)';
    string private constant COLOR_83 = 'hsl(19, 14%, 23%)';
    string private constant COLOR_84 = 'hsl(18, 53%, 33%)';
    string private constant COLOR_85 = 'hsl(18, 48%, 25%)';
    string private constant COLOR_86 = 'hsl(80, 2%, 35%)';
    string private constant COLOR_87 = 'hsl(14, 28%, 18%)';
    string private constant COLOR_88 = 'hsl(120, 1%, 29%)';
    string private constant COLOR_89 = 'hsl(180, 1%, 28%)';
    string private constant COLOR_90 = 'hsl(20, 54%, 40%)';
    string private constant COLOR_91 = 'hsl(15, 33%, 19%)';
    string private constant COLOR_92 = 'hsl(220, 7%, 16%)';
    string private constant COLOR_93 = 'hsl(51, 3%, 43%)';
    string private constant COLOR_94 = 'hsl(210, 5%, 22%)';
    string private constant COLOR_95 = 'hsl(23, 53%, 50%)';
    string private constant COLOR_96 = 'hsl(180, 1%, 28%)';
    string private constant COLOR_97 = 'hsl(218, 22%, 10%)';
    string private constant COLOR_98 = 'hsl(48, 2%, 41%)';
    string private constant COLOR_99 = 'hsl(22, 55%, 47%)';

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
            PART_100
        );
        return result;
    }
}
