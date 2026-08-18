// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderWeapon2SelfTest {
    string private constant PART_1 = '<path d="M 69.941 86 L 68 86 68 87 L 68 88 70.750 88.162 L 73.500 88.325 83.750 88.456 L 94 88.588 94 87.846 L 94 87.105 88.750 86.802 L 83.500 86.500 78.191 87.059 L 72.882 87.618 72.382 86.809 L 71.882 86 69.941 86 M 121.500 87 L 118.100 86.233 117.575 86.758 L 117.050 87.283 106.025 87.140 L 95 86.996 95 88.026 L 95 89.055 104.750 88.945 L 114.500 88.835 121.809 88.917 L 129.118 89 128.507 89.989 L 127.896 90.977 129.648 90.305 L 131.399 89.633 130.256 89.252 L 129.112 88.871 129.600 87.599 L 130.088 86.328 128.064 86.477 L 126.041 86.626 125.470 87.196 L 124.900 87.767 121.500 87 M 139.500 97.195 L 136.500 97.232 138.269 97.693 L 140.038 98.154 141.269 97.656 L 142.500 97.158 139.500 97.195 M 132.500 98.195 L 129.500 98.232 131.269 98.693 L 133.038 99.154 134.269 98.656 L 135.500 98.158 132.500 98.195" fill-rule="evenodd" style="fill:';
    string private constant PART_2 = ';"/><path d="M 148 85 L 147 85 147 86.500 L 147 88 148 88 L 149 88 149 86.500 L 149 85 148 85 M 173.011 87 L 172.022 87 172.223 89.428 L 172.424 91.856 173.212 91.369 L 174 90.882 174 88.941 L 174 87 173.011 87 M 75 92.272 L 70.500 92.272 72.750 92.706 L 75 93.139 77.250 92.706 L 79.500 92.272 75 92.272 M 98 92.232 L 94.500 92.232 96.250 92.689 L 98 93.147 99.750 92.689 L 101.500 92.232 98 92.232 M 105.500 92.195 L 102.500 92.232 104.269 92.693 L 106.038 93.154 107.269 92.656 L 108.500 92.158 105.500 92.195 M 111.500 92.195 L 108.500 92.232 110.269 92.693 L 112.038 93.154 113.269 92.656 L 114.500 92.158 111.500 92.195 M 142.667 92 L 141.333 92 140.694 92.639 L 140.054 93.279 140.586 94.139 L 141.118 95 142.559 95 L 144 95 144 93.500 L 144 92 142.667 92 M 146.862 92.451 L 145.500 92.251 145.356 94.625 L 145.212 97 146.106 97 L 147 97 147 95.893 L 147 94.786 148.541 95.377 L 150.082 95.969 149.153 94.309 L 148.225 92.650 146.862 92.451 M 132.922 93 L 132.245 93 130.905 94.750 L 129.566 96.500 130.434 95.766 L 131.302 95.031 132.451 96.602 L 133.600 98.173 133.600 95.587 L 133.600 93 132.922 93 M 124.559 95 L 122 95 122 95.383 L 122 95.767 123.999 96.289 L 125.998 96.812 126.558 95.906 L 127.118 95 124.559 95" fill-rule="evenodd" style="fill:';
    string private constant PART_3 = ';"/><path d="M 150.941 82 L 150 82 150 83 L 150 84 151.559 84 L 153.118 84 152.500 83 L 151.882 82 150.941 82 M 154.995 82.497 L 154 81.882 154 82.483 L 154 83.084 156.123 85.292 L 158.247 87.500 157.118 85.306 L 155.989 83.111 154.995 82.497 M 107 84.272 L 102.500 84.272 104.750 84.706 L 107 85.139 109.250 84.706 L 111.500 84.272 107 84.272 M 152.500 87 L 151.118 87 150.624 87.800 L 150.129 88.600 152.500 88.600 L 154.871 88.600 154.376 87.800 L 153.882 87 152.500 87 M 171.713 88 L 171.158 86.500 171.079 89.083 L 171 91.667 172.484 91.667 L 173.968 91.667 173.118 90.583 L 172.269 89.500 171.713 88 M 156.793 88.460 L 156.424 88.091 155.143 90.143 L 153.861 92.195 154.350 92.683 L 154.838 93.171 156 91 L 157.162 88.829 156.793 88.460 M 162.589 90.356 L 160.192 90.500 160.655 91.250 L 161.118 92 162.500 92 L 163.882 92 164.434 91.106 L 164.987 90.212 162.589 90.356 M 141.833 95 L 138.667 95 139.301 95.634 L 139.935 96.268 142.467 96.546 L 145 96.824 145 95.912 L 145 95 141.833 95" fill-rule="evenodd" style="fill:';
    string private constant PART_4 = ';"/><path d="M 66.441 86 L 64.882 86 65.447 86.915 L 66.012 87.829 64.756 88.336 L 63.500 88.842 68.128 88.921 L 72.755 89 73.862 87.667 L 74.968 86.333 73.528 86.333 L 72.088 86.333 72.603 87.167 L 73.118 88 70.559 88 L 68 88 68 87 L 68 86 66.441 86 M 89.500 86.286 L 84.500 86.300 87.264 86.718 L 90.027 87.135 92.264 86.704 L 94.500 86.272 89.500 86.286 M 103 86.232 L 99.500 86.232 101.250 86.689 L 103 87.147 104.750 86.689 L 106.500 86.232 103 86.232 M 109.500 86.195 L 106.500 86.232 108.269 86.693 L 110.038 87.154 111.269 86.656 L 112.500 86.158 109.500 86.195 M 115.417 86.079 L 112.500 86.158 113.756 86.664 L 115.012 87.171 114.314 88.335 L 113.616 89.500 115.558 88.033 L 117.500 86.566 117.917 86.283 L 118.333 86 115.417 86.079 M 123.559 86 L 121 86 121 86.383 L 121 86.767 122.999 87.289 L 124.998 87.812 125.558 86.906 L 126.118 86 123.559 86 M 141.711 86 L 139.667 86 140.242 86.575 L 140.817 87.150 142.158 87.353 L 143.500 87.556 145 88.470 L 146.500 89.384 145.128 87.692 L 143.755 86 141.711 86" fill-rule="evenodd" style="fill:';
    string private constant PART_5 = ';"/><path d="M 153 80 L 149.118 80 148.643 80.768 L 148.168 81.537 151.975 81.174 L 155.782 80.811 158.150 82.363 L 160.519 83.915 162.010 82.973 L 163.500 82.031 160.809 82.015 L 158.118 82 157.500 81 L 156.882 80 153 80 M 134.500 81.310 L 128.500 81.320 131.768 81.725 L 135.036 82.129 137.768 81.715 L 140.500 81.300 134.500 81.310 M 68.500 84.252 L 64.500 84.272 66.762 84.707 L 69.023 85.142 70.762 84.687 L 72.500 84.232 68.500 84.252 M 158.119 95 L 157.310 95 155.494 97.006 L 153.679 99.012 154.089 99.307 L 154.500 99.601 156.714 97.301 L 158.929 95 158.119 95 M 127 98.232 L 123.500 98.232 125.250 98.689 L 127 99.147 128.750 98.689 L 130.500 98.232 127 98.232" fill-rule="evenodd" style="fill:';
    string private constant PART_6 = ';"/><path d="M 108.500 82.286 L 103.500 82.300 106.264 82.718 L 109.027 83.135 111.264 82.704 L 113.500 82.272 108.500 82.286 M 87.500 84.252 L 83.500 84.272 85.762 84.707 L 88.023 85.142 89.762 84.687 L 91.500 84.232 87.500 84.252" fill-rule="evenodd" style="fill:';
    string private constant PART_7 = ';"/><path d="M 79 96.272 L 74.500 96.272 76.750 96.706 L 79 97.139 81.250 96.706 L 83.500 96.272 79 96.272 M 95 96.272 L 90.500 96.272 92.750 96.706 L 95 97.139 97.250 96.706 L 99.500 96.272 95 96.272 M 152.956 96.473 L 152 95.882 151.923 96.191 L 151.847 96.500 151.512 98.250 L 151.177 100 151.981 100 L 152.786 100 153.349 98.532 L 153.913 97.064 152.956 96.473" fill-rule="evenodd" style="fill:';
    string private constant PART_8 = ';"/><path d="M 151.591 92.258 L 151 91.667 151 92.892 L 151 94.118 150.011 93.507 L 149.023 92.896 149.585 94.361 L 150.147 95.825 148.323 96.297 L 146.500 96.768 148.683 96.884 L 150.865 97 151.524 94.925 L 152.183 92.849 151.591 92.258 M 90 95.272 L 85.500 95.272 87.750 95.706 L 90 96.139 92.250 95.706 L 94.500 95.272 90 95.272" fill-rule="evenodd" style="fill:';
    string private constant PART_9 = ';"/><path d="M 130.957 90.272 L 129 90.124 129 90.974 L 129 91.823 130.471 91.607 L 131.942 91.391 132.428 90.905 L 132.914 90.419 130.957 90.272 M 165.500 92.252 L 161.500 92.272 163.762 92.707 L 166.023 93.142 167.762 92.687 L 169.500 92.232 165.500 92.252 M 70.500 93.195 L 67.500 93.232 69.269 93.693 L 71.038 94.154 72.269 93.656 L 73.500 93.158 70.500 93.195" fill-rule="evenodd" style="fill:';
    string private constant PART_10 = ';"/><path d="M 144.750 100.745 L 143.500 100.277 141.500 101.068 L 139.500 101.859 142.750 101.930 L 146 102 146 101.607 L 146 101.214 144.750 100.745" fill-rule="evenodd" style="fill:';
    string private constant PART_11 = ';"/><path d="M 76.500 95.195 L 73.500 95.232 75.269 95.693 L 77.038 96.154 78.269 95.656 L 79.500 95.158 76.500 95.195" fill-rule="evenodd" style="fill:';
    string private constant PART_12 = ';"/><path d="M 66 95.300 L 60.500 95.300 63.250 95.716 L 66 96.133 68.750 95.716 L 71.500 95.300 66 95.300 M 145.500 103.229 L 143 103.436 143 104.218 L 143 105 145.500 105 L 148 105 148 104.011 L 148 103.022 145.500 103.229" fill-rule="evenodd" style="fill:';
    string private constant PART_13 = ';"/><path d="M 158.816 87.483 L 158.247 86.914 157.624 88.539 L 157 90.164 157 90.641 L 157 91.118 157.915 90.553 L 158.829 89.988 159.351 91.244 L 159.873 92.500 159.629 90.276 L 159.385 88.052 158.816 87.483 M 104.500 93.286 L 99.500 93.300 102.264 93.718 L 105.027 94.135 107.264 93.704 L 109.500 93.272 104.500 93.286 M 124 93.232 L 120.500 93.232 122.250 93.689 L 124 94.147 125.750 93.689 L 127.500 93.232 124 93.232" fill-rule="evenodd" style="fill:';
    string private constant PART_14 = ';"/><path d="M 96.500 83.195 L 93.500 83.232 95.269 83.693 L 97.038 84.154 98.269 83.656 L 99.500 83.158 96.500 83.195 M 104.500 83.195 L 101.500 83.232 103.269 83.693 L 105.038 84.154 106.269 83.656 L 107.500 83.158 104.500 83.195 M 117.500 83.252 L 113.500 83.272 115.762 83.707 L 118.023 84.142 119.762 83.687 L 121.500 83.232 117.500 83.252 M 124.500 83.195 L 121.500 83.232 123.269 83.693 L 125.038 84.154 126.269 83.656 L 127.500 83.158 124.500 83.195" fill-rule="evenodd" style="fill:';
    string private constant PART_15 = ';"/><path d="M 164.274 88 L 162.667 88 163.362 88.696 L 164.058 89.391 165.534 89.608 L 167.010 89.824 166.446 88.912 L 165.882 88 164.274 88 M 122.500 94.195 L 119.500 94.232 121.269 94.693 L 123.038 95.154 124.269 94.656 L 125.500 94.158 122.500 94.195" fill-rule="evenodd" style="fill:';
    string private constant PART_16 = ';"/><path d="M 166.500 93.310 L 160.500 93.320 163.768 93.725 L 167.036 94.129 169.768 93.715 L 172.500 93.300 166.500 93.310" fill-rule="evenodd" style="fill:';
    string private constant PART_17 = ';"/><path d="M 135.167 84.089 L 133.333 83.108 133.333 84.554 L 133.333 86 135.167 86 L 137 86 137 85.535 L 137 85.070 135.167 84.089" fill-rule="evenodd" style="fill:';
    string private constant PART_18 = ';"/><path d="M 132.195 83.325 L 129.500 83.223 131.262 83.687 L 133.024 84.151 132.453 85.076 L 131.882 86 132.319 86 L 132.755 86 133.823 84.714 L 134.890 83.427 132.195 83.325" fill-rule="evenodd" style="fill:';
    string private constant PART_19 = ';"/><path d="M 92.500 92.195 L 89.500 92.232 91.269 92.693 L 93.038 93.154 94.269 92.656 L 95.500 92.158 92.500 92.195" fill-rule="evenodd" style="fill:';
    string private constant PART_20 = ';"/><path d="M 77.500 97.195 L 74.500 97.232 76.269 97.693 L 78.038 98.154 79.269 97.656 L 80.500 97.158 77.500 97.195 M 85.500 97.252 L 81.500 97.272 83.762 97.707 L 86.023 98.142 87.762 97.687 L 89.500 97.232 85.500 97.252 M 103.500 97.195 L 100.500 97.232 102.269 97.693 L 104.038 98.154 105.269 97.656 L 106.500 97.158 103.500 97.195" fill-rule="evenodd" style="fill:';
    string private constant PART_21 = ';"/><path d="M 133 99.232 L 129.500 99.232 131.250 99.689 L 133 100.147 134.750 99.689 L 136.500 99.232 133 99.232" fill-rule="evenodd" style="fill:';
    string private constant PART_22 = ';"/><path d="M 175 86.232 L 171.500 86.232 173.250 86.689 L 175 87.147 176.750 86.689 L 178.500 86.232 175 86.232" fill-rule="evenodd" style="fill:';
    string private constant PART_23 = ';"/>';
    string private constant COLOR_1 = 'hsl(218, 13%, 17%)';
    string private constant COLOR_2 = 'hsl(300, 1%, 35%)';
    string private constant COLOR_3 = 'hsl(330, 1%, 37%)';
    string private constant COLOR_4 = 'hsl(217, 17%, 15%)';
    string private constant COLOR_5 = 'hsl(215, 21%, 11%)';
    string private constant COLOR_6 = 'hsl(12, 3%, 39%)';
    string private constant COLOR_7 = 'hsl(216, 10%, 20%)';
    string private constant COLOR_8 = 'hsl(225, 2%, 33%)';
    string private constant COLOR_9 = 'hsl(214, 6%, 23%)';
    string private constant COLOR_10 = 'hsl(216, 16%, 13%)';
    string private constant COLOR_11 = 'hsl(228, 3%, 30%)';
    string private constant COLOR_12 = 'hsl(223, 6%, 25%)';
    string private constant COLOR_13 = 'hsl(210, 3%, 27%)';
    string private constant COLOR_14 = 'hsl(24, 4%, 49%)';
    string private constant COLOR_15 = 'hsl(30, 3%, 46%)';
    string private constant COLOR_16 = 'hsl(215, 35%, 10%)';
    string private constant COLOR_17 = 'hsl(26, 3%, 45%)';
    string private constant COLOR_18 = 'hsl(15, 2%, 42%)';
    string private constant COLOR_19 = 'hsl(30, 2%, 34%)';
    string private constant COLOR_20 = 'hsl(213, 69%, 3%)';
    string private constant COLOR_21 = 'hsl(48, 5%, 20%)';
    string private constant COLOR_22 = 'hsl(37, 10%, 55%)';

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
            PART_23
        );
        return result;
    }
}
