// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderBaseBodySelfTest {
    string private constant PART_1 = '<path d="M130 103 L163 103 L167 106 L167 112 L175 112 L175 114 L177 114 L177 145 L175 145 L175 147 L171 151 L169 151 L169 163 L161 165 L161 167 L155 168 L153 171 L149 170 L149 168 L147 168 L147 171 L139 171 L137 171 L132 170 L132 167 L128 165 L128 163 L116 163 L109 157 L109 154 L102 156 L101 158 L87 158 L86 154 L82 154 L82 113 L83 112 L93 112 L95 108 L98 105 L113 105 L116 109 L116 112 L123 112 L124 109 L126 109 L126 107 L128 107 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M82 114 L83 114 L84 122 L85 121 L115 121 L115 122 L86 123 L86 143 L115 144 L115 145 L87 146 L84 144 L84 150 L120 151 L120 146 L121 146 L121 151 L125 150 L134 150 L134 145 L147 144 L149 142 L149 144 L151 143 L152 137 L148 138 L149 135 L157 135 L157 137 L155 138 L157 139 L157 141 L154 144 L160 142 L167 143 L169 141 L170 143 L173 142 L174 138 L174 126 L175 116 L177 115 L177 145 L175 145 L175 147 L171 151 L169 151 L169 163 L161 165 L161 167 L155 168 L153 171 L149 170 L149 168 L147 168 L147 171 L139 171 L137 171 L132 170 L132 167 L128 165 L128 163 L116 163 L109 157 L109 154 L102 156 L101 158 L87 158 L86 154 L82 154 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M130 118 L171 118 L172 120 L165 120 L166 128 L166 135 L161 136 L163 137 L163 139 L161 140 L164 142 L159 143 L154 144 L155 141 L157 141 L157 139 L154 138 L157 137 L157 135 L151 136 L149 137 L152 137 L153 140 L151 144 L147 145 L126 145 L126 140 L129 142 L133 141 L129 139 L126 139 L126 134 L132 133 L132 127 L133 125 L135 125 L134 120 L130 120 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M87 124 L113 124 L113 142 L87 142 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M133 119 L135 120 L135 125 L133 125 L132 133 L147 133 L147 134 L126 134 L126 139 L130 138 L134 141 L133 144 L128 142 L127 141 L126 145 L134 145 L134 150 L120 151 L84 151 L83 150 L83 137 L84 137 L85 144 L88 145 L125 145 L123 126 L124 124 L126 120 L128 130 L128 132 L131 133 L129 126 L131 125 L130 120 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M130 118 L171 118 L172 120 L165 120 L166 128 L166 135 L161 136 L163 137 L163 139 L161 140 L164 142 L159 143 L154 144 L155 141 L157 141 L157 139 L154 138 L157 137 L157 135 L151 136 L155 131 L149 132 L150 128 L150 127 L149 122 L152 122 L153 124 L155 124 L155 122 L157 122 L157 120 L130 120 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M169 112 L175 112 L175 114 L177 115 L176 116 L175 127 L175 138 L173 145 L172 143 L169 144 L168 144 L164 145 L164 141 L160 140 L163 139 L163 137 L160 136 L164 134 L166 135 L165 123 L165 120 L171 119 L166 118 L166 115 L159 115 L159 114 L169 114 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M98 105 L105 105 L105 106 L113 107 L113 109 L111 109 L111 111 L102 112 L99 112 L100 114 L99 121 L85 122 L84 130 L83 130 L82 113 L83 112 L93 112 L95 108 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M160 153 L161 157 L162 160 L158 161 L158 165 L141 165 L140 163 L141 161 L136 161 L136 154 L159 154 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M164 104 L166 106 L165 111 L127 111 L127 109 L131 105 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M87 124 L113 124 L113 142 L109 141 L111 141 L110 137 L110 131 L108 125 L102 127 L100 132 L95 131 L95 129 L89 129 L89 136 L91 138 L93 136 L95 142 L87 142 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M149 135 L157 135 L157 137 L155 138 L157 139 L157 141 L154 144 L160 142 L163 143 L163 150 L155 150 L158 149 L154 149 L154 150 L135 150 L135 145 L147 144 L149 142 L149 144 L151 143 L152 137 L148 138 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M83 137 L84 137 L85 144 L88 145 L112 145 L109 147 L105 146 L107 149 L112 150 L112 151 L84 151 L83 150 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M116 127 L123 127 L124 128 L125 145 L115 145 L116 139 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M148 113 L166 115 L166 118 L130 118 L129 122 L129 118 L125 118 L126 115 L130 116 L132 115 L148 115 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M103 125 L108 125 L111 129 L111 131 L111 140 L108 139 L108 136 L107 138 L102 139 L100 139 L99 141 L97 141 L99 132 L102 126 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M127 112 L129 112 L129 114 L148 114 L148 115 L132 116 L129 117 L126 116 L125 118 L129 118 L132 125 L130 127 L131 128 L131 133 L126 133 L127 129 L126 127 L126 120 L116 120 L116 118 L120 117 L120 115 L127 114 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M133 119 L135 120 L135 125 L133 125 L132 133 L147 133 L147 134 L126 134 L126 139 L130 138 L134 141 L133 144 L128 142 L127 141 L125 144 L123 126 L124 124 L126 120 L128 130 L128 132 L131 133 L129 126 L131 125 L130 120 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M85 114 L98 114 L98 121 L84 122 L84 115 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M113 115 L119 115 L119 117 L116 117 L118 119 L125 120 L124 125 L116 125 L115 122 L109 121 L110 116 L112 117 L113 117 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M113 157 L128 157 L129 160 L126 163 L116 163 L113 160 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M130 103 L163 103 L164 105 L131 106 L128 107 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M155 160 L158 161 L158 165 L141 165 L140 163 L141 161 Z" style="fill:';
    string private constant PART_24 = ';"/>';
    string private constant COLOR_1 = 'hsl(0, 0%, 28%)';
    string private constant COLOR_2 = 'hsl(218, 12%, 13%)';
    string private constant COLOR_3 = 'hsl(75, 2%, 38%)';
    string private constant COLOR_4 = 'hsl(214, 7%, 21%)';
    string private constant COLOR_5 = 'hsl(220, 8%, 23%)';
    string private constant COLOR_6 = 'hsl(47, 4%, 45%)';
    string private constant COLOR_7 = 'hsl(150, 1%, 31%)';
    string private constant COLOR_8 = 'hsl(210, 2%, 24%)';
    string private constant COLOR_9 = 'hsl(204, 4%, 27%)';
    string private constant COLOR_10 = 'hsl(51, 3%, 42%)';
    string private constant COLOR_11 = 'hsl(223, 13%, 11%)';
    string private constant COLOR_12 = 'hsl(220, 5%, 25%)';
    string private constant COLOR_13 = 'hsl(213, 8%, 22%)';
    string private constant COLOR_14 = 'hsl(80, 2%, 37%)';
    string private constant COLOR_15 = 'hsl(210, 4%, 18%)';
    string private constant COLOR_16 = 'hsl(201, 19%, 26%)';
    string private constant COLOR_17 = 'hsl(51, 3%, 43%)';
    string private constant COLOR_18 = 'hsl(210, 3%, 26%)';
    string private constant COLOR_19 = 'hsl(60, 3%, 41%)';
    string private constant COLOR_20 = 'hsl(90, 1%, 36%)';
    string private constant COLOR_21 = 'hsl(218, 8%, 19%)';
    string private constant COLOR_22 = 'hsl(225, 7%, 11%)';
    string private constant COLOR_23 = 'hsl(220, 8%, 23%)';

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
            PART_24
        );
        return result;
    }
}
