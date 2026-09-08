// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderBaseBodySelfTest {
    string private constant PART_1 = '<path d="M130 103 L163 103 L167 106 L167 112 L175 112 L175 114 L177 114 L177 145 L175 145 L175 147 L171 151 L169 151 L169 163 L161 165 L161 167 L155 168 L153 171 L149 170 L149 168 L147 168 L147 171 L139 171 L137 171 L132 170 L132 167 L128 165 L128 163 L116 163 L109 157 L109 154 L102 156 L101 158 L87 158 L86 154 L82 154 L82 113 L83 112 L93 112 L95 108 L98 105 L113 105 L116 109 L116 112 L123 112 L124 109 L126 109 L126 107 L128 107 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M132 118 L171 118 L172 120 L169 123 L171 127 L171 125 L173 125 L174 132 L170 133 L172 132 L172 130 L169 130 L169 132 L167 132 L167 135 L173 135 L174 136 L173 146 L168 151 L163 150 L155 150 L158 149 L154 149 L154 150 L135 150 L135 145 L126 145 L126 140 L129 142 L133 141 L128 139 L126 139 L126 134 L132 133 L132 127 L133 125 L135 125 L134 120 L130 119 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M98 107 L113 107 L113 109 L111 109 L111 111 L108 112 L119 114 L119 117 L129 118 L132 125 L130 127 L131 128 L131 133 L126 133 L127 129 L126 127 L126 120 L122 121 L121 124 L125 125 L125 145 L86 144 L85 143 L85 123 L86 122 L99 121 L99 114 L100 113 L95 111 L95 108 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M82 132 L83 132 L84 150 L120 151 L120 146 L121 150 L134 149 L135 145 L135 150 L146 149 L146 148 L157 148 L158 146 L158 149 L163 150 L163 142 L164 142 L164 151 L169 149 L173 145 L175 145 L175 147 L171 151 L169 151 L169 163 L161 165 L161 167 L155 168 L153 171 L149 170 L149 168 L147 168 L147 171 L139 171 L137 171 L132 170 L132 167 L128 165 L128 163 L116 163 L109 157 L109 154 L102 156 L101 158 L87 158 L86 154 L82 154 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M132 118 L171 118 L172 120 L153 121 L150 126 L151 128 L157 128 L159 129 L158 133 L154 132 L154 131 L153 133 L149 134 L149 137 L152 137 L152 143 L147 145 L126 145 L126 140 L129 142 L133 141 L128 139 L126 139 L126 134 L132 133 L132 127 L133 125 L135 125 L134 120 L130 119 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M163 142 L164 142 L164 151 L169 149 L173 145 L175 145 L175 147 L171 151 L169 151 L169 163 L161 165 L161 167 L155 168 L153 171 L149 170 L149 168 L147 168 L147 171 L139 171 L137 171 L132 170 L132 167 L128 165 L128 163 L132 163 L133 156 L136 157 L134 158 L134 161 L137 162 L141 164 L160 165 L160 163 L158 163 L158 161 L161 160 L161 158 L159 156 L161 156 L161 154 L141 154 L132 153 L132 156 L130 156 L129 160 L123 158 L116 157 L116 156 L125 155 L129 156 L129 153 L111 153 L113 151 L120 151 L120 146 L121 150 L134 149 L135 145 L135 150 L146 149 L146 148 L157 148 L158 146 L158 149 L163 150 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M87 124 L113 124 L113 142 L87 142 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M136 154 L161 154 L162 160 L158 161 L158 163 L160 163 L160 165 L141 165 L136 163 L139 156 L136 156 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M126 134 L146 134 L146 137 L152 137 L152 143 L147 145 L126 145 L126 140 L129 142 L133 141 L128 139 L126 139 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M163 142 L164 142 L164 151 L169 149 L173 145 L175 145 L175 147 L171 151 L169 151 L169 157 L166 156 L167 153 L132 153 L132 156 L130 156 L129 160 L123 158 L116 157 L116 156 L125 155 L129 156 L129 153 L111 153 L113 151 L120 151 L120 146 L121 150 L134 149 L135 145 L135 150 L146 149 L146 148 L157 148 L158 146 L158 149 L163 150 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M98 107 L113 107 L113 109 L111 109 L111 111 L108 112 L119 114 L119 117 L116 117 L116 121 L99 121 L99 114 L100 113 L95 111 L95 108 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M127 112 L129 112 L129 114 L148 114 L148 115 L132 115 L133 119 L135 120 L135 125 L133 125 L132 133 L147 133 L147 134 L126 134 L126 139 L130 138 L134 141 L133 144 L128 142 L127 141 L125 144 L124 139 L124 127 L125 125 L116 125 L120 123 L124 120 L126 120 L128 130 L128 132 L131 133 L129 126 L131 125 L129 122 L129 118 L121 118 L120 115 L127 114 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M149 135 L157 135 L157 137 L155 138 L157 139 L157 141 L154 144 L160 142 L163 143 L163 150 L155 150 L158 149 L154 149 L154 150 L135 150 L135 145 L147 144 L149 142 L149 144 L151 143 L152 137 L148 138 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M149 114 L169 114 L175 115 L175 145 L173 145 L173 136 L167 135 L167 132 L169 132 L169 130 L172 130 L173 132 L172 128 L172 127 L169 127 L168 122 L171 119 L154 118 L154 115 L149 115 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M131 105 L163 105 L163 107 L156 108 L156 111 L127 111 L127 109 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M164 104 L167 106 L167 112 L175 112 L175 114 L177 114 L177 145 L175 145 L174 126 L175 115 L160 114 L160 112 L156 111 L155 107 L163 107 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M123 126 L124 126 L125 145 L115 145 L116 139 L116 127 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M87 124 L113 124 L113 142 L109 141 L111 141 L110 137 L111 129 L108 127 L108 125 L102 127 L97 128 L90 127 L91 129 L89 129 L90 137 L91 138 L93 136 L95 142 L87 142 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M132 153 L141 153 L141 154 L136 154 L136 156 L139 156 L138 160 L134 161 L135 157 L133 156 L133 163 L131 164 L116 163 L113 160 L113 157 L123 157 L129 159 L130 156 L132 156 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M103 128 L108 128 L111 131 L111 141 L109 142 L103 142 L100 139 L101 135 L103 135 L104 130 L101 132 L99 136 L98 130 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M135 120 L139 120 L142 123 L144 125 L146 128 L146 131 L143 133 L132 133 L132 127 L133 125 L135 125 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M137 152 L157 152 L167 153 L167 156 L169 157 L169 163 L163 164 L158 162 L161 160 L161 158 L159 156 L161 156 L161 154 L141 154 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M116 118 L129 118 L132 125 L130 127 L131 128 L131 133 L126 133 L127 129 L126 127 L126 120 L122 121 L121 124 L116 124 L115 121 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M85 114 L98 114 L98 121 L84 122 L84 115 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M98 107 L113 107 L113 109 L111 109 L111 111 L108 112 L116 113 L116 114 L100 114 L96 112 L95 108 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M155 160 L158 161 L158 163 L160 163 L160 165 L141 165 L136 163 L137 161 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M130 103 L163 103 L164 105 L131 106 L128 107 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M127 112 L129 112 L129 114 L148 114 L148 115 L132 115 L132 119 L130 119 L129 122 L129 118 L121 118 L120 115 L127 114 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M142 105 L163 105 L163 107 L156 108 L156 111 L147 111 L150 110 L150 108 L142 107 Z" style="fill:';
    string private constant PART_30 = ';"/>';
    string private constant COLOR_1 = 'hsl(220, 7%, 17%)';
    string private constant COLOR_2 = 'hsl(90, 1%, 35%)';
    string private constant COLOR_3 = 'hsl(45, 2%, 40%)';
    string private constant COLOR_4 = 'hsl(225, 12%, 13%)';
    string private constant COLOR_5 = 'hsl(47, 4%, 47%)';
    string private constant COLOR_6 = 'hsl(225, 13%, 12%)';
    string private constant COLOR_7 = 'hsl(214, 7%, 19%)';
    string private constant COLOR_8 = 'hsl(204, 4%, 27%)';
    string private constant COLOR_9 = 'hsl(60, 2%, 38%)';
    string private constant COLOR_10 = 'hsl(225, 14%, 11%)';
    string private constant COLOR_11 = 'hsl(60, 2%, 37%)';
    string private constant COLOR_12 = 'hsl(220, 2%, 27%)';
    string private constant COLOR_13 = 'hsl(220, 5%, 25%)';
    string private constant COLOR_14 = 'hsl(240, 1%, 26%)';
    string private constant COLOR_15 = 'hsl(60, 3%, 42%)';
    string private constant COLOR_16 = 'hsl(216, 5%, 18%)';
    string private constant COLOR_17 = 'hsl(80, 2%, 37%)';
    string private constant COLOR_18 = 'hsl(223, 14%, 10%)';
    string private constant COLOR_19 = 'hsl(218, 8%, 19%)';
    string private constant COLOR_20 = 'hsl(201, 21%, 26%)';
    string private constant COLOR_21 = 'hsl(72, 3%, 38%)';
    string private constant COLOR_22 = 'hsl(220, 12%, 15%)';
    string private constant COLOR_23 = 'hsl(60, 3%, 44%)';
    string private constant COLOR_24 = 'hsl(60, 3%, 41%)';
    string private constant COLOR_25 = 'hsl(180, 1%, 27%)';
    string private constant COLOR_26 = 'hsl(225, 7%, 22%)';
    string private constant COLOR_27 = 'hsl(225, 7%, 11%)';
    string private constant COLOR_28 = 'hsl(75, 2%, 33%)';
    string private constant COLOR_29 = 'hsl(39, 6%, 51%)';

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
            PART_30
        );
        return result;
    }
}
