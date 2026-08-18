// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderArmor2SelfTest {
    string private constant PART_1 = '<path d="M116 125 L117 125 L117 158 L131 157 L146 158 L147 160 L144 161 L132 161 L127 160 L128 171 L129 172 L136 173 L137 177 L130 178 L124 172 L109 169 L104 164 L99 162 L99 161 L78 160 L78 159 L114 159 L116 160 L116 158 L112 156 L113 154 L115 155 Z M136 171 Z" style="fill:';
    string private constant PART_2 = ';"/><path d="M83 131 L96 131 L102 138 L101 144 L96 146 L92 147 L92 148 L92 149 L81 149 L82 139 L86 139 L85 142 L85 140 L83 140 L85 143 L88 143 L87 138 L82 138 L81 132 Z" style="fill:';
    string private constant PART_3 = ';"/><path d="M111 150 L116 150 L116 155 L113 156 L116 158 L116 160 L77 159 L75 157 L76 153 L111 153 Z" style="fill:';
    string private constant PART_4 = ';"/><path d="M173 116 L175 116 L178 122 L175 122 L175 138 L172 145 L168 147 L168 145 L166 144 L169 143 L171 144 L172 140 L167 138 L164 136 L162 134 L163 130 L168 128 L164 128 L164 124 L170 124 Z" style="fill:';
    string private constant PART_5 = ';"/><path d="M77 121 L78 121 L78 127 L75 127 L75 152 L77 152 L77 128 L78 128 L78 152 L110 152 L110 128 L111 128 L111 153 L76 154 L77 158 L78 159 L85 160 L85 163 L81 163 L80 165 L74 161 L73 159 L73 138 L71 137 L73 137 L73 125 L77 126 Z" style="fill:';
    string private constant PART_6 = ';"/><path d="M81 117 L101 117 L101 126 L78 126 L78 120 Z" style="fill:';
    string private constant PART_7 = ';"/><path d="M75 127 L103 127 L103 128 L79 128 L80 150 L104 149 L105 131 L106 131 L106 144 L109 144 L109 150 L107 150 L107 152 L75 152 Z M134 141 L138 142 L135 147 L135 151 L139 148 L141 148 L141 153 L140 154 L118 154 L118 147 L126 147 L129 146 L129 143 L131 143 L131 146 L134 145 Z" style="fill:';
    string private constant PART_8 = ';"/><path d="M137 163 L158 163 L158 171 L137 171 Z" style="fill:';
    string private constant PART_9 = ';"/><path d="M162 137 L167 137 L172 140 L171 144 L167 144 L169 148 L166 152 L155 151 L154 149 L154 146 L157 143 L160 143 L161 144 L161 138 Z" style="fill:';
    string private constant PART_10 = ';"/><path d="M142 160 L156 160 L168 161 L168 169 L164 173 L159 173 L158 163 L142 163 Z" style="fill:';
    string private constant PART_11 = ';"/><path d="M141 135 L144 136 L145 140 L147 141 L147 154 L140 154 L141 148 L137 151 L135 151 L134 147 L137 142 L141 138 Z" style="fill:';
    string private constant PART_12 = ';"/><path d="M80 129 L104 129 L105 131 L99 132 L81 132 L82 138 L88 137 L88 143 L84 144 L83 140 L86 139 L82 139 L81 149 L104 149 L104 150 L80 150 L79 148 L79 131 Z" style="fill:';
    string private constant PART_13 = ';"/><path d="M125 116 L130 116 L130 118 L133 118 L133 116 L135 116 L135 118 L138 118 L138 116 L142 116 L142 118 L145 118 L145 116 L148 116 L148 118 L151 118 L151 116 L154 116 L154 118 L157 118 L157 116 L173 116 L171 120 L126 120 L125 123 Z" style="fill:';
    string private constant PART_14 = ';"/><path d="M147 154 L148 154 L148 159 L169 159 L169 171 L165 175 L156 177 L154 179 L149 179 L148 174 L145 173 L158 173 L159 169 L159 173 L164 172 L165 167 L167 169 L168 161 L166 161 L165 164 L165 161 L156 161 L147 160 L146 155 Z" style="fill:';
    string private constant PART_15 = ';"/><path d="M123 108 L124 112 L125 115 L116 118 L111 124 L116 124 L116 126 L111 126 L110 128 L78 127 L78 126 L101 126 L101 120 L103 120 L103 126 L109 126 L110 121 L114 117 L98 116 L98 115 L107 114 L111 113 L118 113 L121 112 L121 110 L123 110 Z" style="fill:';
    string private constant PART_16 = ';"/><path d="M127 160 L142 160 L142 163 L137 163 L137 171 L136 173 L129 173 L127 171 Z M175 122 L178 122 L178 145 L170 154 L168 158 L163 158 L162 156 L166 156 L168 151 L172 146 L173 142 L174 138 Z" style="fill:';
    string private constant PART_17 = ';"/><path d="M90 108 L107 108 L111 113 L108 113 L107 115 L87 115 L89 111 Z" style="fill:';
    string private constant PART_18 = ';"/><path d="M163 105 L169 105 L169 115 L160 115 L159 112 L154 111 L156 114 L146 114 L146 111 L147 109 L163 109 Z" style="fill:';
    string private constant PART_19 = ';"/><path d="M129 103 L169 103 L173 107 L173 115 L169 115 L169 105 L129 105 L127 109 L124 111 L125 107 Z" style="fill:';
    string private constant PART_20 = ';"/><path d="M96 131 L105 131 L105 149 L92 149 L89 145 L95 146 L97 144 L100 144 L101 138 L98 134 L91 133 L91 132 Z" style="fill:';
    string private constant PART_21 = ';"/><path d="M68 121 L73 122 L75 121 L75 126 L74 126 L73 137 L71 137 L71 149 L68 150 Z" style="fill:';
    string private constant PART_22 = ';"/><path d="M111 126 L116 126 L116 150 L111 150 Z M152 122 L155 123 L153 123 L154 125 L157 126 L156 130 L158 130 L158 136 L156 137 L149 137 L150 133 L148 132 L148 130 L151 128 L150 125 L148 123 Z" style="fill:';
    string private constant PART_23 = ';"/><path d="M134 105 L163 105 L163 109 L132 109 Z" style="fill:';
    string private constant PART_24 = ';"/><path d="M103 127 L110 127 L110 152 L107 152 L107 150 L109 150 L108 146 L109 144 L106 144 L105 131 L104 130 L80 129 L79 131 L79 128 Z" style="fill:';
    string private constant PART_25 = ';"/><path d="M88 110 L90 112 L88 114 L93 115 L94 111 L94 115 L98 116 L78 117 L74 124 L73 122 L68 121 L69 151 L68 156 L67 156 L67 119 L75 116 L78 114 L85 113 Z" style="fill:';
    string private constant PART_26 = ';"/><path d="M132 133 L148 133 L149 150 L156 148 L155 151 L164 151 L165 153 L161 154 L147 154 L147 134 L133 135 L132 138 L129 137 L128 139 L127 136 Z" style="fill:';
    string private constant PART_27 = ';"/><path d="M136 120 L144 120 L144 124 L142 124 L142 130 L144 126 L146 126 L147 122 L149 123 L151 126 L149 126 L148 128 L147 129 L147 133 L136 133 L137 131 L139 131 L137 126 L134 123 Z" style="fill:';
    string private constant PART_28 = ';"/><path d="M127 121 L130 121 L130 124 L132 124 L132 129 L131 127 L129 128 L127 134 L128 139 L123 139 L120 140 L119 142 L119 131 L126 130 Z" style="fill:';
    string private constant PART_29 = ';"/><path d="M124 154 L147 154 L146 158 L117 158 L118 155 Z" style="fill:';
    string private constant PART_30 = ';"/><path d="M138 134 L147 134 L147 141 L143 140 L143 136 L142 137 L139 141 L134 141 L134 145 L130 147 L130 142 L128 141 L129 137 L132 137 L133 135 Z" style="fill:';
    string private constant PART_31 = ';"/><path d="M137 171 L158 171 L158 173 L148 174 L148 179 L136 179 L136 173 Z" style="fill:';
    string private constant PART_32 = ';"/><path d="M146 108 L148 112 L147 113 L155 113 L153 110 L160 112 L160 115 L135 115 L136 109 Z M157 125 L163 125 L163 127 L158 127 L162 129 L159 137 L160 139 L159 142 L155 142 L155 140 L150 140 L149 137 L156 136 L157 133 L158 130 L156 130 Z" style="fill:';
    string private constant PART_33 = ';"/><path d="M85 160 L100 160 L99 164 L97 166 L81 166 L81 163 L85 163 Z" style="fill:';
    string private constant PART_34 = ';"/><path d="M124 116 L125 116 L125 129 L118 129 L118 145 L125 145 L125 147 L118 147 L118 154 L124 154 L124 155 L119 155 L118 157 L117 155 L116 125 L111 124 L112 122 L118 122 L118 127 L124 127 L123 117 Z" style="fill:';
    string private constant PART_35 = ';"/><path d="M117 116 L124 116 L124 127 L118 127 L118 122 L112 123 L114 119 Z" style="fill:';
    string private constant PART_36 = ';"/><path d="M171 108 L172 108 L173 116 L157 116 L157 118 L154 118 L154 116 L151 116 L151 118 L148 118 L148 116 L145 116 L145 118 L142 118 L142 116 L138 116 L138 118 L135 118 L135 116 L133 116 L133 118 L130 118 L130 116 L122 116 L122 115 L171 115 Z" style="fill:';
    string private constant PART_37 = ';"/><path d="M171 145 L173 147 L168 152 L166 156 L163 158 L148 158 L148 154 L161 153 L166 151 Z" style="fill:';
    string private constant PART_38 = ';"/><path d="M144 120 L162 120 L160 125 L153 126 L152 123 L147 123 L143 131 L141 130 L142 124 L144 124 Z" style="fill:';
    string private constant PART_39 = ';"/><path d="M129 105 L134 105 L133 108 L136 109 L136 114 L135 115 L125 115 L125 113 L123 112 Z" style="fill:';
    string private constant PART_40 = ';"/><path d="M175 117 L179 120 L179 146 L169 159 L166 160 L148 159 L148 158 L168 158 L170 153 L177 145 L177 121 Z" style="fill:';
    string private constant PART_41 = ';"/><path d="M160 119 L171 119 L172 123 L170 125 L164 124 L164 128 L168 128 L167 131 L167 129 L163 131 L161 133 L161 129 L158 129 L158 127 L163 127 L163 125 L160 125 L162 120 Z" style="fill:';
    string private constant PART_42 = ';"/><path d="M71 138 L73 138 L74 160 L67 160 L68 151 L70 149 L70 141 Z" style="fill:';
    string private constant PART_43 = ';"/><path d="M133 124 L138 126 L139 131 L131 135 L127 136 L126 133 L128 133 L128 128 L131 127 Z" style="fill:';
    string private constant PART_44 = ';"/><path d="M149 126 L151 126 L152 129 L148 130 L148 132 L151 133 L150 134 L150 139 L153 141 L151 146 L153 146 L153 150 L148 151 L147 133 L146 128 Z" style="fill:';
    string private constant PART_45 = ';"/><path d="M135 119 L144 119 L144 120 L136 121 L135 125 L130 124 L130 121 L127 121 L126 130 L119 131 L119 145 L118 145 L118 129 L125 129 L126 120 Z" style="fill:';
    string private constant PART_46 = ';"/><path d="M160 131 L163 134 L167 136 L162 138 L162 147 L160 146 L160 143 L157 144 L154 147 L151 146 L153 140 L155 140 L155 142 L159 142 L158 137 Z" style="fill:';
    string private constant PART_47 = ';"/><path d="M103 117 L114 117 L110 122 L109 126 L103 126 Z" style="fill:';
    string private constant PART_48 = ';"/><path d="M78 116 L115 116 L115 117 L108 118 L103 117 L103 120 L101 120 L101 117 L81 118 L78 121 L77 126 L75 126 L75 120 Z" style="fill:';
    string private constant PART_49 = ';"/><path d="M123 138 L128 139 L128 141 L131 142 L129 143 L129 146 L127 146 L126 148 L125 145 L119 145 L120 140 Z" style="fill:';
    string private constant PART_50 = ';"/>';
    string private constant COLOR_1 = 'hsl(213, 14%, 13%)';
    string private constant COLOR_2 = 'hsl(207, 17%, 25%)';
    string private constant COLOR_3 = 'hsl(223, 7%, 21%)';
    string private constant COLOR_4 = 'hsl(0, 0%, 35%)';
    string private constant COLOR_5 = 'hsl(216, 19%, 10%)';
    string private constant COLOR_6 = 'hsl(20, 1%, 42%)';
    string private constant COLOR_7 = 'hsl(300, 1%, 34%)';
    string private constant COLOR_8 = 'hsl(240, 1%, 29%)';
    string private constant COLOR_9 = 'hsl(0, 0%, 33%)';
    string private constant COLOR_10 = 'hsl(214, 6%, 22%)';
    string private constant COLOR_11 = 'hsl(20, 2%, 37%)';
    string private constant COLOR_12 = 'hsl(213, 17%, 10%)';
    string private constant COLOR_13 = 'hsl(34, 3%, 48%)';
    string private constant COLOR_14 = 'hsl(213, 15%, 12%)';
    string private constant COLOR_15 = 'hsl(220, 10%, 17%)';
    string private constant COLOR_16 = 'hsl(220, 5%, 23%)';
    string private constant COLOR_17 = 'hsl(225, 3%, 25%)';
    string private constant COLOR_18 = 'hsl(30, 1%, 37%)';
    string private constant COLOR_19 = 'hsl(218, 13%, 13%)';
    string private constant COLOR_20 = 'hsl(218, 11%, 15%)';
    string private constant COLOR_21 = 'hsl(225, 8%, 19%)';
    string private constant COLOR_22 = 'hsl(0, 1%, 35%)';
    string private constant COLOR_23 = 'hsl(30, 2%, 49%)';
    string private constant COLOR_24 = 'hsl(240, 1%, 32%)';
    string private constant COLOR_25 = 'hsl(213, 16%, 11%)';
    string private constant COLOR_26 = 'hsl(216, 4%, 25%)';
    string private constant COLOR_27 = 'hsl(300, 1%, 32%)';
    string private constant COLOR_28 = 'hsl(0, 1%, 35%)';
    string private constant COLOR_29 = 'hsl(225, 8%, 20%)';
    string private constant COLOR_30 = 'hsl(0, 1%, 34%)';
    string private constant COLOR_31 = 'hsl(225, 10%, 16%)';
    string private constant COLOR_32 = 'hsl(240, 1%, 31%)';
    string private constant COLOR_33 = 'hsl(220, 13%, 14%)';
    string private constant COLOR_34 = 'hsl(228, 4%, 25%)';
    string private constant COLOR_35 = 'hsl(36, 2%, 43%)';
    string private constant COLOR_36 = 'hsl(218, 18%, 9%)';
    string private constant COLOR_37 = 'hsl(220, 10%, 18%)';
    string private constant COLOR_38 = 'hsl(30, 2%, 40%)';
    string private constant COLOR_39 = 'hsl(30, 1%, 36%)';
    string private constant COLOR_40 = 'hsl(213, 24%, 7%)';
    string private constant COLOR_41 = 'hsl(24, 3%, 37%)';
    string private constant COLOR_42 = 'hsl(220, 12%, 15%)';
    string private constant COLOR_43 = 'hsl(20, 2%, 37%)';
    string private constant COLOR_44 = 'hsl(0, 1%, 37%)';
    string private constant COLOR_45 = 'hsl(36, 2%, 42%)';
    string private constant COLOR_46 = 'hsl(40, 2%, 38%)';
    string private constant COLOR_47 = 'hsl(20, 1%, 42%)';
    string private constant COLOR_48 = 'hsl(225, 3%, 27%)';
    string private constant COLOR_49 = 'hsl(20, 2%, 37%)';

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
            PART_50
        );
        return result;
    }
}
