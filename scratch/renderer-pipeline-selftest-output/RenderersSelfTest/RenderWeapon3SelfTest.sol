// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderWeapon3SelfTest {
    string private constant PART_1 = '<path d="M 165 77 L 163 77 164 78 L 165 79 166 78 L 167 77 165 77 M 132 78 L 128 78 129 80 L 129 83 132 84 L 135 84 136 83 L 137 82 136 80 L 136 78 132 78 M 145 78 L 143 78 143 79 L 143 81 142 81 L 141 82 141 83 L 142 84 143 82 L 143 81 145 81 L 147 81 147 80 L 147 78 145 78 M 157 78 L 152 78 152 80 L 151 82 150 83 L 150 84 153 84 L 157 84 159 81 L 161 78 157 78 M 166 81 L 163 81 162 84 L 160 86 162 87 L 165 88 165 89 L 166 90 168 89 L 169 89 169 88 L 169 87 166 87 L 164 87 165 86 L 166 84 168 84 L 169 84 169 83 L 169 81 166 81 M 150 88 L 147 87 145 88 L 143 88 143 89 L 143 90 145 90 L 147 91 150 92 L 154 92 154 91 L 154 89 150 88 M 135 88 L 134 88 132 89 L 131 89 131 90 L 131 91 134 91 L 137 91 136 90 L 136 89 135 88" style="fill:';
    string private constant PART_2 = ';"/><path d="M 137 76 L 135 76 136 78 L 136 81 136 83 L 136 85 139 84 L 141 84 141 86 L 141 88 140 89 L 139 89 137 87 L 135 85 132 86 L 130 87 129 89 L 129 91 130 91 L 130 91 132 89 L 133 88 135 88 L 136 89 136 90 L 137 91 134 91 L 132 91 132 92 L 132 93 133 93 L 135 94 137 93 L 139 92 143 93 L 148 94 148 95 L 148 96 149 96 L 150 96 150 94 L 150 91 148 91 L 146 91 144 90 L 143 89 143 89 L 144 88 145 88 L 147 88 150 88 L 154 89 154 90 L 154 91 157 91 L 160 91 163 90 L 166 88 163 87 L 160 86 162 84 L 163 81 165 81 L 166 81 166 80 L 166 79 165 79 L 163 78 162 79 L 161 80 161 80 L 161 79 160 80 L 158 81 159 84 L 159 86 158 86 L 157 86 153 86 L 150 86 149 85 L 149 84 146 84 L 144 84 142 83 L 141 82 142 81 L 143 81 143 79 L 143 78 141 78 L 139 78 139 77 L 139 76 137 76 M 150 78 L 147 78 147 80 L 147 81 150 81 L 152 81 152 80 L 152 78 150 78 M 170 82 L 169 82 169 83 L 168 85 169 86 L 169 88 171 88 L 172 88 172 85 L 172 83 170 82" style="fill:';
    string private constant PART_3 = ';"/><path d="M 168 78 L 167 77 167 78 L 166 78 166 80 L 166 81 168 81 L 169 81 169 80 L 169 78 168 78 M 132 84 L 129 83 130 84 L 130 86 133 86 L 135 86 137 87 L 139 89 140 89 L 141 88 141 87 L 141 86 140 86 L 139 87 137 85 L 136 84 132 84 M 158 83 L 158 83 153 84 L 149 84 149 85 L 149 86 153 86 L 157 87 158 86 L 159 86 159 84 L 159 83 158 83 M 127 86 L 125 85 124 86 L 124 87 125 87 L 126 87 126 88 L 125 89 126 89 L 128 89 129 91 L 130 93 131 93 L 132 93 132 92 L 132 91 131 91 L 129 91 129 89 L 129 87 127 86 M 171 88 L 169 88 169 89 L 169 90 171 90 L 172 90 172 89 L 172 88 171 88 M 125 92 L 124 92 124 93 L 124 94 125 94 L 126 95 126 93 L 127 92 125 92 M 152 92 L 150 92 150 94 L 150 96 149 96 L 148 96 148 95 L 148 94 147 94 L 145 94 145 96 L 145 97 147 97 L 150 97 151 96 L 153 96 153 94 L 153 92 152 92" style="fill:';
    string private constant PART_4 = ';"/><path d="M 127 79 L 125 79 125 81 L 126 82 126 84 L 126 85 128 84 L 129 84 129 81 L 129 79 127 79 M 127 89 L 126 89 126 91 L 126 92 127 92 L 128 91 128 90 L 128 89 127 89" style="fill:';
    string private constant PART_5 = ';"/><path d="M 129 84 L 127 84 127 85 L 126 85 127 86 L 127 87 129 87 L 130 87 130 86 L 130 84 129 84 M 139 84 L 137 84 137 85 L 137 86 138 86 L 138 87 140 86 L 141 86 141 85 L 141 84 139 84 M 166 89 L 163 89 163 90 L 162 90 158 91 L 154 92 153 93 L 153 94 156 94 L 160 94 161 92 L 163 90 165 91 L 167 92 167 93 L 167 94 166 94 L 166 94 164 94 L 163 94 163 95 L 163 96 166 96 L 168 96 169 94 L 169 93 171 91 L 173 90 171 90 L 170 90 166 89 M 128 91 L 127 91 127 92 L 127 92 129 94 L 131 96 135 96 L 139 97 139 96 L 139 95 141 95 L 143 95 144 98 L 144 100 148 100 L 153 100 153 99 L 154 99 153 98 L 153 96 149 97 L 145 97 145 96 L 145 94 143 93 L 140 92 137 93 L 135 93 133 93 L 131 93 130 92 L 129 91 128 91" style="fill:';
    string private constant PART_6 = ';"/><path d="M 124 80 L 124 80 122 81 L 120 82 122 84 L 125 86 126 85 L 126 83 126 82 L 125 80 124 80" style="fill:';
    string private constant PART_7 = ';"/><path d="M 164 91 L 162 91 161 92 L 160 94 156 94 L 153 94 153 95 L 153 96 157 96 L 161 96 161 95 L 161 93 164 94 L 167 94 167 93 L 166 92 164 91 M 127 93 L 126 93 126 94 L 126 95 128 95 L 129 96 130 96 L 130 95 130 94 L 129 93 127 93 M 141 95 L 139 95 139 97 L 140 99 137 100 L 134 101 133 102 L 133 103 144 103 L 156 103 156 101 L 155 100 150 100 L 144 100 144 98 L 143 95 141 95" style="fill:';
    string private constant PART_8 = ';"/><path d="M 147 81 L 143 81 143 83 L 143 84 146 84 L 150 84 150 83 L 151 81 147 81 M 167 84 L 166 84 165 85 L 164 87 166 87 L 169 87 169 86 L 168 85 167 84" style="fill:';
    string private constant PART_9 = ';"/><path d="M 120 82 L 119 82 119 83 L 118 84 121 85 L 123 86 124 86 L 124 86 123 84 L 121 82 120 82 M 121 90 L 119 89 119 90 L 118 91 120 92 L 122 93 122 92 L 122 91 121 90" style="fill:';
    string private constant PART_10 = ';"/><path d="M 123 88 L 121 88 121 89 L 120 90 121 91 L 123 93 124 92 L 126 92 126 90 L 125 89 123 88" style="fill:';
    string private constant PART_11 = ';"/>';
    string private constant COLOR_1 = 'hsl(150, 1%, 28%)';
    string private constant COLOR_2 = 'hsl(200, 3%, 22%)';
    string private constant COLOR_3 = 'hsl(40, 3%, 18%)';
    string private constant COLOR_4 = 'hsl(6, 23%, 25%)';
    string private constant COLOR_5 = 'hsl(210, 8%, 16%)';
    string private constant COLOR_6 = 'hsl(9, 44%, 33%)';
    string private constant COLOR_7 = 'hsl(214, 12%, 11%)';
    string private constant COLOR_8 = 'hsl(72, 3%, 32%)';
    string private constant COLOR_9 = 'hsl(5, 38%, 25%)';
    string private constant COLOR_10 = 'hsl(7, 43%, 30%)';

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
