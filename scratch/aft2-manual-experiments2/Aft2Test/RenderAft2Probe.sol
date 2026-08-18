// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderAft2Probe {
    string private constant PART_1 = '<path d="M175 105 L176 105 L176 113 L178 114 L178 133 L182 135 L184 135 L183 127 L184 116 L185 116 L186 131 L187 135 L190 136 L189 126 L190 115 L191 115 L192 134 L196 138 L195 141 L215 141 L216 137 L216 141 L220 141 L220 134 L222 136 L221 141 L233 140 L238 136 L238 130 L240 128 L243 136 L247 137 L248 134 L249 133 L250 117 L251 117 L251 135 L248 138 L239 139 L236 143 L243 143 L243 144 L235 145 L235 147 L232 147 L231 149 L227 145 L219 143 L218 146 L213 147 L213 144 L205 144 L205 149 L199 150 L198 147 L204 148 L204 144 L200 144 L200 146 L198 146 L198 144 L191 145 L191 148 L193 150 L190 150 L191 158 L194 157 L196 152 L197 152 L197 161 L202 160 L203 163 L205 163 L204 160 L209 162 L207 164 L214 163 L214 161 L216 162 L216 163 L218 163 L219 161 L219 165 L223 165 L223 146 L224 146 L224 161 L230 161 L232 159 L232 161 L235 160 L235 164 L238 165 L235 166 L244 168 L240 170 L238 174 L236 172 L236 168 L230 169 L230 187 L229 187 L229 173 L225 174 L224 182 L223 182 L222 172 L219 172 L218 186 L217 188 L215 188 L215 194 L213 190 L213 187 L215 187 L215 183 L217 183 L216 173 L215 169 L213 170 L193 170 L193 172 L196 173 L192 177 L190 176 L190 174 L188 173 L191 169 L183 170 L183 166 L173 164 L173 169 L172 165 L166 165 L166 187 L163 189 L161 183 L159 184 L158 178 L157 176 L159 176 L159 174 L156 174 L156 170 L152 172 L152 169 L148 169 L145 166 L145 169 L143 170 L134 170 L134 169 L142 169 L141 165 L146 164 L144 160 L163 159 L165 156 L166 145 L175 136 L176 116 L168 116 L168 112 L170 112 L170 115 L173 115 L173 107 Z M188 144 L183 146 L182 147 L182 157 L183 155 L189 155 L189 144 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M213 169 L215 169 L217 172 L217 183 L215 183 L215 187 L213 187 L214 192 L215 188 L217 188 L218 172 L223 171 L225 171 L225 174 L229 173 L230 187 L234 189 L230 189 L230 191 L232 192 L230 194 L229 203 L228 203 L227 195 L224 195 L223 204 L219 207 L201 207 L196 206 L196 197 L199 197 L199 195 L205 193 L203 192 L206 191 L206 195 L212 195 L211 190 L212 186 L210 185 L212 185 L212 172 L193 172 L193 170 Z M181 98 L182 98 L183 107 L184 101 L185 101 L186 107 L190 107 L189 110 L187 110 L185 116 L184 114 L177 116 L176 113 L176 105 L181 105 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M178 171 L182 172 L181 174 L181 189 L187 194 L190 194 L189 189 L188 187 L190 186 L191 176 L192 176 L193 187 L196 188 L196 191 L193 192 L192 195 L199 195 L199 197 L197 199 L196 206 L201 206 L201 207 L189 207 L184 204 L184 195 L177 194 L177 201 L173 200 L171 199 L171 197 L169 197 L169 195 L165 194 L160 189 L160 187 L156 187 L155 189 L150 187 L143 185 L143 184 L150 183 L152 184 L152 179 L155 181 L156 174 L159 174 L159 176 L158 177 L159 177 L160 183 L162 182 L164 188 L167 187 L167 185 L175 185 L177 176 L178 173 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M228 91 L229 95 L236 96 L236 99 L238 100 L235 101 L235 98 L233 98 L233 106 L232 107 L211 107 L209 106 L207 110 L207 107 L186 108 L186 104 L190 104 L190 102 L188 102 L188 100 L191 101 L191 103 L194 102 L194 105 L204 105 L203 99 L204 96 L211 96 L212 94 L212 96 L219 96 L220 95 L228 95 Z M212 100 L211 106 L214 106 L214 100 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M103 168 L106 168 L106 170 L103 170 L103 174 L106 174 L106 180 L109 179 L108 177 L113 177 L115 170 L116 170 L118 177 L123 180 L124 182 L129 181 L130 177 L143 178 L143 179 L135 179 L136 182 L148 181 L152 180 L152 184 L143 185 L140 186 L133 186 L131 196 L122 196 L121 187 L119 186 L119 196 L118 196 L118 186 L114 185 L113 182 L104 181 L102 179 L102 169 Z M225 111 L227 111 L228 117 L227 132 L226 132 L225 126 L226 120 L222 120 L223 129 L221 132 L219 131 L221 120 L219 120 L219 128 L215 132 L218 134 L216 134 L215 137 L213 135 L198 134 L195 129 L195 117 L196 117 L196 127 L199 127 L199 121 L200 121 L201 128 L205 131 L212 131 L215 128 L216 126 L216 118 L220 118 L220 116 L222 116 L222 119 L225 118 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M219 143 L228 144 L232 147 L235 147 L235 145 L243 144 L243 155 L241 155 L240 149 L236 149 L235 160 L230 162 L224 161 L223 158 L221 159 L221 157 L217 156 L215 159 L215 156 L212 155 L216 153 L218 154 L216 148 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M233 98 L235 98 L236 100 L240 101 L240 105 L249 105 L253 109 L253 133 L251 135 L250 108 L246 107 L244 106 L244 112 L242 111 L242 128 L245 129 L246 132 L249 131 L250 129 L249 135 L247 137 L242 136 L239 128 L238 110 L236 108 L232 106 Z M236 128 L239 129 Z M199 187 L212 187 L212 195 L206 195 L205 193 L204 195 L192 195 L193 191 L196 191 L197 188 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M201 67 L202 67 L202 88 L211 88 L212 89 L211 96 L206 95 L203 94 L203 97 L192 97 L196 95 L189 94 L189 96 L191 97 L182 98 L183 96 L187 95 L188 88 L196 88 L196 83 L197 83 L197 88 L201 88 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M143 185 L149 185 L153 187 L156 189 L155 194 L146 198 L132 198 L131 197 L131 189 L132 193 L134 193 L135 191 L142 189 L145 190 L146 186 L143 187 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M191 144 L198 144 L198 146 L200 146 L200 144 L204 144 L204 148 L199 148 L199 150 L204 151 L207 150 L214 152 L212 155 L208 156 L206 155 L206 157 L203 157 L202 154 L200 153 L201 161 L197 161 L196 155 L195 159 L191 158 L190 150 L190 148 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M244 106 L250 108 L250 129 L246 133 L244 129 L241 129 L241 110 L243 111 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M129 161 L132 162 L145 162 L147 165 L142 166 L143 169 L145 169 L145 166 L148 167 L148 169 L152 170 L147 171 L132 171 L130 181 L130 182 L123 183 L124 178 L129 177 L129 167 L125 166 L124 163 L128 163 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M196 112 L200 114 L198 116 L198 127 L196 127 L198 134 L215 134 L215 137 L194 137 L191 134 L191 124 L193 115 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M122 163 L125 164 L125 166 L130 166 L129 177 L125 178 L124 180 L117 179 L116 176 L116 168 L119 165 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M200 178 L211 179 L212 180 L212 187 L199 187 L198 189 L192 187 L192 179 L193 183 L196 182 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M196 171 L212 172 L212 180 L204 180 L204 178 L197 180 L196 183 L193 183 L192 177 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M227 117 L228 117 L228 133 L222 136 L221 135 L220 141 L216 141 L216 134 L214 132 L218 128 L219 120 L221 120 L221 128 L221 131 L222 128 L222 120 L226 120 L226 127 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M248 175 L249 175 L249 188 L246 191 L238 192 L236 193 L230 191 L230 189 L230 188 L230 184 L237 183 L238 181 L240 181 L241 187 L245 187 L245 181 L247 181 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M166 165 L175 165 L175 167 L180 167 L178 172 L176 174 L176 177 L167 179 L166 179 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M132 170 L152 170 L152 173 L154 174 L146 174 L146 176 L143 176 L143 178 L131 178 L131 171 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M226 108 L233 108 L236 111 L236 114 L233 115 L234 120 L235 115 L236 115 L236 131 L232 130 L233 127 L229 127 L228 127 L227 112 L228 114 L230 114 L230 109 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M154 170 L156 170 L156 181 L154 182 L152 180 L148 182 L135 183 L135 179 L143 179 L143 176 L146 176 L146 174 L152 173 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M243 144 L247 147 L247 161 L246 163 L244 163 L244 165 L235 164 L235 160 L241 160 L241 155 L243 155 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M187 174 L190 174 L191 176 L191 186 L189 188 L191 191 L190 195 L185 194 L180 189 L180 186 L184 187 L184 181 L185 181 L185 188 L186 185 Z M119 186 L122 187 L123 197 L108 197 L107 193 L110 193 L111 189 L111 191 L116 190 L116 192 L118 192 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M220 109 L226 110 L226 118 L222 119 L222 116 L220 116 L221 119 L215 118 L211 116 L205 116 L201 118 L201 116 L197 115 L198 114 L216 113 Z M221 107 L236 107 L239 110 L239 128 L236 128 L234 125 L233 120 L233 117 L231 115 L231 113 L236 114 L233 109 L225 109 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M189 94 L197 94 L196 96 L203 97 L203 94 L207 95 L206 98 L204 99 L192 99 L191 103 L188 100 L188 102 L190 102 L190 104 L185 105 L183 108 L182 107 L182 98 L189 96 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M203 118 L205 120 L205 127 L212 127 L213 121 L217 121 L217 126 L215 130 L212 132 L205 132 L199 129 L201 128 L199 119 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M233 168 L238 169 L238 186 L237 183 L230 184 L230 169 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M196 107 L207 107 L207 110 L214 110 L219 111 L218 114 L200 114 L195 112 L195 109 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M106 168 L113 168 L115 169 L115 180 L113 177 L109 180 L106 180 L106 174 L103 174 L103 170 L106 170 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M205 144 L213 144 L214 146 L217 146 L218 154 L213 154 L212 152 L205 151 L203 152 L203 150 L200 149 L205 149 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M191 107 L199 108 L195 111 L200 111 L196 113 L193 117 L192 124 L191 124 L190 118 L186 118 L185 113 L190 108 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M236 129 L239 130 L239 136 L233 141 L221 141 L221 136 L226 135 L226 137 L233 136 L235 134 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M169 102 L181 102 L181 105 L175 105 L175 113 L173 115 L170 115 L170 112 L168 112 L168 104 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M177 172 L179 173 L178 177 L177 178 L176 186 L169 186 L167 185 L166 187 L166 179 L170 178 L176 177 L175 173 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M127 160 L144 160 L144 162 L141 162 L140 164 L138 164 L138 162 L131 163 L130 162 L128 164 L122 164 L117 166 L115 170 L113 174 L112 169 L104 168 L104 167 L115 166 L121 161 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M200 153 L203 154 L203 157 L206 157 L206 155 L213 155 L212 161 L211 165 L206 164 L206 161 L205 163 L203 163 L200 160 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M173 164 L181 164 L184 166 L185 169 L191 169 L189 173 L187 176 L184 176 L184 174 L181 174 L181 172 L178 170 L180 167 L175 167 L175 165 Z" style="fill:';
    string private constant PART_39 = ';"/><path d="M185 115 L187 118 L190 118 L190 136 L186 135 L185 131 Z" style="fill:';
    string private constant PART_40 = ';"/><path d="M240 171 L245 171 L245 187 L241 187 L239 181 Z" style="fill:';
    string private constant PART_41 = ';"/><path d="M212 116 L216 118 L217 121 L215 122 L213 121 L213 127 L212 128 L205 128 L204 127 L204 122 L213 118 Z" style="fill:';
    string private constant PART_42 = ';"/><path d="M196 137 L215 137 L215 141 L195 141 Z" style="fill:';
    string private constant PART_43 = ';"/><path d="M212 100 L214 100 L214 106 L211 105 Z M209 106 L225 108 L230 109 L230 114 L228 114 L226 111 L220 110 L214 111 L208 110 Z" style="fill:';
    string private constant PART_44 = ';"/><path d="M180 174 L184 174 L184 176 L187 176 L187 188 L180 186 Z" style="fill:';
    string private constant PART_45 = ';"/><path d="M244 168 L248 169 L249 175 L247 185 L245 181 L245 171 L240 171 L239 181 L237 182 L237 173 L240 169 Z" style="fill:';
    string private constant PART_46 = ';"/><path d="M229 125 L234 126 L233 130 L236 131 L235 135 L233 137 L226 137 L226 135 L224 134 L227 133 Z" style="fill:';
    string private constant PART_47 = ';"/><path d="M216 155 L223 158 L223 165 L219 165 L218 163 L216 163 L216 165 L213 164 L215 164 L214 163 L211 164 L211 161 L213 156 Z" style="fill:';
    string private constant PART_48 = ';"/><path d="M177 194 L184 195 L184 205 L178 205 L176 201 Z" style="fill:';
    string private constant PART_49 = ';"/><path d="M108 184 L114 184 L118 186 L118 192 L111 191 L110 193 L107 193 L107 185 Z" style="fill:';
    string private constant PART_50 = ';"/><path d="M133 185 L143 185 L146 186 L145 191 L141 190 L132 193 L132 186 Z" style="fill:';
    string private constant PART_51 = ';"/><path d="M182 114 L184 114 L184 127 L180 126 L178 128 L177 116 Z" style="fill:';
    string private constant PART_52 = ';"/><path d="M236 148 L241 148 L241 160 L235 160 L235 149 Z" style="fill:';
    string private constant PART_53 = ';"/><path d="M224 194 L231 194 L231 202 L230 204 L223 204 L223 195 Z" style="fill:';
    string private constant PART_54 = ';"/><path d="M188 144 L189 144 L189 155 L183 155 L182 157 L182 147 L184 145 Z" style="fill:';
    string private constant PART_55 = ';"/><path d="M177 118 L178 118 L179 125 L183 127 L184 128 L184 135 L180 136 L177 133 Z" style="fill:';
    string private constant PART_56 = ';"/><path d="M205 115 L211 115 L214 119 L204 122 L203 119 L199 119 L199 127 L198 127 L197 117 L201 116 L204 116 Z" style="fill:';
    string private constant PART_57 = ';"/><path d="M192 99 L203 99 L204 100 L204 105 L194 105 L192 103 Z" style="fill:';
    string private constant PART_58 = ';"/>';
    string private constant COLOR_1 = 'hsl(207, 22%, 10%)';
    string private constant COLOR_2 = 'hsl(210, 16%, 13%)';
    string private constant COLOR_3 = 'hsl(213, 23%, 9%)';
    string private constant COLOR_4 = 'hsl(206, 8%, 18%)';
    string private constant COLOR_5 = 'hsl(213, 21%, 10%)';
    string private constant COLOR_6 = 'hsl(300, 1%, 20%)';
    string private constant COLOR_7 = 'hsl(213, 17%, 12%)';
    string private constant COLOR_8 = 'hsl(200, 6%, 18%)';
    string private constant COLOR_9 = 'hsl(213, 14%, 13%)';
    string private constant COLOR_10 = 'hsl(120, 1%, 30%)';
    string private constant COLOR_11 = 'hsl(210, 8%, 19%)';
    string private constant COLOR_12 = 'hsl(218, 11%, 14%)';
    string private constant COLOR_13 = 'hsl(206, 7%, 21%)';
    string private constant COLOR_14 = 'hsl(204, 4%, 23%)';
    string private constant COLOR_15 = 'hsl(216, 5%, 20%)';
    string private constant COLOR_16 = 'hsl(60, 2%, 30%)';
    string private constant COLOR_17 = 'hsl(216, 14%, 15%)';
    string private constant COLOR_18 = 'hsl(228, 8%, 12%)';
    string private constant COLOR_19 = 'hsl(150, 1%, 28%)';
    string private constant COLOR_20 = 'hsl(200, 5%, 22%)';
    string private constant COLOR_21 = 'hsl(90, 1%, 31%)';
    string private constant COLOR_22 = 'hsl(210, 10%, 16%)';
    string private constant COLOR_23 = 'hsl(320, 4%, 14%)';
    string private constant COLOR_24 = 'hsl(216, 14%, 14%)';
    string private constant COLOR_25 = 'hsl(210, 9%, 18%)';
    string private constant COLOR_26 = 'hsl(0, 0%, 25%)';
    string private constant COLOR_27 = 'hsl(210, 8%, 19%)';
    string private constant COLOR_28 = 'hsl(210, 6%, 20%)';
    string private constant COLOR_29 = 'hsl(80, 2%, 35%)';
    string private constant COLOR_30 = 'hsl(195, 3%, 25%)';
    string private constant COLOR_31 = 'hsl(195, 3%, 24%)';
    string private constant COLOR_32 = 'hsl(60, 3%, 37%)';
    string private constant COLOR_33 = 'hsl(210, 13%, 15%)';
    string private constant COLOR_34 = 'hsl(210, 9%, 17%)';
    string private constant COLOR_35 = 'hsl(210, 11%, 18%)';
    string private constant COLOR_36 = 'hsl(210, 30%, 8%)';
    string private constant COLOR_37 = 'hsl(200, 6%, 20%)';
    string private constant COLOR_38 = 'hsl(213, 10%, 17%)';
    string private constant COLOR_39 = 'hsl(0, 1%, 23%)';
    string private constant COLOR_40 = 'hsl(22, 48%, 38%)';
    string private constant COLOR_41 = 'hsl(180, 2%, 25%)';
    string private constant COLOR_42 = 'hsl(216, 16%, 13%)';
    string private constant COLOR_43 = 'hsl(30, 7%, 28%)';
    string private constant COLOR_44 = 'hsl(150, 1%, 29%)';
    string private constant COLOR_45 = 'hsl(240, 2%, 16%)';
    string private constant COLOR_46 = 'hsl(15, 3%, 24%)';
    string private constant COLOR_47 = 'hsl(216, 15%, 13%)';
    string private constant COLOR_48 = 'hsl(210, 15%, 13%)';
    string private constant COLOR_49 = 'hsl(210, 9%, 18%)';
    string private constant COLOR_50 = 'hsl(200, 5%, 23%)';
    string private constant COLOR_51 = 'hsl(160, 2%, 26%)';
    string private constant COLOR_52 = 'hsl(22, 53%, 47%)';
    string private constant COLOR_53 = 'hsl(17, 35%, 22%)';
    string private constant COLOR_54 = 'hsl(180, 2%, 25%)';
    string private constant COLOR_55 = 'hsl(213, 15%, 14%)';
    string private constant COLOR_56 = 'hsl(53, 3%, 45%)';
    string private constant COLOR_57 = 'hsl(23, 47%, 36%)';

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
            PART_58
        );
        return result;
    }
}
