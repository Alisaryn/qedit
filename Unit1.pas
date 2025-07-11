unit Unit1;

interface

uses Types, SysUtils, main, dialogs;

Type
  TRef = Record
    offset: dword;
  end;

const
  npcid: array [0 .. 29] of word = (1, 2, 3, 4, 5, 6, 7, 8, 9, $A, $B, $C, $D, $E, $1A, $1B, $1C, $1D, $1E, $1F, $19,
    $20, $F7, $F9, $FA, $FB, $FC, $FE, 256, 0);

  MonsterPosZ: array [1 .. 111] of integer = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 20, 20, 0, 20, 0, 0, 0, 0, 0, 0, 20, 20, 25, 0, 0, 0, 30, 0, 10, 0, 0, 0, 0, 0, 0, 0, 20, 25, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 30, 30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

  MapFloorId: array [0 .. 45] of integer = (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 0, 1, 2, 3, 4,
    5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0);

  MonsterFile: array [1 .. 128] of ansistring = ('Hildebear', // 1
    'Hildeblue', 'Mothmant', 'Mothest', 'Rappy', 'alRappy', 'SavageWolf', 'BarbarousWolf', 'Boomas', // 9
    'Gobooma', 'Gigobooma', 'Grass', 'lily', // 13
    'Narlily', 'NanoDragon', // 15
    'Shark', 'shark2', 'Shark3', 'Slime', // 19
    'Slimerare', 'PanArms', // 21
    'Migium', 'Hidoom', 'Dubchic', // 24
    'Garanz', 'SinowBlue', 'SinowGold', 'Canadine', // 28
    'Canane', 'Delsaber', 'Sorc', // 31
    'BeeR', 'BeeL', 'Gunner', 'Gunner', 'Bringer', // 36
    'Belra', 'Claw', 'Bulk', 'Bulclaw', // 40
    'Demenian', 'LaDemenian', 'SoDemenian', 'ep1_Dragon', // 44
    'Ep1_DeRolLe', 'VolOpt', 'Falz', 'Container', 'Dubwitch',
    /// ///////////  49
    'Gilchic', 'Loverappy', 'Merilia', 'Meritas', 'Gee', // 54
    'gigue', 'Mericarol', 'Merikle', 'Mericus', 'gibon', // 59
    'Zolgibon', 'Gibbles', 'Berill', 'Spigell', 'Dolmolm', // 64
    'Dolmdarl', 'Morfos', 'Recobox', 'Recon', // 68
    'Zoa', 'Zele', 'Deldeph', 'Delbiter', // 72
    'BarbaRay', 'PigRay', 'UlRay', 'ep2_dragon', 'Gal', 'Olga', 'santaRappy', 'HallowRappy', 'EggRappy', 'IllGill',
    'DelLily', // 83
    'Epsilon', 'Gael', 'Giel', 'Epsigard', 'Astark', 'Yowie', // 15
    's_lizard', // 14
    'MerissaA', 'MerissaAA', 'Girt', 'Zu', // 8
    'Pazuzu', // 9
    'Boota', 'Ze_boota', 'Ba_boota', 'Dolphon', 'dolphon_e', 'golan', 'golan_p', 'golan_d', 'Sandlappy', // 6
    'Delrappy', // 7
    'Saint', 'saint2', 'saint3', 'VolOpt', 'Rappy', 'Unknown', 'crash', // 112
    '..\obj\145', // 113 forest box
    'chao', // 114
    'MiniHidle', // 115
    '..\obj\135-1', // 116
    '..\obj\135-0', // 117
    'minigrass', // 118
    '..\obj\262', // 119
    '..\obj\339', // 120
    '..\obj\338', // 121
    '..\obj\688', // 122
    '..\obj\518', // 123
    '..\obj\521', // 124
    '..\obj\floor28\136', // 125
    'Deldeph2', // 126
    '..\obj\551', // 127
    'nights' // 128
    );

  MonsterName: array [1 .. 111] of ansistring = ('Hildebear', 'Hildeblue', 'Mothmant', 'Monest', 'Rag Rappy',
    'Al Rappy', 'Savage Wolf', 'Barbarous Wolf', 'Booma', 'Gobooma', 'Gigobooma', 'Grass Assassin', 'Poison Lily',
    'Nar Lily', 'Nano Dragon', 'Evil Shark', 'Pal Shark', 'Guil Shark', 'Pofuilly Slime', 'Pouilly Slime', 'Pan Arms',
    'Migium', 'Hidoom', 'Dubchic', 'Garanz', 'Sinow Beat', 'Sinow Gold', 'Canadine', 'Canane', 'Delsaber',
    'Chaos Sorcerer', 'Bee R', 'Bee L', 'Dark Gunner', 'Death Gunner', 'Chaos Bringer', 'Dark Belra', 'Claw', 'Bulk',
    'Bulclaw', 'Dimenian', 'La Dimenian', 'So Dimenian', 'Dragon', 'De Rol Le', 'Vol Opt', 'Dark Falz', 'Container',
    'Dubswitch', 'Gilchic', 'Love Rappy', 'Merillia', 'Meriltas', 'Gee', 'Gi Gue', 'Mericarol', 'Merikle', 'Mericus',
    'Ul Gibbon', 'Zol Gibbon', 'Gibbles', 'Sinow Berill', 'Sinow Spigell', 'Dolmolm', 'Dolmdarl', 'Morfos', 'Recobox',
    'Recon', 'Sinow Zoa', 'Sinow Zele', 'Deldepth', 'Delbiter', 'Barba Ray', 'Pig Ray', 'Ul Ray', 'Gol Dragon',
    'Gal Gryphon', 'Olga Flow', 'Saint Rappy', 'Hallo Rappy', 'Egg Rappy', 'Ill Gill', 'Del Lily', 'Epsilon', 'Gael',
    'Giel', 'Epsigard', 'Astark', 'Yowie', // 15
    'Satellite Lizard', // 14
    'Merissa A', 'Merissa AA', 'Girtablulu', 'Zu', // 8
    'Pazuzu', // 9
    'Boota', 'Ze Boota', 'Ba Boota', 'Dorphon', 'Dorphon Eclair', 'Goran', 'Goran Detonator', 'Pyro Goran',
    'Sand Rappy', // 6
    'Del Rappy', // 7
    'Saint Million', 'Shambertin', 'Kondrieu', 'Vol Opt Part A', 'NPC Rappy', 'Unknown');
  MapID: array [0 .. 45] of integer = (0, 1, 2, 3, 9, 15, 21, 27, 33, 38, 43, 48, 49, 50, 51, 52, 67, 70 // ep1 0-17
    , 73, 80, 83, 74, 77, 86, 87, 88, 89, 92, 93, 96, 99, 100, 101, 102, 103, 104 // ep2 18 -  35
    , 109, 110, 111, 112, 113, 114, 117, 118, 121, 122 // ep4 36 - 44
    );
  EPMap: array [0 .. 2] of integer = (0, 18, 36);
  MapFileName: array [0 .. 122] of ansistring = ('map_city00_00c.rel', 'map_forest01c.rel', 'map_forest02c.rel',
    'map_cave01_00c.rel', 'map_cave01_01c.rel', 'map_cave01_02c.rel', 'map_cave01_03c.rel', 'map_cave01_04c.rel',
    'map_cave01_05c.rel', 'map_cave02_00c.rel', 'map_cave02_01c.rel', 'map_cave02_02c.rel', 'map_cave02_03c.rel',
    'map_cave02_04c.rel', 'map_cave02_05c.rel', 'map_cave03_00c.rel', 'map_cave03_01c.rel', 'map_cave03_02c.rel',
    'map_cave03_03c.rel', 'map_cave03_04c.rel', 'map_cave03_05c.rel', 'map_machine01_00c.rel', 'map_machine01_01c.rel',
    'map_machine01_02c.rel', 'map_machine01_03c.rel', 'map_machine01_04c.rel', 'map_machine01_05c.rel',
    'map_machine02_00c.rel', 'map_machine02_01c.rel', 'map_machine02_02c.rel', 'map_machine02_03c.rel',
    'map_machine02_04c.rel', 'map_machine02_05c.rel', 'map_ancient01_00c.rel', 'map_ancient01_01c.rel',
    'map_ancient01_02c.rel', 'map_ancient01_03c.rel', 'map_ancient01_04c.rel', 'map_ancient02_00c.rel',
    'map_ancient02_01c.rel', 'map_ancient02_02c.rel', 'map_ancient02_03c.rel', 'map_ancient02_04c.rel',
    'map_ancient03_00c.rel', 'map_ancient03_01c.rel', 'map_ancient03_02c.rel', 'map_ancient03_03c.rel',
    'map_ancient03_04c.rel', 'map_boss01c.rel', 'map_boss02c.rel', 'map_boss03c.rel', 'map_darkfalz00c.rel',
    'map_lobby_00c.rel', 'map_lobby_00c.rel', 'map_lobby_00c.rel', 'map_lobby_00c.rel', 'map_lobby_00c.rel',
    'map_lobby_00c.rel', 'map_lobby_00c.rel', 'map_lobby_00c.rel', 'map_lobby_00c.rel', 'map_lobby_00c.rel',
    'map_lobby_green_be00c.rel', 'map_lobby_red_be00c.rel', 'map_lobby_yellow_be00c.rel', 'map_soccer11c.rel',
    'map_soccer11c.rel', 'map_vs01_00c.rel', 'map_vs01_01c.rel', 'map_vs01_02c.rel', 'map_vs02_00c.rel',
    'map_vs02_01c.rel', 'map_vs02_02c.rel', // episode 2
    'map_labo00_00c.rel', // 73
    'map_space01_00c.rel', // 74
    'map_space01_01c.rel', 'map_space01_02c.rel', 'map_space02_00c.rel', // 77
    'map_space02_01c.rel', 'map_space02_02c.rel', 'map_ruins01_00c.rel', // 80
    'map_ruins01_01c.rel', 'map_ruins01_02c.rel', 'map_ruins02_00c.rel', // 83
    'map_ruins02_01c.rel', 'map_ruins02_02c.rel', 'map_jungle01_00c.rel', // 86
    'map_jungle02_00c.rel', // 87
    'map_jungle03_00c.rel', // 88
    'map_jungle04_00c.rel', // 89
    'map_jungle04_01c.rel', 'map_jungle04_02c.rel', 'map_jungle05_00c.rel', // 92

    'map_seabed01_00c.rel', // 93
    'map_seabed01_01c.rel', 'map_seabed01_02c.rel', 'map_seabed02_00c.rel', // 96
    'map_seabed02_01c.rel', 'map_seabed02_02c.rel', 'map_boss05c.rel', // 99
    'map_boss06c.rel', // 100
    'map_boss07c.rel', // 101
    'map_boss08c.rel', // 102

    'map_jungle06_00c.rel', // 103
    'map_jungle07_00c.rel', // 104
    'map_jungle07_01c.rel', 'map_jungle07_02c.rel', 'map_jungle07_03c.rel', 'map_jungle07_04c.rel',

    // episode 4
    'map_wilds01_00c.rel', 'map_wilds01_01c.rel', 'map_wilds01_02c.rel', 'map_wilds01_03c.rel', 'map_crater01_00c.rel',
    'map_desert01_00c.rel', 'map_desert01_01c.rel', 'map_desert01_02c.rel', 'map_desert02_00c.rel',
    'map_desert03_00c.rel', 'map_desert03_01c.rel', 'map_desert03_02c.rel', 'map_boss09_00c.rel', 'map_city02_00c.rel');
  // 60 et 62

  MapXvmName: array [0 .. 122] of ansistring = ('map_city00.xvm', 'map_forest01.xvm', 'map_forest02.xvm',
    'map_cave01.xvm', 'map_cave01.xvm', 'map_cave01.xvm', 'map_cave01.xvm', 'map_cave01.xvm', 'map_cave01.xvm',
    'map_cave02.xvm', 'map_cave02.xvm', 'map_cave02.xvm', 'map_cave02.xvm', 'map_cave02.xvm', 'map_cave02.xvm',
    'map_cave03.xvm', 'map_cave03.xvm', 'map_cave03.xvm', 'map_cave03.xvm', 'map_cave03.xvm', 'map_cave03.xvm',
    'map_machine01.xvm', 'map_machine01.xvm', 'map_machine01.xvm', 'map_machine01.xvm', 'map_machine01.xvm',
    'map_machine01.xvm', 'map_machine02.xvm', 'map_machine02.xvm', 'map_machine02.xvm', 'map_machine02.xvm',
    'map_machine02.xvm', 'map_machine02.xvm', 'map_ancient01.xvm', 'map_ancient01.xvm', 'map_ancient01.xvm',
    'map_ancient01.xvm', 'map_ancient01.xvm', 'map_ancient02.xvm', 'map_ancient02.xvm', 'map_ancient02.xvm',
    'map_ancient02.xvm', 'map_ancient02.xvm', 'map_ancient03.xvm', 'map_ancient03.xvm', 'map_ancient03.xvm',
    'map_ancient03.xvm', 'map_ancient03.xvm', 'map_boss01.xvm', 'map_boss02.xvm', 'map_boss03.xvm',
    'map_darkfalz00.xvm', 'map_lobby_01.xvm', 'map_lobby_01.xvm', 'map_lobby_01.xvm', 'map_lobby_01.xvm',
    'map_lobby_01.xvm', 'map_lobby_01.xvm', 'map_lobby_01.xvm', 'map_lobby_01.xvm', 'map_lobby_01.xvm',
    'map_lobby_01.xvm', 'map_lobby_green_be00.xvm', 'map_lobby_red_be00.xvm', 'map_lobby_yellow_be00.xvm',
    'map_soccer11.xvm', 'map_soccer11.xvm', 'map_vs01.xvm', 'map_vs01.xvm', 'map_vs01.xvm', 'map_vs02.xvm',
    'map_vs02.xvm', 'map_vs02.xvm', // episode 2
    'map_labo00.xvm', // 73
     'map_space01.xvm', // 74
    'map_space01.xvm', 'map_space01.xvm', 'map_space02.xvm', // 77
    'map_space02.xvm', 'map_space02.xvm', 'map_ruins01.xvm', // 80
    'map_ruins01.xvm', 'map_ruins01.xvm', 'map_ruins02.xvm', // 83
    'map_ruins02.xvm', 'map_ruins02.xvm', 'map_jungle01.xvm', // 86
    'map_jungle02.xvm', // 87
    'map_jungle03.xvm', // 88
    'map_jungle04.xvm', // 89
    'map_jungle04.xvm', 'map_jungle04.xvm', 'map_jungle05.xvm', // 92

    'map_seabed01.xvm', // 93
    'map_seabed01.xvm', 'map_seabed01.xvm', 'map_seabed02.xvm', // 96
    'map_seabed02.xvm', 'map_seabed02.xvm', 'map_boss05.xvm', // 99
    'map_boss06.xvm', // 100
    'map_boss07.xvm', // 101
    'map_boss08.xvm', // 102

    'map_jungle06.xvm', // 103
    'map_jungle07.xvm', // 104
    'map_jungle07.xvm', 'map_jungle07.xvm', 'map_jungle07.xvm', 'map_jungle07.xvm',

    // episode 4
    'map_wilds01.xvm', 'map_wilds01.xvm', 'map_wilds01.xvm', 'map_wilds01.xvm', 'map_crater01.xvm', 'map_desert01.xvm',
    'map_desert01.xvm', 'map_desert01.xvm', 'map_desert02.xvm', 'map_desert03.xvm', 'map_desert03.xvm',
    'map_desert03.xvm', 'map_boss09.xvm', 'map_city02.xvm'); // 60 et 62

  MapName: array [0 .. 122] of ansistring = ('Pioneer 2', 'Forest 1', 'Forest 2', 'Cave 1 - map 1', 'Cave 1 - map 2',
    'Cave 1 - map 3', 'Cave 1 - map 4', 'Cave 1 - map 5', 'Cave 1 - map 6', 'Cave 2 - map 1', 'Cave 2 - map 2',
    'Cave 2 - map 3', 'Cave 2 - map 4', 'Cave 2 - map 5', 'Cave 2 - map 6', 'Cave 3 - map 1', 'Cave 3 - map 2',
    'Cave 3 - map 3', 'Cave 3 - map 4', 'Cave 3 - map 5', 'Cave 3 - map 6', 'Mine 1 - map 1', 'Mine 1 - map 2',
    'Mine 1 - map 3', 'Mine 1 - map 4', 'Mine 1 - map 5', 'Mine 1 - map 6', 'Mine 2 - map 1', 'Mine 2 - map 2',
    'Mine 2 - map 3', 'Mine 2 - map 4', 'Mine 2 - map 5', 'Mine 2 - map 6', 'Ruins 1 - map 1', 'Ruins 1 - map 2',
    'Ruins 1 - map 3', 'Ruins 1 - map 4', 'Ruins 1 - map 5', 'Ruins 2 - map 1', 'Ruins 2 - map 2', 'Ruins 2 - map 3',
    'Ruins 2 - map 4', 'Ruins 2 - map 5', 'Ruins 3 - map 1', 'Ruins 3 - map 2', 'Ruins 3 - map 3', 'Ruins 3 - map 4',
    'Ruins 3 - map 5', 'Dragon', 'De Rol', 'Vol Opt', 'Falz', 'Lobby 1', 'Looby 2', 'Looby 3', 'Looby 4', 'Looby 5',
    'Looby 6', 'Looby 7', 'Looby 8', 'Looby 9', 'Looby 10', 'Soccer Looby 11', 'Soccer Looby 12', 'Soccer Looby 13',
    'Soccer Looby 14', 'Soccer Looby 15', 'BA: Space ship - map 1', 'BA: Space ship - map 2', 'BA: Space ship - map 3',
    'BA: Palace - map 1', 'BA: Palace - map 2', 'BA: Palace - map 3',
    // episode 2
    'Labo', // 73
    'Space Ship alpha - map 1', // 74
    'Space Ship alpha - map 2', 'Space Ship alpha - map 3', 'Space Ship beta - map 1', // 77
    'Space Ship beta - map 2', 'Space Ship beta - map 3', 'Temple alpha - map 1', // 80
    'Temple alpha - map 2', 'Temple alpha - map 3', 'Temple beta - map 1', // 83
    'Temple beta - map 2', 'Temple beta - map 3', 'CCA', // 86
    'Jungle north', // 88
    'Jungle east', // 87

    'Mountains - map 1', // 89
    'Mountains - map 2', 'Mountains - map 3', 'Seaside', // 92
    'Seabed upper - map 1', // 99
    'Seabed upper - map 2', 'Seabed upper - map 3', 'Seabed lower - map 1', // 102
    'Seabed lower - map 2', 'Seabed lower - map 3', 'Gal Gryphon', // 105
    'Olga Flow', // 106
    'Barba ray', // 107
    'Gol dragon', // 108
    'Seaside night', // 93
    'Tower - map 1', // 94
    'Tower - map 2', 'Tower - map 3', 'Tower - map 4', 'Tower - map 5',
    // episode 4
    'Wilds - map 1', 'Wilds - map 2', 'Wilds - map 3', 'Wilds - map 4', 'Crater', 'Desert 1 - map 1',
    'Desert 1 - map 2', 'Desert 1 - map 3', 'Desert 2 - map 1', 'Desert 3 - map 1', 'Desert 3 - map 2',
    'Desert 3 - map 3', 'EP4 Boss', 'EP4 Pioneer 2'); // 60 et 62

  MapSkyDome: array [0 .. $2D] of ansistring = ('', 'Forest1.png', 'Forest2.png', '', '', '', '', '', '',
    'ruins02VS2.png', '', '', '', '', '', '', 'space02boss8.png', 'ruins02VS2.png',
    // episode 2
    '', // 73
    'space01VS1.png', // 80
    'ruins02VS2.png', // 83
    'space01VS1.png', // 74
    'space02boss8.png', // 77
    'jungle01.png', // 86
    'jungle02.png', // 87
    'jungle03.png', // 88
    'jungle04.png', // 89
    'jungle05.png', // 92
    'seabed01.png', // 99
    'seabed02.png', // 102
    'boss5.png', // 105
    '', // 106
    '', // 107
    'space02boss8.png', // 108
    'jungle06.png', // 93
    '', // 94
    // episode 4
    'craterwild.png', 'craterwild.png', 'craterwild.png', 'craterwild.png', 'craterwild.png', '', '', '', '', '');
  // 60 et 62

  MapArea: array [0 .. 122] of integer = (0, 1, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6,
    6, 7, 7, 7, 7, 7, 7, 8, 8, 8, 8, 8, 9, 9, 9, 9, 9, 10, 10, 10, 10, 10, 11, 12, 13, 14, 15, // lobby
    15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 16, 17, 17, 17,
    // episode 2
    18, // 73                   //ep2 start
    19, // 80
    19, 19, 20, // 83
    20, 20, 21, // 74
    21, 21, 22, // 77
    22, 22, 23, // 86
    24, // 87
    25, // 88
    26, // 89
    26, 26, 27, // 92
    28, // 99
    28, 28, 29, // 102
    29, 29, 30, // 105
    31, // 106
    32, // 107
    33, // 108
    34, // 93
    35, // 94
    35, 35, 35, 35,
    // episode 4
    36, 37, 38, 39, 40, 41, 41, 41, 42, 43, 43, 43, 44, 45); // 60 et 62

  T_NONE = 0;
  T_IMED = 1;
  T_ARGS = 2;
  T_PUSH = 3;
  T_VASTART = 4;
  T_VAEND = 5;
  T_DC = 6;

  T_REG = 7;
  T_BYTE = 8;
  T_WORD = 9;
  T_DWORD = 10;
  T_FLOAT = 11;
  T_STR = 12;

  T_RREG = 13;
  T_FUNC = 14;
  T_FUNC2 = 15;
  T_SWITCH = 16;
  T_SWITCH2B = 17;
  T_PFLAG = 18;
  T_SWITCHZ = 21;

  T_STRDATA = 19;
  T_DATA = 20;
  T_BREG = 21;
  T_DREG = 22;
  T_HEX = 23;
  T_STRHEX = 24;

Function QuestDisam(code: pansichar; ref: array of dword; CodeLength, RefCount: integer): boolean;
Function QuestBuild(code: pansichar): dword;
function MakeUni(s: ansistring): ansistring;
function GenerateMonsterName(m: TMonster; x, fl: integer): ansistring;

implementation

uses FScrypt, D3DEngin, ComCtrls, Classes, MyConst;

function MakeUni(s: ansistring): ansistring;
var
  x: integer;
begin
  result := '';
  for x := 1 to length(s) do
    result := result + s[x] + #0;

end;

Function QuestDisam(code: pansichar; ref: array of dword; CodeLength, RefCount: integer): boolean;
var
  x, y, v, i, px, dlength, ll: integer;
  s, b: ansistring;
  z, r60, r62, lr: dword;
  m: single;
  p: pansichar;
  StackP, stackb: integer;
  Stack: array [0 .. 400] of TPSOStack;
  inva: boolean;

begin
  // init the treeview
  form4.TreeView1.Items.Clear;
  TrFnc := form4.TreeView1.Items.Add(form4.TreeView1.Items.GetFirstNode, 'Function');
  TrData := form4.TreeView1.Items.Add(form4.TreeView1.Items.GetFirstNode, 'Data/Str');
  TrReg := form4.TreeView1.Items.Add(form4.TreeView1.Items.GetFirstNode, 'Register');
  Tropc := form4.TreeView1.Items.Add(form4.TreeView1.Items.GetFirstNode, 'Opcode');
  TrData.Text := getlanguagestring(133);
  TrFnc.Text := getlanguagestring(132);
  TrReg.Text := getlanguagestring(134);
  Tropc.Text := getlanguagestring(135);
  TrFnc.ImageIndex := 2;
  TrFnc.SelectedIndex := 2;
  TrData.ImageIndex := 2;
  TrData.SelectedIndex := 2;
  TrReg.ImageIndex := 2;
  TrReg.SelectedIndex := 2;
  Tropc.ImageIndex := 2;
  Tropc.SelectedIndex := 2;
  TsData.Clear;
  TsFnc.Clear;
  TsReg.Clear;
  Tsopc.Clear;
  fillchar(regis[0], sizeof(regis), 0);

  x := 0;
  // AsmMode:=0;
  StackP := 0;
  inva := false;
  form4.ListBox1.Items.Clear;
  while x < CodeLength do
  begin
    if (length(s) <> 16) or (AsmMode = 0) then
    begin
      s := '';
      dlength := 0;
      for y := 0 to RefCount - 1 do
        if ref[y] = x then
        begin

          if (((code[x + $18] = #$ff) and (code[x + $19] = #$ff)) or ((code[x + $18] = #$35) and (code[x + $19] = #$ae))
            ) and (code[x + $1A] = #$ff) and (code[x + $1B] = #$ff) then
          begin
            v := $FFFFFFF;
            for i := 0 to RefCount - 1 do
              if (ref[i] < v) and (ref[i] > x) then
                v := ref[i];
            v := v - x;
            if (v = 84) or (v = 120) then
            begin
              for i := 0 to 999 do
                if datablock[i] = -1 then
                  break;
              datablock[i] := y;
            end;
          end;
          for i := 0 to 999 do
          begin
            if datablock[i] = y then
            begin
              dlength := $FFFFFFF;
              for z := 0 to RefCount - 1 do
                if (ref[z] > x) and (ref[z] < dlength) then
                  dlength := ref[z];
              if dlength = $FFFFFFF then
                dlength := CodeLength;
              dlength := dlength - x;
              ll := datablockT[i];
              if datablockT[i] = T_STRDATA then
              begin
                if TsData.IndexOf('S_' + inttostr(y)) = -1 then
                begin
                  TsData.Add('S_' + inttostr(y));
                  TrTmp := form4.TreeView1.Items.AddChild(TrData, 'S_' + inttostr(y));
                  TrTmp.ImageIndex := 3;
                  TrTmp.SelectedIndex := 3;
                end;
              end
              else
              begin
                if TsData.IndexOf('D_' + inttostr(y)) = -1 then
                begin
                  TsData.Add('D_' + inttostr(y));
                  TrTmp := form4.TreeView1.Items.AddChild(TrData, 'D_' + inttostr(y));
                  TrTmp.SelectedIndex := 4;
                  TrTmp.ImageIndex := 4;
                end;
              end;
            end;
          end;
          if s <> '' then
          begin
            while length(s) < 16 do
              s := s + MakeUni(' ');
            // s:=s+makeuni('nop');
            s := s + #0#0;
            form4.ListBox1.Items.Add(pwidechar(@s[1]));
          end;
          if dlength = 0 then
            if TsFnc.IndexOf('F_' + inttostr(y)) = -1 then
            begin
              TsFnc.Add('F_' + inttostr(y));
              TrTmp := form4.TreeView1.Items.AddChild(TrFnc, 'F_' + inttostr(y));
              TrTmp.ImageIndex := 1;
              TrTmp.SelectedIndex := 1;
            end;
          s := MakeUni(inttostr(y) + ':');
          if y = 0 then
            s := MakeUni(inttostr(y) + ':');
        end;
      // if y < refcount then s:=inttostr(y)+':';
      px := x;
    end;
    while length(s) < 16 do
      s := s + MakeUni(' ');

    if dlength <= 0 then
    begin
      z := byte(code[x]);
      inc(x);
      // s:=MakeUni(s);
      // special 16 bit function
      if (z = $F8) or (z = $F9) then
      begin
        z := (z * 256) + byte(code[x]);
        inc(x);
      end;

      for y := 0 to asmcount - 1 do
        if AsmCode[y].fnc = z then
        begin
          if (AsmCode[y].order = T_DC) and (AsmMode <> 2) then
            break;
          if (AsmCode[y].order <> T_DC) then
            break;
        end;
      if y < asmcount then
      begin
        if Tsopc.IndexOf(AsmCode[y].name) = -1 then
        begin
          Tsopc.Add(AsmCode[y].name);
          TrTmp := form4.TreeView1.Items.AddChild(Tropc, AsmCode[y].name);
          TrTmp.ImageIndex := 5;
          TrTmp.SelectedIndex := 5;
        end;

        if (z >= $48) and (z <= $4E) and (not inva) then
        begin
          AsmMode := 2;
          // stackb:=0;
          Stack[StackP].DataType := z - $48;
          if (z = $48) or (z = $4A) then
          begin
            Stack[StackP].value := byte(code[x]);
            // if z= $48 then s:=s+'R'+inttostr(Stack[StackP].value)
            // else s:=s+inttohex(Stack[StackP].value,2);
            inc(x);
          end;
          if (z = $49) then
          begin
            Stack[StackP].value := byte(code[x]) + (byte(code[x + 1]) * 256) + (byte(code[x + 2]) * $10000) +
              (byte(code[x + 3]) * $1000000);
            x := x + 4;
            // s:=s+inttohex(Stack[StackP].value,8);
          end;
          if (z = $4B) then
          begin
            Stack[StackP].value := byte(code[x]) + (byte(code[x + 1]) * 256);
            x := x + 2;
            // s:=s+inttohex(Stack[StackP].value,4);
          end;
          if (z = $4E) then
          begin
            Stack[StackP].str := '';
            { while ((code[x] <> #0) and isdc) or (not isdc and ((code[x] <> #0)or(code[x+1] <> #0))) do begin

              if code[x] = #10 then Stack[StackP].str:=Stack[StackP].str+'<cr>'
              else Stack[StackP].str:=Stack[StackP].str+code[x];
              if not isdc then x:=x+2
              else inc(x);
              end;
              if not isdc then x:=x+2
              else inc(x); }
            if not isdc then
            begin
              // Stack[StackP].str:=WideCharToString(pwidechar(@code[x]));
              while (code[x] <> #0) or (code[x + 1] <> #0) do
              begin
                if (code[x] = #10) and (code[x + 1] = #0) then
                  Stack[StackP].str := Stack[StackP].str + MakeUni('<cr>')
                else
                  Stack[StackP].str := Stack[StackP].str + code[x] + code[x + 1];
                inc(x, 2);
              end;
              inc(x, 2);
            end
            else
            begin
              // Stack[StackP].str:=pansichar(@code[x]);
              while (code[x] <> #0) do
              begin
                if (code[x] = #10) then
                  Stack[StackP].str := Stack[StackP].str + '<cr>'
                else
                  Stack[StackP].str := Stack[StackP].str + code[x];
                inc(x);
              end;
              inc(x);
              Stack[StackP].str := chartouni(Stack[StackP].str);
            end;
          end;
          inc(StackP);
          if StackP > 79 then
            StackP := 80;
        end
        else
        begin
          s := s + MakeUni(AsmCode[y].name + ' ');
          if AsmCode[y].order <> T_NONE then
          begin
            if (AsmMode = 2) and (AsmCode[y].order = T_ARGS) then
            begin
              v := 0;
              while AsmCode[y].arg[v] <> T_NONE do
                inc(v);
              StackP := StackP - v;
              stackb := StackP;
            end;
            v := 0;
            if AsmCode[y].order = T_VASTART then
              inva := true;
            if AsmCode[y].order = T_VAEND then
              inva := false;
            while AsmCode[y].arg[v] <> T_NONE do
            begin
              if v <> 0 then
                s := s + MakeUni(', ');
              if AsmCode[y].arg[v] = T_REG then
              begin
                if (AsmMode = 2) and (AsmCode[y].order = T_ARGS) then
                begin
                  if Stack[stackb].DataType = 0 then
                  begin
                    s := s + MakeUni('R' + inttostr(Stack[stackb].value));
                    if TsReg.IndexOf('R' + inttostr(Stack[stackb].value)) = -1 then
                    begin
                      TsReg.Add('R' + inttostr(Stack[stackb].value));
                      form4.TreeView1.Items.AddChild(TrReg, 'R' + inttostr(Stack[stackb].value));
                    end;
                  end
                  else
                    s := s + MakeUni(inttohex(Stack[stackb].value, 8));
                  lr := Stack[stackb].value and 255;
                  StackP := 0;
                  inc(stackb);
                end
                else
                begin
                  s := s + MakeUni('R' + inttostr(byte(code[x])));
                  if TsReg.IndexOf('R' + inttostr(byte(code[x]))) = -1 then
                  begin
                    TsReg.Add('R' + inttostr(byte(code[x])));
                    form4.TreeView1.Items.AddChild(TrReg, 'R' + inttostr(byte(code[x])));
                  end;
                  lr := byte(code[x]);
                end;
                if AsmCode[y].fnc = $C4 then
                begin // .name='map_designate' then begin
                  // map info
                  if (regis[lr] < 30) and (regis[lr] + EPMap[curepi] < 46) then
                    if MapID[regis[lr] + EPMap[curepi]] + regis[lr + 2] < 123 then
                    begin
                      mapxvmfile[regis[lr]] := path + 'map\xvm\' + MapXvmName
                        [MapID[regis[lr] + EPMap[curepi]] + regis[lr + 2]];
                      mapfile[regis[lr]] := path + 'map\' + MapFileName
                        [MapID[regis[lr] + EPMap[curepi]] + regis[lr + 2]];
                      floor[regis[lr]].floorid := MapArea[MapID[regis[lr] + EPMap[curepi]] + regis[lr + 2]];
                      Form1.CheckListBox1.Items.Strings[regis[lr]] :=
                        MapName[MapID[regis[lr] + EPMap[curepi]] + regis[lr + 2]];
                    end;
                end;
                if AsmCode[y].fnc = $F80D then
                begin // .name='map_designate_ex' then begin
                  // map info
                  if (regis[lr] < 30) and (regis[lr + 1] < 46) then
                    if MapID[regis[lr + 1]] + regis[lr + 3] < 123 then
                    begin
                      mapxvmfile[regis[lr]] := path + 'map\xvm\' + MapXvmName[MapID[regis[lr + 1]] + regis[lr + 3]];
                      mapfile[regis[lr]] := path + 'map\' + MapFileName[MapID[regis[lr + 1]] + regis[lr + 3]];
                      floor[regis[lr]].floorid := MapArea[MapID[regis[lr + 1]] + regis[lr + 3]];
                      Form1.CheckListBox1.Items.Strings[regis[lr]] := MapName[MapID[regis[lr + 1]] + regis[lr + 3]];
                    end;
                end;
                if (AsmMode = 0) or (AsmCode[y].order <> T_ARGS) then
                  inc(x);
              end
              else if AsmCode[y].arg[v] = T_RREG then
              begin
                if (AsmMode = 2) and (AsmCode[y].order = T_ARGS) then
                begin
                  s := s + MakeUni('R' + inttostr(Stack[stackb].value));
                  StackP := 0;

                  if TsReg.IndexOf('R' + inttostr(Stack[stackb].value)) = -1 then
                  begin
                    TsReg.Add('R' + inttostr(Stack[stackb].value));
                    form4.TreeView1.Items.AddChild(TrReg, 'R' + inttostr(Stack[stackb].value));
                  end;
                  inc(stackb);
                end
                else
                begin
                  s := s + MakeUni('R' + inttostr(byte(code[x])));
                  if TsReg.IndexOf('R' + inttostr(byte(code[x]))) = -1 then
                  begin
                    TsReg.Add('R' + inttostr(byte(code[x])));
                    form4.TreeView1.Items.AddChild(TrReg, 'R' + inttostr(byte(code[x])));
                  end;
                  x := x + 1;
                end;

              end
              else if AsmCode[y].arg[v] = T_BREG then
              begin
                if (AsmMode = 2) and (AsmCode[y].order = T_ARGS) then
                begin
                  s := s + MakeUni('R' + inttostr(Stack[stackb].value));
                  StackP := 0;
                  if TsReg.IndexOf('R' + inttostr(Stack[stackb].value)) = -1 then
                  begin
                    TsReg.Add('R' + inttostr(Stack[stackb].value));
                    form4.TreeView1.Items.AddChild(TrReg, 'R' + inttostr(Stack[stackb].value));
                  end;
                  inc(stackb);
                end
                else
                begin
                  s := s + MakeUni('R' + inttostr(byte(code[x])));

                  if TsReg.IndexOf('R' + inttostr(byte(code[x]))) = -1 then
                  begin
                    TsReg.Add('R' + inttostr(byte(code[x])));
                    form4.TreeView1.Items.AddChild(TrReg, 'R' + inttostr(byte(code[x])));
                  end;
                  x := x + 1;
                end;

              end
              else if AsmCode[y].arg[v] = T_DREG then
              begin
                if (AsmMode = 2) and (AsmCode[y].order = T_ARGS) then
                begin
                  s := s + MakeUni('R' + inttostr(Stack[stackb].value));
                  StackP := 0;
                  if TsReg.IndexOf('R' + inttostr(Stack[stackb].value)) = -1 then
                  begin
                    TsReg.Add('R' + inttostr(Stack[stackb].value));
                    form4.TreeView1.Items.AddChild(TrReg, 'R' + inttostr(Stack[stackb].value));
                  end;
                  inc(stackb);
                end
                else
                begin
                  move(code[x], i, 4);
                  s := s + MakeUni('R' + inttostr(i));

                  if TsReg.IndexOf('R' + inttostr(i)) = -1 then
                  begin
                    TsReg.Add('R' + inttostr(i));
                    form4.TreeView1.Items.AddChild(TrReg, 'R' + inttostr(i));
                  end;
                  x := x + 4;
                end;

              end
              else if AsmCode[y].arg[v] = T_SWITCH2B then
              begin
                // s:=s+inttohex(byte(code[x]),2);
                // inc(x);
                i := byte(code[x]);
                s := s + MakeUni(inttostr(i));
                inc(x);
                while i > 0 do
                begin
                  s := s + MakeUni(':' + inttostr(byte(code[x])));
                  x := x + 1;
                  dec(i);
                end;
              end
              else if AsmCode[y].arg[v] = T_SWITCH then
              begin
                // s:=s+inttohex(byte(code[x]),2);
                // inc(x);
                i := byte(code[x]);
                s := s + MakeUni(inttostr(i));
                inc(x);
                while i > 0 do
                begin
                  s := s + MakeUni(':' + inttostr(byte(code[x]) + (byte(code[x + 1]) * 256)));
                  x := x + 2;
                  dec(i);
                end;
              end
              else if AsmCode[y].arg[v] = T_SWITCHZ then
              begin
                // s:=s+inttohex(byte(code[x]),2);
                // inc(x);
                i := 1;
                while i > 0 do
                begin
                  s := s + MakeUni(':' + inttostr(byte(code[x]) + (byte(code[x + 1]) * 256)));
                  i := byte(code[x]) + (byte(code[x + 1]) * 256);
                  x := x + 2;
                end;
              end
              else if AsmCode[y].arg[v] = T_BYTE then
              begin
                if (AsmMode = 2) and (AsmCode[y].order = T_ARGS) then
                begin
                  s := s + MakeUni(inttohex(Stack[stackb].value, 2));
                  StackP := 0;
                  inc(stackb);
                end
                else
                begin
                  s := s + MakeUni(inttohex(byte(code[x]), 2));
                  inc(x);
                end;
              end
              else if (AsmCode[y].arg[v] = T_WORD) then
              begin
                if (AsmMode = 2) and (AsmCode[y].order = T_ARGS) then
                begin
                  s := s + MakeUni(inttohex(Stack[stackb].value, 4));
                  StackP := 0;
                  inc(stackb);
                end
                else
                begin
                  s := s + MakeUni(inttohex(byte(code[x]) + (byte(code[x + 1]) * 256), 4));
                  if AsmCode[y].fnc = $F951 then
                  begin // .name='BB_Map_Designate' then begin
                    // map info
                    if (byte(code[x - 1]) < 30) and (byte(code[x]) < 46) then
                      if MapID[byte(code[x])] + byte(code[x + 2]) < 123 then
                      begin
                        mapxvmfile[byte(code[x - 1])] := path + 'map\xvm\' +
                          MapXvmName[MapID[byte(code[x])] + byte(code[x + 2])];
                        mapfile[byte(code[x - 1])] := path + 'map\' + MapFileName
                          [MapID[byte(code[x])] + byte(code[x + 2])];
                        floor[byte(code[x - 1])].floorid := MapArea[MapID[byte(code[x])] + byte(code[x + 2])];
                        Form1.CheckListBox1.Items.Strings[byte(code[x - 1])] :=
                          MapName[MapID[byte(code[x])] + byte(code[x + 2])];
                      end;
                  end;
                  x := x + 2;
                end;
              end
              else if (AsmCode[y].arg[v] = T_DATA) or (AsmCode[y].arg[v] = T_STRDATA) then
              begin
                if (AsmMode = 2) and (AsmCode[y].order = T_ARGS) then
                begin
                  s := s + MakeUni(inttostr(Stack[stackb].value));
                  for i := 0 to 999 do
                    if (datablock[i] = -1) or (datablock[i] = Stack[stackb].value) then
                      break;
                  datablock[i] := Stack[stackb].value;
                  datablockT[i] := AsmCode[y].arg[v];
                  StackP := 0;
                  inc(stackb);
                end
                else
                begin
                  s := s + MakeUni(inttostr(byte(code[x]) + (byte(code[x + 1]) * 256)));
                  for i := 0 to 999 do
                    if datablock[i] = -1 then
                      break;
                  datablock[i] := byte(code[x]) + (byte(code[x + 1]) * 256);
                  datablockT[i] := AsmCode[y].arg[v];
                  x := x + 2;
                end;
              end
              else
                { if (AsmCode[y].arg[v] = T_STRDATA) then begin
                  b:='';
                  while code[x] <> #0 do begin
                  b:=b+code[x];
                  inc(x);
                  end;
                  s:=s+makeuni(b);
                  for i:=0 to 999 do
                  if datablock[i] = -1 then break;
                  datablock[i]:=strtoint(b);
                  end else }
                if AsmCode[y].arg[v] = T_PFLAG then
                begin
                  if (AsmMode = 2) and (AsmCode[y].order = T_ARGS) then
                  begin
                    s := s + MakeUni(inttohex(Stack[stackb].value, 4));
                    StackP := 0;
                    inc(stackb);
                  end
                  else
                  begin
                    s := s + MakeUni(inttohex(byte(code[x]) + (byte(code[x + 1]) * 256), 4));
                    x := x + 2;
                  end;
                end
                else if AsmCode[y].arg[v] = T_FUNC then
                begin
                  if (AsmMode = 2) and (AsmCode[y].order = T_ARGS) then
                  begin
                    s := s + MakeUni(inttostr(Stack[stackb].value));
                    StackP := 0;
                    inc(stackb);
                  end
                  else
                  begin
                    s := s + MakeUni(inttostr(byte(code[x]) + (byte(code[x + 1]) * 256)));
                    x := x + 2;
                  end;
                end
                else if AsmCode[y].arg[v] = T_FUNC2 then
                begin
                  if (AsmMode = 2) and (AsmCode[y].order = T_ARGS) then
                  begin
                    s := s + MakeUni(inttostr(Stack[stackb].value));
                    StackP := 0;
                    inc(stackb);
                  end
                  else
                  begin
                    if AsmMode = 2 then
                    begin
                      s := s + MakeUni(inttostr(byte(code[x]) + (byte(code[x + 1]) * 256)));
                      x := x + 2;
                    end
                    else
                    begin
                      s := s + MakeUni(inttostr(byte(code[x]) + (byte(code[x + 1]) * 256)));
                      x := x + 4;
                    end;
                  end;
                end
                else if AsmCode[y].arg[v] = T_DWORD then
                begin
                  if (AsmMode = 2) and (AsmCode[y].order = T_ARGS) then
                  begin
                    if Stack[stackb].DataType = 0 then
                    begin
                      s := s + MakeUni('R' + inttostr(Stack[stackb].value));
                      if TsReg.IndexOf('R' + inttostr(Stack[stackb].value)) = -1 then
                      begin
                        TsReg.Add('R' + inttostr(Stack[stackb].value));
                        form4.TreeView1.Items.AddChild(TrReg, 'R' + inttostr(Stack[stackb].value));
                      end;
                    end
                    else
                      s := s + MakeUni(inttohex(Stack[stackb].value, 8));
                    if AsmCode[y].fnc = $9 then
                    begin // .name='leti' then begin
                      regis[lr] := Stack[stackb].value;
                    end;
                    if AsmCode[y].fnc = $8 then
                    begin // .name='let' then begin
                      regis[lr] := regis[Stack[stackb].value];
                    end;
                    StackP := 0;
                    inc(stackb);
                  end
                  else
                  begin
                    s := s + MakeUni(inttohex(byte(code[x]) + (byte(code[x + 1]) * 256) + (byte(code[x + 2]) * $10000) +
                      (byte(code[x + 3]) * $1000000), 8));
                    if AsmCode[y].fnc = $9 then
                    begin // name='leti' then begin
                      regis[lr] := byte(code[x]) + (byte(code[x + 1]) * 256) + (byte(code[x + 2]) * $10000) +
                        (byte(code[x + 3]) * $1000000);
                    end;
                    if AsmCode[y].fnc = $8 then
                    begin // name='let' then begin
                      regis[lr] := regis[byte(code[x])];
                    end;
                    if AsmCode[y].fnc = $F8BC then
                    begin // .name='set_epiII' then begin
                      curepi := byte(code[x]);
                    end;
                    x := x + 4;
                  end;
                end
                else if AsmCode[y].arg[v] = T_FLOAT then
                begin
                  if (AsmMode = 2) and (AsmCode[y].order = T_ARGS) then
                  begin
                    if Stack[stackb].DataType = 0 then
                    begin
                      s := s + MakeUni('R' + inttostr(Stack[stackb].value));
                      if TsReg.IndexOf('R' + inttostr(Stack[stackb].value)) = -1 then
                      begin
                        TsReg.Add('R' + inttostr(Stack[stackb].value));
                        form4.TreeView1.Items.AddChild(TrReg, 'R' + inttostr(Stack[stackb].value));
                      end;
                    end
                    else
                    begin
                      p := @m;
                      p[0] := pansichar(@Stack[stackb].value)[0];
                      p[1] := pansichar(@Stack[stackb].value)[1];
                      p[2] := pansichar(@Stack[stackb].value)[2];
                      p[3] := pansichar(@Stack[stackb].value)[3];
                      s := s + MakeUni(floattostr(m));
                    end;
                    StackP := 0;
                    inc(stackb);
                  end
                  else
                  begin
                    p := @m;
                    p[0] := code[x];
                    p[1] := code[x + 1];
                    p[2] := code[x + 2];
                    p[3] := code[x + 3];
                    s := s + MakeUni(floattostr(m));
                    x := x + 4;
                  end;
                end
                else if AsmCode[y].arg[v] = T_STR then
                begin
                  s := s + MakeUni('''');
                  if (AsmMode = 2) and (AsmCode[y].order = T_ARGS) then
                  begin
                    s := s + Stack[stackb].str;
                    StackP := 0;
                    inc(stackb);
                  end
                  else
                  begin
                    { while ((code[x] <> #0) and isdc) or (not isdc and ((code[x] <> #0)or(code[x+1] <> #0))) do begin

                      if code[x] = #10 then s:=s+'<cr>'
                      else s:=s+code[x];
                      if not isdc then x:=x+2
                      else inc(x);
                      end;
                      if not isdc then x:=x+2
                      else inc(x); }
                    if not isdc then
                    begin
                      // Stack[StackP].str:=WideCharToString(pwidechar(@code[x]));
                      while (code[x] <> #0) or (code[x + 1] <> #0) do
                      begin
                        if (code[x] = #10) and (code[x + 1] = #0) then
                          s := s + MakeUni('<cr>')
                        else
                          s := s + code[x] + code[x + 1];
                        inc(x, 2);
                      end;
                      inc(x, 2);
                    end
                    else
                    begin
                      b := '';
                      // Stack[StackP].str:=pansichar(@code[x]);
                      while (code[x] <> #0) do
                      begin
                        if (code[x] = #10) then
                          b := b + '<cr>'
                        else
                          b := b + code[x];
                        inc(x);
                      end;
                      b := chartouni(b);
                      s := s + b;
                      inc(x);

                    end;
                  end;
                  s := s + MakeUni('''');
                end
                else

                begin
                  if (AsmMode = 2) and (AsmCode[y].order = T_ARGS) then
                  begin
                    s := s + MakeUni(inttohex(Stack[stackb].value, 8));
                    StackP := 0;
                    inc(stackb);
                  end
                  else
                  begin
                    s := s + MakeUni(inttohex(byte(code[x]) + (byte(code[x + 1]) * 256) + (byte(code[x + 2]) * $10000) +
                      (byte(code[x + 3]) * $1000000), 8));
                    x := x + 4;
                  end;
                end;
              inc(v);
            end;
          end;
        end;
      end
      else
      begin
        s := s + MakeUni('Unknow_Opcode (' + inttohex(byte(code[x - 1]), 2) + ')');
      end;
      { for y:=0 to RefCount-1 do
        if (ref[y] < x) and (ref[y]>px) then break;
        if y < refcount then begin
        x:=ref[y];
        s:=inttostr(y)+':';
        while length(s) < 8 do s:=s+' ';
        s:=makeuni(s+'Unknow_Opcode ('+inttohex(byte(code[px]),2)+')');
        for y:=px+1 to x-1 do begin
        s:=makeuni('        Unknow_Opcode ('+inttohex(byte(code[y]),2)+')');
        Form4.ListBox1.Items.Add(s+#0);
        end;

        end; }

      if length(s) > 16 then
      begin
        s := s + #0#0;
        form4.ListBox1.Items.Add(pwidechar(@s[1]));
        { ss:=twidestrings.Create;
          ss.Add(pwidechar(@s[1]));
          showmessage(ss.Strings[0]);
          ss.Free }
      end;

    end
    else
    begin
      if ll = T_STRDATA then
      begin
        s := s + MakeUni('STR: ');
        if isdc then
          s := s + chartouni(pansichar(@code[x]))
        else
          for y := 0 to (dlength div 2) - 1 do
            if (code[x + (y * 2)] <> #0) or (code[x + (y * 2) + 1] <> #0) then
              s := s + code[x + (y * 2)] + code[x + (y * 2) + 1]
            else
              break;
        inc(x, dlength);
        while pos(#10#0, s) > 0 do
        begin
          y := pos(#10#0, s);
          delete(s, y, 2);
          insert('<'#0'c'#0'r'#0'>'#0, s, y);
        end;
        s := s + #0#0;
        form4.ListBox1.Items.Add(pwidechar(@s[1]));
      end
      else
      begin
        y := 0;
        s := s + MakeUni('HEX:');
        for i := 0 to dlength - 1 do
        begin
          s := s + MakeUni(' ' + inttohex(byte(code[x]), 2));
          inc(x);
          inc(y);
          if y > 15 then
          begin
            s := s + #0#0;
            form4.ListBox1.Items.Add(pwidechar(@s[1]));
            s := MakeUni('        HEX:');
            y := 0;
          end;
        end;
        if y > 0 then
        begin
          s := s + #0#0;
          form4.ListBox1.Items.Add(pwidechar(@s[1]));
        end;
      end;
    end;
  end;

  TrData.AlphaSort(false);
  Tropc.AlphaSort(false);
  TrReg.AlphaSort(false);
  TrFnc.AlphaSort(false);
  TsReg.CustomSort(CompareReg);
  Tsopc.CustomSort(Comparestr);
  TsFnc.CustomSort(CompareLabel);
  TsData.CustomSort(CompareLabel);
end;

Function QuestBuild(code: pansichar): dword;
var
  b, cmd, o: widestring;
  s, v: widestring;
  x, p, y, z, i, j, g, d, ll, kkk, oldval, um: integer;
  m: single;
  a: ansistring;
  dw: dword;
begin
  p := 0;
  for x := 0 to form4.ListBox1.Items.Count - 1 do
  begin
    try
      s := form4.ListBox1.Items.Strings[x];
      // Form1.Memo1.Lines.Add(s);
      ll := 0;
      kkk := -1;
      if s[1] <> ' ' then
      begin
        y := pos(':', s);
        kkk := strtoint(copy(s, 1, y - 1));
        if asmref[kkk] <> $FFFFFFFF then
        begin
          raise exception.Create('Duplicated label: ' + inttostr(kkk));
        end;
        asmref[kkk] := p;
        ll := 1;
      end;
      delete(s, 1, 8);
      y := pos(' ', s);
      cmd := copy(s, 1, y - 1);
      delete(s, 1, y);
      if cmd = '' then
      begin

      end
      else if cmd = 'STR:' then
      begin
        while (p div 4) * 4 <> p do
        begin
          code[p] := #0;
          inc(p);
        end;
        if kkk > -1 then
        begin
          for i := 0 to 999999 do
            if (i <> kkk) and (asmref[kkk] = asmref[i]) then
              asmref[i] := p;

          asmref[kkk] := p;
        end;
        if isdc then
        begin
          a := unitochar(s, 0);
          for i := 1 to length(a) do
          begin
            code[p] := a[i];
            inc(p);
          end;
          code[p] := #0;
          inc(p);
        end
        else
        begin
          for i := 1 to length(s) do
          begin
            code[p] := pansichar(@s[i])[0];
            code[p + 1] := pansichar(@s[i])[1];
            inc(p, 2);
          end;
          code[p] := #0;
          code[p + 1] := #0;
          inc(p, 2);
        end;
      end
      else if cmd = 'HEX:' then
      begin
        if ll = 1 then
          while (p div 4) * 4 <> p do
          begin
            code[p] := #0;
            inc(p);
          end;
        if kkk > -1 then
        begin
          for i := 0 to 999999 do
            if (i <> kkk) and (asmref[kkk] = asmref[i]) then
              asmref[i] := p;

          asmref[kkk] := p;
        end;
        while s <> '' do
        begin
          code[p] := ansichar(hextoint(copy(s, 1, 2)));
          delete(s, 1, 3);
          inc(p);
        end;
      end
      else if cmd = 'Unknow_Opcode' then
      begin
        code[p] := ansichar(hextoint(copy(s, 2, 2)));
        s := '';
        inc(p);
      end
      else
      begin
        for z := 0 to asmcount - 1 do
          if lowercase(AsmCode[z].name) = lowercase(cmd) then
          begin
            { if (AsmCode[z].order = T_DC) and (asmmode <> 2) then break;
              if (AsmCode[z].order <> T_DC) then break; }
            break;
          end;

        // analise the opcode
        if AsmMode = 2 then
        begin
          if (AsmCode[z].fnc = $D9) then
            for z := 0 to asmcount - 1 do
              if (AsmCode[z].fnc = $EF) and ((AsmCode[z].order <> T_DC)) then
                break;
          oldval := AsmCode[z].fnc; // auto convert
          for z := 0 to asmcount - 1 do
            if (AsmCode[z].fnc = oldval) and ((AsmCode[z].order <> T_DC)) then
              break;
        end
        else
        begin
          oldval := AsmCode[z].fnc; // make sure it use the real one
          for z := 0 to asmcount - 1 do
            if (AsmCode[z].fnc = oldval) then
              break;
          if AsmCode[z].fnc = $66 then
            s := s + ', 00000007'; // set_ally_NPC1_V3
          if AsmCode[z].fnc = $6D then
            s := s + ', 00000005'; // move_slot_V3
          if AsmCode[z].fnc = $79 then
            s := s + ', 00000008'; // set_neutral_NPC1_V3
          if AsmCode[z].fnc = $7C then
            s := s + ', 00000007'; // set_enemy_NPC_V3
          if AsmCode[z].fnc = $7D then
            s := s + ', 00000006'; // set_ally_NPC2_V3
          if AsmCode[z].fnc = $7F then
            s := s + ', 00000007'; // set_ally_NPC3_v3
          if AsmCode[z].fnc = $84 then
            s := s + ', 00000005'; // pan_camera_V3
          if AsmCode[z].fnc = $87 then
            s := s + ', 00000004'; // coord_create_pipe_V3
          if AsmCode[z].fnc = $A8 then
            s := s + ', 00000004'; // walk_to_coord_V3
          if AsmCode[z].fnc = $C0 then
            s := s + ', 00000005'; // light_orb1_V3
          if AsmCode[z].fnc = $CD then
            s := s + ', 00000004'; // chara_effect_V3
          if AsmCode[z].fnc = $CE then
            s := s + ', 00000007'; // set_neutral_NPC2_V3

          if AsmCode[z].fnc = $F8BC then
            for z := 0 to asmcount - 1 do
              if (AsmCode[z].fnc = $0) then
                break;

          // sync_register
          if AsmCode[z].fnc = $EF then
          begin
            for um := length(s) downto 1 do
            begin
              if s[um] = 'R' then
                break;
              if s[um] = ' ' then
              begin
                for z := 0 to asmcount - 1 do
                  if (AsmCode[z].fnc = $D9) then
                    break;
                break;
              end;
            end;
          end;
        end;

        if (AsmCode[z].order = T_ARGS) and (AsmMode = 2) then
        begin
          i := 0;
          while (s <> '') and (AsmCode[z].arg[i] <> T_NONE) do
          begin
            if AsmCode[z].arg[i] = T_STR then
            begin
              y := pos(widestring(''', '), s);
              if y <> 0 then
                inc(y);
            end
            else
              y := pos(widestring(', '), s);
            if y = 0 then
              b := s
            else
              b := copy(s, 1, y - 1);
            delete(s, 1, length(b) + 2);

            if (AsmCode[z].arg[i] = T_REG) or (AsmCode[z].arg[i] = T_RREG) then
            begin
              if b[1] = 'R' then
              begin
                if (AsmCode[z].arg[i] = T_REG) then
                  code[p] := #$48
                else
                  code[p] := #$4a;
                inc(p);
                code[p] := ansichar(strtoint(copy(b, 2, length(b) - 1)));
                inc(p);
              end
              else
              begin
                code[p] := #$49;
                inc(p);
                dw := hextoint(b);
                move(dw, code[p], 4);
                inc(p, 4);
              end;
            end
            else if (AsmCode[z].arg[i] = T_BREG) then
            begin
              code[p] := #$4a;
              inc(p);
              code[p] := ansichar(strtoint(copy(b, 2, length(b) - 1)));
              inc(p);
            end
            else if (AsmCode[z].arg[i] = T_DREG) then
            begin
              code[p] := #$49;
              inc(p);
              dw := strtoint(copy(b, 2, length(b) - 1));
              move(dw, code[p], 4);
              inc(p, 4);
            end
            else if (AsmCode[z].arg[i] = T_BYTE) then
            begin
              code[p] := #$4a;
              inc(p);
              code[p] := ansichar(hextoint(b));
              inc(p);
            end
            else if (AsmCode[z].arg[i] = T_WORD) or (AsmCode[z].arg[i] = T_PFLAG) then
            begin
              code[p] := #$4b;
              inc(p);
              code[p] := ansichar(hextoint(b));
              inc(p);
              code[p] := ansichar(hextoint(b) div 256);
              inc(p);
            end
            else if (AsmCode[z].arg[i] = T_DATA) then
            begin
              code[p] := #$4b;
              inc(p);
              code[p] := ansichar(strtoint(b));
              inc(p);
              code[p] := ansichar(strtoint(b) div 256);
              inc(p);
            end
            else if (AsmCode[z].arg[i] = T_FUNC) then
            begin
              code[p] := #$4b;
              inc(p);
              code[p] := ansichar(strtoint(b));
              inc(p);
              code[p] := ansichar(strtoint(b) div 256);
              inc(p);
            end
            else if (AsmCode[z].arg[i] = T_FUNC2) then
            begin
              code[p] := #$4b;
              inc(p);
              code[p] := ansichar(strtoint(b));
              inc(p);
              code[p] := ansichar(strtoint(b) div 256);
              inc(p);
            end
            else if (AsmCode[z].arg[i] = T_STR) then
            begin
              code[p] := #$4e;
              inc(p);
              j := 0;
              g := 0;

              { for y:=2 to length(b)-1 do
                begin }
              { if g<> 3 then code[p]:=b[y];
                if b[y] = '<' then begin
                if copy(b,y,4) = '<cr>' then begin
                code[p]:=#10;
                g:=3;
                end
                else g:=1;
                end;
                if b[y] = '>' then g:=0;
                if code[p] = #$a then j:=0;
                if g = 0 then inc(j);
                if (j>28) and (code[p] = #$20) then begin
                j:=0;
                code[p]:=#10;
                end; }
              // remove all <cr>
              v := copy(b, 2, length(b) - 2);
              while pos(widestring('<cr>'), v) > 0 do
              begin
                g := pos(widestring('<cr>'), v);
                v[g] := #$a;
                delete(v, g + 1, 3);
              end;
              if not isdc then
              begin
                for g := 1 to length(v) do
                begin
                  code[p] := pansichar(@v[g])[0];
                  code[p + 1] := pansichar(@v[g])[1];
                  inc(p, 2);
                end;
                code[p] := #0;
                code[p + 1] := #0;
                inc(p, 2);
              end
              else
              begin
                a := unitochar(v, 0);
                for g := 1 to length(a) do
                begin
                  code[p] := a[g];
                  inc(p, 1);
                end;
                code[p] := #0;
                inc(p, 1);
              end;
              // end;

            end
            else if (AsmCode[z].arg[i] = T_FLOAT) then
            begin
              if b[1] = 'R' then
              begin
                code[p] := #$48;
                inc(p);
                code[p] := ansichar(strtoint(copy(b, 2, length(b) - 1)));
                inc(p);
              end
              else
              begin
                code[p] := #$49;
                inc(p);
                m := strtofloat(b);
                code[p] := pansichar(@m)[0];
                inc(p);
                code[p] := pansichar(@m)[1];
                inc(p);
                code[p] := pansichar(@m)[2];
                inc(p);
                code[p] := pansichar(@m)[3];
                inc(p);
              end;
            end
            else
            begin
              if b[1] = 'R' then
              begin
                code[p] := #$48;
                inc(p);
                code[p] := ansichar(strtoint(copy(b, 2, length(b) - 1)));
                inc(p);
              end
              else
              begin
                code[p] := #$49;
                inc(p);
                dw := hextoint(b);
                move(dw, code[p], 4);
                inc(p, 4);
              end;
            end;
            inc(i);
          end;

          if AsmCode[z].fnc > 255 then
          begin
            code[p] := ansichar(AsmCode[z].fnc div 256);
            inc(p);
            code[p] := ansichar(AsmCode[z].fnc);
          end
          else
            code[p] := ansichar(AsmCode[z].fnc);

          inc(p);
        end
        else
        begin
          if AsmCode[z].fnc > 255 then
          begin
            code[p] := ansichar(AsmCode[z].fnc div 256);
            inc(p);
            code[p] := ansichar(AsmCode[z].fnc);
          end
          else
            code[p] := ansichar(AsmCode[z].fnc);
          inc(p);
          i := 0;
          while (s <> '') and (AsmCode[z].arg[i] <> T_NONE) do
          begin
            if AsmCode[z].arg[i] = T_STR then
            begin
              y := pos(widestring(''', '), s);
              if y <> 0 then
                inc(y);
            end
            else
              y := pos(widestring(', '), s);
            if y = 0 then
              b := s
            else
              b := copy(s, 1, y - 1);
            delete(s, 1, length(b) + 2);

            if (AsmCode[z].arg[i] = T_REG) or (AsmCode[z].arg[i] = T_RREG) or (AsmCode[z].arg[i] = T_BREG) then
            begin
              code[p] := ansichar(strtoint(copy(b, 2, length(b) - 1)));
              inc(p);
            end
            else if (AsmCode[z].arg[i] = T_DREG) then
            begin
              g := strtoint(copy(b, 2, length(b) - 1));
              move(g, code[p], 4);
              inc(p, 4);
            end
            else if (AsmCode[z].arg[i] = T_BYTE) then
            begin
              code[p] := ansichar(hextoint(b));
              inc(p);
            end
            else if (AsmCode[z].arg[i] = T_WORD) or (AsmCode[z].arg[i] = T_PFLAG) then
            begin
              code[p] := ansichar(hextoint(b));
              inc(p);
              code[p] := ansichar(hextoint(b) div 256);
              inc(p);
            end
            else if (AsmCode[z].arg[i] = T_DATA) or (AsmCode[z].arg[i] = T_STRDATA) then
            begin
              code[p] := ansichar(strtoint(b));
              inc(p);
              code[p] := ansichar(strtoint(b) div 256);
              inc(p);
            end
            else if (AsmCode[z].arg[i] = T_FUNC) then
            begin
              code[p] := ansichar(strtoint(b));
              inc(p);
              code[p] := ansichar(strtoint(b) div 256);
              inc(p);
            end
            else if (AsmCode[z].arg[i] = T_FUNC2) then
            begin
              IF AsmMode = 2 then
              begin
                code[p] := ansichar(strtoint(b));
                inc(p);
                code[p] := ansichar(strtoint(b) div 256);
                inc(p);
              end
              else
              begin
                code[p] := ansichar(strtoint(b));
                inc(p);
                code[p] := ansichar(strtoint(b) div 256);
                inc(p);
                code[p] := #0;
                inc(p);
                code[p] := #0;
                inc(p);
              end;
            end
            else if AsmCode[z].arg[i] = T_SWITCH2B then
            begin
              g := strtoint(copy(b, 1, pos(':', b) - 1));
              o := copy(b, pos(':', b) + 1, length(b) - pos(':', b));
              code[p] := ansichar(g);
              inc(p);
              while g > 0 do
              begin
                d := pos(':', o);
                if d = 0 then
                  d := length(o) + 1;
                j := strtoint(copy(o, 1, d - 1));
                o := copy(o, d + 1, length(o) - d);
                code[p] := ansichar(j);
                p := p + 1;
                dec(g);
              end;
            end
            else if AsmCode[z].arg[i] = T_SWITCH then
            begin
              g := strtoint(copy(b, 1, pos(':', b) - 1));
              o := copy(b, pos(':', b) + 1, length(b) - pos(':', b));
              code[p] := ansichar(g);
              inc(p);
              while g > 0 do
              begin
                d := pos(':', o);
                if d = 0 then
                  d := length(o) + 1;
                j := strtoint(copy(o, 1, d - 1));
                o := copy(o, d + 1, length(o) - d);
                code[p] := ansichar(j);
                code[p + 1] := ansichar(j div 256);
                p := p + 2;
                dec(g);
              end;
            end
            else if AsmCode[z].arg[i] = T_SWITCHZ then
            begin
              g := 1;
              while g > 0 do
              begin
                d := pos(':', o);
                if d = 0 then
                  d := length(o) + 1;
                j := strtoint(copy(o, 1, d - 1));
                o := copy(o, d + 1, length(o) - d);
                code[p] := ansichar(j);
                code[p + 1] := ansichar(j div 256);
                p := p + 2;
                g := j;
              end;
            end
            else if (AsmCode[z].arg[i] = T_FLOAT) then
            begin
              m := strtofloat(b);
              code[p] := pansichar(@m)[0];
              code[p + 1] := pansichar(@m)[1];
              code[p + 2] := pansichar(@m)[2];
              code[p + 3] := pansichar(@m)[3];
              p := p + 4;
            end
            else if (AsmCode[z].arg[i] = T_STR) then
            begin
              j := 0;
              g := 0;
              v := copy(b, 2, length(b) - 2);
              while pos(widestring('<cr>'), v) > 0 do
              begin
                g := pos(widestring('<cr>'), v);
                v[g] := #$a;
                delete(v, g + 1, 3);
              end;
              if not isdc then
              begin
                for g := 1 to length(v) do
                begin
                  code[p] := pansichar(@v[g])[0];
                  code[p + 1] := pansichar(@v[g])[1];
                  inc(p, 2);
                end;
                code[p] := #0;
                code[p + 1] := #0;
                inc(p, 2);
              end
              else
              begin
                a := unitochar(v, 0);
                for g := 1 to length(a) do
                begin
                  code[p] := a[g];
                  inc(p, 1);
                end;
                code[p] := #0;
                inc(p, 1);
              end;

            end
            else
            begin
              code[p] := ansichar(hextoint(b));
              inc(p);
              code[p] := ansichar(hextoint(b) div 256);
              inc(p);
              code[p] := ansichar(hextoint(b) div $10000);
              inc(p);
              code[p] := ansichar(hextoint(b) div $1000000);
              inc(p);
            end;
            inc(i);
          end;
        end;
      end;
    except
      on E: exception do
      begin
        MessageDlg('Build error at line ' + inttostr(x) + #13#10 + E.Message, mtInformation, [mbOk], 0);
        form4.Show;
        form4.ListBox1.ItemIndex := x;
        break;
      end;
    end;
  end;
  if isdc then
  begin
    x := p div 4;
    x := x * 4;
    if x <> p then
    begin
      x := x + 4;
      for y := p to x - 1 do
        code[y] := #0;
      p := x;
    end;
  end;
  result := p;

end;

function SelectNPCModel(i: integer): T3ditem;
var
  x: integer;
begin

  if (not fileexists(path + 'monster\npc\' + inttohex(i, 2) + '.nj')) and
    (not fileexists(path + 'monster\npc\' + inttohex(i, 2) + '.rel')) then
  begin
    result := basemonster[0];
    exit;
  end;
  for x := 0 to 50 do
    if basemonsterid[x] = i or $10000 then
      break;

  if x < 51 then
  begin
    result := basemonster[x];
  end
  else
  begin
    for x := 0 to 50 do
      if basemonsterid[x] = 0 then
        break;
    if x < 51 then
    begin
      basemonster[x] := T3ditem.Create(myscreen);
      if fileexists(path + 'monster\npc\' + inttohex(i, 2) + '.nj') then
        basemonster[x].LoadFromNJ(path + 'monster\npc\' + inttohex(i, 2) + '.nj', path + 'monster\npc\' + inttohex(i, 2)
          + '.xvm', '')
      else
        basemonster[x].LoadFromRel(path + 'monster\npc\' + inttohex(i, 2) + '.rel',
          path + 'monster\npc\' + inttohex(i, 2) + '.xvm');
      basemonsterid[x] := i or $10000;
      result := basemonster[x];
    end
    else
      result := basemonster[0];

  end;

end;

function SelectMonsterModel(i: integer): T3ditem;
var
  x: integer;
begin
  if (not fileexists(path + 'monster\' + MonsterFile[i] + '.nj')) and
    (not fileexists(path + 'monster\' + MonsterFile[i] + '.xj')) and
    (not fileexists(path + 'monster\' + MonsterFile[i] + '.md3')) then
  begin
    result := basemonster[0];
    exit;
  end;
  for x := 0 to 50 do
    if basemonsterid[x] = i then
      break;

  if x < 51 then
  begin
    result := basemonster[x];
  end
  else
  begin
    for x := 0 to 50 do
      if basemonsterid[x] = 0 then
        break;
    if x < 51 then
    begin
      basemonster[x] := T3ditem.Create(myscreen);
      if fileexists(path + 'monster\' + MonsterFile[i] + '.nj') then
        basemonster[x].LoadFromNJ(path + 'monster\' + MonsterFile[i] + '.nj', path + 'monster\' + MonsterFile[i] +
          '.xvm', '')
      else if fileexists(path + 'monster\' + MonsterFile[i] + '.md3') then
        basemonster[x].LoadQ3Files(path + 'monster\' + MonsterFile[i] + '.md3')
      else
        basemonster[x].LoadFromxJ(path + 'monster\' + MonsterFile[i] + '.xj', path + 'monster\' + MonsterFile[i] +
          '.xvm', '');
      basemonsterid[x] := i;
      result := basemonster[x];
    end
    else
      result := basemonster[0];

  end;
end;

function GenerateMonsterName(m: TMonster; x, fl: integer): ansistring;
var
  re, i: integer;
  px, py: single;
  isnpc: boolean;
begin
  re := 0; // default none
  isnpc := false;
  // ep1 monster
  if (m.Skin = 68) then
    re := 9; // booma
  if (m.Skin = 68) and (m.Movement_flag = 1) then
    re := 10; // gobooma
  if (m.Skin = 68) and (m.Movement_flag = 2) then
    re := 11; // gigobooma
  if (m.Skin = 68) and (m.Movement_flag = 3) then
    re := 11; // gigobooma
  if (m.Skin = 67) then
    re := 7; // savage woolf
  if (m.Skin = 67) and (round(m.Unknow10) = 1) then
    re := 8; // barbarous wolf
  if (m.Skin = 67) and (m.Movement_flag = 1) then
    re := 8; // Ives way D;
  if m.Skin = 65 then
    re := 5; // rappy
  if (m.Skin = 65) and (m.Movement_flag = 1) then
    re := 6; // AL rappy
  if m.Skin = 64 then
    re := 1; // Hildebear
  if (m.Skin = 128) then
    re := 24; // dubchic
  if (m.Skin = 128) and (m.Movement_flag = 1) then
    re := 50; // glitchic
  if m.Skin = 129 then
  begin
    re := 25; // garanz
    { for y:=1 to m.unknow2 div $10000 do
      result.ref[result.count+y]:=result.ref[result.count];
      inc(result.count,(m.unknow2 div $10000)); }
  end;
  if m.Skin = 131 then
    re := 28; // canadine
  if m.Skin = 133 then
    re := 49; // dubwitch
  if m.Skin = 163 then
    re := 34; // dubwitch
  if m.Skin = 97 then
  begin
    re := 13; // poison lily
    if curepi = 1 then
      if m.unknow3 = 17 then
        re := 83;
  end;

  if (m.Skin = 99) then
    re := 16; // evil shark

  if (m.Skin = 99) and (m.Movement_flag = 1) then
    re := 17; // pal shark
  if (m.Skin = 99) and (m.Movement_flag = 2) then
    re := 18; // guil shark
  if m.Skin = 98 then
    re := 15; // nano dragon
  if m.Skin = 96 then
    re := 12; // grass assasin
  if m.Skin = 168 then
    re := 38; // claw
  if (m.Skin = 166) then
    re := 41; // diemen
  if (m.Skin = 166) and (m.Movement_flag = 1) then
    re := 42; // la diemen
  if (m.Skin = 166) and (m.Movement_flag = 2) then
    re := 43; // so diemen
  if m.Skin = 165 then
    re := 37; // dark beltra
  if m.Skin = 160 then
    re := 30; // delsabler
  if m.Skin = 162 then
    re := 34; // dark gunner
  if m.Skin = 163 then
    re := 35; // dark gunner
  if m.Skin = 164 then
    re := 36; // Chaos Bringer
  if m.Skin = 192 then
    re := 44; // dragon
  if m.Skin = 197 then
    re := 46; // vol opt B
  if m.Skin = 193 then
  begin // de rol le
    re := 45;
  end;
  if m.Skin = 194 then
  begin // volopt
    re := 109;
  end;
  if m.Skin = 200 then
  begin // falz
    re := 47;
  end;
  if m.Skin = 66 then
  begin // monest
    re := 4;
  end;
  if m.Skin = 132 then
  begin // canadine army
    re := 29;
  end;
  if m.Skin = 130 then
  begin // sinow
    if round(m.Unknow10) = 1 then
      re := 27 // and 255 = 2 then result.ref[result.count]:=27 //gold
    else
      re := 26; // blue
  end;
  if m.Skin = 100 then
  begin // polyfulslim
    re := 19;
  end;
  if m.Skin = 101 then
  begin // pan arms
    re := 21;
  end;
  if m.Skin = 161 then
  begin // chaos sorcerer
    re := 31;
  end;
  if m.Skin = 167 then
  begin // bulclaw
    re := 40;
  end;

  // ep2

  if m.Skin = 223 then
  begin // ReconBox
    // form1.Memo1.Lines.Add('RaconBox: '+inttostr(m.unknow2 div $10000));
    re := 67;
    { for y:=1 to m.unknow2 div $10000 do
      result.ref[result.count+y]:=68;
      result.count:=result.count+(m.unknow2 div $10000); }
  end;
  if (m.Skin = 213) then
    re := 52;
  if (m.Skin = 213) and (m.Movement_flag = 1) then
    re := 53;

  if (m.Skin = 212) then
  begin
    re := 62;
    if (m.Movement_flag = 1) then
      re := 63;
  end;

  if (m.Skin = 215) then
  begin
    re := 59;
    if (m.Movement_flag = 1) then
      re := 60;
    if (m.Movement_flag = 2) then
      re := 60;
  end;
  if (m.Skin = 217) then
    re := 54;
  if (m.Skin = 218) then
    re := 55;
  if (m.Skin = 214) then
    re := 56;
  if (m.Skin = 214) and (m.Movement_flag = 1) then
    re := 57;
  if (m.Skin = 214) and (m.Movement_flag = 2) then
    re := 58;
  if (m.Skin = 222) then
    re := 66;
  if (m.Skin = 221) then
    re := 64;
  if (m.Skin = 221) and (m.Movement_flag = 1) then
    re := 65;
  if (m.Skin = 221) and (m.Movement_flag = 2) then
    re := 65;
  if (m.Skin = 225) then
    re := 82;
  if (m.Skin = 224) then
  begin
    re := 69;
    if (m.Movement_flag = 1) then
      re := 70;
  end;
  if (m.Skin = 216) then
    re := 61;
  if (m.Skin = 219) then
    re := 71;
  if (m.Skin = 220) then
    re := 72;

  if curepi = 1 then
    if m.Skin = 192 then
      re := 77; // gal

  if m.Skin = 202 then
  begin // olga
    re := 78;
  end;
  if (m.Skin = 201) then
    re := 77;
  if (m.Skin = 204) then
  begin
    re := 76;
  end;
  if m.Skin = 203 then
  begin // Barba Ray
    re := 73;
  end;

  // ep4
  if (m.Skin = 273) and (m.Unknow10 = 0) then
    re := 90; // sat liz
  if (m.Skin = 273) then
    if (round(m.Unknow10) = 1) then
      re := 89; // yowie
  if (m.Skin = 277) then
    re := 96; // boota
  if (m.Skin = 277) and (m.Movement_flag = 1) then
    re := 97; // ..boota
  if (m.Skin = 277) and (m.Movement_flag = 2) then
    re := 98; // ...boota
  if (m.Skin = 277) and (m.Movement_flag = 3) then
    re := 98; // ...boota
  if (m.Skin = 276) then
  begin
    re := 94;
    if (m.Movement_flag = 1) then
      re := 95; // AL rappy
  end;
  if (m.Skin = 272) then
    re := 88;
  if (m.Skin = 278) then
  begin
    re := 99;
    if (m.Movement_flag = 1) then
      re := 100; // AL rappy
  end;
  if (m.Skin = 274) then
  begin
    re := 91;
    if (m.Movement_flag = 1) then
      re := 92; // AL rappy
  end;
  if (m.Skin = 275) then
    re := 93;
  if (m.Skin = 281) then
    re := 106;
  if (m.Skin = 69) then
    re := 110;

  if (m.Skin = 279) then
    re := 101; // Goran
  if (m.Skin = 279) and (m.Movement_flag = 1) then
    re := 103; // Goran d
  if (m.Skin = 279) and (m.Movement_flag = 2) then
    re := 102; // Pyro

  if curepi = 2 then
  begin
    if m.Skin = 65 then
      re := 104; // rappy     asd
    if (m.Skin = 65) and (m.Movement_flag = 1) then
      re := 105; // AL rappy
  end;

  if x >= MyMonstZCount then
  begin
    setlength(MyMonstZ, x + 1);
    MyMonstZCount := x + 1;
  end;
  MyMonstZ[x] := MonsterPosZ[re];
  // give it a name D;
  if m.Skin = 0 then
  begin
    result := 'Unused';
    if fl > 0 then
      if x >= mymonstcount then
      begin
        mymonstcount := x + 1;
        setlength(Mymonst, mymonstcount);
      end;
    if fl = 2 then
      Mymonst[x].Free;
    if fl > 0 then
      Mymonst[x] := T3ditem.Create(myscreen);
  end
  else if (m.Skin < 64) or ((m.Skin >= $D0) and (m.Skin < 257) and (re = 0)) then
  begin
    // is a npc
    if fl > 0 then
      if x >= mymonstcount then
      begin
        mymonstcount := x + 1;
        setlength(Mymonst, mymonstcount);
      end;
    if fl = 2 then
      Mymonst[x].Free;
    if fl > 0 then
    begin
      Mymonst[x] := T3ditem.Create(myscreen);
      px := m.Pos_x;
      py := m.Pos_y;
      // rotate it
      py := cos((rev[floor[sfloor].Monster[x].map_section] and $FFFF) / 10430.37835) * m.Pos_y -
        sin((rev[floor[sfloor].Monster[x].map_section] and $FFFF) / 10430.37835) * m.Pos_x;
      px := sin((rev[floor[sfloor].Monster[x].map_section] and $FFFF) / 10430.37835) * m.Pos_y +
        cos((rev[floor[sfloor].Monster[x].map_section] and $FFFF) / 10430.37835) * m.Pos_x;

      Mymonst[x] := T3ditem.Create(myscreen);

      if m.Skin = 51 then
      begin
        if floor[sfloor].floorid < 46 then
        begin
          if m.unknow7 < 16 then
          begin
            if NPC51Name[floor[sfloor].floorid, m.unknow7] = '' then
            begin
              if floor[sfloor].floorid > 34 then
                Mymonst[x].CloneFromItem(SelectNPCModel(m.Skin))
              else
                Mymonst[x].CloneFromItem(SelectMonsterModel(112));
            end
            else
              Mymonst[x].CloneFromItem(SelectMonsterModel(NPC51File[floor[sfloor].floorid, m.unknow7]));
          end
          else
            Mymonst[x].CloneFromItem(SelectMonsterModel(112));
        end
        else
          Mymonst[x].CloneFromItem(SelectMonsterModel(112));
      end
      else
        Mymonst[x].CloneFromItem(SelectNPCModel(m.Skin));
      Mymonst[x].SetCoordinate(px + midpz[floor[sfloor].Monster[x].map_section].x,
        m.Pos_z + miz[floor[sfloor].Monster[x].map_section], 0 - py - midpz[floor[sfloor].Monster[x].map_section].y);
      Mymonst[x].Visible := true;
      { Mymonst[x].SetRotation(((($8000-(m.Direction+rev[Floor[sfloor].Monster[x].map_section])) and $ffff) / 182.04444)
        ,0,0); }
      Mymonst[x].SetRotation((((-(m.Direction + rev[floor[sfloor].Monster[x].map_section])) and $FFFF) /
        182.04444), 0, 0);
    end;
    result := GetMonsterName(m.Skin);
    if m.Skin = 51 then
    begin
      if floor[sfloor].floorid < 46 then
      begin
        if m.unknow7 < 16 then
        begin
          if NPC51Name[floor[sfloor].floorid, m.unknow7] = '' then
          begin
            if floor[sfloor].floorid > 34 then
              result := result + ' - Unsuported'
            else
              result := result + ' - CRASH';
          end
          else
            result := result + ' - ' + NPC51Name[floor[sfloor].floorid, m.unknow7];
        end
        else
          result := result + ' - CRASH';
      end;
    end;
    if fl = -1 then
      result := inttohex(m.Skin, 2);
  end
  else
  begin
    result := MonsterName[re];
    if fl > 0 then
      if x >= mymonstcount then
      begin
        mymonstcount := x + 1;
        setlength(Mymonst, mymonstcount);
      end;
    if fl = 2 then
      Mymonst[x].Free;
    if fl > 0 then
    begin
      if extractfilename(mapfilenam) = 'map_boss03c.rel' then
      begin
        midpz[0].y := 0;
      end;
      px := m.Pos_x;
      py := m.Pos_y;
      // rotate it
      py := cos((rev[floor[sfloor].Monster[x].map_section] and $FFFF) / 10430.37835) * m.Pos_y -
        sin((rev[floor[sfloor].Monster[x].map_section] and $FFFF) / 10430.37835) * m.Pos_x;
      px := sin((rev[floor[sfloor].Monster[x].map_section] and $FFFF) / 10430.37835) * m.Pos_y +
        cos((rev[floor[sfloor].Monster[x].map_section] and $FFFF) / 10430.37835) * m.Pos_x;

      Mymonst[x] := T3ditem.Create(myscreen);
      Mymonst[x].CloneFromItem(SelectMonsterModel(re));
      Mymonst[x].SetCoordinate(px + midpz[floor[sfloor].Monster[x].map_section].x,
        m.Pos_z + miz[floor[sfloor].Monster[x].map_section] + MonsterPosZ[re],
        0 - py - midpz[floor[sfloor].Monster[x].map_section].y);
      Mymonst[x].Visible := true;
      // Mymonst[x].SetRotation(((($8000-(m.Direction+rev[Floor[sfloor].Monster[x].map_section])) and $ffff) / 182.04444)
      if m.Skin = 223 then
      begin
        if m.Movement_flag = 0 then
          Mymonst[x].SetRotation((((-(m.Direction + rev[floor[sfloor].Monster[x].map_section])) and $FFFF) /
            182.04444), 0, 0);
        if m.Movement_flag = 1 then
          Mymonst[x].SetRotation((((-(m.Direction + rev[floor[sfloor].Monster[x].map_section])) and $FFFF) /
            182.04444), 0, 180);

        if m.Movement_flag >= 2 then
          Mymonst[x].SetRotation(0, ((($C000 - (m.Direction + rev[floor[sfloor].Monster[x].map_section])) and $FFFF) /
            182.04444), 90);
      end
      else
        Mymonst[x].SetRotation((((-(m.Direction + rev[floor[sfloor].Monster[x].map_section])) and $FFFF) /
          182.04444), 0, 0);
    end;
  end;
end;

end.
