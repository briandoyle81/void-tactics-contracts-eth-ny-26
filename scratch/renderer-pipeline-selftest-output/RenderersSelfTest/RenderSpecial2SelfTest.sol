// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderSpecial2SelfTest {
    string private constant PART_1 = '<path d="M 57 25 L 56 25 55 26 L 55 28 56 29 L 58 31 60 31 L 61 31 61 30 L 60 29 59 27 L 59 25 57 25 M 69 32 L 68 32 67 34 L 66 36 67 36 L 68 37 69 35 L 70 33 70 33 L 70 32 69 32 M 52 34 L 51 34 51 35 L 52 36 53 37 L 54 37 54 36 L 54 34 52 34 M 63 40 L 60 40 60 41 L 60 42 59 43 L 59 45 62 45 L 65 45 66 42 L 67 40 63 40 M 68 46 L 67 45 66 47 L 65 49 65 49 L 65 50 67 50 L 69 50 69 48 L 69 46 68 46 M 103 46 L 101 46 101 48 L 100 50 101 51 L 103 52 103 50 L 104 49 104 47 L 104 46 103 46 M 95 57 L 90 57 90 58 L 89 59 90 59 L 91 60 94 59 L 97 59 98 59 L 99 59 99 58 L 99 57 95 57 M 93 203 L 92 203 92 205 L 93 206 93 207 L 93 207 94 207 L 95 207 95 205 L 95 203 93 203 M 111 204 L 109 204 109 206 L 109 207 109 207 L 110 207 111 206 L 113 206 113 205 L 113 204 111 204 M 92 215 L 90 214 89 215 L 89 216 90 218 L 91 219 90 218 L 88 218 88 219 L 88 220 90 220 L 93 219 93 219 L 94 219 94 218 L 94 216 92 215 M 97 218 L 96 218 96 221 L 96 223 97 223 L 99 223 99 222 L 100 222 99 220 L 98 218 97 218" style="fill:';
    string private constant PART_2 = ';"/><path d="M 73 27 L 72 27 72 29 L 72 31 74 31 L 75 31 75 29 L 75 28 73 27 M 50 47 L 49 46 48 48 L 47 51 48 51 L 48 52 50 50 L 52 49 52 48 L 52 47 50 47 M 100 50 L 98 50 98 52 L 99 54 97 55 L 95 55 93 53 L 92 52 89 53 L 87 54 89 56 L 90 57 95 57 L 100 57 101 55 L 102 53 102 51 L 101 50 100 50 M 111 202 L 110 202 110 203 L 109 204 111 204 L 113 204 113 203 L 112 202 111 202 M 107 209 L 106 209 105 211 L 103 213 103 214 L 104 216 105 216 L 106 216 106 214 L 105 212 106 212 L 108 212 108 211 L 108 209 107 209 M 92 213 L 91 213 91 214 L 92 215 93 216 L 94 216 94 215 L 94 213 92 213" style="fill:';
    string private constant PART_3 = ';"/><path d="M 60 32 L 56 30 56 31 L 55 31 56 33 L 56 35 58 35 L 60 35 60 36 L 61 37 64 36 L 67 35 67 34 L 66 33 65 33 L 64 33 60 32 M 49 31 L 48 31 48 34 L 48 36 49 36 L 51 36 51 35 L 52 34 51 32 L 51 31 49 31 M 95 50 L 93 50 93 52 L 94 54 95 55 L 97 55 98 54 L 99 53 98 52 L 98 50 95 50 M 102 205 L 99 205 99 206 L 99 207 101 209 L 102 210 101 211 L 100 213 98 212 L 97 211 96 211 L 95 212 95 213 L 95 214 97 214 L 99 213 99 214 L 99 216 101 216 L 102 217 103 216 L 104 216 103 214 L 103 213 105 211 L 106 209 105 207 L 104 206 102 205 M 91 211 L 90 211 90 213 L 90 214 91 214 L 92 213 92 212 L 92 211 91 211" style="fill:';
    string private constant PART_4 = ';"/><path d="M 64 29 L 61 29 61 31 L 60 32 61 32 L 63 32 65 33 L 68 33 68 32 L 69 32 68 30 L 67 29 64 29 M 55 32 L 54 32 54 33 L 53 33 54 34 L 54 35 55 35 L 56 35 56 34 L 56 32 55 32 M 65 35 L 65 35 63 36 L 62 36 62 38 L 62 40 64 40 L 66 40 67 39 L 68 38 67 36 L 66 35 65 35 M 85 50 L 84 50 84 52 L 85 55 86 54 L 87 54 87 52 L 87 51 85 50 M 102 216 L 99 216 98 217 L 98 218 99 219 L 99 221 100 221 L 102 221 103 219 L 105 217 105 217 L 105 216 102 216" style="fill:';
    string private constant PART_5 = ';"/><path d="M 72 31 L 71 31 72 32 L 72 33 73 33 L 74 33 74 32 L 74 31 72 31 M 71 36 L 70 36 70 37 L 70 38 71 39 L 72 39 72 38 L 72 36 71 36 M 55 37 L 54 37 54 40 L 54 43 56 42 L 58 40 57 38 L 56 37 55 37 M 75 44 L 73 42 72 43 L 71 44 72 44 L 73 45 73 47 L 72 48 73 48 L 75 48 75 46 L 76 45 75 44 M 97 45 L 95 45 95 46 L 95 47 96 47 L 97 47 96 49 L 96 50 97 50 L 98 50 98 48 L 98 45 97 45 M 66 50 L 65 50 66 51 L 66 52 68 52 L 69 52 69 51 L 68 50 66 50 M 113 220 L 111 220 111 222 L 111 223 111 223 L 112 223 113 222 L 115 222 115 221 L 115 220 113 220 M 87 222 L 86 222 86 223 L 85 223 85 225 L 85 226 86 226 L 87 226 87 224 L 88 222 87 222 M 107 224 L 105 224 105 225 L 104 226 105 228 L 106 230 107 230 L 108 230 108 228 L 109 226 109 225 L 108 224 107 224" style="fill:';
    string private constant PART_6 = ';"/><path d="M 71 32 L 70 32 69 36 L 67 39 67 40 L 68 41 68 40 L 69 40 71 42 L 72 43 73 43 L 73 42 72 41 L 71 41 71 39 L 70 37 72 35 L 73 34 72 33 L 72 32 71 32 M 59 40 L 57 40 56 41 L 55 43 58 46 L 61 49 61 49 L 62 49 62 47 L 62 46 63 47 L 64 48 65 48 L 66 48 66 47 L 66 45 62 45 L 59 45 60 43 L 60 40 59 40 M 51 53 L 49 51 49 52 L 48 53 50 54 L 52 56 52 55 L 53 55 51 53 M 67 52 L 66 52 65 53 L 64 54 64 55 L 64 56 66 56 L 67 56 67 56 L 67 55 68 54 L 68 52 67 52 M 100 57 L 99 57 99 58 L 98 59 95 59 L 92 59 92 61 L 92 62 95 62 L 98 61 98 62 L 98 64 97 65 L 96 66 97 66 L 98 66 99 65 L 100 63 100 62 L 99 60 101 60 L 102 60 102 59 L 101 58 100 57 M 88 59 L 86 59 85 61 L 85 63 86 64 L 87 66 87 64 L 87 62 89 61 L 91 61 90 60 L 90 59 88 59 M 104 62 L 103 62 103 64 L 103 66 104 65 L 106 64 105 63 L 105 62 104 62 M 87 215 L 85 215 86 216 L 86 217 88 217 L 89 217 89 216 L 89 215 87 215 M 106 216 L 105 216 105 218 L 105 219 107 219 L 109 219 109 221 L 108 223 109 223 L 111 223 111 222 L 111 221 109 218 L 108 216 106 216 M 95 219 L 95 218 93 219 L 91 219 91 220 L 91 221 93 222 L 95 223 95 223 L 96 223 96 221 L 96 219 95 219 M 90 222 L 90 222 88 223 L 87 223 87 225 L 87 226 85 226 L 84 226 84 227 L 84 229 85 230 L 86 230 86 228 L 86 227 88 226 L 90 226 90 224 L 90 222 90 222 M 114 222 L 113 222 113 223 L 113 224 113 226 L 113 229 112 229 L 111 229 111 230 L 111 231 112 231 L 114 231 115 228 L 117 225 116 223 L 115 222 114 222" style="fill:';
    string private constant PART_7 = ';"/><path d="M 58 35 L 56 35 56 36 L 56 38 57 39 L 58 40 60 40 L 62 40 62 39 L 62 37 61 36 L 60 35 58 35 M 109 212 L 109 211 107 212 L 105 212 105 214 L 106 215 106 216 L 106 216 109 216 L 112 216 112 215 L 112 213 111 213 L 109 213 109 212 M 98 213 L 98 213 96 214 L 94 214 94 216 L 94 217 95 217 L 96 216 97 217 L 97 218 98 217 L 99 217 99 215 L 99 213 98 213" style="fill:';
    string private constant PART_8 = ';"/><path d="M 69 40 L 68 40 67 41 L 65 43 65 44 L 66 46 69 44 L 71 43 71 42 L 70 41 69 40 M 56 44 L 55 43 54 44 L 53 45 54 46 L 55 47 56 46 L 57 45 56 44 M 53 47 L 52 47 52 48 L 52 48 53 50 L 54 52 56 52 L 58 52 56 51 L 55 51 55 49 L 54 47 53 47 M 92 62 L 91 62 91 63 L 91 65 92 66 L 93 66 93 64 L 93 62 92 62 M 112 206 L 111 206 110 208 L 108 209 108 210 L 108 211 109 211 L 111 211 112 209 L 113 207 113 207 L 113 206 112 206 M 107 219 L 104 218 101 221 L 99 223 94 222 L 90 222 90 224 L 90 226 91 225 L 92 224 93 224 L 94 224 94 227 L 94 230 95 230 L 96 230 96 228 L 96 226 99 225 L 102 224 103 225 L 104 226 106 223 L 109 220 109 220 L 109 219 107 219" style="fill:';
    string private constant PART_9 = ';"/><path d="M 103 59 L 102 59 102 60 L 101 60 102 61 L 102 62 104 62 L 105 62 104 61 L 104 59 103 59 M 111 211 L 109 211 109 212 L 109 213 111 213 L 112 213 112 212 L 112 211 111 211 M 96 217 L 95 216 95 217 L 94 218 95 218 L 96 219 96 218 L 97 217 96 217 M 107 230 L 105 229 105 230 L 104 230 104 232 L 104 234 105 234 L 106 234 107 232 L 108 230 107 230 M 85 230 L 85 230 85 231 L 85 232 86 232 L 88 233 88 232 L 89 231 87 231 L 86 230 85 230" style="fill:';
    string private constant PART_10 = ';"/><path d="M 98 206 L 98 206 96 207 L 94 208 92 209 L 90 210 92 212 L 94 214 96 212 L 97 211 98 212 L 100 213 101 211 L 102 210 100 208 L 98 206 98 206" style="fill:';
    string private constant PART_11 = ';"/>';
    string private constant COLOR_1 = 'hsl(28, 31%, 20%)';
    string private constant COLOR_2 = 'hsl(24, 30%, 26%)';
    string private constant COLOR_3 = 'hsl(27, 47%, 33%)';
    string private constant COLOR_4 = 'hsl(27, 53%, 26%)';
    string private constant COLOR_5 = 'hsl(26, 13%, 22%)';
    string private constant COLOR_6 = 'hsl(24, 11%, 18%)';
    string private constant COLOR_7 = 'hsl(192, 16%, 32%)';
    string private constant COLOR_8 = 'hsl(36, 7%, 13%)';
    string private constant COLOR_9 = 'hsl(197, 6%, 23%)';
    string private constant COLOR_10 = 'hsl(28, 43%, 43%)';

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
