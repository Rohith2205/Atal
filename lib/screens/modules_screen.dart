
import 'package:flutter/material.dart';
import 'resources_widgets.dart';

class ModulesScreen extends StatefulWidget {
  const ModulesScreen({super.key});

  @override
  State<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  int? _expandedLevel;

  final Map<int, List<Map<String, String>>> _levelData = {
    1: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/1lhWsHUYnU2nR9JRFmN4lW4IdKHonOBz1/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/1PEtkaLBPTCGyB2E9KA64zuQzGhkEtEiI/view?usp=sharing'},
      {'title': 'Code', 'url': 'https://docs.google.com/document/d/1AH7LY2YsRLH4fXqBzqB83SC4yfO2O2A5/edit?usp=sharing&ouid=109763324838352162584&rtpof=true&sd=true'},
      {'title': 'Materials Required', 'url': 'https://drive.google.com/file/d/1LECqzYUnryVDod-Z_HdFc8HYHRHMDPZg/view?usp=sharing'},
    ],
    2: [
      {'title': ' Components List', 'url': 'https://drive.google.com/file/d/1EVAaVar0vHse929VHVZhTWkXzfCoexYy/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/1S44iG00E4MfD-Z20hurWgBj9wf149mmF/view?usp=sharing'},
    ],
    3: [
      {'title': 'Components List exp-1', 'url': 'https://drive.google.com/file/d/1TFX9sEsm1GnD7o-TJg5IVrkyDnQmsw2Q/view?usp=sharing'},
      {'title': 'Procedure exp-1 ', 'url': 'https://drive.google.com/file/d/1URQNPUlMY1rWytX-hrbdDVuElcKQa7Iq/view?usp=sharing'},
      {'title': 'Component list exp-2', 'url': 'https://drive.google.com/file/d/1f1dxZ0J9RSvgsx5H41Iu1KPdqNJiDtwX/view?usp=sharing'},
      {'title': 'Procedure exp-2', 'url': 'https://drive.google.com/file/d/1mCbU4y5oV18WYEy_PSspd34awOx48Hnl/view?usp=sharing'},
    ],
    4: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/1LgXcjvZQk27HTCz7clEd5onrgWuyiToQ/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/1wNtyJrxPT-pWHgztBUhB-ZgKdaBVb-uH/view?usp=sharing'},
    ],
    5: [
      {'title': 'Components list exp-1', 'url': 'https://drive.google.com/file/d/1LrjMsGPi3cOVa9TdmXiMMwyASKyhXYyx/view?usp=sharing'},
      {'title': 'Procedure exp-1', 'url': 'https://drive.google.com/file/d/1TwhrbZzjyzfV4fS0v7rgprnN1lCouT5U/view?usp=sharing'},
      {'title': 'Component list exp-2', 'url': 'https://drive.google.com/file/d/1wbw-kOrxqqpkS3rd1zKl1uITJPP0JNWl/view?usp=sharing'},
      {'title': 'Procedure exp-2', 'url': 'https://drive.google.com/file/d/1sW7cvFNSh_6_ul84M155GxUfUAuVgSej/view?usp=sharing'},
    ],
    6: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/1RmV0UQBFjBQ66tpLq8Bj9TPgbiBp91GW/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/1eO2iFOfysiSIrAsGKL9oRMMZKKAn1pbi/view?usp=sharing'},
    ],
    7: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/1lxwvIRgyxolNCXNaCh9WefUG4wtv1zLx/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/1_jLBdzzgucWdJp1cndj1EE_uPC5MV8zL/view?usp=sharing'},
    ],
    8: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/1m0cA9lXcCDjqiNiBCn-dd290IzaLTkOH/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/1o3IwZTfcsIzjTfe9PuvmCBG0ed-JPFdb/view?usp=sharing'},
    ],
    9: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/1N97aNW7g28lBAJQrkuQFYoLgU0br2LaP/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/1OeEhooTgpYh_KHj42zUU7jhDHXxWyVh_/view?usp=sharing'},
    ],
    10: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/1nnkSgZkMBJ7R4B2mNq1b0iciIS_6CyO4/view?usp=sharing'},
      {'title': 'Procedure part -1', 'url': 'https://drive.google.com/file/d/1D4_McvOv3aYpL763uGp0c01foGuExhpx/view?usp=sharing'},
      {'title': 'Procedure part -2', 'url': 'https://drive.google.com/file/d/17zoOVWjN6d6W116MhQs3ZXMky15d2eWI/view?usp=sharing'},
      {'title': 'Papertronics', 'url': 'https://docs.google.com/presentation/d/1aIgaZHJzC7f79Bybh9V_8naSqbBxODUY/edit?usp=sharing&ouid=109763324838352162584&rtpof=true&sd=true'},
    ],
    11: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/1NypEjyAi7zAa_yRKCKFxdOYkqAQfpnIq/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/1P1GF2XtVd2CThtzYkRPIJumeBMY27PnU/view?usp=sharing'},
    ],
    12: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/16cdEYY9ZpzbW9JTYcXmgG2hmHxRmo1TV/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/1jdyZpctTZAr3GHlHaD65hdQojFOpt8Cx/view?usp=sharing'},
    ],
    13: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/150ZIchb0LtR6hTBcb6UYtvrDrn6ze7Kn/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/113wsvQ6OruPFq4GFYvtdC_pbytJdHB2U/view?usp=sharing'},
    ],
    14: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/17yH25mhFP_36FQYGWOZ-vA3eqD68Xwdk/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/13wTdft9VypLZiVFgXA15rt83CLx0nmOl/view?usp=sharing'},
    ],
    15: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/1pjEPjQiORpqgetTIJQtsa1TQGuKa3Pxb/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/1XrvoTeER8stSVlH4RBv-tBo5VgUJME_i/view?usp=sharing'},
    ],
    16: [
      {'title': 'Components lis', 'url': 'https://drive.google.com/file/d/1dOrlv9knwiifvJDvd6lcdksv2bvfIXGc/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/1Nc4yyivOr02tSR_1vniYvE9qrOjLRmhz/view?usp=sharing'},
    ],
    17: [
      {'title': 'Components list exp-1', 'url': 'https://drive.google.com/file/d/18x3ymt_AvXRGFP21zPStbO_F98RQXHMH/view?usp=sharing'},
      {'title': 'Procedure exp-1', 'url': 'https://drive.google.com/file/d/1uZ8fkchsau61uDH71B5ANFX2culiLkwo/view?usp=sharing'},
      {'title': 'Procedure exp-2', 'url': 'https://drive.google.com/file/d/1yfv8_1-exfGa1RQUFIfe3UydyZrDMk1T/view?usp=sharing'},
    ],
    18: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/1GWrZhYcZCnb0OInhxB9jdLKHxEGmeT5E/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/19xXhBthe_86TxyE-iSNg2q29OipBWpQ3/view?usp=sharing'},
    ],
    19: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/1yK6EJPXXapaP5n7wJNsmUJooJPwvGrc_/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/1D5X5Dgte9FqL9GUacPbcb8KTG-SyW2OV/view?usp=sharing'},
    ],
    20: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/1fkEOOLc-RTA0HtULtBUoV9cwXVBVvX6W/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/19N_x45EI2qh-zTeHo8ji3ebTO0629i0w/view?usp=sharing'},
    ],
    21: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/1pzdQKgw8yot1eeZFmtLhsjbYc4iErSOn/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/1yUtbjcBVXQBdjo5khx-5JjXOvRFiWMwa/view?usp=sharing'},
    ],
    22: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/1bugIzN45Egh0Nw0s4ScF8-I1eJ3x_45v/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/10gF-owuDydpE-XgaboQpzJO3ajDjEfPO/view?usp=sharing'},
    ],
    23: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/11sru1B6Afp13XLyUt1GqackdTSqqaygf/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/1AMRMVaL4yzzYPhyLEfQC4LzXv5JRZOEC/view?usp=sharing'},
    ],
    24: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/1RvRvqY1aUkwiMc6Sc2q4900D0cQieRHS/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/1dO3bvd-KShUmguqjbvL7IB0AL740ttL1/view?usp=sharing'},
    ],
    25: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/1PHVk7MeuCy1ZQjd8W61uLsDX54Zr07EE/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/1-1x4alqARAasgJ0j1SAkJaxgyIGBWz8-/view?usp=sharing'},
    ],
    26: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/11EHx1tbY9NwJkh_9TtFHJxN8HEgsLwD0/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/1UrdI-HUbYv72k6pSQdd8bmZn7loUoU-2/view?usp=sharing'},
    ],
    27: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/1xJdXV1eAmGFbfhyxxe6tzqxUAa1bAt1g/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/1cgC5dTAjvsCQ5b60KRq1fWwFeQHsK_6h/view?usp=sharing'},
    ],
    28: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/1u0avPkSB7r7svgbmRSPAbi2vwbO99fxT/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/1A__qbiPueMHnTmzkzaA2isrM5u8goDt8/view?usp=sharing'},
    ],
    29: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/1Ah1FREwLuK8AJ-hQBe_010-_ijvOuTp-/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/1UgyBgXDFj9dbfM8MQUIXYj_qyK8fqi9m/view?usp=sharing'},
    ],
    30: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/1Hp8_mg638aeEOpzCqMmp1S9Ub-n7eQtV/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/1uPNhNrKpgpqk4HVoRT2k92FMElExQf78/view?usp=sharing'},
    ],
    31: [
      {'title': 'Components list', 'url': 'https://drive.google.com/file/d/1-f3zRBXRZSFqrAG0i5SnemxDMJV5sGX_/view?usp=sharing'},
      {'title': 'Procedure', 'url': 'https://drive.google.com/file/d/1p_NN3LHohLxn0usotMm4nEhWAJrWuD7_/view?usp=sharing'},
    ],
  };

  // Custom level titles - you can modify these as needed
  final Map<int, String> _levelTitles = {
    1: 'Module 1',
    2: 'Module 2',
    3: 'Module 3',
    4: 'Module 4',
    5: 'Module 5',
    6: 'Module 6',
    7: 'Module 7',
    8: 'Module 8',
    9: 'Module 9',
    10: 'Module 10',
    11: 'Module 11',
    12: 'Module 12',
    13: 'Module 13',
    14: 'Module 14',
    15: 'Module 15',
    16: 'Module 16',
    17: 'Module 17',
    18: 'Module 18',
    19: 'Module 19',
    20: 'Module 20',
    21: 'Module 21',
    22: 'Module 22',
    23: 'Module 23',
    24: 'Module 24',
    25: 'Module 25',
    26: 'Module 26',
    27: 'Module 27',
    28: 'Module 28',
    29: 'Module 29',
    30: 'Module 30',
    31: 'Module 31',
  };

  void _toggleLevel(int level) {
    setState(() {
      _expandedLevel = _expandedLevel == level ? null : level;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Resources',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: [
          const SizedBox(height: 20),
          Center(
            child: Image.asset(
              'assets/images/resources.jpg',
              width: 250,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 30),
          for (int level = 1; level <= 31; level++) ...[
            // Using separated level button widget with custom title
            ATLWidgets.buildLevelButton(
              title: _levelTitles[level] ?? 'Level $level',
              isExpanded: _expandedLevel == level,
              onPressed: () => _toggleLevel(level),
            ),

            // Using separated sub-level buttons widget
            if (_expandedLevel == level)
              ...ATLWidgets.buildSubLevelButtons(
                subLevels: _levelData[level] ?? [],
                onSubLevelPressed: (url) => ATLWidgets.launchURL(url, context),
              ),

            SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}