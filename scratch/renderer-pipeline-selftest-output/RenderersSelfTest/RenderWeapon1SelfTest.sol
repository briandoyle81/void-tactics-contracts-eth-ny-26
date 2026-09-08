// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderWeapon1SelfTest {
    string private constant PART_1 = '<path d="M 149 78 L 148 78 148 79 L 147 80 143 80 L 139 80 139 81 L 140 82 142 83 L 145 84 147 83 L 150 82 151 83 L 153 84 154 82 L 155 81 152 79 L 150 78 149 78 M 166 89 L 166 89 164 90 L 162 90 162 91 L 162 92 165 92 L 168 93 168 93 L 168 92 167 91 L 167 89 166 89 M 149 90 L 148 90 148 92 L 148 94 147 95 L 145 96 143 96 L 141 95 142 96 L 144 98 144 99 L 144 100 145 100 L 146 100 148 96 L 151 93 151 91 L 150 90 149 90 M 134 92 L 133 92 133 93 L 134 94 135 95 L 137 96 138 96 L 138 95 137 94 L 136 92 134 92 M 155 94 L 153 94 153 95 L 153 96 155 96 L 156 97 157 97 L 157 97 157 96 L 157 94 155 94 M 140 100 L 139 100 138 101 L 137 102 137 104 L 137 105 139 105 L 141 105 141 103 L 141 100 140 100 M 149 101 L 148 101 148 103 L 148 105 149 105 L 150 105 150 103 L 150 101 149 101" style="fill:';
    string private constant PART_2 = ';"/><path d="M 116 92 L 116 91 114 92 L 112 92 112 93 L 112 94 115 94 L 117 94 117 93 L 117 92 116 92 M 165 92 L 163 92 162 93 L 162 94 162 95 L 163 95 164 95 L 166 94 166 93 L 166 92 165 92 M 151 94 L 150 94 148 97 L 146 99 147 100 L 147 101 149 101 L 150 101 150 103 L 150 105 151 105 L 152 105 152 102 L 152 99 154 98 L 156 97 154 96 L 151 94 151 94 M 141 96 L 140 96 140 98 L 139 100 142 100 L 144 100 144 99 L 144 97 142 97 L 141 96 141 96" style="fill:';
    string private constant PART_3 = ';"/><path d="M 138 81 L 137 81 137 81 L 137 82 136 84 L 136 87 137 87 L 139 87 139 85 L 140 83 139 82 L 139 81 138 81 M 156 81 L 154 81 154 82 L 153 84 154 84 L 154 85 156 84 L 158 84 158 82 L 158 81 156 81 M 162 81 L 160 81 160 82 L 160 83 161 84 L 163 84 162 87 L 162 90 163 90 L 165 90 166 88 L 168 87 168 86 L 168 84 166 84 L 163 83 163 82 L 163 81 162 81 M 115 89 L 113 89 113 90 L 112 91 113 91 L 114 92 115 92 L 116 91 116 90 L 116 89 115 89 M 141 89 L 140 89 138 90 L 136 92 137 94 L 139 96 142 96 L 146 96 147 95 L 148 94 148 91 L 149 89 147 89 L 146 90 146 92 L 146 94 144 94 L 142 94 142 92 L 142 90 141 89 M 168 89 L 167 89 167 91 L 168 92 168 93 L 168 93 169 93 L 170 92 170 90 L 170 89 168 89 M 152 92 L 151 91 151 92 L 151 94 152 94 L 153 95 153 94 L 154 93 152 92 M 144 100 L 141 100 141 102 L 141 105 145 105 L 148 105 148 103 L 148 101 144 100" style="fill:';
    string private constant PART_4 = ';"/><path d="M 158 81 L 158 81 158 83 L 159 84 160 85 L 162 86 163 86 L 163 85 161 83 L 159 81 158 81 M 131 82 L 127 82 127 83 L 126 84 121 84 L 116 84 114 85 L 113 86 113 87 L 114 89 120 89 L 127 88 131 88 L 136 88 136 86 L 137 85 136 83 L 136 82 131 82 M 149 82 L 148 82 148 83 L 148 84 149 85 L 151 86 151 85 L 152 84 152 83 L 151 82 149 82 M 142 83 L 140 83 139 85 L 138 88 140 89 L 141 90 142 89 L 143 89 142 87 L 140 86 140 86 L 140 85 142 85 L 144 85 144 84 L 144 83 142 83 M 169 85 L 168 85 168 87 L 167 88 167 89 L 167 89 169 89 L 170 89 170 87 L 170 85 169 85 M 144 91 L 142 91 142 93 L 142 94 144 94 L 146 94 146 93 L 146 91 144 91" style="fill:';
    string private constant PART_5 = ';"/><path d="M 146 83 L 145 83 145 84 L 145 84 146 86 L 148 87 151 91 L 154 94 156 94 L 157 94 157 94 L 157 93 152 88 L 148 83 146 83 M 144 89 L 142 89 142 90 L 142 91 144 91 L 145 91 145 90 L 145 89 144 89" style="fill:';
    string private constant PART_6 = ';"/><path d="M 146 85 L 145 84 143 85 L 142 85 142 87 L 142 88 144 89 L 146 90 147 89 L 148 88 147 87 L 147 85 146 85 M 158 84 L 157 84 157 86 L 157 87 158 87 L 159 86 159 86 L 159 85 158 84 M 156 89 L 154 89 154 90 L 155 92 156 92 L 157 92 158 90 L 158 89 156 89" style="fill:';
    string private constant PART_7 = ';"/><path d="M 154 84 L 152 84 151 85 L 151 86 152 88 L 153 89 156 89 L 158 89 158 87 L 157 86 157 85 L 157 84 154 84" style="fill:';
    string private constant PART_8 = ';"/><path d="M 112 84 L 111 84 111 85 L 110 85 110 88 L 110 90 112 90 L 113 90 113 89 L 113 88 113 86 L 113 84 112 84 M 161 86 L 159 86 159 87 L 158 88 158 90 L 157 93 158 93 L 160 93 161 92 L 162 91 162 88 L 162 86 161 86" style="fill:';
    string private constant PART_9 = ';"/><path d="M 137 87 L 136 87 136 89 L 136 91 137 91 L 139 90 139 89 L 139 88 137 87 M 117 89 L 116 89 116 90 L 116 92 117 93 L 118 93 119 93 L 119 92 118 91 L 118 89 117 89 M 111 90 L 110 90 110 91 L 110 93 111 93 L 112 94 112 93 L 113 91 112 91 L 112 90 111 90 M 162 92 L 162 91 159 92 L 157 93 157 95 L 157 96 159 96 L 160 95 161 95 L 162 95 162 94 L 163 92 162 92" style="fill:';
    string private constant PART_10 = ';"/><path d="M 135 87 L 134 87 126 88 L 119 89 118 89 L 118 90 119 91 L 119 93 125 93 L 132 93 134 92 L 136 92 136 90 L 136 88 135 87" style="fill:';
    string private constant PART_11 = ';"/>';
    string private constant COLOR_1 = 'hsl(210, 12%, 13%)';
    string private constant COLOR_2 = 'hsl(200, 19%, 9%)';
    string private constant COLOR_3 = 'hsl(192, 6%, 16%)';
    string private constant COLOR_4 = 'hsl(200, 3%, 21%)';
    string private constant COLOR_5 = 'hsl(180, 2%, 24%)';
    string private constant COLOR_6 = 'hsl(90, 3%, 29%)';
    string private constant COLOR_7 = 'hsl(60, 4%, 35%)';
    string private constant COLOR_8 = 'hsl(0, 19%, 25%)';
    string private constant COLOR_9 = 'hsl(0, 15%, 16%)';
    string private constant COLOR_10 = 'hsl(3, 40%, 18%)';

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
