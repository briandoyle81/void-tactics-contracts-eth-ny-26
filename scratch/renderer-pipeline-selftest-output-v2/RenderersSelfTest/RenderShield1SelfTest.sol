// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderShield1SelfTest {
    string private constant PART_1 = '<path d="M126 103 L164 103 L167 106 L167 108 L170 106 L176 106 L181 111 L183 113 L183 141 L176 148 L175 156 L168 163 L161 165 L126 165 L124 162 L111 161 L106 156 L104 154 L99 154 L97 156 L83 156 L83 153 L78 153 L78 113 L88 111 L93 106 L107 106 L110 110 L119 110 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M127 104 L163 104 L163 107 L156 107 L155 112 L124 112 L124 116 L123 118 L126 118 L126 116 L128 116 L128 114 L162 114 L162 120 L161 124 L162 132 L166 133 L164 135 L167 137 L160 141 L157 145 L155 145 L153 149 L147 152 L135 151 L128 147 L126 143 L123 146 L120 146 L119 146 L119 125 L118 127 L118 141 L117 142 L111 142 L109 146 L109 120 L105 120 L105 112 L90 112 L94 106 L107 106 L110 110 L119 110 L123 106 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M137 121 L147 121 L153 125 L157 132 L158 140 L153 145 L147 149 L137 149 L130 143 L128 137 L129 129 L135 122 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M83 122 L106 122 L106 141 L103 144 L83 144 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M138 118 L147 118 L154 122 L156 121 L160 125 L162 132 L166 133 L164 135 L167 137 L160 141 L157 145 L155 145 L153 149 L147 152 L135 151 L128 147 L126 143 L124 142 L123 136 L120 135 L123 135 L124 128 L126 124 L125 121 L129 122 L133 121 Z M137 121 L130 127 L128 132 L129 141 L134 147 L137 149 L147 149 L153 145 L158 140 L156 129 L151 123 L147 121 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M128 114 L162 114 L162 120 L160 125 L156 123 L155 122 L152 122 L147 119 L138 119 L131 123 L127 122 L125 121 L127 125 L124 131 L123 136 L125 145 L122 146 L119 146 L119 120 L124 120 L124 118 L126 118 L126 116 L128 116 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M143 122 L144 126 L144 132 L149 132 L150 128 L152 129 L151 133 L153 138 L153 142 L148 145 L146 145 L146 142 L142 143 L140 147 L137 148 L137 142 L135 140 L134 130 L137 127 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M127 104 L163 104 L163 107 L156 107 L155 112 L126 112 L125 109 L123 108 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M137 121 L147 121 L151 124 L149 125 L146 124 L146 122 L140 125 L137 128 L135 130 L136 140 L138 142 L137 148 L132 145 L129 141 L128 132 L131 126 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M109 120 L117 120 L117 122 L114 122 L114 124 L117 123 L118 127 L118 141 L117 142 L111 142 L109 146 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M84 114 L104 114 L104 121 L83 121 L83 115 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M83 122 L106 122 L106 141 L103 144 L89 144 L91 141 L103 140 L104 124 L85 125 L84 143 L83 143 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M157 108 L158 112 L164 112 L163 114 L128 114 L128 116 L126 116 L126 118 L123 118 L122 112 L126 111 L157 111 Z M164 111 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M127 136 L129 137 L132 144 L137 148 L147 148 L153 144 L157 139 L158 142 L153 149 L147 152 L135 151 L129 146 L127 142 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M147 134 L153 136 L153 142 L148 145 L146 145 L146 142 L142 143 L141 145 L141 141 L145 140 L145 137 L147 137 Z M135 136 L139 138 L140 144 L139 148 L137 148 L137 142 L135 140 Z M140 145 Z" style="fill:';
    string private constant PART_16 = ';"/>';
    string private constant COLOR_1 = 'hsl(195, 5%, 15%)';
    string private constant COLOR_2 = 'hsl(180, 3%, 19%)';
    string private constant COLOR_3 = 'hsl(201, 78%, 47%)';
    string private constant COLOR_4 = 'hsl(193, 11%, 16%)';
    string private constant COLOR_5 = 'hsl(205, 31%, 21%)';
    string private constant COLOR_6 = 'hsl(72, 3%, 33%)';
    string private constant COLOR_7 = 'hsl(188, 87%, 60%)';
    string private constant COLOR_8 = 'hsl(68, 4%, 35%)';
    string private constant COLOR_9 = 'hsl(204, 78%, 43%)';
    string private constant COLOR_10 = 'hsl(75, 3%, 29%)';
    string private constant COLOR_11 = 'hsl(60, 4%, 34%)';
    string private constant COLOR_12 = 'hsl(75, 2%, 33%)';
    string private constant COLOR_13 = 'hsl(210, 9%, 9%)';
    string private constant COLOR_14 = 'hsl(207, 73%, 29%)';
    string private constant COLOR_15 = 'hsl(193, 83%, 53%)';

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
            PART_16
        );
        return result;
    }
}
