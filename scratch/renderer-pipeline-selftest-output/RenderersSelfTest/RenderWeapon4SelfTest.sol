// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderWeapon4SelfTest {
    string private constant PART_1 = '<path d="M 143 66 L 139 66 138 67 L 137 68 137 70 L 137 71 140 71 L 143 71 144 72 L 145 74 147 73 L 149 73 149 75 L 148 77 149 77 L 150 78 151 77 L 152 76 152 72 L 153 68 150 68 L 147 68 147 67 L 146 66 143 66 M 168 85 L 167 85 166 87 L 164 89 158 89 L 153 88 152 89 L 151 91 150 89 L 149 87 147 87 L 145 87 145 91 L 144 94 142 94 L 140 93 139 94 L 139 95 140 96 L 141 97 142 96 L 144 95 145 95 L 146 96 146 97 L 146 98 149 100 L 151 103 154 103 L 156 103 156 101 L 156 99 155 99 L 153 98 153 95 L 153 92 154 92 L 156 91 157 92 L 157 93 160 92 L 163 92 165 91 L 168 90 168 89 L 168 88 169 87 L 169 85 168 85 M 118 88 L 117 87 115 88 L 114 88 114 90 L 114 91 117 91 L 120 91 120 90 L 120 88 118 88 M 139 87 L 137 87 137 88 L 136 89 134 89 L 132 89 133 90 L 133 91 136 91 L 139 91 140 89 L 141 87 139 87 M 148 91 L 147 91 147 93 L 147 95 148 95 L 150 95 151 94 L 151 93 150 92 L 149 91 148 91 M 138 100 L 136 100 136 101 L 135 101 135 102 L 135 103 137 103 L 139 103 139 102 L 139 100 138 100" style="fill:';
    string private constant PART_2 = ';"/><path d="M 155 70 L 153 70 153 71 L 152 71 152 73 L 152 75 153 74 L 154 73 156 73 L 158 73 158 72 L 157 71 155 70 M 147 76 L 147 76 147 78 L 147 79 149 79 L 150 79 149 78 L 148 76 147 76 M 119 79 L 118 79 118 80 L 118 82 120 82 L 122 83 122 82 L 122 81 121 80 L 120 79 119 79 M 168 81 L 167 81 167 83 L 166 84 166 85 L 166 85 168 85 L 169 85 169 83 L 169 81 168 81 M 162 86 L 161 85 158 86 L 155 87 155 88 L 155 89 160 89 L 164 89 164 88 L 164 87 162 86 M 109 87 L 108 87 106 89 L 104 91 105 92 L 106 93 110 92 L 114 91 114 89 L 114 88 112 89 L 110 89 110 88 L 110 87 109 87 M 148 91 L 147 91 147 93 L 147 95 148 95 L 150 95 151 94 L 151 93 150 92 L 149 91 148 91 M 146 99 L 144 97 141 98 L 139 99 139 101 L 139 103 141 103 L 144 103 144 102 L 145 101 146 102 L 146 103 148 103 L 150 103 150 102 L 149 101 146 99" style="fill:';
    string private constant PART_3 = ';"/><path d="M 148 73 L 146 73 146 75 L 146 76 147 76 L 148 75 149 74 L 149 73 148 73 M 143 88 L 140 88 140 89 L 139 89 139 90 L 139 91 141 91 L 142 91 142 92 L 141 93 142 94 L 143 94 143 94 L 144 93 145 91 L 145 88 143 88 M 156 92 L 156 91 154 92 L 153 92 153 95 L 153 97 154 97 L 154 97 156 96 L 157 94 157 93 L 157 92 156 92 M 158 99 L 156 99 156 101 L 156 103 158 103 L 159 103 159 101 L 159 99 158 99" style="fill:';
    string private constant PART_4 = ';"/><path d="M 145 75 L 144 75 145 77 L 145 79 146 79 L 147 79 147 77 L 147 76 145 75 M 107 77 L 104 77 104 78 L 104 78 105 80 L 107 81 112 81 L 118 82 118 80 L 118 79 115 79 L 111 79 111 78 L 110 77 107 77 M 166 81 L 165 81 164 83 L 163 85 163 87 L 164 88 165 87 L 166 86 167 84 L 167 81 166 81 M 114 84 L 112 84 111 86 L 110 88 110 89 L 110 89 113 88 L 116 88 116 88 L 116 87 115 86 L 115 84 114 84 M 144 84 L 144 84 141 86 L 139 87 141 88 L 144 88 145 87 L 146 86 146 85 L 145 84 144 84 M 134 85 L 133 85 133 87 L 133 89 134 89 L 136 89 136 88 L 137 88 136 86 L 135 85 134 85" style="fill:';
    string private constant PART_5 = ';"/><path d="M 156 73 L 154 73 153 75 L 152 76 154 76 L 157 76 158 74 L 158 73 156 73 M 143 76 L 142 76 141 78 L 140 80 139 80 L 139 80 139 81 L 139 83 141 83 L 143 83 145 85 L 147 87 149 87 L 151 88 151 87 L 151 86 150 86 L 149 86 149 83 L 150 79 147 79 L 145 79 145 78 L 145 76 143 76 M 170 78 L 169 78 169 79 L 168 80 169 81 L 169 82 170 82 L 171 82 171 80 L 171 78 170 78 M 112 81 L 108 81 108 84 L 108 87 110 87 L 111 87 112 86 L 112 84 114 84 L 116 84 116 83 L 115 82 112 81 M 138 84 L 137 84 136 85 L 136 86 136 87 L 137 87 139 87 L 140 86 140 85 L 139 84 138 84 M 157 84 L 156 84 155 86 L 153 88 153 88 L 154 88 156 87 L 158 86 158 85 L 158 84 157 84" style="fill:';
    string private constant PART_6 = ';"/><path d="M 160 75 L 160 75 160 77 L 160 79 161 80 L 163 81 163 80 L 164 80 164 78 L 164 76 162 76 L 161 75 160 75 M 152 77 L 151 76 151 77 L 150 78 150 79 L 151 79 152 79 L 152 78 152 77 M 168 77 L 167 76 167 77 L 167 79 168 79 L 169 79 169 78 L 169 77 168 77 M 136 79 L 133 79 132 80 L 131 82 133 82 L 134 83 135 82 L 136 82 139 84 L 141 86 142 85 L 144 84 143 83 L 143 83 141 82 L 139 82 139 81 L 139 79 136 79 M 158 81 L 155 81 155 83 L 155 84 153 83 L 150 83 150 84 L 149 85 150 87 L 152 88 154 86 L 157 84 158 84 L 160 84 160 83 L 160 81 158 81" style="fill:';
    string private constant PART_7 = ';"/><path d="M 159 75 L 158 75 155 76 L 152 76 152 77 L 152 79 151 79 L 149 80 149 81 L 149 83 150 83 L 152 83 153 84 L 155 84 155 83 L 155 81 158 81 L 160 81 160 83 L 160 85 161 85 L 163 85 164 83 L 165 81 167 81 L 168 81 168 79 L 167 78 167 77 L 167 76 166 76 L 164 76 164 78 L 164 80 163 80 L 163 81 161 80 L 160 79 160 77 L 160 75 159 75 M 136 82 L 135 82 135 83 L 134 84 135 85 L 135 86 137 85 L 138 84 137 83 L 137 82 136 82" style="fill:';
    string private constant PART_8 = ';"/><path d="M 132 82 L 131 82 131 83 L 132 84 133 85 L 134 85 134 84 L 133 83 132 82 M 116 84 L 115 84 115 85 L 115 86 116 87 L 118 88 118 87 L 119 86 119 85 L 118 84 116 84 M 132 87 L 130 87 130 88 L 130 89 132 89 L 133 89 133 88 L 133 87 132 87" style="fill:';
    string private constant PART_9 = ';"/><path d="M 126 81 L 122 81 122 82 L 122 83 126 83 L 130 84 130 86 L 130 87 129 87 L 127 87 127 88 L 127 89 129 89 L 130 89 130 88 L 130 87 132 87 L 133 87 133 86 L 132 85 131 83 L 131 81 126 81 M 120 82 L 118 82 118 84 L 118 85 119 85 L 120 84 121 83 L 121 82 120 82" style="fill:';
    string private constant PART_10 = ';"/><path d="M 123 83 L 121 83 120 84 L 119 85 119 87 L 119 88 121 88 L 122 89 125 89 L 127 89 127 88 L 127 87 129 87 L 130 87 130 86 L 130 84 128 84 L 126 83 123 83" style="fill:';
    string private constant PART_11 = ';"/>';
    string private constant COLOR_1 = 'hsl(204, 7%, 13%)';
    string private constant COLOR_2 = 'hsl(204, 6%, 17%)';
    string private constant COLOR_3 = 'hsl(210, 12%, 10%)';
    string private constant COLOR_4 = 'hsl(204, 5%, 21%)';
    string private constant COLOR_5 = 'hsl(195, 7%, 24%)';
    string private constant COLOR_6 = 'hsl(180, 2%, 27%)';
    string private constant COLOR_7 = 'hsl(180, 1%, 31%)';
    string private constant COLOR_8 = 'hsl(186, 42%, 31%)';
    string private constant COLOR_9 = 'hsl(185, 53%, 38%)';
    string private constant COLOR_10 = 'hsl(182, 57%, 53%)';

    function render(Ship memory ship) external pure returns (string memory) {
        string memory chunk1 = string.concat(
            PART_1,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_1) : COLOR_1,
            PART_2,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_2) : COLOR_2,
            PART_3,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_3) : COLOR_3,
            PART_4,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_4) : COLOR_4
        );
        string memory chunk2 = string.concat(
            PART_5,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_5) : COLOR_5,
            PART_6,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_6) : COLOR_6,
            PART_7,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_7) : COLOR_7,
            PART_8,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_8) : COLOR_8
        );
        string memory chunk3 = string.concat(
            PART_9,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_9) : COLOR_9,
            PART_10,
            ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_10) : COLOR_10,
            PART_11
        );
        return string.concat(
            chunk1,
            chunk2,
            chunk3
        );
    }
}
