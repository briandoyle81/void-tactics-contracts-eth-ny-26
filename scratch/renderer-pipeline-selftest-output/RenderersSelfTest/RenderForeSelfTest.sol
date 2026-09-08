// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../IRenderer.sol";

contract RenderForeSelfTest is IRenderComponent {
    IReturnSVG public immutable render0; // RenderFore0SelfTest
    IReturnSVG public immutable render1; // RenderFore1SelfTest
    IReturnSVG public immutable render2; // RenderFore2SelfTest

    constructor(address[] memory renderers) {
        require(renderers.length == 3, "Invalid renderers array in RenderForeSelfTest");
        render0 = IReturnSVG(renderers[0]);
        render1 = IReturnSVG(renderers[1]);
        render2 = IReturnSVG(renderers[2]);
    }

    function render(Ship memory ship) external view override returns (string memory) {
        if (ship.traits.accuracy == 0) {
            return render0.render(ship);
        } else if (ship.traits.accuracy == 1) {
            return render1.render(ship);
        } else {
            return render2.render(ship);
        }
    }
}
