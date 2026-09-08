// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";
import "../Renderers/RenderUtils.sol";

contract RenderFore0SelfTest {
    string private constant PART_1 = '<path d="M57 104L49 113L38 113L37 116L22 116L15 123L15 129L17 130L17 139L19 139L18 141L23 140L24 142L20 144L13 143L9 146L9 149L13 152L20 150L22 152L29 154L34 154L40 160L42 164L67 164L67 162L74 162L84 152L84 114L82 114L77 113L76 105Z" fill-rule="evenodd" style="fill:';
    string private constant PART_2 = ';"/><path d="M57 106L56 107L56 109L60 109L60 106ZM61 106L61 109L67 109L68 112L68 106ZM70 106L69 107L71 111L70 112L73 112L73 109L75 113L75 106ZM54 110L53 112L56 112L57 110ZM39 115L35 121L34 119L22 118L19 122L18 125L24 125L25 122L25 125L29 125L29 122L33 120L33 122L30 122L30 125L32 125L31 128L30 132L33 131L36 129L41 129L43 130L41 137L44 135L44 131L45 134L50 136L52 134L49 134L49 127L60 127L59 133L59 134L53 136L59 136L63 131L61 127L64 125L60 125L60 121L64 126L64 127L72 127L72 122L70 123L70 120L72 120L73 117L73 127L76 128L77 126L80 127L79 122L81 121L80 119L83 119L77 115ZM55 117L55 122L56 119ZM68 119L64 121L66 124L69 124L67 121L69 122L69 119ZM38 120L38 124L40 123L39 121L43 120ZM47 121L44 125L44 129L48 122ZM32 128L32 131L34 130L33 128ZM50 129L51 132L57 132L57 129ZM75 129L75 133L76 130ZM37 130L36 133L36 135L40 136L39 131ZM35 131L34 134L35 135L36 131ZM69 132L71 133L72 132ZM80 132L73 134L73 139L78 140L73 140L73 147L74 144L76 145L80 143L80 132ZM29 133L30 135L31 135L31 133ZM65 134L61 139L61 141L59 140L56 143L56 145L72 145L72 134ZM19 135L19 138L21 138L20 135ZM24 136L24 138L26 139L27 138ZM46 138L44 141L37 141L40 145L55 145L55 141L48 141L52 144L47 144L48 139ZM64 138L67 140L67 142L64 142L63 140L64 144L70 144L68 139L69 138ZM57 143L59 144L60 143ZM12 144L10 148L15 148L15 144ZM22 144L16 145L16 147L22 147L22 144ZM23 145L24 147L27 147L27 145ZM33 147L35 151L39 151L37 148ZM63 148L65 149L68 148ZM69 150L71 151L72 150ZM78 153L75 155L77 155L73 157L75 158L79 153ZM73 154L65 157L65 155L64 156L66 160L66 157L72 157L73 154ZM67 161L71 162L76 161Z" fill-rule="evenodd" style="fill:';
    string private constant PART_3 = ';"/><path d="M64 106L67 109L68 109L66 106ZM57 107L59 108L60 107ZM62 107L62 109L64 109L63 107ZM70 107L70 109L73 108L73 107ZM41 115L35 120L35 121L40 117L55 117L55 115ZM56 115L56 117L59 118L72 117L72 115ZM73 115L73 117L76 117L78 120L81 120L75 115ZM65 118L65 120L67 120L66 118ZM21 119L19 123L24 123L26 120L26 120ZM33 119L27 120L25 123L29 124L29 122L35 119ZM34 121L31 123L32 124L34 121ZM49 123L45 127L46 128L50 125L58 125L59 123ZM73 125L75 126L76 125ZM32 127L30 131L33 128L38 127ZM41 127L41 128L44 129L44 127ZM51 129L54 130L57 129ZM37 130L36 133L36 135L39 135L39 133ZM64 139L65 141L67 140L67 139ZM48 141L50 142L51 141ZM11 145L13 146L16 145Z" fill-rule="evenodd" style="fill:';
    string private constant PART_4 = ';"/><path d="M41 115L41 116L46 117L49 115ZM49 115L52 116L56 115ZM56 115L60 116L64 115ZM65 115L67 116L68 115ZM69 115L69 117L72 116L72 115ZM74 115L73 117L76 117L75 115ZM39 116L35 122L40 117L40 116ZM20 121L19 123L24 123L24 122ZM28 121L25 123L29 123L28 121ZM48 123L49 125L51 125L50 123ZM55 123L52 125L57 124L58 123ZM32 127L35 128L38 127ZM51 129L53 130L54 129ZM37 131L36 132L36 135L39 135L39 132ZM48 141L50 142L51 141Z" fill-rule="evenodd" style="fill:';
    string private constant PART_5 = ';"/><path d="M37 131L36 132L36 135L39 135L39 132ZM48 141L50 142L51 141Z" fill-rule="evenodd" style="fill:';
    string private constant PART_6 = ';"/><path d="M37 131L36 132L36 135L39 135L39 132Z" fill-rule="evenodd" style="fill:';
    string private constant PART_7 = ';"/><path d="M36 134L38 135L39 134Z" fill-rule="evenodd" style="fill:';
    string private constant PART_8 = ';"/><path d="M36 134L38 135L39 134Z" fill-rule="evenodd" style="fill:';
    string private constant PART_9 = ';"/>';
    string private constant COLOR_1 = 'hsl(218, 9%, 18%)';
    string private constant COLOR_2 = 'hsl(120, 1%, 36%)';
    string private constant COLOR_3 = 'hsl(39, 7%, 53%)';
    string private constant COLOR_4 = 'hsl(42, 14%, 68%)';
    string private constant COLOR_5 = 'hsl(16, 53%, 54%)';
    string private constant COLOR_6 = 'hsl(192, 68%, 61%)';
    string private constant COLOR_7 = 'hsl(190, 39%, 85%)';
    string private constant COLOR_8 = 'hsl(196, 47%, 47%)';

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
            PART_9
        );
        return result;
    }
}
