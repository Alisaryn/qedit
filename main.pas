unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ImgList, Dialogs, Menus, StdCtrls, ExtCtrls, CheckLst, ComCtrls,
  ShellApi, D3DEngin, registry, Spin, System.ImageList, System.Actions,
  Vcl.ActnList;

const
  gcstring = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ!"/$%?&*()_+-=#qazwsxedcrfvtgbyhnujmik,ol.p;^`<>';
  dummy1 = 'Why are you hex editing this file?'#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0;
  dummy2 = 'pikachu''s are gay since there is no femal version of them!'#0#0#0#0#0#0#0#0;
  dummy3 = 'Lee: the cake is not a LIE'#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0;
  dummy4 = 'Schthack is a lie...'#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0;
  dummy5 = 'There is no such thing as a Lee.'#0#0#0#0#0#0#0#0#0#0#0#0;
  dummy6 = 'Mario kart wii rules!!!'#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0;
  dummy7 = 'FireFox276: I''ve said lots of stupid things in my time!'#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0;
  dummy8 = 'We think PSO V2 sux realy bad.... *get killed by Ives*'#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0;

  {
    add these to the scaled items:

    dec 133 Light rays
    dec 267 Spark Machine

    and these to radi ones;
    dec 340 Popup Trap (No Tech)
    dec 913 Heat
    dec 359 Popup Traps (techs)
  }
  ScaleCount = 7;
  ScaleItm: array [0 .. 10] of integer = (192, 222, 257, 769, 133, 267, 26, 0, 0, 0, 0);
  RotateCount = 7;
  RotateItm: array [0 .. 10] of integer = (192, 222, 257, 323, 140, 135, 26, 0, 0, 0, 0);
  subtypeditemcount = 12;
  subtypeditem: array [0 .. 11] of integer = (135, 769, 770, 81, 527, 528, 547, 902, 139, 69, 911, 531); // 139
  subtypeditemV: array [0 .. 11] of integer = (1, 2, 2, 2, 5, 5, 2, 2, 4, 3, 2, 4);
  // 1 = active range, 2 = action, 3 = unk13
  subtypeditemMax: array [0 .. 11] of integer = (1, 2, 2, 3, 1, 1, 1, 2, 1, 1, 1, 2);
  ItemRange: array [0 .. 12] of integer = (8, 18, 24, 87, 352, 913, 340, 913, 359, 7, 14, 34, 36); // 37 or 33,

  ColorItem: array [0 .. 11] of integer = (129, 130, 131, 132, 150, 151, 333, 334, 335, 336, 337, 128);
  ColorPos: array [0 .. 11] of integer = (9, 4, 4, 9, 4, 4, 8, 8, 8, 8, 8, 7);
  ColorMax: array [0 .. 11] of integer = (9, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 9);
  EnemyID: array [0 .. 57] of integer = (68, 67, 64, 65, 128, 129, 131, 133, 163, 97, 99, 98, 96, 168, 166, 165, 160,
    162, 164, 192, 197, 193, 194, 200, 66, 132, 130, 100, 101, 161, 167, 223, 213, 212, 215, 217, 218, 214, 222, 221,
    225, 224, 216, 219, 220, 202, 201, 203, 204, 273, 277, 276, 272, 278, 274, 275, 281, 249);

  PsoMapV: array [0 .. $2D] of byte = (1, 1, 1, 6, 6, 6, 6, 6, 5, 5, 5, 1, 1, 1, 1, 15, 3, 3 // ep1
    , 1, 3, 3, 3, 3, 1, 1, 1, 3, 1, 3, 3, 1, 1, 1, 1, 1, 5, 1, 1, 1, 1, 1, 3, 1, 3, 1, 1);

  quest_sufix: array [0 .. 4] of ansistring = ('_j', '_e', '_g', '_f', '_s');

type
  TPlayer = Record
    RecKeyPos, KeyPos: integer;
    Key: array [0 .. 2, 0 .. $500] of dword;
  end;

  TAsmFnc = Record
    fnc: word;
    name: ansistring;
    order, ver: word;
    arg: array [0 .. 9] of word;
  end;

  TFloorIDData = Record
    count: array [0 .. 3] of integer;
    ids: array [0 .. 3, 0 .. 500] of word;
  end;

  TPSOStack = Record
    DataType: integer;
    value: dword;
    str: ansistring;
  end;

  TMonster = Record
    Skin: word;
    Unknow1: word;
    unknow2: dword;
    unknow3: word;
    unknow4: word;
    map_section: word;
    Unknow5: word;
    unknow6: dword;
    Pos_X: Single;
    Pos_Z: Single;
    Pos_Y: Single;
    unknow7: dword;
    Direction: dword;
    unknow8: dword;
    // unknow9 : dword;
    Movement_data: Single;
    Unknow10: Single;
    unknow11: Single;
    Char_id: Single;
    Action: Single;
    Movement_flag: dword; // 01 00 00 00 = can move
    unknow_flag: dword;
  end;

  TRoomEntry = Record
    Offset: dword;
    v1, v2, v3, v4: Single;
    flag: dword;
  end;

  TfogData = Record // Fog data 64 bytes
    F1, F2: dword;
    F3, F4, F5: Single;
    F6: dword;
    F7, F8, F9: Single;
    F10: dword;
    F11, F12, F13: Single;
    F14: dword;
    F15, F16: word;
    F17: dword;
  End;

  TMapSection = Record
    section: dword;
    dx, dz, dy: Single;
    Unknow1: dword;
    reverse_data: dword;
    unknow3: dword;
    unknow4: Single;
    Offset: dword;
    Unknow5: dword;
    unknow6: dword;
    unknow7: dword;
    unknow8: dword;
    unknow9: dword;
    Unknow10: dword;
    unknow11: dword;
    unknow12: dword;
  end;

  TObj = Record
    Skin: word;
    Unknow1: word;
    unknow2: dword;
    id: word;
    grp: word;
    map_section: word;
    unknow4: word;
    Pos_X: Single;
    Pos_Z: Single;
    Pos_Y: Single;
    Unknow5: dword;
    unknow6: dword;
    unknow7: dword;
    unknow8: Single;
    unknow9: Single;
    Unknow10: Single;
    obj_id: dword;
    Action: dword;
    unknow13: dword;
    unknow14: dword;
  end;

  T3DPoint = Record
    x, z, y: Single;
  end;

  TQSTFile = record
    name: ansistring;
    data: pansichar;
    size, from: integer;
  end;

  TFloor = Record
    Monster: array [0 .. 1000] of TMonster;
    Obj: array [0 .. 1000] of TObj;
    Unknow, d04, d05: array [0 .. 50000] of byte;
    MonsterCount, ObjCount, UnknowCount, d04count, d05count: integer;
    floorid: integer;
  end;

  TNPCGroupeHeader = Record
    flag: dword;
    TotalSize: dword;
    floorid: dword;
    DataLength: dword;
  end;

  TMonsterTemplate = record
    name: ansistring;
    data: TMonster;
  end;

  TObjTemplate = record
    name: ansistring;
    data: TObj;
  end;

  TForm1 = class(Tform)
    GroupBox1: TGroupBox;
    CheckListBox1: TCheckListBox;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    Quest1: TMenuItem;
    Properties1: TMenuItem;
    itle1: TMenuItem;
    Description1: TMenuItem;
    Information1: TMenuItem;
    Load1: TMenuItem;
    Save1: TMenuItem;
    N1: TMenuItem;
    Quit1: TMenuItem;
    ListBox2: TListBox;
    Label3: TLabel;
    Panel1: TPanel;
    Image1: TImage;
    Label4: TLabel;
    Panel2: TPanel;
    Image2: TImage;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Label6: TLabel;
    OpenDialog1: TOpenDialog;
    Scrypt1: TMenuItem;
    ViewScrypt1: TMenuItem;
    Button7: TButton;
    Button8: TButton;
    SaveDialog1: TSaveDialog;
    Setting1: TMenuItem;
    Button9: TButton;
    CheckBox1: TCheckBox;
    Button10: TButton;
    New1: TMenuItem;
    Episode11: TMenuItem;
    Episode21: TMenuItem;
    Episode41: TMenuItem;
    N2: TMenuItem;
    Button11: TButton;
    Label5: TLabel;
    ool1: TMenuItem;
    OpenDialog2: TOpenDialog;
    SaveDialog2: TSaveDialog;
    Fixbadidonitem1: TMenuItem;
    ImageList1: TImageList;
    N4: TMenuItem;
    N3DView1: TMenuItem;
    Button12: TButton;
    About1: TMenuItem;
    N3DSetup1: TMenuItem;
    Itemslistbb1: TMenuItem;
    help1: TMenuItem;
    PopupMenu1: TPopupMenu;
    EnemyWave1: TMenuItem;
    Itemsgroupe1: TMenuItem;
    Compatibilitycheck1: TMenuItem;
    N5: TMenuItem;
    Export1: TMenuItem;
    Import1: TMenuItem;
    PopupMenu2: TPopupMenu;
    Layout11: TMenuItem;
    Checkforupdates1: TMenuItem;
    Label7: TLabel;
    ComboBox1: TComboBox;
    Timer1: TTimer;
    Language1: TMenuItem;
    N6: TMenuItem;
    English1: TMenuItem;
    French1: TMenuItem;
    N7: TMenuItem;
    Exporttextfortranslation1: TMenuItem;
    Importtextfromtranslation1: TMenuItem;
    SaveDialog3: TSaveDialog;
    OpenDialog3: TOpenDialog;
    spanish1: TMenuItem;
    Floorfilter1: TMenuItem;
    Label2: TLabel;
    ListBox1: TListBox;
    Floor1: TMenuItem;
    Sort1: TMenuItem;
    Exportdata1: TMenuItem;
    Importdata1: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    Events1: TMenuItem;
    Randommonsters1: TMenuItem;
    Monster1: TMenuItem;
    Objects1: TMenuItem;
    Byroom1: TMenuItem;
    byWave1: TMenuItem;
    byType1: TMenuItem;
    byRoom2: TMenuItem;
    byType2: TMenuItem;
    ActionList1: TActionList;
    Action1: TAction;
    Monstercount1: TMenuItem;
    smNew: TMenuItem;
    smEdit: TMenuItem;
    smDelete: TMenuItem;
    smDrag: TMenuItem;
    smNewMonster: TMenuItem;
    smNewItem: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    smUndo: TMenuItem;
    smSnap: TMenuItem;
    smPlacement: TMenuItem;
    N12: TMenuItem;
    smMove: TMenuItem;
    Copylastmonster1: TMenuItem;
    Copylastitem1: TMenuItem;
    lblStatus: TLabel;
    lblModifiers: TLabel;
    Hotkeys1: TMenuItem;
    Newmonster1: TMenuItem;
    Newitem1: TMenuItem;
    Copymonster1: TMenuItem;
    Copyitem1: TMenuItem;
    Delete1: TMenuItem;
    Edit1: TMenuItem;
    Move1: TMenuItem;
    Undo1: TMenuItem;
    Options1: TMenuItem;
    Cancelplacement1: TMenuItem;
    PopupMenu3: TPopupMenu;
    smDisableIndicator: TMenuItem;
    Hidemainwindow1: TMenuItem;
    procedure Quit1Click(Sender: TObject);
    procedure Load1Click(Sender: TObject);
    procedure CheckListBox1Click(Sender: TObject);
    procedure DrawMap;
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure itle1Click(Sender: TObject);
    procedure Description1Click(Sender: TObject);
    procedure DrawBBRELFile(filename: ansistring);
    procedure DrawPCRELFile(filename: ansistring);
    procedure DrawZBBRELFile(filename: ansistring; px, py, pz: double);
    procedure ViewScrypt1Click(Sender: TObject);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState; x, y: integer);
    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; x, y: integer);
    procedure Image2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; x, y: integer);
    procedure FormShow(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Setting1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Episode11Click(Sender: TObject);
    procedure Episode21Click(Sender: TObject);
    procedure Episode41Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure SetUndow();
    procedure Button1Click(Sender: TObject);
    procedure ConvertBINDATtooffline1Click(Sender: TObject);
    procedure Fixbadidonitem1Click(Sender: TObject);
    procedure ConvertBINDATtoOnline1Click(Sender: TObject);
    procedure Information1Click(Sender: TObject);
    procedure DrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure N3DView1Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure N3DSetup1Click(Sender: TObject);
    procedure Listitem1Click(Sender: TObject);
    procedure Itemslistbb1Click(Sender: TObject);
    procedure Nuuuuuuuuuuu1Click(Sender: TObject);
    procedure help1Click(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure EnemyWave1Click(Sender: TObject);
    procedure Itemsgroupe1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Compatibilitycheck1Click(Sender: TObject);
    procedure Export1Click(Sender: TObject);
    procedure Import1Click(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure Layout11Click(Sender: TObject);
    procedure Checkforupdates1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure English1Click(Sender: TObject);
    procedure French1Click(Sender: TObject);
    procedure Exporttextfortranslation1Click(Sender: TObject);
    procedure Importtextfromtranslation1Click(Sender: TObject);
    procedure spanish1Click(Sender: TObject);
    procedure Floorfilter1Click(Sender: TObject);
    Function YFromBBRELFile(vpx, vpz: Single): Single;
    procedure FormResize(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure Byroom1Click(Sender: TObject);
    procedure byWave1Click(Sender: TObject);
    procedure byType1Click(Sender: TObject);
    procedure byRoom2Click(Sender: TObject);
    procedure byType2Click(Sender: TObject);
    procedure Monstercount1Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure smEditClick(Sender: TObject);
    procedure smNewMonsterClick(Sender: TObject);
    procedure smNewItemClick(Sender: TObject);
    procedure smDeleteClick(Sender: TObject);
    procedure smUndoClick(Sender: TObject);
    procedure smDragClick(Sender: TObject);
    procedure smSnapClick(Sender: TObject);
    procedure smPlacementClick(Sender: TObject);
    procedure Hotkeys1Click(Sender: TObject);
    procedure smMoveClick(Sender: TObject);
    procedure Copylastmonster1Click(Sender: TObject);
    procedure Copylastitem1Click(Sender: TObject);
    procedure lblModifiersClick(Sender: TObject);
    procedure Newmonster1Click(Sender: TObject);
    procedure Newitem1Click(Sender: TObject);
    procedure Copymonster1Click(Sender: TObject);
    procedure Copyitem1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Move1Click(Sender: TObject);
    procedure Undo1Click(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure Cancelplacement1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure smDisableIndicatorClick(Sender: TObject);
    procedure Hidemainwindow1Click(Sender: TObject);


  private
    procedure MenueDrawItemX(xMenu: TMenu);
    { Private declarations }
  public
    { Public declarations }
  end;

function hextoint(x: ansistring): int64;
function unitochar(s: widestring; max: integer): ansistring;
function Generateobj(m: TObj; p: integer): t3ditem;
function chartouni(s: ansistring): ansistring;
Function PSOEnc(s: ansistring; user, buff: integer): ansistring;
Function CreateKey(val: dword; user: integer): Boolean;
Function GetObjName(id: integer): ansistring;
Function GetObjParam(id: integer): tstringlist;
procedure MenueDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
Function GetMonsterParam(id: integer): tstringlist;
Function GetMonsterName(id: integer): ansistring;
procedure ClearShadow;
Function GetLanguageString(id: integer): ansistring;
procedure SetMonsterDefaults();
procedure SetObjectDefaults();
procedure ShowIndicator();
procedure HideIndicator();
procedure AdjustDistanceX(target: integer);
procedure AdjustDistanceY(target: integer);

var
  Form1: TForm1;
  Floor: array [0 .. 40] of TFloor;
  FloorUn: array [0 .. 20, 0 .. 40] of TFloor;
  undocount: integer = 0;
  sfloor, Selected, stype: integer;
  Zoom: double;
  path: ansistring;
  Title, Info, Desc: widestring;
  language, qnum, sms: word;
  fd, mpcx, mpcy, MoveSel, MoveType: integer;
  MidP, midpz: array [0 .. 25566] of TPoint;
  mapfilenam: ansistring;
  miz: array [0 .. 25566] of integer;
  rev: array [0 .. 25566] of dword;
  MidPU: array [0 .. 25566] of Boolean;
  // fncoff:array[0..100000] of dword;
  mapfile, mapxvmfile: array [0 .. 40] of ansistring;
  lmpx, lmpy, mpx, mpy, mdown, mdrag, asmcount: integer;
  asmcode: array [0 .. 1000] of TAsmFnc;
  AsmRef: array [0 .. 100000] of dword;
  AsmData: Array [0 .. 4000000] of byte;
  isdc: Boolean;
  regis: array [0 .. 255] of dword;
  AsmMode: integer;
  curepi: integer;
  ctrldw, shiftdw, altdw, ddown, fdown, sdown, firstdrop: Boolean;
  ObjTemplate: array [0 .. 400] of TObjTemplate;
  MonsterTemplate: array [0 .. 400] of TMonsterTemplate;
  player: array [0 .. 1] of TPlayer;
  // zmap:array[-800..800,-800..800] of short;
  jis, uni16: array of ansistring;
  jiscount: integer;
  datablock, datablockt: array [0 .. 1000] of integer;
  qstfile: array [0 .. 99] of TQSTFile;
  qstfilecount: integer;
  myscreen: TPikaEngine;
  objscreen: TPikaEngine = nil;
  mymap: Tpikamap;
  MyMonst, MyObj: array of t3ditem;
  MyMonstCount, MyObjCount: integer;
  BaseObj, BaseMonster: array [0 .. 50] of t3ditem;
  BaseObjID, BaseMonsterID: array [0 .. 50] of integer;
  have3d: Boolean;
  ppx, ppy, ppz, vr, vz: Single;
  initied3d: Boolean = false;
  shiftdown: Boolean = false;
  ItemsName: tstringlist;
  FloorMonsID, FloorObjID: array [0 .. 50] of TFloorIDData;
  presetm, preseti: integer;
  StringTest: tstringlist;
  sel3d, sel3d2, objitm: t3ditem;
  BBData: array [0 .. 931] of dword;
  BBRelFileName: ansistring;
  BBRelFile: TMemoryStream = nil;
  BBRelBmp: TBitmap;
  TrData, TrFnc, TrReg, Tropc, TrTmp: ttreenode;
  TsData, TsFnc, TsReg, Tsopc, Monsterini: tstringlist;
  showwave: integer = -1;
  showgrp: integer = -1;
  asmdatas, asmrefs: integer;
  MyMonstZCount: integer = -1;
  MyMonstZ: array of integer;
  MiniMapOrg: TPoint;
  isedited: Boolean = false;
  FullQuestFile: ansistring = '';
  LanguageString: tstringlist = nil;
  FFilter: integer = 3;

  FogEntry: array [0 .. 255] of TfogData;
  particle: tpikasurface;
  testflag: integer;
  mmy: integer = 116;
  mmx: integer = 197;
  imgclickstart: dword = 0;
  lastimgclick: dword = 0;
  lastloadformat: integer = 3;
  lsatsaveformat: integer = 4;
  snapvalue: integer = 10;
  dragenabled: Boolean = false;
  snapenabled: Boolean = false;
  autoaxis: Boolean = false;
  snaprotate: Boolean = false;
  snapdistance: Boolean = false;
  disableindicator: Boolean = false;
  fullscreen: Boolean = false;
  OffsetX: single = 0.0;
  OffsetY: single = 0.0;
  OffsetZ: single = 0.0;
  DefaultSect: integer = 0;
  DefaultX: single = 0.0;
  DefaultY: single = 0.0;
  DefaultZ: single = 0.0;

implementation

uses FTitle, FInfo, Unit1, FScrypt, TCom, FSetting, FEdit, Unit8, Unit9,
  Unit10, Unit11, PikaPackage, Unit12, Unit13, Unit14, Unit15, Unit16,
  Unit17, Unit18, Unit19, FCompat, MyConst, Unit29, crc32, EnemyStat,
  FEnemyAttack, FEnemyMov, FEnemyResist, FFloatEdit, NPCBuild, Unit22,
  FFFilter, FMonsDet, Unit23, FSymbolChat, FAsmModeSel, FPlacement, FHotkeys;

{$R *.dfm}

Procedure SetInterfaceText;
begin
  Form1.Floorfilter1.Caption := GetLanguageString(296);
  form30.Caption := GetLanguageString(296);
  form30.Label1.Caption := GetLanguageString(297);
  form30.Button1.Caption := GetLanguageString(117);
  form30.Button2.Caption := GetLanguageString(118);
  Form1.Quest1.Caption := GetLanguageString(1);
  Form1.Properties1.Caption := GetLanguageString(2);
  Form1.Scrypt1.Caption := GetLanguageString(3);
  Form1.ool1.Caption := GetLanguageString(4);
  Form1.New1.Caption := GetLanguageString(5);
  Form1.Episode11.Caption := GetLanguageString(6);
  Form1.Episode21.Caption := GetLanguageString(7);
  Form1.Episode41.Caption := GetLanguageString(8);
  Form1.Load1.Caption := GetLanguageString(9);
  Form1.Save1.Caption := GetLanguageString(10);
  Form1.Language1.Caption := GetLanguageString(11);
  Form1.Quit1.Caption := GetLanguageString(12);
  Form1.itle1.Caption := GetLanguageString(13);
  Form1.Description1.Caption := GetLanguageString(14);
  Form1.Information1.Caption := GetLanguageString(15);
  Form1.Setting1.Caption := GetLanguageString(16);
  Form1.ViewScrypt1.Caption := GetLanguageString(17);
  Form1.Export1.Caption := GetLanguageString(18);
  Form1.Import1.Caption := GetLanguageString(19);
  Form1.Fixbadidonitem1.Caption := GetLanguageString(20);
  Form1.Compatibilitycheck1.Caption := GetLanguageString(21);
  Form1.Itemslistbb1.Caption := GetLanguageString(22);
  Form1.N3DView1.Caption := GetLanguageString(23);
  Form1.N3DSetup1.Caption := GetLanguageString(24);
  Form1.About1.Caption := GetLanguageString(25);
  Form1.Checkforupdates1.Caption := GetLanguageString(26);
  Form1.help1.Caption := GetLanguageString(27);
  Form1.GroupBox1.Caption := GetLanguageString(28);
  Form1.Label1.Caption := GetLanguageString(29);
  Form1.Button7.Caption := GetLanguageString(30);
  Form1.Button8.Caption := GetLanguageString(31);
  Form1.Button10.Caption := GetLanguageString(32);
  Form1.Button12.Caption := GetLanguageString(33);
  Form1.Label2.Caption := GetLanguageString(34);
  Form1.Label3.Caption := GetLanguageString(35);
  Form1.Label4.Caption := GetLanguageString(36);
  Form1.CheckBox1.Caption := GetLanguageString(37);
  Form1.Label6.Caption := GetLanguageString(38) + ' 100%';
  Form1.Label7.Caption := GetLanguageString(39);
  Form1.Button9.Caption := GetLanguageString(40);
  Form1.Button4.Caption := GetLanguageString(41);
  Form1.Button3.Caption := GetLanguageString(42);
  Form1.Button2.Caption := GetLanguageString(43);
  Form1.Button1.Caption := GetLanguageString(44);
  Form1.Button11.Caption := GetLanguageString(45);
  form21.Button1.Caption := GetLanguageString(116);
  form21.Button2.Caption := GetLanguageString(117);
  form21.Button3.Caption := GetLanguageString(118);
  form21.Caption := GetLanguageString(119);
  form27.Caption := GetLanguageString(120);
  form27.Label1.Caption := GetLanguageString(121);
  form27.Button1.Caption := GetLanguageString(113);
  form7.Caption := GetLanguageString(122);
  form7.Label1.Caption := GetLanguageString(123);
  form7.Label2.Caption := GetLanguageString(124);

  form25.Button1.Caption := GetLanguageString(116);
  form25.Button3.Caption := GetLanguageString(117);
  form25.Button2.Caption := GetLanguageString(118);
  form25.Caption := GetLanguageString(125);
  form26.Button3.Caption := GetLanguageString(116);
  form26.Button1.Caption := GetLanguageString(117);
  form26.Button2.Caption := GetLanguageString(118);
  form26.Caption := GetLanguageString(126);
  form24.Button1.Caption := GetLanguageString(116);
  form24.Button3.Caption := GetLanguageString(117);
  form24.Button2.Caption := GetLanguageString(118);
  form24.Caption := GetLanguageString(127);
  form28.Button1.Caption := GetLanguageString(118);
  form28.Button2.Caption := GetLanguageString(117);
  form28.Caption := GetLanguageString(129);
  form3.Caption := GetLanguageString(130);
  form3.Label1.Caption := GetLanguageString(131);
  form3.Button1.Caption := GetLanguageString(117);
  TrData.Text := GetLanguageString(133);
  TrFnc.Text := GetLanguageString(132);
  TrReg.Text := GetLanguageString(134);
  Tropc.Text := GetLanguageString(135);
  refname[0] := GetLanguageString(136);
  refname[1] := GetLanguageString(137);
  refname[2] := GetLanguageString(138);
  refname[3] := GetLanguageString(139);
  refname[4] := GetLanguageString(140);
  refname[5] := GetLanguageString(141);
  refname[6] := GetLanguageString(142);
  refname[7] := GetLanguageString(143);
  refname[8] := GetLanguageString(144);
  refname[9] := GetLanguageString(145);

  form4.Caption := GetLanguageString(146);
  form4.StatusBar1.Panels.Items[0].Text := GetLanguageString(147);
  form4.Button1.Caption := GetLanguageString(148);
  form4.Button2.Caption := GetLanguageString(149);
  form4.Button5.Caption := GetLanguageString(150);
  form4.Button3.Caption := GetLanguageString(151);
  form4.Button4.Caption := GetLanguageString(152);
  form4.Button7.Caption := GetLanguageString(153);
  form4.Button9.Caption := GetLanguageString(154);
  form4.Button8.Caption := GetLanguageString(155);
  form4.Button6.Caption := GetLanguageString(156);
  form4.Data1.Caption := GetLanguageString(157);
  form4.Section1.Caption := GetLanguageString(158);
  form4.Copy1.Caption := GetLanguageString(159);
  form4.Cut1.Caption := GetLanguageString(160);
  form4.Past1.Caption := GetLanguageString(161);
  form4.Delete1.Caption := GetLanguageString(162);
  form4.NPCEdit1.Caption := GetLanguageString(163);
  form4.Image1.Caption := GetLanguageString(164);
  form4.Saveimage1.Caption := GetLanguageString(165);
  form4.Editenemyphysicaldata1.Caption := GetLanguageString(166);
  form4.EditEnemyresistancedata1.Caption := GetLanguageString(167);
  form4.EditEnemyattackdata1.Caption := GetLanguageString(168);
  form4.EditEnemymovementdata1.Caption := GetLanguageString(169);
  form4.EditFloatdata1.Caption := GetLanguageString(170);
  form4.Delete2.Caption := GetLanguageString(171);
  form4.Ascode1.Caption := GetLanguageString(172);
  form4.AsHex1.Caption := GetLanguageString(173);
  form4.AsStrdata1.Caption := GetLanguageString(174);

  form6.Caption := GetLanguageString(191);
  form6.Button1.Caption := GetLanguageString(117);
  form6.Label1.Caption := GetLanguageString(192);
  form6.Label2.Caption := GetLanguageString(193);
  form2.Caption := GetLanguageString(194);
  form2.Button1.Caption := GetLanguageString(117);
  form2.Label1.Caption := GetLanguageString(195);
  form20.Caption := GetLanguageString(206);
  form20.Button15.Caption := GetLanguageString(117);
  form20.Button16.Caption := GetLanguageString(118);

  form5.Caption := GetLanguageString(238);
  form5.Label1.Caption := GetLanguageString(239);
  form5.Label6.Caption := GetLanguageString(240);
  form5.Button1.Caption := GetLanguageString(241);
  form5.Button2.Caption := GetLanguageString(118);

  form10.Caption := GetLanguageString(242);
  form10.Label1.Caption := GetLanguageString(243);
  form10.Button1.Caption := GetLanguageString(244);
  form10.Button2.Caption := GetLanguageString(118);

  form9.Caption := GetLanguageString(245);
  form9.Label1.Caption := GetLanguageString(246);
  form9.Label2.Caption := GetLanguageString(247);
  form9.Button1.Caption := GetLanguageString(244);
  form9.Button2.Caption := GetLanguageString(118);

  form8.Caption := GetLanguageString(249);
  form8.Label1.Caption := GetLanguageString(250);
  form8.Button1.Caption := GetLanguageString(251);
  form8.Button2.Caption := GetLanguageString(117);
  form8.Button3.Caption := GetLanguageString(118);

  form11.Caption := GetLanguageString(252);
  form11.Label1.Caption := GetLanguageString(253);
  form11.Button1.Caption := GetLanguageString(117);

  form12.Caption := GetLanguageString(256);
  form12.Label1.Caption := GetLanguageString(257);
  form12.Button1.Caption := GetLanguageString(113);
  form12.Button2.Caption := GetLanguageString(18);
  form12.Button3.Caption := GetLanguageString(19);
  form12.Button4.Caption := GetLanguageString(244);
  form12.Button5.Caption := GetLanguageString(152);
  form12.Button6.Caption := GetLanguageString(258);

  form13.Caption := GetLanguageString(259);
  form14.Caption := GetLanguageString(260);

  form15.Caption := GetLanguageString(261);
  form15.TabSheet1.Caption := GetLanguageString(262);
  form15.TabSheet2.Caption := GetLanguageString(263);
  form15.Label1.Caption := GetLanguageString(264);
  form15.Label2.Caption := GetLanguageString(265);
  form15.Label3.Caption := GetLanguageString(266);
  form15.Label4.Caption := GetLanguageString(267);

  form16.Caption := GetLanguageString(268);
  form16.Label1.Caption := GetLanguageString(269);
  form16.Label2.Caption := GetLanguageString(270);
  form16.Memo1.Text := GetLanguageString(271);
  form16.Button1.Caption := GetLanguageString(113);
  form19.Caption := GetLanguageString(272);
  form19.Button1.Caption := GetLanguageString(113);

  form17.Caption := GetLanguageString(273);
  form17.Label1.Caption := GetLanguageString(274);
  form17.Label2.Caption := GetLanguageString(275);
  form17.Label4.Caption := GetLanguageString(276);
  form17.Button1.Caption := GetLanguageString(277);
  form17.CheckBox1.Caption := GetLanguageString(278);
  form17.CheckBox2.Caption := GetLanguageString(279);

  form22.Caption := GetLanguageString(280);
  form22.Label1.Caption := GetLanguageString(281);
  form22.Label2.Caption := GetLanguageString(282);
  form22.Label3.Caption := GetLanguageString(283);
  form22.Button1.Caption := GetLanguageString(118);
  form22.Button2.Caption := GetLanguageString(9);

  form26.Caption := GetLanguageString(284);
  form26.Button2.Caption := GetLanguageString(118);
  form26.Button1.Caption := GetLanguageString(117);

  form29.Caption := GetLanguageString(293);
  form29.Memo2.Text := GetLanguageString(292);
  form29.Button1.Caption := GetLanguageString(113);
  form29.Button2.Caption := GetLanguageString(118);

  Form1.Exporttextfortranslation1.Caption := GetLanguageString(294);
  Form1.Importtextfromtranslation1.Caption := GetLanguageString(295);
end;

Procedure ClearShadow;
var
  s: ansistring;
begin
  if not directoryexists(path + 'temp') then
    CreateDir(path + 'temp');
  s := inttohex(crc32ofstring(FullQuestFile), 8);
  if fileexists(path + 'temp\_' + s) then
    deletefile(path + 'temp\_' + s);
end;

Function GetLanguageString(id: integer): ansistring;
var
  x: integer;
  s: ansistring;
begin
  if id - 1 < LanguageString.count then
  begin
    s := LanguageString.Strings[id - 1];
    x := pos('<cr>', s);
    while x > 0 do
    begin
      delete(s, x, 4);
      insert(#13#10, s, x);
      x := pos('<cr>', s);
    end;
    result := s;
  end
  else
    result := '<Undefined>';
end;

Procedure DumpQuest(fn: ansistring);
var
  ch: array [0 .. 2047] of byte;
  x, y, i, f: integer;
begin

  f := filecreate(fn);
  // title
  fillchar(ch[0], 2048, 0);
  move(Title[1], ch[0], length(Title) * 2);
  filewrite(f, ch[0], 128);
  // desc
  fillchar(ch[0], 2048, 0);
  move(Info[1], ch[0], length(Info) * 2);
  filewrite(f, ch[0], 1024);
  // full desc
  fillchar(ch[0], 2048, 0);
  move(Desc[1], ch[0], length(Desc) * 2);
  filewrite(f, ch[0], 2048);
  // id
  filewrite(f, qnum, 4);
  // lang
  filewrite(f, language, 2);
  filewrite(f, FFilter, 2);
  // floor data
  for x := 0 to 29 do
  begin
    filewrite(f, Floor[x], sizeof(Floor[x])); // floor data
    fillchar(ch[0], 2048, 0);
    i := 0;
    if Form1.CheckListBox1.Checked[x] then
      i := 1;
    filewrite(f, i, 4);
    move(mapfile[x][1], ch[0], length(mapfile[x]));
    move(mapxvmfile[x][1], ch[512], length(mapxvmfile[x]));
    move(Form1.CheckListBox1.Items.Strings[x][1], ch[1024], length(Form1.CheckListBox1.Items.Strings[x]));
    filewrite(f, ch[0], 1152);
  end;
  // script
  form4.SaveToBackupFile(f);
  // info script
  i := TsData.count;
  filewrite(f, i, 4);
  for x := 0 to i - 1 do
  begin
    fillchar(ch[0], 16, 0);
    move(TsData.Strings[x][1], ch[0], length(TsData.Strings[x]));
    filewrite(f, ch[0], 16);
  end;
  i := TsFnc.count;
  filewrite(f, i, 4);
  for x := 0 to i - 1 do
  begin
    fillchar(ch[0], 16, 0);
    move(TsFnc.Strings[x][1], ch[0], length(TsFnc.Strings[x]));
    filewrite(f, ch[0], 16);
  end;
  i := TsReg.count;
  filewrite(f, i, 4);
  for x := 0 to i - 1 do
  begin
    fillchar(ch[0], 16, 0);
    move(TsReg.Strings[x][1], ch[0], length(TsReg.Strings[x]));
    filewrite(f, ch[0], 16);
  end;
  i := Tsopc.count;
  filewrite(f, i, 4);
  for x := 0 to i - 1 do
  begin
    fillchar(ch[0], 16, 0);
    move(Tsopc.Strings[x][1], ch[0], length(Tsopc.Strings[x]));
    filewrite(f, ch[0], 16);
  end;
  fileclose(f);
end;

Procedure CreateShadow;
var
  s: ansistring;
begin
  if not directoryexists(path + 'temp') then
    CreateDir(path + 'temp');
  s := inttohex(crc32ofstring(FullQuestFile), 8);
  DumpQuest(path + 'temp\_' + s);
end;

Procedure unDumpQuest(fn: ansistring);
var
  ch: array [0 .. 2047] of byte;
  x, y, i, f: integer;
  TrTmp: ttreenode;
begin

  f := fileopen(fn, $40);
  // title
  fileread(f, ch[0], 128);
  Title := pwidechar(@ch[0]);
  // desc
  fileread(f, ch[0], 1024);
  Info := pwidechar(@ch[0]);
  // full desc
  fileread(f, ch[0], 2048);
  Desc := pwidechar(@ch[0]);
  // id
  fileread(f, qnum, 4);
  // lang
  language := 0;
  fileread(f, language, 2);
  FFilter := 0;
  fileread(f, FFilter, 2);
  // floor data
  for x := 0 to 29 do
  begin
    fileread(f, Floor[x], sizeof(Floor[x])); // floor data
    fileread(f, i, 4);
    fileread(f, ch[0], 1152);
    mapfile[x] := pansichar(@ch[0]);
    mapxvmfile[x] := pansichar(@ch[512]);
    Form1.CheckListBox1.Items.Strings[x] := pansichar(@ch[1024]);
    Form1.CheckListBox1.Checked[x] := false;
    if i = 1 then
      Form1.CheckListBox1.Checked[x] := true;
  end;
  // script
  form4.LoadFromBackupFile(f);
  // info script
  fileread(f, i, 4);
  TsData.Clear;
  TrData.DeleteChildren;
  for x := 0 to i - 1 do
  begin
    fileread(f, ch[0], 16);
    TsData.Add(pansichar(@ch[0]));
    TrTmp := form4.TreeView1.Items.Addchild(TrData, pansichar(@ch[0]));
    TrTmp.ImageIndex := 3;
    TrTmp.SelectedIndex := 3;
    if ch[0] = ord('D') then
    begin
      TrTmp.ImageIndex := 4;
      TrTmp.SelectedIndex := 4;
    end;
  end;

  fileread(f, i, 4);
  TsFnc.Clear;
  TrFnc.DeleteChildren;
  for x := 0 to i - 1 do
  begin
    fileread(f, ch[0], 16);
    TsFnc.Add(pansichar(@ch[0]));
    TrTmp := form4.TreeView1.Items.Addchild(TrFnc, pansichar(@ch[0]));
    TrTmp.ImageIndex := 1;
    TrTmp.SelectedIndex := 1;
  end;

  fileread(f, i, 4);
  TsReg.Clear;
  TrReg.DeleteChildren;
  for x := 0 to i - 1 do
  begin
    fileread(f, ch[0], 16);
    TsReg.Add(pansichar(@ch[0]));
    TrTmp := form4.TreeView1.Items.Addchild(TrReg, pansichar(@ch[0]));
    TrTmp.ImageIndex := 0;
    TrTmp.SelectedIndex := 0;
  end;

  fileread(f, i, 4);
  Tsopc.Clear;
  Tropc.DeleteChildren;
  for x := 0 to i - 1 do
  begin
    fileread(f, ch[0], 16);
    Tsopc.Add(pansichar(@ch[0]));
    TrTmp := form4.TreeView1.Items.Addchild(Tropc, pansichar(@ch[0]));
    TrTmp.ImageIndex := 5;
    TrTmp.SelectedIndex := 5;
  end;
  fileclose(f);
end;

Procedure LoadShadow;
var
  s: ansistring;
  tmp2: widestring;
begin
  if not directoryexists(path + 'temp') then
    CreateDir(path + 'temp');
  s := inttohex(crc32ofstring(FullQuestFile), 8);
  unDumpQuest(path + 'temp\_' + s);

  tmp2 := 'Quest Editor V 1.0b Public - ' + Title;

  Form1.Caption := unitochar(tmp2, 1000);
  curepi := GetEpisode;
end;

Procedure CheckShadow;
var
  s: ansistring;
begin
  if not directoryexists(path + 'temp') then
    CreateDir(path + 'temp');
  s := inttohex(crc32ofstring(FullQuestFile), 8);
  if fileexists(path + 'temp\_' + s) then
  begin
    if MessageDlg(GetLanguageString(46), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      LoadShadow;
    end;
  end;
end;

Function CountNumberOfWave: integer;
var
  x, y: integer;
begin
  y := 0;
  for x := 0 to Floor[sfloor].MonsterCount - 1 do
  begin
    if Floor[sfloor].Monster[x].Unknow5 > y then
      y := Floor[sfloor].Monster[x].Unknow5;
  end;
  result := y;
end;

Function CountNumberOfGrp: integer;
var
  x, y: integer;
begin
  y := 0;
  for x := 0 to Floor[sfloor].ObjCount - 1 do
  begin
    if Floor[sfloor].Obj[x].grp > y then
      y := Floor[sfloor].Obj[x].grp;
  end;
  result := y;
end;

function unitochar(s: widestring; max: integer): ansistring;

var
  x, t, l, m: integer;
  re, cc: ansistring;
begin
  x := 1;
  re := '';
  m := 1;
  t := max;
  if language = 0 then
    m := 2;
  while x <= length(s) do
  begin
    if x <= length(s) then
    // if m = 1 then re:=re+s[x]
    // else begin
    begin
      if pansichar(@s[x])[1] = #0 then
        re := re + s[x]
      else
      begin
        cc := pansichar(@s[x])[0] + pansichar(@s[x])[1];
        for l := 0 to jiscount - 1 do
          if cc = uni16[l] then
            break;
        if l < jiscount then
          re := re + jis[l];
      end;
    end;

    inc(x, 1);
  end;
  result := re;
end;

function Generateobj(m: TObj; p: integer): t3ditem;
var
  x, i, o, transparency: integer;
  px, py: Single;
  s, fl: ansistring;
  issub: Boolean;
begin
  i := m.Skin;
  o := 0;
  transparency := 255;
  fl := 'Floor' + inttostr(Floor[sfloor].floorid) + '\';
  issub := false;
  if (i = 130) or (i = 150) then
  begin
    i := 130;
    if m.unknow13 = 0 then
      i := 150;
    if m.unknow13 >= 2 then
      transparency := 90;
  end;
  if (i = 131) or (i = 151) then
  begin
    i := 131;
    if m.unknow13 = 0 then
      i := 151;
    if m.unknow13 >= 2 then
      transparency := 90;
  end;

  for x := 0 to subtypeditemcount - 1 do
    if subtypeditem[x] = i then
    begin
      issub := true;

      if subtypeditemV[x] = 1 then
        o := round(m.unknow8)
      else if subtypeditemV[x] = 2 then
        o := m.obj_id
      else if subtypeditemV[x] = 4 then
        o := m.Action
      else if subtypeditemV[x] = 5 then
        o := round(m.Unknow10)
      else
        o := m.unknow13;
      if o > subtypeditemMax[x] then
        o := subtypeditemMax[x];
    end;

  s := inttostr(i);
  if issub then
  begin
    s := s + '-' + inttostr(o);
    o := o * $10000;
  end;

  if p >= 0 then
  begin
    if (not fileexists(path + 'obj\' + fl + s + '.nj')) and (not fileexists(path + 'obj\' + fl + s + '.md3')) and
      (not fileexists(path + 'obj\' + fl + s + '.xj')) and (not fileexists(path + 'obj\' + s + '.nj')) and
      (not fileexists(path + 'obj\' + s + '.md3')) and (not fileexists(path + 'obj\' + s + '.xj')) then
    begin
      result := BaseObj[0];
    end
    else
    begin
      for x := 0 to 50 do
        if BaseObjID[x] = i or ($10000 + o) then
          break;

      if x < 51 then
      begin
        result := BaseObj[x];
      end
      else
      begin
        for x := 0 to 50 do
          if BaseObjID[x] = 0 then
            break;
        if x < 51 then
        begin
          BaseObj[x] := t3ditem.Create(myscreen);
          if fileexists(path + 'obj\' + fl + s + '.md3') then
            BaseObj[x].LoadQ3Files(path + 'obj\' + fl + s + '.md3')
          else if fileexists(path + 'obj\' + fl + s + '.nj') then
            BaseObj[x].LoadFromNJ(path + 'obj\' + fl + s + '.nj', path + 'obj\' + fl + s + '.xvm', '')
          else if fileexists(path + 'obj\' + fl + s + '.xj') then
            BaseObj[x].LoadFromxJ(path + 'obj\' + fl + s + '.xj', path + 'obj\' + fl + s + '.xvm', '')
          else if fileexists(path + 'obj\' + s + '.md3') then
            BaseObj[x].LoadQ3Files(path + 'obj\' + s + '.md3')
          else if fileexists(path + 'obj\' + s + '.nj') then
            BaseObj[x].LoadFromNJ(path + 'obj\' + s + '.nj', path + 'obj\' + s + '.xvm', '')
          else
            BaseObj[x].LoadFromxJ(path + 'obj\' + s + '.xj', path + 'obj\' + s + '.xvm', '');
          BaseObjID[x] := i or ($10000 + o);
          result := BaseObj[x];
        end
        else
          result := BaseObj[0];

      end;
    end;

    x := p;
    // MyObj[x]:=t3ditem.Create(myscreen);
    if extractfilename(mapfilenam) = 'map_boss03c.rel' then
    begin
      midpz[0].y := 0;
    end;

    px := m.Pos_X;
    py := m.Pos_Y;
    // rotate it
    py := cos((rev[Floor[sfloor].Obj[x].map_section] and $FFFF) / 10430.37835) * m.Pos_Y -
      sin((rev[Floor[sfloor].Obj[x].map_section] and $FFFF) / 10430.37835) * m.Pos_X;
    px := sin((rev[Floor[sfloor].Obj[x].map_section] and $FFFF) / 10430.37835) * m.Pos_Y +
      cos((rev[Floor[sfloor].Obj[x].map_section] and $FFFF) / 10430.37835) * m.Pos_X;

    MyObj[x] := t3ditem.Create(myscreen);
    MyObj[x].CloneFromItem(result);
    if i = 0 then
      MyObj[x].SetBaseRotation(180, 0, 0);
    MyObj[x].SetCoordinate(px + midpz[Floor[sfloor].Obj[x].map_section].x,
      m.Pos_Z + miz[Floor[sfloor].Obj[x].map_section], 0 - py - midpz[Floor[sfloor].Obj[x].map_section].y);
    MyObj[x].Visible := true;
    for i := 0 to RotateCount - 1 do
      if m.Skin = RotateItm[i] then
        break;
    if i < RotateCount then
    begin
      if m.Skin = 26 then
      begin
        MyObj[x].rotationseq := 1;
        MyObj[x].SetRotation(((-(m.unknow6 + rev[Floor[sfloor].Obj[x].map_section]) and $FFFF)) / 182.04444,
          (-(m.Unknow5 and $FFFF) / 182.04444), ((m.unknow7 and $FFFF) / 182.04444));
      end
      else
        MyObj[x].SetRotation(((-(m.unknow6 + rev[Floor[sfloor].Obj[x].map_section]) and $FFFF)) / 182.04444,
          (-(m.Unknow5 and $FFFF) / 182.04444), (-(m.unknow7 and $FFFF) / 182.04444))
    end
    else
      MyObj[x].SetRotation(((-(m.unknow6 + rev[Floor[sfloor].Obj[x].map_section]) and $FFFF)) / 182.04444, 0, 0);

    if m.Skin = 65 then
    begin
      MyObj[x].AlphaSource := 3;
      MyObj[x].AlphaDest := 2;
      MyObj[x].zwrite := false;
      if m.obj_id = 0 then
        MyObj[x].Color := $D00000;
      if m.obj_id = 1 then
        MyObj[x].Color := $D000;
      if m.obj_id = 2 then
        MyObj[x].Color := $FFD000;
      if m.obj_id = 3 then
        MyObj[x].Color := $D0;
    end;

    // color
    for i := 0 to 11 do
      if ColorItem[i] = m.Skin then
      begin
        if ColorPos[i] = 4 then
          o := round(m.unknow8);
        if ColorPos[i] = 7 then
          o := m.obj_id div 256;
        if ColorPos[i] = 8 then
          o := m.Action;
        if ColorPos[i] = 9 then
          o := m.unknow13;
        if o > ColorMax[i] then
          o := ColorMax[i];
        if o <> 0 then
        begin
          if m.Skin > 333 then
            MyObj[x].SetTextureSwap(0, o + 3)
          else if m.Skin = 333 then
            MyObj[x].SetTextureSwap(1, o + 6)
          else
            MyObj[x].SetTextureSwap(0, o);
        end;
      end;
    if transparency <> 255 then
      MyObj[x].AlphaLevel := transparency;
    for i := 0 to ScaleCount - 1 do
      if m.Skin = ScaleItm[i] then
        MyObj[x].SetProportion(m.unknow8, m.unknow9, m.Unknow10);

  end
  else if (p = -2) and objscreen.Enable then
  begin
    result := nil;
    if (not fileexists(path + 'obj\' + fl + s + '.nj')) and (not fileexists(path + 'obj\' + fl + s + '.md3')) and
      (not fileexists(path + 'obj\' + fl + s + '.xj')) and (not fileexists(path + 'obj\' + s + '.nj')) and
      (not fileexists(path + 'obj\' + s + '.md3')) and (not fileexists(path + 'obj\' + s + '.xj')) then
    begin
      objitm.LoadQ3Files(path + 'obj\unknown.MD3');
    end
    else
    begin
      if fileexists(path + 'obj\' + fl + s + '.md3') then
        objitm.LoadQ3Files(path + 'obj\' + fl + s + '.md3')
      else if fileexists(path + 'obj\' + fl + s + '.nj') then
        objitm.LoadFromNJ(path + 'obj\' + fl + s + '.nj', path + 'obj\' + fl + s + '.xvm', '')
      else if fileexists(path + 'obj\' + fl + s + '.xj') then
        objitm.LoadFromxJ(path + 'obj\' + fl + s + '.xj', path + 'obj\' + fl + s + '.xvm', '')
      else if fileexists(path + 'obj\' + s + '.md3') then
        objitm.LoadQ3Files(path + 'obj\' + s + '.md3')
      else if fileexists(path + 'obj\' + s + '.nj') then
        objitm.LoadFromNJ(path + 'obj\' + s + '.nj', path + 'obj\' + s + '.xvm', '')
      else
        objitm.LoadFromxJ(path + 'obj\' + s + '.xj', path + 'obj\' + s + '.xvm', '');
    end;
    // color
    for i := 0 to 11 do
      if ColorItem[i] = m.Skin then
      begin
        if ColorPos[i] = 4 then
          o := round(m.unknow8);
        if ColorPos[i] = 7 then
          o := m.obj_id div 256;
        if ColorPos[i] = 8 then
          o := m.Action;
        if ColorPos[i] = 9 then
          o := m.unknow13;
        if o <> 0 then
          objitm.SetTextureSwap(0, o);
      end;

    objitm.Visible := true;
    objitm.AlphaLevel := transparency;
    for i := 0 to ScaleCount - 1 do
      if m.Skin = ScaleItm[i] then
        objitm.SetProportion(m.unknow8, m.unknow9, m.Unknow10);

    if m.Skin = 65 then
    begin
      objitm.AlphaSource := 3;
      objitm.AlphaDest := 2;
      objitm.zwrite := false;
      if m.obj_id = 0 then
        objitm.Color := $990000;
      if m.obj_id = 1 then
        objitm.Color := $9900;
      if m.obj_id = 2 then
        objitm.Color := $EE9900;
      if m.obj_id = 3 then
        objitm.Color := $99;
    end;

  end;
  {

    (17:46:54) leejohnlangan: Laser Fence 130

    Active Range = Colour
    0 = Orange
    1 = Blue
    2 = Green
    3 = Purple

    second from bottom Unknown = Laser fence size
    0 = 2x4
    1 = 2x6
    (17:47:45) leejohnlangan:    130 
    131 
    150 
    151   
    (17:48:24) leejohnlangan: 130 / 150  share the same 2 models
    (17:48:40) leejohnlangan: 150 / 151 share the 2 models for squared fences
    (17:48:53) schthack2: ok
    (17:48:59) leejohnlangan: and just because I want you to kill me
    (17:49:06) schthack2: lol
    (17:49:12) leejohnlangan: Crashed Probe 135

    Active Range = Model Flag
    0 = Crashed
    1 = Normal

    (17:52:44) leejohnlangan: 130 Laser Fence (2x6)
    131 Square Laser Fence (4x6)
    (17:52:52) leejohnlangan: 150 Laser Fence 2x4
    151 Laser Fence 4x4

  }

end;

Procedure load3d;
var
  x: integer;
begin
  if sfloor > -1 then
  begin
    // create the screen

    // make the monster
    form14.Label1.Caption := GetLanguageString(47);
    form14.Show;
    form14.Repaint;
    for x := 0 to MyMonstCount - 1 do
    begin
      if MyMonst[x] <> nil then
        MyMonst[x].Free;

      MyMonst[x] := nil;
    end;

    for x := 0 to MyObjCount - 1 do
    begin
      if MyObj[x] <> nil then
        MyObj[x].Free;

      MyObj[x] := nil;
    end;
    // clean base
    for x := 1 to 50 do
      if BaseMonsterID[x] <> 0 then
      begin
        if BaseMonster[x] <> nil then
          BaseMonster[x].Free;
        BaseMonster[x] := nil;
      end;
    fillchar(BaseMonsterID[0], sizeof(BaseMonsterID), 0);
    BaseMonsterID[0] := -1;

    for x := 1 to 50 do
      if BaseObjID[x] <> 0 then
      begin
        if BaseObj[x] <> nil then
          BaseObj[x].Free;
        BaseObj[x] := nil;
      end;
    fillchar(BaseObjID[0], sizeof(BaseObjID), 0);
    BaseObjID[0] := -1;

    MyMonstCount := Floor[sfloor].MonsterCount;
    setlength(MyMonst, MyMonstCount);
    form14.Label1.Caption := GetLanguageString(48);
    form14.ProgressBar1.max := Floor[sfloor].MonsterCount;
    for x := 0 to Floor[sfloor].MonsterCount - 1 do
    begin
      GenerateMonsterName(Floor[sfloor].Monster[x], x, 1);
      form14.ProgressBar1.Position := x;
      form14.Repaint;
    end;

    MyObjCount := Floor[sfloor].ObjCount;
    setlength(MyObj, MyObjCount);
    form14.Label1.Caption := GetLanguageString(49);
    form14.ProgressBar1.max := Floor[sfloor].ObjCount;
    for x := 0 to Floor[sfloor].ObjCount - 1 do
    begin
      Generateobj(Floor[sfloor].Obj[x], x);
      form14.ProgressBar1.Position := x;
      form14.Repaint;
    end;

    // load the map
    if mymap <> nil then
      mymap.Free;
    form14.Label1.Caption := GetLanguageString(50);
    form14.Repaint;
    form14.ProgressBar1.max := 1;
    form14.ProgressBar1.Position := 0;
    mymap := Tpikamap.Create(myscreen);
    if mymap = nil then
    begin
      form14.Close;
      MessageDlg(GetLanguageString(51), mtInformation, [mbOk], 0);
      exit;
    end;
    mymap.LoadPSOMap(copy(mapfile[sfloor], 1, length(mapfile[sfloor]) - 5) + 'n.rel', mapxvmfile[sfloor]);
    mymap.LoadPSOTam(copy(mapfile[sfloor], 1, length(mapfile[sfloor]) - 5) + '.tam');
    // if myscreen.ViewDistance = 0 then begin
    if form17.CheckBox2.Checked then
      if MapSkyDome[Floor[sfloor].floorid] <> '' then
      begin
        mymap.LoadTopDome(path + 'map\xvm\' + MapSkyDome[Floor[sfloor].floorid]);
        if fileexists(path + 'map\xvm\' + copy(MapSkyDome[Floor[sfloor].floorid], 1,
          length(MapSkyDome[Floor[sfloor].floorid]) - 4) + '_b.png') then
          mymap.LoadBottomDome(path + 'map\xvm\' + copy(MapSkyDome[Floor[sfloor].floorid], 1,
            length(MapSkyDome[Floor[sfloor].floorid]) - 4) + '_b.png');
      end;
    // end;
    mymap.Visible := true;
    mymap.Select;
    form14.ProgressBar1.Position := 1;
  end;

  // myscreen.SetPointLight(0,$FFFFFF,0,10,0,100,100);
  if Floor[sfloor].floorid < 47 then
  begin
    myscreen.BackGroundColor := FogEntry[FloorFog[Floor[sfloor].floorid]].F2;
    fogCol := FogEntry[FloorFog[Floor[sfloor].floorid]].F2;
    fogstart := FogEntry[FloorFog[Floor[sfloor].floorid]].F4;
    fogend := FogEntry[FloorFog[Floor[sfloor].floorid]].F3;
    fogtCol := FogEntry[FloorFog[Floor[sfloor].floorid]].F2;
    fogtstart := FogEntry[FloorFog[Floor[sfloor].floorid]].F4;
    fogtend := FogEntry[FloorFog[Floor[sfloor].floorid]].F3;
    fogcurrent := FloorFog[Floor[sfloor].floorid];
    fogspeed := 0;
    fogtype := FogEntry[FloorFog[Floor[sfloor].floorid]].F1;
    fogfl1 := fogtend - FogEntry[FloorFog[Floor[sfloor].floorid]].F9;
    fogfl2 := fogtend - FogEntry[FloorFog[Floor[sfloor].floorid]].F11;
    fogstep := FogEntry[FloorFog[Floor[sfloor].floorid]].F7;
    if fogtype = 2 then
    begin
      fogtend := fogfl1;
      fogtime := round(((abs(fogfl1 - fogfl2) / fogstep) / 30) * 1000);
      fogspeed := gettickcount + fogtime;
      fogtype := 3;
      if fogtime = 0 then
        fogspeed := 0;
    end;

    if lowercase(Title) = 'mist' then
      if Floor[sfloor].floorid = 1 then
      begin
        myscreen.SetAdvancedFog(PikaVector(-700, 0, 700), PikaVector(700, 30, -700), $88888888, path + 'obj\fog.bmp');
        fogCol := $10101010;
        fogstart := -500;
        fogend := 400;
        fogspeed := 0;
        mymap.LoadTopDome(path + 'map\xvm\forestd.png');
        myscreen.BackGroundColor := 0;
      end
      else
        myscreen.SetAdvancedFog(PikaVector(0, 0, 0), PikaVector(0, 0, 0), $33333333, '');
    // myscreen.SetAdvancedFog(0,20,$40404040,'obj\fog.bmp');
    myscreen.SetFog(fogCol, fogstart, fogend);
  end;
  form14.hide;
end;

function chartouni(s: ansistring): ansistring;
var
  x, t, l, m: integer;
  re: ansistring;
  cc: ansistring;
begin
  x := 1;
  re := '';
  m := 1;
  if language = 0 then
    m := 2;
  t := length(s) * 2;
  while x <= length(s) do
  begin
    if x <= length(s) then
      if m = 1 then
        re := re + s[x] + ansichar(0)
      else
      begin
        if integer(s[x]) < 127 then
          re := re + s[x] + ansichar(0)
        else
        begin
          if language = 0 then
          begin // shif-jis
            cc := s[x];
            if (byte(s[x]) < $A1) or (byte(s[x]) > $DF) then
              cc := cc + s[x + 1];
            for l := 0 to jiscount - 1 do
              if cc = jis[l] then
                break;
            if l < jiscount then
              re := re + uni16[l];

            inc(x);
          end
          else
            re := re + s[x] + ansichar(0);
        end;
      end;

    inc(x);
  end;
  result := re;
end;

function chartouni2(s: ansistring): widestring;
var
  x, t, l, m: integer;
  re: ansistring;
  cc: ansistring;
begin
  x := 1;
  re := '';
  m := 1;
  if language = 0 then
    m := 2;
  t := length(s) * 2;
  while x <= length(s) do
  begin
    if x <= length(s) then
      if m = 1 then
        re := re + s[x] + ansichar(0)
      else
      begin
        if integer(s[x]) < 127 then
          re := re + s[x] + ansichar(0)
        else
        begin
          if language = 0 then
          begin // shif-jis
            cc := s[x];
            if (byte(s[x]) < $A1) or (byte(s[x]) > $DF) then
              cc := cc + s[x + 1];
            for l := 0 to jiscount - 1 do
              if cc = jis[l] then
                break;
            if l < jiscount then
              re := re + uni16[l];

            inc(x);
          end
          else
            re := re + s[x] + ansichar(0);
        end;
      end;

    inc(x);
  end;
  setlength(result, length(re) div 2);
  move(pansichar(@re[1])[0], pansichar(@result[1])[0], length(re));
  // result:=re;
end;

Procedure TForm1.DrawMap;
Var
  px, py, px2, py2, px3, py3: double;
  ppx, ppy: Single;
  x, i, z: integer;
  rt: word;
  tpt: array [0 .. 2] of TPoint;
  ts: TMemoryStream;
begin
  // clear map       a
  if BBRelBmp = nil then
    BBRelBmp := TBitmap.Create;

  BBRelBmp.Width := Image2.Width;
  BBRelBmp.height := Image2.height;

  BBRelBmp.Canvas.Brush.Color := ClWhite;
  BBRelBmp.Canvas.FillRect(BBRelBmp.Canvas.ClipRect);
  if fileexists(mapfilenam) then
    DrawBBRELFile(mapfilenam);

  if Floor[sfloor].d04count > 0 then
    try
      move(Floor[sfloor].d04[4], x, 4); // data pos
      while x < Floor[sfloor].d04count do
      begin
        move(Floor[sfloor].d04[x], ppx, 4);
        move(Floor[sfloor].d04[x + 8], ppy, 4);
        px2 := ppx / Zoom;
        py2 := ppy / Zoom;
        // rotate it
        z := 0;
        move(Floor[sfloor].d04[x + 24], z, 2);
        px := cos(-rev[z] / 10430.37835) * px2 - sin(-rev[z] / 10430.37835) * py2;
        py := sin(-rev[z] / 10430.37835) * px2 + cos(-rev[z] / 10430.37835) * py2;

        px2 := mpx;
        px2 := px2 / Zoom;
        px := px + mmx + MidP[z].x + px2;
        px2 := mpy;
        px2 := px2 / Zoom;
        py := py + mmy + MidP[z].y + px2;
        BBRelBmp.Canvas.Brush.Color := $018AFF;
        BBRelBmp.Canvas.FillRect(Rect(round(px) - round(6 / Zoom), round(py) - round(6 / Zoom),
          round(px) + round(6 / Zoom), round(py) + round(6 / Zoom)));

        move(Floor[sfloor].d04[x + 16], rt, 2);
        rt := -(rev[z] + rt);
        px2 := -(8 / Zoom);
        py2 := -(8 / Zoom);
        px3 := cos(rt / 10430.37835) * px2 - sin(rt / 10430.37835) * py2;
        py3 := sin(rt / 10430.37835) * px2 + cos(rt / 10430.37835) * py2;
        tpt[0] := point(round(px) + round(px3), round(py) + round(py3));
        px2 := 0;
        py2 := 8 / Zoom;
        px3 := cos(rt / 10430.37835) * px2 - sin(rt / 10430.37835) * py2;
        py3 := sin(rt / 10430.37835) * px2 + cos(rt / 10430.37835) * py2;
        tpt[1] := point(round(px) + round(px3), round(py) + round(py3));
        px2 := (8 / Zoom);
        py2 := -(8 / Zoom);
        px3 := cos(rt / 10430.37835) * px2 - sin(rt / 10430.37835) * py2;
        py3 := sin(rt / 10430.37835) * px2 + cos(rt / 10430.37835) * py2;
        tpt[2] := point(round(px) + round(px3), round(py) + round(py3));
        BBRelBmp.Canvas.Polyline(tpt);
        inc(x, 28);
      end;
    except
      MessageDlg(GetLanguageString(52), mtInformation, [mbOk], 0);
    end;

  try
    for x := 0 to Floor[sfloor].MonsterCount - 1 do
      if (Floor[sfloor].Monster[x].Unknow5 = showwave) or (showwave = -1) then
      begin
        // 395,233
        if extractfilename(mapfilenam) = 'map_boss03c.rel' then
        begin
          MidP[0].y := 0;
        end;
        px2 := Floor[sfloor].Monster[x].Pos_X / Zoom;
        py2 := Floor[sfloor].Monster[x].Pos_Y / Zoom;
        // rotate it
        px := cos(-rev[Floor[sfloor].Monster[x].map_section] / 10430.37835) * px2 -
          sin(-rev[Floor[sfloor].Monster[x].map_section] / 10430.37835) * py2;
        py := sin(-rev[Floor[sfloor].Monster[x].map_section] / 10430.37835) * px2 +
          cos(-rev[Floor[sfloor].Monster[x].map_section] / 10430.37835) * py2;

        px2 := mpx;
        px2 := px2 / Zoom;
        px := px + mmx + MidP[Floor[sfloor].Monster[x].map_section].x + px2;
        px2 := mpy;
        px2 := px2 / Zoom;
        py := py + mmy + MidP[Floor[sfloor].Monster[x].map_section].y + px2;
        BBRelBmp.Canvas.Brush.Color := ClRed;
        BBRelBmp.Canvas.FillRect(Rect(round(px) - round(6 / Zoom), round(py) - round(6 / Zoom),
          round(px) + round(6 / Zoom), round(py) + round(6 / Zoom)));
        if (stype = 1) and (Selected = x) then
        begin
          BBRelBmp.Canvas.Brush.Color := ClYellow;
          if Zoom < 3.1 then
            BBRelBmp.Canvas.Rectangle(Rect(round(px) - round(8 / Zoom), round(py) - round(8 / Zoom),
              round(px) + round(8 / Zoom), round(py) + round(8 / Zoom)))
          else
            BBRelBmp.Canvas.Rectangle(Rect(round(px) - 3, round(py) - 3, round(px) + 3, round(py) + 3));
        end;
        rt := -(rev[Floor[sfloor].Monster[x].map_section] + Floor[sfloor].Monster[x].Direction);
        px2 := -(8 / Zoom);
        py2 := -(8 / Zoom);
        px3 := cos(rt / 10430.37835) * px2 - sin(rt / 10430.37835) * py2;
        py3 := sin(rt / 10430.37835) * px2 + cos(rt / 10430.37835) * py2;
        tpt[0] := point(round(px) + round(px3), round(py) + round(py3));
        px2 := 0;
        py2 := 8 / Zoom;
        px3 := cos(rt / 10430.37835) * px2 - sin(rt / 10430.37835) * py2;
        py3 := sin(rt / 10430.37835) * px2 + cos(rt / 10430.37835) * py2;
        tpt[1] := point(round(px) + round(px3), round(py) + round(py3));
        px2 := (8 / Zoom);
        py2 := -(8 / Zoom);
        px3 := cos(rt / 10430.37835) * px2 - sin(rt / 10430.37835) * py2;
        py3 := sin(rt / 10430.37835) * px2 + cos(rt / 10430.37835) * py2;
        tpt[2] := point(round(px) + round(px3), round(py) + round(py3));
        BBRelBmp.Canvas.Polyline(tpt);
      end;
  except
    MessageDlg(GetLanguageString(52), mtInformation, [mbOk], 0);
  end;
  try
    for x := 0 to Floor[sfloor].ObjCount - 1 do
      if (Floor[sfloor].Obj[x].grp = showgrp) or (showgrp = -1) then
      begin
        // 395,233
        if extractfilename(mapfilenam) = 'map_boss03c.rel' then
        begin
          MidP[0].y := 0;
        end;

        px2 := Floor[sfloor].Obj[x].Pos_X / Zoom;
        py2 := Floor[sfloor].Obj[x].Pos_Y / Zoom;
        px := cos(-rev[Floor[sfloor].Obj[x].map_section] / 10430.37835) * px2 -
          sin(-rev[Floor[sfloor].Obj[x].map_section] / 10430.37835) * py2;
        py := sin(-rev[Floor[sfloor].Obj[x].map_section] / 10430.37835) * px2 +
          cos(-rev[Floor[sfloor].Obj[x].map_section] / 10430.37835) * py2;

        { if rev[Floor[sfloor].obj[x].map_section] = $8000 then begin
          px:=-px;
          py:=-py;
          end;
          if rev[Floor[sfloor].obj[x].map_section] = $c000 then begin
          px2:=px;
          px:=-py;
          py:=px2;
          end;
          if rev[Floor[sfloor].obj[x].map_section] = $3fff then begin
          px2:=px;
          px:=py;
          py:=-px2;
          end; }
        px2 := mpx;
        px2 := px2 / Zoom;
        px := px + mmx + MidP[Floor[sfloor].Obj[x].map_section].x + px2;
        px2 := mpy;
        px2 := px2 / Zoom;
        py := py + mmy + MidP[Floor[sfloor].Obj[x].map_section].y + px2;
        BBRelBmp.Canvas.Brush.Color := ClGreen;
        BBRelBmp.Canvas.FillRect(Rect(round(px) - round(6 / Zoom), round(py) - round(6 / Zoom),
          round(px) + round(6 / Zoom), round(py) + round(6 / Zoom)));
        if (stype = 2) and (Selected = x) then
        begin
          BBRelBmp.Canvas.Brush.Color := ClYellow;
          if Zoom < 3.1 then
            BBRelBmp.Canvas.Rectangle(Rect(round(px) - round(8 / Zoom), round(py) - round(8 / Zoom),
              round(px) + round(8 / Zoom), round(py) + round(8 / Zoom)))
          else
            BBRelBmp.Canvas.Rectangle(Rect(round(px) - 3, round(py) - 3, round(px) + 3, round(py) + 3));
          for i := 0 to 12 do
            if ItemRange[i] = Floor[sfloor].Obj[x].Skin then
              break;
          if i < 13 then
          begin
            BBRelBmp.Canvas.Brush.Style := bsclear;
            BBRelBmp.Canvas.Pen.Color := ClOlive;
            BBRelBmp.Canvas.Ellipse(round(px - (Floor[sfloor].Obj[x].unknow8 / Zoom)),
              round(py - (Floor[sfloor].Obj[x].unknow8 / Zoom)), round(px + (Floor[sfloor].Obj[x].unknow8 / Zoom)),
              round(py + (Floor[sfloor].Obj[x].unknow8 / Zoom)));
            BBRelBmp.Canvas.Brush.Style := bssolid;
            BBRelBmp.Canvas.Pen.Color := clblack;
          end;

          if (Floor[sfloor].Obj[x].Skin = 150) then
          begin
            BBRelBmp.Canvas.Pen.Color := ClBlue;
            rt := -(rev[Floor[sfloor].Obj[x].map_section] + Floor[sfloor].Obj[x].unknow6);
            px2 := -((Floor[sfloor].Obj[x].unknow9 / 2) / Zoom);
            py2 := -((Floor[sfloor].Obj[x].Unknow10 / 2) / Zoom);
            px3 := cos(rt / 10430.37835) * px2 - sin(rt / 10430.37835) * py2;
            py3 := sin(rt / 10430.37835) * px2 + cos(rt / 10430.37835) * py2;
            BBRelBmp.Canvas.PenPos := point(round(px) + round(px3), round(py) + round(py3));
            px2 := ((Floor[sfloor].Obj[x].unknow9 / 2) / Zoom);
            py2 := -((Floor[sfloor].Obj[x].Unknow10 / 2) / Zoom);
            px3 := cos(rt / 10430.37835) * px2 - sin(rt / 10430.37835) * py2;
            py3 := sin(rt / 10430.37835) * px2 + cos(rt / 10430.37835) * py2;
            BBRelBmp.Canvas.lineto(round(px) + round(px3), round(py) + round(py3));
            px2 := ((Floor[sfloor].Obj[x].unknow9 / 2) / Zoom);
            py2 := ((Floor[sfloor].Obj[x].Unknow10 / 2) / Zoom);
            px3 := cos(rt / 10430.37835) * px2 - sin(rt / 10430.37835) * py2;
            py3 := sin(rt / 10430.37835) * px2 + cos(rt / 10430.37835) * py2;
            BBRelBmp.Canvas.lineto(round(px) + round(px3), round(py) + round(py3));
            px2 := -((Floor[sfloor].Obj[x].unknow9 / 2) / Zoom);
            py2 := ((Floor[sfloor].Obj[x].Unknow10 / 2) / Zoom);
            px3 := cos(rt / 10430.37835) * px2 - sin(rt / 10430.37835) * py2;
            py3 := sin(rt / 10430.37835) * px2 + cos(rt / 10430.37835) * py2;
            BBRelBmp.Canvas.lineto(round(px) + round(px3), round(py) + round(py3));
            px2 := -((Floor[sfloor].Obj[x].unknow9 / 2) / Zoom);
            py2 := -((Floor[sfloor].Obj[x].Unknow10 / 2) / Zoom);
            px3 := cos(rt / 10430.37835) * px2 - sin(rt / 10430.37835) * py2;
            py3 := sin(rt / 10430.37835) * px2 + cos(rt / 10430.37835) * py2;
            BBRelBmp.Canvas.lineto(round(px) + round(px3), round(py) + round(py3));

            BBRelBmp.Canvas.Pen.Color := clblack;
          end;

          if (Floor[sfloor].Obj[x].Skin = 3) or (Floor[sfloor].Obj[x].Skin = 321) or (Floor[sfloor].Obj[x].Skin = 697)
          then
          begin
            BBRelBmp.Canvas.Pen.Color := ClBlue;
            i := round((mpx / Zoom) + (Floor[sfloor].Obj[x].unknow8 / Zoom) + mmx);
            z := round((mpy / Zoom) + (Floor[sfloor].Obj[x].Unknow10 / Zoom) + mmy);
            BBRelBmp.Canvas.PenPos := point(i - 10, z);
            BBRelBmp.Canvas.lineto(i + 10, z);
            BBRelBmp.Canvas.PenPos := point(i, z - 10);
            BBRelBmp.Canvas.lineto(i, z + 10);
            BBRelBmp.Canvas.Pen.Color := clblack;
          end;
        end;
        // rotation
        rt := -(rev[Floor[sfloor].Obj[x].map_section] + Floor[sfloor].Obj[x].unknow6);
        px2 := -(8 / Zoom);
        py2 := -(8 / Zoom);
        px3 := cos(rt / 10430.37835) * px2 - sin(rt / 10430.37835) * py2;
        py3 := sin(rt / 10430.37835) * px2 + cos(rt / 10430.37835) * py2;
        tpt[0] := point(round(px) + round(px3), round(py) + round(py3));
        px2 := 0;
        py2 := 8 / Zoom;
        px3 := cos(rt / 10430.37835) * px2 - sin(rt / 10430.37835) * py2;
        py3 := sin(rt / 10430.37835) * px2 + cos(rt / 10430.37835) * py2;
        tpt[1] := point(round(px) + round(px3), round(py) + round(py3));
        px2 := (8 / Zoom);
        py2 := -(8 / Zoom);
        px3 := cos(rt / 10430.37835) * px2 - sin(rt / 10430.37835) * py2;
        py3 := sin(rt / 10430.37835) * px2 + cos(rt / 10430.37835) * py2;
        tpt[2] := point(round(px) + round(px3), round(py) + round(py3));
        BBRelBmp.Canvas.Polyline(tpt);
        // dsfsdf

        { if (rt >= $e000) or (rt <= $1fff) then begin
          Image2.Canvas.PenPos:=point(round(px)-round(8/zoom),round(py)-round(8/zoom));
          image2.Canvas.LineTo(round(px),round(py)+round(8/zoom));
          image2.Canvas.LineTo(round(px)+round(8/zoom),round(py)-round(8/zoom));
          end;
          if (rt >= $2000) and (rt <= $5fff) then begin
          Image2.Canvas.PenPos:=point(round(px)-round(8/zoom),round(py)-round(8/zoom));
          image2.Canvas.LineTo(round(px)+round(8/zoom),round(py));
          image2.Canvas.LineTo(round(px)-round(8/zoom),round(py)+round(8/zoom));
          end;
          if (rt >= $6000) and (rt <= $9fff) then begin
          Image2.Canvas.PenPos:=point(round(px)-round(8/zoom),round(py)+round(8/zoom));
          image2.Canvas.LineTo(round(px),round(py)-round(8/zoom));
          image2.Canvas.LineTo(round(px)+round(8/zoom),round(py)+round(8/zoom));
          end;
          if (rt >= $a000) and (rt <= $dfff) then begin
          Image2.Canvas.PenPos:=point(round(px)+round(8/zoom),round(py)-round(8/zoom));
          image2.Canvas.LineTo(round(px)-round(8/zoom),round(py));
          image2.Canvas.LineTo(round(px)+round(8/zoom),round(py)+round(8/zoom));
          end;
        }

      end;
    BBRelBmp.Canvas.Brush.Color := ClWhite;
    BBRelBmp.Canvas.TextOut(5, 5, GetLanguageString(54) + ' ' + inttohex(sms, 2));
  except
    MessageDlg(GetLanguageString(53), mtInformation, [mbOk], 0);
  end;
  ts := TMemoryStream.Create;
  BBRelBmp.SaveToStream(ts);
  ts.Position := 0;
  // image2.Canvas.Draw(0,0,BBRelBmp);
  Image2.Picture.Bitmap.LoadFromStream(ts);
  ts.Free;
  // BBRelBmp.Free;
end;

procedure TForm1.Quit1Click(Sender: TObject);
begin
  if isedited then
  begin
    if MessageDlg(GetLanguageString(55), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      Form1.Save1Click(Form1);
      if isedited then
        exit;
    end;
  end;
  ClearShadow;
  application.Terminate;
end;

Function MixKey(user, buff: integer): Boolean;
var
  esi, edi, eax, ebp, edx: dword;
begin
  edi := 1;
  edx := $18;
  eax := edi;
  while edx > 0 do
  begin
    esi := player[user].Key[buff][eax + $1F];
    ebp := player[user].Key[buff][eax];
    ebp := ebp - esi;
    player[user].Key[buff][eax] := ebp;
    inc(eax);
    dec(edx);
  end;
  edi := $19;
  edx := $1F;
  eax := edi;
  while edx > 0 do
  begin
    esi := player[user].Key[buff][eax - $18];
    ebp := player[user].Key[buff][eax];
    ebp := ebp - esi;
    player[user].Key[buff][eax] := ebp;
    inc(eax);
    dec(edx);
  end;
  result := true;
end;

Function CreateKey(val: dword; user: integer): Boolean;
var
  esi, ebx, edi, eax, ebp, edx, x: dword;
  Key: array [0 .. 60] of dword;
begin
  esi := 1;
  ebx := val;
  edi := $15;
  Key[56] := ebx;
  Key[55] := ebx;
  while edi <= $46E do
  begin
    eax := edi;
    ebp := $37;
    x := eax div ebp;
    edx := eax - (x * ebp);
    ebx := ebx - esi;
    edi := edi + $15;
    Key[edx] := esi;
    esi := ebx;
    ebx := Key[edx];
  end;
  for x := 0 to 59 do
    player[user].Key[0][x] := Key[x];
  MixKey(user, 0);
  MixKey(user, 0);
  MixKey(user, 0);
  MixKey(user, 0);
  for x := 0 to 59 do
    player[user].Key[1][x] := player[user].Key[0][x];
  player[user].RecKeyPos := 4;
  player[user].KeyPos := 4;
  result := true;
end;

Function PSOEnc(s: ansistring; user, buff: integer): ansistring;
var
  x, y, z, u: integer;
  l: dword;
  re: ansistring;
begin
  if buff = 0 then
    x := player[user].KeyPos
  else
    x := player[user].RecKeyPos;

  if x < 4 then
    x := 4;

  re := '';

  for z := 1 to length(s) do
  begin
    if x = 4 then
      MixKey(user, buff);
    re := re + ansichar(byte(s[z]) xor byte(pansichar(@player[user].Key[buff, 0])[x]));
    inc(x);
    if x = 224 then
      x := 4;
  end;
  if (x div 4) * 4 <> x then
    x := ((x div 4) + 1) * 4;
  if x = 224 then
    x := 4;
  if buff = 0 then
    player[user].KeyPos := x
  else
    player[user].RecKeyPos := x;
  result := re;

end;

procedure TForm1.Load1Click(Sender: TObject);
var
  x, y, f, F1, F2, tf, i: integer;
  h: TNPCGroupeHeader;
  seg: array [0 .. 3] of dword;
  txt: array [0 .. $137F] of byte;
  unp: array [0 .. $8FF] of byte;
  tmp: ansistring;
  tmp2: widestring;
  fn, g: ansistring;
  si, ln, eb1, eb2: dword;
  di, da, db: pansichar;
begin
  if isedited then
  begin
    if MessageDlg(GetLanguageString(56), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      Form1.Save1Click(Form1);
      if isedited then
        exit;
    end;
  end;
  OpenDialog1.Filter :=
    'Raw Quest|*.bin|Compressed Quest|*.bin|Server Quest File|*.qst*|BB Server Quest File|*.qst*|Download Quest File|*.qst*|Quest project|*.qprj';
  OpenDialog1.FilterIndex := lastloadformat;
  if OpenDialog1.Execute then
  begin
    lastloadformat := OpenDialog1.FilterIndex;
    isedited := false;
    undocount := 0;
    ClearShadow;
    Button11.Enabled := false;
    smUndo.Enabled := false;
    AsmMode := 0;
    eb1 := 0;
    eb2 := 0;
    curepi := 0;
    fillchar(BBData[0], sizeof(BBData), 0);
    MoveSel := -1;
    HideIndicator();
    path := extractfilepath(application.ExeName);
    fn := OpenDialog1.filename;
    FullQuestFile := fn;
    for x := 0 to qstfilecount - 1 do
      freemem(qstfile[x].data);
    qstfilecount := 0;
    try
      if (OpenDialog1.FilterIndex = 6) then
      begin
        unDumpQuest(fn);
        tmp2 := 'Quest Editor V 1.0b Public - ' + Title;

        Form1.Caption := unitochar(tmp2, 1000);
        curepi := GetEpisode;
        exit;
      end;
      if (OpenDialog1.FilterIndex = 1) or (OpenDialog1.FilterIndex = 2) then
      begin
        qstfilecount := 2;
        qstfile[0].name := extractfilename(fn);
        f := fileopen(fn, $40);
        i := fileseek(f, 0, 2);
        fileseek(f, 0, 0);
        qstfile[0].data := allocmem(i);
        qstfile[0].size := i;
        fileread(f, qstfile[0].data[0], qstfile[0].size);
        fileclose(f);

        qstfile[1].name := changefileext(extractfilename(fn), '.dat');
        f := fileopen(changefileext(fn, '.dat'), $40);
        i := fileseek(f, 0, 2);
        fileseek(f, 0, 0);
        qstfile[1].data := allocmem(i);
        qstfile[1].size := i;
        fileread(f, qstfile[1].data[0], qstfile[1].size);
        fileclose(f);
      end;
      if (OpenDialog1.FilterIndex = 3) or (OpenDialog1.FilterIndex = 4) or (OpenDialog1.FilterIndex = 5) then
      begin
        // its in a qst extract the files
        f := fileopen(fn, $40);
        i := fileread(f, unp[0], 4);
        // detect the version
        F1 := 0; // default pc
        if unp[0] = $44 then
        begin
          F1 := 1; // gc /dc
        end;
        if unp[0] = $A6 then
          F1 := 1; // dc download quest
        if (unp[2] = $44) and (unp[0] = $58) then
          F1 := 2; // bb format
        if F1 = 2 then
          OpenDialog1.FilterIndex := 4;
        if F1 = 2 then
          AsmMode := 2;
        if (unp[0] = $A6) or (unp[2] = $A6) then
          OpenDialog1.FilterIndex := 5;
        // get the header
        while i = 4 do
        begin
          if F1 = 1 then
            F2 := unp[2] + (unp[3] * 256) // packet size
          else
            F2 := unp[0] + (unp[1] * 256);
          tf := unp[2];
          if F1 = 1 then
            tf := unp[0];
          if F1 = 2 then
          begin
            fileread(f, unp[0], 4);
            dec(F2, 4);
          end;
          fileread(f, unp[0], F2 - 4);
          // file creator
          if (tf = $44) or (tf = $A6) then
          begin
            if F1 = 1 then
              if byte(unp[$23]) < 3 then
                AsmMode := 2;
            tmp := pansichar(@unp[$24]);
            if (F1 = 1) and (byte(unp[$23]) >= 3) then
              tmp := pansichar(@unp[$23]);
            qstfile[qstfilecount].name := tmp;
            qstfile[qstfilecount].from := 0;
            move(unp[$34], qstfile[qstfilecount].size, 4);
            qstfile[qstfilecount].data := allocmem(qstfile[qstfilecount].size);
            qstfile[qstfilecount].size := 0;
            inc(qstfilecount);
          end;

          if (tf = $13) or (tf = $A7) then
          begin
            tmp := pansichar(@unp[0]);
            move(unp[$410], y, 4);
            for x := 0 to qstfilecount - 1 do
              if tmp = qstfile[x].name then
                break;
            move(unp[16], qstfile[x].data[qstfile[x].size], y);
            inc(qstfile[x].size, y);
            if F1 = 2 then
              if (F2 div 8) * 8 = F2 then
                fileread(f, unp[0], 4);
          end;

          i := fileread(f, unp, 4);
        end;
        fileclose(f);
        if OpenDialog1.FilterIndex = 5 then
        begin
          for x := 0 to qstfilecount - 1 do
            if (pos('.bin', lowercase(qstfile[x].name)) > 0) or (pos('.dat', lowercase(qstfile[x].name)) > 0) then
            begin
              move(qstfile[x].data[4], si, 4);
              setlength(tmp, qstfile[x].size - 8);
              move(qstfile[x].data[8], tmp[1], qstfile[x].size - 8);
              CreateKey(si, 0);
              tmp := PSOEnc(tmp, 0, 0);
              dec(qstfile[x].size, 8);
              move(tmp[1], qstfile[x].data[0], qstfile[x].size);
            end;
        end;
      end;

      If OpenDialog1.FilterIndex > 1 then
      begin
        // compressed file, unpack them
        di := allocmem(10000000);
        for x := 0 to qstfilecount - 1 do
          if (pos('.bin', lowercase(qstfile[x].name)) > 0) or (pos('.dat', lowercase(qstfile[x].name)) > 0) then
          begin
            y := PikaDecompress(qstfile[x].data, di, qstfile[x].size);
            freemem(qstfile[x].data);
            qstfile[x].size := y;
            qstfile[x].data := allocmem(y);
            move(di[0], qstfile[x].data[0], y);
          end;
        freemem(di);
      end;
    except
      MessageDlg(GetLanguageString(57), mtInformation, [mbOk], 0);

    end;
    // clear map data
    // mapfilename:=path+'map\map_forest01c.rel';
    Zoom := 5;
    sms := 0;
    for x := 0 to 30 do
    begin
      Floor[x].MonsterCount := 0;
      Floor[x].ObjCount := 0;
      Floor[x].UnknowCount := 0;
      Floor[x].d04count := 0;
      Floor[x].d05count := 0;
      CheckListBox1.Checked[x] := false;
      CheckListBox1.Items.Strings[x] := GetLanguageString(58);
      mapfile[x] := '';
      // mapfile[x]:=path+'map\'+mapfilename[mapid[x+EPMap[curepi]]];
      // Form1.CheckListBox1.Items.Strings[x]:=mapname[mapid[x+EPMap[curepi]]];
    end;

    // load map object and monster
    try
      for f := 0 to qstfilecount - 1 do
        if pos('.dat', lowercase(qstfile[f].name)) > 0 then
          break;

      y := 0;
      while y < qstfile[f].size do
      begin
        move(qstfile[f].data[y], h, 16);
        inc(y, 16);
        if (h.TotalSize = 0) and (h.flag = 0) then
          break;
        CheckListBox1.Checked[h.floorid] := true;
        if h.flag <> 0 then
          if h.flag = 1 then
          begin // object groupe
            Floor[h.floorid].ObjCount := h.DataLength div $44;
            move(qstfile[f].data[y], Floor[h.floorid].Obj[0], h.DataLength);
            inc(y, h.DataLength);
          end
          else if h.flag = 2 then
          begin // monster groupe
            Floor[h.floorid].MonsterCount := h.DataLength div $48;
            move(qstfile[f].data[y], Floor[h.floorid].Monster[0], h.DataLength);
            inc(y, h.DataLength);
          end
          else if h.flag = 3 then
          begin // unknow groupe
            Floor[h.floorid].UnknowCount := h.DataLength;
            move(qstfile[f].data[y], Floor[h.floorid].Unknow[0], h.DataLength);
            inc(y, h.DataLength);
          end
          else if h.flag = 4 then
          begin // unknow groupe
            Floor[h.floorid].d04count := h.DataLength;
            move(qstfile[f].data[y], Floor[h.floorid].d04[0], h.DataLength);
            inc(y, h.DataLength);
          end
          else if h.flag = 5 then
          begin // unknow groupe
            Floor[h.floorid].d05count := h.DataLength;
            move(qstfile[f].data[y], Floor[h.floorid].d05[0], h.DataLength);
            inc(y, h.DataLength);
          end
          else
          begin
            MessageDlg(GetLanguageString(59) + inttostr(h.flag) + GetLanguageString(60) + ' ' + inttohex(y, 8),
              mtInformation, [mbOk], 0);
            inc(y, h.DataLength);
          end;

      end;

    except
      MessageDlg(GetLanguageString(61), mtInformation, [mbOk], 0);
    end;

    // load quest description
    try
      for f := 0 to qstfilecount - 1 do
        if pos('.bin', lowercase(qstfile[f].name)) > 0 then
          break;
      y := 20;
      move(qstfile[f].data[0], seg, 16);
      move(qstfile[f].data[16], language, 2);
      language := language and 255;
      move(qstfile[f].data[18], qnum, 2);
      if OpenDialog1.FilterIndex = 4 then
      begin
        y := 24;
        language := 0;
        move(qstfile[f].data[16], qnum, 2);
      end;
      if pos('_f.', fn) > 0 then
        language := 3;
      if pos('_e.', fn) > 0 then
        language := 1;
      if pos('_s.', fn) > 0 then
        language := 4;
      if pos('_g.', fn) > 0 then
        language := 2;
      if pos('_k.', fn) > 0 then
        language := 0;
      if pos('_j.', fn) > 0 then
        language := 0;
      if pos('_c.', fn) > 0 then
        language := 0;
      if pos('.qst.fr', fn) > 0 then
        language := 3;
      if pos('.qst.en', fn) > 0 then
        language := 1;
      if pos('.qst.sp', fn) > 0 then
        language := 4;
      if pos('.qst.ge', fn) > 0 then
        language := 2;
      if pos('.qst.kr', fn) > 0 then
        language := 0;
      if pos('.qst.jp', fn) > 0 then
        language := 0;
      if pos('.qst.cn', fn) > 0 then
        language := 0;

      move(qstfile[f].data[y], txt[0], seg[0] - 20);

      if seg[0] = $1D4 then
      begin
        isdc := true;
        Title := chartouni2(pansichar(@txt[0]));
        tmp2 := chartouni2(pansichar(@txt[$20]));
      end
      else
      begin
        Title := pwidechar(@txt[0]);
        tmp2 := pwidechar(@txt[$40]);
        isdc := false;
        if seg[0] = 4652 then
        begin
          move(txt[$384], BBData[0], $E90);
        end;
      end;
      Info := '';
      for y := 1 to length(tmp2) do
        if tmp2[y] = #10 then
          Info := Info + #13#10
        else
          Info := Info + tmp2[y];

      if seg[0] = $1D4 then
        tmp2 := chartouni2(pansichar(@txt[$A0]))
      else
        tmp2 := pwidechar(@txt[$140]);
      Desc := '';
      for y := 1 to length(tmp2) do
        if tmp2[y] = #10 then
          Desc := Desc + #13#10
        else
          Desc := Desc + tmp2[y];

      move(qstfile[f].data[seg[0]], AsmData[0], seg[1] - seg[0]);
      move(qstfile[f].data[seg[1]], AsmRef[0], seg[2] - seg[1]); // fncoff
      asmdatas := seg[1] - seg[0];
      asmrefs := (seg[2] - seg[1]) div 4;
    except
      MessageDlg(GetLanguageString(62), mtInformation, [mbOk], 0);
    end;
    try
      for x := 0 to 1000 do
        datablock[x] := -1;
      if pos('_f.', fn) > 0 then
        language := 3;
      if pos('_e.', fn) > 0 then
        language := 1;
      if pos('_s.', fn) > 0 then
        language := 4;
      if pos('_g.', fn) > 0 then
        language := 2;
      if pos('_k.', fn) > 0 then
        language := 0;
      if pos('_j.', fn) > 0 then
        language := 0;
      if pos('_c.', fn) > 0 then
        language := 0;
      if pos('.qst.fr', fn) > 0 then
        language := 3;
      if pos('.qst.en', fn) > 0 then
        language := 1;
      if pos('.qst.sp', fn) > 0 then
        language := 4;
      if pos('.qst.ge', fn) > 0 then
        language := 2;
      if pos('.qst.kr', fn) > 0 then
        language := 0;
      if pos('.qst.jp', fn) > 0 then
        language := 0;
      if pos('.qst.cn', fn) > 0 then
        language := 0;

      if OpenDialog1.FilterIndex = 2 then begin
        // detect asm mode
        form34.showmodal;
      end;
      QuestDisam(@AsmData, AsmRef, seg[1] - seg[0], (seg[2] - seg[1]) div 4);
    except
      MessageDlg(GetLanguageString(63), mtInformation, [mbOk], 0);
    end;
    // here all is loaded try to disasemble the action
    if curepi < 2 then
    begin
      for x := 0 to 30 do
      begin
        if mapid[x + EPMap[curepi]] < 123 then
          if mapfile[x] = '' then
          begin
            mapfile[x] := path + 'map\' + mapfilename[mapid[x + EPMap[curepi]]];
            mapxvmfile[x] := path + 'map\xvm\' + mapxvmname[mapid[x + EPMap[curepi]]];
            Form1.CheckListBox1.Items.Strings[x] := mapname[mapid[x + EPMap[curepi]]];
            Floor[x].floorid := maparea[mapid[x + EPMap[curepi]]];
          end;
      end;
    end
    else
    begin
      mapfile[0] := path + 'map\' + mapfilename[122];
      Form1.CheckListBox1.Items.Strings[0] := mapname[122];
      for x := 0 to 29 do
      begin
        if mapid[x + EPMap[curepi]] < 123 then
        begin
          if mapfile[x + 1] = '' then
          begin
            mapfile[x + 1] := path + 'map\' + mapfilename[mapid[x + EPMap[curepi]]];
            mapxvmfile[x + 1] := path + 'map\xvm\' + mapxvmname[mapid[x + EPMap[curepi]]];
            Form1.CheckListBox1.Items.Strings[x + 1] := mapname[mapid[x + EPMap[curepi]]];
            Floor[x + 1].floorid := maparea[mapid[x + EPMap[curepi]]];
          end;
        end
        else
        begin

        end;
      end;
    end;

    // ...
    CheckListBox1.ItemIndex := 0;
    CheckListBox1Click(Form1);
    // Form1.Caption:='Quest Editor V 1.6d - '+Title;
    tmp2 := 'Quest Editor V 1.0b Public - ' + Title;
    { if isdc then Form1.Caption:=Form1.Caption+' (DreamCast ASCII Format)'
      else Form1.Caption:=Form1.Caption+' (PC Unicode Format)';
      if curepi = 0 then  Form1.Caption:=Form1.Caption+' - Episode 1';
      if curepi = 1 then  Form1.Caption:=Form1.Caption+' - Episode 2';
      if curepi = 2 then  Form1.Caption:=Form1.Caption+' - Episode 4';
      if asmmode = 2 then
      Form1.Caption:=Form1.Caption+' - Scrypt Mode 2'; }

    if isdc then
      tmp2 := tmp2 + GetLanguageString(64)
    else
      tmp2 := tmp2 + GetLanguageString(65);
    if curepi = 0 then
      tmp2 := tmp2 + GetLanguageString(66);
    if curepi = 1 then
      tmp2 := tmp2 + GetLanguageString(67);
    if curepi = 2 then
      tmp2 := tmp2 + GetLanguageString(68);
    if AsmMode = 2 then
      tmp2 := tmp2 + GetLanguageString(69);
    tmp2 := tmp2 + #0#0;
    FFilter := 1;
    if AsmMode = 2 then
      FFilter := 3;
    if isdc and (AsmMode = 2) then
      FFilter := 2;
    // SetWindowTextW(form1.Handle,@tmp2[1]);
    Form1.Caption := unitochar(tmp2, 1000);
    CheckShadow;
  end;
end;

Function GetObjName(id: integer): ansistring;
var
  x, y: integer;
  a: ansistring;
begin
  a := inttostr(id) + #9;
  for x := 0 to ItemsName.count - 1 do
    if copy(ItemsName.Strings[x], 1, length(a)) = a then
      break;
  if x < ItemsName.count then
  begin
    for y := 0 to length(ItemsName.Strings[x]) - length(a) - 1 do
      if ItemsName.Strings[x][1 + length(a) + y] = #9 then
        break;
    result := copy(ItemsName.Strings[x], 1 + length(a), y);
  end
  else
    result := GetLanguageString(70) + ' ' + a;
end;

Function GetMonsterName(id: integer): ansistring;
var
  x, y: integer;
  a: ansistring;
begin
  a := inttostr(id) + #9;
  for x := 0 to Monsterini.count - 1 do
    if copy(Monsterini.Strings[x], 1, length(a)) = a then
      break;
  if x < Monsterini.count then
  begin
    for y := 0 to length(Monsterini.Strings[x]) - length(a) - 1 do
      if Monsterini.Strings[x][1 + length(a) + y] = #9 then
        break;
    result := copy(Monsterini.Strings[x], 1 + length(a), y);
  end
  else
    result := GetLanguageString(71) + ' ' + a;
end;

Function GetObjParam(id: integer): tstringlist;
var
  x, y: integer;
  a: ansistring;
begin
  result := tstringlist.Create;
  a := inttostr(id) + #9;
  for x := 0 to ItemsName.count - 1 do
    if copy(ItemsName.Strings[x], 1, length(a)) = a then
      break;
  if x < ItemsName.count then
  begin
    a := ItemsName.Strings[x];
    y := pos(#9, a);
    delete(a, 1, y);
    y := pos(#9, a);
    if y = 0 then
      y := length(a);
    delete(a, 1, y);
    y := pos(#9, a);
    result.Add(copy(a, 1, y - 1));
    delete(a, 1, y);
    y := pos(#9, a);
    result.Add(copy(a, 1, y - 1));
    delete(a, 1, y);
    y := pos(#9, a);
    result.Add(copy(a, 1, y - 1));
    delete(a, 1, y);
    y := pos(#9, a);
    result.Add(copy(a, 1, y - 1));
    delete(a, 1, y);
    y := pos(#9, a);
    result.Add(copy(a, 1, y - 1));
    delete(a, 1, y);
    y := pos(#9, a);
    result.Add(copy(a, 1, y - 1));
    delete(a, 1, y);
    y := pos(#9, a);
    result.Add(copy(a, 1, y - 1));
    delete(a, 1, y);
    y := pos(#9, a);
    result.Add(copy(a, 1, y - 1));
    delete(a, 1, y);
    y := pos(#9, a);
    result.Add(copy(a, 1, y - 1));
    delete(a, 1, y);
    result.Add(a);
  end
  else
  begin
    result.Add('Rotation X');
    result.Add('Rotation Y');
    result.Add('Rotation Z');
    result.Add('Active range');
    result.Add('Unknown');
    result.Add('Unknown');
    result.Add('Action');
    result.Add('Unknown');
    result.Add('Unknown');
    result.Add('Unknown');
  end;
end;

Function GetMonsterParam(id: integer): tstringlist;
var
  x, y, i: integer;
  a: ansistring;
begin
  result := tstringlist.Create;
  a := inttostr(id) + #9;
  for x := 0 to Monsterini.count - 1 do
    if copy(Monsterini.Strings[x], 1, length(a)) = a then
      break;
  if x < Monsterini.count then
  begin
    a := Monsterini.Strings[x];
    y := pos(#9, a);
    delete(a, 1, y);
    y := pos(#9, a);
    if y = 0 then
      y := length(a);
    delete(a, 1, y);
    for i := 0 to 20 do
    begin
      y := pos(#9, a);
      result.Add(copy(a, 1, y - 1));
      delete(a, 1, y);
    end;
    result.Add(a);
  end
  else
  begin
    result.Add('Skin');
    result.Add('Unknow');
    result.Add('Unknow');
    result.Add('Child Count ');
    result.Add('Unknow ');
    result.Add('Unknow ');
    result.Add('Map Section ');
    result.Add('Wave number ');
    result.Add('Wave number ');
    result.Add('Pos X');
    result.Add('Pos Y');
    result.Add('Pos Z');
    result.Add('Rot X');
    result.Add('Rot Y');
    result.Add('Rot Z');
    result.Add('Movement Data ');
    result.Add('Unknow');
    result.Add('Unknow');
    result.Add('Char Id ');
    result.Add('Action');
    result.Add('Flag 1');
    result.Add('Flag 2');
  end;
end;

procedure SetMonsterDefaults();
begin
  // Set default monster position based on user's setting
  Floor[sfloor].Monster[Floor[sfloor].MonsterCount - 1].map_section := FPlacementOptions.seDefaultSect.Value;
  Floor[sfloor].Monster[Floor[sfloor].MonsterCount - 1].Pos_X := FPlacementOptions.nbDefaultX.Value;
  Floor[sfloor].Monster[Floor[sfloor].MonsterCount - 1].Pos_Y := FPlacementOptions.nbDefaultZ.Value;
  Floor[sfloor].Monster[Floor[sfloor].MonsterCount - 1].Pos_Z := FPlacementOptions.nbDefaultY.Value;
end;

procedure SetObjectDefaults();
begin
  // Set default object position based on user's setting
  Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1].map_section := FPlacementOptions.seDefaultSect.Value;
  Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1].Pos_X := FPlacementOptions.nbDefaultX.Value;
  Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1].Pos_Y := FPlacementOptions.nbDefaultZ.Value;
  Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1].Pos_Z := FPlacementOptions.nbDefaultY.Value;
end;

procedure ShowIndicator();
begin
  if not Form1.smDisableIndicator.Checked then
  begin
    Form1.lblStatus.Visible := true;
    Form1.lblModifiers.Visible := true;
  end;
end;

procedure HideIndicator();
begin
  if not Form1.smDisableIndicator.Checked then
  begin
    Form1.lblStatus.Visible := false;
    Form1.lblModifiers.Visible := false;
  end;
end;

procedure AdjustDistanceX(target: integer);
var
  i,diff,diffmin,count: integer;
  selectionX,targetX: single;
begin
  if FPlacementOptions.chkSnapDistance.Checked then
  begin
    if have3d and form13.Focused then
      MoveSel := Selected;

    diffmin := 0;
    count := 0;

    if sType = 1 then
    begin
      selectionX := Floor[sfloor].Monster[MoveSel].Pos_X;
      targetX := Floor[sfloor].Monster[target].Pos_X;
      if selectionX < targetX then
      begin
         for i := 0 to Floor[sfloor].MonsterCount - 1 do
         begin
          // Make sure the monster is visible and of the same section
          if (Floor[sfloor].Monster[i].map_section = Floor[sfloor].Monster[MoveSel].map_section) and
            ((Floor[sfloor].Monster[i].Unknow5 = showwave) or (showwave = -1)) and (Floor[sfloor].Monster[i].Pos_X > targetX)
            and (i <> target) and (i <> MoveSel) then
            begin
              // Find closest monster in opposite direction that is not the snap target or selection
              diff := round(Floor[sfloor].Monster[i].Pos_X - targetX);
              count := count + 1;
              if diff > diffmin then
              begin
                diffmin := diff;
              end;
            end;
         end;
         if (diffmin <> 0) and (count <> 0) then
          Floor[sfloor].Monster[MoveSel].Pos_X := targetX - (diffmin / count);
      end
      else if selectionX > targetX then
      begin
         for i := 0 to Floor[sfloor].MonsterCount - 1 do
         begin
          if (Floor[sfloor].Monster[i].map_section = Floor[sfloor].Monster[MoveSel].map_section) and
            ((Floor[sfloor].Monster[i].Unknow5 = showwave) or (showwave = -1)) and (Floor[sfloor].Monster[i].Pos_X < targetX)
            and (i <> target) and (i <> MoveSel) then
            begin
              diff := round(targetX - Floor[sfloor].Monster[i].Pos_X);
              count := count + 1;
              if diff > diffmin then
              begin
                diffmin := diff;
              end;
            end;
         end;
         if (diffmin <> 0) and (count <> 0) then
          Floor[sfloor].Monster[MoveSel].Pos_X := targetX + (diffmin / count);
      end;
    end;

    if sType = 2 then
    begin
      selectionX := Floor[sfloor].Obj[MoveSel].Pos_X;
      targetX := Floor[sfloor].Obj[target].Pos_X;

      if selectionX < targetX then
      begin
         for i := 0 to Floor[sfloor].ObjCount - 1 do
         begin
          // Make sure the object is visible and of the same section
          if (Floor[sfloor].Obj[i].map_section = Floor[sfloor].Obj[MoveSel].map_section) and
            ((Floor[sfloor].Obj[i].Unknow5 = showwave) or (showwave = -1)) and (Floor[sfloor].Obj[i].Pos_X > targetX)
            and (i <> target) and (i <> MoveSel) then
            begin
            // Find closest object in opposite direction that is not the snap target or selection
            diff := round(Floor[sfloor].Obj[i].Pos_X - targetX);
            count := count + 1;
            if diff > diffmin then
            begin
              diffmin := diff;
              end;
            end;
         end;
         if (diffmin <> 0) and (count <> 0) then
          Floor[sfloor].Obj[MoveSel].Pos_X := targetX - (diffmin / count);
      end
      else if selectionX > targetX then
      begin
         for i := 0 to Floor[sfloor].ObjCount - 1 do
         begin
          if (Floor[sfloor].Obj[i].map_section = Floor[sfloor].Obj[MoveSel].map_section) and
            ((Floor[sfloor].Obj[i].Unknow5 = showwave) or (showwave = -1)) and (Floor[sfloor].Obj[i].Pos_X < targetX)
            and (i <> target) and (i <> MoveSel) then
            begin
            diff := round(targetX - Floor[sfloor].Obj[i].Pos_X);
            count := count + 1;
            if diff > diffmin then
            begin
              diffmin := diff;
              end;
            end;
         end;
         if (diffmin <> 0) and (count <> 0) then
          Floor[sfloor].Obj[MoveSel].Pos_X := targetX + (diffmin / count);
      end;
    end;
  end;
end;

procedure AdjustDistanceY(target: integer);
var
  i, diff,diffmin,count: integer;
  selectionY,targetY: single;
begin
  if FPlacementOptions.chkSnapDistance.Checked then
  begin
    if have3d and form13.Focused then
      MoveSel := Selected;

    diffmin := 0;
    count := 0;

    if sType = 1 then
    begin
      selectionY := Floor[sfloor].Monster[MoveSel].Pos_Y;
      targetY := Floor[sfloor].Monster[target].Pos_Y;

      if selectionY < targetY then
      begin
         for i := 0 to Floor[sfloor].MonsterCount - 1 do
         begin
          // Make sure the monster is visible and of the same section
          if (Floor[sfloor].Monster[i].map_section = Floor[sfloor].Monster[MoveSel].map_section) and
            ((Floor[sfloor].Monster[i].Unknow5 = showwave) or (showwave = -1)) and (Floor[sfloor].Monster[i].Pos_Y > targetY)
            and (i <> target) and (i <> MoveSel) then
            begin
            // Find closest monster in opposite direction that is not the snap target or selection
            diff := round(Floor[sfloor].Monster[i].Pos_Y - targetY);
            count := count + 1;
            if diff > diffmin then
            begin
              diffmin := diff;
              end;
            end;
         end;
         if (diffmin <> 0) and (count <> 0) then
           Floor[sfloor].Monster[MoveSel].Pos_Y := targetY - (diffmin / count);
      end
      else if selectionY > targetY then
      begin
         for i := 0 to Floor[sfloor].MonsterCount - 1 do
         begin
          if (Floor[sfloor].Monster[i].map_section = Floor[sfloor].Monster[MoveSel].map_section) and
            ((Floor[sfloor].Monster[i].Unknow5 = showwave) or (showwave = -1)) and (Floor[sfloor].Monster[i].Pos_Y < targetY)
            and (i <> target) and (i <> MoveSel) then
            begin
            diff := round(targetY - Floor[sfloor].Monster[i].Pos_Y);
            count := count + 1;
            if diff > diffmin then
            begin
              diffmin := diff;
              end;
            end;
         end;
         if (diffmin <> 0) and (count <> 0) then
           Floor[sfloor].Monster[MoveSel].Pos_Y := targetY + (diffmin / count);
      end;
    end;

    if sType = 2 then
    begin
      selectionY := Floor[sfloor].Obj[MoveSel].Pos_Y;
      targetY := Floor[sfloor].Obj[target].Pos_Y;

      if selectionY < targetY then
      begin
         for i := 0 to Floor[sfloor].ObjCount - 1 do
         begin
          // Make sure the object is visible and of the same section
          if (Floor[sfloor].Obj[i].map_section = Floor[sfloor].Obj[MoveSel].map_section) and
            ((Floor[sfloor].Obj[i].Unknow5 = showwave) or (showwave = -1)) and (Floor[sfloor].Obj[i].Pos_Y > targetY)
            and (i <> target) and (i <> MoveSel) then
            begin
            // Find closest object in opposite direction that is not the snap target or selection
            diff := round(Floor[sfloor].Obj[i].Pos_Y - targetY);
            count := count + 1;
            if diff > diffmin then
            begin
              diffmin := diff;
              end;
            end;
         end;
         if (diffmin <> 0) and (count <> 0) then
          Floor[sfloor].Obj[MoveSel].Pos_Y := targetY - (diffmin / count);
      end
      else if selectionY > targetY then
      begin
         for i := 0 to Floor[sfloor].ObjCount - 1 do
         begin
          if (Floor[sfloor].Obj[i].map_section = Floor[sfloor].Obj[MoveSel].map_section) and
            ((Floor[sfloor].Obj[i].Unknow5 = showwave) or (showwave = -1)) and (Floor[sfloor].Obj[i].Pos_Y < targetY)
            and (i <> target) and (i <> MoveSel) then
            begin
            diff := round(targetY - Floor[sfloor].Obj[i].Pos_Y);
            count := count + 1;
            if diff > diffmin then
            begin
              diffmin := diff;
              end;
            end;
         end;
         if (diffmin <> 0) and (count <> 0) then
          Floor[sfloor].Obj[MoveSel].Pos_Y := targetY + (diffmin / count);
      end;
    end;
  end;
end;

procedure TForm1.CheckListBox1Click(Sender: TObject);
var
  x: integer;
begin
  if CheckListBox1.ItemIndex >= 0 then
  begin
    HideIndicator();
    Copylastmonster1.Enabled := false;
    Copylastitem1.Enabled := false;
    ListBox1.Clear;
    ListBox2.Clear;
    Selected := -1;
    if not ctrldw then
    begin
      mpx := 0;
      mpy := 0;
    end;
    { if CheckListBox1.ItemIndex = 0 then mapfilename:=path+'map\map_city00_00c.rel';
      if CheckListBox1.ItemIndex = 1 then mapfilename:=path+'map\map_forest01c.rel';
      if CheckListBox1.ItemIndex = 2 then mapfilename:=path+'map\map_forest02c.rel';
      if CheckListBox1.ItemIndex = 11 then mapfilename:=path+'map\map_boss01c.rel';
      if CheckListBox1.ItemIndex = 12 then mapfilename:=path+'map\map_boss02c.rel';
      if CheckListBox1.ItemIndex = 13 then mapfilename:=path+'map\map_boss03c.rel';
      if CheckListBox1.ItemIndex = 14 then mapfilename:=path+'map\map_darkfalz00c.rel';
      if (CheckListBox1.ItemIndex > 2) and (CheckListBox1.ItemIndex < 11) then }
    mapfilenam := mapfile[CheckListBox1.ItemIndex];
    Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
    Button2.Enabled := false;
    Button1.Enabled := false;
    Button3.Enabled := false;
    smEdit.Enabled := false;
    smDelete.Enabled := false;
    smMove.Enabled := false;
    sfloor := CheckListBox1.ItemIndex;
    for x := 0 to Floor[sfloor].MonsterCount - 1 do
    begin
      ListBox1.Items.Add('#' + inttostr(x) + ' - ' + GenerateMonsterName(Floor[sfloor].Monster[x], x, 0));
    end;

    for x := 0 to Floor[sfloor].ObjCount - 1 do
    begin
      ListBox2.Items.Add('#' + inttostr(x) + ' - ' + GetObjName(Floor[sfloor].Obj[x].Skin));
    end;
    if Floor[sfloor].d04count = 0 then
      Button12.Enabled := false
    else
      Button12.Enabled := true;
    DrawMap;
    if have3d then
      load3d;
  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  p: double;
begin
  if Zoom > 0.02 then
  begin
    Zoom := Zoom / 1.1;
    p := (5 / Zoom) * 100;
    Label6.Caption := GetLanguageString(38) + ' ' + inttostr(round(p)) + '%';
    DrawMap;
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  p: double;
begin
  if Zoom < 40 then
  begin
    Zoom := Zoom * 1.1;
    p := (5 / Zoom) * 100;
    Label6.Caption := GetLanguageString(38) + ' ' + inttostr(round(p)) + '%';
    DrawMap;
  end;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
var
  bm: TBitmap;
  na: ansistring;
  hs: TMemoryStream;
  x: integer;
begin
  if ListBox1.ItemIndex >= 0 then
  begin
    Selected := ListBox1.ItemIndex;
    ListBox2.ItemIndex := -1;
    MoveSel := -1;
    HideIndicator();
    stype := 1;
    Button2.Enabled := true;
    Button1.Enabled := true;
    Button3.Enabled := true;
    smEdit.Enabled := true;
    smDelete.Enabled := true;
    smMove.Enabled := true;
    sms := Floor[sfloor].Monster[Selected].map_section;
    DrawMap;
    Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
    bm := TBitmap.Create;

    { if (round(floor[sfloor].Monster[selected].Movement_flag) = 0)
      or (floor[sfloor].Monster[selected].Skin<$33) then begin
      if fileexists(path+'img\'+inttohex(floor[sfloor].Monster[selected].Skin,2)+'.bmp') then
      bm.LoadFromFile(path+'img\'+inttohex(floor[sfloor].Monster[selected].Skin,2)+'.bmp')
      else bm.LoadFromFile(path+'img\unknow.bmp');
      end else begin
      if fileexists(path+'img\'+inttohex(floor[sfloor].Monster[selected].Skin,2)+'-'
      +inttostr(round(floor[sfloor].Monster[selected].Movement_flag))+'.bmp') then
      bm.LoadFromFile(path+'img\'+inttohex(floor[sfloor].Monster[selected].Skin,2)+'-'
      +inttostr(round(floor[sfloor].Monster[selected].Movement_flag))+'.bmp')
      else bm.LoadFromFile(path+'img\unknow.bmp');
      end; }
    hs := TMemoryStream.Create;
    na := GenerateMonsterName(Floor[sfloor].Monster[Selected], Selected, -1) + '.bmp';
    if fileexists(path + 'img\' + na) then
      bm.LoadFromFile(path + 'img\' + na)
    else if PikaGetFile(hs, na, path + 'images.ppk', 'Build By Schthack') = 0 then
      bm.LoadFromStream(hs)
    else if PikaGetFile(hs, 'unknow.bmp', path + 'images.ppk', 'Build By Schthack') = 0 then
      bm.LoadFromStream(hs)
    else if fileexists(path + 'img\unknow.bmp') then
      bm.LoadFromFile(path + 'img\unknow.bmp');
    hs.Free;
    Image1.Canvas.Draw(2, 2, bm);
    Image1.Canvas.TextOut(52, 4, 'Skin : ' + inttostr(Floor[sfloor].Monster[Selected].Skin));
    Image1.Canvas.TextOut(130, 4, 'Map Section : ' + inttostr(Floor[sfloor].Monster[Selected].map_section));
    Image1.Canvas.TextOut(250, 4, 'Wave #' + inttostr(round(Floor[sfloor].Monster[Selected].Unknow5)));
    for x := 0 to 57 do
      if EnemyID[x] = Floor[sfloor].Monster[Selected].Skin then
        break;
    if x = 58 then
    begin
      Image1.Canvas.TextOut(330, 4, 'ID : ' + inttostr(round(Floor[sfloor].Monster[Selected].Char_id)));
      Image1.Canvas.TextOut(420, 4, 'Script ID : ' + inttostr(round(Floor[sfloor].Monster[Selected].Action)));
    end;

    Image1.Canvas.TextOut(52, 22, 'Pos X : ' + inttostr(round(Floor[sfloor].Monster[Selected].Pos_X)));
    Image1.Canvas.TextOut(130, 22, 'Pos Y : ' + inttostr(round(Floor[sfloor].Monster[Selected].Pos_Z)));
    Image1.Canvas.TextOut(250, 22, 'Pos Z : ' + inttostr(round(Floor[sfloor].Monster[Selected].Pos_Y)));
    Image1.Canvas.TextOut(330, 22, 'Rotation : ' + inttostr((Floor[sfloor].Monster[Selected].Direction) and
      $FFFF div 182) + '°');

    bm.Free;
  end;
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin
  Form1.Button2Click(nil);
end;

procedure TForm1.ListBox2Click(Sender: TObject);
var
  bm: TBitmap;
  t: Single;
  hs: TMemoryStream;
begin
  if ListBox2.ItemIndex >= 0 then
  begin
    Selected := ListBox2.ItemIndex;
    HideIndicator();
    MoveSel := -1;
    Button2.Enabled := true;
    Button1.Enabled := true;
    Button3.Enabled := true;
    smEdit.Enabled := true;
    smDelete.Enabled := true;
    smMove.Enabled := true;
    ListBox1.ItemIndex := -1;
    sms := Floor[sfloor].Obj[Selected].map_section;
    stype := 2;
    DrawMap;
    Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
    { if fileexists(path+'img\i'+inttohex(floor[sfloor].obj[selected].Skin,2)+'.bmp') then
      Image3.Picture.LoadFromFile(path+'img\i'+inttohex(floor[sfloor].obj[selected].Skin,2)+'.bmp')
      else Image3.Picture.LoadFromFile(path+'img\unknow.bmp'); }

    if objscreen = nil then
    begin
      objscreen := TPikaEngine.Create(form10.Panel1.Handle, 177, 151, 1);
      if objscreen.Enable then
      begin
        objscreen.AlphaEnabled := true;
        objscreen.AlphaTestValue := 16;
        objscreen.Antializing := true;
        objscreen.ViewDistance := 0;
        objscreen.TextureMirrored := true;
        objscreen.BackGroundColor := $FFA0A0A0;
        objitm := t3ditem.Create(objscreen);
        form10.Timer1.Enabled := true;
      end;
    end;
    if objscreen.Enable then
    begin
      objscreen.BackGroundColor := $FFA0A0A0;
      if objitm <> nil then
        objitm.Free;
      objitm := nil;
      objitm := t3ditem.Create(objscreen);
      Generateobj(Floor[sfloor].Obj[Selected], -2);
      if objitm.Color and $FFFFFF = $FFFFFF then
        objitm.Color := $FEFEFE;
      objitm.Visible := true;
      t := objitm.GetLargessVertex;
      objscreen.LookAt(0, t, -(t * 1.7), 0, t / 2, 0);
      objitm.SetRotation(15, 0, 0);
      objscreen.RenderSurface;
      objscreen.GetBitmap(bm);

    end
    else
    begin
      bm := TBitmap.Create;
      hs := TMemoryStream.Create;
      if fileexists(path + 'img\i' + inttohex(Floor[sfloor].Obj[Selected].Skin, 2) + '.bmp') then
        bm.LoadFromFile(path + 'img\i' + inttohex(Floor[sfloor].Obj[Selected].Skin, 2) + '.bmp')
      else if PikaGetFile(hs, 'unknow.bmp', path + 'images.ppk', 'Build By Schthack') = 0 then
        bm.LoadFromStream(hs)
      else
        bm.LoadFromFile(path + 'img\unknow.bmp');
      hs.Free;
    end;

    Image1.Canvas.StretchDraw(Rect(2, 2, 45, 45), bm);
    Image1.Canvas.TextOut(52, 4, 'Skin : ' + inttostr(Floor[sfloor].Obj[Selected].Skin));
    Image1.Canvas.TextOut(150, 4, 'Map Section : ' + inttostr(Floor[sfloor].Obj[Selected].map_section));
    Image1.Canvas.TextOut(52, 22, 'Pos X : ' + inttostr(round(Floor[sfloor].Obj[Selected].Pos_X)));
    Image1.Canvas.TextOut(150, 22, 'Pos Y : ' + inttostr(round(Floor[sfloor].Obj[Selected].Pos_Z)));
    Image1.Canvas.TextOut(260, 22, 'Pos Z : ' + inttostr(round(Floor[sfloor].Obj[Selected].Pos_Y)));
    Image1.Canvas.TextOut(260, 4, 'Direction : ' + inttostr((Floor[sfloor].Obj[Selected].unknow6 and $FFFF)
      div 182) + '°');
    bm.Free;
  end;
end;

procedure TForm1.itle1Click(Sender: TObject);
begin
  form2.Edit1.Text := Title;
  form2.ShowModal;
end;

procedure TForm1.Delete1Click(Sender: TObject);
begin
  Button3Click(nil);
end;

procedure TForm1.Description1Click(Sender: TObject);
begin
  form3.UnicodeMemo1.Text := Info;
  form3.ShowModal;
end;

procedure TForm1.smDisableIndicatorClick(Sender: TObject);
var
  Reg: TRegistry;
begin
  smDisableIndicator.Checked := not smDisableIndicator.Checked;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
  if Reg.OpenKey('\Software\Microsoft\schthack\qedit', true) then
  begin
    Reg.WriteBool('DisableIndicator', smDisableIndicator.Checked);
    Reg.CloseKey;
  end;
  finally
    Reg.Free;
  end;
end;

procedure TForm1.DrawPCRELFile(filename: ansistring);
var
  rel, rel1: array [0 .. 2] of Single;
  f, y, l, sec: integer;
  t, r, m, tab: dword;
  p: array [0 .. 1000] of TRoomEntry;
  u: TMapSection;
begin
  // zoom:=7;
  // sec:=0;
  Image2.Canvas.FillRect(Image2.Canvas.ClipRect);
  f := fileopen(filename, $40);
  t := fileseek(f, -16, 2);
  fileread(f, t, 4); // find the first room entry
  fileseek(f, t, 0);
  fileread(f, t, 4);

  y := fileopen(copy(filename, 1, length(filename) - 5) + 'd.rel', $40);
  fileseek(y, -16, 2);
  fileread(y, r, 4);
  fileseek(y, r, 0);
  fileread(y, m, 4);
  fileread(y, r, 4);
  fileread(y, r, 4);
  fileseek(y, r, 0);
  for l := 0 to m - 1 do
  begin
    fileread(y, u, $3C);
    if u.section < 1000 then
    begin
      MidP[u.section].x := round(u.dx / Zoom);
      MidP[u.section].y := round(u.dy / Zoom);
      rev[u.section] := u.reverse_data;
      if CheckBox1.Checked then
      begin
        Image2.Canvas.Brush.Color := Clskyblue;
        Form1.Image2.Canvas.Chord(MidP[u.section].x + mmx + round((-60 + mpx) / Zoom),
          MidP[u.section].y + mmy + round((-60 + mpy) / Zoom), MidP[u.section].x + mmx + round((60 + mpx) / Zoom),
          MidP[u.section].y + mmy + round((60 + mpy) / Zoom), MidP[u.section].x + mmx + round((60 + mpx) / Zoom),
          MidP[u.section].y + mmy + round((-60 + mpy) / Zoom), MidP[u.section].x + mmx + round((60 + mpx) / Zoom),
          MidP[u.section].y + mmy + round((-60 + mpy) / Zoom));
        { image2.Canvas.Rectangle(midp[u.section].X+round((-60+mpx) / zoom)+197,
          midp[u.section].Y+round((-60+mpy) / zoom)+116,
          midp[u.section].X+round((60+mpx) / zoom)+197,
          midp[u.section].Y+round((60+mpy) / zoom)+116); }
        Image2.Canvas.FloodFill(MidP[u.section].x + mmx + round(mpx / Zoom),
          MidP[u.section].y + mmy + round(mpy / Zoom), Clskyblue, fsBorder);
        Image2.Canvas.Font.size := round(40 / Zoom);
        Image2.Canvas.TextOut(MidP[u.section].x + mmx + round((-40 + mpx) / Zoom),
          MidP[u.section].y + mmy + round((-40 + mpy) / Zoom), inttohex(u.section, 2));
        Image2.Canvas.Font.size := 8;
      end;
    end;
  end;
  fileclose(y);
  Image2.Canvas.Brush.Color := clblack;
  fileseek(f, t, 0); // first header found ready to read
  tab := t + $18;
  l := 1;
  while l = 1 do
  begin
    fileread(f, r, 4);
    if r <> 0 then
    begin
      fileseek(f, r, 0); // seek to map block
      fileread(f, r, 4);
      fileread(f, t, 4);
      y := r;
      fileseek(f, t, 0);
      While y > 0 do
      begin
        fileread(f, rel1, 12);
        Image2.Canvas.PenPos := point(round((rel1[0] + mpx) / Zoom) + mmx, round((rel1[2] + mpy) / Zoom) + mmy);
        fileread(f, rel, 12);
        Image2.Canvas.lineto(round((rel[0] + mpx) / Zoom) + mmx, round((rel[2] + mpy) / Zoom) + mmy);
        fileread(f, rel, 12);
        Image2.Canvas.lineto(round((rel[0] + mpx) / Zoom) + mmx, round((rel[2] + mpy) / Zoom) + mmy);
        Image2.Canvas.lineto(round((rel1[0] + mpx) / Zoom) + mmx, round((rel1[2] + mpy) / Zoom) + mmy);
        fileread(f, rel, 12);
        fileread(f, rel, 12);
        fileread(f, rel, 8);
        dec(y);
      end;
      fileseek(f, tab, 0);
      tab := tab + $18;

    end
    else
      l := 0;
    // image2.Repaint;
    // inc(sec);
  end;
  fileclose(f);
end;

Procedure MiniMapLineTo(hdc, col, x, y: integer);
var
  x1, y1, dx, dy: Single;
  i, c: integer;
begin
  setpixel(hdc, x, y, col);

end;

Function TForm1.YFromBBRELFile(vpx, vpz: Single): Single;
var
  rel, rel1: array [0 .. 2] of Single;
  f, y, l, sec, hd, ll, col: integer;
  t, r, m, tab, r2: dword;
  p: array [0 .. 1000] of TRoomEntry;
  u: TMapSection;
  tmppoint: array [0 .. 10000] of array [0 .. 2] of Single;
  pt: array [0 .. 3] of word;
  tpt: array [0 .. 3] of TPoint;
  mm, mm2: Single;
begin
  result := 0;
  if BBRelFile = nil then
    exit;
  try
    t := BBRelFile.Seek(-16, 2);
    BBRelFile.read(t, 4); // find the first room entry
    BBRelFile.Seek(t, 0);
    BBRelFile.read(t, 4);
    BBRelFile.Seek(t, 0); // first header found ready to read
    // fillchar(zmap,sizeof(zmap),$7f);
    tab := t + $18;
    l := 1;
    mm2 := 1000;
    ll := 0;
    col := $101010;
    while l = 1 do
    begin
      BBRelFile.read(r, 4);
      if r <> 0 then
      begin
        BBRelFile.Seek(r, 0); // seek to map block
        BBRelFile.read(r, 4);
        BBRelFile.read(t, 4);
        BBRelFile.read(r, 4);
        BBRelFile.read(r2, 4);
        y := r;

        BBRelFile.Seek(t, 0);
        BBRelFile.read(tmppoint, r2 - t); // read point table
        While y > 0 do
        begin
          BBRelFile.read(pt, 8);
          // put in the z maping
          if (pt[3] and 64 = 64) or (pt[3] and 1 = 1) then // 1 = top+floor  32 = wall

            // get other point
            { rel1[0]:=tmppoint[pt[0]][0];
              rel1[2]:=tmppoint[pt[0]][2];
              rel[0]:=tmppoint[pt[1]][0];
              rel[2]:=tmppoint[pt[1]][2]; }

            // test the triangle
            if GetYposition(PikaVector(vpx, 0, vpz), PikaVector(tmppoint[pt[0]][0], tmppoint[pt[0]][1],
              tmppoint[pt[0]][2]), PikaVector(tmppoint[pt[1]][0], tmppoint[pt[1]][1], tmppoint[pt[1]][2]),
              PikaVector(tmppoint[pt[2]][0], tmppoint[pt[2]][1], tmppoint[pt[2]][2]), mm) then
            begin
              if mm < mm2 then
              begin
                result := mm;
                mm2 := mm;
              end;
            end;

          BBRelFile.Seek(28, 1);
          dec(y);
        end;
        BBRelFile.Seek(tab, 0);
        tab := tab + $18;

      end
      else
        l := 0;
    end;

  except
    result := 0;
  end;
end;

procedure TForm1.DrawBBRELFile(filename: ansistring);
var
  rel, rel1: array [0 .. 2] of Single;
  f, y, l, sec, hd, ll, col: integer;
  t, r, m, tab, r2: dword;
  p: array [0 .. 1000] of TRoomEntry;
  u: TMapSection;
  tmppoint: array [0 .. 10000] of array [0 .. 2] of Single;
  pt: array [0 .. 3] of word;
  tpt: array [0 .. 3] of TPoint;
begin
  if BBRelFile = nil then
    BBRelFile := TMemoryStream.Create;

  BBRelBmp.Canvas.FillRect(BBRelBmp.Canvas.ClipRect);
  BBRelBmp.Canvas.FloodFill(10, 10, ClWhite, fsBorder);
  if BBRelFileName <> filename then
  begin
    BBRelFile.LoadFromFile(filename);
    BBRelFileName := filename;
    // end;
    // zoom:=7;
    // sec:=0;
    for f := 0 to 25566 do
      MidPU[f] := false;
    try

      // f:=fileopen(filename,$40);

      y := fileopen(copy(filename, 1, length(filename) - 5) + 'n.rel', $40);
      fileseek(y, -16, 2);
      fileread(y, r, 4);
      fileseek(y, r, 0);
      fileread(y, m, 4);
      fileread(y, m, 4);
      fileread(y, m, 4);
      fileread(y, r, 4);
      fileread(y, r, 4);
      fileseek(y, r, 0);
      Form1.ComboBox1.Clear;
      Form1.ComboBox1.Items.Add('Auto');
      for l := 0 to m - 1 do
      begin
        fileread(y, u, $34);
        if u.section < 1000 then
        begin
          t := 1;
          for t := 1 to Form1.ComboBox1.Items.count - 1 do
            if strtoint(Form1.ComboBox1.Items.Strings[t]) > u.section then
              break;
          if t >= Form1.ComboBox1.Items.count then
            Form1.ComboBox1.Items.Add(inttostr(u.section))
          else
            Form1.ComboBox1.Items.insert(t, inttostr(u.section));
          MidP[u.section].x := round(u.dx / Zoom);
          MidP[u.section].y := round(u.dy / Zoom);
          midpz[u.section].x := round(u.dx);
          midpz[u.section].y := round(u.dy);
          miz[u.section] := round(u.dz);
          MidPU[u.section] := true;
          rev[u.section] := u.reverse_data;
          if CheckBox1.Checked then
          begin
            BBRelBmp.Canvas.Brush.Color := Clskyblue;
            if Form1.ComboBox1.ItemIndex > 0 then
              if l = strtoint(Form1.ComboBox1.Items.Strings[Form1.ComboBox1.ItemIndex]) then
                BBRelBmp.Canvas.Brush.Color := $00FF80FF;
            BBRelBmp.Canvas.Chord(MidP[u.section].x + mmx + round((-60 + mpx) / Zoom),
              MidP[u.section].y + mmy + round((-60 + mpy) / Zoom), MidP[u.section].x + mmx + round((60 + mpx) / Zoom),
              MidP[u.section].y + mmy + round((60 + mpy) / Zoom),

              MidP[u.section].x + mmx + round((60 + mpx) / Zoom), MidP[u.section].y + mmy + round((-60 + mpy) / Zoom),
              MidP[u.section].x + mmx + round((60 + mpx) / Zoom), MidP[u.section].y + mmy + round((-60 + mpy) / Zoom));

            BBRelBmp.Canvas.Font.size := round(40 / Zoom);
            BBRelBmp.Canvas.TextOut(MidP[u.section].x + mmx + round((-40 + mpx) / Zoom),
              MidP[u.section].y + mmy + round((-40 + mpy) / Zoom), inttostr(u.section));
            BBRelBmp.Canvas.Font.size := 8;
          end;
        end;
      end;
      Form1.ComboBox1.ItemIndex := 0; // default auto
      fileclose(y);
      if extractfilename(mapfilenam) = 'map_boss03c.rel' then
      begin
        MidP[0].y := 0;
        midpz[0].y := 0;
      end;
    except
      MessageDlg(GetLanguageString(72), mtInformation, [mbOk], 0);
    end;
  end
  else
  begin

    for l := 0 to 999 do
      if MidPU[l] then
      begin
        MidP[l].x := round(midpz[l].x / Zoom);
        MidP[l].y := round(midpz[l].y / Zoom);

        if CheckBox1.Checked then
        begin
          BBRelBmp.Canvas.Brush.Color := Clskyblue;
          if Form1.ComboBox1.ItemIndex > 0 then
            if l = strtoint(Form1.ComboBox1.Items.Strings[Form1.ComboBox1.ItemIndex]) then
              BBRelBmp.Canvas.Brush.Color := $00FF80FF;
          BBRelBmp.Canvas.Chord(MidP[l].x + mmx + round((-60 + mpx) / Zoom),
            MidP[l].y + mmy + round((-60 + mpy) / Zoom), MidP[l].x + mmx + round((60 + mpx) / Zoom),
            MidP[l].y + mmy + round((60 + mpy) / Zoom),

            MidP[l].x + mmx + round((60 + mpx) / Zoom), MidP[l].y + mmy + round((-60 + mpy) / Zoom),
            MidP[l].x + mmx + round((60 + mpx) / Zoom), MidP[l].y + mmy + round((-60 + mpy) / Zoom));

          // BBRelBmp.Canvas.FloodFill(midp[l].x+197+round(mpx / zoom),midp[l].Y+116+round(mpy / zoom),Clskyblue,fsBorder	);
          BBRelBmp.Canvas.Font.size := round(40 / Zoom);
          BBRelBmp.Canvas.TextOut(MidP[l].x + mmx + round((-40 + mpx) / Zoom),
            MidP[l].y + mmy + round((-40 + mpy) / Zoom), inttostr(l));
          BBRelBmp.Canvas.Font.size := 8;
        end;

      end;

  end;

  try
    t := BBRelFile.Seek(-16, 2);
    BBRelFile.read(t, 4); // find the first room entry
    BBRelFile.Seek(t, 0);
    BBRelFile.read(t, 4);
    BBRelBmp.Canvas.Brush.Color := clblack;
    BBRelFile.Seek(t, 0); // first header found ready to read
    // fillchar(zmap,sizeof(zmap),$7f);
    tab := t + $18;
    l := 1;
    ll := 0;
    col := $101010;
    while l = 1 do
    begin
      BBRelFile.read(r, 4);
      if r <> 0 then
      begin
        BBRelFile.Seek(r, 0); // seek to map block
        BBRelFile.read(r, 4);
        BBRelFile.read(t, 4);
        BBRelFile.read(r, 4);
        BBRelFile.read(r2, 4);
        y := r;

        BBRelFile.Seek(t, 0);
        BBRelFile.read(tmppoint, r2 - t); // read point table
        While y > 0 do
        begin
          BBRelFile.read(pt, 8);
          // put in the z maping
          // if (pt[3] and 64 = 64) or (pt[3] and 1 = 1) then // and (pt[3] and $8000 = 0)then     //1 = top+floor  32 = wall
          if ((round((tmppoint[pt[0]][0] + mpx) / Zoom) >= -mmx) and (round((tmppoint[pt[0]][0] + mpx) / Zoom) <= mmx +
            1) and (round((tmppoint[pt[0]][2] + mpy) / Zoom) >= -mmy) and
            (round((tmppoint[pt[0]][2] + mpy) / Zoom) <= mmy + 1)) or

            ((round((tmppoint[pt[1]][0] + mpx) / Zoom) >= -mmx) and (round((tmppoint[pt[1]][0] + mpx) / Zoom) <= mmx +
            1) and (round((tmppoint[pt[1]][2] + mpy) / Zoom) >= -mmy) and
            (round((tmppoint[pt[1]][2] + mpy) / Zoom) <= mmy + 1)) or

            ((round((tmppoint[pt[2]][0] + mpx) / Zoom) >= -mmx) and (round((tmppoint[pt[2]][0] + mpx) / Zoom) <= mmx +
            1) and (round((tmppoint[pt[2]][2] + mpy) / Zoom) >= -mmy) and
            (round((tmppoint[pt[2]][2] + mpy) / Zoom) <= mmy + 1)) then
          begin
            // get other point
            rel1[0] := tmppoint[pt[0]][0];
            rel1[2] := tmppoint[pt[0]][2];
            rel[0] := tmppoint[pt[1]][0];
            rel[2] := tmppoint[pt[1]][2];

            // BBRelBmp.Canvas.Pen.Color:=130+(round(tmppoint[pt[0]][1])*2);
            if (pt[3] and 64 = 64) then
              BBRelBmp.Canvas.Pen.Color := ClBlue
            else if (pt[3] and 16 = 16) then
              BBRelBmp.Canvas.Pen.Color := $7FFF7F
            else if (pt[3] and 1 = 1) then
              BBRelBmp.Canvas.Pen.Color := $999999 // $90D517//$77AD19
            else
              BBRelBmp.Canvas.Pen.Color := clblack;

            tpt[0].x := round((rel1[0] + mpx) / Zoom) + mmx;
            tpt[0].y := round((rel1[2] + mpy) / Zoom) + mmy;

            tpt[1].x := round((rel[0] + mpx) / Zoom) + mmx;
            tpt[1].y := round((rel[2] + mpy) / Zoom) + mmy;
            rel[0] := tmppoint[pt[2]][0];
            rel[2] := tmppoint[pt[2]][2];
            tpt[2].x := round((rel[0] + mpx) / Zoom) + mmx;
            tpt[2].y := round((rel[2] + mpy) / Zoom) + mmy;
            tpt[3] := tpt[0];
            BBRelBmp.Canvas.Polyline(tpt);
          end;

          BBRelFile.Seek(28, 1);
          dec(y);
        end;
        BBRelFile.Seek(tab, 0);
        tab := tab + $18;

      end
      else
        l := 0;
      // image2.Repaint;
      // inc(sec);
    end;
    // deletedc(hd);

    BBRelBmp.Canvas.Pen.Color := 0;
    // fileclose(f);
    // releasedc(Image2.Canvas.Handle,hd);
    // show the z table

  except
    MessageDlg(GetLanguageString(73), mtInformation, [mbOk], 0);
  end;
end;

procedure TForm1.DrawZBBRELFile(filename: ansistring; px, py, pz: double);
var
  rel, rel1: array [0 .. 2] of Single;
  f, l, sec, y: integer;
  t, r, m, tab, r2: dword;
  p: array [0 .. 1000] of TRoomEntry;
  u: TMapSection;
  tmppoint: array [0 .. 5000] of array [0 .. 2] of Single;
  pt: array [0 .. 3] of word;
begin
  try
    form7.Image1.Canvas.Brush.Color := $FFFFFF;
    form7.Image1.Canvas.FillRect(form7.Image1.Canvas.ClipRect);
    f := fileopen(filename, $40);
    if f = -1 then
      exit;
    t := fileseek(f, -16, 2);
    fileread(f, t, 4); // find the first room entry
    fileseek(f, t, 0);
    fileread(f, t, 4);

    form7.Image1.Canvas.Brush.Color := clblack;
    fileseek(f, t, 0); // first header found ready to read
    // fillchar(zmap,sizeof(zmap),$7f);
    tab := t + $18;
    l := 1;
    while l = 1 do
    begin
      fileread(f, r, 4);
      if r <> 0 then
      begin
        fileseek(f, r, 0); // seek to map block
        fileread(f, r, 4);
        fileread(f, t, 4);
        fileread(f, r, 4);
        fileread(f, r2, 4);
        y := r;

        fileseek(f, t, 0);
        fileread(f, tmppoint, r2 - t); // read point table
        While y > 0 do
        begin
          fileread(f, pt, 8);
          if (pt[3] and 64 = 64) or (pt[3] and 1 = 1) then
            if (tmppoint[pt[0]][2] > py - 200) and (tmppoint[pt[0]][2] < py + 200) then
            begin
              // get other point
              rel1[0] := tmppoint[pt[0]][0];
              rel1[1] := (tmppoint[pt[0]][1] - pz) / 1.5;
              // rel1[1]:=tmppoint[pt[1]];
              rel[0] := tmppoint[pt[1]][0];
              rel[1] := (tmppoint[pt[1]][1] - pz) / 1.5;
              form7.Image1.Canvas.PenPos := point(round((rel1[0] - px) / 1.5) + 52, round(100 - rel1[1]));
              form7.Image1.Canvas.Pen.Color := 130 + (round(tmppoint[pt[0]][2]) * 2);
              form7.Image1.Canvas.lineto(round((rel[0] - px) / 1.5) + 52, round(100 - rel[1]));
              rel[0] := tmppoint[pt[2]][0];
              rel[1] := (tmppoint[pt[2]][1] - pz) / 1.5;
              form7.Image1.Canvas.Pen.Color := 130 + (round(tmppoint[pt[1]][2]) * 2);
              form7.Image1.Canvas.lineto(round((rel[0] - px) / 1.5) + 52, round(100 - rel[1]));
              form7.Image1.Canvas.Pen.Color := 130 + (round(tmppoint[pt[2]][2]) * 2);
              form7.Image1.Canvas.lineto(round((rel1[0] - px) / 1.5) + 52, round(100 - rel1[1]));
            end;

          fileread(f, rel, 12);
          fileread(f, rel, 12);
          fileread(f, rel, 4);
          // image2.Repaint;

          dec(y);

        end;
        fileseek(f, tab, 0);
        tab := tab + $18;

      end
      else
        l := 0;
      // image2.Repaint;
      // inc(sec);
    end;
    fileclose(f);

    // show the z table

  except
    MessageDlg(GetLanguageString(73), mtInformation, [mbOk], 0);
  end;
end;

procedure TForm1.Copyitem1Click(Sender: TObject);
begin
  Copylastitem1Click(nil);
end;

procedure TForm1.Copylastitem1Click(Sender: TObject);
var
  x: integer;
begin
  if ((form10.ComboBox1.ItemIndex > -1) and (form10.tag = 1)) or Copylastitem1.Enabled then
  begin
    inc(Floor[sfloor].ObjCount);
    for x := 0 to preseti - 1 do
      if ObjTemplate[x].name = form10.ComboBox1.Text then
        break;
    move(ObjTemplate[x].data, Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1], sizeof(TObj));
    if form10.UnicodestringGrid1.Visible then
      Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1].unknow8 := strtofloat(form10.UnicodestringGrid1.Cells[1, 0]);

    if form10.UnicodeStringGrid2.Visible then
    begin
      Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1].unknow8 := strtofloat(form10.UnicodeStringGrid2.Cells[1, 0]);
      Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1].unknow9 := strtofloat(form10.UnicodeStringGrid2.Cells[1, 1]);
      Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1].Unknow10 := strtofloat(form10.UnicodeStringGrid2.Cells[1, 2]);
    end;

    SetObjectDefaults();
    ShowIndicator();
    MoveSel := Floor[sfloor].ObjCount - 1;
    MoveType := 2;
    ListBox2.Items.Add('#' + inttostr(MoveSel) + ' - ' + GetObjName(Floor[sfloor].Obj[MoveSel].Skin));
    if have3d then
    begin
      MyObjCount := Floor[sfloor].ObjCount;
      setlength(MyObj, MyObjCount);
      MyObj[MoveSel] := nil;
      Generateobj(Floor[sfloor].Obj[MoveSel], MoveSel);

    end;
    ctrldw := true;
    firstdrop := true;
    DrawMap;
    isedited := true;
  end;
end;

procedure TForm1.Copylastmonster1Click(Sender: TObject);
var
  x: integer;
begin
  if ((form9.ComboBox1.ItemIndex > -1) and (form9.tag = 1)) or Copylastmonster1.Enabled then
  begin
    inc(Floor[sfloor].MonsterCount);
    for x := 0 to presetm - 1 do
      if MonsterTemplate[x].name = form9.ComboBox1.Text then
        break;
    move(MonsterTemplate[x].data, Floor[sfloor].Monster[Floor[sfloor].MonsterCount - 1], sizeof(TMonster));
    Floor[sfloor].Monster[Floor[sfloor].MonsterCount - 1].Unknow5 := form9.SpinEdit1.value;
    Floor[sfloor].Monster[Floor[sfloor].MonsterCount - 1].unknow6 := form9.SpinEdit1.value;
    Floor[sfloor].Monster[Floor[sfloor].MonsterCount - 1].unknow3 := MapFloorId[Floor[sfloor].floorid];

    SetMonsterDefaults();
    ShowIndicator();
    MoveSel := Floor[sfloor].MonsterCount - 1;
    MoveType := 1;
    firstdrop := true;
    if have3d then
      ListBox1.Items.Add('#' + inttostr(MoveSel) + ' - ' + GenerateMonsterName(Floor[sfloor].Monster[MoveSel],
        MoveSel, 1))
    else
      ListBox1.Items.Add('#' + inttostr(MoveSel) + ' - ' + GenerateMonsterName(Floor[sfloor].Monster[MoveSel],
        MoveSel, 0));
    DrawMap;
    ctrldw := true;
    isedited := true;
  end;
end;

procedure TForm1.Copymonster1Click(Sender: TObject);
begin
  Copylastmonster1Click(nil);
end;

procedure TForm1.ViewScrypt1Click(Sender: TObject);
begin
  form4.Show;
end;

procedure TForm1.Image2MouseMove(Sender: TObject; Shift: TShiftState; x, y: integer);
var
  t: double;
begin
  mpcx := x;
  mpcy := y;
  Label5.Caption := 'X:' + inttostr(round(((x - mmx) - (mpx / Zoom)) * Zoom)) + '  Y:' +
    inttostr(round(YFromBBRELFile(((x - mmx) - (mpx / Zoom)) * Zoom, ((y - mmy) - (mpy / Zoom)) * Zoom))) + '  Z:' +
    inttostr(round(((y - mmy) - (mpy / Zoom)) * Zoom));
  if mdown >= 1 then
  begin
    t := (x - lmpx);
    t := t * Zoom;
    mpx := mpx + round(t);
    t := (y - lmpy);
    t := t * Zoom;
    mpy := mpy + round(t);
    lmpx := x;
    lmpy := y;
    DrawMap;
    mdown := 2;
  end;
end;

procedure TForm1.Image2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; x, y: integer);
var
  z, l: Integer;
  px, px2, py, py2: Double;
begin
  // Start of mouse drag
  if (Button = mbleft) and (smDrag.checked) then
  begin
    imgclickstart := gettickcount();
    // Drag monsters
    for z := 0 to Floor[sfloor].MonsterCount - 1 do
      if (Floor[sfloor].Monster[z].Unknow5 = showwave) or (showwave = -1) then
      begin
        if extractfilename(mapfilenam) = 'map_boss03c.rel' then
        begin
          MidP[0].y := 0;
        end;
        px2 := Floor[sfloor].Monster[z].Pos_X / Zoom;
        py2 := Floor[sfloor].Monster[z].Pos_Y / Zoom;
        px := cos(-rev[Floor[sfloor].Monster[z].map_section] / 10430.37835) * px2 -
          sin(-rev[Floor[sfloor].Monster[z].map_section] / 10430.37835) * py2;
        py := sin(-rev[Floor[sfloor].Monster[z].map_section] / 10430.37835) * px2 +
          cos(-rev[Floor[sfloor].Monster[z].map_section] / 10430.37835) * py2;

        px2 := mpx;
        px2 := px2 / Zoom;
        px := px + mmx + MidP[Floor[sfloor].Monster[z].map_section].x + px2;
        px2 := mpy;
        px2 := px2 / Zoom;
        py := py + mmy + MidP[Floor[sfloor].Monster[z].map_section].y + px2;

        if (mpcx >= round(px) - round(6 / Zoom)) and (mpcx <= round(px) + round(6 / Zoom)) and
          (mpcy >= round(py) - round(6 / Zoom)) and (mpcy <= round(py) + round(6 / Zoom)) then
          begin
            l := ListBox1.ItemIndex;
            ListBox1.ItemIndex := z;
            if have3d and shiftdown then
            begin
              ppx := midpz[Floor[sfloor].Monster[z].map_section].x;
              ppy := Floor[sfloor].Monster[z].Pos_Z + 15;
              ppz := -midpz[Floor[sfloor].Monster[z].map_section].y;
              vr := 0;
              vz := 0;
              myscreen.SetView(ppx, ppy, ppz, vr, vz);
            end;
            if gettickcount() - lastimgclick > 500 then
              l := -1;
            if l = ListBox1.ItemIndex then
              Form1.ListBox1DblClick(Form1)
            else
              Form1.ListBox1Click(Form1);
              lastimgclick := gettickcount();
              mdrag := 1;
            end;
      end;
      // Drag objects
      for z := 0 to Floor[sfloor].ObjCount - 1 do
      if (Floor[sfloor].Obj[z].grp = showgrp) or (showgrp = -1) then
      begin
        if extractfilename(mapfilenam) = 'map_boss03c.rel' then
        begin
          MidP[0].y := 0;
        end;
        px2 := Floor[sfloor].Obj[z].Pos_X / Zoom;
        py2 := Floor[sfloor].Obj[z].Pos_Y / Zoom;
        px := cos(-rev[Floor[sfloor].Obj[z].map_section] / 10430.37835) * px2 -
          sin(-rev[Floor[sfloor].Obj[z].map_section] / 10430.37835) * py2;
        py := sin(-rev[Floor[sfloor].Obj[z].map_section] / 10430.37835) * px2 +
          cos(-rev[Floor[sfloor].Obj[z].map_section] / 10430.37835) * py2;

        px2 := mpx;
        px2 := px2 / Zoom;
        px := px + mmx + MidP[Floor[sfloor].Obj[z].map_section].x + px2;
        px2 := mpy;
        px2 := px2 / Zoom;
        py := py + mmy + MidP[Floor[sfloor].Obj[z].map_section].y + px2;

        if (mpcx >= round(px) - round(6 / Zoom)) and (mpcx <= round(px) + round(6 / Zoom)) and
          (mpcy >= round(py) - round(6 / Zoom)) and (mpcy <= round(py) + round(6 / Zoom)) then
        begin
            l := ListBox2.ItemIndex;
            ListBox2.ItemIndex := z;
            if have3d and shiftdown then
            begin
              ppx := midpz[Floor[sfloor].Obj[z].map_section].x;
              ppy := Floor[sfloor].Obj[z].Pos_Z + 15;
              ppz := -midpz[Floor[sfloor].Obj[z].map_section].y;
              vr := 0;
              vz := 0;
              myscreen.SetView(ppx, ppy, ppz, vr, vz);
            end;
            if gettickcount() - lastimgclick > 500 then
              l := -1;
            if l = ListBox2.ItemIndex then
              Form1.ListBox1DblClick(Form1)
            else
              Form1.ListBox2Click(Form1);
              lastimgclick := gettickcount();
              mdrag := 1;
            end;
      end;
  end;

  ctrldw := false;
  shiftdown := true;
  shiftdw := false;
  altdw := false;
  if ssleft in Shift then
  begin
    if ssCtrl in Shift then
      ctrldw := true;
    if ssShift in Shift then
      shiftdw := true;
    if ssalt in Shift then
      altdw := true;
  end;
  if ssShift in Shift then
    shiftdown := true;
  if Button = mbRight then
  begin
    lmpx := x;
    lmpy := y;
    mdown := 1;
  end
end;

procedure TForm1.Image2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; x, y: integer);
begin
  // End of mouse drag
  if (Button = mbleft) and (smDrag.Checked) and (mdrag = 1) and (gettickcount() - imgclickstart >= 300) then
  begin
    MoveSel := -1;
    HideIndicator();
    if Selected > -1 then
    begin
      ShowIndicator();
      MoveSel := Selected;
      MoveType := stype;
      isedited := true;
      Image2Click(nil);
      mdrag := 0;
    end;
  end;
  if mdown = 1 then
    Image2.PopupMenu.Popup(mouse.CursorPos.x, mouse.CursorPos.y);
  mdown := 0;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  f: textfile;
  s, b: ansistring;
  x, y, z, ma, l, i, mylang: integer;
  m, fl: tstringlist;
  fx: textfile;
  Reg: TRegistry;
  flp: TMemoryStream;
begin
  If tag = 0 then
  begin
    mylang := 0;
    FormatSettings.DecimalSeparator := '.';
    LanguageString := tstringlist.Create;

    TrFnc := form4.TreeView1.Items.Item[0];
    TrData := form4.TreeView1.Items.Item[1];
    TrReg := form4.TreeView1.Items.Item[2];
    Tropc := form4.TreeView1.Items.Item[3];

    TsData := tstringlist.Create;
    TsFnc := tstringlist.Create;
    TsReg := tstringlist.Create;
    Tsopc := tstringlist.Create;

    Monsterini := tstringlist.Create;
    fl := tstringlist.Create;
    StringTest := tstringlist.Create;
    Zoom := 5;
    curepi := 0;
    path := extractfilepath(application.ExeName);
    Zoom := 5;
    sms := 0;
    for x := 0 to 30 do
    begin
      Floor[x].MonsterCount := 0;
      Floor[x].ObjCount := 0;
      Floor[x].UnknowCount := 0;
      CheckListBox1.Checked[x] := false;
      if x < 18 then
      begin
        mapfile[x] := path + 'map\' + mapfilename[mapid[x + EPMap[curepi]]];
        mapxvmfile[x] := path + 'map\xvm\' + mapxvmname[mapid[x + EPMap[curepi]]];
        Form1.CheckListBox1.Items.Strings[x] := mapname[mapid[x + EPMap[curepi]]];
        Floor[x].floorid := maparea[mapid[x + EPMap[curepi]]];
      end;
    end;
    tag := 1;
    m := tstringlist.Create;
    m.Add('T_NONE');
    m.Add('T_IMED');
    m.Add('T_ARGS');
    m.Add('T_PUSH');
    m.Add('T_VASTART');
    m.Add('T_VAEND');
    m.Add('T_DC');

    m.Add('T_REG');
    m.Add('T_BYTE');
    m.Add('T_WORD');
    m.Add('T_DWORD');
    m.Add('T_FLOAT');
    m.Add('T_STR');

    m.Add('T_RREG');
    m.Add('T_FUNC');
    m.Add('T_FUNC2');
    m.Add('T_SWITCH');
    m.Add('T_SWITCH2B');
    m.Add('T_PFLAG');

    m.Add('T_STRDATA');
    m.Add('T_DATA');
    m.Add('T_BREG');
    m.Add('T_DREG');
    // load monster template
    flp := TMemoryStream.Create;
    if fileexists('monsters.txt') then
      fl.LoadFromFile('monsters.txt')
    else
    begin
      flp.Clear;
      PikaGetFile(flp, 'monsters.txt', path + 'config.ppk', 'Build By Schthack');
      fl.LoadFromStream(flp);
    end;
    x := 0;
    i := 0;
    presetm := 0;
    while i < fl.count do
    begin
      s := fl.Strings[i];
      inc(i);
      MonsterTemplate[x].name := copy(s, 2, length(s) - 1);
      inc(presetm);
      form9.ComboBox1.Items.Add(MonsterTemplate[x].name);
      for ma := 1 to 22 do
      begin
        s := fl.Strings[i];
        inc(i);
        s := copy(s, pos(#9, s) + 1, 20);
        if ma = 1 then
          MonsterTemplate[x].data.Skin := strtoint(s);
        if ma = 2 then
          MonsterTemplate[x].data.Unknow1 := strtoint(s);
        if ma = 3 then
          MonsterTemplate[x].data.unknow2 := strtoint(s);
        if ma = 4 then
          MonsterTemplate[x].data.unknow3 := strtoint(s);
        if ma = 5 then
          MonsterTemplate[x].data.unknow4 := strtoint(s);
        if ma = 6 then
          MonsterTemplate[x].data.map_section := strtoint(s);
        if ma = 7 then
          MonsterTemplate[x].data.Unknow5 := strtoint(s);
        if ma = 8 then
          MonsterTemplate[x].data.unknow6 := strtoint(s);
        if ma = 9 then
          MonsterTemplate[x].data.Pos_X := strtoint(s);
        if ma = 10 then
          MonsterTemplate[x].data.Pos_Z := strtoint(s);
        if ma = 11 then
          MonsterTemplate[x].data.Pos_Y := strtoint(s);
        if ma = 12 then
          MonsterTemplate[x].data.unknow7 := strtoint(s);
        if ma = 13 then
          MonsterTemplate[x].data.Direction := strtoint(s);
        if ma = 14 then
          MonsterTemplate[x].data.unknow8 := strtoint(s);
        // if ma = 15 then MonsterTemplate[x].data.unknow9:=strtoint(s);
        if ma = 16 then
          MonsterTemplate[x].data.Movement_data := strtoint(s);

        if ma = 17 then
          MonsterTemplate[x].data.Unknow10 := strtofloat(s);
        if ma = 18 then
          MonsterTemplate[x].data.unknow11 := strtofloat(s);
        if ma = 19 then
          MonsterTemplate[x].data.Char_id := strtoint(s);
        if ma = 20 then
          MonsterTemplate[x].data.Action := strtoint(s);
        if ma = 21 then
          MonsterTemplate[x].data.Movement_flag := strtoint(s);
        if ma = 22 then
          MonsterTemplate[x].data.unknow_flag := strtoint(s);

      end;
      inc(i);
      inc(x);
    end;

    preseti := 0;

    if fileexists('objs.txt') then
      fl.LoadFromFile('objs.txt')
    else
    begin
      flp.Clear;
      PikaGetFile(flp, 'objs.txt', path + 'config.ppk', 'Build By Schthack');
      fl.LoadFromStream(flp);
    end;
    x := 0;
    i := 0;
    while i < fl.count do
    begin
      s := fl.Strings[i];
      inc(i);
      ObjTemplate[x].name := copy(s, 2, length(s) - 1);
      inc(preseti);
      form10.ComboBox1.Items.Add(ObjTemplate[x].name);
      for ma := 1 to 19 do
      begin
        s := fl.Strings[i];
        inc(i);
        s := copy(s, pos(#9, s) + 1, 20);
        if ma = 1 then
          ObjTemplate[x].data.Skin := strtoint(s);
        if ma = 2 then
          ObjTemplate[x].data.Unknow1 := strtoint(s);
        if ma = 3 then
          ObjTemplate[x].data.unknow2 := strtoint(s);
        if ma = 4 then
          ObjTemplate[x].data.id := strtoint(s);
        if ma = 5 then
          ObjTemplate[x].data.map_section := strtoint(s);
        if ma = 6 then
          ObjTemplate[x].data.unknow4 := strtoint(s);
        if ma = 7 then
          ObjTemplate[x].data.Pos_X := strtoint(s);
        if ma = 8 then
          ObjTemplate[x].data.Pos_Z := strtoint(s);
        if ma = 9 then
          ObjTemplate[x].data.Pos_Y := strtoint(s);
        if ma = 10 then
          ObjTemplate[x].data.Unknow5 := strtoint(s);
        if ma = 11 then
          ObjTemplate[x].data.unknow6 := strtoint(s);
        if ma = 12 then
          ObjTemplate[x].data.unknow7 := strtoint(s);
        if ma = 13 then
          ObjTemplate[x].data.unknow8 := strtoint(s);
        if ma = 14 then
          ObjTemplate[x].data.unknow9 := strtoint(s);
        if ma = 15 then
          ObjTemplate[x].data.Unknow10 := strtoint(s);
        if ma = 16 then
          ObjTemplate[x].data.obj_id := strtoint(s);
        if ma = 17 then
          ObjTemplate[x].data.Action := strtoint(s);
        if ma = 18 then
          ObjTemplate[x].data.unknow13 := strtoint(s);
        if ma = 19 then
          ObjTemplate[x].data.unknow14 := strtoint(s);

      end;
      inc(i);
      inc(x);
    end;

    // load the asm code

    if fileexists('fogentry.dat') then
    begin
      flp.LoadFromFile('fogentry.dat');
      flp.Position := 0;
      flp.read(FogEntry[0], flp.size);
    end
    else
    begin
      flp.Clear;
      PikaGetFile(flp, 'fogentry.dat', path + 'config.ppk', 'Build By Schthack');
      flp.Position := 0;
      flp.read(FogEntry[0], flp.size);
    end;

    if fileexists('asm.txt') then
      fl.LoadFromFile('asm.txt')
    else
    begin
      flp.Clear;
      PikaGetFile(flp, 'asm.txt', path + 'config.ppk', 'Build By Schthack');
      fl.LoadFromStream(flp);
    end;

    i := 0;
    x := 0;
    ma := 0;
    while x < fl.count do
    begin
      s := fl.Strings[x];
      y := pos('}', s);
      s := copy(s, 4, y - 4) + ',';
      y := pos(',', s);
      asmcode[x].fnc := hextoint(copy(s, 1, y - 1));
      asmcode[x].ver := 0;

      s := copy(s, y + 3, length(s) - y - 2);
      y := pos(',', s);
      asmcode[x].name := copy(s, 1, y - 2);
      for i := 0 to x - 1 do
        if asmcode[i].name = asmcode[x].name then
          break;
      if i < x then
        asmcode[x].name := asmcode[x].name + inttohex(x, 2);
      s := copy(s, y + 2, length(s) - y - 1);

      y := pos(',', s);
      asmcode[x].order := m.IndexOf(copy(s, 1, y - 1));
      s := copy(s, y + 2, length(s) - y - 1);
      z := 0;
      while s <> '' do
      begin
        y := pos(',', s);
        asmcode[x].arg[z] := m.IndexOf(copy(s, 1, y - 1));
        s := copy(s, y + 2, length(s) - y - 1);
        if asmcode[x].arg[z] = 0 then
          break;
        inc(z);
      end;
      y := pos(',', s);
      if y > 0 then
      begin
        if copy(s, 1, y - 1) = 'T_V2' then
          asmcode[x].ver := 1;
        if copy(s, 1, y - 1) = 'T_V3' then
          asmcode[x].ver := 2;
        if copy(s, 1, y - 1) = 'T_V4' then
          asmcode[x].ver := 3;
      end;

      if z > ma then
        ma := z;
      form5.ComboBox1.Items.Add(asmcode[x].name);
      { Form5.ComboBox1.ItemsEx.AddItem(AsmCode[x].name,(AsmCode[x].ver*2)
        ,(AsmCode[x].ver*2)+1,-1,0,nil); }
      inc(x);
    end;
    asmcount := x;
    asmcode[x].name := 'HEX:';
    asmcode[x].order := T_IMED;
    asmcode[x].ver := 0;
    asmcode[x].arg[0] := T_HEX;
    asmcode[x].arg[1] := 0;
    asmcode[x + 1].name := 'STR:';
    asmcode[x + 1].order := T_IMED;
    asmcode[x + 1].ver := 0;
    asmcode[x + 1].arg[0] := T_STRHEX;
    asmcode[x + 1].arg[1] := 0;
    form5.ComboBox1.Items.Add(asmcode[x].name);
    form5.ComboBox1.Items.Add(asmcode[x + 1].name);

    if fileexists('shiftjis.dat') then
      fl.LoadFromFile('shiftjis.dat')
    else
    begin
      flp.Clear;
      PikaGetFile(flp, 'shiftjis.dat', path + 'config.ppk', 'Build By Schthack');
      fl.LoadFromStream(flp);
    end;
    y := 0;
    setlength(jis, fl.count);
    jiscount := fl.count;
    setlength(uni16, fl.count);
    for i := 0 to fl.count - 1 do
    begin
      b := fl.Strings[i];
      z := pos(#9, b);
      s := copy(b, 1, z - 1);
      b := copy(b, z + 1, length(b) - z);
      if length(s) > 4 then
      begin
        jis[i] := ansichar(hextoint(copy(s, 3, 2))) + ansichar(hextoint(copy(s, 5, 2)));
      end
      else
        jis[i] := ansichar(hextoint(copy(s, 3, 2)));
      z := pos(#9, b);
      s := copy(b, 1, z - 1);
      uni16[i] := ansichar(hextoint(copy(s, 5, 2))) + ansichar(hextoint(copy(s, 3, 2)));
    end;

    ItemsName := tstringlist.Create;

    if fileexists('itemsname.ini') then
      ItemsName.LoadFromFile('itemsname.ini')
    else
    begin
      flp.Clear;
      PikaGetFile(flp, 'itemsname.ini', path + 'config.ppk', 'Build By Schthack');
      ItemsName.LoadFromStream(flp);
    end;
    if fileexists('npcname.ini') then
      Monsterini.LoadFromFile('npcname.ini')
    else
    begin
      flp.Clear;
      PikaGetFile(flp, 'npcname.ini', path + 'config.ppk', 'Build By Schthack');
      Monsterini.LoadFromStream(flp);
    end;

    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey('\Software\Microsoft\schthack\qedit', true) then
      begin
        if Reg.ValueExists('Video') then
          form17.ComboBox1.ItemIndex := Reg.ReadInteger('Video');
        if Reg.ValueExists('Frame') then
          form17.combobox2.ItemIndex := Reg.ReadInteger('Frame');
        if Reg.ValueExists('AA') then
          form17.CheckBox1.Checked := Boolean(Reg.ReadInteger('AA'));
        if Reg.ValueExists('Dist') then
          form17.combobox4.ItemIndex := Reg.ReadInteger('Dist');
        if Reg.ValueExists('SkyDome') then
          form17.CheckBox2.Checked := Boolean(Reg.ReadInteger('SkyDome'));
        if Reg.ValueExists('FontName') then
          form4.ListBox1.Font.name := Reg.ReadString('FontName');
        if Reg.ValueExists('FontSize') then
          form4.ListBox1.Font.size := Reg.ReadInteger('FontSize');
        if Reg.ValueExists('FontStyle') then
          form4.ListBox1.Font.Style := Tfontstyles(byte(Reg.ReadInteger('FontStyle')));
        form4.ListBox1.Font.Pitch := fpFixed;
        if Reg.ValueExists('Lang') then
          mylang := Reg.ReadInteger('Lang');
        if Reg.ValueExists('LoadFrom') then
          lastloadformat := Reg.ReadInteger('LoadFrom');
        if Reg.ValueExists('SaveTo') then
          lsatsaveformat := Reg.ReadInteger('SaveTo');
        if Reg.ValueExists('DragEnabled') then
          dragenabled := Reg.ReadBool('DragEnabled');
        if Reg.ValueExists('SnapEnabled') then
          snapenabled := Reg.ReadBool('SnapEnabled');
        if Reg.ValueExists('AutoAxis') then
          autoaxis := Reg.ReadBool('AutoAxis');
        if Reg.ValueExists('SnapValue') then
          snapvalue := Reg.ReadInteger('SnapValue');
        if Reg.ValueExists('SnapRotate') then
          snaprotate := Reg.ReadBool('SnapRotate');
        if Reg.ValueExists('SnapDistance') then
          snapdistance := Reg.ReadBool('SnapDistance');
        if Reg.ValueExists('OffsetX') then
          OffsetX := Reg.ReadFloat('OffsetX');
        if Reg.ValueExists('OffsetY') then
          OffsetY := Reg.ReadFloat('OffsetY');
        if Reg.ValueExists('OffsetZ') then
          OffsetZ := Reg.ReadFloat('OffsetZ');
        if Reg.ValueExists('DefaultSect') then
          DefaultSect := Reg.ReadInteger('DefaultSect');
        if Reg.ValueExists('DefaultX') then
          DefaultX := Reg.ReadFloat('DefaultX');
        if Reg.ValueExists('DefaultY') then
          DefaultY := Reg.ReadFloat('DefaultY');
        if Reg.ValueExists('DefaultZ') then
          DefaultZ := Reg.ReadFloat('DefaultZ');
        if Reg.ValueExists('DisableIndicator') then
          disableindicator := Reg.ReadBool('DisableIndicator');
        if Reg.ValueExists('Fullscreen3D') then
          fullscreen := Reg.ReadBool('Fullscreen3D');
        Reg.CloseKey;
      end;
      Reg.Free;
    except

    end;

    // if fileexists('FloorSet.ini') then begin
    if fileexists('FloorSet.ini') then
      fl.LoadFromFile('FloorSet.ini')
    else
    begin
      flp.Clear;
      PikaGetFile(flp, 'FloorSet.ini', path + 'config.ppk', 'Build By Schthack');
      fl.LoadFromStream(flp);
    end;

    for i := 0 to fl.count - 1 do
    begin
      s := fl.Strings[i];
      if copy(s, 1, 4) = 'area' then
      begin
        b := copy(s, 5, length(s) - 4);
        z := pos(' ', b);
        while z > 0 do
        begin
          delete(b, z, 1);
          z := pos(' ', b);
        end;
        x := strtoint(b);
        FloorMonsID[x].count[0] := 0;
        FloorMonsID[x].count[1] := 0;
        FloorMonsID[x].count[2] := 0;
        FloorMonsID[x].count[3] := 0;
      end
      else if copy(s, 1, 4) = 'mons' then
      begin
        delete(s, 1, 4);
        l := 0;
        if copy(s, 1, 2) = 'v2' then
          l := 1;
        if copy(s, 1, 2) = 'v3' then
          l := 2;
        if copy(s, 1, 2) = 'v4' then
          l := 3;
        delete(s, 1, 2);
        while s <> '' do
        begin
          z := pos(',', s);
          if z = 0 then
          begin
            b := s;
            s := '';
          end
          else
          begin
            b := copy(s, 1, z - 1);
            delete(s, 1, z);
          end;
          z := pos(' ', b);
          while z > 0 do
          begin
            delete(b, z, 1);
            z := pos(' ', b);
          end;
          if b <> '' then
          begin
            FloorMonsID[x].ids[l, FloorMonsID[x].count[l]] := strtoint(b);
            inc(FloorMonsID[x].count[l]);
          end;
        end;
      end
      else if copy(s, 1, 4) = 'item' then
      begin
        delete(s, 1, 4);
        l := 0;
        if copy(s, 1, 2) = 'v2' then
          l := 1;
        if copy(s, 1, 2) = 'v3' then
          l := 2;
        if copy(s, 1, 2) = 'v4' then
          l := 3;
        delete(s, 1, 2);
        while s <> '' do
        begin
          z := pos(',', s);
          if z = 0 then
          begin
            b := s;
            s := '';
          end
          else
          begin
            b := copy(s, 1, z - 1);
            delete(s, 1, z);
          end;
          z := pos(' ', b);
          while z > 0 do
          begin
            delete(b, z, 1);
            z := pos(' ', b);
          end;
          if b <> '' then
          begin
            FloorObjID[x].ids[l, FloorObjID[x].count[l]] := strtoint(b);
            inc(FloorObjID[x].count[l]);
          end;
        end;
      end;

      // end;

    end;
    flp.Clear;
    if mylang = 0 then
      PikaGetFile(flp, 'eng.txt', path + 'config.ppk', 'Build By Schthack');
    if mylang = 1 then
      PikaGetFile(flp, 'fra.txt', path + 'config.ppk', 'Build By Schthack');
    if mylang = 2 then
      PikaGetFile(flp, 'spa.txt', path + 'config.ppk', 'Build By Schthack');

    smDrag.Checked := dragenabled;
    smSnap.Checked := snapenabled;
    Form7.chkAutoAxis.Checked := autoaxis;
    FPlacementOptions.chkSnapRotate.Checked := snaprotate;
    FplacementOptions.chkSnapDistance.Checked := snapdistance;
    smDisableIndicator.Checked := disableindicator;
    form17.chkFullscreen.Checked := fullscreen;
    FPlacementOptions.seSnapTolerance.Value := snapvalue;
    FPlacementOptions.nbOffsetX.Value := OffsetX;
    FPlacementOptions.nbOffsetY.Value := OffsetY;
    FPlacementOptions.nbOffsetZ.Value := OffsetZ;
    FPlacementOptions.seDefaultSect.Value := DefaultSect;
    FPlacementOptions.nbDefaultX.Value := DefaultX;
    FPlacementOptions.nbDefaultY.Value := DefaultY;
    FPlacementOptions.nbDefaultZ.Value := DefaultZ;

    flp.Position := 0;
    LanguageString.LoadFromStream(flp);
    SetInterfaceText;
    flp.Clear;
    CheckShadow;
  end;

end;

function hextoint(x: ansistring): int64;
var
  y: int64;
begin
  y := 0;
  x := uppercase(x);
  if x <> '' then
  begin
    while length(x) > 0 do
    begin
      y := y * 16;
      if x[1] = '0' then
        y := y + 0;
      if x[1] = '1' then
        y := y + 1;
      if x[1] = '2' then
        y := y + 2;
      if x[1] = '3' then
        y := y + 3;
      if x[1] = '4' then
        y := y + 4;
      if x[1] = '5' then
        y := y + 5;
      if x[1] = '6' then
        y := y + 6;
      if x[1] = '7' then
        y := y + 7;
      if x[1] = '8' then
        y := y + 8;
      if x[1] = '9' then
        y := y + 9;
      if x[1] = 'A' then
        y := y + 10;
      if x[1] = 'B' then
        y := y + 11;
      if x[1] = 'C' then
        y := y + 12;
      if x[1] = 'D' then
        y := y + 13;
      if x[1] = 'E' then
        y := y + 14;
      if x[1] = 'F' then
        y := y + 15;
      if (integer(x[1]) < $30) or ((integer(x[1]) > $39) and (integer(x[1]) < $41)) or (integer(x[1]) > $46) then
      begin
        x := '';
        y := -1;
      end;
      x := copy(x, 2, length(x) - 1);

    end;
  end
  else
    y := -1;
  result := y;
end;

procedure TForm1.Button7Click(Sender: TObject);
var // h:TNPCGroupeHeader;
  f: integer;
begin
  SaveDialog1.Filter := 'All chunk|*.*|Object only|*o.dat|Monster only|*e.dat|Event only|*.evt';
  if CheckListBox1.ItemIndex > -1 then
    if SaveDialog1.Execute then
    begin
      if (SaveDialog1.FilterIndex = 1) or (SaveDialog1.FilterIndex = 2) then
      begin
        f := filecreate(SaveDialog1.filename + 'o.dat');
        filewrite(f, Floor[CheckListBox1.ItemIndex].Obj[0], (Floor[CheckListBox1.ItemIndex].ObjCount * $44));
        fileclose(f);
      end;
      if (SaveDialog1.FilterIndex = 1) or (SaveDialog1.FilterIndex = 3) then
      begin
        f := filecreate(SaveDialog1.filename + 'e.dat');
        filewrite(f, Floor[CheckListBox1.ItemIndex].Monster[0], (Floor[CheckListBox1.ItemIndex].MonsterCount * $48));
        fileclose(f);
      end;
      if (SaveDialog1.FilterIndex = 1) or (SaveDialog1.FilterIndex = 4) then
      begin
        f := filecreate(SaveDialog1.filename + '.evt');
        filewrite(f, Floor[CheckListBox1.ItemIndex].Unknow[0], Floor[CheckListBox1.ItemIndex].UnknowCount);
        fileclose(f);
      end;
      { f:=filecreate(SaveDialog1.FileName);
        h.Flag:=1;
        h.TotalSize:=(Floor[checklistbox1.ItemIndex].ObjCount * $44) + 16;
        h.FloorId:=checklistbox1.ItemIndex;
        h.DataLength:=h.TotalSize-16;
        FileWrite(f,h,16);
        FileWrite(f,Floor[checklistbox1.ItemIndex].Obj[0],h.DataLength);

        h.Flag:=2;
        h.TotalSize:=(Floor[checklistbox1.ItemIndex].MonsterCount * $48) + 16;
        h.DataLength:=h.TotalSize-16;
        FileWrite(f,h,16);
        FileWrite(f,Floor[checklistbox1.ItemIndex].Monster[0],h.DataLength);

        h.Flag:=3;
        h.TotalSize:=Floor[checklistbox1.ItemIndex].UnknowCount + 16;
        h.DataLength:=h.TotalSize-16;
        if h.DataLength > 0 then begin
        FileWrite(f,h,16);
        FileWrite(f,Floor[checklistbox1.ItemIndex].unknow[0],h.DataLength);
        end;
        fileclose(f); }
    end;
end;

procedure TForm1.Save1Click(Sender: TObject);
var
  x, y, f, o, j, F2, F1, s1, s2, z, bl, dl: integer;
  d: dword;
  txt: array [0 .. 1] of ansichar;
  h: TNPCGroupeHeader;
  fn, b: ansistring;
  tmp: array [0 .. $3FF] of ansichar;
  di, da, db: pansichar;
  qtmp: array [0 .. 99] of pansichar;
  qtmpsize, qtmppos: array [0 .. 99] of integer;
  mh: ansistring;
begin

  SaveDialog1.Filter :=
    'Quest file|*.bin|Server Quest file(PC)|*.qst|Server Quest file(DC)|*.qst|Server Quest file(GC)|*.qst|Server Quest file(BB)'
    + '|*.qst|Download Quest file(DC)|*.qst|Download Quest file(PC)|*.qst|Download Quest file(GC)|*.qst|Download Quest file(Xbox)|*.qst'
    + '|Kohle basic format(PC)|*.bin|Kohle basic format(DC)|*.bin|Kohle basic format(GC)|*.bin|Kohle basic format(BB)|*.bin'
    + '|Quest project|*.qprj';

  SaveDialog1.FilterIndex := lsatsaveformat;
  if SaveDialog1.Execute then
  begin
    lsatsaveformat := SaveDialog1.FilterIndex;
    isedited := false;
    ClearShadow;
    FullQuestFile := SaveDialog1.filename;
    if SaveDialog1.FilterIndex = 13 then
    begin
      DumpQuest(changefileext(SaveDialog1.filename, '.qprj'));
      exit;
    end;
    // save the quest;
    // clear the ref data

    AsmMode := 0;
    if SaveDialog1.FilterIndex >= 3 then
      isdc := true;
    if SaveDialog1.FilterIndex < 3 then
      isdc := false;
    if SaveDialog1.FilterIndex >= 4 then
      AsmMode := 2;
    if SaveDialog1.FilterIndex = 5 then
      isdc := false;
    if SaveDialog1.FilterIndex = 7 then
      isdc := false;
    if SaveDialog1.FilterIndex = 6 then
      AsmMode := 0;
    if SaveDialog1.FilterIndex = 7 then
      AsmMode := 0;

    if SaveDialog1.FilterIndex = 10 then
    begin
      AsmMode := 0;
      isdc := false;
    end;
    if SaveDialog1.FilterIndex = 11 then
    begin
      AsmMode := 0;
      isdc := true;
    end;
    if SaveDialog1.FilterIndex = 12 then
    begin
      AsmMode := 2;
      isdc := true;
    end;
    if SaveDialog1.FilterIndex = 13 then
    begin
      AsmMode := 2;
      isdc := false;
    end;

    for x := 0 to 90000 do
      AsmRef[x] := $FFFFFFFF;
    y := QuestBuild(@AsmData);
    For x := 90000 downto 0 do
      if AsmRef[x] <> $FFFFFFFF then
        break;
    inc(x);
    asmdatas := y;
    asmrefs := x;

    // rebuild the virtual file
    di := allocmem(5000000);

    F1 := 0;
    // bin file
    if not isdc then
    begin
      if SaveDialog1.FilterIndex = 5 then
      begin
        d := 4652;
        move(d, di[F1], 4);
        inc(F1, 4);
        d := y + 4652;
        move(d, di[F1], 4);
        inc(F1, 4);
        d := (x * 4) + y + 4652;
        F2 := d;
        move(d, di[F1], 4);
        inc(F1, 4);
        d := $FFFFFFFF;
        move(d, di[F1], 4);
        inc(F1, 4);
        // language and quest number
        d := qnum;
        move(d, di[F1], 4);
        inc(F1, 4);
        d := $0;
        move(d, di[F1], 4);
        inc(F1, 4);
        move(BBData[0], di[$39C], $E90);
      end
      else
      begin
        d := $394;
        move(d, di[F1], 4);
        inc(F1, 4);
        d := y + $394;
        move(d, di[F1], 4);
        inc(F1, 4);
        d := (x * 4) + y + $394;
        F2 := d;
        move(d, di[F1], 4);
        inc(F1, 4);
        d := $FFFFFFFF;
        move(d, di[F1], 4);
        inc(F1, 4);
        // language and quest number
        d := language + (qnum * $10000);
        move(d, di[F1], 4);
        inc(F1, 4);
      end;

      // title and other info
      txt[1] := #0;
      // for pc quest only
      o := 0;
      for d := 0 to $1F do
      begin
        if d < length(Title) then
        begin
          txt[0] := pansichar(@Title[d + 1])[0];
          txt[1] := pansichar(@Title[d + 1])[1];
        end
        else
        begin
          txt[0] := #0;
          txt[1] := #0;
        end;
        if (txt[0] <> #$a) or (txt[1] <> #0) then
        begin
          if (txt[0] = #$d) and (txt[1] = #0) then
            txt[0] := #$a;
          move(txt[0], di[F1], 2);
          inc(F1, 2);
        end
        else
          inc(o);
      end;
      txt[0] := #0;
      for j := 0 to o - 1 do
      begin
        move(txt[0], di[F1], 2);
        inc(F1, 2);
      end;
      o := 0;
      for d := 0 to $7F do
      begin
        if d < length(Info) then
        begin
          txt[0] := pansichar(@Info[d + 1])[0];
          txt[1] := pansichar(@Info[d + 1])[1];
        end
        else
        begin
          txt[0] := #0;
          txt[1] := #0;
        end;
        if (txt[0] <> #$a) or (txt[1] <> #0) then
        begin
          if (txt[0] = #$d) and (txt[1] = #0) then
            txt[0] := #$a;
          move(txt[0], di[F1], 2);
          inc(F1, 2);
        end
        else
          inc(o);
      end;
      txt[0] := #0;
      for j := 0 to o - 1 do
      begin
        move(txt[0], di[F1], 2);
        inc(F1, 2);
      end;
      o := 0;
      for d := 0 to $11F do
      begin
        if d < length(Desc) then
        begin
          txt[0] := pansichar(@Desc[d + 1])[0];
          txt[1] := pansichar(@Desc[d + 1])[1];
        end
        else
        begin
          txt[0] := #0;
          txt[1] := #0;
        end;
        if (txt[0] <> #$a) or (txt[1] <> #0) then
        begin
          if (txt[0] = #$d) and (txt[1] = #0) then
            txt[0] := #$a;
          move(txt[0], di[F1], 2);
          inc(F1, 2);
        end
        else
          inc(o);
      end;
      txt[0] := #0;
      for j := 0 to o - 1 do
      begin
        move(txt[0], di[F1], 2);
        inc(F1, 2);
      end;

    end
    else
    begin // dreamcast format for quest

      d := $1D4;
      move(d, di[F1], 4);
      inc(F1, 4);
      d := y + $1D4;
      move(d, di[F1], 4);
      inc(F1, 4);
      d := (x * 4) + y + $1D4;
      move(d, di[F1], 4);
      inc(F1, 4);
      F2 := d;
      d := $FFFFFFFF;
      move(d, di[F1], 4);
      inc(F1, 4);
      // language and quest number
      d := language + (qnum * $10000);
      if SaveDialog1.FilterIndex = 4 then
        d := d + $200;
      move(d, di[F1], 4);
      inc(F1, 4);
      // title and other info
      txt[1] := #0;
      // for pc quest only
      o := 0;
      mh := unitochar(Title, 32);
      for d := 0 to $1F do
      begin
        if d < length(mh) then
          txt[0] := mh[d + 1]
        else
          txt[0] := #0;
        if (txt[0] <> #$a) then
        begin
          if (txt[0] = #$d) then
            txt[0] := #$a;
          di[F1] := txt[0];
          inc(F1);
        end
        else
          inc(o);
      end;
      txt[0] := #0;
      for j := 0 to o - 1 do
      begin
        di[F1] := txt[0];
        inc(F1);
      end;
      o := 0;
      mh := unitochar(Info, $80);
      for d := 0 to $7F do
      begin
        if d < length(mh) then
          txt[0] := mh[d + 1]
        else
          txt[0] := #0;
        if (txt[0] <> #$a) then
        begin
          if (txt[0] = #$d) then
            txt[0] := #$a;
          di[F1] := txt[0];
          inc(F1);
        end
        else
          inc(o);
      end;
      txt[0] := #0;
      for j := 0 to o - 1 do
      begin
        di[F1] := txt[0];
        inc(F1);
      end;
      o := 0;
      mh := unitochar(Desc, $120);
      for d := 0 to $11F do
      begin
        if d < length(mh) then
          txt[0] := mh[d + 1]
        else
          txt[0] := #0;
        if (txt[0] <> #$a) then
        begin
          if (txt[0] = #$d) then
            txt[0] := #$a;
          di[F1] := txt[0];
          inc(F1);
        end
        else
          inc(o);
      end;
      txt[0] := #0;
      for j := 0 to o - 1 do
      begin
        di[F1] := txt[0];
        inc(F1);
      end;

    end;

    move(di[0], F1, 4);
    // code data
    move(AsmData[0], di[F1], y);
    inc(F1, y);
    move(AsmRef[0], di[F1], x * 4);
    inc(F1, x * 4);

    bl := y + (x * 4);

    for f := 0 to qstfilecount - 1 do
      if pos('.bin', lowercase(qstfile[f].name)) > 0 then
        break;
    if f = qstfilecount then
    begin
      qstfile[f].name := 'quest' + inttostr(qnum) + '.bin';
      qstfile[f].from := 0;
      inc(qstfilecount);
    end
    else
      freemem(qstfile[f].data);
    qstfile[f].data := allocmem(F2);
    qstfile[f].size := F2;
    move(di[0], qstfile[f].data[0], F2);


    // dat file

    dl := 0;
    F1 := 0;
    for x := 0 to 20 do
      if CheckListBox1.Checked[x] then
        if Floor[x].ObjCount > 0 then
        begin
          h.flag := 1;
          h.TotalSize := (Floor[x].ObjCount * $44) + 16;
          dl := dl + h.TotalSize;
          h.floorid := x;
          h.DataLength := h.TotalSize - 16;
          move(h, di[F1], 16);
          inc(F1, 16);
          move(Floor[x].Obj[0], di[F1], h.DataLength);
          inc(F1, h.DataLength);
        end;

    for x := 0 to 20 do
      if CheckListBox1.Checked[x] then
        if Floor[x].MonsterCount > 0 then
        begin
          h.flag := 2;
          h.TotalSize := (Floor[x].MonsterCount * $48) + 16;
          dl := dl + h.TotalSize;
          h.DataLength := h.TotalSize - 16;
          h.floorid := x;
          move(h, di[F1], 16);
          inc(F1, 16);
          move(Floor[x].Monster[0], di[F1], h.DataLength);
          inc(F1, h.DataLength);
        end;

    for x := 1 to 20 do
      if CheckListBox1.Checked[x] then
      begin
        h.flag := 3;
        h.TotalSize := Floor[x].UnknowCount + 16;
        dl := dl + h.TotalSize;
        h.DataLength := h.TotalSize - 16;
        h.floorid := x;
        if h.DataLength > 0 then
        begin
          move(h, di[F1], 16);
          inc(F1, 16);
          move(Floor[x].Unknow[0], di[F1], h.DataLength);
          inc(F1, h.DataLength);
        end;
      end;

    for x := 0 to 20 do
      if CheckListBox1.Checked[x] then
        if Floor[x].d04count > 0 then
        begin
          h.flag := 4;
          h.TotalSize := Floor[x].d04count + 16;
          dl := dl + h.TotalSize;
          h.DataLength := h.TotalSize - 16;
          h.floorid := x;
          if h.DataLength > 0 then
          begin
            move(h, di[F1], 16);
            inc(F1, 16);
            move(Floor[x].d04[0], di[F1], h.DataLength);
            inc(F1, h.DataLength);
          end;
        end;

    for x := 0 to 20 do
      if CheckListBox1.Checked[x] then
        if Floor[x].d05count > 0 then
        begin
          h.flag := 5;
          h.TotalSize := Floor[x].d05count + 16;
          dl := dl + h.TotalSize;
          h.DataLength := h.TotalSize - 16;
          h.floorid := x;
          if h.DataLength > 0 then
          begin
            move(h, di[F1], 16);
            inc(F1, 16);
            move(Floor[x].d05[0], di[F1], h.DataLength);
            inc(F1, h.DataLength);
          end;
        end;

    h.flag := 0;
    h.TotalSize := 0;
    h.floorid := 0;
    h.DataLength := 0;
    move(h, di[F1], 16);
    inc(F1, 16);
    dl := dl + 16;

    for f := 0 to qstfilecount - 1 do
      if pos('.dat', lowercase(qstfile[f].name)) > 0 then
        break;
    if f = qstfilecount then
    begin
      qstfile[f].name := 'quest' + inttostr(qnum) + '.dat';
      qstfile[f].from := 0;
      inc(qstfilecount);
    end
    else
      freemem(qstfile[f].data);
    qstfile[f].data := allocmem(F1);
    qstfile[f].size := F1;
    move(di[0], qstfile[f].data[0], F1);

    // end of file construction

    // compress if needed
    if (SaveDialog1.FilterIndex = 2) or (SaveDialog1.FilterIndex = 4) or (SaveDialog1.FilterIndex = 3) or
      (SaveDialog1.FilterIndex = 5) or (SaveDialog1.FilterIndex = 6) or (SaveDialog1.FilterIndex = 7) or
      (SaveDialog1.FilterIndex = 8) or (SaveDialog1.FilterIndex = 9) then
    begin


      // prs compression

      for f := 0 to qstfilecount - 1 do
        if (pos('.bin', lowercase(qstfile[f].name)) = 0) and (pos('.dat', lowercase(qstfile[f].name)) = 0) then
        begin
          // copy data only
          qtmp[f] := allocmem(qstfile[f].size + 8);
          qtmpsize[f] := qstfile[f].size;
          move(qstfile[f].data[0], qtmp[f][0], qstfile[f].size);
          qtmppos[f] := 0;
        end
        else
        begin
          // compress
          qtmp[f] := allocmem(qstfile[f].size * 2);
          qtmpsize[f] := pikacompress(qstfile[f].data, qtmp[f], qstfile[f].size);
          qtmppos[f] := 0;
        end;
      // file is compressed

      if (SaveDialog1.FilterIndex = 6) or (SaveDialog1.FilterIndex = 7) or (SaveDialog1.FilterIndex = 8) or
        (SaveDialog1.FilterIndex = 9) then
      begin
        // need to encrypt the file
        for f := 0 to qstfilecount - 1 do
          if (pos('.bin', lowercase(qstfile[f].name)) > 0) or (pos('.dat', lowercase(qstfile[f].name)) > 0) then
          begin
            setlength(b, qtmpsize[f]);
            move(qtmp[f][0], b[1], qtmpsize[f]);
            F1 := random($7FFFFFFF);
            CreateKey(F1, 0);
            b := PSOEnc(b, 0, 0);
            bl := qstfile[f].size;
            b := ansichar(bl) + ansichar(bl div 256) + ansichar(bl div $10000) + #0 + pansichar(@F1)[0] + pansichar(@F1)
              [1] + pansichar(@F1)[2] + pansichar(@F1)[3] + b;
            inc(qtmpsize[f], 8);
            move(b[1], qtmp[f][0], qtmpsize[f]);
          end;
        // done
      end;

      // save in the file
      f := filecreate(changefileext(SaveDialog1.filename, '.qst'));
      if f < 0 then
      begin
        showmessage(GetLanguageString(74) + #13#10 + SaveDialog1.filename);
        exit;
      end;
      // write all header
      for x := 0 to qstfilecount - 1 do
      begin
        qstfile[x].name := 'quest' + inttostr(qnum) + extractfileext(qstfile[x].name);
        if SaveDialog1.FilterIndex = 5 then
        begin
          setlength(b, $58);
          fillchar(b[1], $58, 0);
          b[1] := #$58;
          b[3] := #$44;
          move(qnum, b[5], 2);
          move(qstfile[x].name[1], b[45], length(qstfile[x].name));
          if qstfilecount > 2 then
            b[43] := ansichar(qstfilecount - 2);
          move(qtmpsize[x], b[61], 4);
          fn := qstfile[x].name;
          insert('_j', fn, pos('.', qstfile[x].name));
          move(fn[1], b[65], length(fn));
        end;
        if (SaveDialog1.FilterIndex = 2) or (SaveDialog1.FilterIndex = 7) then
        begin
          setlength(b, $3C);
          fillchar(b[1], $3C, 0);
          b[1] := #$3c;
          b[3] := #$44;
          if SaveDialog1.FilterIndex = 7 then
            b[3] := #$a6;
          if qstfilecount > 2 then
            b[39] := ansichar(qstfilecount - 2);
          move(qnum, b[4], 1);
          move(qstfile[x].name[1], b[41], length(qstfile[x].name));
          move(qtmpsize[x], b[57], 4);
        end;
        if (SaveDialog1.FilterIndex = 4) or (SaveDialog1.FilterIndex = 8) or (SaveDialog1.FilterIndex = 3) or
          (SaveDialog1.FilterIndex = 6) then
        begin
          setlength(b, $3C);
          fillchar(b[1], $3C, 0);
          b[3] := #$3c;
          b[1] := #$44;
          if SaveDialog1.FilterIndex > 5 then
            b[1] := #$a6;
          move(qnum, b[2], 1);
          if (SaveDialog1.FilterIndex = 4) or (SaveDialog1.FilterIndex = 8) then
            move(qstfile[x].name[1], b[41], length(qstfile[x].name))
          else
            move(qstfile[x].name[1], b[40], length(qstfile[x].name));
          if qstfilecount > 2 then
            b[39] := ansichar(qstfilecount - 2);

          move(qtmpsize[x], b[57], 4);
          fn := unitochar('PSO/' + Title, 32);
          if length(fn) > 32 then
            fn := copy(fn, 1, 32);
          move(fn[1], b[5], length(fn));
        end;
        if (SaveDialog1.FilterIndex = 9) then
        begin
          setlength(b, $54);
          fillchar(b[1], $54, 0);
          b[3] := #$54;
          b[1] := #$a6;
          move(qnum, b[$25], 2);
          move(qstfile[x].name[1], b[41], length(qstfile[x].name));

          move(qtmpsize[x], b[57], 4);
          fn := unitochar('PSO/' + Title, 32);
          if length(fn) > 32 then
            fn := copy(fn, 1, 32);
          move(fn[1], b[5], length(fn));

          // add file name and quest id for xbox folder
          fn := changefileext(qstfile[x].name, quest_sufix[language] + '.dat');
          move(fn[1], b[$3D], length(fn));
          move(qnum, b[$4D], 2);
          b[$50] := ansichar((language + 1) * $10);
        end;

        filewrite(f, b[1], length(b));
      end;
      F2 := 0;
      while F2 < qstfilecount do
      begin
        for x := 0 to qstfilecount - 1 do
          if qtmppos[x] <= qtmpsize[x] then
          begin
            // make header
            setlength(b, $1C);
            fillchar(b[1], $1C, 0);
            if (SaveDialog1.FilterIndex = 4) or (SaveDialog1.FilterIndex = 8) or (SaveDialog1.FilterIndex = 9) or
              (SaveDialog1.FilterIndex = 3) or (SaveDialog1.FilterIndex = 6) then
            begin
              b[1] := #$13;
              if SaveDialog1.FilterIndex > 5 then
                b[1] := #$a7;
              b[3] := #$18;
              b[4] := #4;
              b[2] := ansichar(qtmppos[x] div 1024);
            end;
            if (SaveDialog1.FilterIndex = 2) or (SaveDialog1.FilterIndex = 7) then
            begin
              b[3] := #$13;
              if SaveDialog1.FilterIndex > 5 then
                b[3] := #$a7;
              b[1] := #$18;
              b[2] := #4;
              b[4] := ansichar(qtmppos[x] div 1024);
            end;
            if (SaveDialog1.FilterIndex = 5) then
            begin
              b[3] := #$13;
              b[1] := #$1c;
              b[2] := #4;
              b[5] := ansichar(qtmppos[x] div 1024);
              move(qstfile[x].name[1], b[9], length(qstfile[x].name));
              filewrite(f, b[1], $18);
            end
            else
            begin
              move(qstfile[x].name[1], b[5], length(qstfile[x].name));
              filewrite(f, b[1], $14);
            end;
            // write data
            F1 := qtmpsize[x] - qtmppos[x];
            if F1 > 1024 then
              F1 := 1024;
            setlength(b, 1024);
            fillchar(b[1], 1024, 0);
            move(qtmp[x][qtmppos[x]], b[1], F1);
            filewrite(f, b[1], 1024);
            inc(qtmppos[x], 1024);
            if qtmppos[x] >= qtmpsize[x] then inc(F2);
            filewrite(f, F1, 4);
            // pso bug

            if (SaveDialog1.FilterIndex = 5) then
            begin
              F1 := 0;
              filewrite(f, F1, 4);
            end;
          end;
      end;
      fileclose(f);
      for x := 0 to qstfilecount - 1 do
        freemem(qtmp[x]);
    end
    else if (SaveDialog1.FilterIndex = 13) or (SaveDialog1.FilterIndex = 10) or (SaveDialog1.FilterIndex = 11) or
      (SaveDialog1.FilterIndex = 12) then
    begin
      fn := SaveDialog1.filename;
      for x := 0 to qstfilecount - 1 do
      begin
        fn := changefileext(fn, extractfileext(qstfile[x].name));
        if pos('.pvr', lowercase(qstfile[x].name)) > 0 then
        begin
          // copy data only
          qtmp[x] := allocmem(qstfile[x].size * 2);
          F1 := qstfile[x].size;
          move(qstfile[x].data[0], qtmp[x], F1);
        end
        else
        begin
          // compress
          qtmp[x] := allocmem(qstfile[x].size * 2);
          F1 := pikacompress(qstfile[x].data, qtmp[x], qstfile[x].size);
        end;
        f := filecreate(fn);
        if f < 0 then
        begin
          showmessage(GetLanguageString(74) + #13#10 + fn);
          exit;
        end;
        filewrite(f, qtmp[x][0], F1);
        fileclose(f);
        freemem(qtmp[x]);
      end;

    end
    else
    begin
      // normal uncompressed format
      fn := SaveDialog1.filename;
      for x := 0 to qstfilecount - 1 do
      begin
        fn := changefileext(fn, extractfileext(qstfile[x].name));
        f := filecreate(fn);
        if f < 0 then
        begin
          showmessage(GetLanguageString(74) + #13#10 + fn);
          exit;
        end;
        filewrite(f, qstfile[x].data[0], qstfile[x].size);
        fileclose(f);
      end;
    end;

    freemem(di);
  end;
end;

procedure TForm1.Setting1Click(Sender: TObject);
begin
  form6.ComboBox1.ItemIndex := language;
  form6.SpinEdit1.value := qnum;
  form6.ShowModal;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  x1, z1, x2, z2: Single;
begin
  SetUndow;

  If stype = 1 then
  begin
    // monster;
    form7.StringGrid1.RowCount := 23;
    form7.StringGrid1.Cells[0, 0] := 'Skin';
    form7.StringGrid1.Cells[0, 1] := 'Unknow';
    form7.StringGrid1.Cells[0, 2] := 'Unknow';
    form7.StringGrid1.Cells[0, 3] := 'Child Count';
    form7.StringGrid1.Cells[0, 4] := 'Unknow';
    form7.StringGrid1.Cells[0, 5] := 'Unknow';
    form7.StringGrid1.Cells[0, 6] := 'Map Section';
    form7.StringGrid1.Cells[0, 7] := 'Apear order';
    form7.StringGrid1.Cells[0, 8] := 'Apear order';
    form7.StringGrid1.Cells[0, 9] := 'Pos X';
    form7.StringGrid1.Cells[0, 10] := 'Pos Y';
    form7.StringGrid1.Cells[0, 11] := 'Pos Z';
    form7.StringGrid1.Cells[0, 12] := 'Rotation X';
    form7.StringGrid1.Cells[0, 13] := 'Rotation Y';
    form7.StringGrid1.Cells[0, 14] := 'Rotation Z';
    // Form7.StringGrid1.Cells[0,15]:='Unknow';
    form7.StringGrid1.Cells[0, 15] := 'Movement Data';
    form7.StringGrid1.Cells[0, 16] := 'Unknow';
    form7.StringGrid1.Cells[0, 17] := 'Unknow';
    form7.StringGrid1.Cells[0, 18] := 'Char Id';
    form7.StringGrid1.Cells[0, 19] := 'Action';
    form7.StringGrid1.Cells[0, 20] := 'Flag 1';
    form7.StringGrid1.Cells[0, 21] := 'Flag 2';
    { if fileexists(path+'Edit_mons.cfg') then
      Form7.StringGrid1.Cols[0].LoadFromFile(path+'Edit_mons.cfg'); }

    form7.Label3.Caption := inttostr(miz[Floor[sfloor].Monster[Selected].map_section]);

    x1 := Floor[sfloor].Monster[Selected].Pos_X;
    z1 := Floor[sfloor].Monster[Selected].Pos_Y;
    x2 := cos(-rev[Floor[sfloor].Monster[Selected].map_section] / 10430.37835) * x1 -
      sin(-rev[Floor[sfloor].Monster[Selected].map_section] / 10430.37835) * z1;
    z2 := sin(-rev[Floor[sfloor].Monster[Selected].map_section] / 10430.37835) * x1 +
      cos(-rev[Floor[sfloor].Monster[Selected].map_section] / 10430.37835) * z1;

    Form1.DrawZBBRELFile(mapfilenam, x2 + midpz[Floor[sfloor].Monster[Selected].map_section].x,
      z2 + midpz[Floor[sfloor].Monster[Selected].map_section].y, miz[Floor[sfloor].Monster[Selected].map_section]);

    move(Floor[sfloor].Monster[Selected], form7.EMonsterData, sizeof(TMonster));
    form7.UpdateMonsterData;
  end;

  If stype = 2 then
  begin
    // Object;

    form7.StringGrid1.RowCount := 20;
    form7.StringGrid1.Cells[0, 0] := 'Skin';
    form7.StringGrid1.Cells[0, 1] := 'Unknow';
    form7.StringGrid1.Cells[0, 2] := 'Unknow';
    form7.StringGrid1.Cells[0, 3] := 'ID';
    form7.StringGrid1.Cells[0, 4] := 'Apear flag';
    form7.StringGrid1.Cells[0, 5] := 'Map Section';
    form7.StringGrid1.Cells[0, 6] := 'Unknow';
    form7.StringGrid1.Cells[0, 7] := 'Pos X';
    form7.StringGrid1.Cells[0, 8] := 'Pos Y';
    form7.StringGrid1.Cells[0, 9] := 'Pos Z';
    form7.StringGrid1.Cells[0, 10] := 'Rotation X';
    form7.StringGrid1.Cells[0, 11] := 'rotation Y';
    form7.StringGrid1.Cells[0, 12] := 'Rotation Z';
    form7.StringGrid1.Cells[0, 13] := 'Active range';
    form7.StringGrid1.Cells[0, 14] := 'Scale Y';
    form7.StringGrid1.Cells[0, 15] := 'Scale Z';
    form7.StringGrid1.Cells[0, 16] := 'Action';
    form7.StringGrid1.Cells[0, 17] := 'unknow';
    form7.StringGrid1.Cells[0, 18] := 'Unknow';
    form7.StringGrid1.Cells[0, 19] := 'Unknow';
    if fileexists(path + 'Edit_objs.cfg') then
      form7.StringGrid1.Cols[0].LoadFromFile(path + 'Edit_objs.cfg');

    form7.Label3.Caption := inttostr(miz[Floor[sfloor].Obj[Selected].map_section]);

    x1 := Floor[sfloor].Monster[Selected].Pos_X;
    z1 := Floor[sfloor].Monster[Selected].Pos_Y;
    x2 := cos(-rev[Floor[sfloor].Monster[Selected].map_section] / 10430.37835) * x1 -
      sin(-rev[Floor[sfloor].Monster[Selected].map_section] / 10430.37835) * z1;
    z2 := sin(-rev[Floor[sfloor].Monster[Selected].map_section] / 10430.37835) * x1 +
      cos(-rev[Floor[sfloor].Monster[Selected].map_section] / 10430.37835) * z1;

    Form1.DrawZBBRELFile(mapfilenam, x2 + midpz[Floor[sfloor].Obj[Selected].map_section].x,
      z2 + midpz[Floor[sfloor].Obj[Selected].map_section].y, miz[Floor[sfloor].Obj[Selected].map_section]);

    move(Floor[sfloor].Obj[Selected], form7.EObjData, sizeof(TObj));
    form7.UpdateItemData;
  end;

  form7.ShowModal;
end;

procedure TForm1.Button8Click(Sender: TObject);
var
  x, y, f: integer;
  h: TNPCGroupeHeader;
begin
  OpenDialog1.Filter := 'Object only|*o.dat;*d.dat|Monster only|*e.dat|Event only|*.evt';
  if OpenDialog1.Execute then
  begin
    isedited := true;
    x := sfloor;
    if OpenDialog1.FilterIndex = 1 then
    begin
      f := fileopen(OpenDialog1.filename, $40);
      Floor[x].ObjCount := fileseek(f, 0, 2) div $44;
      fileseek(f, 0, 0);
      fileread(f, Floor[x].Obj[0], Floor[x].ObjCount * $44);
      fileclose(f);
      CheckListBox1Click(Form1);
    end;
    if OpenDialog1.FilterIndex = 2 then
    begin
      f := fileopen(OpenDialog1.filename, $40);
      Floor[x].MonsterCount := fileseek(f, 0, 2) div $48;
      fileseek(f, 0, 0);
      fileread(f, Floor[x].Monster[0], Floor[x].MonsterCount * $48);
      fileclose(f);
      CheckListBox1Click(Form1);
    end;
    if OpenDialog1.FilterIndex = 3 then
    begin
      f := fileopen(OpenDialog1.filename, $40);
      Floor[x].UnknowCount := fileseek(f, 0, 2);
      fileseek(f, 0, 0);
      fileread(f, Floor[x].Unknow[0], Floor[x].UnknowCount);
      fileclose(f);
    end;

  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  x, y, s: integer;
  p1, p2: pansichar;
begin
  if Selected > -1 then
  begin
    s := Selected;
    isedited := true;
    HideIndicator();
    MoveSel := -1;
    SetUndow;
    if stype = 1 then
    begin // monstre
      // if have3d then Mymonst[selected].Free;
      for x := Selected to Floor[sfloor].MonsterCount - 2 do
      begin
        p1 := @Floor[sfloor].Monster[x];
        p2 := @Floor[sfloor].Monster[x + 1];

        for y := 0 to sizeof(TMonster) - 1 do
          p1[y] := p2[y];
        // if have3d then Mymonst[x]:=Mymonst[x+1];
      end;
      dec(Floor[sfloor].MonsterCount);
      // form1.listbox1.Items.Delete(selected);
      { if have3d then begin
        dec(MyMonstCount);
        setlength(Mymonst,MyMonstCount);
        end; }
    end;

    if stype = 2 then
    begin // object
      for x := Selected to Floor[sfloor].ObjCount - 2 do
      begin
        p1 := @Floor[sfloor].Obj[x];
        p2 := @Floor[sfloor].Obj[x + 1];

        for y := 0 to sizeof(TObj) - 1 do
          p1[y] := p2[y];

        // Floor[sfloor].Obj[x].id:=x;
      end;
      dec(Floor[sfloor].ObjCount);
      // form1.listbox2.Items.Delete(selected);
    end;
    ctrldw := true;
    //
    CheckListBox1Click(Form1);
    if stype = 1 then
    begin
      if s < Form1.ListBox1.count then
      begin
        Selected := s;
        Form1.ListBox1.Selected[s] := true;
        Button2.Enabled := true;
        Button1.Enabled := true;
        Button3.Enabled := true;
        smEdit.Enabled := true;
        smDelete.Enabled := true;
        smMove.Enabled := true;
      end;
    end;
    if stype = 2 then
    begin
      if s < Form1.ListBox2.count then
      begin
        Selected := s;
        Form1.ListBox2.Selected[s] := true;
        Button2.Enabled := true;
        Button1.Enabled := true;
        Button3.Enabled := true;
        smEdit.Enabled := true;
        smDelete.Enabled := true;
        smMove.Enabled := true;
      end;
    end;
    DrawMap;
    ctrldw := false;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  x, y: integer;
begin
  SetUndow;
  fillchar(Floor[sfloor].Obj[Floor[sfloor].ObjCount], sizeof(TObj), 0);
  if objscreen = nil then
  begin
    objscreen := TPikaEngine.Create(form10.Panel1.Handle, 177, 151, 1);
    if objscreen.Enable then
    begin
      objscreen.AlphaEnabled := true;
      objscreen.AlphaTestValue := 16;
      objscreen.Antializing := true;
      objscreen.ViewDistance := 0;
      objscreen.TextureMirrored := true;
      objscreen.BackGroundColor := $FF303030;
      objitm := t3ditem.Create(objscreen);
      form10.Timer1.Enabled := true;
    end;
  end;
  objscreen.BackGroundColor := $FF303030;
  form10.ComboBox1.Clear;
  for x := 0 to preseti - 1 do
    for y := 0 to FloorObjID[Floor[sfloor].floorid].count[FFilter] - 1 do
      if FloorObjID[Floor[sfloor].floorid].ids[FFilter, y] = ObjTemplate[x].data.Skin then
      begin
        form10.ComboBox1.Items.Add(ObjTemplate[x].name);
        break;
      end;
  form10.tag := 0;
  form10.ComboBox1.ItemIndex := 0;
  if form10.UnicodestringGrid1.Cells[1, 0] = '' then
    form10.UnicodestringGrid1.Cells[1, 0] := '30';
  if form10.UnicodeStringGrid2.Cells[1, 0] = '' then
    form10.UnicodeStringGrid2.Cells[1, 0] := '1';
  if form10.UnicodeStringGrid2.Cells[1, 1] = '' then
    form10.UnicodeStringGrid2.Cells[1, 1] := '1';
  if form10.UnicodeStringGrid2.Cells[1, 2] = '' then
    form10.UnicodeStringGrid2.Cells[1, 2] := '1';
  form10.UnicodestringGrid1.Cells[0, 0] := GetLanguageString(75);
  form10.UnicodeStringGrid2.Cells[0, 0] := GetLanguageString(76);
  form10.UnicodeStringGrid2.Cells[0, 1] := GetLanguageString(77);
  form10.UnicodeStringGrid2.Cells[0, 2] := GetLanguageString(78);
  form10.ComboBox1Change(form9);

  form10.ShowModal;
  if (form10.ComboBox1.ItemIndex > -1) and (form10.tag = 1) then
  begin
    Copylastitem1.Enabled := true;
    inc(Floor[sfloor].ObjCount);
    for x := 0 to preseti - 1 do
      if ObjTemplate[x].name = form10.ComboBox1.Text then
        break;
    for y := 0 to sizeof(TObj) - 1 do
      pansichar(@Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1])[y] := pansichar(@ObjTemplate[x].data)[y];

    if form10.UnicodestringGrid1.Visible then
      Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1].unknow8 := strtofloat(form10.UnicodestringGrid1.Cells[1, 0]);

    if form10.UnicodeStringGrid2.Visible then
    begin
      Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1].unknow8 := strtofloat(form10.UnicodeStringGrid2.Cells[1, 0]);
      Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1].unknow9 := strtofloat(form10.UnicodeStringGrid2.Cells[1, 1]);
      Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1].Unknow10 := strtofloat(form10.UnicodeStringGrid2.Cells[1, 2]);
    end;

    SetObjectDefaults();
    ShowIndicator();
    MoveSel := Floor[sfloor].ObjCount - 1;
    MoveType := 2;
    ListBox2.Items.Add('#' + inttostr(MoveSel) + ' - ' + GetObjName(Floor[sfloor].Obj[MoveSel].Skin));
    if have3d then
    begin
      MyObjCount := Floor[sfloor].ObjCount;
      setlength(MyObj, MyObjCount);
      MyObj[MoveSel] := nil;
      Generateobj(Floor[sfloor].Obj[MoveSel], MoveSel);

    end;
    ctrldw := true;
    firstdrop := true;
    DrawMap;
    isedited := true;
    // CheckListBox1Click(form1);
  end;

end;

procedure TForm1.Button9Click(Sender: TObject);
var
  x, y: integer;
begin
  SetUndow;
  fillchar(Floor[sfloor].Monster[Floor[sfloor].MonsterCount], sizeof(TMonster), 0);

  form9.ComboBox1.Items.Clear;
  for x := 0 to presetm - 1 do
    for y := 0 to FloorMonsID[Floor[sfloor].floorid].count[FFilter] - 1 do
      if FloorMonsID[Floor[sfloor].floorid].ids[FFilter, y] = MonsterTemplate[x].data.Skin then
      begin
        // check for eps and such
        if MonsterTemplate[x].data.Skin = 65 then
        begin
          if (pos('ep4', lowercase(MonsterTemplate[x].name)) > 0) and (Floor[sfloor].floorid > 35) then
            form9.ComboBox1.Items.Add(MonsterTemplate[x].name);
          if (pos('ep4', lowercase(MonsterTemplate[x].name)) = 0) and (Floor[sfloor].floorid < 36) then
            form9.ComboBox1.Items.Add(MonsterTemplate[x].name);
        end
        else if MonsterTemplate[x].data.Skin = 97 then
        begin // test if del or normal
          if (pos('cca', lowercase(MonsterTemplate[x].name)) > 0) and (Floor[sfloor].floorid = 35) then
            form9.ComboBox1.Items.Add(MonsterTemplate[x].name);
          if (pos('cca', lowercase(MonsterTemplate[x].name)) = 0) and (Floor[sfloor].floorid <> 35) then
            form9.ComboBox1.Items.Add(MonsterTemplate[x].name);
        end
        else if MonsterTemplate[x].data.Skin = 192 then
        begin // test if del or normal
          if (pos('ep2', lowercase(MonsterTemplate[x].name)) > 0) and (Floor[sfloor].floorid = 30) then
            form9.ComboBox1.Items.Add(MonsterTemplate[x].name);
          if (pos('ep2', lowercase(MonsterTemplate[x].name)) = 0) and (Floor[sfloor].floorid = 11) then
            form9.ComboBox1.Items.Add(MonsterTemplate[x].name);
        end
        else if MonsterTemplate[x].data.Skin = 224 then
        begin // test if del or normal
          if (pos('cca', lowercase(MonsterTemplate[x].name)) > 0) and (Floor[sfloor].floorid = 35) then
            form9.ComboBox1.Items.Add(MonsterTemplate[x].name);
          if (pos('cca', lowercase(MonsterTemplate[x].name)) = 0) and (Floor[sfloor].floorid <> 35) then
            form9.ComboBox1.Items.Add(MonsterTemplate[x].name);
        end
        else
          form9.ComboBox1.Items.Add(MonsterTemplate[x].name);
        break;
      end;
  form9.tag := 0;
  form9.ComboBox1.ItemIndex := 0;
  form9.ComboBox1Change(form9);
  form9.ShowModal;
  if (form9.ComboBox1.ItemIndex > -1) and (form9.tag = 1) then
  begin
    Copylastmonster1.Enabled := true;
    inc(Floor[sfloor].MonsterCount);
    for x := 0 to presetm - 1 do
      if MonsterTemplate[x].name = form9.ComboBox1.Text then
        break;
    for y := 0 to sizeof(TMonster) - 1 do
      pansichar(@Floor[sfloor].Monster[Floor[sfloor].MonsterCount - 1])[y] := pansichar(@MonsterTemplate[x].data)[y];
    Floor[sfloor].Monster[Floor[sfloor].MonsterCount - 1].Unknow5 := form9.SpinEdit1.value;
    Floor[sfloor].Monster[Floor[sfloor].MonsterCount - 1].unknow6 := form9.SpinEdit1.value;
    Floor[sfloor].Monster[Floor[sfloor].MonsterCount - 1].unknow3 := MapFloorId[Floor[sfloor].floorid];

    SetMonsterDefaults();
    ShowIndicator();
    MoveSel := Floor[sfloor].MonsterCount - 1;
    MoveType := 1;
    firstdrop := true;
    if have3d then
      ListBox1.Items.Add('#' + inttostr(MoveSel) + ' - ' + GenerateMonsterName(Floor[sfloor].Monster[MoveSel],
        MoveSel, 1))
    else
      ListBox1.Items.Add('#' + inttostr(MoveSel) + ' - ' + GenerateMonsterName(Floor[sfloor].Monster[MoveSel],
        MoveSel, 0));
    DrawMap;
    ctrldw := true;
    isedited := true;
  end;
end;

procedure TForm1.Byroom1Click(Sender: TObject);
var
  x, i, v: integer;
  m: array [0 .. 1000] of TMonster;
begin
  // sort
  i := 0;
  v := 0;
  // for x:=0 to Floor[sfloor].MonsterCount-1 do if v < Floor[sfloor].Monster[x].map_section
  while i < Floor[sfloor].MonsterCount do
  begin
    for x := 0 to Floor[sfloor].MonsterCount - 1 do
      if Floor[sfloor].Monster[x].map_section = v then
      begin
        move(Floor[sfloor].Monster[x], m[i], sizeof(TMonster));
        inc(i);
      end;
    inc(v);
  end;
  move(m[0], Floor[sfloor].Monster[0], sizeof(TMonster) * Floor[sfloor].MonsterCount);
  CheckListBox1Click(Form1);
end;

procedure TForm1.byRoom2Click(Sender: TObject);
var
  x, i, v: integer;
  m: array [0 .. 1000] of TObj;
begin
  // sort
  i := 0;
  v := 0;
  // for x:=0 to Floor[sfloor].MonsterCount-1 do if v < Floor[sfloor].Monster[x].map_section
  while i < Floor[sfloor].ObjCount do
  begin
    for x := 0 to Floor[sfloor].ObjCount - 1 do
      if Floor[sfloor].Obj[x].map_section = v then
      begin
        move(Floor[sfloor].Obj[x], m[i], sizeof(TObj));
        inc(i);
      end;
    inc(v);
  end;
  move(m[0], Floor[sfloor].Obj[0], sizeof(TObj) * Floor[sfloor].ObjCount);
  CheckListBox1Click(Form1);
end;

procedure TForm1.byType1Click(Sender: TObject);
var
  x, i, v: integer;
  m: array [0 .. 1000] of TMonster;
begin
  // sort
  i := 0;
  v := 0;
  // for x:=0 to Floor[sfloor].MonsterCount-1 do if v < Floor[sfloor].Monster[x].map_section
  while i < Floor[sfloor].MonsterCount do
  begin
    for x := 0 to Floor[sfloor].MonsterCount - 1 do
      if Floor[sfloor].Monster[x].Skin = v then
      begin
        move(Floor[sfloor].Monster[x], m[i], sizeof(TMonster));
        inc(i);
      end;
    inc(v);
  end;
  move(m[0], Floor[sfloor].Monster[0], sizeof(TMonster) * Floor[sfloor].MonsterCount);
  CheckListBox1Click(Form1);
end;

procedure TForm1.byType2Click(Sender: TObject);
var
  x, i, v: integer;
  m: array [0 .. 1000] of TObj;
begin
  // sort
  i := 0;
  v := 0;
  // for x:=0 to Floor[sfloor].MonsterCount-1 do if v < Floor[sfloor].Monster[x].map_section
  while i < Floor[sfloor].ObjCount do
  begin
    for x := 0 to Floor[sfloor].ObjCount - 1 do
      if Floor[sfloor].Obj[x].Skin = v then
      begin
        move(Floor[sfloor].Obj[x], m[i], sizeof(TObj));
        inc(i);
      end;
    inc(v);
  end;
  move(m[0], Floor[sfloor].Obj[0], sizeof(TObj) * Floor[sfloor].ObjCount);
  CheckListBox1Click(Form1);
end;

procedure TForm1.byWave1Click(Sender: TObject);
var
  x, i, v: integer;
  m: array [0 .. 1000] of TMonster;
begin
  // sort
  i := 0;
  v := 0;
  // for x:=0 to Floor[sfloor].MonsterCount-1 do if v < Floor[sfloor].Monster[x].map_section
  while i < Floor[sfloor].MonsterCount do
  begin
    for x := 0 to Floor[sfloor].MonsterCount - 1 do
      if Floor[sfloor].Monster[x].Unknow5 = v then
      begin
        move(Floor[sfloor].Monster[x], m[i], sizeof(TMonster));
        inc(i);
      end;
    inc(v);
  end;
  move(m[0], Floor[sfloor].Monster[0], sizeof(TMonster) * Floor[sfloor].MonsterCount);
  CheckListBox1Click(Form1);
end;

procedure TForm1.Image2Click(Sender: TObject);
var
  x, d, pz, i, z, y, j, l, diff, diffmin, closest: integer;
  px, py, px2, py2, di, pz2: double;
begin
  if MoveSel > -1 then
  begin
    snapvalue := FPlacementOptions.seSnapTolerance.Value;
    HideIndicator();
    // find the nearest zone
    // extract the real px, py
    SetUndow;
    if ctrldw then
    begin
      if MoveType = 1 then
      begin
        inc(Floor[sfloor].MonsterCount);
        if have3d then
        begin
          Form1.Listbox1.Items.Strings[MoveSel]:='#'+inttostr(MoveSel)+' - ' + GenerateMonsterName(Floor[sfloor].Monster[MoveSel],MoveSel,2); // Refresh monster name
          setlength(MyMonst, Floor[sfloor].MonsterCount);
          MyMonstCount := Floor[sfloor].MonsterCount;
          MyMonst[Floor[sfloor].MonsterCount - 1] := t3ditem.Create(myscreen);
        end
        else Form1.Listbox1.Items.Strings[MoveSel]:='#'+inttostr(MoveSel)+' - ' + GenerateMonsterName(Floor[sfloor].Monster[MoveSel],MoveSel,0);
        for x := 0 to sizeof(TMonster) - 1 do
          pansichar(@Floor[sfloor].Monster[Floor[sfloor].MonsterCount - 1])[x] :=
            pansichar(@Floor[sfloor].Monster[MoveSel])[x];
        ShowIndicator();
        MoveSel := Floor[sfloor].MonsterCount - 1;
      end;
      if MoveType = 2 then
      begin
        inc(Floor[sfloor].ObjCount);
        if have3d then
        begin
          setlength(MyObj, Floor[sfloor].ObjCount);
          MyObjCount := Floor[sfloor].ObjCount;
          MyObj[Floor[sfloor].ObjCount - 1] := nil;
        end;
        Form1.ListBox2.Items.Strings[MoveSel]:='#'+inttostr(MoveSel)+' - ' + GetObjName(Floor[sfloor].Obj[MoveSel].skin); // Refresh object name
        for x := 0 to sizeof(TObj) - 1 do
          pansichar(@Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1])[x] := pansichar(@Floor[sfloor].Obj[MoveSel])[x];
        ShowIndicator();
        MoveSel := Floor[sfloor].ObjCount - 1;
      end;
    end;
    px := mpx;
    px := px / Zoom;
    px := mpcx - mmx - px;
    py := mpy;
    py := py / Zoom;
    py := mpcy - mmy - py;

    // py:=py+116+midp[Floor[sfloor].Monster[x].map_section].y+px2;
    if shiftdw then
    begin
      if MoveType = 1 then
        d := Floor[sfloor].Monster[MoveSel].map_section;
      if MoveType = 2 then
        d := Floor[sfloor].Obj[MoveSel].map_section;
    end
    else
    begin
      // find the nearest section
      d := -1;
      di := $FFFFFF;
      for x := 0 to 25566 do
        if MidPU[x] then
        begin
          // find the distance
          px2 := px - MidP[x].x;
          py2 := py - MidP[x].y;
          px2 := (px2 * px2) + (py2 * py2);
          // record it if nearest
          if di > px2 then
          begin
            di := px2;
            d := x;
          end;
        end;

      if Form1.ComboBox1.ItemIndex > 0 then
        d := strtoint(Form1.ComboBox1.Items.Strings[Form1.ComboBox1.ItemIndex]);

    end;

    // section found save the data to the object/monster
    pz2 := YFromBBRELFile(px * Zoom, py * Zoom);
    pz2 := pz2 - miz[d];

    px2 := px - MidP[d].x;
    py2 := py - MidP[d].y;

    px := cos(rev[d] / 10430.37835) * px2 - sin(rev[d] / 10430.37835) * py2;
    py := sin(rev[d] / 10430.37835) * px2 + cos(rev[d] / 10430.37835) * py2;

    px := px * Zoom;
    py := py * Zoom;
    // pz:=$0;

    diffmin := High(integer);
    closest := -1;

    if MoveType = 1 then
    begin
      Floor[sfloor].Monster[MoveSel].map_section := d;
      Floor[sfloor].Monster[MoveSel].Pos_X := px;
      Floor[sfloor].Monster[MoveSel].Pos_Y := py;

      if (smSnap.Checked) or (sdown) then // S key
      begin
        // X axis snap for monsters
        for j := 0 to Floor[sfloor].MonsterCount - 1 do
        begin
          for i := 0 to snapvalue do
          begin
              // Make sure both are visible and sections are the same
              if (Floor[sfloor].Monster[j].map_section = Floor[sfloor].Monster[MoveSel].map_section) and
              ((Floor[sfloor].Monster[j].Unknow5 = showwave) or (showwave = -1)) then
              begin
                if ((round(Floor[sfloor].Monster[j].Pos_X + i)) = round(px))
                or ((round(Floor[sfloor].Monster[j].Pos_X - i)) = round(px)) then
                begin
                  Floor[sfloor].Monster[MoveSel].Pos_X := Floor[sfloor].Monster[j].Pos_X;
                  // Match monster's rotations if enabled
                  if FPlacementOptions.chkSnapRotate.Checked then
                    Floor[sfloor].Monster[MoveSel].Direction := Floor[sfloor].Monster[j].Direction;
                  // Save closest snap target
                  diff := abs(round(Floor[sfloor].Monster[MoveSel].Pos_Y - Floor[sfloor].Monster[j].Pos_Y));
                  if diff < diffmin then
                  begin
                    diffmin := diff;
                    if j <> MoveSel then
                      closest := j;
                  end;
                end;
              end;
          end;
        end;
        if closest > -1 then
          AdjustDistanceY(closest);

        diffmin := High(integer);
        closest := -1;

        // Z axis snap for monsters
        for j := 0 to Floor[sfloor].MonsterCount - 1 do
        begin
          for i := 0 to snapvalue do
          begin
              // Make sure both are visible and sections are the same
              if (Floor[sfloor].Monster[j].map_section = Floor[sfloor].Monster[MoveSel].map_section) and
              ((Floor[sfloor].Monster[j].Unknow5 = showwave) or (showwave = -1)) then
              begin
                if ((round(Floor[sfloor].Monster[j].Pos_Y + i)) = round(py))
                or ((round(Floor[sfloor].Monster[j].Pos_Y - i)) = round(py)) then
                begin
                  Floor[sfloor].Monster[MoveSel].Pos_Y := Floor[sfloor].Monster[j].Pos_Y;
                  if FPlacementOptions.chkSnapRotate.Checked then
                    Floor[sfloor].Monster[MoveSel].Direction := Floor[sfloor].Monster[j].Direction;
                  // Save closest snap target
                  diff := abs(round(Floor[sfloor].Monster[MoveSel].Pos_X - Floor[sfloor].Monster[j].Pos_X));
                  if diff < diffmin then
                  begin
                    diffmin := diff;
                    if j <> MoveSel then
                      closest := j;
                  end;
                end;
              end;
          end;
        end;
        if closest > -1 then
          AdjustDistanceX(closest);
      end;

      // look around to find the best pz
      if not altdw or firstdrop then
        Floor[sfloor].Monster[MoveSel].Pos_Z := pz2;

      // Placement modifiers - overwrite values if keys are pressed
      if (Selected > -1) and (fdown) then // F key
      begin
        Floor[sfloor].Monster[MoveSel].map_section := Floor[sfloor].Monster[Selected].map_section;
        Floor[sfloor].Monster[MoveSel].Pos_X := Floor[sfloor].Monster[Selected].Pos_X + FPlacementOptions.nbOffsetX.Value;
        Floor[sfloor].Monster[MoveSel].Pos_Y := Floor[sfloor].Monster[Selected].Pos_Y + FPlacementOptions.nbOffsetZ.Value;
        Floor[sfloor].Monster[MoveSel].Pos_Z := Floor[sfloor].Monster[Selected].Pos_Z + FPlacementOptions.nbOffsetY.Value;
      end
      else if ddown then // D key
      begin
        Floor[sfloor].Monster[MoveSel].map_section := FPlacementOptions.seDefaultSect.Value;
        Floor[sfloor].Monster[MoveSel].Pos_X := FPlacementOptions.nbDefaultX.Value;
        Floor[sfloor].Monster[MoveSel].Pos_Y := FPlacementOptions.nbDefaultZ.Value;
        Floor[sfloor].Monster[MoveSel].Pos_Z := FPlacementOptions.nbDefaultY.Value;
      end;

      if have3d then
      begin
        GenerateMonsterName(Floor[sfloor].Monster[MoveSel], MoveSel, 2);
      end;
      ListBox1Click(Form1);
    end;
    if MoveType = 2 then
    begin
      Floor[sfloor].Obj[MoveSel].map_section := d;
      Floor[sfloor].Obj[MoveSel].Pos_X := px;
      Floor[sfloor].Obj[MoveSel].Pos_Y := py;

      if (smSnap.Checked) or (sdown) then // S key
      begin
        // X axis snap for objects
        for j := 0 to Floor[sfloor].ObjCount - 1 do
        begin
          for i := 0 to snapvalue do
          begin
              // Make sure both are visible and sections are the same
              if (Floor[sfloor].Obj[j].map_section = Floor[sfloor].Obj[MoveSel].map_section) and
              ((Floor[sfloor].Obj[j].Unknow5 = showwave) or (showwave = -1)) then
              begin
                if ((round(Floor[sfloor].Obj[j].Pos_X + i)) = round(px))
                or ((round(Floor[sfloor].Obj[j].Pos_X - i)) = round(px)) then
                begin
                  Floor[sfloor].Obj[MoveSel].Pos_X := Floor[sfloor].Obj[j].Pos_X;
                  // Match object's rotations if enabled
                  if FPlacementOptions.chkSnapRotate.Checked then
                    Floor[sfloor].Obj[MoveSel].unknow6 := Floor[sfloor].Obj[j].unknow6;
                  // Save closest snap target
                  diff := abs(round(Floor[sfloor].Obj[MoveSel].Pos_Y - Floor[sfloor].Obj[j].Pos_Y));
                  if diff < diffmin then
                  begin
                    diffmin := diff;
                    if j <> MoveSel then
                      closest := j;
                  end;
                end;
              end;
          end;
        end;
        if closest > -1 then
          AdjustDistanceY(closest);

        diffmin := High(integer);
        closest := -1;

        // Z axis snap for objects
        for j := 0 to Floor[sfloor].ObjCount - 1 do
        begin
          for i := 0 to snapvalue do
          begin
              // Make sure both are visible and sections are the same
              if (Floor[sfloor].Obj[j].map_section = Floor[sfloor].Obj[MoveSel].map_section) and
              ((Floor[sfloor].Obj[j].Unknow5 = showwave) or (showwave = -1)) then
              begin
                if ((round(Floor[sfloor].Obj[j].Pos_Y + i)) = round(py))
                or ((round(Floor[sfloor].Obj[j].Pos_Y - i)) = round(py)) then
                begin
                  Floor[sfloor].Obj[MoveSel].Pos_Y := Floor[sfloor].Obj[j].Pos_Y;
                  if FPlacementOptions.chkSnapRotate.Checked then
                    Floor[sfloor].Obj[MoveSel].unknow6 := Floor[sfloor].Obj[j].unknow6;
                  // Save closest snap target
                  diff := abs(round(Floor[sfloor].Obj[MoveSel].Pos_X - Floor[sfloor].Obj[j].Pos_X));
                  if diff < diffmin then
                  begin
                    diffmin := diff;
                    if j <> MoveSel then
                      closest := j;
                  end;
                end;
              end;
          end;
        end;
        if closest > -1 then
          AdjustDistanceX(closest);
      end;

      if not altdw or firstdrop then
        Floor[sfloor].Obj[MoveSel].Pos_Z := pz2;

      // Placement modifiers - overwrite values if keys are pressed
      if (Selected > -1) and (fdown) then // F key
      begin
        Floor[sfloor].Obj[MoveSel].map_section := Floor[sfloor].Obj[Selected].map_section;
        Floor[sfloor].Obj[MoveSel].Pos_X := Floor[sfloor].Obj[Selected].Pos_X + FPlacementOptions.nbOffsetX.Value;
        Floor[sfloor].Obj[MoveSel].Pos_Y := Floor[sfloor].Obj[Selected].Pos_Y + FPlacementOptions.nbOffsetZ.Value;
        Floor[sfloor].Obj[MoveSel].Pos_Z := Floor[sfloor].Obj[Selected].Pos_Z + FPlacementOptions.nbOffsetY.Value;
      end
      else if ddown then // D key
      begin
        Floor[sfloor].Obj[MoveSel].map_section := FPlacementOptions.seDefaultSect.Value;
        Floor[sfloor].Obj[MoveSel].Pos_X := FPlacementOptions.nbDefaultX.Value;
        Floor[sfloor].Obj[MoveSel].Pos_Y := FPlacementOptions.nbDefaultZ.Value;
        Floor[sfloor].Obj[MoveSel].Pos_Z := FPlacementOptions.nbDefaultY.Value;
      end;

      if have3d then
      begin
        if MyObj[MoveSel] <> nil then
          MyObj[MoveSel].Free;
        MyObj[MoveSel] := nil;
        Generateobj(Floor[sfloor].Obj[MoveSel], MoveSel);
        // form1.listbox1.Items.Strings[selected]:=GenerateMonsterName(Floor[sfloor].Monster[selected],selected,2);
      end;
      ListBox2Click(Form1);
    end;
    HideIndicator();
    MoveSel := -1;
    firstdrop := false;
    if ctrldw then
    begin
      // Form1.CheckListBox1Click(form1);
      if MoveType = 1 then
      begin
        ShowIndicator();
        MoveSel := Floor[sfloor].MonsterCount - 1;
        ListBox1.Items.Add('#' + inttostr(MoveSel) + ' - ' + GenerateMonsterName(Floor[sfloor].Monster[Selected],
          Selected, 0));
        Selected := MoveSel;
      end;
      if MoveType = 2 then
      begin
        ShowIndicator();
        MoveSel := Floor[sfloor].ObjCount - 1;
        ListBox2.Items.Add('#' + inttostr(MoveSel) + ' - ' + GetObjName(Floor[sfloor].Obj[Selected].Skin));
        Selected := MoveSel;

      end;
      DrawMap;
    end;
    DrawMap;
  end
  else
  begin
    for x := 0 to Floor[sfloor].MonsterCount - 1 do
      if (Floor[sfloor].Monster[x].Unknow5 = showwave) or (showwave = -1) then
      begin
        // 395,233
        if extractfilename(mapfilenam) = 'map_boss03c.rel' then
        begin
          MidP[0].y := 0;
        end;
        px2 := Floor[sfloor].Monster[x].Pos_X / Zoom;
        py2 := Floor[sfloor].Monster[x].Pos_Y / Zoom;
        px := cos(-rev[Floor[sfloor].Monster[x].map_section] / 10430.37835) * px2 -
          sin(-rev[Floor[sfloor].Monster[x].map_section] / 10430.37835) * py2;
        py := sin(-rev[Floor[sfloor].Monster[x].map_section] / 10430.37835) * px2 +
          cos(-rev[Floor[sfloor].Monster[x].map_section] / 10430.37835) * py2;

        px2 := mpx;
        px2 := px2 / Zoom;
        px := px + mmx + MidP[Floor[sfloor].Monster[x].map_section].x + px2;
        px2 := mpy;
        px2 := px2 / Zoom;
        py := py + mmy + MidP[Floor[sfloor].Monster[x].map_section].y + px2;

        if (mpcx >= round(px) - round(6 / Zoom)) and (mpcx <= round(px) + round(6 / Zoom)) and
          (mpcy >= round(py) - round(6 / Zoom)) and (mpcy <= round(py) + round(6 / Zoom))
          and not smDrag.Checked then
        begin
          l := ListBox1.ItemIndex;
          ListBox1.ItemIndex := x;
          if have3d and shiftdown then
          begin
            ppx := midpz[Floor[sfloor].Monster[x].map_section].x;
            ppy := Floor[sfloor].Monster[x].Pos_Z + 15;
            ppz := -midpz[Floor[sfloor].Monster[x].map_section].y;
            vr := 0;
            vz := 0;
            myscreen.SetView(ppx, ppy, ppz, vr, vz);
          end;
          if gettickcount() - lastimgclick > 1000 then
            l := -1;
          if l = ListBox1.ItemIndex then
            Form1.ListBox1DblClick(Form1)
          else
            Form1.ListBox1Click(Form1);
        end;

      end;
    for x := 0 to Floor[sfloor].ObjCount - 1 do
      if (Floor[sfloor].Obj[x].grp = showgrp) or (showgrp = -1) then
      begin
        // 395,233
        if extractfilename(mapfilenam) = 'map_boss03c.rel' then
        begin
          MidP[0].y := 0;
        end;
        px2 := Floor[sfloor].Obj[x].Pos_X / Zoom;
        py2 := Floor[sfloor].Obj[x].Pos_Y / Zoom;
        px := cos(-rev[Floor[sfloor].Obj[x].map_section] / 10430.37835) * px2 -
          sin(-rev[Floor[sfloor].Obj[x].map_section] / 10430.37835) * py2;
        py := sin(-rev[Floor[sfloor].Obj[x].map_section] / 10430.37835) * px2 +
          cos(-rev[Floor[sfloor].Obj[x].map_section] / 10430.37835) * py2;

        px2 := mpx;
        px2 := px2 / Zoom;
        px := px + mmx + MidP[Floor[sfloor].Obj[x].map_section].x + px2;
        px2 := mpy;
        px2 := px2 / Zoom;
        py := py + mmy + MidP[Floor[sfloor].Obj[x].map_section].y + px2;

        if (mpcx >= round(px) - round(6 / Zoom)) and (mpcx <= round(px) + round(6 / Zoom)) and
          (mpcy >= round(py) - round(6 / Zoom)) and (mpcy <= round(py) + round(6 / Zoom))
          and not smDrag.Checked then
        begin
          l := ListBox2.ItemIndex;
          ListBox2.ItemIndex := x;
          if have3d and shiftdown then
          begin
            ppx := midpz[Floor[sfloor].Obj[x].map_section].x;
            ppy := Floor[sfloor].Obj[x].Pos_Z + 15;
            ppz := -midpz[Floor[sfloor].Obj[x].map_section].y;
            vr := 0;
            vz := 0;
            myscreen.SetView(ppx, ppy, ppz, vr, vz);
          end;
          if gettickcount() - lastimgclick > 1000 then
            l := -1;
          if l = ListBox2.ItemIndex then
            Form1.ListBox1DblClick(Form1)
          else
            Form1.ListBox2Click(Form1);
        end;
      end;
      if not smDrag.Checked then
        lastimgclick := gettickcount();
  end;
end;

procedure TForm1.Button10Click(Sender: TObject);
var
  x, y, z, i, m, u, v, c: integer;
  a, b: ansistring;
begin
  if CheckListBox1.ItemIndex > -1 then
  begin

    y := 16;
    move(Floor[CheckListBox1.ItemIndex].Unknow[8], c, 4);
    form8.Memo2.Clear;
    form8.ListBox1.Clear;
    for x := 1 to c do
    begin

      form8.Memo2.Lines.Add('#' + inttostr(Floor[CheckListBox1.ItemIndex].Unknow[y] +
        (Floor[CheckListBox1.ItemIndex].Unknow[y + 1] * 256)));
      form8.ListBox1.Items.Add('#' + inttostr(Floor[CheckListBox1.ItemIndex].Unknow[y] +
        (Floor[CheckListBox1.ItemIndex].Unknow[y + 1] * 256)));
      form8.Memo2.Lines.Add('    Section: ' + inttostr(Floor[CheckListBox1.ItemIndex].Unknow[y + 8] +
        (Floor[CheckListBox1.ItemIndex].Unknow[y + 9] * 256)));
      form8.Memo2.Lines.Add('    Wave: ' + inttostr(Floor[CheckListBox1.ItemIndex].Unknow[y + 10] +
        (Floor[CheckListBox1.ItemIndex].Unknow[y + 11] * 256)));
      form8.Memo2.Lines.Add('    Delay: ' + inttostr(Floor[CheckListBox1.ItemIndex].Unknow[y + 12] +
        (Floor[CheckListBox1.ItemIndex].Unknow[y + 13] * 256)));

      if Floor[CheckListBox1.ItemIndex].Unknow[15] = $32 then
      begin
        z := Floor[CheckListBox1.ItemIndex].Unknow[y + 20] + (Floor[CheckListBox1.ItemIndex].Unknow[y + 21] * 256);
        z := z + (Floor[CheckListBox1.ItemIndex].Unknow[0] + (Floor[CheckListBox1.ItemIndex].Unknow[1] * 256));
        form8.Memo2.Lines.Add('    wavesetting: ' + inttostr(Floor[CheckListBox1.ItemIndex].Unknow[y + 16]) + ' ' +
          inttostr(Floor[CheckListBox1.ItemIndex].Unknow[y + 17]) + ' ' +
          inttostr(Floor[CheckListBox1.ItemIndex].Unknow[y + 18]) + ' ' +
          inttostr(Floor[CheckListBox1.ItemIndex].Unknow[y + 19]));
        inc(y, 24);
      end
      else
      begin
        z := Floor[CheckListBox1.ItemIndex].Unknow[y + 16] + (Floor[CheckListBox1.ItemIndex].Unknow[y + 17] * 256);
        z := z + (Floor[CheckListBox1.ItemIndex].Unknow[0] + (Floor[CheckListBox1.ItemIndex].Unknow[1] * 256));
        inc(y, 20);
      end;
      form8.Memo2.Lines.Add('');

      while Floor[CheckListBox1.ItemIndex].Unknow[z] <> 1 do
      begin
        u := 0;
        m := 0;
        if Floor[CheckListBox1.ItemIndex].Unknow[z] = $C then
        begin
          move(Floor[CheckListBox1.ItemIndex].Unknow[z + 1], m, 4);
          form8.Memo2.Lines.Add('    Call ' + inttostr(m));
          inc(z, 5);
        end
        else if Floor[CheckListBox1.ItemIndex].Unknow[z] = $A then
        begin
          move(Floor[CheckListBox1.ItemIndex].Unknow[z + 1], m, 2);
          form8.Memo2.Lines.Add('    Unlock ' + inttostr(m));
          inc(z, 3);
        end
        else if Floor[CheckListBox1.ItemIndex].Unknow[z] = $B then
        begin
          move(Floor[CheckListBox1.ItemIndex].Unknow[z + 1], m, 2);
          form8.Memo2.Lines.Add('    Lock ' + inttostr(m));
          inc(z, 3);
        end
        else if Floor[CheckListBox1.ItemIndex].Unknow[z] = $8 then
        begin
          move(Floor[CheckListBox1.ItemIndex].Unknow[z + 1], m, 2);
          move(Floor[CheckListBox1.ItemIndex].Unknow[z + 3], u, 2);
          form8.Memo2.Lines.Add('    Unhide ' + inttostr(m) + ' ' + inttostr(u));
          inc(z, 5);
        end;
      end;
      form8.Memo2.Lines.Add('');
      form8.Memo2.Lines.Add('');

      {
        01 = end
        0c xx xx xx xx = next event
        0a xx xx = unlock door
        0b xx xx = lock door
        08 xx xx yy yy = unhide item
      }
    end;

    // form8.Label2.Caption:=inttostr(floor[checklistbox1.ItemIndex].Unknow[8]);

    form8.ShowModal;
  end;

end;

procedure TForm1.Episode11Click(Sender: TObject);
var
  x: integer;
begin
  if isedited then
  begin
    if MessageDlg(GetLanguageString(79), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      Form1.Save1Click(Form1);
      if isedited then
        exit;
    end;
  end;
  ClearShadow;
  FFilter := 1;
  FullQuestFile := '';
  isedited := false;
  undocount := 0;
  Button11.Enabled := false;
  smUndo.Enabled := false;
  TrFnc.DeleteChildren;
  TrData.DeleteChildren;
  TrReg.DeleteChildren;
  Tropc.DeleteChildren;
  TsData.Clear;
  TsFnc.Clear;
  TsReg.Clear;
  Tsopc.Clear;
  for x := 0 to 30 do
  begin
    Floor[x].MonsterCount := 0;
    Floor[x].ObjCount := 0;
    Floor[x].UnknowCount := 0;
    CheckListBox1.Checked[x] := false;
    CheckListBox1.Items.Strings[x] := '';
  end;
  form4.ListBox1.Items.Clear;
  form4.ListBox1.Items.Add('0:      ret ');
  for x := 0 to 17 do
  begin
    Floor[x].MonsterCount := 0;
    Floor[x].ObjCount := 0;
    Floor[x].UnknowCount := 0;
    CheckListBox1.Checked[x] := false;
    CheckListBox1.Items.Strings[x] := mapname[mapid[x + EPMap[0]]];
    mapfile[x] := path + 'map\' + mapfilename[mapid[x + EPMap[0]]];
    mapxvmfile[x] := path + 'map\xvm\' + mapxvmname[mapid[x + EPMap[0]]];
    Floor[x].floorid := maparea[mapid[x + EPMap[0]]];
  end;
  curepi := 0;

end;

procedure TForm1.Episode21Click(Sender: TObject);
var
  x: integer;
begin
  if isedited then
  begin
    if MessageDlg(GetLanguageString(79), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      Form1.Save1Click(Form1);
      if isedited then
        exit;
    end;
  end;
  ClearShadow;
  FFilter := 2;
  FullQuestFile := '';
  isedited := false;
  undocount := 0;
  Button11.Enabled := false;
  smUndo.Enabled := false;
  TrFnc.DeleteChildren;
  TrData.DeleteChildren;
  TrReg.DeleteChildren;
  Tropc.DeleteChildren;
  TsData.Clear;
  TsFnc.Clear;
  TsReg.Clear;
  Tsopc.Clear;
  for x := 0 to 30 do
  begin
    Floor[x].MonsterCount := 0;
    Floor[x].ObjCount := 0;
    Floor[x].UnknowCount := 0;
    CheckListBox1.Checked[x] := false;
    CheckListBox1.Items.Strings[x] := '';
  end;
  form4.ListBox1.Items.Clear;
  form4.ListBox1.Items.Add('0:      ' + getopcodename($F8BC) + ' 00000001');
  form4.ListBox1.Items.Add('        ret ');
  for x := 0 to 17 do
  begin
    Floor[x].MonsterCount := 0;
    Floor[x].ObjCount := 0;
    Floor[x].UnknowCount := 0;
    CheckListBox1.Checked[x] := false;
    CheckListBox1.Items.Strings[x] := mapname[mapid[x + EPMap[1]]];
    mapfile[x] := path + 'map\' + mapfilename[mapid[x + EPMap[1]]];
    mapxvmfile[x] := path + 'map\xvm\' + mapxvmname[mapid[x + EPMap[1]]];
    Floor[x].floorid := maparea[mapid[x + EPMap[1]]];
  end;
  curepi := 1;
end;

procedure TForm1.Episode41Click(Sender: TObject);
var
  x: integer;
begin
  if isedited then
  begin
    if MessageDlg(GetLanguageString(79), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      Form1.Save1Click(Form1);
      if isedited then
        exit;
    end;
  end;
  ClearShadow;
  FFilter := 3;
  FullQuestFile := '';
  isedited := false;
  undocount := 0;
  Button11.Enabled := false;
  smUndo.Enabled := false;
  TrFnc.DeleteChildren;
  TrData.DeleteChildren;
  TrReg.DeleteChildren;
  Tropc.DeleteChildren;
  TsData.Clear;
  TsFnc.Clear;
  TsReg.Clear;
  Tsopc.Clear;
  for x := 0 to 30 do
  begin
    Floor[x].MonsterCount := 0;
    Floor[x].ObjCount := 0;
    Floor[x].UnknowCount := 0;
    CheckListBox1.Checked[x] := false;
    CheckListBox1.Items.Strings[x] := '';
  end;
  form4.ListBox1.Items.Clear;
  form4.ListBox1.Items.Add('0:      ' + getopcodename($F8BC) + ' 00000002');
  form4.ListBox1.Items.Add('        ret ');
  x := 10;
  Floor[0].MonsterCount := 0;
  Floor[0].ObjCount := 0;
  Floor[0].UnknowCount := 0;
  CheckListBox1.Checked[0] := false;
  CheckListBox1.Items.Strings[0] := mapname[mapid[x + EPMap[2]]];
  mapfile[0] := path + 'map\' + mapfilename[mapid[x + EPMap[2]]];
  Floor[0].floorid := maparea[mapid[x + EPMap[2]]];
  mapxvmfile[0] := path + 'map\xvm\' + mapxvmname[mapid[x + EPMap[2]]];
  for x := 0 to 8 do
  begin
    Floor[x + 1].MonsterCount := 0;
    Floor[x + 1].ObjCount := 0;
    Floor[x + 1].UnknowCount := 0;
    CheckListBox1.Checked[x + 1] := false;
    CheckListBox1.Items.Strings[x + 1] := mapname[mapid[x + EPMap[2]]];
    mapfile[x + 1] := path + 'map\' + mapfilename[mapid[x + EPMap[2]]];
    mapxvmfile[x + 1] := path + 'map\xvm\' + mapxvmname[mapid[x + EPMap[2]]];
    Floor[x + 1].floorid := maparea[mapid[x + EPMap[2]]];
  end;
  curepi := 2;
end;

procedure TForm1.Button11Click(Sender: TObject);
var
  x: integer;
begin
  if undocount = 0 then
    exit;
  dec(undocount);
  if undocount = 0 then
  begin
    Button11.Enabled := false;
    smUndo.Enabled := false;
  end;
  isedited := true;
  move(FloorUn[undocount], Floor[0], sizeof(TFloor) * 40);
  ctrldw := true;
  Form1.CheckListBox1Click(Form1);
  ctrldw := false;
end;

procedure TForm1.SetUndow();
var
  x: integer;
begin
  Button11.Enabled := true;
  smUndo.Enabled := true;
  if undocount = 20 then
  begin
    dec(undocount);
    move(FloorUn[1], FloorUn[0], sizeof(TFloor) * 40 * 19);
  end;
  move(Floor[0], FloorUn[undocount], sizeof(TFloor) * 40);
  inc(undocount);
  // Form1.CheckListBox1Click(form1);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  HideIndicator();
  MoveSel := -1;
  if Selected > -1 then
  begin
    ShowIndicator();
    MoveSel := Selected;
    MoveType := stype;
    isedited := true;
  end;
end;

procedure TForm1.ConvertBINDATtooffline1Click(Sender: TObject);
var
  di, da, db: pchar;
  fn, b, name, mh: ansistring;
  f, F1, F2, bl, dl, s1, s2, z, y: integer;
  txt: array [0 .. 10] of ansichar;
  tmp: array [0 .. $400] of ansichar;
begin
  if OpenDialog2.Execute then
    if SaveDialog2.Execute then
    begin
      fn := OpenDialog2.filename;
      // isedited:=true;
      // get size
      f := fileopen(fn, $40);
      fileseek(f, $14, 0);
      fileread(f, tmp, 20);
      name := pansichar(@tmp[0]);
      bl := fileseek(f, 0, 2);
      fileclose(f);
      f := fileopen(copy(fn, 1, length(fn) - 3) + 'dat', $40);
      dl := fileseek(f, 0, 2);
      fileclose(f);
      di := stralloc(1024);
      da := stralloc(1024);
      db := stralloc(1024);
      strpcopy(db, path + 'compress.exe');
      deletefile('c:\tmp2.binb');
      deletefile('c:\tmp2.datb');
      strpcopy(di, extractfilepath(application.ExeName));
      strpcopy(da, '"' + copy(fn, 1, length(fn) - 3) + 'dat" c:\tmp2.datb');
      ShellExecute(0, 'open', db, da, di, SW_minimize);
      strpcopy(da, '"' + fn + '" c:\tmp2.binb');
      ShellExecute(0, 'open', db, da, di, SW_minimize);

      f := -1;
      while f = -1 do
        f := fileopen('c:\tmp2.binb', $12);
      fileclose(f);
      f := -1;
      while f = -1 do
        f := fileopen('c:\tmp2.datb', $12);
      fileclose(f);

      // file is compressed

      // rename file
      deletefile('c:\tmp2.benc');
      deletefile('c:\tmp2.denc');
      RenameFile('c:\tmp2.binb', 'c:\tmp2.benc');
      RenameFile('c:\tmp2.datb', 'c:\tmp2.denc');
      // encrypt , add the header
      F1 := fileopen('c:\tmp2.benc', $40);
      f := fileread(F1, txt, 1);
      b := '';
      while f = 1 do
      begin
        b := b + txt[0];
        f := fileread(F1, txt, 1);
      end;
      fileclose(F1);
      while (length(b) div 4) * 4 <> length(b) do
        b := b + #0;
      f := random($7FFFFFFF);
      CreateKey(f, 0);
      b := PSOEnc(b, 0, 0);
      b := ansichar(bl) + ansichar(bl div 256) + ansichar(bl div $10000) + #0 + pansichar(@f)[0] + pansichar(@f)[1] +
        pansichar(@f)[2] + pansichar(@f)[3] + b;
      F1 := filecreate('c:\tmp2.binb', $40);
      filewrite(F1, b[1], length(b));
      fileclose(F1);

      F1 := fileopen('c:\tmp2.denc', $40);
      f := fileread(F1, txt, 1);
      b := '';
      while f = 1 do
      begin
        b := b + txt[0];
        f := fileread(F1, txt, 1);
      end;
      fileclose(F1);
      while (length(b) div 4) * 4 <> length(b) do
        b := b + #0;
      f := random($7FFFFFFF);
      CreateKey(f, 0);
      b := PSOEnc(b, 0, 0);
      b := ansichar(dl) + ansichar(dl div 256) + ansichar(dl div $10000) + #0 + pansichar(@f)[0] + pansichar(@f)[1] +
        pansichar(@f)[2] + pansichar(@f)[3] + b;
      F1 := filecreate('c:\tmp2.datb', $40);
      filewrite(F1, b[1], length(b));
      fileclose(F1);

      fn := 'c:\tmp2.bin';

      if SaveDialog2.FilterIndex = 1 then
      begin
        F2 := fileopen(fn + 'b', $40);
        F1 := fileopen(copy(fn, 1, length(fn) - 3) + 'datb', $40);
        s2 := fileseek(F1, 0, 2);
        fileseek(F1, 0, 0);
        s1 := fileseek(F2, 0, 2);
        fileseek(F2, 0, 0);
        // make the data for server
        b := #$3c#0#$a6#2#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0 + #0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0 + 'quest3.dat' +
          #0#0#0#0#0#0 + ansichar(s2) + ansichar(s2 div 256) + ansichar(s2 div $10000) + #0;
        f := filecreate(SaveDialog2.filename);
        filewrite(f, b[1], $3C);
        b := #$3c#0#$a6#2#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0 + #0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0 + 'quest3.bin' +
          #0#0#0#0#0#0 + ansichar(s1) + ansichar(s1 div 256) + ansichar(s1 div $10000) + #0;
        filewrite(f, b[1], $3C);
        z := 0;
        while s2 + s1 > 0 do
        begin
          if s2 > 0 then
          begin
            b := #$18#4#$a7 + ansichar(z) + 'quest3.dat' + #0#0#0#0#0#0;
            filewrite(f, b[1], 20);
            fillchar(tmp, $400, 0);
            y := fileread(F1, tmp, $400);
            filewrite(f, tmp, $400);
            filewrite(f, y, 4);
            s2 := s2 - y;
            y := 0;
          end;
          if s1 > 0 then
          begin
            b := #$18#4#$a7 + ansichar(z) + 'quest3.bin' + #0#0#0#0#0#0;
            filewrite(f, b[1], 20);
            fillchar(tmp, $400, 0);
            y := fileread(F2, tmp, $400);
            filewrite(f, tmp, $400);
            filewrite(f, y, 4);
            s1 := s1 - y;
            y := 0;
          end;
          inc(z);
        end;
        fileclose(f);
        fileclose(F1);
        fileclose(F2);
      end;
      if SaveDialog2.FilterIndex > 1 then
      begin
        F2 := fileopen(fn + 'b', $40);
        F1 := fileopen(copy(fn, 1, length(fn) - 3) + 'datb', $40);
        s2 := fileseek(F1, 0, 2);
        fileseek(F1, 0, 0);
        s1 := fileseek(F2, 0, 2);
        fileseek(F2, 0, 0);
        if (SaveDialog2.FilterIndex = 3) then
        begin
          b := #$a6#3#$3c#0'PSO/'#0#0#0#0#0#0#0#0#0#0#0#0 + #0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0 + 'quest3.dat' +
            #0#0#0#0#0#0 + ansichar(s2) + ansichar(s2 div 256) + ansichar(s2 div $10000) + #0;
          for z := 1 to length(name) do
            b[4 + z] := name[z];
          b[z + 5] := ':';
          b[z + 6] := '2';
          b[z + 7] := '-';
          b[z + 8] := '1';
        end
        else
        begin
          b := #$a6#3#$3c#0'PSO/'#0#0#0#0#0#0#0#0#0#0#0#0 + #0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0 + 'quest3.dat' +
            #0#0#0#0#0#0#0 + ansichar(s2) + ansichar(s2 div 256) + ansichar(s2 div $10000) + #0;
          mh := unitochar(Title, 32);
          for z := 1 to length(mh) do
            b[8 + z] := mh[z];
        end;
        f := filecreate(SaveDialog2.filename);
        filewrite(f, b[1], $3C);

        if (SaveDialog2.FilterIndex = 3) then
        begin
          b := #$a6#3#$3c#0'PSO/'#0#0#0#0#0#0#0#0#0#0#0#0#0 + #0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0 + 'quest3.bin' +
            #0#0#0#0#0#0 + ansichar(s1) + ansichar(s1 div 256) + ansichar(s1 div $10000) + #0;
          for z := 1 to length(name) do
            b[4 + z] := name[z];
          b[z + 5] := ':';
          b[z + 6] := '2';
          b[z + 7] := '-';
          b[z + 8] := '2';
        end
        else
        begin
          b := #$a6#3#$3c#0'PSO/'#0#0#0#0#0#0#0#0#0#0#0#0#0 + #0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0 + 'quest3.bin' +
            #0#0#0#0#0#0#0 + ansichar(s1) + ansichar(s1 div 256) + ansichar(s1 div $10000) + #0;
          mh := unitochar(Title, 32);
          for z := 1 to length(mh) do
            b[8 + z] := mh[z];
        end;
        filewrite(f, b[1], $3C);

        z := 0;

        while s2 + s1 > 0 do
        begin
          if s2 > 0 then
          begin
            b := #$a7 + ansichar(z) + #$18#4'quest3.dat' + #0#0#0#0#0#0;
            filewrite(f, b[1], 20);
            fillchar(tmp, $400, 0);
            y := fileread(F1, tmp, $400);
            filewrite(f, tmp, $400);
            filewrite(f, y, 4);
            s2 := s2 - y;
          end;
          if s1 > 0 then
          begin
            b := #$a7 + ansichar(z) + #$18#4'quest3.bin' + #0#0#0#0#0#0;
            filewrite(f, b[1], 20);
            fillchar(tmp, $400, 0);
            y := fileread(F2, tmp, $400);
            filewrite(f, tmp, $400);
            filewrite(f, y, 4);
            s1 := s1 - y;
          end;
          inc(z);
        end;
        fileclose(f);
        fileclose(F1);
        fileclose(F2);

      end;
    end;
end;

procedure TForm1.Fixbadidonitem1Click(Sender: TObject);
var
  x: integer;
begin
  form12.ListBox1.Clear;
  for x := 0 to qstfilecount - 1 do
  begin
    form12.ListBox1.Items.Add(qstfile[x].name + ' (' + inttostr(qstfile[x].size) + ' Bytes)');
  end;
  form12.Show;
end;

procedure TForm1.ConvertBINDATtoOnline1Click(Sender: TObject);
var
  di, da, db: pansichar;
  fn, b, name, mh: ansistring;
  f, F1, F2, bl, dl, s1, s2, z, y: integer;
  txt: array [0 .. 10] of ansichar;
  tmp: array [0 .. $400] of ansichar;
begin
  if OpenDialog2.Execute then
    if SaveDialog2.Execute then
    begin
      fn := OpenDialog2.filename;
      // get size

      // fn:='c:\tmp2.bin';
      name := 'Homebrew Quest';
      if SaveDialog2.FilterIndex = 4 then
      begin
        F2 := fileopen(fn, $40);
        F1 := fileopen(copy(fn, 1, length(fn) - 3) + 'dat', $40);
        s2 := fileseek(F1, 0, 2);
        fileseek(F1, 0, 0);
        s1 := fileseek(F2, 0, 2);
        fileseek(F2, 0, 0);
        // make the data for server
        b := #$58#0#$44#0#2#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0 + #0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1 +
          'quest3.dat' + #0#0#0#0#0#0 + ansichar(s2) + ansichar(s2 div 256) + ansichar(s2 div $10000) + #0 +
          'quest3_e.dat' + #0#0#0#0#0#0#0#0#0#0#0#0;
        f := filecreate(SaveDialog2.filename);
        filewrite(f, b[1], $58);
        b := #$58#0#$44#0#2#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0 + #0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#1 +
          'quest3.bin' + #0#0#0#0#0#0 + ansichar(s1) + ansichar(s1 div 256) + ansichar(s1 div $10000) + #0 +
          'quest3_e.dat' + #0#0#0#0#0#0#0#0#0#0#0#0;
        filewrite(f, b[1], $58);
        z := 0;
        while s2 + s1 > 0 do
        begin
          if s2 > 0 then
          begin
            b := #$1C#4#$13#0 + ansichar(z) + #0#0#0 + 'quest3.dat' + #0#0#0#0#0#0;
            filewrite(f, b[1], 24);
            fillchar(tmp, $400, 0);
            y := fileread(F1, tmp, $400);
            filewrite(f, tmp, $400);
            filewrite(f, y, 4);
            s2 := s2 - y;
            y := 0;
            filewrite(f, y, 4);
            y := 0;
          end;
          if s1 > 0 then
          begin
            b := #$1c#4#$13#0 + ansichar(z) + #0#0#0 + 'quest3.bin' + #0#0#0#0#0#0;
            filewrite(f, b[1], 24);
            fillchar(tmp, $400, 0);
            y := fileread(F2, tmp, $400);
            filewrite(f, tmp, $400);
            filewrite(f, y, 4);
            s1 := s1 - y;
            y := 0;
            filewrite(f, y, 4);
            y := 0;
          end;
          inc(z);
        end;
        fileclose(f);
        fileclose(F1);
        fileclose(F2);
      end
      else if SaveDialog2.FilterIndex = 1 then
      begin
        F2 := fileopen(fn, $40);
        F1 := fileopen(copy(fn, 1, length(fn) - 3) + 'dat', $40);
        s2 := fileseek(F1, 0, 2);
        fileseek(F1, 0, 0);
        s1 := fileseek(F2, 0, 2);
        fileseek(F2, 0, 0);
        // make the data for server
        b := #$3c#0#$44#2#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0 + #0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0 + 'quest3.dat' +
          #0#0#0#0#0#0 + ansichar(s2) + ansichar(s2 div 256) + ansichar(s2 div $10000) + #0;
        f := filecreate(SaveDialog2.filename);
        filewrite(f, b[1], $3C);
        b := #$3c#0#$44#2#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0 + #0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0 + 'quest3.bin' +
          #0#0#0#0#0#0 + ansichar(s1) + ansichar(s1 div 256) + ansichar(s1 div $10000) + #0;
        filewrite(f, b[1], $3C);
        z := 0;
        while s2 + s1 > 0 do
        begin
          if s2 > 0 then
          begin
            b := #$18#4#$13 + ansichar(z) + 'quest3.dat' + #0#0#0#0#0#0;
            filewrite(f, b[1], 20);
            fillchar(tmp, $400, 0);
            y := fileread(F1, tmp, $400);
            filewrite(f, tmp, $400);
            filewrite(f, y, 4);
            s2 := s2 - y;
            y := 0;
          end;
          if s1 > 0 then
          begin
            b := #$18#4#$13 + ansichar(z) + 'quest3.bin' + #0#0#0#0#0#0;
            filewrite(f, b[1], 20);
            fillchar(tmp, $400, 0);
            y := fileread(F2, tmp, $400);
            filewrite(f, tmp, $400);
            filewrite(f, y, 4);
            s1 := s1 - y;
            y := 0;
          end;
          inc(z);
        end;
        fileclose(f);
        fileclose(F1);
        fileclose(F2);
      end
      else if SaveDialog2.FilterIndex > 1 then
      begin
        F2 := fileopen(fn, $40);
        F1 := fileopen(copy(fn, 1, length(fn) - 3) + 'dat', $40);
        s2 := fileseek(F1, 0, 2);
        fileseek(F1, 0, 0);
        s1 := fileseek(F2, 0, 2);
        fileseek(F2, 0, 0);
        if (SaveDialog2.FilterIndex = 3) then
        begin
          b := #$44#3#$3c#0'PSO/'#0#0#0#0#0#0#0#0#0#0#0#0 + #0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0 + 'quest3.dat' +
            #0#0#0#0#0#0 + ansichar(s2) + ansichar(s2 div 256) + ansichar(s2 div $10000) + #0;
          for z := 1 to length(name) do
            b[4 + z] := name[z];
          b[z + 5] := ':';
          b[z + 6] := '2';
          b[z + 7] := '-';
          b[z + 8] := '1';
        end
        else
        begin
          b := #$44#3#$3c#0'PSO/'#0#0#0#0#0#0#0#0#0#0#0#0 + #0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0 + 'quest3.dat' +
            #0#0#0#0#0#0#0 + ansichar(s2) + ansichar(s2 div 256) + ansichar(s2 div $10000) + #0;
          mh := unitochar(Title, 32);
          for z := 1 to length(mh) do
            b[8 + z] := mh[z];
        end;
        f := filecreate(SaveDialog2.filename);
        filewrite(f, b[1], $3C);

        if (SaveDialog2.FilterIndex = 3) then
        begin
          b := #$44#3#$3c#0'PSO/'#0#0#0#0#0#0#0#0#0#0#0#0#0 + #0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0 + 'quest3.bin' +
            #0#0#0#0#0#0 + ansichar(s1) + ansichar(s1 div 256) + ansichar(s1 div $10000) + #0;
          for z := 1 to length(name) do
            b[4 + z] := name[z];
          b[z + 5] := ':';
          b[z + 6] := '2';
          b[z + 7] := '-';
          b[z + 8] := '2';
        end
        else
        begin
          b := #$44#3#$3c#0'PSO/'#0#0#0#0#0#0#0#0#0#0#0#0#0 + #0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0 + 'quest3.bin' +
            #0#0#0#0#0#0#0 + ansichar(s1) + ansichar(s1 div 256) + ansichar(s1 div $10000) + #0;
          mh := unitochar(Title, 32);
          for z := 1 to length(mh) do
            b[8 + z] := mh[z];
        end;
        filewrite(f, b[1], $3C);

        z := 0;

        while s2 + s1 > 0 do
        begin
          if s2 > 0 then
          begin
            b := #$13 + ansichar(z) + #$18#4'quest3.dat' + #0#0#0#0#0#0;
            filewrite(f, b[1], 20);
            fillchar(tmp, $400, 0);
            y := fileread(F1, tmp, $400);
            filewrite(f, tmp, $400);
            filewrite(f, y, 4);
            s2 := s2 - y;
          end;
          if s1 > 0 then
          begin
            b := #$13 + ansichar(z) + #$18#4'quest3.bin' + #0#0#0#0#0#0;
            filewrite(f, b[1], 20);
            fillchar(tmp, $400, 0);
            y := fileread(F2, tmp, $400);
            filewrite(f, tmp, $400);
            filewrite(f, y, 4);
            s1 := s1 - y;
          end;
          inc(z);
        end;
        fileclose(f);
        fileclose(F1);
        fileclose(F2);

      end;
    end;
end;

procedure TForm1.Information1Click(Sender: TObject);
begin
  form11.UnicodeMemo1.Text := Desc;
  form11.ShowModal;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  s: ansistring;
begin
  // MenueDrawItemX(form1.MainMenu1);
  have3d := false;
  s := dummy1 + dummy2 + dummy3 + dummy4 + dummy5 + dummy6 + dummy7 + dummy8;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 68 then
    ddown := true;
  if key = 70 then
    fdown := true;
  if key = 83 then
    sdown := true;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  ddown := false;
  fdown := false;
  sdown := false;
end;

procedure TForm1.DrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
begin
  MenueDrawItem(Sender, ACanvas, ARect, Selected);
end;

procedure TForm1.MenueDrawItemX(xMenu: TMenu);
var
  i: integer;
  b: TBitmap;
  FMenuItem: TMenuItem;
begin
  b := TBitmap.Create;
  b.Width := 1;
  b.height := 1;

  for i := 0 to ComponentCount - 1 do
    if Components[i] is TMenuItem then
    begin
      FMenuItem := TMenuItem(Components[i]);
      FMenuItem.OnDrawItem := DrawItem;
      if (FMenuItem.ImageIndex = -1) and (FMenuItem.Bitmap.Width = 0) and (xMenu <> nil) then
        if FMenuItem.GetParentComponent.name <> xMenu.name then
          FMenuItem.Bitmap.Assign(b);
    end;

  b.Free;
  DrawMenuBar(Handle);

end;

procedure TForm1.Monstercount1Click(Sender: TObject);
begin
  form31.ShowModal;
end;

procedure TForm1.Move1Click(Sender: TObject);
begin
  Button1Click(nil);
end;

procedure MenueDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
var
  txt: ansistring;
  b: TBitmap;

  IConRect, TextRect: TRect;
  FBackColor, FIconBackColor, FSelectedBkColor, FFontColor, FSelectedFontColor, FDisabledFontColor, FSeparatorColor,
    FCheckedColor: TColor;

  i, x1, x2: integer;
  TextFormat: integer;
  HasImgLstBitmap: Boolean;
  FMenuItem: TMenuItem;
  FMenu: TMenu;

begin
  FMenuItem := TMenuItem(Sender);
  FMenu := FMenuItem.Parent.GetParentMenu;

  FBackColor := $FFFFFF; // $00E1E1E1;
  FIconBackColor := $E9D1C9; // $00D1D1D1;
  FSelectedBkColor := $00DCCFC7;

  FFontColor := clblack;
  FSelectedFontColor := clNavy;
  FDisabledFontColor := clGray;
  FSeparatorColor := $E9D1C9; // $00D1D1D1;
  FCheckedColor := clGray;

  if FMenu.IsRightToLeft then
  begin
    x1 := ARect.Right - 20;
    x2 := ARect.Right;
  end
  else
  begin
    x1 := ARect.Left;
    x2 := ARect.Left + 20;
  end;
  IConRect := Rect(x1, ARect.Top, x2, ARect.Bottom);

  TextRect := ARect;
  txt := ' ' + FMenuItem.Caption;

  b := TBitmap.Create;

  b.Transparent := true;
  b.TransparentMode := tmAuto;

  HasImgLstBitmap := false;
  if (FMenuItem.Parent.GetParentMenu.Images <> nil) or (FMenuItem.Parent.SubMenuImages <> nil) then
  begin
    if FMenuItem.ImageIndex <> -1 then
      HasImgLstBitmap := true
    else
      HasImgLstBitmap := false;
  end;

  if HasImgLstBitmap then
  begin
    if FMenuItem.Parent.SubMenuImages <> nil then
      FMenuItem.Parent.SubMenuImages.GetBitmap(FMenuItem.ImageIndex, b)
    else
      FMenuItem.Parent.GetParentMenu.Images.GetBitmap(FMenuItem.ImageIndex, b)
  end
  else if FMenuItem.Bitmap.Width > 0 then
    b.Assign(TBitmap(FMenuItem.Bitmap));

  if FMenu.IsRightToLeft then
  begin
    x1 := ARect.Left;
    x2 := ARect.Right - 20;
  end
  else
  begin
    x1 := ARect.Left + 20;
    x2 := ARect.Right;
  end;
  TextRect := Rect(x1, ARect.Top, x2, ARect.Bottom);

  ACanvas.Brush.Color := FBackColor;
  ACanvas.FillRect(TextRect);

  if FMenu is TMainMenu then
    for i := 0 to FMenuItem.GetParentMenu.Items.count - 1 do
      if FMenuItem.GetParentMenu.Items[i] = FMenuItem then
      begin
        ACanvas.Brush.Color := FIconBackColor;
        ACanvas.FillRect(ARect);
        if (FMenuItem.ImageIndex = -1) and (FMenuItem.Bitmap.Width = 0) then
        begin
          TextRect := ARect;
          break;
        end;
      end;

  ACanvas.Brush.Color := FIconBackColor;
  ACanvas.FillRect(IConRect);

  if FMenuItem.Enabled then
    ACanvas.Font.Color := FFontColor
  else
    ACanvas.Font.Color := FDisabledFontColor;

  if Selected then
  begin
    ACanvas.Brush.Style := bssolid;
    ACanvas.Brush.Color := FSelectedBkColor;
    ACanvas.FillRect(TextRect);

    ACanvas.Pen.Color := FSelectedFontColor;

    ACanvas.Brush.Style := bsclear;
    ACanvas.RoundRect(TextRect.Left, TextRect.Top, TextRect.Right, TextRect.Bottom, 6, 6);

    if FMenuItem.Enabled then
      ACanvas.Font.Color := FSelectedFontColor;
  end;

  x1 := IConRect.Left + 2;
  if b <> nil then
    ACanvas.Draw(x1, IConRect.Top + 1, b);

  if FMenuItem.Checked then
  begin
    ACanvas.Pen.Color := FCheckedColor;
    ACanvas.Brush.Style := bsclear;
    ACanvas.RoundRect(IConRect.Left, IConRect.Top, IConRect.Right, IConRect.Bottom, 3, 3);
  end;

  if not FMenuItem.IsLine then
  begin
    SetBkMode(ACanvas.Handle, Transparent);

    ACanvas.Font.name := 'Tahoma';
    if FMenu.IsRightToLeft then
      ACanvas.Font.Charset := ARABIC_CHARSET;

    if FMenu.IsRightToLeft then
      TextFormat := DT_RIGHT + DT_RTLREADING
    else
      TextFormat := 0;

    if FMenuItem.Default then
    begin
      inc(TextRect.Left, 1);
      inc(TextRect.Right, 1);
      inc(TextRect.Top, 1);
      ACanvas.Font.Color := clGray;
      DrawtextEx(ACanvas.Handle, pchar(txt), length(txt), TextRect, TextFormat, nil);

      dec(TextRect.Left, 1);
      dec(TextRect.Right, 1);
      dec(TextRect.Top, 1);

      ACanvas.Font.Color := FFontColor;
    end;

    DrawtextEx(ACanvas.Handle, pchar(txt), length(txt), TextRect, TextFormat, nil);

    txt := ShortCutToText(FMenuItem.ShortCut) + ' ';

    if FMenu.IsRightToLeft then
      TextFormat := DT_LEFT
    else
      TextFormat := DT_RIGHT;

    DrawtextEx(ACanvas.Handle, pchar(txt), length(txt), TextRect, TextFormat, nil);
  end
  else
  begin
    ACanvas.Pen.Color := FSeparatorColor;
    ACanvas.MoveTo(ARect.Left + 10, TextRect.Top + round((TextRect.Bottom - TextRect.Top) / 2));
    ACanvas.lineto(ARect.Right - 2, TextRect.Top + round((TextRect.Bottom - TextRect.Top) / 2))
  end;

  b.Free;

end;

procedure TForm1.N3DView1Click(Sender: TObject);
var
  x, y: integer;
begin
  form14.Label1.Caption := GetLanguageString(80);
  form14.Show;
  if myscreen = nil then
  begin
    if form17.chkFullscreen.Checked then
    begin
      x := Screen.Width;
      y := Screen.Height;
      form13.ClientWidth := Screen.Width;
      form13.ClientHeight := Screen.Height;
      form13.BorderStyle := bsNone;
      form13.Position := poDefault;
    end
    else
    begin
      x := 320;
      y := 240;
      if form17.ComboBox1.ItemIndex = 1 then
      begin
        x := 640;
        y := 480;
      end;
      if form17.ComboBox1.ItemIndex = 2 then
      begin
        x := 800;
        y := 600;
      end;
      if form17.ComboBox1.ItemIndex = 3 then
      begin
        x := 1024;
        y := 768;
      end;
      if form17.ComboBox1.ItemIndex = 4 then
      begin
        x := 1600;
        y := 900;
      end;
      if form17.ComboBox1.ItemIndex = 5 then
      begin
        x := 1920;
        y := 1080;
      end;
      if form17.ComboBox1.ItemIndex = 6 then
      begin
        x := 2560;
        y := 1440;
      end;
      if form17.ComboBox1.ItemIndex = 7 then
      begin
        x := 3840;
        y := 2160;
      end;
      form13.ClientWidth := x;
      form13.ClientHeight := y;
      form13.BorderStyle := bsSizeable;
      form13.Position := poDefaultPosOnly;
    end;

    myscreen := TPikaEngine.Create(form13.Handle, x, y, form17.combobox2.ItemIndex);
    if myscreen.Enable then
    begin
      myscreen.AlphaEnabled := true;
      myscreen.AlphaTestValue := 32;
      myscreen.ViewDistance := 0;
      if form17.combobox4.ItemIndex = 0 then
        myscreen.ViewDistance := 500;
      if form17.combobox4.ItemIndex = 1 then
        myscreen.ViewDistance := 900;
      if form17.combobox4.ItemIndex = 2 then
        myscreen.ViewDistance := 1500;
      if form17.combobox4.ItemIndex = 0 then
        myscreen.ItemDistance := 500;
      if form17.combobox4.ItemIndex = 1 then
        myscreen.ItemDistance := 800;
      if form17.combobox4.ItemIndex = 2 then
        myscreen.ItemDistance := 1000;
      if form17.combobox4.ItemIndex = 3 then
        myscreen.ItemDistance := 1200;
      if myscreen.ViewDistance <> 0 then
        myscreen.SetClipping(myscreen.ViewDistance)
      else
        myscreen.SetClipping(0);
      myscreen.TextureMirrored := true;

      myscreen.BackGroundColor := $FF303030;
      if form17.CheckBox1.Checked then
        myscreen.Antializing := true;
      MyMonstCount := 0;
      MyObjCount := 0;
      fillchar(BaseMonsterID[0], sizeof(BaseMonsterID), 0);
      BaseMonsterID[0] := -1;
      BaseMonster[0] := t3ditem.Create(myscreen);
      BaseMonster[0].LoadQ3Files(path + 'monster\unknown.MD3');
      BaseMonster[0].SetBaseRotation(0, 0, 0);

      BaseObjID[0] := -1;
      BaseObj[0] := t3ditem.Create(myscreen);
      BaseObj[0].LoadQ3Files(path + 'obj\unknown.MD3');
      BaseObj[0].SetBaseRotation(0, 0, 0);

      sel3d := t3ditem.Create(myscreen);
      sel3d.LoadQ3Files(path + 'obj\selection.md3');
      sel3d.zwrite := false;
      sel3d.isOnTop := true;
      sel3d.AlphaSource := 3;
      sel3d.AlphaDest := 2;
      sel3d2 := t3ditem.Create(myscreen);
      sel3d2.CloneFromItem(sel3d);
      sel3d2.isOnTop := true;

      { BaseObj[1]:=t3ditem.Create(myscreen);
        BaseObj[1].SetCoordinate(0,10,0);
        BaseObj[1].Visible:=true;
        BaseObj[1].Particles:=T3DParticleGenerator.Create(BaseObj[1]);
        BaseObj[1].Particles.sizex:=20;
        BaseObj[1].Particles.sizey:=20;
        BaseObj[1].Particles.Particlecount:=1;
        //BaseObj[1].Particles.color:=$ff0000;
        BaseObj[1].Particles.LoadTexture ('effect\700431.bmp'); }

    end
    else
    begin
      showmessage(GetLanguageString(81));
      myscreen := nil;
      form14.Close;
      exit;
    end;
    // myscreen.SetProjection(2,2,1,1,-1);
    {
      BaseMonster[111]:=t3ditem.Create(myscreen);
      BaseMonster[111].LoadQ3Files(path+'monster\unknown.MD3');
      BaseMonster[111].setBaseRotation(180,0,0);
      Basenpc[29]:=t3ditem.Create(myscreen);
      Basenpc[29].LoadQ3Files(path+'monster\unknown.MD3');
      Basenpc[29].setBaseRotation(180,0,0); }

  end;

  form13.Show;
  have3d := true;
  load3d;
end;

procedure TForm1.Newitem1Click(Sender: TObject);
begin
  Button4Click(nil);
end;

procedure TForm1.Newmonster1Click(Sender: TObject);
begin
  Button9Click(nil);
end;

procedure TForm1.smNewItemClick(Sender: TObject);
begin
  Button4Click(nil);
end;

procedure TForm1.smNewMonsterClick(Sender: TObject);
begin
  Button9Click(nil);
end;

procedure TForm1.smPlacementClick(Sender: TObject);
begin
  FPlacementOptions.showmodal();
  // Update based on snap preferences
  snapvalue := FPlacementOptions.seSnapTolerance.Value;
  snaprotate := FPlacementOptions.chkSnapRotate.Checked;
  snapdistance := FPlacementOptions.chkSnapDistance.Checked;
end;

procedure TForm1.smDeleteClick(Sender: TObject);
begin
  Button3Click(nil);
end;

procedure TForm1.smDragClick(Sender: TObject);
var
  Reg: TRegistry;
begin
  smDrag.Checked := not smDrag.Checked;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
  if Reg.OpenKey('\Software\Microsoft\schthack\qedit', true) then
  begin
    Reg.WriteBool('DragEnabled', smDrag.Checked);
    Reg.CloseKey;
  end;
  finally
    Reg.Free;
  end;
end;

procedure TForm1.smEditClick(Sender: TObject);
begin
  Button2Click(nil);
end;

procedure TForm1.smMoveClick(Sender: TObject);
begin
  Button1Click(nil);
end;

procedure TForm1.smSnapClick(Sender: TObject);
var
  Reg: TRegistry;
begin
  smSnap.Checked := not smSnap.Checked;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
  if Reg.OpenKey('\Software\Microsoft\schthack\qedit', true) then
  begin
    Reg.WriteBool('SnapEnabled', smSnap.Checked);
    Reg.CloseKey;
  end;
  finally
    Reg.Free;
  end;
end;

procedure TForm1.smUndoClick(Sender: TObject);
begin
  Button11Click(nil);
end;

{

  Lee John Langan: i list them as uknown
  Lee John Langan: well if i map it right
  Lee John Langan: you can mess with it
  Lee John Langan: Type 05:
  Primary Header: 0x10 bytes
  32b: Chunk type (05 00 00 00)
  32b: Chunk size (CC 01 00 00)
  32b: Area number (01 00 00 00)
  32b: Size without header (BC 01 00 00)

  DATA:
  Data header: 0x10 bytes
  32b: pointer to 1st data set
  32b: pointer to second data set
  32b: number of entries 1st data set
  32b: number of entries 2nd data set

  1st data set:
  0x20 bytes
  flt: unknown 1
  flt: unknown 2
  flt: unknown 3
  32b: unknown 4
  32b: unknown 5
  32b: unknown 6
  32b: unknown 7
  16b: unknown 8
  16b: unknown 9

  2nd data set:
  0x4 bytes
  16b: unknown 1
  16b: unknown 2
  Aleron Ives dit :
  Lee John Langan: I don't know hack wants it formated
  Lee John Langan: XD
  Lee John Langan: type 04 is fun
  Lee John Langan: it has the xyz coords



  Type 04:
  Primary Header: 0x10 bytes
  32b: Chunk type (05 00 00 00)
  32b: Chunk size (CC 01 00 00)
  32b: Area number (01 00 00 00)
  32b: Size without header (BC 01 00 00)

  DATA:
  Data header: 0xC bytes
  32b: pointers to room float coord data sets
  32b: Start of float data
  32b: number of entries for room pointers

  pointers to room float coord data sets: 0x8 bytes
  16b: Room number
  16b: Number of spawn slots in that room
  32b: Pointer to the float data (take away this data set so it starts at 0x0)

  Each entry is 0x1C bytes long
  Dword: Position X
  Dword: Position Y
  Dword: Position z
  Dword: Rotation X
  Dword: Rotation Y
  Dword: Rotation Z
  Word: Room number
  Word: entry number
}

procedure TForm1.Button12Click(Sender: TObject);
var
  x, int, y, z: integer;
  flt: Single;
begin
  move(Floor[sfloor].d05[0], y, 4);
  move(Floor[sfloor].d05[8], z, 4);
  if z = 0 then
    form15.StringGrid1.RowCount := 2
  else
    form15.StringGrid1.RowCount := z + 1;
  form15.StringGrid1.Rows[0].LoadFromFile(path + 'rand05A.cfg');
  form15.StringGrid2.Rows[0].LoadFromFile(path + 'rand05b.cfg');
  for x := 1 to z do
  begin
    form15.StringGrid1.Cells[0, x] := inttostr(x);
    move(Floor[sfloor].d05[y], flt, 4);
    form15.StringGrid1.Cells[1, x] := floattostr(flt);
    move(Floor[sfloor].d05[y + 4], flt, 4);
    form15.StringGrid1.Cells[2, x] := floattostr(flt);
    move(Floor[sfloor].d05[y + 8], flt, 4);
    form15.StringGrid1.Cells[3, x] := floattostr(flt);
    move(Floor[sfloor].d05[y + 12], flt, 4);
    form15.StringGrid1.Cells[4, x] := floattostr(flt);
    move(Floor[sfloor].d05[y + 16], flt, 4);
    form15.StringGrid1.Cells[5, x] := floattostr(flt);
    int := 0;
    move(Floor[sfloor].d05[y + 20], int, 2);
    form15.StringGrid1.Cells[6, x] := inttostr(int);
    move(Floor[sfloor].d05[y + 22], int, 2);
    form15.StringGrid1.Cells[7, x] := inttostr(int);
    move(Floor[sfloor].d05[y + 24], int, 4);
    form15.StringGrid1.Cells[8, x] := inttostr(int);
    int := 0;
    move(Floor[sfloor].d05[y + 28], int, 2);
    form15.StringGrid1.Cells[9, x] := inttostr(int);
    move(Floor[sfloor].d05[y + 30], int, 2);
    form15.StringGrid1.Cells[10, x] := inttostr(int);
    inc(y, $20);
  end;
  move(Floor[sfloor].d05[4], y, 4);
  move(Floor[sfloor].d05[12], z, 4);
  if z = 0 then
    form15.StringGrid2.RowCount := 2
  else
    form15.StringGrid2.RowCount := z + 1;
  for x := 1 to z do
  begin
    form15.StringGrid2.Cells[0, x] := inttostr(x);
    int := 0;
    move(Floor[sfloor].d05[y], int, 2);
    form15.StringGrid2.Cells[1, x] := inttostr(int and 255);
    form15.StringGrid2.Cells[2, x] := inttostr(int div 256);
    move(Floor[sfloor].d05[y + 2], int, 2);
    form15.StringGrid2.Cells[3, x] := inttostr(int);
    inc(y, 4);
  end;

  // enumerate the entry
  move(Floor[sfloor].d04[0], y, 4);
  move(Floor[sfloor].d04[8], z, 4);
  form15.ListBox1.Clear;
  for x := 1 to z do
  begin
    move(Floor[sfloor].d04[y], int, 4);
    form15.ListBox1.Items.Add(inttostr(int and $FFFF) + ' (' + inttostr(int div $10000) + GetLanguageString(82));
    inc(y, 8);
  end;
  if z > 0 then
  begin
    form15.ListBox1.Selected[0] := true;
    form15.ListBox1.ItemIndex := 0;
    form15.ListBox1Click(Form1);
  end;
  form15.ShowModal;
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
  form33.Show;
end;

procedure TForm1.About1Click(Sender: TObject);
begin
  form16.ShowModal;
end;

procedure TForm1.N3DSetup1Click(Sender: TObject);
begin
  form17.Show;
end;

procedure TForm1.Listitem1Click(Sender: TObject);
var
  x: integer;
  s: ansistring;
begin
  for x := 0 to Floor[sfloor].ObjCount - 1 do
  begin
    if StringTest.IndexOf(inttostr(Floor[sfloor].Obj[x].Skin)) = -1 then
      StringTest.Add(inttostr(Floor[sfloor].Obj[x].Skin));
  end;
  form18.Show;
  s := '';
  for x := 0 to StringTest.count - 1 do
    s := s + StringTest.Strings[x] + ',';
  form18.Memo1.Clear;
  form18.Memo1.Lines.Add(s);
end;

procedure TForm1.Itemslistbb1Click(Sender: TObject);
var
  i, x: integer;
begin
  for x := 0 to 63 do
    for i := 0 to 13 do
      form19.StringGrid1.Cells[i, x + 1] := inttohex(BBData[(x * 14) + i + 36], 8);
  form19.Show;
end;

{
  special code for bb quest
  000F6D38 00-06 // Music Discs
  000F59B0 00-06 // Music Discs
  000FB3A3 1B-1D // Class Walls
  000F80C0 00-0F // S-rank Specials
  000F7120 01-0C // Second byte Roulete weapon
  000F5D9C 04-07 // Third byte Roulete weapon
  00100590 0A-32 // Roulete Weapon percentage
  00123040 00-FF // Flower Bouquet
  000F6180 01-09 // Valentines Chocolate
  00112AF8 70-88 // S-rank second byte set 1
  001155FE A5-A9 // S-rank second byte set 2
  0011D70D ??-?? // S-rank second byte set 3
  000F4DF8 00-04 // Area location 1
  0010059A 0A-37 // Area % 1
  000F55C8 00-04 // Area location 2
  00100590 0A-37 // Area % 2
  000F55C8 00-05 // Area location 1
  0010C8E0 00-64 // Area % Claries deal
  000F7CD8 00-0F // Sbeats Grind
  000FA3E8 00-19 // Parms Grid
  000F6568 00-09 // Delsaber Buster
  000FCAF8 00-23 // Dragons claw
  000FB770 00-1E // Baranc Launcher
  000F9060 00-14 // Belra Cannon
  00101918 00-37 // Gigo Claw
  000FBF40 00-20 // Rappy Fan
  000F51E1 00-05 // Area location
  FFFFFFFF 00-FF // Accept any value
}

procedure TForm1.Nuuuuuuuuuuu1Click(Sender: TObject);
var
  i, y, o: integer;
  st: tstringlist;
  s, id: ansistring;
begin
  form18.Memo1.Clear;
  for i := 0 to ItemsName.count - 1 do
  begin

    s := ItemsName.Strings[i];
    o := pos(#9, s);
    id := copy(s, 1, o - 1);
    delete(s, 1, o);
    o := pos(#9, s);
    s := copy(s, 1, o - 1);
    form18.Memo1.Lines.Add(#9 + s);
    form18.Memo1.Lines.Add('Skin'#9 + id);
    form18.Memo1.Lines.Add('Unknow'#9'0');
    form18.Memo1.Lines.Add('Unknow'#9'0');
    form18.Memo1.Lines.Add('ID'#9'0');
    form18.Memo1.Lines.Add('Map Section'#9'0');
    form18.Memo1.Lines.Add('Unknow'#9'0');
    form18.Memo1.Lines.Add('Pos X'#9'0');
    form18.Memo1.Lines.Add('Pos Z'#9'0');
    form18.Memo1.Lines.Add('Pos Y'#9'0');
    form18.Memo1.Lines.Add('Unknow'#9'0');
    form18.Memo1.Lines.Add('Rotation'#9'0');
    form18.Memo1.Lines.Add('Unknow'#9'0');
    form18.Memo1.Lines.Add('Active Range'#9'1');
    form18.Memo1.Lines.Add('Unknow'#9'1');
    form18.Memo1.Lines.Add('Unknow'#9'1');
    form18.Memo1.Lines.Add('Action'#9'0');
    form18.Memo1.Lines.Add('unknow'#9'0');
    form18.Memo1.Lines.Add('Unknow'#9'0');
    form18.Memo1.Lines.Add('Unknow'#9'0');
    form18.Memo1.Lines.Add('');
  end;
  form18.Show;
end;

procedure TForm1.Options1Click(Sender: TObject);
begin
  smPlacementClick(nil);
end;

{
  3, 321

}

procedure TForm1.help1Click(Sender: TObject);
begin
  if Form1.Active then
    ShellExecute(0, 'open', 'https://qedit.info/', '', '', 0);
end;

procedure TForm1.Hidemainwindow1Click(Sender: TObject);
begin
   if (have3d) and (form13.BorderStyle = bsNone) and (not form13.Focused) then
    Form1.WindowState := wsMinimized
   else
   begin
    Form1.WindowState := wsNormal;
    Form1.BringToFront;
   end;
end;

procedure TForm1.Hotkeys1Click(Sender: TObject);
begin
  fmHotkeys.ShowModal;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    PopupMenu3.Popup(mouse.CursorPos.x, mouse.CursorPos.y);
end;

procedure TForm1.FormMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
var
  mypos: TPoint;
begin
  mypos := Image2.ScreenToClient(MousePos);
  if (mypos.x >= 0) and (mypos.y >= 0) and (mypos.y <= Image2.height) and (mypos.x <= Image2.Width) then
  begin
    Handled := true;
    Button5Click(self);
  end;
end;

procedure TForm1.FormMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
var
  mypos: TPoint;
begin
  mypos := Image2.ScreenToClient(MousePos);
  if (mypos.x >= 0) and (mypos.y >= 0) and (mypos.y <= Image2.height) and (mypos.x <= Image2.Width) then
  begin
    Handled := true;
    Button6Click(self);
  end;
end;

procedure TForm1.PopupMenu1Popup(Sender: TObject);
var
  tm: TMenuItem;
  x, y: integer;
begin
  EnemyWave1.Clear;
  tm := TMenuItem.Create(EnemyWave1);
  tm.Caption := GetLanguageString(83);
  tm.tag := -1;
  tm.OnClick := EnemyWave1Click;
  EnemyWave1.Add(tm);
  y := CountNumberOfWave;
  for x := 0 to y do
  begin
    tm := TMenuItem.Create(EnemyWave1);
    tm.Caption := GetLanguageString(84) + inttostr(x);
    tm.tag := x;
    tm.OnClick := EnemyWave1Click;
    EnemyWave1.Add(tm);
  end;

  Itemsgroupe1.Clear;
  tm := TMenuItem.Create(Itemsgroupe1);
  tm.Caption := GetLanguageString(83);
  tm.tag := -1;
  tm.OnClick := Itemsgroupe1Click;
  Itemsgroupe1.Add(tm);
  y := CountNumberOfGrp;
  for x := 0 to y do
  begin
    tm := TMenuItem.Create(EnemyWave1);
    tm.Caption := GetLanguageString(85) + inttostr(x);
    tm.tag := x;
    tm.OnClick := Itemsgroupe1Click;
    Itemsgroupe1.Add(tm);
  end;
end;

procedure TForm1.Edit1Click(Sender: TObject);
begin
  Button2Click(nil);
end;

procedure TForm1.EnemyWave1Click(Sender: TObject);
var
  x: integer;
begin
  showwave := TMenuItem(Sender).tag;
  DrawMap;
  if have3d then
  begin
    for x := 0 to Floor[sfloor].MonsterCount - 1 do
      if (Floor[sfloor].Monster[x].Unknow5 = showwave) or (showwave = -1) then
        MyMonst[x].Visible := true
      else
        MyMonst[x].Visible := false;
  end;
end;

procedure TForm1.Itemsgroupe1Click(Sender: TObject);
var
  x: integer;
begin
  showgrp := TMenuItem(Sender).tag;
  DrawMap;
  if have3d then
  begin
    for x := 0 to Floor[sfloor].ObjCount - 1 do
      if (Floor[sfloor].Obj[x].grp = showgrp) or (showgrp = -1) then
        MyObj[x].Visible := true
      else
        MyObj[x].Visible := false;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Reg: TRegistry;
  flp: TMemoryStream;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\schthack\qedit', true) then
    begin
      Reg.WriteInteger('LoadFrom', lastloadformat);
      Reg.WriteInteger('SaveTo', lsatsaveformat);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
    inherited;
  end;
  if isedited then
  begin
    if MessageDlg(GetLanguageString(55), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      Form1.Save1Click(Form1);
      if isedited then
      begin
        Action := caNone;
        exit;
      end;
    end;
  end;
  if have3d then
    myscreen.Free3d;
  if objscreen <> nil then
    objscreen.Free3d;
  ClearShadow;
end;

Function LookForLabel2(s: ansistring): integer;
var
  x: integer;
begin
  result := 0;
  if TsData.IndexOf('D_' + s) > -1 then
    result := 1;
  if TsData.IndexOf('S_' + s) > -1 then
    result := 1;
  if TsFnc.IndexOf('F_' + s) > -1 then
    result := 1;

end;

Procedure TestCompatibility(ver: integer; var errors, warn: tstringlist);
const
  DefaultLabel: array [0 .. 21] of integer = (100, 90, 120, 130, 80, 70, 60, 140, 110, 30, 50, 1, 20, 850, 800, 830,
    820, 810, 860, 870, 840, 880); // 13 for the v2
  DefaultLabel2: array [0 .. 18] of integer = (720, 660, 620, 600, 501, 520, 560, 540, 580, 680, 950, 900, 930, 920,
    910, 960, 970, 940, 980); // 10 for the v2
var
  x, y, i, c, l, ep, k, d: integer;
  s, cmd, b: ansistring;
begin
  errors := tstringlist.Create;
  warn := tstringlist.Create;
  { error }
  // does label 0 exists
  if LookForLabel2('0') = 0 then
    errors.Add(GetLanguageString(86));
  // check for all the opcode
  for x := 0 to form4.ListBox1.Items.count - 1 do
  begin
    s := form4.ListBox1.Items.Strings[x];
    delete(s, 1, 8);
    y := pos(' ', s);
    if y > 0 then
      cmd := copy(s, 1, y - 1)
    else
      cmd := s;
    delete(s, 1, length(cmd) + 1);
    for i := 0 to asmcount - 1 do
      if lowercase(cmd) = lowercase(asmcode[i].name) then
        break;
    // check if convert
    if (asmcode[i].fnc = $66) or (asmcode[i].fnc = $6D) or (asmcode[i].fnc = $79) or (asmcode[i].fnc = $7C) or
      (asmcode[i].fnc = $7D) or (asmcode[i].fnc = $7F) or (asmcode[i].fnc = $84) or (asmcode[i].fnc = $87) or
      (asmcode[i].fnc = $A8) or (asmcode[i].fnc = $C0) or (asmcode[i].fnc = $CD) or (asmcode[i].fnc = $CE) then
    begin
      // set a warning
      if (ver < 2) and (asmcode[i].order <> T_DC) then
        warn.Add(GetLanguageString(89) + cmd + GetLanguageString(87) + ' ' + inttostr(x));
    end
    else
      // check for the episode
      if (asmcode[i].fnc = $F8BC) then
      begin
        if (ver < 2) and (s <> '00000000') then
          errors.Add(GetLanguageString(90) + s + GetLanguageString(87) + ' ' + inttostr(x));
        if (ver = 2) and (s = '00000002') then
          errors.Add(GetLanguageString(90) + s + GetLanguageString(87) + ' ' + inttostr(x));
      end
      else
        // check version
        if (asmcode[i].fnc <> $D9) and (asmcode[i].fnc <> $EF) then
          if asmcode[i].ver > ver then
            errors.Add(GetLanguageString(91) + cmd + GetLanguageString(87) + ' ' + inttostr(x));

    if (asmcode[i].fnc = $F8EE) then
      warn.Add(GetLanguageString(92));

    // check if argument match

    // look trought all the param
    c := 0;
    while (asmcode[i].arg[c] <> T_NONE) and (asmcode[i].arg[c] <> T_STR) and (asmcode[i].arg[c] <> T_HEX) and
      (asmcode[i].arg[c] <> T_STRDATA) and (s <> '') do
    begin
      if (asmcode[i].ver < 2) and (asmcode[i].order = T_ARGS) and (ver < 2) then
        if ((asmcode[i].arg[c] = T_REG) and (s[1] <> 'R')) or ((asmcode[i].arg[c] = T_DWORD) and (s[1] = 'R')) then
          errors.Add(GetLanguageString(93) + cmd + GetLanguageString(87) + ' ' + inttostr(x));

      if (asmcode[i].arg[c] = T_FUNC) or (asmcode[i].arg[c] = T_FUNC2) or (asmcode[i].arg[c] = T_DATA) then
      begin
        l := pos(' ', s) - 2;
        if l <= 0 then
          l := length(s);
        if LookForLabel2(copy(s, 1, l)) = 0 then
          warn.Add(GetLanguageString(94) + ' ' + copy(s, 1, l) + GetLanguageString(88) + ' ' + inttostr(x));
      end;

      // test for switch call or jmp
      if (asmcode[i].arg[c] = T_SWITCH) then
      begin
        l := pos(' ', s);
        if (l = 0) then
          l := length(s) + 1;
        b := copy(s, 1, l - 1);
        l := pos(':', b);
        k := strtoint(copy(b, 1, l - 1));
        delete(b, 1, l);

        // test all of them
        for d := 1 to k do
        begin
          if b = '' then
          begin
            errors.Add('Array of function is missing entrys at line ' + inttostr(x));
            break;
          end;
          l := pos(':', b) - 1;
          if l <= 0 then
            l := length(s);
          if LookForLabel2(copy(b, 1, l)) = 0 then
            warn.Add(GetLanguageString(94) + ' ' + copy(b, 1, l) + GetLanguageString(88) + ' ' + inttostr(x));
          delete(b, 1, l + 1);
        end;
        if b <> '' then
          errors.Add('Array of function contain too many entrys at line ' + inttostr(x));
      end;

      l := pos(' ', s);
      if l > 0 then
        delete(s, 1, l)
      else
        s := '';
      inc(c);
    end;
    if (asmcode[i].arg[c] = T_STR) or (asmcode[i].arg[c] = T_STRDATA) then
    begin
      if (asmcode[i].arg[c] = T_STR) then
      begin
        delete(s, 1, 1);
        l := pos(''', ', s);
        if l > 0 then
          l := l - 2
        else
          l := length(s) - 1;
        s := copy(s, 1, l);
      end;
      c := 0;
      for l := 1 to length(s) do
      begin
        if s[l] = '<' then
          inc(c);
        if s[l] = '>' then
          dec(c);
      end;
      if c <> 0 then
        warn.Add(GetLanguageString(95) + ' ' + inttostr(x));
    end;

  end;
  { warning }

  ep := GetEpisode;
  // check label from npc
  for x := 0 to 20 do
    if Form1.CheckListBox1.Checked[x] then
    begin
      for y := 0 to Floor[x].MonsterCount - 1 do
      begin

        for i := 0 to 57 do
          if EnemyID[i] = Floor[x].Monster[y].Skin then
            break;
        if i = 58 then
        begin // check if label is existing
          // check in the fixed list by version
          if round(Floor[x].Monster[y].Action) > 0 then
          begin
            c := 0;
            if ep = 1 then
            begin
              for l := 0 to 9 do
                if DefaultLabel2[l] = round(Floor[x].Monster[y].Action) then
                  c := 1;
              if ver = 3 then
                for l := 10 to 18 do
                  if DefaultLabel2[l] = round(Floor[x].Monster[y].Action) then
                    c := 1;
            end
            else
            begin
              for l := 0 to 12 do
                if DefaultLabel[l] = round(Floor[x].Monster[y].Action) then
                  c := 1;
              if ver = 3 then
                for l := 13 to 21 do
                  if DefaultLabel[l] = round(Floor[x].Monster[y].Action) then
                    c := 1;
            end;
            if c = 0 then
              if LookForLabel2(inttostr(round(Floor[x].Monster[y].Action))) = 0 then
                warn.Add(GetLanguageString(96) + ' ' + inttostr(round(Floor[x].Monster[y].Action)) +
                  GetLanguageString(97) + inttostr(y) + GetLanguageString(98) + ' ' + inttostr(x));
          end;
        end;
        if Floor[x].Monster[y].Skin = 51 then
        begin
          if ver < 2 then
            warn.Add(GetLanguageString(99) + ' ' + inttostr(Floor[x].Monster[y].Skin) + GetLanguageString(100) +
              inttostr(y) + GetLanguageString(98) + ' ' + inttostr(x))
          else if ep = 2 then
            warn.Add(GetLanguageString(99) + ' ' + inttostr(Floor[x].Monster[y].Skin) + GetLanguageString(100) +
              inttostr(y) + GetLanguageString(98) + ' ' + inttostr(x))
          else
          begin
            if Floor[x].Monster[y].unknow7 > 15 then
              errors.Add(GetLanguageString(101) + inttostr(y) + GetLanguageString(98) + ' ' + inttostr(x))
            else if (NPC51Name[Floor[x].floorid, Floor[x].Monster[y].unknow7] = 'CRASH') or
              (NPC51Name[Floor[x].floorid, Floor[x].Monster[y].unknow7] = '') then
              errors.Add(GetLanguageString(101) + inttostr(y) + GetLanguageString(98) + ' ' + inttostr(x));

          end;
        end;
        if Floor[x].floorid < 50 then
        begin
          for i := 0 to FloorMonsID[Floor[x].floorid].count[ver] - 1 do
            if FloorMonsID[Floor[x].floorid].ids[ver, i] = Floor[x].Monster[y].Skin then
              break;
          if (i = FloorMonsID[Floor[x].floorid].count[ver]) and (FloorMonsID[Floor[x].floorid].count[ver] <> 0) then
            warn.Add(GetLanguageString(99) + ' ' + inttostr(Floor[x].Monster[y].Skin) + GetLanguageString(102) +
              inttostr(y) + GetLanguageString(98) + ' ' + inttostr(x));

        end;
      end;
      for y := 0 to Floor[x].ObjCount - 1 do
      begin
        if Floor[x].floorid < 50 then
        begin
          for i := 0 to FloorObjID[Floor[x].floorid].count[ver] - 1 do
            if FloorObjID[Floor[x].floorid].ids[ver, i] = Floor[x].Obj[y].Skin then
              break;
          if (i = FloorObjID[Floor[x].floorid].count[ver]) and (FloorObjID[Floor[x].floorid].count[ver] <> 0) then
            warn.Add(GetLanguageString(103) + ' ' + inttostr(Floor[x].Obj[y].Skin) + GetLanguageString(102) +
              inttostr(y) + GetLanguageString(98) + ' ' + inttostr(x));

        end;
      end;
      if Floor[x].ObjCount > 400 then
        warn.Add(GetLanguageString(104) + ' ' + inttostr(x) + GetLanguageString(105));
      if Floor[x].MonsterCount > 400 then
        warn.Add(GetLanguageString(104) + ' ' + inttostr(x) + GetLanguageString(106));
    end;

  // look for unused t_data
  for x := 0 to TsData.count - 1 do
  begin
    if GetReferenceType(strtoint(copy(TsData.Strings[x], 3, length(TsData.Strings[x]) - 2))) = 0 then
      warn.Add(GetLanguageString(107) + ' ' + TsData.Strings[x]);
  end;

  // look for extra pvr
  for x := 0 to qstfilecount - 1 do
    if pos('.bin', lowercase(qstfile[x].name)) > 0 then
      break;
  if x = qstfilecount then
    errors.Add(GetLanguageString(108));

  for x := 0 to qstfilecount - 1 do
    if pos('.dat', lowercase(qstfile[x].name)) > 0 then
      break;
  if x = qstfilecount then
    warn.Add(GetLanguageString(109));

  for x := 0 to qstfilecount - 1 do
    if pos('.pvr', lowercase(qstfile[x].name)) > 0 then
      break;
  if ver > 1 then
    if x < qstfilecount then
      errors.Add(GetLanguageString(110));

end;

procedure TForm1.Compatibilitycheck1Click(Sender: TObject);
begin
  TestCompatibility(0, form27.er[0], form27.wa[0]);
  TestCompatibility(1, form27.er[1], form27.wa[1]);
  form27.er[2] := form27.er[1];
  form27.wa[2] := form27.wa[1];
  TestCompatibility(2, form27.er[3], form27.wa[3]);
  TestCompatibility(3, form27.er[4], form27.wa[4]);
  form27.ListBox1.ItemIndex := 0;
  form27.ListBox1Click(form27);
  form27.ShowModal;

  form27.er[0].Free;
  form27.er[1].Free;
  form27.er[3].Free;
  form27.er[4].Free;
  form27.wa[0].Free;
  form27.wa[1].Free;
  form27.wa[3].Free;
  form27.wa[4].Free;
end;

{

  Yin dit :
  skin 689 Lab Computer Console
  Yin dit :
  is missing a link to a function ;o



  74 - 78 = quest board
  99 = used on talk?
}

procedure TForm1.Export1Click(Sender: TObject);
begin
  form4.Button8Click(form4.Button8);
end;

procedure TForm1.Import1Click(Sender: TObject);
begin
  form4.Button9Click(form4.Button9);
end;

procedure TForm1.PopupMenu2Popup(Sender: TObject);
var
  x: integer;
  tm: TMenuItem;
begin
  if CheckListBox1.ItemIndex = -1 then
    CheckListBox1.ItemIndex := 0;
  PopupMenu2.Items.Clear;
  for x := 1 to PsoMapV[Floor[CheckListBox1.ItemIndex].floorid] do
  begin
    tm := TMenuItem.Create(PopupMenu2);
    tm.tag := x - 1;
    tm.Caption := GetLanguageString(111) + ' ' + inttostr(x);
    tm.OnClick := Layout11Click;
    PopupMenu2.Items.Add(tm);
  end;
end;

procedure TForm1.Layout11Click(Sender: TObject);
var
  x, i, c, pos, k, y, okfnd: integer;
  strtofind, mappc, mapgc, mapbb, leti: ansistring;
  regused, modetouse, regcount: byte;
  s: ansistring;
  b: widestring;
begin
  // yay now find the place it set the map
  x := CheckListBox1.ItemIndex; // floor id
  i := form4.ListBox1.Items.count - 1;
  mappc := getopcodename($C4) + ' ';
  mapgc := getopcodename($F80D) + ' ';
  mapbb := getopcodename($F951);
  leti := getopcodename($9);
  modetouse := 0;
  pos := -1;
  okfnd := 0;
  if Floor[CheckListBox1.ItemIndex].floorid > $11 then
    modetouse := 1;
  if Floor[CheckListBox1.ItemIndex].floorid > $23 then
    modetouse := 2;
  strtofind := '';
  for c := i downto 0 do
  begin
    if copy(form4.ListBox1.Items.Strings[c], 9, length(mapbb)) = mapbb then
    begin
      modetouse := 2;
      s := copy(form4.ListBox1.Items.Strings[c], 10 + length(mapbb), 2);
      if hextoint(s) = x then
      begin
        pos := c;
        b := copy(form4.ListBox1.Items.Strings[c], 1, 8) + mapbb + ' ' + inttohex(x, 2) + ', ' +
          inttohex(Floor[CheckListBox1.ItemIndex].floorid, 4) + ', ' + inttohex(TMenuItem(Sender).tag, 2) + ', 00';
        form4.ListBox1.Items.Strings[c] := b;
        okfnd := 1;
        break;
      end;
    end;
    if copy(form4.ListBox1.Items.Strings[c], 9, length(mapgc)) = mapgc then
    begin
      modetouse := 1;
      pos := c;
      s := copy(form4.ListBox1.Items.Strings[c], 10 + length(mapgc), 3); // the reg
      regused := strtoint(s);
      strtofind := leti + ' R' + inttostr(regused) + ', ' + inttohex(x, 8);
      regcount := 4;
    end;
    if copy(form4.ListBox1.Items.Strings[c], 9, length(mappc)) = mappc then
    begin
      modetouse := 0;
      s := copy(form4.ListBox1.Items.Strings[c], 10 + length(mappc), 3); // the reg
      pos := c;
      regused := strtoint(s);
      strtofind := leti + ' R' + inttostr(regused) + ', ' + inttohex(x, 8);
      regcount := 3;
    end;
    if strtofind <> '' then
    begin
      if strtofind = copy(form4.ListBox1.Items.Strings[c], 9, length(form4.ListBox1.Items.Strings[c]) - 8) then
      begin
        k := c;
        b := copy(form4.ListBox1.Items.Strings[c], 1, 8);
        while k < pos do
        begin // delete all reg
          // scan for any matching reg
          for y := regused to regused + regcount do
          begin
            s := leti + ' R' + inttostr(y) + ', ';
            if copy(form4.ListBox1.Items.Strings[k], 9, length(s)) = s then
            begin
              form4.ListBox1.Items.delete(k);
              dec(pos);
              break;
            end;
          end;
          if y > regused + regcount then
            inc(k); // didnt match
        end;
        // here insert all at the pos
        b := b + leti + ' R' + inttostr(regused) + ', ' + inttohex(x, 8);
        form4.ListBox1.Items.insert(pos, b);
        y := 0;
        if regcount = 4 then
        begin
          form4.ListBox1.Items.insert(pos + 1, '        ' + leti + ' R' + inttostr(regused + 1) + ', ' +
            inttohex(Floor[CheckListBox1.ItemIndex].floorid, 8));
          y := 1;
        end;
        form4.ListBox1.Items.insert(pos + y + 1, '        ' + leti + ' R' + inttostr(regused + 1 + y) + ', 00000000');
        form4.ListBox1.Items.insert(pos + y + 2, '        ' + leti + ' R' + inttostr(regused + 2 + y) + ', ' +
          inttohex(TMenuItem(Sender).tag, 8));
        form4.ListBox1.Items.insert(pos + y + 3, '        ' + leti + ' R' + inttostr(regused + 3 + y) + ', 00000000');
        okfnd := 1;
        break;
      end;
    end;
  end;

  // if not found add it
  if okfnd = 0 then
  begin
    // find the label 0
    for c := i downto 0 do
      if copy(form4.ListBox1.Items.Strings[c], 1, 8) = '0:      ' then
        break;
    if c > -1 then
      if copy(form4.ListBox1.Items.Strings[c], 1, 8) = '0:      ' then
      begin
        form4.ListBox1.Items.Strings[c] := '  ' + copy(form4.ListBox1.Items.Strings[c], 3,
          length(form4.ListBox1.Items.Strings[c]) - 2);
      end;
    // dec(c);
    if modetouse = 2 then
    begin
      form4.ListBox1.Items.insert(c, '0:      ' + mapbb + ' ' + inttohex(x, 2) + ', ' +
        inttohex(Floor[CheckListBox1.ItemIndex].floorid, 4) + ', ' + inttohex(TMenuItem(Sender).tag, 2) + ', 00');
    end
    else
    begin
      pos := c;
      if pos < 0 then
        pos := 0;
      if modetouse = 0 then
      begin
        regused := 60;
        regcount := 3;
      end
      else
      begin
        regused := 60;
        regcount := 4;
      end;
      b := '0:      ' + leti + ' R' + inttostr(regused) + ', ' + inttohex(x, 8);
      form4.ListBox1.Items.insert(pos, b);
      y := 0;
      if regcount = 4 then
      begin
        form4.ListBox1.Items.insert(pos + 1, '        ' + leti + ' R' + inttostr(regused + 1) + ', ' +
          inttohex(Floor[CheckListBox1.ItemIndex].floorid, 8));
        y := 1;
      end;
      form4.ListBox1.Items.insert(pos + y + 1, '        ' + leti + ' R' + inttostr(regused + 1 + y) + ', 00000000');
      form4.ListBox1.Items.insert(pos + y + 2, '        ' + leti + ' R' + inttostr(regused + 2 + y) + ', ' +
        inttohex(TMenuItem(Sender).tag, 8));
      form4.ListBox1.Items.insert(pos + y + 3, '        ' + leti + ' R' + inttostr(regused + 3 + y) + ', 00000000');
      if modetouse = 0 then
        form4.ListBox1.Items.insert(pos + y + 4, '        ' + mappc + 'R60')
      else
        form4.ListBox1.Items.insert(pos + y + 4, '        ' + mapgc + 'R60')
    end;
  end;

  mapxvmfile[x] := path + 'map\xvm\' + mapxvmname[mapid[Floor[CheckListBox1.ItemIndex].floorid] +
    TMenuItem(Sender).tag];
  mapfile[x] := path + 'map\' + mapfilename[mapid[Floor[CheckListBox1.ItemIndex].floorid] + TMenuItem(Sender).tag];
  Floor[x].floorid := maparea[mapid[Floor[CheckListBox1.ItemIndex].floorid] + TMenuItem(Sender).tag];
  Form1.CheckListBox1.Items.Strings[x] := mapname[mapid[Floor[CheckListBox1.ItemIndex].floorid] +
    TMenuItem(Sender).tag];

end;

procedure TForm1.lblModifiersClick(Sender: TObject);
begin
  fmHotkeys.ShowModal;
end;

procedure TForm1.Checkforupdates1Click(Sender: TObject);
begin
  // make it look for updates
  mstat := 0;
  GetHttpFile('/updatev2.sml');
  form29.Memo1.Clear;
  if fileupd = nil then
    fileupd := tstringlist.Create;
  fileupd.Clear;
  form29.Memo1.Lines.Add('');
  form29.Memo1.Lines.Add('');
  form29.Memo1.Lines.Add('');
  form29.Memo1.Lines.Add(GetLanguageString(112));
  form29.Button1.Caption := GetLanguageString(113);
  form29.ShowModal;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  DrawMap;
end;

procedure TForm1.Cancelplacement1Click(Sender: TObject);
begin
  if (have3d) and (form13.Focused) and (form13.BorderStyle = bsNone) then
    form13.close
  else
  begin
    MoveSel := -1;
    HideIndicator();
  end;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  DrawMap;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if isedited then
    CreateShadow;
end;

procedure TForm1.Undo1Click(Sender: TObject);
begin
  Button11Click(nil);
end;

procedure TForm1.English1Click(Sender: TObject);
var
  Reg: TRegistry;
  flp: TMemoryStream;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\schthack\qedit', true) then
    begin
      Reg.WriteInteger('Lang', 0);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
    inherited;
  end;
  flp := TMemoryStream.Create;
  PikaGetFile(flp, 'eng.txt', path + 'config.ppk', 'Build By Schthack');
  flp.Position := 0;
  LanguageString.LoadFromStream(flp);
  SetInterfaceText;
  flp.Free;
end;

procedure TForm1.French1Click(Sender: TObject);
var
  Reg: TRegistry;
  flp: TMemoryStream;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\schthack\qedit', true) then
    begin
      Reg.WriteInteger('Lang', 1);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
    inherited;
  end;
  flp := TMemoryStream.Create;
  PikaGetFile(flp, 'fra.txt', path + 'config.ppk', 'Build By Schthack');
  // flp.LoadFromFile('span.txt');
  flp.Position := 0;
  LanguageString.LoadFromStream(flp);
  SetInterfaceText;
  flp.Free;
end;

procedure TForm1.Exporttextfortranslation1Click(Sender: TObject);
var
  s, b: widestring;
  f, x, y, re, z, i, c: integer;
begin
  if SaveDialog3.Execute then
  begin
    f := filecreate(SaveDialog3.filename);
    x := $FEFF;
    re := $0A000D;
    filewrite(f, x, 2);
    s := Title;
    while pos(#10, s) > 0 do
    begin
      y := pos(#10, s);
      delete(s, y, 1);
    end;
    while pos(#13, s) > 0 do
    begin
      y := pos(#13, s);
      delete(s, y, 1);
      insert('<cr>', s, y);
    end;
    filewrite(f, s[1], length(s) * 2);
    filewrite(f, re, 4);

    s := Info;
    while pos(#10, s) > 0 do
    begin
      y := pos(#10, s);
      delete(s, y, 1);
    end;
    while pos(#13, s) > 0 do
    begin
      y := pos(#13, s);
      delete(s, y, 1);
      insert('<cr>', s, y);
    end;
    filewrite(f, s[1], length(s) * 2);
    filewrite(f, re, 4);

    s := Desc;
    while pos(#10, s) > 0 do
    begin
      y := pos(#10, s);
      delete(s, y, 1);
    end;
    while pos(#13, s) > 0 do
    begin
      y := pos(#13, s);
      delete(s, y, 1);
      insert('<cr>', s, y);
    end;
    filewrite(f, s[1], length(s) * 2);
    filewrite(f, re, 4);
    filewrite(f, re, 4);

    // scan all the script
    for y := 0 to form4.ListBox1.Items.count - 1 do
    begin
      s := form4.ListBox1.Items.Strings[y];
      delete(s, 1, 8);
      x := pos(' ', s);
      if x = 0 then
        x := length(s) + 1;
      b := copy(s, 1, x - 1);
      delete(s, 1, x);
      for z := 0 to asmcount - 1 do
        if lowercase(asmcode[z].name) = lowercase(b) then
          break;
      if z < asmcount then
      begin
        // look if any strings
        for x := 0 to 9 do
        begin
          if asmcode[z].arg[x] = T_NONE then
            break
          else if (asmcode[z].arg[x] = T_STRHEX) or (asmcode[z].arg[x] = T_STR) then
          begin
            b := s;
            for i := 0 to x - 1 do
            begin
              c := pos(widestring(', '), b);
              delete(b, 1, c + 1);
            end;
            c := pos(widestring(''', '), b);
            if c = 0 then
              c := length(b);
            b := copy(b, 2, c - 2);
            filewrite(f, b[1], length(b) * 2);
            filewrite(f, re, 4);
          end;
        end;

      end;
    end;

    fileclose(f);

  end;
end;

Function ReadUniString(f: integer): widestring;
var
  c: widechar;
begin
  result := '';
  while fileread(f, c, 2) = 2 do
  begin
    if c = #10 then
      break;
    if c <> #13 then
      result := result + c;
  end;
end;

procedure TForm1.Importtextfromtranslation1Click(Sender: TObject);
var
  s, b, a: widestring;
  f, x, y, re, z, i, c: integer;
begin
  if OpenDialog3.Execute then
  begin
    f := fileopen(OpenDialog3.filename, $40);
    x := $0;
    fileread(f, x, 2);
    if x <> $FEFF then
    begin
      raise ERangeError.Create(GetLanguageString(176));
      exit;
    end;
    s := ReadUniString(f);
    while pos(widestring('<cr>'), s) > 0 do
    begin
      y := pos(widestring('<cr>'), s);
      delete(s, y, 4);
      insert(#13, s, y);
    end;
    Title := s;

    s := ReadUniString(f);
    while pos(widestring('<cr>'), s) > 0 do
    begin
      y := pos(widestring('<cr>'), s);
      delete(s, y, 4);
      insert(#13, s, y);
    end;
    Info := s;

    s := ReadUniString(f);
    while pos(widestring('<cr>'), s) > 0 do
    begin
      y := pos(widestring('<cr>'), s);
      delete(s, y, 4);
      insert(#13, s, y);
    end;
    Desc := s;
    s := ReadUniString(f);

    // scan all the script
    for y := 0 to form4.ListBox1.Items.count - 1 do
    begin
      s := form4.ListBox1.Items.Strings[y];
      a := copy(s, 1, 8);
      delete(s, 1, 8);
      x := pos(' ', s);
      if x = 0 then
        x := length(s) + 1;
      b := copy(s, 1, x - 1);
      a := a + copy(s, 1, x);
      delete(s, 1, x);
      re := 0;
      for z := 0 to asmcount - 1 do
        if lowercase(asmcode[z].name) = lowercase(b) then
          break;
      if z < asmcount then
      begin
        // look if any strings
        b := s;
        for x := 0 to 9 do
        begin
          if asmcode[z].arg[x] = T_NONE then
            break
          else
          begin
            if (asmcode[z].arg[x] = T_STRHEX) or (asmcode[z].arg[x] = T_STR) then
            begin
              c := pos(widestring(''', '), b);
              if c = 0 then
                c := length(b);
              a := a + '''' + ReadUniString(f) + '''';
              re := 1;
              delete(b, 1, c + 2);
            end
            else
            begin
              c := pos(widestring(', '), b);
              a := a + copy(b, 1, c + 1);
              delete(b, 1, c + 1);
            end;
          end;
        end;

      end;
      if re = 1 then
        form4.ListBox1.Items.Strings[y] := a;
    end;

    fileclose(f);

  end;
end;

procedure TForm1.spanish1Click(Sender: TObject);
var
  Reg: TRegistry;
  flp: TMemoryStream;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\schthack\qedit', true) then
    begin
      Reg.WriteInteger('Lang', 2);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
    inherited;
  end;
  flp := TMemoryStream.Create;
  PikaGetFile(flp, 'spa.txt', path + 'config.ppk', 'Build By Schthack');
  // flp.LoadFromFile('span.txt');
  flp.Position := 0;
  LanguageString.LoadFromStream(flp);
  SetInterfaceText;
  flp.Free;
end;

procedure TForm1.Floorfilter1Click(Sender: TObject);
begin
  form30.ComboBox1.ItemIndex := FFilter;
  form30.ShowModal;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  mmy := Image2.height div 2;
  mmx := Image2.Width div 2;
  ListBox2.Left := 200 + (((Form1.Width - 190) div 2) - 16);
  Label3.Left := 200 + (((Form1.Width - 190) div 2) - 16);
  ListBox2.Width := (((Form1.Width - 190) div 2) - 14);
  ListBox1.Width := (((Form1.Width - 190) div 2) - 14);
  DrawMap;
end;

end.
