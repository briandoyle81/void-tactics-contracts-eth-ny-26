// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderWeapon4SelfTest {
    string private constant PART_1 = '<path d="M139 66L137 68L137 71L142 71L146 74L139 79L133 79L132 81L121 81L120 79L111 79L110 77L104 77L104 79L108 81L108 87L104 91L105 93L113 91L120 91L121 89L132 89L133 91L142 91L139 95L141 97L144 95L145 96L142 99L136 101L135 103L159 103L159 99L154 99L153 98L159 92L163 92L168 90L169 82L171 82L171 78L167 76L158 75L158 71L153 70L153 68L147 68L146 66Z" fill-rule="evenodd" style="fill:';
    string private constant PART_2 = ';"/><path d="M139 66L137 69L138 70L147 70L143 71L145 74L147 73L147 75L144 75L144 77L143 77L138 81L136 79L132 81L121 81L117 79L113 80L114 83L109 77L104 77L104 79L108 81L108 91L107 88L104 91L105 93L108 92L112 91L121 90L120 89L133 89L133 91L143 91L142 89L146 93L146 95L143 98L144 99L147 97L146 100L137 101L136 103L159 103L159 100L157 100L155 100L153 98L153 101L151 98L151 100L147 100L151 96L155 97L157 92L159 93L159 91L163 92L166 90L169 87L169 81L171 82L171 78L168 77L164 77L162 75L158 74L158 71L153 70L152 68L141 69L147 67L146 67ZM150 71L152 72L153 71ZM148 74L148 75L151 77L152 75L150 76L150 74ZM145 80L147 81L148 80ZM165 81L166 88L167 83ZM159 86L160 89L158 90L157 87L154 90L147 90L148 88L146 87L145 88L147 91L154 91L153 94L157 90L159 91L163 88L160 88ZM156 88L154 92L157 89L157 88ZM142 93L139 94L141 97L145 95L145 93Z" fill-rule="evenodd" style="fill:';
    string private constant PART_3 = ';"/><path d="M139 67L137 70L139 70L148 71L149 72L148 73L146 72L143 71L144 73L146 72L147 74L157 74L157 72L157 71L153 70L153 72L150 72L152 71L152 69L139 70L139 68L147 67ZM157 74L156 75L144 75L144 77L142 76L140 80L149 80L146 81L146 85L148 89L155 89L156 91L153 94L154 91L148 91L146 90L147 88L145 89L146 96L147 98L151 97L151 95L151 92L153 96L155 97L157 91L155 88L156 87L159 88L160 84L160 88L166 88L165 81L168 83L167 87L164 89L159 90L160 88L159 89L158 94L159 91L163 92L169 86L169 81L171 82L171 79L168 76L165 78L162 76ZM150 76L148 78L149 79L151 77ZM153 77L152 78L162 78L161 77ZM105 77L104 79L108 81L108 88L110 89L107 90L107 88L104 91L105 93L110 91L113 87L120 87L121 89L133 88L133 91L143 91L139 89L139 85L141 90L141 86L144 88L146 87L145 81L140 81L137 80L136 79L133 80L135 82L119 82L119 80L113 80L114 83L109 77ZM115 82L117 83L118 82ZM113 84L114 86L115 86L115 84ZM114 88L113 90L117 90L120 91L120 88ZM141 93L140 94L140 96L143 96L143 94ZM147 93L147 96L150 97L148 94ZM144 96L143 99L147 99L145 96ZM153 98L153 100L138 100L136 101L139 103L157 102L158 101L155 101Z" fill-rule="evenodd" style="fill:';
    string private constant PART_4 = ';"/><path d="M139 67L143 68L147 67ZM137 69L139 71L143 70L143 69ZM150 69L147 70L151 74L157 74L157 72L157 71L153 70L153 72L150 72L152 70ZM157 74L156 75L150 75L151 77L161 76L162 78L149 78L156 80L149 80L148 77L145 77L150 75L144 75L144 77L142 76L140 80L144 80L149 80L146 81L148 88L155 89L157 87L157 83L159 89L165 88L166 86L165 81L168 83L169 81L171 82L171 78L167 76L167 78L163 78L163 76ZM105 77L104 78L108 82L109 88L112 87L108 90L107 88L104 91L111 91L113 87L120 87L121 89L133 88L133 91L142 91L139 88L140 85L145 88L146 87L145 81L139 82L139 80L137 82L136 79L133 80L135 82L119 82L119 80L113 80L119 83L115 83L111 80L110 84L110 80L110 77ZM159 82L159 89L160 85ZM150 83L153 84L156 83ZM113 84L113 86L115 86L115 84ZM167 84L167 87L169 86L169 84ZM137 86L136 90L138 90L138 86ZM114 88L113 90L117 90L120 91L120 88ZM159 90L158 92L159 93L159 91L164 92L164 90ZM147 91L146 92L146 97L148 98L147 92L149 97L151 92L153 93L152 96L153 94L157 95L153 93L154 92ZM141 93L140 95L143 96L142 93ZM144 96L143 100L145 97ZM153 98L153 100L138 100L136 101L142 103L153 102L154 99Z" fill-rule="evenodd" style="fill:';
    string private constant PART_5 = ';"/><path d="M153 70L154 72L152 73L156 72L157 75L152 75L150 75L151 77L159 76L162 76L157 74L158 71ZM144 75L147 76L150 75ZM142 76L140 80L148 80L148 77ZM162 76L162 78L150 78L156 79L157 81L151 80L146 81L148 88L156 88L157 87L157 82L159 88L158 79L160 82L160 87L163 88L165 86L166 81L168 83L169 81L171 82L171 78L167 76L167 78L163 78ZM105 77L104 78L106 81L111 80L112 85L109 81L108 81L108 87L110 88L112 85L112 87L108 90L111 90L112 87L120 87L121 89L137 89L138 86L139 90L133 89L133 91L143 91L139 89L139 83L141 85L146 87L145 81L139 82L138 80L138 82L135 79L135 81L132 84L132 82L134 80L120 82L115 83L109 77ZM113 80L117 82L119 80ZM150 83L150 85L155 85L155 83ZM113 84L113 86L115 86L115 84ZM168 84L167 86L168 87L169 84ZM132 85L132 87L135 88L136 86ZM115 88L113 90L116 89L118 91L118 89L120 92L119 89ZM104 90L106 91L107 90ZM161 90L160 92L164 92L163 90ZM148 91L148 95L151 93L150 91ZM146 92L146 97L148 98L147 92ZM153 93L155 95L156 94ZM153 98L153 100L151 99L150 101L148 101L149 100L137 100L138 102L152 102L154 99Z" fill-rule="evenodd" style="fill:';
    string private constant PART_6 = ';"/><path d="M153 70L156 73L158 72L157 70ZM157 74L156 75L150 75L151 77L160 76L161 75ZM144 75L147 76L150 75ZM142 76L140 80L148 80L148 77ZM162 76L162 78L152 78L156 79L157 81L148 81L148 88L156 88L157 87L157 82L159 88L158 79L160 82L160 87L165 86L165 82L163 83L163 81L166 81L167 83L170 81L171 82L171 79L167 76L168 78L163 78ZM105 77L104 79L111 80L115 85L115 86L111 87L111 85L110 81L108 81L108 87L110 86L111 88L108 90L110 90L112 87L120 87L121 89L133 89L132 85L133 86L137 82L136 79L135 81L132 84L132 82L134 80L119 82L117 83L113 82L120 80L112 80L109 77ZM138 80L138 82L135 86L139 86L139 83L141 83L143 86L146 87L145 81L140 82ZM150 83L149 86L154 84L155 85L155 83ZM140 89L133 91L142 91L142 90ZM160 91L162 92L165 91ZM153 93L155 95L156 94ZM149 99L137 101L138 101L147 102L149 99Z" fill-rule="evenodd" style="fill:';
    string private constant PART_7 = ';"/><path d="M157 70L154 72L157 73L157 70ZM152 75L151 77L160 76L161 75ZM142 77L140 80L146 79L148 79L148 77ZM104 78L111 81L115 85L115 86L111 87L111 85L110 81L108 81L108 87L110 87L111 87L109 91L113 87L120 87L122 89L133 88L132 85L133 86L137 83L137 80L136 80L132 84L132 81L122 81L117 83L113 82L120 80L112 80L110 78ZM152 78L156 79L157 81L148 81L148 88L156 88L158 82L159 87L158 79L160 82L160 87L165 86L165 82L163 83L163 81L169 81L169 78ZM170 79L170 83L171 80ZM138 80L138 82L135 86L139 86L139 83L141 83L142 86L145 86L145 81L140 82ZM150 83L149 86L154 84L155 85L155 83ZM140 100L139 102L147 102L148 100Z" fill-rule="evenodd" style="fill:';
    string private constant PART_8 = ';"/><path d="M152 75L151 77L160 76L161 75ZM142 77L140 80L142 79L147 78L148 77ZM104 78L111 81L115 85L115 86L111 87L111 84L108 81L108 88L110 85L111 88L109 90L113 87L120 87L122 89L133 88L132 85L133 86L137 83L137 80L136 80L132 84L132 81L122 81L117 83L113 82L120 80L112 80L110 78ZM152 78L153 79L160 80L161 88L161 85L165 86L165 83L163 83L163 81L169 81L169 78ZM138 80L138 82L135 86L139 86L139 80ZM148 80L147 81L147 87L149 87L148 85L151 83L155 83L155 85L150 85L151 88L157 87L157 81L159 82L158 80ZM143 81L140 82L143 86L145 85L145 81ZM141 100L144 101L147 100Z" fill-rule="evenodd" style="fill:';
    string private constant PART_9 = ';"/><path d="M152 75L151 77L161 76L161 75ZM142 77L140 80L143 79L147 78L148 77ZM104 78L110 80L115 84L114 87L119 87L122 89L133 88L132 85L133 86L137 82L136 80L132 84L132 81L122 81L117 83L113 82L120 80L112 80L110 78ZM152 78L160 79L160 83L162 83L162 86L165 84L161 80L161 79L164 79L163 81L169 81L169 78ZM138 80L138 83L135 86L139 86L139 80ZM148 80L147 81L147 87L149 82L149 85L151 81L151 83L155 83L156 82L155 84L157 88L157 81L159 82L158 80ZM108 81L108 88L110 85L111 88L109 90L113 87L113 86L111 87L111 84ZM142 81L141 83L143 85L145 84L145 82ZM150 85L153 86L156 85Z" fill-rule="evenodd" style="fill:';
    string private constant PART_10 = ';"/><path d="M152 75L151 77L161 76L161 75ZM142 77L140 81L143 78L149 77ZM104 78L106 79L109 78ZM152 78L153 79L167 79L167 81L169 81L169 78ZM138 80L138 84L135 86L137 86L139 84ZM148 80L147 83L148 87L148 82L150 81L152 84L152 81L157 82L156 80ZM108 81L108 88L110 85L111 88L109 90L113 87L113 86L111 87L111 84ZM122 81L116 83L116 87L120 87L122 89L133 88L132 86L135 83L136 83L137 81L134 82L132 85L132 81ZM142 81L141 83L143 82L142 85L144 84L145 82ZM160 81L160 83L163 83L162 86L165 84L162 81ZM150 85L153 86L156 85Z" fill-rule="evenodd" style="fill:';
    string private constant PART_11 = ';"/><path d="M152 75L151 77L161 76L161 75ZM142 77L141 79L147 78L147 77ZM152 78L153 79L168 79L169 78ZM148 80L147 81L147 84L150 81L152 84L152 81L157 82L156 80ZM108 81L108 88L110 85L111 88L109 90L112 88L111 84ZM122 81L116 83L116 87L120 87L122 89L133 88L132 84L132 81ZM137 81L133 83L136 84L137 82ZM138 81L138 86L139 83ZM160 81L160 82L163 83L163 81ZM150 85L153 86L156 85Z" fill-rule="evenodd" style="fill:';
    string private constant PART_12 = ';"/><path d="M152 75L151 77L160 76L160 75ZM153 78L154 79L168 79L169 78ZM148 80L147 82L148 83L148 81L155 81L156 80ZM108 81L108 88L110 85L110 88L110 89L112 88L111 84ZM122 81L116 83L116 87L120 87L122 89L133 88L132 84L132 81ZM160 81L162 82L163 81ZM133 82L135 83L138 82ZM150 85L152 86L155 85Z" fill-rule="evenodd" style="fill:';
    string private constant PART_13 = ';"/><path d="M152 75L152 77L160 76L160 75ZM153 78L156 79L159 78ZM159 78L160 79L169 79L169 78ZM149 80L153 81L157 80ZM108 81L108 88L109 85L111 88L111 84ZM122 81L116 83L116 87L120 87L122 89L133 88L132 84L132 81ZM160 81L162 82L163 81ZM133 82L135 83L138 82Z" fill-rule="evenodd" style="fill:';
    string private constant PART_14 = ';"/><path d="M152 75L152 77L160 76L160 75ZM153 78L156 79L159 78ZM159 78L160 79L169 79L169 78ZM149 80L153 81L157 80ZM108 81L108 88L109 85L111 88L111 84ZM160 81L162 82L163 81ZM120 82L116 83L116 87L122 88L132 88L133 85L132 82ZM133 82L135 83L138 82Z" fill-rule="evenodd" style="fill:';
    string private constant PART_15 = ';"/><path d="M152 75L152 77L159 76L159 75ZM159 78L160 79L169 79L169 78ZM108 81L108 88L109 85L111 88L111 84ZM160 81L162 82L163 81ZM120 82L116 83L116 87L122 88L132 88L133 85L132 82Z" fill-rule="evenodd" style="fill:';
    string private constant PART_16 = ';"/><path d="M152 75L152 77L159 76L159 75ZM159 78L160 79L169 79L169 78ZM108 81L108 88L109 85L111 88L111 84ZM160 81L162 82L163 81ZM120 82L116 83L116 87L122 88L132 88L133 84L132 84L123 82L122 84L120 84L121 82Z" fill-rule="evenodd" style="fill:';
    string private constant PART_17 = ';"/><path d="M152 75L152 77L159 76L159 75ZM159 78L160 79L169 79L169 78ZM108 81L108 88L109 85L111 88L111 84ZM160 81L162 82L163 81ZM120 82L116 83L116 87L120 87L132 88L133 84L132 84L123 82L122 84L120 84L121 82ZM118 85L120 86L121 85Z" fill-rule="evenodd" style="fill:';
    string private constant PART_18 = ';"/><path d="M152 75L152 77L159 76L159 75ZM159 78L160 79L169 79L169 78ZM108 81L108 88L109 85L111 88L111 84ZM160 81L162 82L163 81ZM119 82L118 84L116 83L116 87L121 88L121 86L117 85L130 86L132 88L133 84L132 84L123 82L122 84L120 84L121 82Z" fill-rule="evenodd" style="fill:';
    string private constant PART_19 = ';"/><path d="M152 75L152 77L159 76L159 75ZM159 78L160 79L169 79L169 78ZM108 81L108 88L109 85L111 88L111 84ZM160 81L162 82L163 81ZM116 84L116 87L121 88L121 86L117 85L130 86L132 88L133 84L128 84Z" fill-rule="evenodd" style="fill:';
    string private constant PART_20 = ';"/><path d="M152 75L152 77L155 76L155 75ZM164 78L166 79L169 78ZM108 81L108 88L109 85L111 88L111 84ZM116 84L116 87L121 88L121 86L117 85L130 86L132 88L133 84L128 84Z" fill-rule="evenodd" style="fill:';
    string private constant PART_21 = ';"/><path d="M164 78L166 79L169 78ZM108 81L108 88L109 85L111 88L111 84ZM116 84L116 87L121 88L121 86L117 85L130 86L132 88L133 84L128 84Z" fill-rule="evenodd" style="fill:';
    string private constant PART_22 = ';"/><path d="M164 78L166 79L169 78ZM108 81L108 88L109 85L111 88L111 84ZM116 84L116 87L121 88L121 86L117 85L129 85L132 88L133 84L128 84Z" fill-rule="evenodd" style="fill:';
    string private constant PART_23 = ';"/><path d="M108 81L108 88L109 85L111 88L111 84ZM116 84L116 87L121 88L121 86L117 85L129 85L132 88L133 84L128 84Z" fill-rule="evenodd" style="fill:';
    string private constant PART_24 = ';"/><path d="M108 82L108 87L111 84L111 83ZM116 84L116 87L121 88L121 86L117 85L129 85L132 88L133 84L128 84Z" fill-rule="evenodd" style="fill:';
    string private constant PART_25 = ';"/><path d="M108 82L108 87L111 84L111 83ZM116 83L116 87L121 88L121 86L117 86L120 84ZM126 83L126 85L129 85L129 84ZM130 84L130 87L132 88L133 84Z" fill-rule="evenodd" style="fill:';
    string private constant PART_26 = ';"/><path d="M108 82L108 87L111 84L111 83ZM116 83L116 88L118 85L120 84ZM126 83L126 85L129 85L129 84ZM130 84L130 86L132 86L133 84Z" fill-rule="evenodd" style="fill:';
    string private constant PART_27 = ';"/><path d="M108 83L108 86L110 85L110 83ZM116 83L116 88L118 85L120 84ZM126 83L126 85L129 85L129 84ZM130 84L130 86L132 86L132 84Z" fill-rule="evenodd" style="fill:';
    string private constant PART_28 = ';"/><path d="M108 83L108 86L110 85L110 83ZM116 83L116 88L118 85L120 84ZM126 84L128 85L129 84Z" fill-rule="evenodd" style="fill:';
    string private constant PART_29 = ';"/><path d="M108 83L108 86L110 85L110 83ZM116 83L116 87L117 87L118 84ZM126 84L128 85L129 84Z" fill-rule="evenodd" style="fill:';
    string private constant PART_30 = ';"/><path d="M109 83L108 85L110 85L110 83ZM116 83L116 86L118 85L117 83ZM126 84L128 85L129 84Z" fill-rule="evenodd" style="fill:';
    string private constant PART_31 = ';"/><path d="M109 83L108 85L110 85L110 83ZM116 83L116 87L117 84ZM126 84L128 85L129 84Z" fill-rule="evenodd" style="fill:';
    string private constant PART_32 = ';"/><path d="M109 83L108 85L110 85L110 83ZM116 83L116 87L117 84ZM126 84L128 85L129 84Z" fill-rule="evenodd" style="fill:';
    string private constant PART_33 = ';"/><path d="M109 83L108 85L110 85L110 83ZM126 84L128 85L129 84Z" fill-rule="evenodd" style="fill:';
    string private constant PART_34 = ';"/><path d="M126 84L128 85L129 84Z" fill-rule="evenodd" style="fill:';
    string private constant PART_35 = ';"/>';
    string private constant COLOR_1 = 'hsl(210, 14%, 8%)';
    string private constant COLOR_2 = 'hsl(210, 11%, 11%)';
    string private constant COLOR_3 = 'hsl(206, 9%, 15%)';
    string private constant COLOR_4 = 'hsl(210, 6%, 18%)';
    string private constant COLOR_5 = 'hsl(206, 7%, 21%)';
    string private constant COLOR_6 = 'hsl(204, 19%, 5%)';
    string private constant COLOR_7 = 'hsl(180, 2%, 24%)';
    string private constant COLOR_8 = 'hsl(120, 1%, 28%)';
    string private constant COLOR_9 = 'hsl(90, 3%, 31%)';
    string private constant COLOR_10 = 'hsl(75, 2%, 34%)';
    string private constant COLOR_11 = 'hsl(60, 3%, 38%)';
    string private constant COLOR_12 = 'hsl(60, 3%, 45%)';
    string private constant COLOR_13 = 'hsl(212, 68%, 7%)';
    string private constant COLOR_14 = 'hsl(51, 6%, 51%)';
    string private constant COLOR_15 = 'hsl(185, 64%, 47%)';
    string private constant COLOR_16 = 'hsl(183, 67%, 56%)';
    string private constant COLOR_17 = 'hsl(187, 80%, 36%)';
    string private constant COLOR_18 = 'hsl(183, 64%, 48%)';
    string private constant COLOR_19 = 'hsl(57, 9%, 61%)';
    string private constant COLOR_20 = 'hsl(55, 6%, 56%)';
    string private constant COLOR_21 = 'hsl(178, 75%, 61%)';
    string private constant COLOR_22 = 'hsl(51, 8%, 67%)';
    string private constant COLOR_23 = 'hsl(194, 58%, 13%)';
    string private constant COLOR_24 = 'hsl(175, 89%, 76%)';
    string private constant COLOR_25 = 'hsl(188, 86%, 34%)';
    string private constant COLOR_26 = 'hsl(195, 44%, 20%)';
    string private constant COLOR_27 = 'hsl(184, 61%, 52%)';
    string private constant COLOR_28 = 'hsl(177, 87%, 72%)';
    string private constant COLOR_29 = 'hsl(193, 53%, 28%)';
    string private constant COLOR_30 = 'hsl(183, 68%, 42%)';
    string private constant COLOR_31 = 'hsl(37, 16%, 54%)';
    string private constant COLOR_32 = 'hsl(184, 50%, 38%)';
    string private constant COLOR_33 = 'hsl(202, 19%, 31%)';
    string private constant COLOR_34 = 'hsl(170, 89%, 86%)';

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
            PART_35
        );
        return result;
    }
}
