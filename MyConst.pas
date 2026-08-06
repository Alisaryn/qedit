unit MyConst;

interface

  Const
    EnglishUIText: array[0..533] of string = (
    'File',                                                                     // 1
    'Properties',                                                               // 2
    'Script',                                                                   // 3
    'Tools',                                                                    // 4
    'New',                                                                      // 5
    'Episode 1',                                                                // 6
    'Episode 2',                                                                // 7
    'Episode 4',                                                                // 8
    'Open...',                                                                  // 9
    'Save...',                                                                  // 10
    'Language',                                                                 // 11
    'Quit',                                                                     // 12
    'Title',                                                                    // 13
    'Information',                                                              // 14
    'Description',                                                              // 15
    'Settings',                                                                 // 16
    'View script',                                                              // 17
    'Export...',                                                                // 18
    'Import...',                                                                // 19
    'Quest files manager',                                                      // 20
    'Compatibility check',                                                      // 21
    'Item list (BB quests only)',                                               // 22
    '3D View',                                                                  // 23
    '3D Setup',                                                                 // 24
    'About',                                                                    // 25
    'Check for updates...',                                                     // 26
    'Help',                                                                     // 27
    'Map :',                                                                    // 28
    'Area :',                                                                   // 29
    'Export floor data',                                                        // 30
    'Import floor data',                                                        // 31
    'View map events',                                                          // 32
    'Random monster data',                                                      // 33
    'Monsters :',                                                               // 34
    'Objects :',                                                                // 35
    'Visual map',                                                               // 36
    'Show room ID',                                                             // 37
    'Zoom',                                                                     // 38
    'Room ID placement :',                                                      // 39
    'Add monster',                                                              // 40
    'Add object',                                                               // 41
    'Delete',                                                                   // 42
    'Edit data',                                                                // 43
    'Move',                                                                     // 44
    'Undo',                                                                     // 45
    'A previous shadow file has been found for this quest.<cr>Do you want to restore it?', // 46
    'Clearing previous models...',                                              // 47
    'Generating monster models...',                                             // 48
    'Generating object models...',                                              // 49
    'Loading map...',                                                           // 50
    'Couldn''t load map: not enough memory.',                                   // 51
    'Error while rendering monsters on map.',                                   // 52
    'Error while rendering objects on map.',                                    // 53
    'Room',                                                                     // 54
    'Save current project before quitting?',                                    // 55
    'Save current project before opening a new one?',                           // 56
    'Error while unpacking the quest.',                                         // 57
    'Not used',                                                                 // 58
    'Unknown group type(',                                                      // 59
    ') at offset',                                                              // 60
    'Error while reading quest data.',                                          // 61
    'Error while reading Binary data.',                                         // 62
    'Error while disassembling the quest script.',                              // 63
    ' (Dreamcast ASCII Format)',                                                // 64
    ' (Unicode Format)',                                                        // 65
    ' - Episode 1',                                                             // 66
    ' - Episode 2',                                                             // 67
    ' - Episode 4',                                                             // 68
    ' - Script Mode 2',                                                         // 69
    'Unknown skin',                                                             // 70
    'Unknown NPC',                                                              // 71
    'Error rendering map area.',                                                // 72
    'Error rendering map.',                                                     // 73
    'Error creating the file',                                                  // 74
    'Range',                                                                    // 75
    'Scale X',                                                                  // 76
    'Scale Y',                                                                  // 77
    'Scale Z',                                                                  // 78
    'Save current project before creating a new one?',                          // 79
    'Creating 3D device...',                                                    // 80
    'Couldn''t create DirectX surface.',                                        // 81
    ' entries)',                                                                // 82
    'All',                                                                      // 83
    'Wave #',                                                                   // 84
    'Group #',                                                                  // 85
    'Main function (label 0) is undefined',                                     // 86
    '" at line',                                                                // 87
    ' at line',                                                                 // 88
    'Auto conversion might fail "',                                             // 89
    'Selected episode not supported "',                                         // 90
    'Opcode not supported "',                                                   // 91
    'This quest is using an encoded image, make sure the image format matches the version you''re saving.', // 92
    'Parameter swap not allowed on this version "',                             // 93
    'Undefined label used',                                                     // 94
    'Missing text command mark at line',                                        // 95
    'Undefined label',                                                          // 96
    ' used in NPC #',                                                           // 97
    ' on floor',                                                                // 98
    ' Monster/NPC',                                                             // 99
    ' doesn''t work on this version, entry #',                                  // 100
    'NPC skin 51 has a bad skin selected and will crash PSO, entry #',          // 101
    ' shouldn''t be allowed on this floor, entry #',                            // 102
    'Object',                                                                   // 103
    'Floor',                                                                    // 104
    ' You have over 400 objects, this could crash or cause random bugs.',       // 105
    ' You have over 400 enemies, this could crash or cause random bugs.',       // 106
    'Unused chunk of data :',                                                   // 107
    'No Binary file found.',                                                    // 108
    'No Dataset file found.',                                                   // 109
    'PVR file not allowed on this version.',                                    // 110
    'Map layout',                                                               // 111
    'Getting update information....',                                           // 112
    'Close',                                                                    // 113
    'Attack range',                                                             // 114
    'Knockback range',                                                          // 115
    'Load template',                                                            // 116
    'OK',                                                                       // 117
    'Cancel',                                                                   // 118
    'Enemy stat',                                                               // 119
    'Compatibility check',                                                      // 120
    'Version :',                                                                // 121
    'Edit',                                                                     // 122
    'Y position',                                                               // 123
    'Base Y value of the zone:',                                                // 124
    'Enemy attack data',                                                        // 125
    'Enemy movement edit',                                                      // 126
    'Enemy resistance',                                                         // 127
    'Wrong float value at entry #',                                             // 128
    'Float data editor',                                                        // 129
    'Quest Information',                                                        // 130
    'Information :',                                                            // 131
    'Function',                                                                 // 132
    'Data/Str',                                                                 // 133
    'Register',                                                                 // 134
    'Opcode',                                                                   // 135
    'Unused',                                                                   // 136
    'NPC data',                                                                 // 137
    'Code',                                                                     // 138
    'Image data',                                                               // 139
    'String data',                                                              // 140
    'Enemy physical data',                                                      // 141
    'Enemy resist data',                                                        // 142
    'Enemy attack data',                                                        // 143
    'Enemy movement data',                                                      // 144
    'Float data',                                                               // 145
    'Script',                                                                   // 146
    'Line',                                                                     // 147
    'Up',                                                                       // 148
    'Down',                                                                     // 149
    'Edit',                                                                     // 150
    'Add',                                                                      // 151
    'Delete',                                                                   // 152
    'Change font',                                                              // 153
    'Import',                                                                   // 154
    'Export',                                                                   // 155
    'Search',                                                                   // 156
    'Data',                                                                     // 157
    'Change label flag',                                                        // 158
    'Copy',                                                                     // 159
    'Cut',                                                                      // 160
    'Paste',                                                                    // 161
    'Delete',                                                                   // 162
    'NPC Edit',                                                                 // 163
    'Change image',                                                             // 164
    'Save image',                                                               // 165
    'Edit Enemy physical data',                                                 // 166
    'Edit Enemy resistance data',                                               // 167
    'Edit Enemy attack data',                                                   // 168
    'Edit Enemy movement data',                                                 // 169
    'Edit Float data',                                                          // 170
    'Delete chunk',                                                             // 171
    'As code',                                                                  // 172
    'As Hex data',                                                              // 173
    'As Str data',                                                              // 174
    'Couldn''t create file',                                                    // 175
    'This isn''t a valid Unicode file.',                                        // 176
    'Text not found.',                                                          // 177
    'This label is not referenced as NPC Data,<cr>Do you still want to edit it?', // 178
    'The selected label is currently undefined,<cr>It''s important you define it before saving/reopening the quest.', // 179
    'The image selected should be compressed before being added.<cr>Do you want the editor to do it now?', // 180
    'File added successfully.<cr>Size of the original file :', // 181
    '<cr>Size after compression:', // 182
    'File added successfully.<cr>Size of the file :', // 183
    'This label is not referenced as Enemy physical Data,<cr>Do you still want to edit it?', // 184
    'This label is not referenced as Enemy resistance Data,<cr>Do you still want to edit it?', // 185
    'This label is not referenced as Enemy Attack Data,<cr>Do you still want to edit it?', // 186
    'This label is not referenced as Enemy Movement Data,<cr>Do you still want to edit it?', // 187
    'Changing the type of a label will cancel any unsaved changes,<cr>do you want to continue?', // 188
    'Script Disassembly Error!',                                                // 189
    'This label is not referenced as Float Data,<cr>Do you still want to edit it?', // 190
    'Common settings',                                                          // 191
    'Language :',                                                               // 192
    'Quest Number :',                                                           // 193
    'Quest title',                                                              // 194
    'Title :',                                                                  // 195
    'Section ID',                                                               // 196
    'NPC None',                                                                 // 197
    'NPC',                                                                      // 198
    'Skin',                                                                     // 199
    'Head',                                                                     // 200
    'Unused',                                                                   // 201
    'Face',                                                                     // 202
    'Hair',                                                                     // 203
    'Costume',                                                                  // 204
    'Section ID',                                                               // 205
    'NPC Builder',                                                              // 206
    'Invalid opcode name',                                                      // 207
    'Label number must be between 0 and 65535',                                 // 208
    'Label isn''t a valid integer',                                             // 209
    'Field is empty.',                                                          // 210
    'Value is invalid.',                                                        // 211
    'Value must be between 0 and FFFFFFFF.',                                    // 212
    'Value for Register must be between 0 and 255.',                            // 213
    'Value for T_BYTE is invalid.',                                             // 214
    'Value for T_BYTE must be between 0 and FF.',                               // 215
    'Value for T_WORD is invalid.',                                             // 216
    'Value for T_WORD must be between 0 and FFFF.',                             // 217
    'Value for T_PFLAG is invalid.',                                            // 218
    'Value for T_PFLAG must be between 0 and FFFF.',                            // 219
    'Value for T_FUNC/T_DATA must be between 0 and 65535.',                     // 220
    'Value for Register must be between 0 and 255.',                            // 221
    'Number of switches is different.',                                         // 222
    'Value for Register must be between 0 and 255.',                            // 223
    'Value must be between 0 and FFFFFFFF.',                                    // 224
    'This label is already used and defined as',                                // 225
    '<cr>Please select another label.',                                        // 226
    'Sorry, PsoBB ep4 is not supported since Sega apparently disabled/bugged this feature.<cr>Same goes for BB ep1 and 2.', // 227
    'The field is empty; you need to set a label first.',                       // 228
    'You can''t edit this label yet, since it''s currently undefined or isn''t data.<cr>Press insert to add this opcode and set up the NPC.', // 229
    'The field is empty; you need to set a label first.',                       // 230
    'You can''t edit this label yet, since its currently undefined or isn''t data.<cr>Press insert to add this opcode and set up the enemy physical data.', // 231
    'The field is empty; you need to set a label first.',                       // 232
    'You can''t edit this label yet, since it''s currently undefined or isn''t data.<cr>Press insert to add this opcode and set up the enemy resist data.', // 233
    'You can''t edit this label yet, since it''s currently undefined or isn''t data.<cr>Press insert to add this opcode and set up the enemy movement data.', // 234
    'You can''t edit this label yet, since it''s currently undefined or isn''t data.<cr>Press insert to add this opcode and set up the enemy attack data.', // 235
    'You can''t edit this label yet, since it''s currently undefined or isn''t data.<cr>Press insert to add this opcode and set up the image data.', // 236
    'You can''t edit this label yet, since it''s currently undefined or isn''t data.<cr>Press insert to add this opcode and set up the floats.', // 237
    'Add command',                                                              // 238
    'Opcode :',                                                                 // 239
    'Label',                                                                    // 240
    'Insert',                                                                   // 241
    'Add Object',                                                               // 242
    'Select an object to add :',                                                // 243
    'Add',                                                                      // 244
    'Add Monster',                                                              // 245
    'Select the monster to add :',                                              // 246
    'Set to wave :',                                                            // 247
    'Failed to build the event<cr>',                                            // 248
    'Map events',                                                               // 249
    'Event:',                                                                   // 250
    'Test and save',                                                            // 251
    'Description',                                                              // 252
    'Long description:',                                                        // 253
    ' Bytes)',                                                                  // 254
    'Are you sure that you want to remove that file?',                          // 255
    'Quest files manager',                                                      // 256
    'Files:',                                                                   // 257
    'Save to quest',                                                            // 258
    '3D View',                                                                  // 259
    '3D Processing',                                                            // 260
    'Monster randomness',                                                       // 261
    'Monster position',                                                         // 262
    'Enemy configuration',                                                      // 263
    'Rooms:',                                                                   // 264
    'Spawn points',                                                             // 265
    'Monster settings',                                                         // 266
    'Config pool',                                                              // 267
    'About',                                                                    // 268
    'PSO Quest Editor by Schthack',                                             // 269
    'Supports PSO DC, PC, GC, BB',                                              // 270
    'Credit:<cr><cr>Coder:<cr>Schthack<cr><cr>First ASM file:<cr>Myria<cr>Clara<cr><cr>ASM Update:<cr>Lee 			(over 50% of the ASM)<cr>Aleron Ives<cr>Gatten<cr>Schthack<cr><cr>Quest file format:<cr>Schthack<cr>Lee			(Challenge mode data)<cr><cr>3D map structure:<cr>Schthack<cr><cr>3D model structure:<cr>Kryslin<cr><cr>Object and Monster model research:<cr>Lee<cr>Schthack<cr>Firefox<cr><cr>Special thanks to:<cr>AleronIves<cr>Lee<cr>Firefox276<cr>for their suggestions and being very good<cr>guinea pigs<cr><cr>1.0c-2.0c updates:<cr>Alisaryn<cr>', // 271
    'Item list manager',                                                        // 272
    '3D Settings',                                                              // 273
    'Screen size:',                                                             // 274
    'Frame skip:',                                                              // 275
    'Distance:',                                                                // 276
    'Save',                                                                     // 277
    'Use anti-aliasing',                                                        // 278
    'Use skydome',                                                              // 279
    'Load template',                                                            // 280
    'Database :',                                                               // 281
    'Monster :',                                                                // 282
    'Difficulty :',                                                             // 283
    'Select the monster',                                                       // 284
    'There are no updates available.',                                          // 285
    'Update',                                                                   // 286
    'Done.',                                                                    // 287
    'Some updates will only take effect after restarting the application.',     // 288
    'The current project isn''t saved, and the application needs to be restarted,<cr>do you want to continue?', // 289
    'There was an error retrieving update data.',                               // 290
    'Error getting file.',                                                      // 291
    '<cr>Keep QEdit up to date to<cr>ensure its functionality and<cr>get all the improvements<cr>being worked on.<cr>', // 292
    'Updates',                                                                  // 293
    'Export text for translation...',                                           // 294
    'Import text from translation...',                                          // 295
    'Floor filter',                                                             // 296
    'Sort for:',                                                                // 297
    'Add random spawns',                                                        // 298
    'Set rotation',                                                             // 299
    'Auto-axis',                                                                // 300
    'Set theme...',                                                             // 301
    'Set theme',                                                                // 302
    'Text editor',                                                              // 303
    'Floor',                                                                    // 304
    'Sort',                                                                     // 305
    'Monsters',                                                                 // 306
    'Objects',                                                                  // 307
    'by Room',                                                                  // 308
    'by Wave',                                                                  // 309
    'by Group',                                                                 // 310
    'by Type',                                                                  // 311
    'Export data...',                                                           // 312
    'Import data...',                                                           // 313
    'View events',                                                              // 314
    'Preview events',                                                           // 315
    'Random monsters',                                                          // 316
    'Add room',                                                                 // 317
    'Edit room',                                                                // 318
    'Delete room',                                                              // 319
    'Add entry',                                                                // 320
    'Delete entry',                                                             // 321
    'Add row',                                                                  // 322
    'Delete row',                                                               // 323
    'Monster and box count',                                                    // 324
    'Monster and box details',                                                  // 325
    'This quest is so epic that it doesn''t need monsters or boxes!',           // 326
    ' Previous',                                                                // 327
    ' Next',                                                                    // 328
    'Space: Pause/Play',                                                        // 329
    'Esc: Exit preview',                                                        // 330
    'Delete room ',                                                             // 331
    ' and all of its entries?',                                                 // 332
    'Enemy wave',                                                               // 333
    'Object group',                                                             // 334
    'New',                                                                      // 335
    'Monster...',                                                               // 336
    'Object...',                                                                // 337
    'Copy last monster',                                                        // 338
    'Copy last object',                                                         // 339
    'Drag to move',                                                             // 340
    'Options',                                                                  // 341
    'Placement options',                                                        // 342
    'Snap options',                                                             // 343
    'Defaults',                                                                 // 344
    'Offset X:',                                                                // 345
    'Offset Y:',                                                                // 346
    'Offset Z:',                                                                // 347
    'Default section:',                                                         // 348
    'Default X:',                                                               // 349
    'Default Y:',                                                               // 350
    'Default Z:',                                                               // 351
    'Placement Options',                                                        // 352
    'Snap Options',                                                             // 353
    'Snap alignment',                                                           // 354
    'Match distance',                                                           // 355
    'Match rotation',                                                           // 356
    'Match Y value',                                                            // 357
    'Anchor limit (units):',                                                    // 358
    'Snap tolerance (units):',                                                  // 359
    'Script Text Editor',                                                       // 360
    'Edit text',                                                                // 361
    'Format',                                                                   // 362
    'View',                                                                     // 363
    'Open from file...',                                                        // 364
    'Save to file...',                                                          // 365
    'Exit',                                                                     // 366
    'Add STR comment...',                                                       // 367
    'Replace...',                                                               // 368
    'Search and replace settings',                                              // 369
    'Find whole words and registers only',                                      // 370
    'Match case',                                                               // 371
    'Engine',                                                                   // 372
    'Extended',                                                                 // 373
    'Regular Expression',                                                       // 374
    'Wildcard',                                                                 // 375
    'Reset...',                                                                 // 376
    'Search and replace settings will be reset back to their defaults, continue?', // 377
    'Go to label...',                                                           // 378
    'Go to line...',                                                            // 379
    'Go To Label',                                                              // 380
    'Go To Line',                                                               // 381
    'Change font...',                                                           // 382
    'Change text color',                                                        // 383
    'Change text color...',                                                     // 384
    'Change background color...',                                               // 385
    'Label...',                                                                 // 386
    'Opcode...',                                                                // 387
    'Register...',                                                              // 388
    'Value...',                                                                 // 389
    'String (STR)/comment...',                                                  // 390
    'String (Argument)...',                                                     // 391
    'Change theme',                                                             // 392
    'Reset formatting...',                                                      // 393
    'Font and color options will be reset back to their defaults, continue?',   // 394
    'Font and color options for notes will be reset back to their defaults, continue?', // 395
    'Toggle notes',                                                             // 396
    'Opcode list',                                                              // 397
    'Typical register uses',                                                    // 398
    'Common functions',                                                         // 399
    'Add or edit data',                                                         // 400
    'NPC',                                                                      // 401
    'Image',                                                                    // 402
    'Enemy',                                                                    // 403
    'Float',                                                                    // 404
    'Symbol Chat',                                                              // 405
    'Vector',                                                                   // 406
    'Change',                                                                   // 407
    'Physical',                                                                 // 408
    'Resist',                                                                   // 409
    'Attack',                                                                   // 410
    'Movement',                                                                 // 411
    'Add new unused label',                                                     // 412
    'Add new unused register',                                                  // 413
    'Prepend leti/fleti arguments',                                             // 414
    'Set argument format',                                                      // 415
    'Hex',                                                                      // 416
    'Decimal',                                                                  // 417
    'Hide NOPs',                                                                // 418
    'Switch editor',                                                            // 419
    'Replace Text',                                                             // 420
    'Replace text:',                                                            // 421
    'Replace with:',                                                            // 422
    'Selection only',                                                           // 423
    'Notes',                                                                    // 424
    '[Click to place]',                                                         // 425
    '(Modifiers)',                                                              // 426
    'Placement Modifiers',                                                      // 427
    'Disable automatic Y placement',                                            // 428
    'Disable automatic section placement',                                      // 429
    'Set at default position',                                                  // 430
    'Set at offset selection position',                                         // 431
    'Snap align',                                                               // 432
    'Cancel placement',                                                         // 433
    '[Click to place - Esc: cancel]',                                           // 434
    'Error reloading quest data.',                                              // 435
    'Invalid episode number.',                                                  // 436
    'Error',                                                                    // 437
    'The new theme will be applied on next restart. Restart now?',              // 438
    'Changing the display format will cancel any unsaved changes, continue?',   // 439
    'Changing the NOP opcode display will cancel any unsaved changes, continue?', // 440
    'Build warning at line ',                                                   // 441
    'Build error at line ',                                                     // 442
    'Floating point value cannot be NAN.',                                      // 443
    'Screen size settings will be applied on next restart. Restart now?',       // 444
    'Could not generate JSON ASM list',                                         // 445
    'Could not generate JSON register list',                                    // 446
    'Label not found.',                                                         // 447
    'Vector list',                                                              // 448
    'Duration',                                                                 // 449
    'Distance',                                                                 // 450
    'Bezier curve',                                                             // 451
    'Face',                                                                     // 452
    'Sound',                                                                    // 453
    'Corners',                                                                  // 454
    'Parts',                                                                    // 455
    'Array of function contains too many entries at line ',                     // 456
    'Array of function is missing entries at line ',                            // 457
    'Floor ',                                                                   // 458
    ' room ',                                                                   // 459
    ' has more than 32 random spawn entries',                                   // 460
    'Invalid random monster weight value at row #',                             // 461
    'Invalid random monster config value at row #',                             // 462
    ' on floor ',                                                               // 463
    'Load enemy data',                                                          // 464
    'Monster type',                                                             // 465
    'Auto',                                                                     // 466
    'Hide data',                                                                // 467
    'Show data',                                                                // 468
    'Add Symbol Chat',                                                          // 469
    'Edit Symbol Chat',                                                         // 470
    'Edit Vector data',                                                         // 471
    'String data declared without a label',                                     // 472
    'String data declared in a code or Hex section',                            // 473
    'Hex data declared in a code or String section',                            // 474
    'Duplicated label: ',                                                       // 475
    'GC endianness',                                                            // 476
    'Loading Script',                                                           // 477
    'Saving Script',                                                            // 478
    'Normal',                                                                   // 479
    'Reset notes formatting...',                                                // 480
    'Disable placement indicator',                                              // 481
    'Paused',                                                                   // 482
    'Load',                                                                     // 483
    'Movement speed: ',                                                         // 484
    'Auto-section: On, ',                                                       // 485
    'Auto-section: Off, ',                                                      // 486
    'Auto-Y: On',                                                               // 487
    'Auto-Y: Off',                                                              // 488
    'Left arrow = Previous event,  Right arrow = Next event,  Space = Pause/Resume,  ESC = Exit',  // 489
    'Q = Forward, A = Backward, D = Toggle data format, F = Toggle fog effect, L/R = Auto rotate', // 490
    'Scroll = Change movement speed, S = Toggle auto section adjust, Y = Toggle auto Y adjust',    // 491
    'Edit: Hold click + CTRL = Move, + SHIFT = Up/down, + right-click = Rotate, CTRL + S = Snap',  // 492
    'ESC = Exit, CTRL + X = Show/hide the main window (Click outside of window to return to 3D)',  // 493
    'Round',                                                                    // 494
    'Triangle',                                                                 // 495
    'Square',                                                                   // 496
    'Hexa',                                                                     // 497
    'Part',                                                                     // 498
    'Table :',                                                                  // 499
    'Fullscreen mode',                                                          // 500
    'Follow selection',                                                         // 501
    'Adding References',                                                        // 502
    'Monster #',                                                                // 503
    ' is not part of a map event on floor ',                                    // 504
    'Show icon overlays',                                                       // 505
    'Creating Bitmaps',                                                         // 506
    'Map marker brightness',                                                    // 507
    'Default',                                                                  // 508
    'High',                                                                     // 509
    'Very high',                                                                // 510
    'Orientation line width',                                                   // 511
    'Clear undefined NPC labels',                                               // 512
    'All undefined NPC labels will be set to 0.<cr>If this quest will be used on BB, it''s important to select "No" and make a backup before continuing if you don''t already have one.<cr>Continue?', // 513
    'None',                                                                     // 514
    'Transform',                                                                // 515
    'Invert Y rotation',                                                        // 516
    'Mirror X position',                                                        // 517
    'Mirror Z position',                                                        // 518
    'View mode',                                                                // 519
    'List',                                                                     // 520
    'Grid',                                                                     // 521
    'Filter:',                                                                  // 522
    'Switch tab',                                                               // 523
    'Grid mode',                                                                // 524
    'Selection',                                                                // 525
    'Edit',                                                                     // 526
    'Look at target or area',                                                   // 527
    '[Click a target or area - Esc: cancel]',                                   // 528
    'Redo',                                                                     // 529
    'W = Change wave, G = Change group, Left-click + X = Rotate object X, + Z = Rotate object Z', // 530
    ' syntax comment...',                                                       // 531
    'Hide annotations',                                                         // 532
    'Define',                                                                   // 533
    'Annotation...'                                                             // 534
  );

Const FloorFog: array[0..46] of byte = (
   $21,
   $01,
   $02,
   $03,
   $04,
   $05,
   $0E,
   $0F,
   $1E,
   $1F,
   $20,
   $17,
   $10,
   $22,
   $23,
   $22,
   $13,
   $2F,
   $60,
   $61,
   $62,
   $40,
   $41,
   $18,
   $19,
   $1A,
   $1B,
   $1C,
   $28,
   $29,
   $42,
   $63,
   $64,
   $10,
   $49,
   $4B,
   $80,
   $80,
   $80,
   $80,
   $84,
   $85,
   $8E,
   $97,
   $A0,
   $21,
   $A0
);

Const NPC51Name:array[0..45,0..15] of string = (
    ('','','','','','','','','','','','','','','',''),
    ('Forest Box','Booma','Gigobooma','Gobooma','Rag Rappy','Al Rappy','Mothmant','Monest','Barbarous Wolf','Savage Wolf','Chao npc','Crashed Probe','Crashed Probe on side','CRASH','CRASH','CRASH'),
    ('Forest Box','Booma','Gigobooma','Gobooma','Rag Rappy','Al Rappy','Mothmant','Monest','Barbarous Wolf','Savage Wolf','Chao npc','Mini Hidebear','Hibdebear','Hildeblue','Crashed Probe','Crashed Probe on side'),
    ('Caves Box','Nano Dragon','Pan Arms','Hiddom','Migium','Pal Shark','Guil Shark','Evil Shark','Grass Assasin','Mini Grass Assasin','Poison Lilly','CRASH','CRASH','CRASH','CRASH','CRASH'),
    ('Caves Box','Nano Dragon','Slime','Rare Slime','Pal Shark','Guil Shark','Evil Shark','Grass Assasin','Mini Grass Assasin','Poison Lilly','CRASH','CRASH','CRASH','CRASH','CRASH','CRASH'),
    ('Caves Box','Nano Dragon','Pan Arms','Hiddom','Migium','Slime','Rare Slime','Pal Shark','Guil Shark','Evil Shark','Grass Assasin','Mini Grass Assasin','Poison Lilly','CRASH','CRASH','CRASH'),
    ('Mine Box','Canadine','canane','Gillchic','Dubchic','Garanz','Garanz broke','Sinow blue','Sino gold','CRASH','CRASH','CRASH','CRASH','CRASH','CRASH','CRASH'),
    ('Mine Box','Canadine','canane','Gillchic','Dubchic','Garanz','Garanz broke','Sinow blue','Sino gold','Litle flying robot','CRASH','CRASH','CRASH','CRASH','CRASH','CRASH'),
    ('Bulclaw','Claw','Dark Beltre','Del Saber','SoDieman','LaDieman','Dieman','Chaos sorcerer','Pillar Trap','Poison bulb','CRASH','CRASH','CRASH','CRASH','CRASH','CRASH'),
    ('Chaos brigner','Del Saber','SoDieman','LaDieman','Dieman','Pillar Trap','Poison bulb','CRASH','CRASH','CRASH','CRASH','CRASH','CRASH','CRASH','CRASH','CRASH'),
    ('Dark Beltre','Chaos brigner','SoDieman','LaDieman','Dieman','Chaos sorcerer','Pillar Trap','Poison bulb','CRASH','CRASH','CRASH','CRASH','CRASH','CRASH','CRASH','CRASH'),
    ('','','','','','','','','','','','','','','',''),
    ('','','','','','','','','','','','','','','',''),
    ('','','','','','','','','','','','','','','',''),
    ('','','','','','','','','','','','','','','',''),
    ('','','','','','','','','','','','','','','',''),
    ('','','','','','','','','','','','','','','',''),
    ('','','','','','','','','','','','','','','',''),
    ('','','','','','','','','','','','','','','',''),
    ('Rappy','Love rappy','Mothmant','Monest','Dark Beltre','SoDieman','LaDieman','Dieman','Mini Hidebear','Hibdebear','Hildeblue','Grass Assasin','Mini Grass Assasin','Poison Lilly','Pillar Trap','CRASH'),
    ('Rappy','Love rappy','Mothmant','Monest','Dark Beltre','SoDieman','LaDieman','Dieman','Mini Hidebear','Hibdebear','Hildeblue','Grass Assasin','Mini Grass Assasin','Poison Lilly','Pillar Trap','CRASH'),
    ('Barbarous Wolf','Savage Wolf','Del Saber','Gillchic','Dubchic','Garanz','Garanz broke','Pan Arms','Hiddom','Migium','Pillar Trap','CRASH','CRASH','CRASH','CRASH','CRASH'),
    ('Barbarous Wolf','Savage Wolf','Del Saber','Gillchic','Dubchic','Pan Arms','Hiddom','Migium','Chaos sorcerer','Pillar Trap','CRASH','CRASH','CRASH','CRASH','CRASH','CRASH'),
    ('Rappy','Love rappy','Ul gibbon','Zol Gibbon','Gee','CRASH','Merillias','CRASH','Meriltas','Gee nest','Small Rock','Small plant','Gi Gue','Mericarol','Gibbles','CRASH'),
    ('Rappy','Love rappy','Ul gibbon','Zol Gibbon','Gee','CRASH','Merillias','CRASH','Meriltas','Gee nest','Small Rock','Small plant','Gi Gue','Mericarol','Gibbles','CRASH'),
    ('Rappy','Love rappy','Ul gibbon','Zol Gibbon','Gee','CRASH','Merillias','CRASH','Meriltas','Gee nest','Small Rock','Small plant','Gi Gue','Mericarol','Gibbles','CRASH'),
    ('Rappy','Love rappy','Ul gibbon','Zol Gibbon','Gee','CRASH','Merillias','CRASH','Meriltas','Gee nest','Small Rock','Small plant','Gi Gue','Mericarol','Gibbles','CRASH'),
    ('Rappy','Love rappy','Ul gibbon','Zol Gibbon','Gee','CRASH','Merillias','CRASH','Meriltas','Gee nest','Small Rock','Small plant','Gi Gue','Mericarol','Gibbles','CRASH'),
    ('Seabeb Box','Recon','ReconBox','Dolphin','Dolmolm','Delbiter','Deldebth','Deldebth form 2','Sinow Zoa','Sinow zele','Sinow Zoa dead','Sinow Zele dead','Morfos','Dolmdarl','CRASH','CRASH'),
    ('Seabeb Box','Recon','ReconBox','Dolphin','Dolmolm','Delbiter','Deldebth','Deldebth form 2','Sinow Zoa','Sinow zele','Sinow Zoa dead','Sinow Zele dead','Morfos','Dolmdarl','CRASH','CRASH'),
    ('','','','','','','','','','','','','','','',''),
    ('','','','','','','','','','','','','','','',''),
    ('','','','','','','','','','','','','','','',''),
    ('','','','','','','','','','','','','','','',''),
    ('Rappy','Love rappy','Recon','Reconbox','CRASH','Zol Gibbon','Gee','Nights sit','Nights Fly','Merillias','Meriltas','Gee nest','Small Rock','Small plant','Dolmolm','Dolmdarl'),
    ('Recon','Recon box','Del Lilly','Gee nest','Gi Gue','Mericarol','Ill Gill','Gibbles','Delbiter','Epsilon','CRASH','CRASH','CRASH','CRASH','CRASH','CRASH'),
    ('','','','','','','','','','','','','','','',''),
    ('','','','','','','','','','','','','','','',''),
    ('','','','','','','','','','','','','','','',''),
    ('','','','','','','','','','','','','','','',''),
    ('','','','','','','','','','','','','','','',''),
    ('','','','','','','','','','','','','','','',''),
    ('','','','','','','','','','','','','','','',''),
    ('','','','','','','','','','','','','','','',''),
    ('','','','','','','','','','','','','','','',''),
    ('','','','','','','','','','','','','','','','')    );

    NPC51File:array[0..45,0..15] of integer = (
    (112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112),
    (113,9,11,10,5,6,3,4,8,7,114,116,117,112,112,112),
    (113,9,11,10,5,6,3,4,8,7,114,115,1,2,116,117),
    (113,15,21,23,22,17,18,16,12,118,13,112,112,112,112,112),
    (113,15,19,20,17,18,16,12,118,13,112,112,112,112,112,112),
    (113,15,21,23,22,19,20,17,18,16,12,118,13,112,112,112),
    (113,28,29,50,24,25,25,26,27,112,112,112,112,112,112,112),
    (113,28,29,50,24,25,25,26,27,119,112,112,112,112,112,112),
    (40,39,37,30,43,42,41,31,120,121,112,112,112,112,112,112),
    (36,30,43,42,41,120,121,112,112,112,112,112,112,112,112,112),
    (37,36,43,42,41,31,120,121,112,112,112,112,112,112,112,112),
    (112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112),
    (112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112),
    (112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112),
    (112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112),
    (112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112),
    (112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112),
    (112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112),
    (112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112),
    (5,6,3,4,37,43,42,41,115,1,2,12,118,121,120,112),
    (5,6,3,4,37,43,42,41,115,1,2,12,118,121,120,112),
    (8,7,30,50,24,25,25,21,23,22,120,112,112,112,112,112),
    (8,7,30,50,24,21,23,22,31,120,112,112,112,112,112,112),
    (5,51,59,60,54,112,52,112,53,122,123,124,55,56,61,112),
    (5,51,59,60,54,112,52,112,53,122,123,124,55,56,61,112),
    (5,51,59,60,54,112,52,112,53,122,123,124,55,56,61,112),
    (5,51,59,60,54,112,52,112,53,122,123,124,55,56,61,112),
    (5,51,59,60,54,112,52,112,53,122,123,124,55,56,61,112),
    (125,68,67,127,64,72,71,126,69,70,69,70,66,65,112,112),
    (125,68,67,127,64,72,71,126,69,70,69,70,66,65,112,112),
    (112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112),
    (112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112),
    (112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112),
    (112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112),
    (5,51,68,67,112,60,54,128,128,52,53,122,123,124,64,65),
    (68,67,83,122,55,56,82,61,72,84,112,112,112,112,112,112),
    (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
    (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
    (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
    (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
    (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
    (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
    (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
    (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
    (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
    (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)    );

implementation

end.
