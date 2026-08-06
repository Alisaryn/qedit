unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ImgList, Dialogs, Math, Menus, StdCtrls, ExtCtrls, CheckLst, ComCtrls, System.Types,
  ShellApi, D3DEngin, registry, Spin, System.ImageList, System.Generics.Collections,
  System.Generics.Defaults, StrUtils, System.Actions, System.IOUtils, Vcl.ActnList, Vcl.Themes,
  Winapi.GDIPAPI, Winapi.GDIPOBJ, Winapi.GDIPUTIL,
  Vcl.Styles, Data.DB, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, Vcl.Buttons, Vcl.DBCtrls;

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
  TSnapPoint = record
    X, Y: double;
  end;
  TSnapPoints = array of TSnapPoint;

  TPolygonVertices = array of TPointF;

  TPolygonEdge = record
    X1, Y1, X2, Y2: double;
  end;
  TPolygonEdges = array of TPolygonEdge;

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

  TAsmArg = Record
    opcodeid: dword;
    argtype: ansistring;
    argnum: integer;
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

  TGridScrollPos = record
    Horz: Integer;
    Vert: Integer;
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
    Label5: TPanel;
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
    smSnapOptions: TMenuItem;
    SnapOptions2: TMenuItem;
    Options2: TMenuItem;
    Texteditor1: TMenuItem;
    SwitchScriptEditor1: TMenuItem;
    PopupMenu4: TPopupMenu;
    Smallfont1: TMenuItem;
    Largefont1: TMenuItem;
    Mediumfont1: TMenuItem;
    byGroup1: TMenuItem;
    Button14: TButton;
    Settheme1: TMenuItem;
    N3: TMenuItem;
    tmPreview: TTimer;
    lblPreview: TLabel;
    Previewevents1: TMenuItem;
    N13: TMenuItem;
    Russian1: TMenuItem;
    Japanese1: TMenuItem;
    Image2: TPaintBox;
    showbmp: TMenuItem;
    Showbitmapoverlays1: TMenuItem;
    MapRenderMode1: TMenuItem;
    MapRenderWireframe1: TMenuItem;
    MapRenderTopographic1: TMenuItem;
    MapRenderShadingSep1: TMenuItem;
    MapRenderHeightShading1: TMenuItem;
    Markerbrightness1: TMenuItem;
    Default1: TMenuItem;
    High1: TMenuItem;
    Veryhigh1: TMenuItem;
    N14: TMenuItem;
    Outlinewidth1: TMenuItem;
    Width1: TMenuItem;
    Width2: TMenuItem;
    Width3: TMenuItem;
    N15: TMenuItem;
    InvertYrotation1: TMenuItem;
    MirrorXposition1: TMenuItem;
    MirrorZposition1: TMenuItem;
    Transform1: TMenuItem;
    InvertYrotation2: TMenuItem;
    MirrorZposition2: TMenuItem;
    N16: TMenuItem;
    View1: TMenuItem;
    Lists1: TMenuItem;
    Grids1: TMenuItem;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    ClientDataSet1: TClientDataSet;
    ClientDataSet2: TClientDataSet;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    ClientDataSet1Field: TIntegerField;
    ClientDataSet1Name: TStringField;
    ClientDataSet2Field: TIntegerField;
    ClientDataSet2Name: TStringField;
    ClientDataSet1Section: TWordField;
    ClientDataSet1Skin: TWordField;
    ClientDataSet1Wave: TWordField;
    ClientDataSet1PositionX: TSingleField;
    ClientDataSet1PositionY: TSingleField;
    ClientDataSet1PositionZ: TSingleField;
    ClientDataSet1RotationY: TIntegerField;
    popupMonsters: TPopupMenu;
    popupObjects: TPopupMenu;
    Sort2: TMenuItem;
    byRoom3: TMenuItem;
    byWave2: TMenuItem;
    byType3: TMenuItem;
    Sort3: TMenuItem;
    byRoom4: TMenuItem;
    byGroup2: TMenuItem;
    byType4: TMenuItem;
    ClientDataSet2Skin: TWordField;
    ClientDataSet2Section: TWordField;
    ClientDataSet2Group: TWordField;
    ClientDataSet2PosX: TSingleField;
    ClientDataSet2PosY: TSingleField;
    ClientDataSet2PosZ: TSingleField;
    ClientDataSet1Param1: TIntegerField;
    ClientDataSet2Param4: TIntegerField;
    ClientDataSet2Param5: TIntegerField;
    ClientDataSet2Param6: TIntegerField;
    ClientDataSet1Param7: TIntegerField;
    ClientDataSet1Param2: TSingleField;
    ClientDataSet1Param3: TSingleField;
    ClientDataSet1Param4: TSingleField;
    ClientDataSet1Param5: TSingleField;
    ClientDataSet1Param6: TSingleField;
    ClientDataSet2Param1: TSingleField;
    ClientDataSet2Param2: TSingleField;
    ClientDataSet2Param3: TSingleField;
    Switchgridtab1: TMenuItem;
    ClientDataSet1ChildCount: TWordField;
    Gridmode1: TMenuItem;
    Rowselection1: TMenuItem;
    Celledit1: TMenuItem;
    N17: TMenuItem;
    popupGrid: TPopupMenu;
    Gridmode2: TMenuItem;
    Switchtab1: TMenuItem;
    Edit2: TMenuItem;
    Selection1: TMenuItem;
    ClientDataSet2RotX: TIntegerField;
    ClientDataSet2RotY: TIntegerField;
    ClientDataSet2RotZ: TIntegerField;
    N18: TMenuItem;
    LookAt1: TMenuItem;
    LookAt2: TMenuItem;
    btnRedo: TButton;
    smRedo: TMenuItem;
    Redo1: TMenuItem;
    Redo2: TMenuItem;
    btnCollapseTop: TButton;
    procedure btnCollapseTopClick(Sender: TObject);
    procedure Quit1Click(Sender: TObject);
    procedure Load1Click(Sender: TObject);
    procedure CheckListBox1Click(Sender: TObject);
    procedure DrawMap;
    procedure LoadFloorGrids;
    procedure UpdateSnapPolygonChildren(polygon: TObj);
    function TrySnapToPolygon(var targetX, targetY: double; polyObj: TObj;
                          snapThreshold: double; targetMapSection: integer): boolean;
    function SectionToMouseX(idx: integer; etype: integer): double;
    function SectionToMouseY(idx: integer; etype: integer): double;
    procedure LookAt2D(idx: integer; eType: integer; targetX: double; targetY: double);
    function GetDBGridScrollPos(Grid: TDBGrid): TGridScrollPos;
    procedure SetDBGridScrollPos(Grid: TDBGrid; const Pos: TGridScrollPos);
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
    function PartialSearch(strings: TStrings; const substr: string): integer;
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
    procedure smSnapOptionsClick(Sender: TObject);
    procedure SnapOptions2Click(Sender: TObject);
    procedure Texteditor1Click(Sender: TObject);
    procedure SwitchScriptEditor1Click(Sender: TObject);
    procedure Label5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Smallfont1Click(Sender: TObject);
    procedure Largefont1Click(Sender: TObject);
    procedure Mediumfont1Click(Sender: TObject);
    procedure byGroup1Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);

    procedure Button15Click(Sender: TObject);
    procedure tmPreviewTimer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Previewevents1Click(Sender: TObject);
    procedure Russian1Click(Sender: TObject);
    procedure Japanese1Click(Sender: TObject);
    procedure Image2Paint(Sender: TObject);
    procedure showbmpClick(Sender: TObject);
    procedure Showbitmapoverlays1Click(Sender: TObject);
    procedure MapRenderWireframe1Click(Sender: TObject);
    procedure MapRenderTopographic1Click(Sender: TObject);
    procedure MapRenderHeightShading1Click(Sender: TObject);
    procedure Default1Click(Sender: TObject);
    procedure High1Click(Sender: TObject);
    procedure Veryhigh1Click(Sender: TObject);
    procedure Width1Click(Sender: TObject);
    procedure Width2Click(Sender: TObject);
    procedure Width3Click(Sender: TObject);
    procedure InvertYrotation1Click(Sender: TObject);
    procedure InvertYrotation2Click(Sender: TObject);
    procedure MirrorZposition2Click(Sender: TObject);
    procedure MirrorXposition1Click(Sender: TObject);
    procedure MirrorZposition1Click(Sender: TObject);
    procedure Lists1Click(Sender: TObject);
    procedure Grids1Click(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure byRoom3Click(Sender: TObject);
    procedure byWave2Click(Sender: TObject);
    procedure byType3Click(Sender: TObject);
    procedure byRoom4Click(Sender: TObject);
    procedure byGroup2Click(Sender: TObject);
    procedure byType4Click(Sender: TObject);
    procedure DBGrid2CellClick(Column: TColumn);
    procedure DBGrid2TitleClick(Column: TColumn);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure Switchgridtab1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ClientDataSet1AfterScroll(DataSet: TDataSet);
    procedure ClientDataSet2AfterScroll(DataSet: TDataSet);
    procedure DBGrid1Exit(Sender: TObject);
    procedure DBGrid1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure DBGrid2Exit(Sender: TObject);
    procedure DBGrid2MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure DBGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBGrid2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ClientDataSet1RotationYGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure ClientDataSet2RotXGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure ClientDataSet2RotYGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure ClientDataSet2RotZGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure DBGrid2MouseLeave(Sender: TObject);
    procedure DBGrid1MouseLeave(Sender: TObject);
    procedure Celledit1Click(Sender: TObject);
    procedure Rowselection1Click(Sender: TObject);
    procedure ClientDataSet1SkinSetText(Sender: TField; const Text: string);
    procedure ClientDataSet1SectionSetText(Sender: TField; const Text: string);
    procedure ClientDataSet1WaveSetText(Sender: TField; const Text: string);
    procedure ClientDataSet1PositionXSetText(Sender: TField;
      const Text: string);
    procedure ClientDataSet1PositionYSetText(Sender: TField;
      const Text: string);
    procedure ClientDataSet1PositionZSetText(Sender: TField;
      const Text: string);
    procedure ClientDataSet1RotationYSetText(Sender: TField;
      const Text: string);
    procedure ClientDataSet1Param1SetText(Sender: TField; const Text: string);
    procedure ClientDataSet1Param2SetText(Sender: TField; const Text: string);
    procedure ClientDataSet1Param3SetText(Sender: TField; const Text: string);
    procedure ClientDataSet1Param4SetText(Sender: TField; const Text: string);
    procedure ClientDataSet1Param6SetText(Sender: TField; const Text: string);
    procedure ClientDataSet1Param7SetText(Sender: TField; const Text: string);
    procedure ClientDataSet1ChildCountSetText(Sender: TField;
      const Text: string);
    procedure ClientDataSet1Param5SetText(Sender: TField; const Text: string);
    procedure ClientDataSet2SkinSetText(Sender: TField; const Text: string);
    procedure ClientDataSet2SectionSetText(Sender: TField; const Text: string);
    procedure ClientDataSet2GroupSetText(Sender: TField; const Text: string);
    procedure ClientDataSet2PosXSetText(Sender: TField; const Text: string);
    procedure ClientDataSet2PosYSetText(Sender: TField; const Text: string);
    procedure ClientDataSet2PosZSetText(Sender: TField; const Text: string);
    procedure ClientDataSet2RotXSetText(Sender: TField; const Text: string);
    procedure ClientDataSet2RotYSetText(Sender: TField; const Text: string);
    procedure ClientDataSet2RotZSetText(Sender: TField; const Text: string);
    procedure ClientDataSet2Param1SetText(Sender: TField; const Text: string);
    procedure ClientDataSet2Param2SetText(Sender: TField; const Text: string);
    procedure ClientDataSet2Param3SetText(Sender: TField; const Text: string);
    procedure ClientDataSet2Param4SetText(Sender: TField; const Text: string);
    procedure ClientDataSet2Param5SetText(Sender: TField; const Text: string);
    procedure ClientDataSet2Param6SetText(Sender: TField; const Text: string);
    procedure Switchtab1Click(Sender: TObject);
    procedure Edit2Click(Sender: TObject);
    procedure Selection1Click(Sender: TObject);
    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGrid2KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid2MouseEnter(Sender: TObject);
    procedure DBGrid1MouseEnter(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1Click(Sender: TObject);
    procedure LookAt1Click(Sender: TObject);
    procedure LookAt2Click(Sender: TObject);
    procedure btnRedoClick(Sender: TObject);
    procedure smRedoClick(Sender: TObject);
    procedure Redo1Click(Sender: TObject);
    procedure Redo2Click(Sender: TObject);

  private
    FClosedSuccessfully: Boolean;
    procedure MenueDrawItemX(xMenu: TMenu);
    procedure SetTopCollapsed(collapsed: Boolean);
    { Private declarations }
  public
    property ClosedSuccessfully: Boolean read FClosedSuccessfully;
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
Function GetMonsterParam(monst: TMonster): tstringlist;
Function GetMonsterName(id: integer): ansistring;
procedure ClearShadow;
Function GetLanguageString(id: integer): string;
function FindClosestSection(): integer;
procedure SetMonsterDefaults();
procedure SetObjectDefaults();
procedure ShowIndicator();
procedure HideIndicator();
procedure AdjustDistanceX(target: integer);
procedure AdjustDistanceY(target: integer);
procedure AdjustDistanceZ(target: integer);
procedure CalculateWarpOffsets(rotation: dword);
function SanitizeFileName(const AFileName: string): string;
procedure SetCoordSize(size: integer);
function ReplaceTabs(const S: string): string;
procedure UpdateWindowTitle;
procedure AddRoomEntry(section: integer; x: double; y: double; z: double);
procedure SetImage1Colors;
procedure DrawPreviewState(AState: Integer);
Function LookForLabel2(s: ansistring): integer;
Function CountNumberOfWave: integer;
Function CountNumberOfGrp: integer;

var
  Form1: TForm1;
  Floor: array [0 .. 40] of TFloor;
  FloorUn: array [0 .. 20, 0 .. 40] of TFloor;
  FloorRedo: array [0 .. 20, 0 .. 40] of TFloor;
  undocount: integer = 0;
  redocount: integer = 0;
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
  lmpx, lmpy, lmdx, lmdy, mpx, mpy, mdown, mdrag, asmcount: integer;
  asmcode: array [0 .. 1000] of TAsmFnc;
  asmarg: array [0 .. 1000] of TAsmArg;
  AsmRef: array [0 .. 100000] of dword;
  AsmData: Array [0 .. 4000000] of byte;
  isdc: Boolean;
  regis: array [0 .. 255] of dword;
  AsmMode: integer;
  curepi: integer;
  ctrldw, shiftdw, altdw, ddown, fdown, sdown, xdown, zdown, firstdrop: Boolean;
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
  // Outline-mode cache (invalidated when filename changes)
  cachedOutlineFor: ansistring = '';
  cachedOutlineContours: TArray<TArray<TGPPointF>>;   // world-space XZ per contour
  cachedOutlineAvgY: TArray<Single>;
  cachedOutlineBlock: TArray<Integer>;
  cachedOutlineComponent: TArray<Integer>;
  cachedOutlineParent: TArray<Integer>;
  cachedOutlineDepth: TArray<Integer>;
  cachedOutlineCount: Integer = 0;
  cachedOutlineMinY: Single = 0;
  cachedOutlineMaxY: Single = 0;
  // Interior edges (shared between two triangles) — drawn as fine triangulation
  // inside contour-traced rooms. Flat 2N array: consecutive pairs are line segments.
  cachedOutlineInterior: TArray<TGPPointF>;
  cachedOutlineInteriorCount: Integer = 0;
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
  lastimgclick: dword = 0;
  lastloadformat: integer = 3;
  lsatsaveformat: integer = 4;
  snapvalue: integer = 10;
  distancelimit: integer = 30;
  texteditzoom: integer = 125;
  dragenabled: Boolean = false;
  snapenabled: Boolean = false;
  texttheme: integer = -1;
  autoaxis: Boolean = false;
  snaprotate: Boolean = false;
  snapyvalue: Boolean = false;
  snapdistance: Boolean = false;
  anchorenabled: Boolean = false;
  disableindicator: Boolean = false;
  fullscreen: Boolean = false;
  follow3D: Boolean = false;
  showdata: Boolean = false;
  showdecimal: Boolean = false;
  showgrid: Boolean = false;
  editgrid: Boolean = false;
  addargs: Boolean = false;
  hidenops: Boolean = true;
  hideanno: Boolean = false;
  showbitmaps: Boolean = false;
  markerbrightness: integer = 0;
  outlinewidth: integer = 1;
  countfilter: integer = 0;
  searchwholewords: Boolean = false;
  searchmatchcase: Boolean = false;
  searchengine: integer = 0;
  replaceselectiononly: Boolean = false;
  OffsetX: single = 0.0;
  OffsetY: single = 0.0;
  OffsetZ: single = 0.0;
  DefaultSect: integer = 0;
  DefaultX: single = 0.0;
  DefaultY: single = 0.0;
  DefaultZ: single = 0.0;
  warpx, warpz: single;
  TEHeight: integer = 673;
  TEWidth: integer = 810;
  TEState: integer = Ord(wsNormal);
  NotesWidth: integer = 183;
  NotesVisible: Boolean = false;
  MinimapVisible: Boolean = false;
  scriptline: integer = 0;
  scriptindex: integer = 0;
  importscan: Boolean = false;
  coordsize: integer = 0;
  thememodified: Boolean = false;
  inedit: Boolean = false;
  inundo: Boolean = false;
  indelete: Boolean = false;
  placerandom: Boolean = false;
  placelookat: Boolean = false;
  placerotation: integer = 0;
  darkmode: Boolean = false;
  mapRenderMode: integer = 0; // 0=wireframe (every triangle outlined), 1=topographic (height-tinted contours + interior triangulation)
  topoHeightShading: Boolean = false; // when off, topo floors use a flat neutral fill and the height legend is hidden
  topCollapsed: Boolean = false;
  previewstate: integer = 0;
  previewstring: string;
  previewpaused: Boolean = false;
  settingstring: string;
  actionstring: string;
  delaystring: string;
  mapwave: integer = -1;

  prevsection: integer = 0;
  prevwave: integer = -1;
  prevgroup: integer = -1;
  prevmwave: integer = 0;
  prevroomID: integer = 0;
  prevfloor: integer = 0;
  prevx: integer = 0;
  prevy: integer = 0;
  prevzoom: double = 5.0;
  prevppx, prevppy, prevppz, prevvr, prevvz: single;

  BMPCache: TDictionary<string, TBitmap>;
  selectionBMP: TBitmap;
  objloaded: Boolean = false;
  unusedlabel: Boolean = false;

  lastmonstersort: string = '';
  lastobjsort: string = '';
  decmonstsort: Boolean = false;
  decobjsort: Boolean = false;
  grid1col: integer = 0;
  grid2col: integer = 0;
  gridtype: integer = -1;
  monstgridfocused: Boolean = false;
  objgridfocused: Boolean = false;

implementation

uses FTitle, FInfo, Unit1, FScrypt, TCom, FSetting, FEdit, Unit8, Unit9,
  Unit10, Unit11, PikaPackage, Unit12, Unit13, Unit14, Unit15, Unit16,
  Unit17, Unit18, Unit19, FCompat, MyConst, Unit29, crc32, EnemyStat,
  FEnemyAttack, FEnemyMov, FEnemyResist, FFloatEdit, NPCBuild, Unit22,
  FFFilter, FMonsDet, Unit23, FSymbolChat, FAsmModeSel, FPlacement, FHotkeys,
  FSnap, FScriptTE, FReplace, FRotation, FThemes, FMonsType, FVector, FGoTo,
  FAddRoom;

{$R *.dfm}

function TForm1.SectionToMouseX(idx: integer; etype: integer): double;
var
  px, py, px2, py2: double;
begin
  if extractfilename(mapfilenam) = 'map_boss03c.rel' then
  begin
    MidP[0].y := 0;
  end;
  if etype = 1 then
  begin
    px2 := Floor[sfloor].Monster[idx].Pos_X / Zoom;
    py2 := Floor[sfloor].Monster[idx].Pos_Y / Zoom;
    px := cos(-rev[Floor[sfloor].Monster[idx].map_section] / 10430.37835) * px2 -
      sin(-rev[Floor[sfloor].Monster[idx].map_section] / 10430.37835) * py2;
    py := sin(-rev[Floor[sfloor].Monster[idx].map_section] / 10430.37835) * px2 +
      cos(-rev[Floor[sfloor].Monster[idx].map_section] / 10430.37835) * py2;

    px2 := mpx;
    px2 := px2 / Zoom;
    px := px + mmx + MidP[Floor[sfloor].Monster[idx].map_section].x + px2;
    px2 := mpy;
    px2 := px2 / Zoom;
    py := py + mmy + MidP[Floor[sfloor].Monster[idx].map_section].y + px2;
  end;
  if etype = 2 then
  begin
    px2 := Floor[sfloor].Obj[idx].Pos_X / Zoom;
    py2 := Floor[sfloor].Obj[idx].Pos_Y / Zoom;
    px := cos(-rev[Floor[sfloor].Obj[idx].map_section] / 10430.37835) * px2 -
      sin(-rev[Floor[sfloor].Obj[idx].map_section] / 10430.37835) * py2;
    py := sin(-rev[Floor[sfloor].Obj[idx].map_section] / 10430.37835) * px2 +
      cos(-rev[Floor[sfloor].Obj[idx].map_section] / 10430.37835) * py2;

    px2 := mpx;
    px2 := px2 / Zoom;
    px := px + mmx + MidP[Floor[sfloor].Obj[idx].map_section].x + px2;
    px2 := mpy;
    px2 := px2 / Zoom;
    py := py + mmy + MidP[Floor[sfloor].Obj[idx].map_section].y + px2;
  end;
  result := px;
end;

function TForm1.SectionToMouseY(idx: integer; etype: integer): double;
var
  px, py, px2, py2: double;
begin
  if extractfilename(mapfilenam) = 'map_boss03c.rel' then
  begin
    MidP[0].y := 0;
  end;
  if etype = 1 then
  begin
    px2 := Floor[sfloor].Monster[idx].Pos_X / Zoom;
    py2 := Floor[sfloor].Monster[idx].Pos_Y / Zoom;
    px := cos(-rev[Floor[sfloor].Monster[idx].map_section] / 10430.37835) * px2 -
      sin(-rev[Floor[sfloor].Monster[idx].map_section] / 10430.37835) * py2;
    py := sin(-rev[Floor[sfloor].Monster[idx].map_section] / 10430.37835) * px2 +
      cos(-rev[Floor[sfloor].Monster[idx].map_section] / 10430.37835) * py2;

    px2 := mpx;
    px2 := px2 / Zoom;
    px := px + mmx + MidP[Floor[sfloor].Monster[idx].map_section].x + px2;
    px2 := mpy;
    px2 := px2 / Zoom;
    py := py + mmy + MidP[Floor[sfloor].Monster[idx].map_section].y + px2;
  end;
  if etype = 2 then
  begin
    px2 := Floor[sfloor].Obj[idx].Pos_X / Zoom;
    py2 := Floor[sfloor].Obj[idx].Pos_Y / Zoom;
    px := cos(-rev[Floor[sfloor].Obj[idx].map_section] / 10430.37835) * px2 -
      sin(-rev[Floor[sfloor].Obj[idx].map_section] / 10430.37835) * py2;
    py := sin(-rev[Floor[sfloor].Obj[idx].map_section] / 10430.37835) * px2 +
      cos(-rev[Floor[sfloor].Obj[idx].map_section] / 10430.37835) * py2;

    px2 := mpx;
    px2 := px2 / Zoom;
    px := px + mmx + MidP[Floor[sfloor].Obj[idx].map_section].x + px2;
    px2 := mpy;
    px2 := px2 / Zoom;
    py := py + mmy + MidP[Floor[sfloor].Obj[idx].map_section].y + px2;
  end;
  result := py;
end;

Procedure TForm1.LookAt2D(idx: integer; eType: integer; targetX: double; targetY: double);
var
  px, py, px2, py2, rad, diffX, diffY: double;
  angle, mapsection, mouseAngle: integer;
begin
    if placelookat then
    begin
      form1.SetUndow;
      isedited := true;
    end;

    if eType = 1 then
    begin
      mapsection := Floor[sfloor].Monster[idx].map_section;
      if extractfilename(mapfilenam) = 'map_boss03c.rel' then
        MidP[0].y := 0;
      px2 := Floor[sfloor].Monster[idx].Pos_X / Zoom;
      py2 := Floor[sfloor].Monster[idx].Pos_Y / Zoom;
      px := cos(-rev[mapsection] / 10430.37835) * px2 -
        sin(-rev[mapsection] / 10430.37835) * py2;
      py := sin(-rev[mapsection] / 10430.37835) * px2 +
        cos(-rev[mapsection] / 10430.37835) * py2;
      px2 := mpx / Zoom;
      px := px + mmx + MidP[mapsection].x + px2;
      px2 := mpy / Zoom;
      py := py + mmy + MidP[mapsection].y + px2;
    end;
    if eType = 2 then
    begin
      mapsection := Floor[sfloor].Obj[idx].map_section;
      if extractfilename(mapfilenam) = 'map_boss03c.rel' then
        MidP[0].y := 0;
      px2 := Floor[sfloor].Obj[idx].Pos_X / Zoom;
      py2 := Floor[sfloor].Obj[idx].Pos_Y / Zoom;
      px := cos(-rev[mapsection] / 10430.37835) * px2 -
        sin(-rev[mapsection] / 10430.37835) * py2;
      py := sin(-rev[mapsection] / 10430.37835) * px2 +
        cos(-rev[mapsection] / 10430.37835) * py2;
      px2 := mpx / Zoom;
      px := px + mmx + MidP[mapsection].x + px2;
      px2 := mpy / Zoom;
      py := py + mmy + MidP[mapsection].y + px2;
    end;

    diffX := targetX - px;
    diffY := targetY - py;
    rad := ArcTan2(diffY, diffX);

    mouseAngle := Round(rad * 10430.37835);
    mouseAngle := mouseAngle - 16384;

    angle := -mouseAngle - rev[mapSection];

    angle := angle mod 65536;
    if angle < 0 then
      angle := angle + 65536;

    if eType = 1 then
    begin
      Floor[sfloor].Monster[idx].Direction := angle;
      if have3d then
        GenerateMonsterName(Floor[sfloor].Monster[idx],idx,2)
    end
    else if eType = 2 then
    begin
      Floor[sfloor].Obj[idx].unknow6 := angle;
      if have3d then
      begin
         myobj[idx].Free;
         Generateobj(Floor[sfloor].obj[idx],idx);
      end;
    end;

    if placelookat then
    begin
      placelookat := false;
      HideIndicator;
      form1.DrawMap;
    end;
    form1.LoadFloorGrids;
end;

procedure TForm1.UpdateSnapPolygonChildren(polygon: TObj);
var
  i: integer;
  localOffsetX, localOffsetY: double;
  parentScale, parentRot: double;
  scaledOffsetX, scaledOffsetY: double;
  worldOffsetX, worldOffsetY: double;
  px, py: double;
begin
  parentScale := polygon.unknow8 * 20.0;
  parentRot := -polygon.unknow6 / 10430.37835;

  // Update all monsters that are children
  for i := 0 to Floor[sfloor].MonsterCount - 1 do
  begin
    if Floor[sfloor].Monster[i].unknow4 = polygon.id then
    begin
      Floor[sfloor].Monster[i].map_section := polygon.map_section;

      // Get stored local offset percentages
      localOffsetX := SmallInt(Floor[sfloor].Monster[i].Unknow1) / 100.0;
      localOffsetY := SmallInt(Floor[sfloor].Monster[i].unknow2 and $ffff) / 100.0;

      // Scale by current parent scale
      scaledOffsetX := localOffsetX * parentScale;
      scaledOffsetY := localOffsetY * parentScale;

      // Rotate by current parent rotation
      worldOffsetX := cos(parentRot) * scaledOffsetX - sin(parentRot) * scaledOffsetY;
      worldOffsetY := sin(parentRot) * scaledOffsetX + cos(parentRot) * scaledOffsetY;

      // Apply to child position
      Floor[sfloor].Monster[i].Pos_X := polygon.Pos_X + worldOffsetX;
      Floor[sfloor].Monster[i].Pos_Y := polygon.Pos_Y + worldOffsetY;

      // Re-snap to the closest point
      px := Floor[sfloor].Monster[i].Pos_X;
      py := Floor[sfloor].Monster[i].Pos_Y;
      if TrySnapToPolygon(
        px,
        py,
        polygon,
        Double.MaxValue,
        Floor[sfloor].Monster[i].map_section
      ) then
      begin
        Floor[sfloor].Monster[i].Pos_X := px;
        Floor[sfloor].Monster[i].Pos_Y := py;
      end;

      // Update orientation
      if polygon.Action = 1 then
        LookAt2D(i, 1, SectionToMouseX(selected, 2), SectionToMouseY(selected, 2));

      // Update Y position
      if polygon.unknow13 = 1 then
        Floor[sfloor].Monster[i].Pos_Z := polygon.Pos_Z;

      if have3d then
        GenerateMonsterName(Floor[sfloor].Monster[i],i,2);
    end;
  end;

  // Update all objects that are children
  for i := 0 to Floor[sfloor].ObjCount - 1 do
  begin
    if (Floor[sfloor].Obj[i].id = polygon.id) and (i <> selected) then
    begin
      Floor[sfloor].Obj[i].map_section := polygon.map_section;

      // Get stored local offset percentages
      localOffsetX := SmallInt(Floor[sfloor].Obj[i].Unknow1) / 100.0;
      localOffsetY := SmallInt(Floor[sfloor].Obj[i].unknow2 and $ffff) / 100.0;

      // Scale by current parent scale
      scaledOffsetX := localOffsetX * parentScale;
      scaledOffsetY := localOffsetY * parentScale;

      // Rotate by current parent rotation
      worldOffsetX := cos(parentRot) * scaledOffsetX - sin(parentRot) * scaledOffsetY;
      worldOffsetY := sin(parentRot) * scaledOffsetX + cos(parentRot) * scaledOffsetY;

      // Apply to child position
      Floor[sfloor].Obj[i].Pos_X := polygon.Pos_X + worldOffsetX;
      Floor[sfloor].Obj[i].Pos_Y := polygon.Pos_Y + worldOffsetY;

      // Re-snap to the closest point
      px := Floor[sfloor].Obj[i].Pos_X;
      py := Floor[sfloor].Obj[i].Pos_Y;
      if TrySnapToPolygon(
        px,
        py,
        polygon,
        Double.MaxValue,
        Floor[sfloor].Obj[i].map_section
      ) then
      begin
        Floor[sfloor].Obj[i].Pos_X := px;
        Floor[sfloor].Obj[i].Pos_Y := py;
      end;

      // Update orientation
      if polygon.Action = 1 then
        LookAt2D(i, 2, SectionToMouseX(selected, 2), SectionToMouseY(selected, 2));

      // Update Y position
      if polygon.unknow13 = 1 then
        Floor[sfloor].Obj[i].Pos_Z := polygon.Pos_Z;

      if have3d then
      begin
         myobj[i].Free;
         Generateobj(Floor[sfloor].obj[i],i);
      end;
    end;
  end;
end;

function GetEdgeSnapPoints(edge: TPolygonEdge; snapMode: integer): TSnapPoints;
var
  i, numPoints: integer;
  t: double;
  dx, dy: double;
begin
  dx := edge.X2 - edge.X1;
  dy := edge.Y2 - edge.Y1;

  case snapMode of
    -1: // Snap anywhere
    begin
      SetLength(Result, 0);
    end;

    0: // Snap only to corners
    begin
      SetLength(Result, 2);
      Result[0].X := edge.X1;
      Result[0].Y := edge.Y1;
      Result[1].X := edge.X2;
      Result[1].Y := edge.Y2;
    end;

    else // Snap to corners + n-points per edge
    begin
      numPoints := snapMode + 2;
      SetLength(Result, numPoints);

      for i := 0 to numPoints - 1 do
      begin
        t := i / (numPoints - 1);
        Result[i].X := edge.X1 + t * dx;
        Result[i].Y := edge.Y1 + t * dy;
      end;
    end;
  end;
end;

function GeneratePolygonVertices(rotation: integer; scale: double; sides: integer): TPolygonVertices;
var
  i: integer;
  angle, angleStep: double;
begin
  SetLength(Result, sides);

  // Angle between each vertex
  angleStep := (2 * Pi) / sides;

  for i := 0 to sides - 1 do
  begin
    // Calculate angle for this vertex, adjusted by rotation
    angle := (i * angleStep) + ((rotation) / 10430.37835);

    // Calculate vertex position
    // Starting at top (negative Y) by default
    Result[i].X := sin(angle) * scale * 20;
    Result[i].Y := -cos(angle) * scale * 20;  // Negative because screen Y is inverted
  end;
end;

procedure DrawPolygon(Canvas: TCanvas; obj: TObj; centerX: double; centerY: double);
var
  vertices: TPolygonVertices;
  screenPoints: array of TPoint;
  i: integer;
  OldPenColor: TColor;
  OldPenWidth: integer;
  OldBrushStyle: TBrushStyle;
begin
  // Save the original canvas state
  OldPenColor := Canvas.Pen.Color;
  OldPenWidth := Canvas.Pen.Width;
  OldBrushStyle := Canvas.Brush.Style;

  // Generate polygon in local space (relative to object center)
  vertices := GeneratePolygonVertices(
    obj.unknow6 - rev[obj.map_section], // Rotation value
    obj.unknow8, // Scale/radius
    obj.obj_id   // Number of sides
  );

  SetLength(screenPoints, Length(vertices) + 1);

  // Transform each vertex to screen space
  for i := 0 to High(vertices) do
  begin
    screenPoints[i].X := Round(centerX + (vertices[i].X / Zoom));
    screenPoints[i].Y := Round(centerY + (vertices[i].Y / Zoom));
  end;

  // Close the shape
  screenPoints[High(screenPoints)] := screenPoints[0];

  // Draw the polygon
  Canvas.Pen.Color := clPurple;
  Canvas.Pen.Width := 2;
  Canvas.Brush.Style := bsClear;
  Canvas.Polyline(screenPoints);

  // Restore the canvas
  Canvas.Pen.Color := OldPenColor;
  Canvas.Pen.Width := OldPenWidth;
  Canvas.Brush.Style := OldBrushStyle;
end;

procedure DrawStar(Canvas: TCanvas; CenterX, CenterY: Double; OuterRadius: Double;
                   Filled: Boolean = True);
var
  Points: array[0..9] of TPoint;
  i: Integer;
  angle: Double;
  InnerRadius: Double;
begin
  InnerRadius := OuterRadius * 0.382;

  // Generate 10 points (5 outer, 5 inner) for a 5-pointed star
  for i := 0 to 9 do
  begin
    angle := (i * 36 - 90) * Pi / 180; // 36 degrees between points
    if i mod 2 = 0 then
      // Outer
      Points[i] := Point(Round(CenterX + OuterRadius * Cos(angle)),
                        Round(CenterY + OuterRadius * Sin(angle)))
    else
      // Inner
      Points[i] := Point(Round(CenterX + InnerRadius * Cos(angle)),
                        Round(CenterY + InnerRadius * Sin(angle)));
  end;

  if Filled then
    Canvas.Polygon(Points)
  else
    Canvas.Polyline(Points);
end;

function GetPolygonEdgesWorldSpace(obj: TObj; applyMapRotation: boolean): TPolygonEdges;
var
  vertices: TPolygonVertices;
  i: integer;
  worldX, worldY, px, py: double;
begin
  vertices := GeneratePolygonVertices(
    obj.unknow6 - rev[obj.map_section],
    obj.unknow8,
    obj.obj_id
  );

  SetLength(Result, Length(vertices));

  for i := 0 to High(vertices) do
  begin
    if applyMapRotation then
    begin
      // Transform vertex by map section rotation
      px := vertices[i].X;
      py := vertices[i].Y;
      worldX := cos(-rev[obj.map_section] / 10430.37835) * px -
                sin(-rev[obj.map_section] / 10430.37835) * py;
      worldY := sin(-rev[obj.map_section] / 10430.37835) * px +
                cos(-rev[obj.map_section] / 10430.37835) * py;

      // Add object's world position
      Result[i].X1 := worldX + obj.Pos_X;
      Result[i].Y1 := worldY + obj.Pos_Y;

      // Next vertex
      px := vertices[(i + 1) mod Length(vertices)].X;
      py := vertices[(i + 1) mod Length(vertices)].Y;
      worldX := cos(-rev[obj.map_section] / 10430.37835) * px -
                sin(-rev[obj.map_section] / 10430.37835) * py;
      worldY := sin(-rev[obj.map_section] / 10430.37835) * px +
                cos(-rev[obj.map_section] / 10430.37835) * py;

      Result[i].X2 := worldX + obj.Pos_X;
      Result[i].Y2 := worldY + obj.Pos_Y;
    end
    else
    begin
      // No rotation
      Result[i].X1 := vertices[i].X + obj.Pos_X;
      Result[i].Y1 := vertices[i].Y + obj.Pos_Y;
      Result[i].X2 := vertices[(i + 1) mod Length(vertices)].X + obj.Pos_X;
      Result[i].Y2 := vertices[(i + 1) mod Length(vertices)].Y + obj.Pos_Y;
    end;
  end;
end;

procedure DrawPolygonSnapPoints(Canvas: TCanvas; obj: TObj; centerX: double; centerY: double);
var
  edges: TPolygonEdges;
  snapPoints: TSnapPoints;
  i, j: integer;
  screenX, screenY: integer;
  snapMode: integer;
  OldPenColor: TColor;
begin
  snapMode := obj.unknow14;

  if snapMode = -1 then
    Exit;

  OldPenColor := Canvas.Pen.Color;

  edges := GetPolygonEdgesWorldSpace(obj, false);

  Canvas.Pen.Color := clBlue;

  for i := 0 to High(edges) do
  begin
    snapPoints := GetEdgeSnapPoints(edges[i], snapMode);

    for j := 0 to High(snapPoints) do
    begin
      // Transform to screen space
      screenX := Round(centerX + ((snapPoints[j].X - obj.Pos_X) / Zoom));
      screenY := Round(centerY + ((snapPoints[j].Y - obj.Pos_Y) / Zoom));

      // Draw each point as a cross shape
      Canvas.MoveTo(screenX - 3, screenY);
      Canvas.LineTo(screenX + 4, screenY);
      Canvas.MoveTo(screenX, screenY - 3);
      Canvas.LineTo(screenX, screenY + 4);
    end;
  end;

  Canvas.Pen.Color := OldPenColor;
end;

function TForm1.TrySnapToPolygon(var targetX, targetY: double; polyObj: TObj;
                          snapThreshold: double; targetMapSection: integer): boolean;
var
  edges: TPolygonEdges;
  snapPoints: TSnapPoints;
  i, j: integer;
  minDist, dist, t, dx, dy: double;
  closestEdgeIdx: integer;
  snapX, snapY: double;
  snapMode: integer;
begin
  Result := False;

  // Only snap if in the same map section
  if polyObj.map_section <> targetMapSection then
    Exit;

  edges := GetPolygonEdgesWorldSpace(polyObj, true);
  snapMode := polyObj.unknow14;
  minDist := Double.MaxValue;
  closestEdgeIdx := -1;

  // -1: Edge-only snapping
  if snapMode = -1 then
  begin
    for i := 0 to High(edges) do
    begin
      dx := edges[i].X2 - edges[i].X1;
      dy := edges[i].Y2 - edges[i].Y1;

      if (dx = 0) and (dy = 0) then
        Continue;

      t := ((targetX - edges[i].X1) * dx + (targetY - edges[i].Y1) * dy) / (dx * dx + dy * dy);

      if t < 0 then t := 0
      else if t > 1 then t := 1;

      snapX := edges[i].X1 + t * dx;
      snapY := edges[i].Y1 + t * dy;

      dist := sqrt(sqr(targetX - snapX) + sqr(targetY - snapY));

      if dist < minDist then
      begin
        minDist := dist;
        closestEdgeIdx := i;
      end;
    end;

    if (closestEdgeIdx >= 0) and (minDist <= snapThreshold) then
    begin
      dx := edges[closestEdgeIdx].X2 - edges[closestEdgeIdx].X1;
      dy := edges[closestEdgeIdx].Y2 - edges[closestEdgeIdx].Y1;
      t := ((targetX - edges[closestEdgeIdx].X1) * dx + (targetY - edges[closestEdgeIdx].Y1) * dy) / (dx * dx + dy * dy);
      t := Max(0, Min(1, t));

      targetX := edges[closestEdgeIdx].X1 + t * dx;
      targetY := edges[closestEdgeIdx].Y1 + t * dy;
      Result := True;
    end;
  end
  else
  // 0 or positive: Snap to points
  begin
    for i := 0 to High(edges) do
    begin
      snapPoints := GetEdgeSnapPoints(edges[i], snapMode);

      for j := 0 to High(snapPoints) do
      begin
        dist := sqrt(sqr(targetX - snapPoints[j].X) + sqr(targetY - snapPoints[j].Y));

        if dist < minDist then
        begin
          minDist := dist;
          snapX := snapPoints[j].X;
          snapY := snapPoints[j].Y;
        end;
      end;
    end;

    if minDist <= snapThreshold then
    begin
      targetX := snapX;
      targetY := snapY;
      Result := True;
    end;
  end;
end;

Procedure ShowGrids;
begin
  form1.label2.Visible := false;
  form1.label3.Visible := false;
  form1.ListBox1.Visible := false;
  form1.ListBox2.Visible := false;
  form1.Sort1.Visible := false;
  form1.PageControl1.Visible := true;
  form1.Lists1.Checked := false;
  form1.Grids1.Checked := true;
  form1.Switchgridtab1.Enabled := true;
  form1.Gridmode1.Visible := true;
  if selected > -1 then
  begin
    if sType = 1 then
      form1.PageControl1.ActivePage := form1.tabsheet1;
    if sType = 2 then
      form1.PageControl1.ActivePage := form1.tabsheet2;
    gridtype := sType;
  end;
  form1.LoadFloorGrids;
end;

Procedure HideGrids;
begin
  form1.label2.Visible := true;
  form1.label3.Visible := true;
  form1.ListBox1.Visible := true;
  form1.ListBox2.Visible := true;
  form1.Sort1.Visible := true;
  form1.PageControl1.Visible := false;
  form1.Lists1.Checked := true;
  form1.Grids1.Checked := false;
  form1.Switchgridtab1.Enabled := false;
  form1.Gridmode1.Visible := false;
  form1.DBGrid1.Options := form1.DBGrid1.Options - [dgMultiSelect];
  form1.DBGrid2.Options := form1.DBGrid2.Options - [dgMultiSelect];
end;

Procedure DisableGridEdit;
begin
  with form1 do
  begin
    DBGrid1.Options := DBGrid1.Options + [dgRowSelect];
    DBGrid1.Options := DBGrid1.Options - [dgEditing];
    DBGrid2.Options := DBGrid2.Options + [dgRowSelect];
    DBGrid2.Options := DBGrid2.Options - [dgEditing];
    DBGrid1.ReadOnly := true;
    DBGrid2.ReadOnly := true;
    Rowselection1.Checked := true;
    Selection1.Checked := true;
    Celledit1.Checked := false;
    Edit2.Checked := false;
  end;
end;

Procedure EnableGridEdit;
begin
  with form1 do
  begin
    DBGrid1.Options := DBGrid1.Options - [dgRowSelect];
    DBGrid1.Options := DBGrid1.Options + [dgEditing];
    DBGrid2.Options := DBGrid2.Options - [dgRowSelect];
    DBGrid2.Options := DBGrid2.Options + [dgEditing];
    DBGrid1.ReadOnly := false;
    DBGrid2.ReadOnly := false;
    Rowselection1.Checked := false;
    Selection1.Checked := false;
    Celledit1.Checked := true;
    Edit2.Checked := true;
    if grid1col < 2 then
      grid1col := 2;
    if grid2col < 2 then
      grid2col := 2;
    DBGrid1.SelectedIndex := grid1col;
    DBGrid2.SelectedIndex := grid2col;
  end;
end;

Procedure SetBrightness(value: integer);
var
  Reg: TRegistry;
begin
  markerbrightness := value;

  form1.Default1.Checked := false;
  form1.High1.Checked := false;
  form1.Veryhigh1.Checked := false;

  if value = 1 then
    form1.High1.Checked := true
  else if value = 2 then
    form1.Veryhigh1.Checked := true
  else
    form1.Default1.Checked := true;

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\schthack\qedit', true) then
    begin
      Reg.WriteInteger('MarkerBrightness', value);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;

  form1.DrawMap;
end;

Function GetMonsterColor(value: integer): TColor;
begin
  if darkmode then
  begin
    if value = 1 then result := RGB(190, 70, 70)      // High
    else if value = 2 then result := RGB(210, 85, 85) // Very High
    else result := RGB(170, 55, 55);                  // Default
  end
  else
  begin
    if value = 1 then result := RGB(255, 100, 100)     // High
    else if value = 2 then result := RGB(255, 160, 160) // Very High
    else result := clRed;                              // Default
  end;
end;

Function GetObjectColor(value: integer): TColor;
begin
  if darkmode then
  begin
    if value = 1 then result := RGB(50, 130, 75)      // High
    else if value = 2 then result := RGB(60, 150, 90) // Very High
    else result := RGB(40, 110, 60);                  // Default
  end
  else
  begin
    if value = 1 then result := RGB(0, 180, 0)        // High
    else if value = 2 then result := RGB(0, 220, 50)  // Very High
    else result := clGreen;                           // Default
  end;
end;

Function GetSpawnColor(value: integer): TColor;
begin
  if darkmode then
  begin
    if value = 1 then result := RGB(210, 120, 45)     // High
    else if value = 2 then result := RGB(230, 140, 60) // Very High
    else result := RGB(190, 100, 30);                 // Default
  end
  else
  begin
    if value = 1 then result := RGB(255, 150, 0)      // High
    else if value = 2 then result := RGB(255, 180, 30) // Very High
    else result := $018AFF;                           // Default
  end;
end;

Procedure SetOutlineWidth(value: integer);
var
  Reg: TRegistry;
begin
  outlinewidth := value;

  form1.Width1.Checked := false;
  form1.Width2.Checked := false;
  form1.Width3.Checked := false;

  if value = 2 then
    form1.Width2.Checked := true
  else if value = 3 then
    form1.Width3.Checked := true
  else
    form1.Width1.Checked := true;

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\schthack\qedit', true) then
    begin
      Reg.WriteInteger('OutlineWidth', value);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;

  form1.DrawMap;
end;

Procedure SetAutoHotkeys;
begin
  form1.MainMenu1.AutoHotkeys := maAutomatic;
  form1.PopupMenu1.AutoHotkeys := maAutomatic;
  form1.PopupMenu2.AutoHotkeys := maAutomatic;
  form1.PopupMenu3.AutoHotkeys := maAutomatic;
  form1.PopupMenu4.AutoHotkeys := maAutomatic;
  form1.popupMonsters.AutoHotkeys := maAutomatic;
  form1.popupObjects.AutoHotkeys := maAutomatic;
  form1.popupGrid.AutoHotkeys := maAutomatic;
  form4.PopupMenu1.AutoHotkeys := maAutomatic;
  form13.popupWave.AutoHotkeys := maAutomatic;
  form13.popupGroup.AutoHotkeys := maAutomatic;
  form15.PopupMenu1.AutoHotKeys := maAutomatic;
  form15.PopupMenu2.AutoHotKeys := maAutomatic;
  form15.PopupMenu3.AutoHotKeys := maAutomatic;
  form15.PopupMenu4.AutoHotKeys := maAutomatic;
  fmScriptTE.MainMenu1.AutoHotkeys := maAutomatic;
  fmScriptTE.PopupMenu1.AutoHotkeys := maAutomatic;
  fmScriptTE.PopupMenu2.AutoHotkeys := maAutomatic;
end;

Procedure SetManualHotkeys;
begin
  form1.MainMenu1.AutoHotkeys := maManual;
  form1.PopupMenu1.AutoHotkeys := maManual;
  form1.PopupMenu2.AutoHotkeys := maManual;
  form1.PopupMenu3.AutoHotkeys := maManual;
  form1.PopupMenu4.AutoHotkeys := maManual;
  form1.popupMonsters.AutoHotkeys := maManual;
  form1.popupObjects.AutoHotkeys := maManual;
  form1.popupGrid.AutoHotkeys := maManual;
  form4.PopupMenu1.AutoHotkeys := maManual;
  form13.popupWave.AutoHotkeys := maManual;
  form13.popupGroup.AutoHotkeys := maManual;
  form15.PopupMenu1.AutoHotKeys := maManual;
  form15.PopupMenu2.AutoHotKeys := maManual;
  form15.PopupMenu3.AutoHotKeys := maManual;
  form15.PopupMenu4.AutoHotKeys := maManual;
  fmScriptTE.MainMenu1.AutoHotkeys := maManual;
  fmScriptTE.PopupMenu1.AutoHotkeys := maManual;
  fmScriptTE.PopupMenu2.AutoHotkeys := maManual;
end;

Procedure UncheckLanguages;
begin
  form1.English1.Checked := false;
  form1.French1.Checked := false;
  form1.Spanish1.Checked := false;
  form1.Russian1.Checked := false;
  form1.Japanese1.Checked := false;
  SetAutoHotkeys;
end;

Procedure LoadLanguageStrings(ms: TMemoryStream);
begin
    // Load from the stream based on encoding
    try
      ms.Position := 0;
      LanguageString.LoadFromStream(ms, TEncoding.UTF8);
    except
      begin
        ms.Position := 0;
        LanguageString.LoadFromStream(ms)
      end;
    end;
end;

Procedure SetInterfaceText;
var
  width, start, idx: integer;
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
  form1.Switchgridtab1.Caption := GetLanguageString(523);
  form1.Gridmode1.Caption := GetLanguageString(524);
  form1.Rowselection1.Caption := GetLanguageString(525);
  form1.Celledit1.Caption := GetLanguageString(526);
  form1.Switchtab1.Caption := GetLanguageString(523);
  form1.Gridmode2.Caption := GetLanguageString(524);
  form1.Selection1.Caption := GetLanguageString(525);
  form1.Edit2.Caption := GetLanguageString(526);
  form1.LookAt1.Caption := GetLanguageString(527);
  form1.btnRedo.Caption := GetLanguageString(529);
  form1.smRedo.Caption := GetLanguageString(529);
  form21.Button1.Caption := GetLanguageString(116);
  form21.Button2.Caption := GetLanguageString(117);
  form21.Button3.Caption := GetLanguageString(118);
  form21.Caption := GetLanguageString(119);
  form27.Caption := GetLanguageString(120);
  form27.Label1.Caption := GetLanguageString(121);
  form27.Button1.Caption := GetLanguageString(113);
  form27.Clearunusedlabels1.Caption := GetLanguageString(512);
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
  form26.Caption := GetLanguageString(144);
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
  form12.Button2.Caption := GetLanguageString(155);
  form12.Button3.Caption := GetLanguageString(154);
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
  form22.lblAttack.Caption := GetLanguageString(499);
  form22.Button1.Caption := GetLanguageString(118);
  form22.Button2.Caption := GetLanguageString(483);

  form26.Button2.Caption := GetLanguageString(118);
  form26.Button1.Caption := GetLanguageString(117);

  form29.Caption := GetLanguageString(293);
  form29.Memo2.Text := GetLanguageString(292);
  form29.Button1.Caption := GetLanguageString(113);
  form29.Button2.Caption := GetLanguageString(118);

  fmRotation.Caption := GetLanguageString(299);
  fmRotation.chkAutoAxis.Caption := GetLanguageString(300);
  form7.chkAutoAxis.Caption := GetLanguageString(300);

  fmThemes.Caption := GetLanguageString(302);

  form1.Settheme1.Caption := GetLanguageString(301);
  Form1.Exporttextfortranslation1.Caption := GetLanguageString(294);
  Form1.Importtextfromtranslation1.Caption := GetLanguageString(295);
  Form1.Button14.Caption := GetLanguageString(298);
  form1.Texteditor1.Caption := GetLanguageString(303);
  form1.Floor1.Caption := GetLanguageString(304);
  form1.Sort1.Caption := GetLanguageString(305);
  form1.Sort2.Caption := GetLanguageString(305);
  form1.Sort3.Caption := GetLanguageString(305);
  form1.Monster1.Caption := GetLanguageString(306);
  form1.Objects1.Caption := GetLanguageString(307);
  form1.Monstercount1.Caption := GetLanguageString(324);
  form1.byRoom1.Caption := GetLanguageString(308);
  form1.byRoom2.Caption := GetLanguageString(308);
  form1.byWave1.Caption := GetLanguageString(309);
  form1.byGroup1.Caption := GetLanguageString(310);
  form1.byType1.Caption := GetLanguageString(311);
  form1.byType2.Caption := GetLanguageString(311);
  form1.byRoom3.Caption := GetLanguageString(308);
  form1.byRoom4.Caption := GetLanguageString(308);
  form1.byWave2.Caption := GetLanguageString(309);
  form1.byGroup2.Caption := GetLanguageString(310);
  form1.byType3.Caption := GetLanguageString(311);
  form1.byType4.Caption := GetLanguageString(311);
  form1.Exportdata1.Caption := GetLanguageString(312);
  form1.Importdata1.Caption := GetLanguageString(313);
  form1.Events1.Caption := GetLanguageString(314);
  form1.Previewevents1.Caption := GetLanguageString(315);
  form1.Randommonsters1.Caption := GetLanguageString(316);
  form1.EnemyWave1.Caption := GetLanguageString(333);
  form1.Itemsgroupe1.Caption := GetLanguageString(334);
  form1.smNew.Caption := GetLanguageString(335);
  form1.smNewMonster.Caption := GetLanguageString(336);
  form1.smNewItem.Caption := GetLanguageString(337);
  form1.Copylastmonster1.Caption := GetLanguageString(338);
  form1.Copylastitem1.Caption := GetLanguageString(339);
  form1.smDelete.Caption := GetLanguageString(42);
  form1.smEdit.Caption := GetLanguageString(122);
  form1.smMove.Caption := GetLanguageString(44);
  form1.smUndo.Caption := GetLanguageString(45);
  form1.smDrag.Caption := GetLanguageString(340);
  form1.Options2.Caption := GetLanguageString(341);
  form1.smPlacement.Caption := GetLanguageString(342);
  form1.smSnapOptions.Caption := GetLanguageString(343);
  Form1.lblStatus.Caption := GetLanguageString(425);
  form1.lblModifiers.Caption := GetLanguageString(426);
  form1.smDisableIndicator.Caption := GetLanguageString(481);
  form1.lblPreview.Caption := #8592 + GetLanguageString(327) + '  |  ' +
                              #8594 + GetLanguageString(328) + '  |  ' +
                                      GetLanguageString(329) + '  |  ' +
                                      GetLanguageString(330);
  form1.ComboBox1.Items.Strings[0] := GetLanguageString(466);
  form1.ComboBox1.ItemIndex := 0;
  form1.showbmp.Caption := GetLanguageString(505);
  form1.Markerbrightness1.Caption := GetLanguageString(507);
  form1.Default1.Caption := GetLanguageString(508);
  form1.High1.Caption := GetLanguageString(509);
  form1.Veryhigh1.Caption := GetLanguageString(510);
  form1.Outlinewidth1.Caption := GetLanguageString(511);
  form1.Width1.Caption := GetLanguageString(508) + ' (1 px)';
  form1.Transform1.Caption := GetLanguageString(515);
  form1.InvertYrotation1.Caption := GetLanguageString(516);
  form1.MirrorXposition1.Caption := GetLanguageString(517);
  form1.MirrorZposition1.Caption := GetLanguageString(518);
  form1.View1.Caption := GetLanguageString(519);
  form1.Lists1.Caption := GetLanguageString(520);
  form1.Grids1.Caption := GetLanguageString(521);
  form1.TabSheet1.Caption := GetLanguageString(306);
  form1.TabSheet2.Caption := GetLanguageString(307);

  FPlacementOptions.Caption := GetLanguageString(352);
  FPlacementOptions.Label3.Caption := GetLanguageString(345);
  FPlacementOptions.Label2.Caption := GetLanguageString(346);
  FPlacementOptions.Label1.Caption := GetLanguageString(347);
  FPlacementOptions.Label7.Caption := GetLanguageString(348);
  FPlacementOptions.Label6.Caption := GetLanguageString(349);
  FPlacementOptions.Label4.Caption := GetLanguageString(350);
  FPlacementOptions.Label5.Caption := GetLanguageString(351);
  FPlacementOptions.btnSave.Caption := GetLanguageString(277);
  FPlacementOptions.btnReset.Caption := GetLanguageString(344);

  FSnapOptions.Caption := GetLanguageString(353);
  FSnapOptions.chkSnap.Caption := GetLanguageString(354);
  FSnapOptions.chkSnapDistance.Caption := GetLanguageString(355);
  FSnapOptions.chkSnapRotate.Caption := GetLanguageString(356);
  FSnapOptions.chkSnapYValue.Caption := GetLanguageString(357);
  FSnapOptions.chkDistancelimit.Caption := GetLanguageString(358);
  FSnapOptions.Label8.Caption := GetLanguageString(359);
  FSnapOptions.btnSave.Caption := GetLanguageString(277);
  FSnapOptions.btnReset.Caption := GetLanguageString(344);

  form15.btnAddRoom.Caption := GetLanguageString(317);
  form15.Addroom1.Caption := GetLanguageString(317);
  form15.btnEditRoom.Caption := GetLanguageString(318);
  form15.Editroom1.Caption := GetLanguageString(318);
  form15.btnDeleteRoom.Caption := GetLanguageString(319);
  form15.Deleteroom1.Caption := GetLanguageString(319);
  form15.btnAddEntry.Caption := GetLanguageString(320);
  form15.Addrow1.Caption := GetLanguageString(320);
  form15.btnDeleteEntry.Caption := GetLanguageString(321);
  form15.Deleterow1.Caption := GetLanguageString(321);
  form15.Button1.Caption := GetLanguageString(322);
  form15.Button2.Caption := GetLanguageString(322);
  form15.btnDeleteRow2.Caption := GetLanguageString(323);
  form15.btnDeleteRow3.Caption := GetLanguageString(323);
  form15.Addrow2.Caption := GetLanguageString(322);
  form15.Addrow3.Caption := GetLanguageString(322);
  form15.Deleterow2.Caption := GetLanguageString(323);
  form15.Deleterow3.Caption := GetLanguageString(323);
  form15.btnSave1.Caption := GetLanguageString(277);
  form15.btnSave2.Caption := GetLanguageString(277);
  form15.btnClose1.Caption := GetLanguageString(113);
  form15.btnClose2.Caption := GetLanguageString(113);

  form23.Caption := GetLanguageString(464);
  form23.Button2.Caption := GetLanguageString(118);

  fmMonsterType.Caption := GetLanguageString(465);
  fmmonstertype.Button2.Caption := GetLanguageString(118);

  form31.Caption := GetLanguageString(325);
  form31.Copy.Caption := GetLanguageString(159);
  form31.Button1.Caption := GetLanguageString(113);
  form31.Button2.Caption := GetLanguageString(155);


  form32.Caption := GetLanguageString(448);
  form32.Button1.Caption := GetLanguageString(148);
  form32.Button2.Caption := GetLanguageString(149);
  form32.Button4.Caption := GetLanguageString(151);
  form32.Button3.Caption := GetLanguageString(152);
  form32.Button6.Caption := GetLanguageString(118);
  form32.chkBezier.Caption := GetLanguageString(451);

  Form33.Caption := GetLanguageString(405);
  form33.Label1.Caption := GetLanguageString(452);
  form33.Label3.Caption := GetLanguageString(453);
  form33.Label2.Caption := GetLanguageString(454);
  form33.Label4.Caption := GetLanguageString(455);
  form33.chkGCEndian.Caption := GetLanguageString(476);
  form33.Button2.Caption := GetLanguageString(118);

  fmHotkeys.Caption := GetLanguageString(427);
  fmHotkeys.Label7.Caption := GetLanguageString(159);
  fmHotkeys.Label11.Caption := GetLanguageString(428);
  fmHotkeys.Label12.Caption := GetLanguageString(429);
  fmHotkeys.Label10.Caption := GetLanguageString(430);
  fmHotkeys.Label9.Caption := GetLanguageString(431);
  fmHotkeys.Label8.Caption := GetLanguageString(432);
  fmHotkeys.Label14.Caption := GetLanguageString(433);
  fmHotkeys.btnClose.Caption := GetLanguageString(113);

  form4.btnEditText.Caption := GetLanguageString(361);
  form4.Changedataformat1.Caption := GetLanguageString(415);
  form4.Hex1.Caption := GetLanguageString(416);
  form4.Decimal1.Caption := GetLanguageString(417);
  form4.HideNOPs1.Caption := GetLanguageString(418);
  form4.Switcheditors1.Caption := GetLanguageString(419);
  form4.Addsymbolechat1.Caption := GetLanguageString(469);
  form4.Editsymbolechat1.Caption := GetLanguageString(470);
  form4.EditVectordata1.Caption := GetLanguageString(471);

  fmScriptTE.Caption := GetLanguageString(360);
  fmScriptTE.StatusBar1.Panels[0].Text := GetLanguageString(147);
  fmScriptTE.File1.Caption := GetLanguageString(1);
  fmScriptTE.Openfromfile1.Caption := GetLanguageString(364);
  fmScriptTE.Savetofile1.Caption := GetLanguageString(365);
  fmScriptTE.Exit1.Caption := GetLanguageString(366);
  fmScriptTE.Edit1.Caption := GetLanguageString(122);
  fmScriptTE.AddSTRcomment1.Caption := GetLanguageString(367);
  fmScriptTE.Find1.Caption := GetLanguageString(156);
  fmScriptTE.Replace1.Caption := GetLanguageString(368);
  fmScriptTE.Searchreplacesettings1.Caption := GetLanguageString(369);
  fmScriptTE.Wholewords1.Caption := GetLanguageString(370);
  fmScriptTE.Matchcase1.Caption := GetLanguageString(371);
  fmScriptTE.Engine1.Caption := GetLanguageString(372);
  fmScriptTE.Normal1.Caption := GetLanguageString(479);
  fmScriptTE.Extended1.Caption := GetLanguageString(373);
  fmScriptTE.RegularExpression1.Caption := GetLanguageString(374);
  fmScriptTE.Wildcard1.Caption := GetLanguageString(375);
  fmScriptTE.Resetsettings1.Caption := GetLanguageString(376);
  fmScriptTE.GoToLabel1.Caption := GetLanguageString(378);
  fmScriptTE.GoToLine1.Caption := GetLanguageString(379);
  fmScriptTE.Format1.Caption := GetLanguageString(362);
  fmScriptTE.Changefont1.Caption := GetLanguageString(382);
  fmScriptTE.Changetextcolor1.Caption := GetLanguageString(383);
  fmScriptTE.Label1.Caption := GetLanguageString(386);
  fmScriptTE.Opcodes1.Caption := GetLanguageString(387);
  fmScriptTE.Registers1.Caption := GetLanguageString(388);
  fmScriptTE.Values1.Caption := GetLanguageString(389);
  fmScriptTE.StringSTR1.Caption := GetLanguageString(390);
  fmScriptTE.StringArgument1.Caption := GetLanguageString(391);
  fmScriptTE.Changetheme1.Caption := GetLanguageString(392);
  fmScriptTE.Setformattingdefaults1.Caption := GetLanguageString(393);
  fmScriptTE.View1.Caption := GetLanguageString(363);
  fmScriptTE.Notes1.Caption := GetLanguageString(396);
  fmScriptTE.Zoom1.Caption := GetLanguageString(38);
  fmScriptTE.Help1.Caption := GetLanguageString(27);
  fmScriptTE.Opcodes2.Caption := GetLanguageString(397);
  fmScriptTE.ReservedRegisters1.Caption := GetLanguageString(398);
  fmScriptTE.Functions1.Caption := GetLanguageString(399);
  fmScriptTE.Panel2.Caption := GetLanguageString(424);
  fmScriptTE.NotesFont1.Caption := GetLanguageString(382);
  fmScriptTE.NotesText1.Caption := GetLanguageString(384);
  fmScriptTE.NotesBackground1.Caption := GetLanguageString(385);
  fmScriptTE.NotesReset1.Caption := GetLanguageString(480);
  fmScriptTE.Addeditdata1.Caption := GetLanguageString(400);
  fmScriptTE.NPC1.Caption := GetLanguageString(401);
  fmScriptTE.Image1.Caption := GetLanguageString(402);
  fmScriptTE.Enemy1.Caption := GetLanguageString(403);
  fmScriptTE.Float1.Caption := GetLanguageString(404);
  fmScriptTE.Symbolchat1.Caption := GetLanguageString(405);
  fmScriptTE.Vector1.Caption := GetLanguageString(406);
  fmScriptTE.Changeimage1.Caption := GetLanguageString(407);
  fmScriptTE.SaveImage1.Caption := GetLanguageString(277);
  fmScriptTE.Enemystat1.Caption := GetLanguageString(408);
  fmScriptTE.EnemyResist1.Caption := GetLanguageString(409);
  fmScriptTE.EnemyAttack1.Caption := GetLanguageString(410);
  fmScriptTE.EnemyMovement1.Caption := GetLanguageString(411);
  fmScriptTE.NewLabel1.Caption := GetLanguageString(412);
  fmScriptTE.NewRegister1.Caption := GetLanguageString(413);
  fmScriptTE.AddArgs1.Caption := GetLanguageString(414);
  fmScriptTE.Argumentformat1.Caption := GetLanguageString(415);
  fmScriptTE.Hex1.Caption := GetLanguageString(416);
  fmScriptTE.Decimal1.Caption := GetLanguageString(417);
  fmScriptTE.HideNOPs1.Caption := GetLanguageString(418);
  fmScriptTE.Switcheditor1.Caption := GetLanguageString(419);
  fmScriptTE.Copy1.Caption := GetLanguageString(159);
  fmScriptTE.Cut1.Caption := GetLanguageString(160);
  fmScriptTE.Paste1.Caption := GetLanguageString(161);
  fmScriptTE.Delete1.Caption := GetLanguageString(162);
  fmScriptTE.Undo1.Caption := GetLanguageString(45);
  fmScriptTE.Redo1.Caption := GetLanguageString(529);
  fmScriptTE.Addannotation1.Caption := GetLanguageString(531);
  fmScriptTE.Annotations1.Caption := GetLanguageString(532);
  fmScriptTE.Annotation1.Caption := GetLanguageString(534);

  fmReplace.Caption := GetLanguageString(420);
  fmReplace.Label1.Caption := GetLanguageString(421);
  fmReplace.Label2.Caption := GetLanguageString(422);
  fmReplace.Selectiononly1.Caption := GetLanguageString(423);
  fmReplace.btnClose.Caption := GetLanguageString(113);

  form17.chkFullscreen.Caption := GetLanguageString(500);
  form17.chkFollow.Caption := GetLanguageString(501);

  // Center zoom text
  start := form1.Button5.Left + form1.Button5.Width;
  width := form1.Button6.Left - start;
  form1.Label6.Left := (start + (width div 2) - (form1.Label6.Width div 2)) + 1;

  // Adjust modifiers label position based on status text width
  form1.lblModifiers.Left := form1.lblStatus.Left + form1.lblStatus.Width + 6;

  // OK buttons
  form7.Button1.Caption := GetLanguageString(117);
  form23.Button1.Caption := GetLanguageString(117);
  form32.Button5.Caption := GetLanguageString(117);
  form33.Button1.Caption := GetLanguageString(117);
  fmGoto.btnOK.Caption := GetLanguageString(117);
  fmReplace.btnOK.Caption := GetLanguageString(117);
  fmMonsterType.btnOK.Caption := GetLanguageString(117);
  fmRotation.btnOK.Caption := GetLanguageString(117);
  fmThemes.btnOK.Caption := GetLanguageString(117);
  fmRoom.btnOK.Caption := GetLanguageString(117);

  // Set main font for forms
  for idx := 0 to Screen.FormCount - 1 do
  begin
    Screen.Forms[idx].Font.Name := 'Microsoft Sans Serif';
    Screen.Forms[idx].Font.Quality := fqNonAntialiased;
    Screen.Forms[idx].Font.Charset := DEFAULT_CHARSET;
  end;

  // Refresh map area text
  form1.DrawMap;

  // Update the window title
  if (pos('Unicode',form1.Caption) <> 0) or
  (pos('ASCII',form1.Caption) <> 0) then
    UpdateWindowTitle;
end;

procedure DrawPreviewState(AState: Integer);
var
  y, z, m, u, idx: integer;
begin
  idx := form1.CheckListBox1.ItemIndex;
  if idx < 0 then Exit;

  delaystring := 'Delay: ';
  actionstring := '';
  settingstring := 'Wave setting: ';

  // Check if the state is in bounds
  if (AState <= 0) or
     (AState > Floor[idx].Unknow[8]) then
    Exit;

  // Calculate offsets and delay/setting string
  if Floor[idx].Unknow[15] = $32 then
  begin
    y := 16 + (24 * (AState - 1));
    z := Floor[idx].Unknow[y + 20] + Floor[idx].Unknow[y + 21] * 256;
    z := z + (Floor[idx].Unknow[0] + Floor[idx].Unknow[1] * 256);

    delaystring :=
      delaystring +
      'min = ' + IntToStr(Floor[idx].Unknow[y + 12] +
                           Floor[idx].Unknow[y + 13] * 256) +
      ' max = ' + IntToStr(Floor[idx].Unknow[y + 14] +
                           Floor[idx].Unknow[y + 15] * 256);
    settingstring :=
      settingstring +
        inttostr(Floor[form1.CheckListBox1.ItemIndex].Unknow[y + 16]) + ' ' +
        inttostr(Floor[form1.CheckListBox1.ItemIndex].Unknow[y + 17]) + ' ' +
        inttostr(Floor[form1.CheckListBox1.ItemIndex].Unknow[y + 18]) + ' ' +
        inttostr(Floor[form1.CheckListBox1.ItemIndex].Unknow[y + 19]);
  end
  else
  begin
    y := 16 + (20 * (AState - 1));
    z := Floor[idx].Unknow[y + 16] + Floor[idx].Unknow[y + 17] * 256;
    z := z + (Floor[idx].Unknow[0] + Floor[idx].Unknow[1] * 256);

    delaystring :=
      delaystring +
      IntToStr(Floor[idx].Unknow[y + 12] +
               Floor[idx].Unknow[y + 13] * 256);
  end;

  // Event information
  previewstring :=
    '#' + IntToStr(Floor[idx].Unknow[y] +
                   Floor[idx].Unknow[y + 1] * 256);

  prevsection :=
    Floor[idx].Unknow[y + 8] +
    Floor[idx].Unknow[y + 9] * 256;

  mapwave :=
    Floor[idx].Unknow[y + 10] +
    Floor[idx].Unknow[y + 11] * 256;
  if Floor[idx].Unknow[15] <> $32 then
  begin
    form1.EnemyWave1.Tag := mapwave;
    form1.EnemyWave1Click(form1.EnemyWave1);
  end;

  // Parse the actions
  while (Floor[idx].Unknow[z] <> 1) and
        (z < Length(Floor[idx].Unknow) - 5) do
  begin
    m := 0;
    u := 0;

    if Floor[idx].Unknow[z] = $0C then
    begin
      move(Floor[idx].Unknow[z + 1], m, 4);
      actionstring := actionstring + 'Call ' + IntToStr(m);
      Inc(z, 5);
    end
    else if Floor[idx].Unknow[z] = $0A then
    begin
      move(Floor[idx].Unknow[z + 1], m, 2);
      actionstring := actionstring + 'Unlock ' + IntToStr(m);
      Inc(z, 3);
    end
    else if Floor[idx].Unknow[z] = $0B then
    begin
      move(Floor[idx].Unknow[z + 1], m, 2);
      actionstring := actionstring + 'Lock ' + IntToStr(m);
      Inc(z, 3);
    end
    else if Floor[idx].Unknow[z] = $08 then
    begin
      move(Floor[idx].Unknow[z + 1], m, 2);
      move(Floor[idx].Unknow[z + 3], u, 2);
      actionstring :=
        actionstring + 'Unhide ' + IntToStr(m) + ' ' + IntToStr(u);
      Inc(z, 5);
    end;
    actionstring := actionstring + ' > ';
  end;
  delete(actionstring, length(actionstring)-2, 3);

  mpx := Round(-MidP[prevsection].x * Zoom);
  mpy := Round(-MidP[prevsection].y * Zoom);
  form9.SpinEdit1.Value := mapwave;
  for idx := 0 to form1.ComboBox1.Items.Count - 1 do
    if form1.ComboBox1.Items[idx] = inttostr(prevsection) then break;
  form1.ComboBox1.ItemIndex := idx;
  form1.DrawMap;
  if have3d and not inundo and not indelete then
  begin
    ppx := midpz[prevsection].x;
    ppy := Form1.YFromBBRELFile(MidP[prevsection].x * zoom, MidP[prevsection].y * zoom) + 15;
    ppz := -midpz[prevsection].y;
    myscreen.SetView(ppx, ppy, ppz, vr, vz);
  end;
end;

Procedure ResetPreviewState;
var
  idx: integer;
begin
  previewstate := 0;
  form1.EnemyWave1.Tag := prevwave;
  form1.EnemyWave1Click(form1.EnemyWave1);
  form1.Itemsgroupe1.Tag := prevgroup;
  form1.Itemsgroupe1Click(form1.Itemsgroupe1);
  // Reset state
  mpx := prevx;
  mpy := prevy;
  ppx := prevppx;
  ppy := prevppy;
  ppz := prevppz;
  vr := prevvr;
  vz := prevvz;
  zoom := prevzoom;
  form1.lblPreview.Visible := false;
  form9.SpinEdit1.Value := prevmwave;
  form1.ComboBox1.ItemIndex := prevRoomID;
  form1.DrawMap;
  if have3d then
    myscreen.SetView(ppx,ppy,ppz,vr,vz);
end;

Procedure ClearBMPCache;
var
  bmp: TBitmap;
begin
  for bmp in BMPCache.Values do
    bmp.Free;
  BMPCache.Clear;
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

Function GetLanguageString(id: integer): string;
var
  x: integer;
  s: string;
begin
  if id - 1 < LanguageString.count then
    s := LanguageString.Strings[id - 1]
  else s := EnglishUIText[id - 1];
  x := pos('<cr>', s);
  while x > 0 do
  begin
    delete(s, x, 4);
    insert(#13#10, s, x);
    x := pos('<cr>', s);
  end;
  result := s;
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
  // Window title information
  filewrite(f, isdc, 1);
  filewrite(f, asmmode, 2);
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
  cleantitle: widestring;
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

  // Window title information
  isdc := false;
  fileread(f, isdc, 1);
  asmmode := 0;
  fileread(f, asmmode, 2);

  fileclose(f);

  curepi := GetEpisode;
  UpdateWindowTitle;

  // Clear and update map strings
  for x := 0 to 30 do
    form1.CheckListBox1.Items.Strings[x] := '';
  if curepi < 2 then
  begin
    for x := 0 to 17 do
      form1.CheckListBox1.Items.Strings[x] := mapname[mapid[x + EPMap[curepi]]];
  end
  else
  begin
    x := 10;
    form1.CheckListBox1.Items.Strings[0] := mapname[mapid[x + EPMap[2]]];
    for x := 0 to 8 do
      form1.CheckListBox1.Items.Strings[x + 1] := mapname[mapid[x + EPMap[2]]];
  end;
  UpdateScriptRefs;
  importscan := true;
  ScanForMap;
  importscan := false;
  form1.CheckListBox1.ItemIndex := 0;
  form1.CheckListBox1Click(Form1);

  // Load quest notes file based on quest name if they exist
  fmScriptTE.txtNotes.Clear;
  cleantitle := SanitizeFileName(title);
  if (cleantitle <> '') and FileExists(path + 'notes\' + cleantitle + ' notes'+ '.txt') then
    fmScriptTE.txtNotes.Lines.LoadFromFile(path + 'notes\' + cleantitle + ' notes'+ '.txt');
  fmScriptTE.BuildNoteLookup;
  isedited := false;
 if previewstate > 0 then
  ResetPreviewState;
end;

Procedure LoadShadow;
var
  s: ansistring;
begin
  if fmScriptTE.Visible then
    form4.Show;
  if not directoryexists(path + 'temp') then
    CreateDir(path + 'temp');
  s := inttohex(crc32ofstring(FullQuestFile), 8);
  unDumpQuest(path + 'temp\_' + s);
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
      else if m.Skin = 135 then
      begin
        MyObj[x].rotationseq := 3;
        MyObj[x].SetRotation(((-(m.unknow6 + rev[Floor[sfloor].Obj[x].map_section]) and $FFFF)) / 182.04444,
          (-(m.Unknow5 and $FFFF) / 182.04444), ((m.unknow7 and $FFFF) / 182.04444));
      end
      else if m.Skin = 140 then
      begin
        MyObj[x].rotationseq := 3;
        MyObj[x].SetRotation(((-(m.unknow6 + rev[Floor[sfloor].Obj[x].map_section]) and $FFFF)) / 182.04444,
          (-(m.Unknow5 and $FFFF) / 182.04444), (-(m.unknow7 and $FFFF) / 182.04444));
      end
      else if (m.Skin = 192) or (m.Skin = 222) or (m.Skin = 257) or (m.Skin = 323) then
      begin
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

    // Apply the current visibility settings
    form1.Itemsgroupe1.Tag := showgrp;
    form1.Itemsgroupe1Click(form1.Itemsgroupe1);
    if previewstate > 0 then
      DrawPreviewState(previewstate)
    else
    begin
      form1.EnemyWave1.Tag := showwave;
      form1.EnemyWave1Click(form1.EnemyWave1);
    end;
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

// Low-level functions to save/restore DBGrid scroll positions
function TForm1.GetDBGridScrollPos(Grid: TDBGrid): TGridScrollPos;
var
  si: TScrollInfo;
begin
  ZeroMemory(@si, SizeOf(si));
  si.cbSize := SizeOf(si);
  si.fMask := SIF_POS;

  GetScrollInfo(Grid.Handle, SB_HORZ, si);
  Result.Horz := si.nPos;

  GetScrollInfo(Grid.Handle, SB_VERT, si);
  Result.Vert := si.nPos;
end;

procedure TForm1.SetDBGridScrollPos(Grid: TDBGrid; const Pos: TGridScrollPos);
var
  si: TScrollInfo;
begin
  ZeroMemory(@si, SizeOf(si));
  si.cbSize := SizeOf(si);
  si.fMask := SIF_POS;

  si.nPos := Pos.Horz;
  SetScrollInfo(Grid.Handle, SB_HORZ, si, True);

  si.nPos := Pos.Vert;
  SetScrollInfo(Grid.Handle, SB_VERT, si, True);

  // Repaint
  Grid.Perform(WM_HSCROLL, MakeWParam(SB_THUMBPOSITION, Pos.Horz), 0);
  Grid.Perform(WM_VSCROLL, MakeWParam(SB_THUMBPOSITION, Pos.Vert), 0);
end;

procedure ApplyMonsterSort(const s: string);
begin
  with Form1.ClientDataSet1 do
  begin
    // Clear current index
    IndexName := '';
    try
      DeleteIndex('temp_idx');
    except
      // Index doesn't exist yet; ignore exception
    end;

    // Create new index with the current setting
    if decmonstsort then
      AddIndex('temp_idx', s, [ixDescending])
    else
      AddIndex('temp_idx', s, []);

    // Toggle the setting
    decmonstsort := not decmonstsort;

    // Apply the index
    IndexName := 'temp_idx';
  end;
end;

procedure ApplyObjectSort(const s: string);
begin
  with Form1.ClientDataSet2 do
  begin
    // Clear current index
    IndexName := '';
    try
      DeleteIndex('temp_idx');
    except
      // Index doesn't exist yet; ignore exception
    end;

    // Create new index with the current setting
    if decobjsort then
      AddIndex('temp_idx', s, [ixDescending])
    else
      AddIndex('temp_idx', s, []);

    // Toggle the setting
    decobjsort := not decobjsort;

    // Apply the index
    IndexName := 'temp_idx';
  end;
end;

Procedure TForm1.LoadFloorGrids;
var
  i: integer;
begin
  if showgrid then
  begin
    with form1 do
    begin
      // Disable editing if the tables are blank
      if Floor[Checklistbox1.ItemIndex].MonsterCount <= 0 then
        DBGrid1.Options := DBGrid1.Options - [dgEditing]
      else if editgrid then
        DBGrid1.Options := DBGrid1.Options + [dgEditing];
      if Floor[Checklistbox1.ItemIndex].ObjCount <= 0 then
        DBGrid2.Options := DBGrid2.Options - [dgEditing]
      else if editgrid then
        DBGrid2.Options := DBGrid2.Options + [dgEditing];

      // Disable controls for smoother updating
      ClientDataSet1.DisableControls;
      ClientDataSet2.DisableControls;

      // Clear the data sets
      ClientDataSet1.EmptyDataSet;
      ClientDataSet2.EmptyDataSet;

      // Temporarily disable read-only fields for writing
      DBGrid1.Fields[0].ReadOnly := false;
      DBGrid2.Fields[0].ReadOnly := false;
      DBGrid1.Fields[1].ReadOnly := false;
      DBGrid2.Fields[1].ReadOnly := false;

      // Load monsters
      for i := 0 to Floor[sFloor].MonsterCount - 1 do
      begin
        ClientDataSet1.Append;
        ClientDataSet1.FieldByName('#').AsInteger := i;
        ClientDataSet1.FieldByName('Name').AsString := GenerateMonsterName(Floor[sfloor].Monster[i], i, 0);
        ClientDataSet1.FieldByName('Skin').AsInteger := Floor[sFloor].Monster[i].Skin;
        ClientDataSet1.FieldByName('Section').AsInteger := Floor[sFloor].Monster[i].map_section;
        ClientDataSet1.FieldByName('Wave').AsInteger := Floor[sFloor].Monster[i].unknow5;
        ClientDataSet1.FieldByName('Pos X').AsSingle := Floor[sFloor].Monster[i].Pos_X;
        ClientDataSet1.FieldByName('Pos Y').AsSingle := Floor[sFloor].Monster[i].Pos_Z;
        ClientDataSet1.FieldByName('Pos Z').AsSingle := Floor[sFloor].Monster[i].Pos_Y;

        if editgrid then
          ClientDataSet1.FieldByName('Rot Y').AsInteger := Floor[sFloor].Monster[i].Direction
        else
          ClientDataSet1.FieldByName('Rot Y').AsInteger := (Floor[sFloor].Monster[i].Direction) and $FFFF div 182;

        ClientDataSet1.FieldByName('Param 1').AsInteger := Floor[sFloor].Monster[i].unknow8;
        ClientDataSet1.FieldByName('Param 2').AsSingle := Floor[sFloor].Monster[i].Movement_data;
        ClientDataSet1.FieldByName('Param 3').AsSingle := Floor[sFloor].Monster[i].Unknow10;
        ClientDataSet1.FieldByName('Param 4').AsSingle := Floor[sFloor].Monster[i].unknow11;
        ClientDataSet1.FieldByName('Param 5').AsSingle := Floor[sFloor].Monster[i].Char_id;
        ClientDataSet1.FieldByName('Param 6').AsSingle := Floor[sFloor].Monster[i].Action;
        ClientDataSet1.FieldByName('Param 7').AsInteger := Floor[sFloor].Monster[i].Movement_flag;
        ClientDataSet1.FieldByName('Child Count').AsInteger := Floor[sFloor].Monster[i].Unknow2 div $10000;
        ClientDataSet1.Post;
      end;

      // Load objects
      for i := 0 to Floor[sFloor].ObjCount - 1 do
      begin
        ClientDataSet2.Append;
        ClientDataSet2.FieldByName('#').AsInteger := i;
        ClientDataSet2.FieldByName('Name').AsString := GetObjName(Floor[sFloor].Obj[i].Skin);
        ClientDataSet2.FieldByName('Skin').AsInteger := Floor[sFloor].Obj[i].Skin;
        ClientDataSet2.FieldByName('Section').AsInteger := Floor[sFloor].Obj[i].map_section;
        ClientDataSet2.FieldByName('Group').AsInteger := Floor[sFloor].Obj[i].grp;
        ClientDataSet2.FieldByName('Pos X').AsSingle := Floor[sFloor].Obj[i].Pos_X;
        ClientDataSet2.FieldByName('Pos Y').AsSingle := Floor[sFloor].Obj[i].Pos_Z;
        ClientDataSet2.FieldByName('Pos Z').AsSingle := Floor[sFloor].Obj[i].Pos_Y;

        if editgrid then
        begin
          ClientDataSet2.FieldByName('Rot X').AsInteger := Floor[sFloor].Obj[i].unknow5;
          ClientDataSet2.FieldByName('Rot Y').AsInteger := Floor[sFloor].Obj[i].unknow6;
          ClientDataSet2.FieldByName('Rot Z').AsInteger := Floor[sFloor].Obj[i].unknow7;
        end
        else
        begin
          ClientDataSet2.FieldByName('Rot X').AsInteger := (Floor[sFloor].Obj[i].unknow5) and $FFFF div 182;
          ClientDataSet2.FieldByName('Rot Y').AsInteger := (Floor[sFloor].Obj[i].unknow6) and $FFFF div 182;
          ClientDataSet2.FieldByName('Rot Z').AsInteger := (Floor[sFloor].Obj[i].unknow7) and $FFFF div 182;
        end;

        ClientDataSet2.FieldByName('Param 1').AsSingle := Floor[sFloor].Obj[i].unknow8;
        ClientDataSet2.FieldByName('Param 2').AsSingle := Floor[sFloor].Obj[i].unknow9;
        ClientDataSet2.FieldByName('Param 3').AsSingle := Floor[sFloor].Obj[i].Unknow10;
        ClientDataSet2.FieldByName('Param 4').AsInteger := Floor[sFloor].Obj[i].obj_id;
        ClientDataSet2.FieldByName('Param 5').AsInteger := Floor[sFloor].Obj[i].Action;
        ClientDataSet2.FieldByName('Param 6').AsInteger := Floor[sFloor].Obj[i].unknow13;
        ClientDataSet2.Post;
      end;

      // Find and set the original selection
      if selected > -1 then
      begin
        if sType = 1 then
        begin
          ClientDataSet1.Locate('#', selected, []);
          ClientDataSet2.Locate('#', Listbox2.ItemIndex, []);
          gridtype := 1;
        end;
        if sType = 2 then
        begin
          ClientDataSet2.Locate('#', selected, []);
          ClientDataSet1.Locate('#', Listbox1.ItemIndex, []);
          gridtype := 2;
        end;
      end
      else
      begin
        ClientDataSet1.First;
        ClientDataSet2.First;
        gridtype := -1;
      end;

      // Restore columns
      DBGrid1.SelectedIndex := grid1col;
      DBGrid2.SelectedIndex := grid2col;

      // Done writing; cleanup and revert original settings
      ClientDataSet1.EnableControls;
      ClientDataSet2.EnableControls;

      DBGrid1.Fields[0].ReadOnly := true;
      DBGrid2.Fields[0].ReadOnly := true;
      DBGrid1.Fields[1].ReadOnly := true;
      DBGrid2.Fields[1].ReadOnly := true;
    end;
  end;
end;

procedure TForm1.LookAt1Click(Sender: TObject);
begin
  if selected > -1 then
  begin
    placelookat := true;
    lblStatus.Caption := GetLanguageString(528);
    if not Form1.smDisableIndicator.Checked then
      lblStatus.Show;
    lblModifiers.Hide;
    MoveType := 0;
    MoveSel := -1;
  end;
end;

procedure TForm1.LookAt2Click(Sender: TObject);
begin
  if Screen.ActiveForm = fmScriptTE then
    fmScriptTE.Annotations1Click(nil)
  else
    LookAt1Click(nil);
end;

Procedure TForm1.DrawMap;
Var
  px, py, px2, py2, px3, py3: double;
  ppx, ppy, rad: Single;
  x, i, z: integer;
  rt: word;
  tpt: array [0 .. 2] of TPoint;
  hs: TMemoryStream;
  bm: TBitmap;
  name: ansistring;
  maprect: TRect;
begin
  // clear map
  if BBRelBmp = nil then
    BBRelBmp := TBitmap.Create;

  BBRelBmp.Width := Image2.Width;
  BBRelBmp.height := Image2.height;

  if darkmode then BBRelBmp.Canvas.Brush.Color := RGB(18,18,18)
  else
    BBRelBmp.Canvas.Brush.Color := ClWhite;
  BBRelBmp.Canvas.FillRect(BBRelBmp.Canvas.ClipRect);
  if fileexists(mapfilenam) then
    DrawBBRELFile(mapfilenam);

  if (selected > -1) and (sType = 2) and (mdown = 0) and (mdrag = 0) then
  begin
    if (Floor[sFloor].Obj[selected].Skin = 10000) then
      UpdateSnapPolygonChildren(Floor[sFloor].Obj[selected]);
  end;

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
        if (previewstate > 0) and (z <> prevsection) then
        begin
          inc(x, 28);
          continue;
        end;
        px := cos(-rev[z] / 10430.37835) * px2 - sin(-rev[z] / 10430.37835) * py2;
        py := sin(-rev[z] / 10430.37835) * px2 + cos(-rev[z] / 10430.37835) * py2;

        px2 := mpx;
        px2 := px2 / Zoom;
        px := px + mmx + MidP[z].x + px2;
        px2 := mpy;
        px2 := px2 / Zoom;
        py := py + mmy + MidP[z].y + px2;
        BBRelBmp.Canvas.Brush.Color := GetSpawnColor(markerbrightness);
        BBRelBmp.Canvas.FillRect(Rect(round(px) - round(6 / Zoom), round(py) - round(6 / Zoom),
          round(px) + round(6 / Zoom), round(py) + round(6 / Zoom)));

        move(Floor[sfloor].d04[x + 16], rt, 2);
        if darkmode then BBRelBmp.Canvas.Pen.Color := RGB(200,200,200);
        BBRelBmp.Canvas.Pen.Width := outlinewidth;
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
        BBRelBmp.Canvas.Pen.Color := clBlack;
        BBRelBmp.Canvas.Pen.Width := 1;
        inc(x, 28);
      end;
    except
    end;

  try
    for x := 0 to Floor[sfloor].MonsterCount - 1 do
      if (Floor[sfloor].Monster[x].Unknow5 = showwave) or (showwave = -1) then
      begin
        if (previewstate > 0) and
        (Floor[sfloor].Monster[x].map_section <> prevsection)
        then continue;

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
        BBRelBmp.Canvas.Brush.Color := GetMonsterColor(markerbrightness);
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
        if showbmp.Checked then
        begin
          // Attempt to add the bitmap to the cache
          name := GenerateMonsterName(Floor[sfloor].Monster[x], x, -1) + '.bmp';
          if not BMPCache.TryGetValue('monster_' + name, bm) then
          begin
            hs := TMemorystream.Create;
            bm := TBitmap.Create;
            if fileexists(path + 'img\' + name) then
              bm.LoadFromFile(path + 'img\' + name)
            else if PikaGetFile(hs, name, path + 'images.ppk', 'Build By Schthack') = 0 then
              bm.LoadFromStream(hs)
            else if PikaGetFile(hs, 'unknow.bmp', path + 'images.ppk', 'Build By Schthack') = 0 then
              bm.LoadFromStream(hs)
            else if fileexists(path + 'img\unknow.bmp') then
              bm.LoadFromFile(path + 'img\unknow.bmp');
            if Assigned(bm) and not bm.Empty then
              BMPCache.Add('monster_' + name, bm)
            else
            begin
              bm.free;
              bm := nil;
            end;
            hs.free;
          end;
          maprect := Rect(round(px) - round(6 / Zoom), round(py) - round(6 / Zoom),
          round(px) + round(6 / Zoom), round(py) + round(6 / Zoom));
          if Assigned(bm) and not bm.Empty then
            BBRelBmp.Canvas.StretchDraw(maprect, bm);
        end;
        if darkmode and not ((sType = 1) and (selected = x))
        or (darkmode and ((sType = 1) and (selected = x)) and showbmp.Checked)
        then
          BBRelBmp.Canvas.Pen.Color := RGB(200,200,200);
        BBRelBmp.Canvas.Pen.Width := outlinewidth;
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
        BBRelBmp.Canvas.Pen.Color := clBlack;
        BBRelBmp.Canvas.Pen.Width := 1;
      end;
  except
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
        BBRelBmp.Canvas.Brush.Color := GetObjectColor(markerbrightness);
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
        end;
        if showbmp.Checked and (Floor[sfloor].Obj[x].Skin <> 11000) then
        begin
          name := inttohex(Floor[sFloor].Obj[x].Skin,2) + '.bmp';
          if not BMPCache.TryGetValue('object_' + name, bm) then
          begin
            bm := TBitmap.Create;
            hs := TMemorystream.Create;
            if fileexists(path + 'img\i' + name) then
            begin
              // Only cache the object bitmap if a valid file was loaded
              bm.LoadFromFile(path + 'img\i' + name);
              if Assigned(bm) and not bm.Empty then
                BMPCache.Add('object_' + name, bm);
            end
            else if PikaGetFile(hs, name, path + 'images.ppk', 'Build By Schthack') = 0 then
              bm.LoadFromStream(hs)
            else if PikaGetFile(hs, 'unknow.bmp', path + 'images.ppk', 'Build By Schthack') = 0 then
              bm.LoadFromStream(hs)
            else if fileexists(path + 'img\unknow.bmp') then
              bm.LoadFromFile(path + 'img\unknow.bmp')
            else
            begin
              bm.free;
              bm := nil;
            end;
            hs.free;
          end;
          if Assigned(bm) and (sType = 2) and (selected = x) and objloaded then
            bm := selectionBMP;
          maprect := Rect(round(px) - round(6 / Zoom), round(py) - round(6 / Zoom),
          round(px) + round(6 / Zoom), round(py) + round(6 / Zoom));
          if Assigned(bm) and not bm.Empty then
            BBRelBmp.Canvas.StretchDraw(maprect, bm);
        end;
        if (stype = 2) and (Selected = x) then
        begin
          for i := 0 to 12 do
            if ItemRange[i] = Floor[sfloor].Obj[x].Skin then
              break;
          if i < 13 then
          begin
            if Floor[sfloor].Obj[x].Skin = 14 then
              rad := (Floor[sfloor].Obj[x].unknow8 * 10)
            else
              rad := Floor[sfloor].Obj[x].unknow8;
            BBRelBmp.Canvas.Brush.Style := bsclear;
            BBRelBmp.Canvas.Pen.Color := ClOlive;
            BBRelBmp.Canvas.Ellipse(round(px - (rad / Zoom)),
              round(py - (rad / Zoom)), round(px + (rad / Zoom)),
              round(py + (rad / Zoom)));
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
            CalculateWarpOffsets(Floor[sfloor].Obj[x].unknow6 + rev[Floor[sfloor].Obj[x].map_section]);
            i := round((mpx / Zoom) + ((Floor[sfloor].Obj[x].unknow8 + warpx) / Zoom) + mmx);
            z := round((mpy / Zoom) + ((Floor[sfloor].Obj[x].Unknow10 + warpz) / Zoom) + mmy);
            BBRelBmp.Canvas.PenPos := point(i - 10, z);
            BBRelBmp.Canvas.lineto(i + 10, z);
            BBRelBmp.Canvas.PenPos := point(i, z - 10);
            BBRelBmp.Canvas.lineto(i, z + 10);
            BBRelBmp.Canvas.PenPos := point(round(px), round(py));
            BBRelBmp.Canvas.lineto(i, z);
            BBRelBmp.Canvas.Pen.Color := clblack;
          end;
        end;
        // rotation
        if darkmode and not ((sType = 2) and (selected = x))
        or (darkmode and ((sType = 2) and (selected = x)) and showbmp.Checked
        and (Floor[sfloor].Obj[x].Skin <> 11000))
        then
          BBRelBmp.Canvas.Pen.Color := RGB(200,200,200);
        if Floor[sfloor].Obj[x].Skin = 10000 then
        begin
          DrawPolygon(BBRelBmp.Canvas, Floor[sFloor].Obj[x], round(px), round(py));
          DrawPolygonSnapPoints(BBRelBmp.Canvas, Floor[sFloor].Obj[x], round(px), round(py))
        end
        else if Floor[sfloor].Obj[x].Skin = 11000 then
        begin
          BBRelBmp.Canvas.Pen.Width := outlinewidth;
          if (sType = 2) and (selected = x) then
            DrawStar(BBRelBmp.Canvas, round(px), round(py), round(8 / Zoom) * 0.60, true)
          else
            DrawStar(BBRelBmp.Canvas, round(px), round(py), round(6 / Zoom) * 0.60, true)
        end
        else
        begin
          BBRelBmp.Canvas.Pen.Width := outlinewidth;
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
        end;
        BBRelBmp.Canvas.Pen.Color := clBlack;
        BBRelBmp.Canvas.Pen.Width := 1;
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

    if darkmode then
    begin
      BBRelBmp.Canvas.Brush.Color := RGB(18,18,18);
      BBRelBmp.Canvas.Font.Color := RGB(220,220,220)
    end
    else
      BBRelBmp.Canvas.Brush.Color := ClWhite;
    if previewstate > 0 then
    begin
      BBRelBmp.Canvas.TextOut(5, 5, previewstring +
       ' (' + inttostr(previewstate) + '/' + inttostr(Floor[CheckListBox1.ItemIndex].Unknow[8]) + ')');
      BBRelBmp.Canvas.TextOut(5, 20, 'Section: ' + inttostr(prevsection));
      BBRelBmp.Canvas.TextOut(5, 35, 'Wave: ' + inttostr(mapwave));
      BBRelBmp.Canvas.TextOut(5, 50, delaystring);
      if Floor[form1.CheckListBox1.ItemIndex].Unknow[15] = $32 then
      begin
        BBRelBmp.Canvas.TextOut(5, 65, settingstring);
        BBRelBmp.Canvas.TextOut(5, 80, actionstring)
      end
      else BBRelBmp.Canvas.TextOut(5, 65, actionstring);
      if previewpaused then
      begin
        if Floor[form1.CheckListBox1.ItemIndex].Unknow[15] = $32 then
          BBRelBmp.Canvas.TextOut(5, 110, GetLanguageString(482))
        else
          BBRelBmp.Canvas.TextOut(5, 95, GetLanguageString(482));
      end;
    end
    else
      BBRelBmp.Canvas.TextOut(5, 5, GetLanguageString(54) + ' ' + inttostr(sms));
    BBRelBmp.Canvas.Font.Color := clBlack;
  except
  end;
  // image2.Canvas.Draw(0,0,BBRelBmp);
  Image2.Canvas.Draw(0, 0, BBRelBmp);
  // BBRelBmp.Free;
end;

procedure TForm1.Quit1Click(Sender: TObject);
var
  s: string;
begin
  s:=GetLanguageString(55);

  if isedited then
  begin
    if MessageDlg(s, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      Form1.Save1Click(Form1);
      if isedited then
        exit;
    end;
  end;
  ClearShadow;
  application.Terminate;
end;

procedure TForm1.Redo1Click(Sender: TObject);
begin
  if not form4.edit1.Focused and not fmScriptTE.TextEdit.Focused
  and not fmScriptTE.Edit2.Focused and not fmScriptTE.txtNotes.Focused then
    btnRedoClick(nil)
  else if fmScriptTE.TextEdit.Focused then
    fmScriptTE.Redo1Click(nil);
end;

procedure TForm1.Redo2Click(Sender: TObject);
begin
  if not form4.edit1.Focused and not fmScriptTE.TextEdit.Focused
  and not fmScriptTE.Edit2.Focused and not fmScriptTE.txtNotes.Focused then
    btnRedoClick(nil)
  else if fmScriptTE.TextEdit.Focused then
    fmScriptTE.Redo1Click(nil);
end;

procedure TForm1.Rowselection1Click(Sender: TObject);
var
  Reg: TRegistry;
begin
  DisableGridEdit;
  editgrid := false;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\schthack\qedit', true) then
    begin
      Reg.WriteBool('EditGrid', false);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
  LoadFloorGrids;
end;

procedure TForm1.Russian1Click(Sender: TObject);
var
  Reg: TRegistry;
  flp: TMemoryStream;
begin
  UncheckLanguages;
  Russian1.Checked := true;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\schthack\qedit', true) then
    begin
      Reg.WriteInteger('Lang', 3);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
    inherited;
  end;
  flp := TMemoryStream.Create;
  flp.LoadFromFile(path + 'ru.txt');
  LoadLanguageStrings(flp);
  SetInterfaceText;
  flp.Free;
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
  x, y, f, F1, F2, tf, i, labelseg: integer;
  h: TNPCGroupeHeader;
  seg: array [0 .. 3] of dword;
  txt: array [0 .. $137F] of byte;
  unp: array [0 .. $8FF] of byte;
  tmp: ansistring;
  tmp2, cleantitle: widestring;
  fn, g: ansistring;
  s: string;
  si, ln, eb1, eb2: dword;
  di, da, db: pansichar;
begin
  s:=GetLanguageString(56);
  if isedited then
  begin
    if MessageDlg(s, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
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
    if previewstate > 0 then
      ResetPreviewState;
    undocount := 0;
    redocount := 0;
    ClearShadow;
    Button11.Enabled := false;
    smUndo.Enabled := false;
    btnRedo.Enabled := false;
    smRedo.Enabled := false;
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

      // Load STR/HEX label data, if it exists
      labelseg := seg[1] + (seg[2] - seg[1]);
      x := 0;
      while (labelseg + x + 4) < qstfile[f].size do
      begin
        for i := 0 to 1000 do if datablock[i]=-1 then break;
        move(qstfile[f].data[labelseg + x], datablock[i], 4);
        inc(x, 4);
        move(qstfile[f].data[labelseg + x], datablockT[i], 1);
        inc(x, 1);
      end;

      // Load quest notes file based on quest name if they exist
      fmScriptTE.txtNotes.Clear;
      cleantitle := SanitizeFileName(title);
      if (cleantitle <> '') and FileExists(path + 'notes\' + cleantitle + ' notes'+ '.txt') then
        fmScriptTE.txtNotes.Lines.LoadFromFile(path + 'notes\' + cleantitle + ' notes'+ '.txt');
      fmScriptTE.BuildNoteLookup;
      isedited := false;
      if previewstate > 0 then
        ResetPreviewState;

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

//      if OpenDialog1.FilterIndex = 2 then begin
//        // detect asm mode
//        form34.showmodal;
//      end;
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
    { if isdc then Form1.Caption:=Form1.Caption+' (DreamCast ASCII Format)'
      else Form1.Caption:=Form1.Caption+' (PC Unicode Format)';
      if curepi = 0 then  Form1.Caption:=Form1.Caption+' - Episode 1';
      if curepi = 1 then  Form1.Caption:=Form1.Caption+' - Episode 2';
      if curepi = 2 then  Form1.Caption:=Form1.Caption+' - Episode 4';
      if asmmode = 2 then
      Form1.Caption:=Form1.Caption+' - Scrypt Mode 2'; }

    UpdateWindowTitle;

    FFilter := 1;
    if AsmMode = 2 then
      FFilter := 3;
    if isdc and (AsmMode = 2) then
      FFilter := 2;
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
    if (id = 39) or (id = 128) then
    begin
      delete(a, 1, y);
      y := pos(#9, a);
      result.Add(copy(a, 1, y - 1));
    end;
    if (id = 222) or (id = 527) or (id = 528) then
    begin
      delete(a, 1, y);
      y := pos(#9, a);
      result.Add(copy(a, 1, y - 1));
      delete(a, 1, y);
      y := pos(#9, a);
      result.Add(copy(a, 1, y - 1));
    end;
    if (id = 33) or (id = 37) then
    begin
      delete(a, 1, y);
      y := pos(#9, a);
      result.Add(copy(a, 1, y - 1));
      delete(a, 1, y);
      y := pos(#9, a);
      result.Add(copy(a, 1, y - 1));
      delete(a, 1, y);
      y := pos(#9, a);
      result.Add(copy(a, 1, y - 1));
    end;
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

Function GetMonsterParam(monst: TMonster): tstringlist;
var
  x, y, i, id: integer;
  a, name: ansistring;
begin
  if not ((selected > -1) and (sType = 1)) then exit;

  name := GenerateMonsterName(monst, selected, 0);
  id := monst.Skin;
  if (monst.Skin = 65) and (pos('sand', lowercase(name)) > 0)
  or (monst.Skin = 97) and (pos('del', lowercase(name)) > 0)
  or (monst.Skin = 192) and (pos('gal', lowercase(name)) > 0)
  or (monst.Skin = 224) and (pos('epsi', lowercase(name)) > 0)
  then begin
    id := -id;
    a := inttostr(id) + #9;
    for x := 0 to Monsterini.count - 1 do
      if copy(Monsterini.Strings[x], 1, length(a)) = a then
        break;
    if x >= Monsterini.count then
      id := -id;
  end;

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

function FindClosestSection(): integer;
var
  x, d: integer;
  di, ppx2, ppy2: double;
begin
  // Find closest section to the player
  d := -1;
  di := $FFFFFF;
  for x := 0 to 25566 do
  if MidPU[x] then
    begin
    // Find the distance
    ppx2 := ppx - (MidP[x].x * zoom);
    ppy2 := -ppz - (MidP[x].y * zoom);
    ppx2 := (ppx2 * ppx2) + (ppy2 * ppy2);
    // Record if nearest
    if di > ppx2 then
    begin
      di := ppx2;
      d := x;
    end;
  end;
  result := d;
end;

procedure SetMonsterDefaults();
var
  section: integer;
  px, py, px2, py2, pz2: double;
begin
  // Set default monster position based on user's setting
  if form13.focused then
  begin
    if Form1.ComboBox1.ItemIndex > 0 then
      section := strtoint(Form1.ComboBox1.Items.Strings[Form1.ComboBox1.ItemIndex])
    else
      section := FindClosestSection();

    pz2 := form1.YFromBBRELFile(ppx, -ppz);
    pz2 := pz2 - miz[section];

    px2 := (ppx / zoom) - MidP[section].x;
    py2 := (-ppz / zoom) - MidP[section].y;

    px := cos(rev[section] / 10430.37835) * px2 - sin(rev[section] / 10430.37835) * py2;
    py := sin(rev[section] / 10430.37835) * px2 + cos(rev[section] / 10430.37835) * py2;

    px := px * Zoom;
    py := py * Zoom;

    Floor[sfloor].Monster[Floor[sfloor].MonsterCount - 1].map_section := section;
    Floor[sfloor].Monster[Floor[sfloor].MonsterCount - 1].Pos_X := px;
    Floor[sfloor].Monster[Floor[sfloor].MonsterCount - 1].Pos_Y := py;
    Floor[sfloor].Monster[Floor[sfloor].MonsterCount - 1].Pos_Z := pz2;

    selected := Floor[sfloor].MonsterCount - 1;
    stype:=1;
    form1.ListBox1.ItemIndex:=selected;
    form1.DBGrid1.Options := form1.DBGrid1.Options - [dgIndicator];
    form1.DBGrid2.Options := form1.DBGrid2.Options - [dgIndicator];
    form1.PageControl1.ActivePage := form1.TabSheet1;
  end
  else
  begin
    Floor[sfloor].Monster[Floor[sfloor].MonsterCount - 1].map_section := FPlacementOptions.seDefaultSect.Value;
    Floor[sfloor].Monster[Floor[sfloor].MonsterCount - 1].Pos_X := FPlacementOptions.nbDefaultX.Value;
    Floor[sfloor].Monster[Floor[sfloor].MonsterCount - 1].Pos_Y := FPlacementOptions.nbDefaultZ.Value;
    Floor[sfloor].Monster[Floor[sfloor].MonsterCount - 1].Pos_Z := FPlacementOptions.nbDefaultY.Value;
  end;
end;

procedure SetObjectDefaults();
var
  section, i, j: integer;
  px, py, px2, py2, pz2: double;
  found: Boolean;
begin
  // Set default object position based on user's setting
  if form13.focused then
  begin
    if Form1.ComboBox1.ItemIndex > 0 then
      section := strtoint(Form1.ComboBox1.Items.Strings[Form1.ComboBox1.ItemIndex])
    else section := FindClosestSection();

    if Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1].Skin = 11000 then
      section := 0;

    pz2 := form1.YFromBBRELFile(ppx, -ppz);
    pz2 := pz2 - miz[section];

    px2 := (ppx / zoom) - MidP[section].x;
    py2 := (-ppz / zoom) - MidP[section].y;

    px := cos(rev[section] / 10430.37835) * px2 - sin(rev[section] / 10430.37835) * py2;
    py := sin(rev[section] / 10430.37835) * px2 + cos(rev[section] / 10430.37835) * py2;

    px := px * Zoom;
    py := py * Zoom;

    Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1].map_section := section;
    Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1].Pos_X := px;
    Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1].Pos_Y := py;
    Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1].Pos_Z := pz2;

    selected := Floor[sfloor].ObjCount - 1;
    stype:=2;
    form1.ListBox2.ItemIndex:=selected;
    form1.DBGrid1.Options := form1.DBGrid1.Options - [dgIndicator];
    form1.DBGrid2.Options := form1.DBGrid2.Options - [dgIndicator];
    form1.PageControl1.ActivePage := form1.TabSheet2;
  end
  else
  begin
    Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1].map_section := FPlacementOptions.seDefaultSect.Value;
    Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1].Pos_X := FPlacementOptions.nbDefaultX.Value;
    Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1].Pos_Y := FPlacementOptions.nbDefaultZ.Value;
    Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1].Pos_Z := FPlacementOptions.nbDefaultY.Value;
  end;

  // Find the next unused entity ID after 10000 if a snap object
  if Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1].Skin = 10000 then
  begin
    for i := 10001 to 65535 do
    begin
      found := false;
      for j := 0 to Floor[sFloor].MonsterCount - 1 do
        if Floor[sFloor].Monster[j].unknow4 = i then
          found := true;
      for j := 0 to Floor[sFloor].ObjCount - 1 do
        if Floor[sFloor].Obj[j].id = i then
          found := true;
      if not found then break;
    end;
    Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1].id := i;
  end;
end;

procedure ShowIndicator();
begin
  if previewstate > 0 then
  begin
    previewpaused := true;
    form1.DrawMap;
    exit;
  end;
  if not Form1.smDisableIndicator.Checked then
  begin
    Form1.lblStatus.Visible := true;
    if not placerandom and not placelookat then
    begin
      Form1.lblModifiers.Visible := true;
      Form1.lblStatus.Caption := GetLanguageString(425);
    end;
  end;
end;

procedure HideIndicator();
begin
  if not Form1.smDisableIndicator.Checked then
  begin
    Form1.lblStatus.Visible := false;
    Form1.lblModifiers.Visible := false;
  end;
  placerandom := false;
  placelookat := false;
end;

procedure AdjustDistanceX(target: integer);
var
  i,closest,selectionidx: integer;
  selectionX,targetX: single;
  diff,diffmin: double;
begin
  if FSnapOptions.chkSnapDistance.Checked then
  begin
    diff := 0;
    diffmin := Double.MaxValue;
    closest := -1;

    if have3d and form13.Focused then
      selectionidx := selected
    else
      selectionidx := MoveSel;

    if sType = 1 then
    begin
      selectionX := Floor[sfloor].Monster[selectionidx].Pos_X;
      targetX := Floor[sfloor].Monster[target].Pos_X;

      if selectionX < targetX then
      begin
          // First find the next closest from the target in the opposite direction
          for i := 0 to Floor[sfloor].MonsterCount - 1 do
          begin
            if (Floor[sfloor].Monster[i].map_section = Floor[sfloor].Monster[target].map_section) and
              ((Floor[sfloor].Monster[i].Unknow5 = showwave) or (showwave = -1)) and (Floor[sfloor].Monster[i].Pos_X > targetX)
              and (round(Floor[sfloor].Monster[i].Pos_Y) = round(Floor[sfloor].Monster[target].Pos_Y))
              and (i <> target) and (i <> selectionidx) then
              begin
                diff := abs(targetX - Floor[sfloor].Monster[i].Pos_X);
                if diff < diffmin then
                begin
                  diffmin := diff;
                  closest := i;
                end;
              end;
          end;
          // Find the difference
          if closest <> -1 then
            diff := abs(targetX - Floor[sfloor].Monster[closest].Pos_X);
         // Offset the selection by the difference
         if diff <> 0 then
          Floor[sfloor].Monster[selectionidx].Pos_X := targetX - diff;
      end
      else if selectionX > targetX then
      begin
          // First find the next closest from the target in the opposite direction
          for i := 0 to Floor[sfloor].MonsterCount - 1 do
          begin
            if (Floor[sfloor].Monster[i].map_section = Floor[sfloor].Monster[target].map_section) and
              ((Floor[sfloor].Monster[i].Unknow5 = showwave) or (showwave = -1)) and (Floor[sfloor].Monster[i].Pos_X < targetX)
              and (round(Floor[sfloor].Monster[i].Pos_Y) = round(Floor[sfloor].Monster[target].Pos_Y))
              and (i <> target) and (i <> selectionidx) then
              begin
                diff := abs(targetX - Floor[sfloor].Monster[i].Pos_X);
                if diff < diffmin then
                begin
                  diffmin := diff;
                  closest := i;
                end;
              end;
          end;
          // Find the difference
          if closest <> -1 then
            diff := abs(targetX - Floor[sfloor].Monster[closest].Pos_X);
         // Offset the selection by the difference
         if diff <> 0 then
          Floor[sfloor].Monster[selectionidx].Pos_X := targetX + diff;
      end
    end;

    if sType = 2 then
    begin
      selectionX := Floor[sfloor].obj[selectionidx].Pos_X;
      targetX := Floor[sfloor].obj[target].Pos_X;

      if selectionX < targetX then
      begin
          // First find the next closest from the target in the opposite direction
          for i := 0 to Floor[sfloor].ObjCount - 1 do
          begin
            if (Floor[sfloor].Obj[i].map_section = Floor[sfloor].Obj[target].map_section) and
              ((Floor[sfloor].Obj[i].grp = showgrp) or (showgrp = -1)) and (Floor[sfloor].Obj[i].Pos_X > targetX)
              and (round(Floor[sfloor].Obj[i].Pos_Y) = round(Floor[sfloor].Obj[target].Pos_Y))
              and (i <> target) and (i <> selectionidx) then
              begin
                diff := abs(targetX - Floor[sfloor].Obj[i].Pos_X);
                if diff < diffmin then
                begin
                  diffmin := diff;
                  closest := i;
                end;
              end;
          end;
          // Find the difference
          if closest <> -1 then
            diff := abs(targetX - Floor[sfloor].Obj[closest].Pos_X);
         // Offset the selection by the difference
         if diff <> 0 then
          Floor[sfloor].Obj[selectionidx].Pos_X := targetX - diff;
      end
      else if selectionX > targetX then
      begin
          // First find the next closest from the target in the opposite direction
          for i := 0 to Floor[sfloor].ObjCount - 1 do
          begin
            if (Floor[sfloor].Obj[i].map_section = Floor[sfloor].Obj[target].map_section) and
              ((Floor[sfloor].Obj[i].grp = showgrp) or (showgrp = -1)) and (Floor[sfloor].Obj[i].Pos_X < targetX)
              and (round(Floor[sfloor].Obj[i].Pos_Y) = round(Floor[sfloor].Obj[target].Pos_Y))
              and (i <> target) and (i <> selectionidx) then
              begin
                diff := abs(targetX - Floor[sfloor].Obj[i].Pos_X);
                if diff < diffmin then
                begin
                  diffmin := diff;
                  closest := i;
                end;
              end;
          end;
          // Find the difference
          if closest <> -1 then
            diff := abs(targetX - Floor[sfloor].Obj[closest].Pos_X);
         // Offset the selection by the difference
         if diff <> 0 then
          Floor[sfloor].Obj[selectionidx].Pos_X := targetX + diff;
      end
    end;
  end;
end;

procedure AdjustDistanceY(target: integer);
var
  i,closest,selectionidx: integer;
  selectionY,targetY: single;
  diff,diffmin: double;
begin
  if FSnapOptions.chkSnapDistance.Checked then
  begin
    diff := 0;
    diffmin := Double.MaxValue;
    closest := -1;

    if have3d and form13.Focused then
      selectionidx := selected
    else
      selectionidx := MoveSel;

    if sType = 1 then
    begin
      selectionY := Floor[sfloor].Monster[selectionidx].Pos_Y;
      targetY := Floor[sfloor].Monster[target].Pos_Y;

      if selectionY < targetY then
      begin
          // First find the next closest from the target in the opposite direction
          for i := 0 to Floor[sfloor].MonsterCount - 1 do
          begin
            if (Floor[sfloor].Monster[i].map_section = Floor[sfloor].Monster[target].map_section) and
              ((Floor[sfloor].Monster[i].Unknow5 = showwave) or (showwave = -1)) and (Floor[sfloor].Monster[i].Pos_Y > targetY)
              and (round(Floor[sfloor].Monster[i].Pos_X) = round(Floor[sfloor].Monster[target].Pos_X))
              and (i <> target) and (i <> selectionidx) then
              begin
                diff := abs(targetY - Floor[sfloor].Monster[i].Pos_Y);
                if diff < diffmin then
                begin
                  diffmin := diff;
                  closest := i;
                end;
              end;
          end;
          // Find the difference
          if closest <> -1 then
            diff := abs(targetY - Floor[sfloor].Monster[closest].Pos_Y);
         // Offset the selection by the difference
         if diff <> 0 then
          Floor[sfloor].Monster[selectionidx].Pos_Y := targetY - diff;
      end
      else if selectionY > targetY then
      begin
          // First find the next closest from the target in the opposite direction
          for i := 0 to Floor[sfloor].MonsterCount - 1 do
          begin
            if (Floor[sfloor].Monster[i].map_section = Floor[sfloor].Monster[target].map_section) and
              ((Floor[sfloor].Monster[i].Unknow5 = showwave) or (showwave = -1)) and (Floor[sfloor].Monster[i].Pos_Y < targetY)
              and (round(Floor[sfloor].Monster[i].Pos_X) = round(Floor[sfloor].Monster[target].Pos_X))
              and (i <> target) and (i <> selectionidx) then
              begin
                diff := abs(targetY - Floor[sfloor].Monster[i].Pos_Y);
                if diff < diffmin then
                begin
                  diffmin := diff;
                  closest := i;
                end;
              end;
          end;
          // Find the difference
          if closest <> -1 then
            diff := abs(targetY - Floor[sfloor].Monster[closest].Pos_Y);
         // Offset the selection by the difference
         if diff <> 0 then
          Floor[sfloor].Monster[selectionidx].Pos_Y := targetY + diff;
      end
    end;

    if sType = 2 then
    begin
      selectionY := Floor[sfloor].obj[selectionidx].Pos_Y;
      targetY := Floor[sfloor].obj[target].Pos_Y;

      if selectionY < targetY then
      begin
          // First find the next closest from the target in the opposite direction
          for i := 0 to Floor[sfloor].ObjCount - 1 do
          begin
            if (Floor[sfloor].Obj[i].map_section = Floor[sfloor].Obj[target].map_section) and
              ((Floor[sfloor].Obj[i].grp = showgrp) or (showgrp = -1)) and (Floor[sfloor].Obj[i].Pos_Y > targetY)
              and (round(Floor[sfloor].Obj[i].Pos_X) = round(Floor[sfloor].Obj[target].Pos_X))
              and (i <> target) and (i <> selectionidx) then
              begin
                diff := abs(targetY - Floor[sfloor].Obj[i].Pos_Y);
                if diff < diffmin then
                begin
                  diffmin := diff;
                  closest := i;
                end;
              end;
          end;
          // Find the difference
          if closest <> -1 then
            diff := abs(targetY - Floor[sfloor].Obj[closest].Pos_Y);
         // Offset the selection by the difference
         if diff <> 0 then
          Floor[sfloor].Obj[selectionidx].Pos_Y := targetY - diff;
      end
      else if selectionY > targetY then
      begin
          // First find the next closest from the target in the opposite direction
          for i := 0 to Floor[sfloor].ObjCount - 1 do
          begin
            if (Floor[sfloor].Obj[i].map_section = Floor[sfloor].Obj[target].map_section) and
              ((Floor[sfloor].Obj[i].grp = showgrp) or (showgrp = -1)) and (Floor[sfloor].Obj[i].Pos_Y < targetY)
              and (round(Floor[sfloor].Obj[i].Pos_X) = round(Floor[sfloor].Obj[target].Pos_X))
              and (i <> target) and (i <> selectionidx) then
              begin
                diff := abs(targetY - Floor[sfloor].Obj[i].Pos_Y);
                if diff < diffmin then
                begin
                  diffmin := diff;
                  closest := i;
                end;
              end;
          end;
          // Find the difference
          if closest <> -1 then
            diff := abs(targetY - Floor[sfloor].Obj[closest].Pos_Y);
         // Offset the selection by the difference
         if diff <> 0 then
          Floor[sfloor].Obj[selectionidx].Pos_Y := targetY + diff;
      end
    end;
  end;
end;

procedure AdjustDistanceZ(target: integer);
var
  i,closest: integer;
  selectionZ,targetZ: single;
  diff,diffmin: double;
begin
  if FSnapOptions.chkSnapDistance.Checked then
  begin
    diff := 0;
    diffmin := Double.MaxValue;
    closest := -1;

    if sType = 1 then
    begin
      selectionZ := Floor[sfloor].Monster[selected].Pos_Z;
      targetZ := Floor[sfloor].Monster[target].Pos_Z;

      if selectionZ < targetZ then
      begin
          // First find the next closest from the target in the opposite direction
          for i := 0 to Floor[sfloor].MonsterCount - 1 do
          begin
            if (Floor[sfloor].Monster[i].map_section = Floor[sfloor].Monster[target].map_section) and
              ((Floor[sfloor].Monster[i].Unknow5 = showwave) or (showwave = -1)) and (Floor[sfloor].Monster[i].Pos_Z > targetZ)
              and (round(Floor[sfloor].Monster[i].Pos_X) = round(Floor[sfloor].Monster[target].Pos_X))
              and (round(Floor[sfloor].Monster[i].Pos_Y) = round(Floor[sfloor].Monster[target].Pos_Y))
              and (i <> target) and (i <> selected) then
              begin
                diff := abs(targetZ - Floor[sfloor].Monster[i].Pos_Z);
                if diff < diffmin then
                begin
                  diffmin := diff;
                  closest := i;
                end;
              end;
          end;
          // Find the difference
          if closest <> -1 then
            diff := abs(targetZ - Floor[sfloor].Monster[closest].Pos_Z);
         // Offset the selection by the difference
         if diff <> 0 then
          Floor[sfloor].Monster[selected].Pos_Z := targetZ - diff;
      end
      else if selectionZ > targetZ then
      begin
          // First find the next closest from the target in the opposite direction
          for i := 0 to Floor[sfloor].MonsterCount - 1 do
          begin
            if (Floor[sfloor].Monster[i].map_section = Floor[sfloor].Monster[target].map_section) and
              ((Floor[sfloor].Monster[i].Unknow5 = showwave) or (showwave = -1)) and (Floor[sfloor].Monster[i].Pos_Z < targetZ)
              and (round(Floor[sfloor].Monster[i].Pos_X) = round(Floor[sfloor].Monster[target].Pos_X))
              and (round(Floor[sfloor].Monster[i].Pos_Y) = round(Floor[sfloor].Monster[target].Pos_Y))
              and (i <> target) and (i <> selected) then
              begin
                diff := abs(targetZ - Floor[sfloor].Monster[i].Pos_Z);
                if diff < diffmin then
                begin
                  diffmin := diff;
                  closest := i;
                end;
              end;
          end;
          // Find the difference
          if closest <> -1 then
            diff := abs(targetZ - Floor[sfloor].Monster[closest].Pos_Z);
         // Offset the selection by the difference
         if diff <> 0 then
          Floor[sfloor].Monster[selected].Pos_Z := targetZ + diff;
      end
    end;

    if sType = 2 then
    begin
      selectionZ := Floor[sfloor].obj[selected].Pos_Z;
      targetZ := Floor[sfloor].obj[target].Pos_Z;

      if selectionZ < targetZ then
      begin
          // First find the next closest from the target in the opposite direction
          for i := 0 to Floor[sfloor].ObjCount - 1 do
          begin
            if (Floor[sfloor].Obj[i].map_section = Floor[sfloor].Obj[target].map_section) and
              ((Floor[sfloor].Obj[i].grp = showgrp) or (showgrp = -1)) and (Floor[sfloor].Obj[i].Pos_Z > targetZ)
              and (round(Floor[sfloor].Obj[i].Pos_X) = round(Floor[sfloor].Obj[target].Pos_X))
              and (round(Floor[sfloor].Obj[i].Pos_Y) = round(Floor[sfloor].Obj[target].Pos_Y))
              and (i <> target) and (i <> selected) then
              begin
                diff := abs(targetZ - Floor[sfloor].Obj[i].Pos_Z);
                if diff < diffmin then
                begin
                  diffmin := diff;
                  closest := i;
                end;
              end;
          end;
          // Find the difference
          if closest <> -1 then
            diff := abs(targetZ - Floor[sfloor].Obj[closest].Pos_Z);
         // Offset the selection by the difference
         if diff <> 0 then
          Floor[sfloor].Obj[selected].Pos_Z := targetZ - diff;
      end
      else if selectionZ > targetZ then
      begin
          // First find the next closest from the target in the opposite direction
          for i := 0 to Floor[sfloor].ObjCount - 1 do
          begin
            if (Floor[sfloor].Obj[i].map_section = Floor[sfloor].Obj[target].map_section) and
              ((Floor[sfloor].Obj[i].grp = showgrp) or (showgrp = -1)) and (Floor[sfloor].Obj[i].Pos_Z < targetZ)
              and (round(Floor[sfloor].Obj[i].Pos_X) = round(Floor[sfloor].Obj[target].Pos_X))
              and (round(Floor[sfloor].Obj[i].Pos_Y) = round(Floor[sfloor].Obj[target].Pos_Y))
              and (i <> target) and (i <> selected) then
              begin
                diff := abs(targetZ - Floor[sfloor].Obj[i].Pos_Z);
                if diff < diffmin then
                begin
                  diffmin := diff;
                  closest := i;
                end;
              end;
          end;
          // Find the difference
          if closest <> -1 then
            diff := abs(targetZ - Floor[sfloor].Obj[closest].Pos_Z);
         // Offset the selection by the difference
         if diff <> 0 then
          Floor[sfloor].Obj[selected].Pos_Z := targetZ + diff;
      end
    end;
  end;
end;

procedure CalculateWarpOffsets(rotation: dword);
var
  angle: single;
begin
  rotation := rotation mod 65536;
  warpx := -10;
  warpz := -10;

  if rotation <> 0 then
  begin
    angle := abs(65536 / rotation);
    angle := 360 / angle;
    angle := angle * Pi / 180;
    warpx := -(10 * sin(angle) + 10 * cos(angle));
    warpz := -(10 * cos(angle) - 10 * sin(angle));
  end;
end;

function SanitizeFileName(const AFileName: string): string;
const
  InvalidChars: set of Char = ['\', '/', ':', '*', '?', '"', '<', '>', '|'];
var
  I: Integer;
  ResultFileName: string;
begin
  ResultFileName := '';
  for I := 1 to Length(AFileName) do
  begin
    if not (AFileName[I] in InvalidChars) and (Ord(AFileName[I]) >= 32) then // Exclude control characters and invalid chars
    begin
      ResultFileName := ResultFileName + AFileName[I];
    end;
  end;

  // Handle trailing periods/spaces for Windows compatibility
  while (Length(ResultFileName) > 0) and (ResultFileName[Length(ResultFileName)] in ['.', ' ']) do
  begin
    SetLength(ResultFileName, Length(ResultFileName) - 1);
  end;

  // Truncate to a maximum of 249 characters to allow room for ' notes' suffix
  if Length(ResultFileName) > 249 then
  begin
    SetLength(ResultFileName, 249);
  end;

  // Ensure a non-empty filename, if all characters were invalid
  if ResultFileName = '' then
    ResultFileName := 'Untitled';

  Result := ResultFileName;
end;

procedure SetCoordSize(size: integer);
var
  Reg: TRegistry;
begin
  form1.Smallfont1.Checked := false;
  form1.Mediumfont1.Checked := false;
  form1.Largefont1.Checked := false;

  if size = 1 then
  begin
    form1.label5.Font.Size := 10;
    form1.Mediumfont1.Checked := true;
    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\schthack\qedit', true) then
    begin
      Reg.WriteInteger('CoordSize', 1);
      Reg.CloseKey;
    end;
    finally
      Reg.Free;
    end;
  end
  else if size = 2 then
  begin
    form1.label5.Font.Size := 12;
    form1.Largefont1.Checked := true;
    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\schthack\qedit', true) then
    begin
      Reg.WriteInteger('CoordSize', 2);
      Reg.CloseKey;
    end;
    finally
      Reg.Free;
    end;
  end
  else
  begin
    form1.label5.Font.Size := 8;
    form1.Smallfont1.Checked := true;
    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\schthack\qedit', true) then
    begin
      Reg.WriteInteger('CoordSize', 0);
      Reg.CloseKey;
    end;
    finally
      Reg.Free;
    end;
  end;
end;

function ReplaceTabs(const S: string): string;
var
  First8, Rest: string;
begin
  First8 := Copy(S, 1, 8);
  Rest := Copy(S, 9, MaxInt);

  First8 := StringReplace(First8, #9, '  ', [rfReplaceAll]);

  Result := First8 + Rest;
end;

procedure UpdateWindowTitle;
var
  tmp2: widestring;
begin
  if isdc then
    tmp2 := 'Quest Editor v2.0c Public - ' + unitochar(Title,1000)
  else
    tmp2 := 'Quest Editor v2.0c Public - ' + Title;

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
  Form1.Caption := tmp2;
end;

procedure AddRoomEntry(section: integer; x: double; y: double; z: double);
var
  i, j, roomIndex, insertRow, insertPos, oldSize, idx, newrotation: Integer;
  sx, sy, sz: single;
  found: Boolean;
begin
  sx := x;
  sy := y;
  sz := z;

  for i := 0 to length(roomdata) do if roomdata[i].roomnum = section then break;
  roomIndex := i;

  if roomIndex > length(roomdata) then
  begin
    // Create a new room with the entry values
    SetLength(roomdata, Length(roomdata) + 1);
    idx := High(roomdata);
    with roomdata[idx] do
    begin
      roomnum := section;
      numentries := 1;
      SetLength(data, 28);
      FillChar(data[0], 28, 0);
      move(sx, data[0], 4);
      move(sz, data[4], 4);
      move(sy, data[8], 4);
      newrotation := -(placerotation + rev[section]);
      move(newrotation, data[16], 4);
      move(roomnum, data[24], 2);
    end;
    Form1.Button12.Enabled := true;
    exit;
  end;

  // Number of existing entries in this room
  oldSize := Length(roomdata[roomIndex].data);

  // Insert at the end
  insertPos := oldSize;

  // Expand data for one more entry
  SetLength(roomdata[roomIndex].data, oldSize + 28);

  // Zero the new block
  FillChar(roomdata[roomIndex].data[insertPos], 28, 0);

  // Set X/Y/Z location and rotation
  move(sx, roomdata[roomIndex].data[insertPos + 0], 4);
  move(sz, roomdata[roomIndex].data[insertPos + 4], 4);
  move(sy, roomdata[roomIndex].data[insertPos + 8], 4);
  newrotation := -(placerotation + rev[section]);
  move(newrotation, roomdata[roomIndex].data[insertPos + 16], 4);

  // Set room ID
  move(roomdata[roomIndex].roomnum, roomdata[roomIndex].data[insertPos + 24], 2);

  // Set entry #
  for i := 0 to 65535 do
  begin
    found := false;
    for j := 0 to roomdata[roomIndex].numentries do
    begin
      if roomdata[roomIndex].data[(j*28) + 26] = i then
      begin
        found := true;
        break;
      end;
    end;
    if not found then
      break;
  end;
  move(i, roomdata[roomIndex].data[insertPos + 26], 2);

  // Increase total
  Inc(roomdata[roomIndex].numentries);
  Form1.Button12.Enabled := true;
end;

procedure SetImage1Colors;
begin
  if (TStyleManager.ActiveStyle.Name <> 'Obsidian') and
  (TStyleManager.ActiveStyle.Name <> 'Windows10 Blue') and
  (TStyleManager.ActiveStyle.Name <> 'Windows10 Green') and
  (TStyleManager.ActiveStyle.Name <> 'Windows10 Purple')
  then
  begin
    form1.Image1.Canvas.Brush.Color := TStyleManager.ActiveStyle.GetStyleColor(scListBox);
    form1.Image1.Canvas.Font.Color := TStyleManager.ActiveStyle.GetStyleFontColor(sfTextLabelNormal);
  end
  else
  begin
    form1.Image1.Canvas.Brush.Color := TStyleManager.ActiveStyle.GetStyleColor(scListBox);
    form1.Image1.Canvas.Font.Color := clBlack;
  end;
  form1.Panel1.Color := TStyleManager.ActiveStyle.GetStyleColor(scListBox);
  form1.Image1.Canvas.FillRect(form1.Image1.Canvas.ClipRect);
end;

procedure TForm1.CheckListBox1Click(Sender: TObject);
var
  x: integer;
begin
  if CheckListBox1.ItemIndex >= 0 then
  begin
    if previewstate > 0 then
    begin
      if prevfloor <> CheckListBox1.ItemIndex then
        ResetPreviewState
      else previewpaused := true;
    end;
    HideIndicator();
    if not indelete and not inundo then
    begin
      Copylastmonster1.Enabled := false;
      Copylastitem1.Enabled := false;
    end;
    ListBox1.Clear;
    ListBox2.Clear;
    Selected := -1;
    if not indelete then
    begin
      DBGrid1.Options := DBGrid1.Options - [dgMultiSelect];
      DBGrid2.Options := DBGrid2.Options - [dgMultiSelect];
    end;
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
    transform1.Enabled := false;
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
    if form17.chkFollow.Checked and not inundo and not indelete
    and (previewstate = 0) then
    begin
      ppx := 0;
      ppy := YFromBBRELFile(0,0) + 15;
      ppz := 0;
      vr := 0;
      vz := 0;
    end;
    if have3d then
    begin
      load3d;
      if form17.chkFollow.Checked and not inundo and not indelete
      and (previewstate = 0) then
        myscreen.SetView(ppx,ppy,ppz,vr,vz);
    end;

    ClearBMPCache;
    LoadFloorGrids;
    // Save the last selected floor
    prevfloor := CheckListBox1.ItemIndex;
    if showgrid then
    begin
      DBGrid1.Options := DBGrid1.Options - [dgIndicator];
      DBGrid2.Options := DBGrid2.Options - [dgIndicator];
      gridtype := -1;
    end;
  end;
end;

procedure TForm1.ClientDataSet1AfterScroll(DataSet: TDataSet);
begin
  if (not ClientDataSet1.isEmpty and (selected > -1) and monstgridfocused
  and showgrid and not ClientDataSet1.ControlsDisabled) or (DataSet = nil) then
  begin
    sType := 1;
    gridtype := 1;
    selected := strtointdef(DBGrid1.DataSource.DataSet.FieldByName('#').AsString, -1);
    listbox1.ItemIndex := selected;
    listbox2.ItemIndex := -1;
    listbox1click(DBGrid1);
    DBGrid1.SelectedIndex := grid1col;
    DrawMap;
  end;
end;

procedure TForm1.ClientDataSet1ChildCountSetText(Sender: TField;
  const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Monster[ClientDataSet1.FieldByName('#').AsInteger].unknow2 := strtoint(Text) * $10000;
    if have3d then
        GenerateMonsterName(Floor[sfloor].Monster[selected],selected,2);
    Listbox1Click(nil);
  end;
end;

procedure TForm1.ClientDataSet1Param1SetText(Sender: TField;
  const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Monster[ClientDataSet1.FieldByName('#').AsInteger].Unknow8 := strtoint(Text);
    if have3d then
        GenerateMonsterName(Floor[sfloor].Monster[selected],selected,2);
    Listbox1Click(nil);
  end;
end;

procedure TForm1.ClientDataSet1Param2SetText(Sender: TField;
  const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Monster[ClientDataSet1.FieldByName('#').AsInteger].Movement_data := strtofloat(Text);
    if have3d then
        GenerateMonsterName(Floor[sfloor].Monster[selected],selected,2);
    Listbox1Click(nil);
  end;
end;

procedure TForm1.ClientDataSet1Param3SetText(Sender: TField;
  const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Monster[ClientDataSet1.FieldByName('#').AsInteger].Unknow10 := strtofloat(Text);
    if have3d then
        GenerateMonsterName(Floor[sfloor].Monster[selected],selected,2);
    Listbox1Click(nil);
  end;
end;

procedure TForm1.ClientDataSet1Param4SetText(Sender: TField;
  const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Monster[ClientDataSet1.FieldByName('#').AsInteger].Unknow11 := strtofloat(Text);
    if have3d then
        GenerateMonsterName(Floor[sfloor].Monster[selected],selected,2);
    Listbox1Click(nil);
  end;
end;

procedure TForm1.ClientDataSet1Param5SetText(Sender: TField;
  const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Monster[ClientDataSet1.FieldByName('#').AsInteger].Char_id := strtofloat(Text);
    if have3d then
        GenerateMonsterName(Floor[sfloor].Monster[selected],selected,2);
    Listbox1Click(nil);
  end;
end;

procedure TForm1.ClientDataSet1Param6SetText(Sender: TField;
  const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Monster[ClientDataSet1.FieldByName('#').AsInteger].Action := strtofloat(Text);
    if have3d then
        GenerateMonsterName(Floor[sfloor].Monster[selected],selected,2);
    Listbox1Click(nil);
  end;
end;

procedure TForm1.ClientDataSet1Param7SetText(Sender: TField;
  const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Monster[ClientDataSet1.FieldByName('#').AsInteger].Movement_flag := strtoint(Text);
    if have3d then
        GenerateMonsterName(Floor[sfloor].Monster[selected],selected,2);
    Listbox1Click(nil);
  end;
end;

procedure TForm1.ClientDataSet1PositionXSetText(Sender: TField;
  const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Monster[ClientDataSet1.FieldByName('#').AsInteger].Pos_X := strtofloat(Text);
    if have3d then
        GenerateMonsterName(Floor[sfloor].Monster[selected],selected,2);
    Listbox1Click(nil);
  end;
end;

procedure TForm1.ClientDataSet1PositionYSetText(Sender: TField;
  const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Monster[ClientDataSet1.FieldByName('#').AsInteger].Pos_Z := strtofloat(Text);
    if have3d then
        GenerateMonsterName(Floor[sfloor].Monster[selected],selected,2);
    Listbox1Click(nil);
  end;
end;

procedure TForm1.ClientDataSet1PositionZSetText(Sender: TField;
  const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Monster[ClientDataSet1.FieldByName('#').AsInteger].Pos_Y := strtofloat(Text);
    if have3d then
        GenerateMonsterName(Floor[sfloor].Monster[selected],selected,2);
    Listbox1Click(nil);
  end;
end;

procedure TForm1.ClientDataSet1RotationYGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if not Sender.IsNull and not editgrid then
  begin
    Text := Sender.AsString + #$00B0;
  end
  else Text := Sender.AsString;
end;

procedure TForm1.ClientDataSet1RotationYSetText(Sender: TField;
  const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Monster[ClientDataSet1.FieldByName('#').AsInteger].Direction := strtoint(Text);
    if have3d then
        GenerateMonsterName(Floor[sfloor].Monster[selected],selected,2);
    Listbox1Click(nil);
  end;
end;

procedure TForm1.ClientDataSet1SectionSetText(Sender: TField;
  const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Monster[ClientDataSet1.FieldByName('#').AsInteger].map_section := strtoint(Text);
    if have3d then
        GenerateMonsterName(Floor[sfloor].Monster[selected],selected,2);
    Listbox1Click(nil);
  end;
end;

procedure TForm1.ClientDataSet1SkinSetText(Sender: TField; const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Monster[ClientDataSet1.FieldByName('#').AsInteger].Skin := strtoint(Text);
    if have3d then
        GenerateMonsterName(Floor[sfloor].Monster[selected],selected,2);
    Listbox1Click(nil);
  end;
end;

procedure TForm1.ClientDataSet1WaveSetText(Sender: TField; const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Monster[ClientDataSet1.FieldByName('#').AsInteger].Unknow5 := strtoint(Text);
    if have3d then
        GenerateMonsterName(Floor[sfloor].Monster[selected],selected,2);
    Listbox1Click(nil);
  end;
end;

procedure TForm1.ClientDataSet2AfterScroll(DataSet: TDataSet);
begin
  if (not ClientDataSet2.isEmpty and (selected > -1) and objgridfocused
  and showgrid and not ClientDataSet2.ControlsDisabled) or (DataSet = nil) then
  begin
    sType := 2;
    gridtype := 2;
    selected := strtointdef(DBGrid2.DataSource.DataSet.FieldByName('#').AsString, -1);
    listbox2.ItemIndex := selected;
    listbox1.ItemIndex := -1;
    listbox2click(DBGrid2);
    DBGrid2.SelectedIndex := grid2col;
    DrawMap;
  end;
end;

procedure TForm1.ClientDataSet2GroupSetText(Sender: TField; const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Obj[ClientDataSet2.FieldByName('#').AsInteger].grp := strtoint(Text);
    if have3d then
    begin
       myobj[selected].Free;
       Generateobj(Floor[sfloor].obj[selected],selected);
    end;
    Listbox2Click(nil);
  end;
end;

procedure TForm1.ClientDataSet2Param1SetText(Sender: TField;
  const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Obj[ClientDataSet2.FieldByName('#').AsInteger].unknow8 := strtofloat(Text);
    if have3d then
    begin
       myobj[selected].Free;
       Generateobj(Floor[sfloor].obj[selected],selected);
    end;
    Listbox2Click(nil);
  end;
end;

procedure TForm1.ClientDataSet2Param2SetText(Sender: TField;
  const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Obj[ClientDataSet2.FieldByName('#').AsInteger].unknow9 := strtofloat(Text);
    if have3d then
    begin
       myobj[selected].Free;
       Generateobj(Floor[sfloor].obj[selected],selected);
    end;
    Listbox2Click(nil);
  end;
end;

procedure TForm1.ClientDataSet2Param3SetText(Sender: TField;
  const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Obj[ClientDataSet2.FieldByName('#').AsInteger].Unknow10 := strtofloat(Text);
    if have3d then
    begin
       myobj[selected].Free;
       Generateobj(Floor[sfloor].obj[selected],selected);
    end;
    Listbox2Click(nil);
  end;
end;

procedure TForm1.ClientDataSet2Param4SetText(Sender: TField;
  const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Obj[ClientDataSet2.FieldByName('#').AsInteger].obj_id := strtoint(Text);
    if have3d then
    begin
       myobj[selected].Free;
       Generateobj(Floor[sfloor].obj[selected],selected);
    end;
    Listbox2Click(nil);
  end;
end;

procedure TForm1.ClientDataSet2Param5SetText(Sender: TField;
  const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Obj[ClientDataSet2.FieldByName('#').AsInteger].Action := strtoint(Text);
    if have3d then
    begin
       myobj[selected].Free;
       Generateobj(Floor[sfloor].obj[selected],selected);
    end;
    Listbox2Click(nil);
  end;
end;

procedure TForm1.ClientDataSet2Param6SetText(Sender: TField;
  const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Obj[ClientDataSet2.FieldByName('#').AsInteger].unknow13 := strtoint(Text);
    if have3d then
    begin
       myobj[selected].Free;
       Generateobj(Floor[sfloor].obj[selected],selected);
    end;
    Listbox2Click(nil);
  end;
end;

procedure TForm1.ClientDataSet2PosXSetText(Sender: TField; const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Obj[ClientDataSet2.FieldByName('#').AsInteger].Pos_X := strtofloat(Text);
    if have3d then
    begin
       myobj[selected].Free;
       Generateobj(Floor[sfloor].obj[selected],selected);
    end;
    Listbox2Click(nil);
  end;
end;

procedure TForm1.ClientDataSet2PosYSetText(Sender: TField; const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Obj[ClientDataSet2.FieldByName('#').AsInteger].Pos_Z := strtofloat(Text);
    if have3d then
    begin
       myobj[selected].Free;
       Generateobj(Floor[sfloor].obj[selected],selected);
    end;
    Listbox2Click(nil);
  end;
end;

procedure TForm1.ClientDataSet2PosZSetText(Sender: TField; const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Obj[ClientDataSet2.FieldByName('#').AsInteger].Pos_Y := strtofloat(Text);
    if have3d then
    begin
       myobj[selected].Free;
       Generateobj(Floor[sfloor].obj[selected],selected);
    end;
    Listbox2Click(nil);
  end;
end;

procedure TForm1.ClientDataSet2RotXGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if not Sender.IsNull and not editgrid then
  begin
    Text := Sender.AsString + #$00B0;
  end
  else Text := Sender.AsString;
end;

procedure TForm1.ClientDataSet2RotXSetText(Sender: TField; const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Obj[ClientDataSet2.FieldByName('#').AsInteger].Unknow5 := strtoint(Text);
    if have3d then
    begin
       myobj[selected].Free;
       Generateobj(Floor[sfloor].obj[selected],selected);
    end;
    Listbox2Click(nil);
  end;
end;

procedure TForm1.ClientDataSet2RotYGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if not Sender.IsNull and not editgrid then
  begin
    Text := Sender.AsString + #$00B0;
  end
  else Text := Sender.AsString;
end;

procedure TForm1.ClientDataSet2RotYSetText(Sender: TField; const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Obj[ClientDataSet2.FieldByName('#').AsInteger].Unknow6 := strtoint(Text);
    if have3d then
    begin
       myobj[selected].Free;
       Generateobj(Floor[sfloor].obj[selected],selected);
    end;
    Listbox2Click(nil);
  end;
end;

procedure TForm1.ClientDataSet2RotZGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if not Sender.IsNull and not editgrid then
  begin
    Text := Sender.AsString + #$00B0;
  end
  else Text := Sender.AsString;
end;

procedure TForm1.ClientDataSet2RotZSetText(Sender: TField; const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Obj[ClientDataSet2.FieldByName('#').AsInteger].Unknow7 := strtoint(Text);
    if have3d then
    begin
       myobj[selected].Free;
       Generateobj(Floor[sfloor].obj[selected],selected);
    end;
    Listbox2Click(nil);
  end;
end;

procedure TForm1.ClientDataSet2SectionSetText(Sender: TField;
  const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Obj[ClientDataSet2.FieldByName('#').AsInteger].map_section := strtoint(Text);
    if have3d then
    begin
       myobj[selected].Free;
       Generateobj(Floor[sfloor].obj[selected],selected);
    end;
    Listbox2Click(nil);
  end;
end;

procedure TForm1.ClientDataSet2SkinSetText(Sender: TField; const Text: string);
begin
  if not Sender.IsNull and (Text <> '') and editgrid and (selected > -1) then
  begin
    isedited := true;
    SetUndow;
    Floor[sFloor].Obj[ClientDataSet2.FieldByName('#').AsInteger].Skin := strtoint(Text);
    if have3d then
    begin
       myobj[selected].Free;
       Generateobj(Floor[sfloor].obj[selected],selected);
    end;
    Listbox2Click(nil);
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
  na: ansistring;
  hs: TMemoryStream;
  x: integer;
begin
  if ListBox1.ItemIndex >= 0 then
  begin
    monstgridfocused := false;
    objgridfocused := false;
    Selected := ListBox1.ItemIndex;
    ListBox2.ItemIndex := -1;
    MoveSel := -1;
    HideIndicator();
    stype := 1;
    gridtype := 1;
    Button2.Enabled := true;
    Button1.Enabled := true;
    Button3.Enabled := true;
    smEdit.Enabled := true;
    smDelete.Enabled := true;
    smMove.Enabled := true;
    transform1.Enabled := true;
    sms := Floor[sfloor].Monster[Selected].map_section;
    DrawMap;
    SetImage1Colors;
    Image1.Canvas.FillRect(Image1.Canvas.ClipRect);

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
      selectionBMP.LoadFromFile(path + 'img\' + na)
    else if PikaGetFile(hs, na, path + 'images.ppk', 'Build By Schthack') = 0 then
      selectionBMP.LoadFromStream(hs)
    else if PikaGetFile(hs, 'unknow.bmp', path + 'images.ppk', 'Build By Schthack') = 0 then
      selectionBMP.LoadFromStream(hs)
    else if fileexists(path + 'img\unknow.bmp') then
      selectionBMP.LoadFromFile(path + 'img\unknow.bmp');
    hs.Free;
    Image1.Canvas.Draw(2, 2, selectionBMP);
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
      $FFFF div 182) + #$00B0);

    if have3d and form17.chkFollow.Checked then
    begin
      ppx := midpz[Floor[sfloor].Monster[selected].map_section].x;
      ppy := Floor[sfloor].Monster[selected].Pos_Z + 15;
      ppz := -midpz[Floor[sfloor].Monster[selected].map_section].y;
      vr := 0;
      vz := 0;
      myscreen.SetView(ppx, ppy, ppz, vr, vz);
    end;
    if (sender <> DBGrid1) and showgrid then
    begin
      if not ClientDataSet1.ControlsDisabled then
        LoadFloorGrids;
      PageControl1.ActivePage := TabSheet1;
    end;
    DBGrid1.Options := DBGrid1.Options + [dgIndicator];
    DBGrid2.Options := DBGrid2.Options - [dgIndicator];
  end;
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin
  Form1.Button2Click(nil);
end;

procedure TForm1.ListBox2Click(Sender: TObject);
var
  t: Single;
  hs: TMemoryStream;
begin
  if ListBox2.ItemIndex >= 0 then
  begin
    monstgridfocused := false;
    objgridfocused := false;
    objloaded := false;
    Selected := ListBox2.ItemIndex;
    HideIndicator();
    MoveSel := -1;
    Button2.Enabled := true;
    Button1.Enabled := true;
    Button3.Enabled := true;
    smEdit.Enabled := true;
    smDelete.Enabled := true;
    smMove.Enabled := true;
    transform1.Enabled := true;
    ListBox1.ItemIndex := -1;
    sms := Floor[sfloor].Obj[Selected].map_section;
    stype := 2;
    gridtype := 2;
    DrawMap;
    SetImage1Colors;
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
      objscreen.GetBitmap(selectionBMP);
      objloaded := true;
    end
    else
    begin
      selectionBMP := TBitmap.Create;
      hs := TMemoryStream.Create;
      if fileexists(path + 'img\i' + inttohex(Floor[sfloor].Obj[Selected].Skin, 2) + '.bmp') then
        selectionBMP.LoadFromFile(path + 'img\i' + inttohex(Floor[sfloor].Obj[Selected].Skin, 2) + '.bmp')
      else if PikaGetFile(hs, 'unknow.bmp', path + 'images.ppk', 'Build By Schthack') = 0 then
        selectionBMP.LoadFromStream(hs)
      else
        selectionBMP.LoadFromFile(path + 'img\unknow.bmp');
      hs.Free;
    end;

    Image1.Canvas.StretchDraw(Rect(2, 2, 45, 45), selectionBMP);
    Image1.Canvas.TextOut(52, 4, 'Skin : ' + inttostr(Floor[sfloor].Obj[Selected].Skin));
    Image1.Canvas.TextOut(150, 4, 'Map Section : ' + inttostr(Floor[sfloor].Obj[Selected].map_section));
    Image1.Canvas.TextOut(52, 22, 'Pos X : ' + inttostr(round(Floor[sfloor].Obj[Selected].Pos_X)));
    Image1.Canvas.TextOut(150, 22, 'Pos Y : ' + inttostr(round(Floor[sfloor].Obj[Selected].Pos_Z)));
    Image1.Canvas.TextOut(260, 22, 'Pos Z : ' + inttostr(round(Floor[sfloor].Obj[Selected].Pos_Y)));
    Image1.Canvas.TextOut(260, 4, 'Direction : ' + inttostr((Floor[sfloor].Obj[Selected].unknow6 and $FFFF)
      div 182) + #$00B0);

    if have3d and form17.chkFollow.Checked then
    begin
      ppx := midpz[Floor[sfloor].Obj[selected].map_section].x;
      ppy := Floor[sfloor].Obj[selected].Pos_Z + 15;
      ppz := -midpz[Floor[sfloor].Obj[selected].map_section].y;
      vr := 0;
      vz := 0;
      myscreen.SetView(ppx, ppy, ppz, vr, vz);
    end;
    if (sender <> DBGrid2) and showgrid then
    begin
      if not ClientDataSet2.ControlsDisabled then
        LoadFloorGrids;
      PageControl1.ActivePage := TabSheet2;
    end;
    DBGrid1.Options := DBGrid1.Options - [dgIndicator];
    DBGrid2.Options := DBGrid2.Options + [dgIndicator];
  end;
end;

procedure TForm1.itle1Click(Sender: TObject);
begin
  form2.Edit1.Text := Title;
  form2.ShowModal;
end;

procedure TForm1.Japanese1Click(Sender: TObject);
var
  Reg: TRegistry;
  flp: TMemoryStream;
begin
  UncheckLanguages;
  SetManualHotkeys;
  Japanese1.Checked := true;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\schthack\qedit', true) then
    begin
      Reg.WriteInteger('Lang', 4);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
    inherited;
  end;
  flp := TMemoryStream.Create;
  flp.LoadFromFile(path + 'jp.txt');
  LoadLanguageStrings(flp);
  SetInterfaceText;
  flp.Free;
end;

procedure TForm1.DBGrid1CellClick(Column: TColumn);
begin
  if not ClientDataSet1.isEmpty then
  begin
    selected := strtoint(DBGrid1.DataSource.DataSet.FieldByName('#').AsString);
    listbox1.ItemIndex := selected;
    Listbox1click(DBGrid1);
    grid1col := Column.ID - 1;
    DBGrid1.SelectedIndex := grid1col;
    DBGrid1.Invalidate;
  end;
end;

procedure TForm1.DBGrid1DblClick(Sender: TObject);
var
  Pt: TPoint;
  intitle: Boolean;
begin
  Pt := DBGrid1.ScreenToClient(Mouse.CursorPos);
  intitle := DBGrid1.MouseCoord(Pt.X, Pt.Y).Y = 0;
  if (selected > -1) and not ClientDataSet1.IsEmpty and not intitle then
  begin
    if not editgrid or ((grid1col = 0) or (grid1col = 1)) then
      Listbox1DblClick(nil);
  end;
end;

procedure TForm1.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Grid: TDBGrid;
begin
  if (gridtype <> 1) or ClientDataSet1.IsEmpty then
  begin
    Grid := Sender as TDBGrid;

    if gdSelected in State then
    begin
      Grid.Canvas.Brush.Color :=
        TStyleManager.ActiveStyle.GetStyleColor(scGrid);
      Grid.Canvas.Font.Color :=
        TStyleManager.ActiveStyle.GetStyleFontColor(sfTextLabelNormal);
    end;

    Grid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end
  else if not TStyleManager.IsCustomStyleActive then
  begin
    Grid := Sender as TDBGrid;

    if (gdSelected in State) or
    ((dgMultiSelect in Grid.Options)
    and Grid.SelectedRows.CurrentRowSelected)
    then
    begin
      Grid.Canvas.Brush.Color :=
        clHighlight;
      Grid.Canvas.Font.Color :=
        clHighlightText;
    end;

    Grid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;
end;

procedure TForm1.DBGrid1Exit(Sender: TObject);
begin
  monstgridfocused := false;
end;

procedure TForm1.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssShift in Shift) or (ssCtrl in Shift) then
    DBGrid1.Options := DBGrid1.Options + [dgMultiSelect];
end;

procedure TForm1.DBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_UP) or (Key = VK_DOWN) then
    ClientDataSet1AfterScroll(nil);
  if (Key = VK_ESCAPE) then DBGrid1.Options := DBGrid1.Options - [dgMultiSelect];
end;

procedure TForm1.DBGrid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  monstgridfocused := true;
end;

procedure TForm1.DBGrid1MouseEnter(Sender: TObject);
begin
   if (Screen.ActiveForm = form1) and editgrid then
    DBGrid1.SetFocus;
end;

procedure TForm1.DBGrid1MouseLeave(Sender: TObject);
begin
  monstgridfocused := false;
end;

procedure TForm1.DBGrid1MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  monstgridfocused := true;
end;

procedure TForm1.DBGrid1TitleClick(Column: TColumn);
begin
  lastmonstersort := Column.FieldName;
  ApplyMonsterSort(lastmonstersort);
end;

procedure TForm1.DBGrid2CellClick(Column: TColumn);
begin
  if not ClientDataSet2.isEmpty then
  begin
    selected := strtoint(DBGrid2.DataSource.DataSet.FieldByName('#').AsString);
    listbox2.ItemIndex := selected;
    Listbox2click(DBGrid2);
    grid2col := Column.ID - 1;
    DBGrid2.SelectedIndex := grid2col;
    DBGrid2.Invalidate;
  end;
end;

procedure TForm1.DBGrid2DblClick(Sender: TObject);
var
  Pt: TPoint;
  intitle: Boolean;
begin
  Pt := DBGrid2.ScreenToClient(Mouse.CursorPos);
  intitle := DBGrid2.MouseCoord(Pt.X, Pt.Y).Y = 0;
  if (selected > -1) and not ClientDataSet2.IsEmpty and not intitle then
  begin
    if not editgrid or ((grid2col = 0) or (grid2col = 1)) then
      Listbox1DblClick(nil);
  end;
end;

procedure TForm1.DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Grid: TDBGrid;
begin
  if (gridtype <> 2) or ClientDataSet2.IsEmpty then
  begin
    Grid := Sender as TDBGrid;

    if gdSelected in State then
    begin
      Grid.Canvas.Brush.Color :=
        TStyleManager.ActiveStyle.GetStyleColor(scListBox);
      Grid.Canvas.Font.Color :=
        TStyleManager.ActiveStyle.GetStyleFontColor(sfTextLabelNormal);
    end;

    Grid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end
  else if not TStyleManager.IsCustomStyleActive then
  begin
    Grid := Sender as TDBGrid;

    if (gdSelected in State) or
    ((dgMultiSelect in Grid.Options)
    and Grid.SelectedRows.CurrentRowSelected) then
    begin
      Grid.Canvas.Brush.Color :=
        clHighlight;
      Grid.Canvas.Font.Color :=
        clHighlightText;
    end;

    Grid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;
end;

procedure TForm1.DBGrid2Exit(Sender: TObject);
begin
  objgridfocused := false;
end;

procedure TForm1.DBGrid2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssShift in Shift) or (ssCtrl in Shift) then
    DBGrid2.Options := DBGrid2.Options + [dgMultiSelect];
end;

procedure TForm1.DBGrid2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_UP) or (Key = VK_DOWN) then
    ClientDataSet2AfterScroll(nil);
  if (Key = VK_ESCAPE) then DBGrid2.Options := DBGrid2.Options - [dgMultiSelect];
end;

procedure TForm1.DBGrid2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  objgridfocused := true;
end;

procedure TForm1.DBGrid2MouseEnter(Sender: TObject);
begin
  if (Screen.ActiveForm = form1) and editgrid then
    DBGrid2.SetFocus;
end;

procedure TForm1.DBGrid2MouseLeave(Sender: TObject);
begin
  objgridfocused := false;
end;

procedure TForm1.DBGrid2MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  objgridfocused := true;
end;

procedure TForm1.DBGrid2TitleClick(Column: TColumn);
begin
  lastobjsort := Column.FieldName;
  ApplyObjectSort(lastobjsort);
end;

procedure TForm1.Default1Click(Sender: TObject);
begin
  SetBrightness(0);
end;

procedure TForm1.Width1Click(Sender: TObject);
begin
  SetOutlineWidth(1);
end;

procedure TForm1.Delete1Click(Sender: TObject);
var
  Grid: TDBGrid;
  i, j, temp: Integer;
  bm: TBookmark;
  Dataset: TClientDataSet;
  deletionidx: array of Integer;
begin
  if not form4.edit1.Focused and not fmScriptTE.TextEdit.Focused
  and not fmScriptTE.txtNotes.Focused then
  begin
    indelete := true;
    if not (dgMultiSelect in DBGrid1.Options) and not (dgMultiSelect in DBGrid2.Options)
    or form13.Focused then
      Button3Click(nil)
    // Multi-delete
    else if showgrid then
    begin
      SetUndow;
      if pagecontrol1.ActivePage = tabsheet1 then
      begin
        Grid := DBGrid1;
        Dataset := ClientDataSet1;
      end;
      if pagecontrol1.ActivePage = tabsheet2 then
      begin
        Grid := DBGrid2;
        Dataset := ClientDataSet2;
      end;
      Dataset.DisableControls;
      try
        SetLength(deletionidx, Grid.SelectedRows.Count);
        // Delete from bottom to top
        for i := Grid.SelectedRows.Count - 1 downto 0 do
        begin
          bm := Grid.SelectedRows[i];

          if Assigned(bm) and Dataset.BookmarkValid(bm) then
          begin
            Dataset.GotoBookmark(bm);
            deletionidx[i] := Dataset.FieldByName('#').AsInteger;
          end;
        end;
        // Sort descending; delete from bottom to top
        for i := 0 to High(deletionidx) - 1 do
          for j := i + 1 to High(deletionidx) do
            if deletionidx[i] < deletionidx[j] then
            begin
              temp := deletionidx[i];
              deletionidx[i] := deletionidx[j];
              deletionidx[j] := temp;
            end;

          // Call single-delete on each item
          for i := 0 to High(deletionidx) do
          begin
            Selected := deletionidx[i];
            Button3Click(DBGrid1);
          end;

          // Select the next available
          if sType = 1 then
          begin
            if Floor[sfloor].MonsterCount > 0 then
            begin
              Selected := Min(Selected, Floor[sfloor].MonsterCount - 1);
              listbox1.ItemIndex := Selected;
              Button2.Enabled := true;
              Button1.Enabled := true;
              Button3.Enabled := true;
              smEdit.Enabled := true;
              smDelete.Enabled := true;
              smMove.Enabled := true;
              transform1.Enabled := true;
            end
            else
              Selected := -1;
          end;

          if sType = 2 then
          begin
            if Floor[sfloor].ObjCount > 0 then
            begin
              Selected := Min(Selected, Floor[sfloor].ObjCount - 1);
              listbox2.ItemIndex := Selected;
              Button2.Enabled := true;
              Button1.Enabled := true;
              Button3.Enabled := true;
              smEdit.Enabled := true;
              smDelete.Enabled := true;
              smMove.Enabled := true;
              transform1.Enabled := true;
            end
            else
              Selected := -1;
          end;

          finally
          Grid.SelectedRows.Clear;
          Grid.Options := Grid.Options - [dgMultiSelect];
          Grid.Options := Grid.Options - [dgMultiSelect];
          Dataset.EnableControls;
          LoadFloorGrids;
      end;
    end;
    indelete := false;
  end
  else if form4.edit1.Focused then
    form4.edit1.Clear
  else if fmScriptTE.TextEdit.Focused then
    fmScriptTE.TextEdit.DeleteSelection
  else if fmScriptTE.txtNotes.Focused then
    fmScriptTE.txtNotes.SelText := '';
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
  if smDisableIndicator.Checked then
  begin
    lblStatus.Visible := false;
    lblModifiers.Visible := false;
  end;
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
          MidP[u.section].y + mmy + round((-40 + mpy) / Zoom), inttostr(u.section));
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

procedure DouglasPeuckerRec(const pts: TArray<TGPPointF>; tol2: Single;
  lo, hi: Integer; var keep: TArray<Boolean>);
var
  maxDist2, d2, dx, dy, len2, t, projX, projY, ax, ay, bx, by: Single;
  maxIdx, i: Integer;
begin
  if hi <= lo + 1 then Exit;
  ax := pts[lo].X; ay := pts[lo].Y;
  bx := pts[hi].X; by := pts[hi].Y;
  dx := bx - ax; dy := by - ay;
  len2 := dx * dx + dy * dy;
  maxDist2 := 0;
  maxIdx := -1;
  for i := lo + 1 to hi - 1 do
  begin
    if len2 < 1e-9 then
    begin
      dx := pts[i].X - ax;
      dy := pts[i].Y - ay;
      d2 := dx * dx + dy * dy;
    end
    else
    begin
      t := ((pts[i].X - ax) * (bx - ax) + (pts[i].Y - ay) * (by - ay)) / len2;
      if t < 0 then t := 0 else if t > 1 then t := 1;
      projX := ax + t * (bx - ax);
      projY := ay + t * (by - ay);
      dx := pts[i].X - projX;
      dy := pts[i].Y - projY;
      d2 := dx * dx + dy * dy;
    end;
    if d2 > maxDist2 then
    begin
      maxDist2 := d2;
      maxIdx := i;
    end;
  end;
  if (maxIdx >= 0) and (maxDist2 > tol2) then
  begin
    keep[maxIdx] := True;
    DouglasPeuckerRec(pts, tol2, lo, maxIdx, keep);
    DouglasPeuckerRec(pts, tol2, maxIdx, hi, keep);
  end;
end;

function SimplifyContour(const pts: TArray<TGPPointF>; tol: Single): TArray<TGPPointF>;
var
  keep: TArray<Boolean>;
  i, n, k: Integer;
begin
  n := Length(pts);
  if n <= 4 then
  begin
    SetLength(Result, n);
    for i := 0 to n - 1 do Result[i] := pts[i];
    Exit;
  end;
  SetLength(keep, n);
  keep[0] := True;
  keep[n - 1] := True;
  DouglasPeuckerRec(pts, tol * tol, 0, n - 1, keep);
  k := 0;
  for i := 0 to n - 1 do if keep[i] then Inc(k);
  SetLength(Result, k);
  k := 0;
  for i := 0 to n - 1 do
    if keep[i] then
    begin
      Result[k] := pts[i];
      Inc(k);
    end;
end;

function PolygonSignedArea(const pts: TArray<TGPPointF>): Double;
var
  i, n: Integer;
begin
  n := Length(pts);
  Result := 0;
  if n < 3 then Exit;
  for i := 0 to n - 1 do
    Result := Result + pts[i].X * pts[(i + 1) mod n].Y - pts[(i + 1) mod n].X * pts[i].Y;
  Result := Result * 0.5;
end;

function CreateRoundedRectPath(x, y, w, h, r: Single): TGPGraphicsPath;
begin
  Result := TGPGraphicsPath.Create;
  if r * 2 > w then r := w / 2;
  if r * 2 > h then r := h / 2;
  Result.AddArc(x,             y,             2 * r, 2 * r, 180, 90);
  Result.AddArc(x + w - 2 * r, y,             2 * r, 2 * r, 270, 90);
  Result.AddArc(x + w - 2 * r, y + h - 2 * r, 2 * r, 2 * r,   0, 90);
  Result.AddArc(x,             y + h - 2 * r, 2 * r, 2 * r,  90, 90);
  Result.CloseFigure;
end;

function PointInPolygon(const p: TGPPointF; const pts: TArray<TGPPointF>): Boolean;
var
  i, j, n: Integer;
  inside: Boolean;
begin
  n := Length(pts);
  inside := False;
  if n < 3 then Exit(False);
  j := n - 1;
  for i := 0 to n - 1 do
  begin
    if ((pts[i].Y > p.Y) <> (pts[j].Y > p.Y)) and
       (p.X < (pts[j].X - pts[i].X) * (p.Y - pts[i].Y) / (pts[j].Y - pts[i].Y) + pts[i].X) then
      inside := not inside;
    j := i;
  end;
  Result := inside;
end;

function PointOnSegment(const p, a, b: TGPPointF): Boolean;
const
  Epsilon = 0.001;
var
  cross: Double;
begin
  cross := (b.X - a.X) * (p.Y - a.Y) - (b.Y - a.Y) * (p.X - a.X);
  Result := (Abs(cross) <= Epsilon) and
            (p.X >= Min(a.X, b.X) - Epsilon) and
            (p.X <= Max(a.X, b.X) + Epsilon) and
            (p.Y >= Min(a.Y, b.Y) - Epsilon) and
            (p.Y <= Max(a.Y, b.Y) + Epsilon);
end;

function SegmentsIntersect(const a1, a2, b1, b2: TGPPointF): Boolean;
const
  Epsilon = 0.001;
var
  d1, d2, d3, d4: Double;
begin
  d1 := (a2.X - a1.X) * (b1.Y - a1.Y) - (a2.Y - a1.Y) * (b1.X - a1.X);
  d2 := (a2.X - a1.X) * (b2.Y - a1.Y) - (a2.Y - a1.Y) * (b2.X - a1.X);
  d3 := (b2.X - b1.X) * (a1.Y - b1.Y) - (b2.Y - b1.Y) * (a1.X - b1.X);
  d4 := (b2.X - b1.X) * (a2.Y - b1.Y) - (b2.Y - b1.Y) * (a2.X - b1.X);

  Result := (((d1 > Epsilon) and (d2 < -Epsilon)) or
             ((d1 < -Epsilon) and (d2 > Epsilon))) and
            (((d3 > Epsilon) and (d4 < -Epsilon)) or
             ((d3 < -Epsilon) and (d4 > Epsilon)));
  if Result then Exit;

  Result := ((Abs(d1) <= Epsilon) and PointOnSegment(b1, a1, a2)) or
            ((Abs(d2) <= Epsilon) and PointOnSegment(b2, a1, a2)) or
            ((Abs(d3) <= Epsilon) and PointOnSegment(a1, b1, b2)) or
            ((Abs(d4) <= Epsilon) and PointOnSegment(a2, b1, b2));
end;

function PolygonStrictlyContains(const outerPts, innerPts: TArray<TGPPointF>): Boolean;
var
  outerIdx, innerIdx: Integer;
begin
  Result := False;
  if (Length(outerPts) < 3) or (Length(innerPts) < 3) then Exit;

  // Every child vertex must be strictly inside. A centroid alone is not a
  // containment proof for concave or partially overlapping contours.
  for innerIdx := 0 to Length(innerPts) - 1 do
  begin
    for outerIdx := 0 to Length(outerPts) - 1 do
      if PointOnSegment(innerPts[innerIdx], outerPts[outerIdx],
           outerPts[(outerIdx + 1) mod Length(outerPts)]) then Exit;
    if not PointInPolygon(innerPts[innerIdx], outerPts) then Exit;
  end;

  // Concave polygons can contain every vertex while an edge crosses outside.
  // Reject boundary crossings and touching contours as parent/child pairs.
  for innerIdx := 0 to Length(innerPts) - 1 do
    for outerIdx := 0 to Length(outerPts) - 1 do
      if SegmentsIntersect(innerPts[innerIdx],
           innerPts[(innerIdx + 1) mod Length(innerPts)],
           outerPts[outerIdx], outerPts[(outerIdx + 1) mod Length(outerPts)]) then Exit;

  Result := True;
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
  // Outline mode variables
  outlineLnX, outlineLnY: Single;
  outlineLpt: array[0..3] of word;
  outlineEdgeArr: array of Int64;
  outlineEdgeCount, outlineRemY, outlineEi: integer;
  outlineVa, outlineVb, outlineTmp: word;
  outlineEk: Int64;
  outlineTi: integer;
  // Contour tracing
  boundaryEdges: array of record a, b: word; used: boolean; end;
  boundaryCount, seedEi, adjIdx, adjEi: integer;
  vertAdj: TDictionary<word, TList<integer>>;
  adjList: TList<integer>;
  contourPts: TArray<TGPPointF>;
  contourLen, cIdx: integer;
  curV, nextV, startV: word;
  foundNext: boolean;
  contoursPts: TArray<TArray<TGPPointF>>;
  contoursAvgY: TArray<Single>;
  contoursBlock, contoursComponent: TArray<Integer>;
  contoursCount: integer;
  sumY: Double;
  vCount: integer;
  contMinY, contMaxY, heightT, shadowOffset: Single;
  lowR, lowG, lowB, highR, highG, highB, strokeR, strokeG, strokeB: Byte;
  fillR, fillG, fillB: Byte;
  gpGraphics: TGPGraphics;
  gpBrush, gpShadowBrush: TGPSolidBrush;
  gpPen: TGPPen;
  contoursArea: TArray<Double>;
  contoursParent: TArray<Integer>;
  contoursDepth: TArray<Integer>;
  contourPaths: TArray<TGPGraphicsPath>;
  pIdx, depthWalker, bestParent, projIdx: Integer;
  bestParentArea: Double;
  projectedPts: TArray<TArray<TGPPointF>>;
  screenTemp: TArray<TGPPointF>;
  gpRawGraphics: TGPGraphics;
  gpPenBlue, gpPenGreen, gpPenGray, gpPenDefault, curPen: TGPPen;
  gpTrianglePts: array[0..2] of TGPPointF;
  // Topographic mode: thin pen for interior (shared) edges painted between fill and boundary.
  topoInteriorPen: TGPPen;
  topoIeIdx: Integer;
  // Per-section interior edges (world-XZ pairs), appended into the global cache after
  // the section's edge sort/classification step.
  interiorPts: TArray<TGPPointF>;
  interiorCount: Integer;
  interiorVa, interiorVb: word;
  topoIntS1, topoIntS2: TGPPointF;
  combinedPath: TGPGraphicsPath;
  hatchBrush: TGPHatchBrush;
  lgCardPath, lgBarPath: TGPGraphicsPath;
  lgCardBrush, lgTextBrush, lgCardShadowBrush: TGPSolidBrush;
  lgGradBrush: TGPLinearGradientBrush;
  lgCardPen, lgBarPen: TGPPen;
  lgFontFamily: TGPFontFamily;
  lgFont: TGPFont;
  lgStringFormat: TGPStringFormat;
  lgPt: TGPPointF;
  lgRectF: TGPRectF;
  lgTextRect: TRect;
  lgX, lgY, lgW, lgH, lgBarX, lgBarY, lgBarW, lgBarH: Integer;
  savedFont: TFont;
  savedBrushStyle: TBrushStyle;
  vertexParent: TArray<Integer>;
  vertexCountLocal, outlineBlockId: Integer;

  function FindVertexRoot(vertex: Integer): Integer;
  var
    parentVertex: Integer;
  begin
    Result := vertex;
    while vertexParent[Result] <> Result do
      Result := vertexParent[Result];
    while vertexParent[vertex] <> vertex do
    begin
      parentVertex := vertexParent[vertex];
      vertexParent[vertex] := Result;
      vertex := parentVertex;
    end;
  end;

  procedure UnionVertices(a, b: Integer);
  var
    rootA, rootB: Integer;
  begin
    rootA := FindVertexRoot(a);
    rootB := FindVertexRoot(b);
    if rootA <> rootB then
      vertexParent[rootB] := rootA;
  end;
begin
  if BBRelFile = nil then
    BBRelFile := TMemoryStream.Create;

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
      Form1.ComboBox1.Items.Add(GetLanguageString(466));
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
      end;

  end;

  gpRawGraphics := nil;
  gpPenBlue := nil;
  gpPenGreen := nil;
  gpPenGray := nil;
  gpPenDefault := nil;
  SetLength(contourPaths, 0);
  try
    try
    t := BBRelFile.Seek(-16, 2);
    BBRelFile.read(t, 4); // find the first room entry
    BBRelFile.Seek(t, 0);
    BBRelFile.read(t, 4);
    if darkmode then
      BBRelBmp.Canvas.Brush.Color := RGB(200,200,200)
    else
      BBRelBmp.Canvas.Brush.Color := clblack;
    BBRelFile.Seek(t, 0); // first header found ready to read
    // fillchar(zmap,sizeof(zmap),$7f);
    tab := t + $18;
    l := 1;
    ll := 0;
    col := $101010;
    // Raw mode: set up GDI+ graphics + pens once, reused for every triangle
    topoInteriorPen := nil;
    if mapRenderMode = 0 then
    begin
      gpRawGraphics := TGPGraphics.Create(BBRelBmp.Canvas.Handle);
      gpRawGraphics.SetSmoothingMode(SmoothingModeAntiAlias);
      gpRawGraphics.SetPixelOffsetMode(PixelOffsetModeHalf);
      gpPenBlue := TGPPen.Create(MakeColor(255, 0, 0, 255), 1);
      gpPenGreen := TGPPen.Create(MakeColor(255, 127, 255, 127), 1);
      if darkmode then
      begin
        gpPenGray := TGPPen.Create(MakeColor(255, 135, 135, 135), 1);
        gpPenDefault := TGPPen.Create(MakeColor(255, 200, 200, 200), 1);
      end
      else
      begin
        gpPenGray := TGPPen.Create(MakeColor(255, 153, 153, 153), 1);
        gpPenDefault := TGPPen.Create(MakeColor(255, 0, 0, 0), 1);
      end;
    end;

    // Topographic cache: if filename unchanged, reuse prior world-space contours + interior edges
    interiorCount := 0;
    SetLength(interiorPts, 0);
    if (mapRenderMode = 1) and (cachedOutlineFor = filename) and (cachedOutlineCount > 0) then
    begin
      contoursCount := cachedOutlineCount;
      contoursPts := Copy(cachedOutlineContours, 0, cachedOutlineCount);
      contoursAvgY := Copy(cachedOutlineAvgY, 0, cachedOutlineCount);
      contoursBlock := Copy(cachedOutlineBlock, 0, cachedOutlineCount);
      contoursComponent := Copy(cachedOutlineComponent, 0, cachedOutlineCount);
      contoursParent := Copy(cachedOutlineParent, 0, cachedOutlineCount);
      contoursDepth := Copy(cachedOutlineDepth, 0, cachedOutlineCount);
      contMinY := cachedOutlineMinY;
      contMaxY := cachedOutlineMaxY;
      interiorCount := cachedOutlineInteriorCount;
      // Each interior edge stores 2 endpoints (start + end), so the cached
      // point array length is 2x the edge count. Restoring only N items
      // instead of N*2 left the back half of the rebuilt interiorPts as
      // out-of-bounds reads, which produced random "radial lines" through
      // the floor every cache hit (i.e. every redraw after the first frame).
      interiorPts := Copy(cachedOutlineInterior, 0, cachedOutlineInteriorCount * 2);
      l := 0; // skip outer while loop
    end
    else
    begin
      contoursCount := 0;
      SetLength(contoursPts, 0);
      SetLength(contoursAvgY, 0);
      SetLength(contoursBlock, 0);
      SetLength(contoursComponent, 0);
      contMinY := 1e30;
      contMaxY := -1e30;
    end;
    outlineBlockId := 0;
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

        // Mode 1: floor-contour outline — trace boundary edges into closed polygons, fill + stroke
        if mapRenderMode = 1 then
        begin
          vertexCountLocal := (r2 - t) div SizeOf(tmppoint[0]);
          SetLength(vertexParent, vertexCountLocal);
          for outlineEi := 0 to vertexCountLocal - 1 do
            vertexParent[outlineEi] := outlineEi;
          SetLength(outlineEdgeArr, 3 * y);
          outlineEdgeCount := 0;
          outlineRemY := y;
          while outlineRemY > 0 do
          begin
            BBRelFile.read(outlineLpt, 8);
            BBRelFile.read(outlineLnX, 4);
            BBRelFile.read(outlineLnY, 4);
            BBRelFile.Seek(20, 1);
            if ((outlineLpt[3] and 1 = 1) or (outlineLpt[3] and 16 = 16) or (outlineLpt[3] and 64 = 64))
              and (outlineLnY >= 0.2588) then
            begin
              UnionVertices(outlineLpt[0], outlineLpt[1]);
              UnionVertices(outlineLpt[1], outlineLpt[2]);
              for outlineEi := 0 to 2 do
              begin
                outlineVa := outlineLpt[outlineEi];
                outlineVb := outlineLpt[(outlineEi + 1) mod 3];
                if outlineVa > outlineVb then
                begin
                  outlineTmp := outlineVa;
                  outlineVa := outlineVb;
                  outlineVb := outlineTmp;
                end;
                outlineEdgeArr[outlineEdgeCount] := Int64(outlineVa) shl 16 or Int64(outlineVb);
                inc(outlineEdgeCount);
              end;
            end;
            dec(outlineRemY);
          end;
          TArray.Sort<Int64>(outlineEdgeArr, TComparer<Int64>.Default, 0, outlineEdgeCount);

          // Classify edges: singleton -> boundary (room frame, traced into contours);
          // duplicate -> interior (shared between two triangles, drawn as fine triangulation).
          SetLength(boundaryEdges, outlineEdgeCount);
          boundaryCount := 0;
          // Reserve interior buffer in this section: at most outlineEdgeCount/2 interior edges
          if Length(interiorPts) < (interiorCount + outlineEdgeCount) * 2 then
            SetLength(interiorPts, (interiorCount + outlineEdgeCount) * 2);
          outlineTi := 0;
          while outlineTi < outlineEdgeCount do
          begin
            outlineEk := outlineEdgeArr[outlineTi];
            if (outlineTi + 1 < outlineEdgeCount) and (outlineEdgeArr[outlineTi + 1] = outlineEk) then
            begin
              // Interior edge — record once in world-XZ, then skip all duplicates of this key
              interiorVa := word(outlineEk shr 16);
              interiorVb := word(outlineEk and $FFFF);
              interiorPts[interiorCount * 2].X := tmppoint[interiorVa][0];
              interiorPts[interiorCount * 2].Y := tmppoint[interiorVa][2];
              interiorPts[interiorCount * 2 + 1].X := tmppoint[interiorVb][0];
              interiorPts[interiorCount * 2 + 1].Y := tmppoint[interiorVb][2];
              Inc(interiorCount);
              while (outlineTi < outlineEdgeCount) and (outlineEdgeArr[outlineTi] = outlineEk) do
                inc(outlineTi);
            end
            else
            begin
              boundaryEdges[boundaryCount].a := word(outlineEk shr 16);
              boundaryEdges[boundaryCount].b := word(outlineEk and $FFFF);
              boundaryEdges[boundaryCount].used := false;
              inc(boundaryCount);
              inc(outlineTi);
            end;
          end;

          // Build vertex -> boundary-edge adjacency
          vertAdj := TDictionary<word, TList<integer>>.Create;
          try
            for outlineEi := 0 to boundaryCount - 1 do
            begin
              if not vertAdj.TryGetValue(boundaryEdges[outlineEi].a, adjList) then
              begin
                adjList := TList<integer>.Create;
                vertAdj.Add(boundaryEdges[outlineEi].a, adjList);
              end;
              adjList.Add(outlineEi);
              if not vertAdj.TryGetValue(boundaryEdges[outlineEi].b, adjList) then
              begin
                adjList := TList<integer>.Create;
                vertAdj.Add(boundaryEdges[outlineEi].b, adjList);
              end;
              adjList.Add(outlineEi);
            end;

            // Walk each contour loop starting from any unused edge; append to global list
            for seedEi := 0 to boundaryCount - 1 do
            begin
              if boundaryEdges[seedEi].used then continue;
              SetLength(contourPts, 64);
              contourLen := 0;
              sumY := 0;
              vCount := 0;
              startV := boundaryEdges[seedEi].a;
              curV := startV;
              nextV := boundaryEdges[seedEi].b;
              boundaryEdges[seedEi].used := true;

              contourPts[contourLen].X := tmppoint[curV][0];
              contourPts[contourLen].Y := tmppoint[curV][2];
              sumY := sumY + tmppoint[curV][1];
              inc(vCount);
              inc(contourLen);

              repeat
                if contourLen >= Length(contourPts) then
                  SetLength(contourPts, Length(contourPts) * 2);
                contourPts[contourLen].X := tmppoint[nextV][0];
                contourPts[contourLen].Y := tmppoint[nextV][2];
                sumY := sumY + tmppoint[nextV][1];
                inc(vCount);
                inc(contourLen);

                curV := nextV;
                if curV = startV then break;
                foundNext := false;
                if vertAdj.TryGetValue(curV, adjList) then
                begin
                  for adjIdx := 0 to adjList.Count - 1 do
                  begin
                    adjEi := adjList[adjIdx];
                    if boundaryEdges[adjEi].used then continue;
                    if boundaryEdges[adjEi].a = curV then
                      nextV := boundaryEdges[adjEi].b
                    else
                      nextV := boundaryEdges[adjEi].a;
                    boundaryEdges[adjEi].used := true;
                    foundNext := true;
                    break;
                  end;
                end;
              until not foundNext;

              if contourLen >= 3 then
              begin
                SetLength(contourPts, contourLen);
                SetLength(contoursPts, contoursCount + 1);
                SetLength(contoursAvgY, contoursCount + 1);
                SetLength(contoursBlock, contoursCount + 1);
                SetLength(contoursComponent, contoursCount + 1);
                contoursPts[contoursCount] := Copy(contourPts, 0, contourLen);
                contoursAvgY[contoursCount] := sumY / vCount;
                contoursBlock[contoursCount] := outlineBlockId;
                contoursComponent[contoursCount] := FindVertexRoot(startV);
                if contoursAvgY[contoursCount] < contMinY then contMinY := contoursAvgY[contoursCount];
                if contoursAvgY[contoursCount] > contMaxY then contMaxY := contoursAvgY[contoursCount];
                inc(contoursCount);
              end;
            end;

          finally
            for adjList in vertAdj.Values do
              adjList.Free;
            vertAdj.Free;
          end;

          y := 0; // skip main loop for this block
        end;

        While y > 0 do
        begin
          BBRelFile.read(pt, 8);
          BBRelFile.Seek(28, 1); // raw mode: skip normal + padding

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
            rel1[0] := tmppoint[pt[0]][0];
            rel1[2] := tmppoint[pt[0]][2];
            rel[0] := tmppoint[pt[1]][0];
            rel[2] := tmppoint[pt[1]][2];

            if (pt[3] and 64 = 64) then
              curPen := gpPenBlue
            else if (pt[3] and 16 = 16) then
              curPen := gpPenGreen
            else if (pt[3] and 1 = 1) then
              curPen := gpPenGray
            else
              curPen := gpPenDefault;

            gpTrianglePts[0].X := (rel1[0] + mpx) / Zoom + mmx;
            gpTrianglePts[0].Y := (rel1[2] + mpy) / Zoom + mmy;
            gpTrianglePts[1].X := (rel[0] + mpx) / Zoom + mmx;
            gpTrianglePts[1].Y := (rel[2] + mpy) / Zoom + mmy;
            rel[0] := tmppoint[pt[2]][0];
            rel[2] := tmppoint[pt[2]][2];
            gpTrianglePts[2].X := (rel[0] + mpx) / Zoom + mmx;
            gpTrianglePts[2].Y := (rel[2] + mpy) / Zoom + mmy;
            gpRawGraphics.DrawPolygon(curPen, PGPPointF(@gpTrianglePts[0]), 3);
          end;

          dec(y);
        end;
        BBRelFile.Seek(tab, 0);
        tab := tab + $18;
        Inc(outlineBlockId);

      end
      else
        l := 0;
      // image2.Repaint;
      // inc(sec);
    end;
    // deletedc(hd);

    // Cache miss path: compute nesting topology once on world-space contours, then persist
    if (mapRenderMode = 1) and (contoursCount > 0) and (cachedOutlineFor <> filename) then
    begin
      SetLength(contoursArea, contoursCount);
      for cIdx := 0 to contoursCount - 1 do
        contoursArea[cIdx] := Abs(PolygonSignedArea(contoursPts[cIdx]));

      SetLength(contoursParent, contoursCount);
      for cIdx := 0 to contoursCount - 1 do
      begin
        bestParent := -1;
        bestParentArea := 1e30;
        for pIdx := 0 to contoursCount - 1 do
        begin
          if pIdx = cIdx then Continue;
          if contoursBlock[pIdx] <> contoursBlock[cIdx] then Continue;
          if contoursComponent[pIdx] <> contoursComponent[cIdx] then Continue;
          if contoursArea[pIdx] <= contoursArea[cIdx] then Continue;
          if PolygonStrictlyContains(contoursPts[pIdx], contoursPts[cIdx]) and
             (contoursArea[pIdx] < bestParentArea) then
          begin
            bestParent := pIdx;
            bestParentArea := contoursArea[pIdx];
          end;
        end;
        contoursParent[cIdx] := bestParent;
      end;

      SetLength(contoursDepth, contoursCount);
      for cIdx := 0 to contoursCount - 1 do
      begin
        depthWalker := contoursParent[cIdx];
        contoursDepth[cIdx] := 0;
        while depthWalker >= 0 do
        begin
          Inc(contoursDepth[cIdx]);
          depthWalker := contoursParent[depthWalker];
        end;
      end;

      // One-time world-space DP simplification: cuts 30-60% of vertices, skips per-frame DP
      for cIdx := 0 to contoursCount - 1 do
        contoursPts[cIdx] := SimplifyContour(contoursPts[cIdx], 1.0);

      cachedOutlineFor := filename;
      cachedOutlineContours := Copy(contoursPts, 0, contoursCount);
      cachedOutlineAvgY := Copy(contoursAvgY, 0, contoursCount);
      cachedOutlineBlock := Copy(contoursBlock, 0, contoursCount);
      cachedOutlineComponent := Copy(contoursComponent, 0, contoursCount);
      cachedOutlineParent := Copy(contoursParent, 0, contoursCount);
      cachedOutlineDepth := Copy(contoursDepth, 0, contoursCount);
      cachedOutlineCount := contoursCount;
      cachedOutlineMinY := contMinY;
      cachedOutlineMaxY := contMaxY;
      cachedOutlineInterior := Copy(interiorPts, 0, interiorCount * 2);
      cachedOutlineInteriorCount := interiorCount;
    end;

    // Mode 1 render: project world -> screen, DP-simplify, build hole-aware paths, GDI+ render
    if (mapRenderMode = 1) and (contoursCount > 0) then
    begin
      SetLength(projectedPts, contoursCount);
      for cIdx := 0 to contoursCount - 1 do
      begin
        SetLength(projectedPts[cIdx], Length(contoursPts[cIdx]));
        for projIdx := 0 to Length(contoursPts[cIdx]) - 1 do
        begin
          projectedPts[cIdx][projIdx].X := (contoursPts[cIdx][projIdx].X + mpx) / Zoom + mmx;
          projectedPts[cIdx][projIdx].Y := (contoursPts[cIdx][projIdx].Y + mpy) / Zoom + mmy;
        end;
      end;

      SetLength(contourPaths, contoursCount);
      for cIdx := 0 to contoursCount - 1 do
      begin
        if (contoursDepth[cIdx] mod 2) = 0 then
        begin
          contourPaths[cIdx] := TGPGraphicsPath.Create(FillModeAlternate);
          contourPaths[cIdx].AddPolygon(PGPPointF(@projectedPts[cIdx][0]), Length(projectedPts[cIdx]));
          for pIdx := 0 to contoursCount - 1 do
            if contoursParent[pIdx] = cIdx then
              contourPaths[cIdx].AddPolygon(PGPPointF(@projectedPts[pIdx][0]), Length(projectedPts[pIdx]));
        end
        else
          contourPaths[cIdx] := nil;
      end;

      if darkmode then
      begin
        // Atlas Modern, dark variant. Same hues as light, dropped to ~50%
        // value so they read as colored on a near-black bitmap.
        lowR := 50;  lowG := 95;  lowB := 150;
        highR := 165; highG := 135; highB := 60;
        strokeR := 220; strokeG := 220; strokeB := 220;
      end
      else
      begin
        // Atlas Modern palette: cool blue at low, warm sand at high.
        // Hue pair sits near 210° / 45° on the wheel — far enough apart
        // for clear height encoding, close to complementary so the
        // linear-RGB midpoint lands on a natural pale-olive instead of
        // muddy gray. Saturation kept around 50% so the floor reads as
        // colored without competing with the brighter UI elements
        // (yellow selection rect, pink room-ID, blue warp lines, olive
        // range ring). Lightness ~85-90% leaves dark markers
        // unambiguous on top.
        lowR := 115; lowG := 170; lowB := 220;
        highR := 235; highG := 205; highB := 115;
        strokeR := 30; strokeG := 30; strokeB := 30;
      end;
      shadowOffset := outlinewidth + 1.5;

      gpGraphics := TGPGraphics.Create(BBRelBmp.Canvas.Handle);
      try
        gpGraphics.SetSmoothingMode(SmoothingModeAntiAlias);
        gpGraphics.SetPixelOffsetMode(PixelOffsetModeHalf);

        // Hatch pass: faint 45° diagonal lines outside floor areas (cartographic negative space)
        combinedPath := TGPGraphicsPath.Create(FillModeAlternate);
        try
          for cIdx := 0 to contoursCount - 1 do
            if contourPaths[cIdx] <> nil then
              combinedPath.AddPath(contourPaths[cIdx], False);
          gpGraphics.SetClip(combinedPath, CombineModeExclude);
          hatchBrush := TGPHatchBrush.Create(HatchStyleForwardDiagonal,
            MakeColor(32, 0, 0, 0), MakeColor(0, 0, 0, 0));
          try
            gpGraphics.FillRectangle(hatchBrush, 0.0, 0.0,
              Single(BBRelBmp.Width), Single(BBRelBmp.Height));
          finally
            hatchBrush.Free;
          end;
          gpGraphics.ResetClip;
        finally
          combinedPath.Free;
        end;

        // Shadow pass: single wide AA stroke (soft edge) + solid fill (core)
        gpShadowBrush := TGPSolidBrush.Create(MakeColor(55, 0, 0, 0));
        try
          gpGraphics.TranslateTransform(shadowOffset, shadowOffset);
          gpPen := TGPPen.Create(MakeColor(28, 0, 0, 0), outlinewidth + 3);
          try
            gpPen.SetLineJoin(LineJoinRound);
            for cIdx := 0 to contoursCount - 1 do
              if contourPaths[cIdx] <> nil then
                gpGraphics.DrawPath(gpPen, contourPaths[cIdx]);
          finally
            gpPen.Free;
          end;
          for cIdx := 0 to contoursCount - 1 do
            if contourPaths[cIdx] <> nil then
              gpGraphics.FillPath(gpShadowBrush, contourPaths[cIdx]);
          gpGraphics.ResetTransform;
        finally
          gpShadowBrush.Free;
        end;

        // Fill pass: per-outer height-tinted color when shading is enabled,
        // otherwise a single neutral cool gray for the whole floor layer.
        for cIdx := 0 to contoursCount - 1 do
        begin
          if contourPaths[cIdx] = nil then Continue;
          if topoHeightShading then
          begin
            if contMaxY > contMinY then
              heightT := (contoursAvgY[cIdx] - contMinY) / (contMaxY - contMinY)
            else
              heightT := 0.5;
            fillR := Byte(Round(lowR + (Integer(highR) - Integer(lowR)) * heightT));
            fillG := Byte(Round(lowG + (Integer(highG) - Integer(lowG)) * heightT));
            fillB := Byte(Round(lowB + (Integer(highB) - Integer(lowB)) * heightT));
          end
          else if darkmode then
          begin
            // Match the bitmap background fill (DrawMap uses RGB(18,18,18))
            // so the floor reads as "uncolored" — only outlined by the
            // boundary stroke, with the drop shadow still visible behind.
            fillR := 18; fillG := 18; fillB := 18;
          end
          else
          begin
            fillR := 255; fillG := 255; fillB := 255;
          end;
          gpBrush := TGPSolidBrush.Create(MakeColor(255, fillR, fillG, fillB));
          try
            gpGraphics.FillPath(gpBrush, contourPaths[cIdx]);
          finally
            gpBrush.Free;
          end;
        end;

        // Interior triangulation: shared edges between two filtered triangles, drawn
        // as fine detail inside the fills. Single muted color (matched to stroke palette
        // but desaturated + transparent), narrower than boundary so the room frame still wins.
        if interiorCount > 0 then
        begin
          topoInteriorPen := TGPPen.Create(
            MakeColor(95, strokeR, strokeG, strokeB), outlinewidth * 0.75);
          try
            for topoIeIdx := 0 to interiorCount - 1 do
            begin
              topoIntS1.X := (interiorPts[topoIeIdx * 2].X + mpx) / Zoom + mmx;
              topoIntS1.Y := (interiorPts[topoIeIdx * 2].Y + mpy) / Zoom + mmy;
              topoIntS2.X := (interiorPts[topoIeIdx * 2 + 1].X + mpx) / Zoom + mmx;
              topoIntS2.Y := (interiorPts[topoIeIdx * 2 + 1].Y + mpy) / Zoom + mmy;
              gpGraphics.DrawLine(topoInteriorPen, topoIntS1.X, topoIntS1.Y, topoIntS2.X, topoIntS2.Y);
            end;
          finally
            topoInteriorPen.Free;
            topoInteriorPen := nil;
          end;
        end;

        // Boundary stroke pass — drawn last so the room frame stays crisp on top of triangulation
        gpPen := TGPPen.Create(MakeColor(255, strokeR, strokeG, strokeB), outlinewidth);
        try
          gpPen.SetLineJoin(LineJoinRound);
          for cIdx := 0 to contoursCount - 1 do
          begin
            if contourPaths[cIdx] = nil then Continue;
            gpGraphics.DrawPath(gpPen, contourPaths[cIdx]);
          end;
        finally
          gpPen.Free;
        end;

        // Height legend: horizontal pill — "Height:  LOW [==gradient==] HIGH"
        // Hidden when height shading is off — a flat-fill floor has nothing
        // to legend.
        if topoHeightShading then
        begin
          lgW := 320;
          lgH := 28;
          lgX := BBRelBmp.Width - lgW - 16;
          lgY := BBRelBmp.Height - lgH - 16;
          lgBarW := 130;
          lgBarH := 10;
          lgBarX := lgX + 128;
          lgBarY := lgY + (lgH - lgBarH) div 2;

          lgCardPath := CreateRoundedRectPath(Single(lgX), Single(lgY), Single(lgW), Single(lgH), Single(lgH) / 2);
          try
            gpGraphics.TranslateTransform(0.0, 2.0);
            lgCardShadowBrush := TGPSolidBrush.Create(MakeColor(40, 0, 0, 0));
            try
              gpGraphics.FillPath(lgCardShadowBrush, lgCardPath);
            finally
              lgCardShadowBrush.Free;
            end;
            gpGraphics.ResetTransform;

            lgCardBrush := TGPSolidBrush.Create(MakeColor(245, 255, 255, 255));
            try
              gpGraphics.FillPath(lgCardBrush, lgCardPath);
            finally
              lgCardBrush.Free;
            end;

            lgCardPen := TGPPen.Create(MakeColor(130, 140, 140, 140), 1);
            try
              gpGraphics.DrawPath(lgCardPen, lgCardPath);
            finally
              lgCardPen.Free;
            end;
          finally
            lgCardPath.Free;
          end;

          lgBarPath := CreateRoundedRectPath(Single(lgBarX), Single(lgBarY), Single(lgBarW), Single(lgBarH), Single(lgBarH) / 2);
          try
            lgGradBrush := TGPLinearGradientBrush.Create(
              MakePoint(Single(lgBarX), Single(lgBarY)),
              MakePoint(Single(lgBarX + lgBarW), Single(lgBarY)),
              MakeColor(255, lowR, lowG, lowB),
              MakeColor(255, highR, highG, highB));
            try
              gpGraphics.FillPath(lgGradBrush, lgBarPath);
            finally
              lgGradBrush.Free;
            end;

            lgBarPen := TGPPen.Create(MakeColor(140, 80, 80, 80), 1);
            try
              gpGraphics.DrawPath(lgBarPen, lgBarPath);
            finally
              lgBarPen.Free;
            end;
          finally
            lgBarPath.Free;
          end;
        end;

      finally
        gpGraphics.Free;
      end;

      if topoHeightShading then
      begin
        savedFont := TFont.Create;
        savedBrushStyle := BBRelBmp.Canvas.Brush.Style;
        try
          savedFont.Assign(BBRelBmp.Canvas.Font);
          // Legend labels via GDI Canvas (reliable across system font configs)
          BBRelBmp.Canvas.Brush.Style := bsClear;

          // Title "Height:" on the left
          BBRelBmp.Canvas.Font.Name := 'Segoe UI';
          BBRelBmp.Canvas.Font.Size := 9;
          BBRelBmp.Canvas.Font.Style := [fsBold];
          BBRelBmp.Canvas.Font.Color := RGB(30, 35, 45);
          lgTextRect := Rect(lgX + 14, lgY, lgX + 78, lgY + lgH);
          DrawText(BBRelBmp.Canvas.Handle, 'Height:', 7, lgTextRect,
            DT_LEFT or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX);

          // LOW / HIGH small labels flanking the bar
          BBRelBmp.Canvas.Font.Size := 8;
          BBRelBmp.Canvas.Font.Color := RGB(70, 75, 85);
          lgTextRect := Rect(lgX + 82, lgY, lgBarX - 4, lgY + lgH);
          DrawText(BBRelBmp.Canvas.Handle, 'LOW', 3, lgTextRect,
            DT_RIGHT or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX);
          lgTextRect := Rect(lgBarX + lgBarW + 4, lgY, lgX + lgW - 10, lgY + lgH);
          DrawText(BBRelBmp.Canvas.Handle, 'HIGH', 4, lgTextRect,
            DT_LEFT or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX);
        finally
          BBRelBmp.Canvas.Font.Assign(savedFont);
          BBRelBmp.Canvas.Brush.Style := savedBrushStyle;
          savedFont.Free;
        end;
      end;
    end;

    // Room-ID badges drawn after the floor render so topographic fills can't
    // occlude them. Hollow ring (Ellipse + bsClear brush) instead of filled
    // chord so the map underneath stays visible. Selected gets a bright
    // pink ring to stand out.
    if CheckBox1.Checked then
    begin
      if darkmode then
        BBRelBmp.Canvas.Font.Color := RGB(220, 220, 220)
      else
        BBRelBmp.Canvas.Font.Color := clBlack;
      BBRelBmp.Canvas.Brush.Style := bsClear;
      BBRelBmp.Canvas.Pen.Width := 2;
      for l := 0 to 999 do
        if MidPU[l] then
        begin
          if (Form1.ComboBox1.ItemIndex > 0) and
             (l = strtoint(Form1.ComboBox1.Items.Strings[Form1.ComboBox1.ItemIndex])) then
            BBRelBmp.Canvas.Pen.Color := $00FF80FF
          else if darkmode then
            BBRelBmp.Canvas.Pen.Color := RGB(220, 220, 220)
          else
            BBRelBmp.Canvas.Pen.Color := clBlack;
          BBRelBmp.Canvas.Ellipse(
            MidP[l].x + mmx + round((-60 + mpx) / Zoom),
            MidP[l].y + mmy + round((-60 + mpy) / Zoom),
            MidP[l].x + mmx + round((60 + mpx) / Zoom),
            MidP[l].y + mmy + round((60 + mpy) / Zoom));

          BBRelBmp.Canvas.Font.Size := round(40 / Zoom);
          BBRelBmp.Canvas.TextOut(MidP[l].x + mmx + round((-40 + mpx) / Zoom),
            MidP[l].y + mmy + round((-40 + mpy) / Zoom), inttostr(l));
          BBRelBmp.Canvas.Font.Size := 8;
        end;
      BBRelBmp.Canvas.Brush.Style := bsSolid;
      BBRelBmp.Canvas.Pen.Width := 1;
    end;

    BBRelBmp.Canvas.Pen.Color := 0;
    // fileclose(f);
    // releasedc(Image2.Canvas.Handle,hd);
    // show the z table

    finally
      if gpPenBlue <> nil then gpPenBlue.Free;
      if gpPenGreen <> nil then gpPenGreen.Free;
      if gpPenGray <> nil then gpPenGray.Free;
      if gpPenDefault <> nil then gpPenDefault.Free;
      if gpRawGraphics <> nil then gpRawGraphics.Free;
      for cIdx := 0 to Length(contourPaths) - 1 do
        if contourPaths[cIdx] <> nil then contourPaths[cIdx].Free;
    end;
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
  if Screen.ActiveForm = fmScriptTE then
    fmScriptTE.AddAnnotation1Click(nil)
  else
  begin
    if Copylastitem1.Enabled then
      Copylastitem1Click(nil);
  end;
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
    placerandom := false;
    placelookat := false;
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
    if form13.focused then
    begin
      MoveSel := -1;
      HideIndicator();
    end;
    LoadFloorGrids;
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
    placerandom := false;
    placelookat := false;
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
    if form13.focused then
    begin
      MoveSel := -1;
      HideIndicator();
    end;
    LoadFloorGrids;
  end;
end;

procedure TForm1.Copymonster1Click(Sender: TObject);
begin
  if Copylastmonster1.Enabled and not form4.edit1.Focused and not fmScriptTE.TextEdit.Focused
  and not fmScriptTE.Edit2.Focused and not fmScriptTE.txtNotes.Focused then
    Copylastmonster1Click(nil)
  else if form4.edit1.Focused then
    form4.edit1.CopyToClipboard
  else if fmScriptTE.TextEdit.Focused then
    fmScriptTE.TextEdit.CopyToClipboard(false)
  else if fmScriptTE.Edit2.Focused then
    fmScriptTE.Edit2.CopyToClipboard
  else if fmScriptTE.txtNotes.Focused then
    fmScriptTE.txtNotes.CopyToClipboard
end;

procedure TForm1.Veryhigh1Click(Sender: TObject);
begin
  SetBrightness(2);
end;

procedure TForm1.ViewScrypt1Click(Sender: TObject);
begin
  form4.Show;
end;

procedure DrawDragOverlay(const P: TPoint);
var
  OldPenMode: TPenMode;
  OldPenColor: TColor;
  OldPenStyle: TPenStyle;
  OldPenWidth: Integer;
  OldBrushStyle: TBrushStyle;
  C: TCanvas;
begin
  C := form1.Image2.Canvas;

  // Save original canvas state
  OldPenMode   := C.Pen.Mode;
  OldPenColor  := C.Pen.Color;
  OldPenStyle  := C.Pen.Style;
  OldPenWidth  := C.Pen.Width;
  OldBrushStyle := C.Brush.Style;

  try
    // Set the new style
    C.Pen.Mode  := pmCopy;
    if darkmode then
      C.Pen.Color := clWhite
    else
      C.Pen.Color := clBlack;
    C.Pen.Style := psDash;
    C.Pen.Width := 2;
    C.Brush.Style := bsClear;

    // Draw the overlay based on monster/object size
    C.Rectangle(P.X - Round(8 / Zoom), P.Y - Round(8 / Zoom),
                P.X + Round(8 / Zoom), P.Y + Round(8 / Zoom));
  finally
    // Restore the original canvas settings
    C.Pen.Mode  := OldPenMode;
    C.Pen.Color := OldPenColor;
    C.Pen.Style := OldPenStyle;
    C.Pen.Width := OldPenWidth;
    C.Brush.Style := OldBrushStyle;
  end;
end;

procedure DrawGuideLines(Anchor: TPoint; setsection: Boolean);
var
  OldPenMode: TPenMode;
  OldPenColor: TColor;
  OldPenStyle: TPenStyle;
  OldPenWidth: Integer;
  C: TCanvas;
  px,px2,px3,px4,py,py2,py3,py4,di: double;
  d, j, x: integer;
begin
    C := form1.Image2.Canvas;

    // Save original canvas state
    OldPenMode   := C.Pen.Mode;
    OldPenColor  := C.Pen.Color;
    OldPenStyle  := C.Pen.Style;
    OldPenWidth  := C.Pen.Width;

    C.Pen.Mode := pmCopy;
    C.Pen.Color := clBlack;
    C.Pen.Style := psDashDot;
    C.Pen.Width := 1;

    // Calculate the section coordinates based on the anchor
    px := mpx;
    px := px / Zoom;
    px := anchor.x - mmx - px;
    py := mpy;
    py := py / Zoom;
    py := anchor.y - mmy - py;

    if (shiftdw and not placerandom) or setsection then
    begin
      if sType = 1 then
        d := Floor[sfloor].Monster[selected].map_section;
      if sType = 2 then
        d := Floor[sfloor].Obj[selected].map_section;
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

    px2 := px - MidP[d].x;
    py2 := py - MidP[d].y;

    px := cos(rev[d] / 10430.37835) * px2 - sin(rev[d] / 10430.37835) * py2;
    py := sin(rev[d] / 10430.37835) * px2 + cos(rev[d] / 10430.37835) * py2;

    px := px * Zoom;
    py := py * Zoom;

    if sType = 1 then
    begin
      for j := 0 to Floor[sfloor].MonsterCount - 1 do
      begin
        if (Floor[sfloor].Monster[j].map_section = d) and
           ((Floor[sfloor].Monster[j].Unknow5 = showwave) or (showwave = -1)) then
        begin
          if (Round(Floor[sfloor].Monster[j].Pos_X) = Round(px)) or
             (Round(Floor[sfloor].Monster[j].Pos_Y) = Round(py)) then
          begin
            if j <> selected then
            begin
            if extractfilename(mapfilenam) = 'map_boss03c.rel' then
            begin
              MidP[0].y := 0;
            end;
            px4 := Floor[sfloor].Monster[j].Pos_X / Zoom;
            py4 := Floor[sfloor].Monster[j].Pos_Y / Zoom;
            px3 := cos(-rev[Floor[sfloor].Monster[j].map_section] / 10430.37835) * px4 -
            sin(-rev[Floor[sfloor].Monster[j].map_section] / 10430.37835) * py4;
            py3 := sin(-rev[Floor[sfloor].Monster[j].map_section] / 10430.37835) * px4 +
            cos(-rev[Floor[sfloor].Monster[j].map_section] / 10430.37835) * py4;

            px4 := mpx;
            px4 := px4 / Zoom;
            px3 := px3 + mmx + MidP[Floor[sfloor].Monster[j].map_section].x + px4;
            px4 := mpy;
            px4 := px4 / Zoom;
            py3 := py3 + mmy + MidP[Floor[sfloor].Monster[j].map_section].y + px4;

            C.MoveTo(Anchor.X, Anchor.Y);
            C.LineTo(Round(px3), Round(py3));
          end;
         end;
        end;
      end;
    end;


    if sType = 2 then
    begin
      for j := 0 to Floor[sfloor].ObjCount - 1 do
      begin
        if (Floor[sfloor].Obj[j].map_section = d) and
           ((Floor[sfloor].Obj[j].grp = showgrp) or (showgrp = -1)) then
        begin
          if (Round(Floor[sfloor].Obj[j].Pos_X) = Round(px)) or
             (Round(Floor[sfloor].Obj[j].Pos_Y) = Round(py)) then
          begin
            if j <> selected then
            begin
            if extractfilename(mapfilenam) = 'map_boss03c.rel' then
            begin
              MidP[0].y := 0;
            end;
            px4 := Floor[sfloor].Obj[j].Pos_X / Zoom;
            py4 := Floor[sfloor].Obj[j].Pos_Y / Zoom;
            px3 := cos(-rev[Floor[sfloor].Obj[j].map_section] / 10430.37835) * px4 -
            sin(-rev[Floor[sfloor].Obj[j].map_section] / 10430.37835) * py4;
            py3 := sin(-rev[Floor[sfloor].Obj[j].map_section] / 10430.37835) * px4 +
            cos(-rev[Floor[sfloor].Obj[j].map_section] / 10430.37835) * py4;

            px4 := mpx;
            px4 := px4 / Zoom;
            px3 := px3 + mmx + MidP[Floor[sfloor].Obj[j].map_section].x + px4;
            px4 := mpy;
            px4 := px4 / Zoom;
            py3 := py3 + mmy + MidP[Floor[sfloor].Obj[j].map_section].y + px4;

            C.MoveTo(Anchor.X, Anchor.Y);
            C.LineTo(Round(px3), Round(py3));
            end;
         end;
        end;
      end;
    end;

    // Restore the original canvas settings
    C.Pen.Mode  := OldPenMode;
    C.Pen.Color := OldPenColor;
    C.Pen.Style := OldPenStyle;
    C.Pen.Width := OldPenWidth;
end;

procedure TForm1.Image2MouseMove(Sender: TObject; Shift: TShiftState; x, y: integer);
var
  t, px, px2, py, py2: double;
  p: TPoint;
begin
  mpcx := x;
  mpcy := y;
  // Ready to drag
  if (mdrag = 1) and (selected > -1) then
  begin
    // Check within a 6 px radius for mouse movement
    if ((mpcx - lmdx)*(mpcx - lmdx) +
        (mpcy - lmdy)*(mpcy - lmdy)) >= (6*6) then
    begin
      mdrag := 2;
    end;
  end;
  // Actively dragging
  if (mdrag = 2) and (selected > -1) then
  begin
    DrawMap;
    if stype = 1 then
    begin
      if extractfilename(mapfilenam) = 'map_boss03c.rel' then
      begin
        MidP[0].y := 0;
      end;
      px2 := Floor[sfloor].Monster[selected].Pos_X / Zoom;
      py2 := Floor[sfloor].Monster[selected].Pos_Y / Zoom;
      px := cos(-rev[Floor[sfloor].Monster[selected].map_section] / 10430.37835) * px2 -
        sin(-rev[Floor[sfloor].Monster[selected].map_section] / 10430.37835) * py2;
      py := sin(-rev[Floor[sfloor].Monster[selected].map_section] / 10430.37835) * px2 +
        cos(-rev[Floor[sfloor].Monster[selected].map_section] / 10430.37835) * py2;

      px2 := mpx;
      px2 := px2 / Zoom;
      px := px + mmx + MidP[Floor[sfloor].Monster[selected].map_section].x + px2;
      px2 := mpy;
      px2 := px2 / Zoom;
      py := py + mmy + MidP[Floor[sfloor].Monster[selected].map_section].y + px2;
    end;
    if stype = 2 then
    begin
      if extractfilename(mapfilenam) = 'map_boss03c.rel' then
      begin
        MidP[0].y := 0;
      end;
      px2 := Floor[sfloor].Obj[selected].Pos_X / Zoom;
      py2 := Floor[sfloor].Obj[selected].Pos_Y / Zoom;
      px := cos(-rev[Floor[sfloor].Obj[selected].map_section] / 10430.37835) * px2 -
        sin(-rev[Floor[sfloor].Obj[selected].map_section] / 10430.37835) * py2;
      py := sin(-rev[Floor[sfloor].Obj[selected].map_section] / 10430.37835) * px2 +
        cos(-rev[Floor[sfloor].Obj[selected].map_section] / 10430.37835) * py2;

      px2 := mpx;
      px2 := px2 / Zoom;
      px := px + mmx + MidP[Floor[sfloor].Obj[selected].map_section].x + px2;
      px2 := mpy;
      px2 := px2 / Zoom;
      py := py + mmy + MidP[Floor[sfloor].Obj[selected].map_section].y + px2;
    end;

    image2.Canvas.Pen.Color := RGB(0, 160, 200);

    // X-axis - left-right
    if xdown then
    begin
      p := Point(x, Round(py));
      image2.Canvas.MoveTo(0, Round(py));
      image2.Canvas.LineTo(Image2.Width, Round(py));
    end
    // Z-axis - up-down
    else if zdown then
    begin
      p := Point(Round(px), y);
      image2.Canvas.MoveTo(Round(px), 0);
      image2.Canvas.LineTo(Round(px), Image2.Height);
    end
    else p := Point(x, y);
    DrawDragOverlay(p);
    DrawGuideLines(p, false);
    image2.Canvas.Pen.Color := clBlack;
  end;
  Label5.Caption := 'X: ' + inttostr(round(((x - mmx) - (mpx / Zoom)) * Zoom)) + '  Y: ' +
    inttostr(round(YFromBBRELFile(((x - mmx) - (mpx / Zoom)) * Zoom, ((y - mmy) - (mpy / Zoom)) * Zoom))) + '  Z: ' +
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
    mdrag := 0;
    DrawMap;
    mdown := 2;
  end;
end;

procedure TForm1.Image2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; x, y: integer);
var
  z, l: Integer;
  px, px2, py, py2: Double;
  p: TPoint;
begin
  inedit := false;
  // Start of mouse drag
  if (Button = mbleft) and (smDrag.checked) then
  begin
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

        if placelookat then
        begin
          if (mpcx >= round(px) - round(6 / Zoom)) and (mpcx <= round(px) + round(6 / Zoom)) and
          (mpcy >= round(py) - round(6 / Zoom)) and (mpcy <= round(py) + round(6 / Zoom)) then
          begin
            LookAt2D(selected, sType, px, py);
            exit;
          end;
        end;

        if (mpcx >= round(px) - round(6 / Zoom)) and (mpcx <= round(px) + round(6 / Zoom)) and
          (mpcy >= round(py) - round(6 / Zoom)) and (mpcy <= round(py) + round(6 / Zoom))
          and not placelookat then
          begin
            l := ListBox1.ItemIndex;
            ListBox1.ItemIndex := z;
            lmdx := mpcx;
            lmdy := mpcy;
            mdrag := 0;
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
            begin
              inedit := true;
              mdrag := 0;
              DrawMap;
              Form1.ListBox1DblClick(Form1)
            end
            else
              Form1.ListBox1Click(Form1);
            if not inedit then
            begin
              lastimgclick := gettickcount();
              mdrag := 1;
            end;
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

        if placelookat then
        begin
          if (mpcx >= round(px) - round(6 / Zoom)) and (mpcx <= round(px) + round(6 / Zoom)) and
          (mpcy >= round(py) - round(6 / Zoom)) and (mpcy <= round(py) + round(6 / Zoom)) then
          begin
            LookAt2D(selected, sType, px, py);
            exit;
          end;
        end;

        if (mpcx >= round(px) - round(6 / Zoom)) and (mpcx <= round(px) + round(6 / Zoom)) and
        (mpcy >= round(py) - round(6 / Zoom)) and (mpcy <= round(py) + round(6 / Zoom))
        and not placelookat then
        begin
            l := ListBox2.ItemIndex;
            ListBox2.ItemIndex := z;
            lmdx := mpcx;
            lmdy := mpcy;
            mdrag := 0;
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
            begin
              inedit := true;
              mdrag := 0;
              DrawMap;
              Form1.ListBox1DblClick(Form1)
            end
            else
              Form1.ListBox2Click(Form1);
            if not inedit then
            begin
              lastimgclick := gettickcount();
              mdrag := 1;
            end;
        end;
      end;
      if placelookat then
        LookAt2D(selected, sType, mpcx, mpcy);
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
  end;

   if (mdrag = 1) and (selected > -1) then
  begin
    if stype = 1 then
    begin
      if extractfilename(mapfilenam) = 'map_boss03c.rel' then
      begin
        MidP[0].y := 0;
      end;
      px2 := Floor[sfloor].Monster[selected].Pos_X / Zoom;
      py2 := Floor[sfloor].Monster[selected].Pos_Y / Zoom;
      px := cos(-rev[Floor[sfloor].Monster[selected].map_section] / 10430.37835) * px2 -
        sin(-rev[Floor[sfloor].Monster[selected].map_section] / 10430.37835) * py2;
      py := sin(-rev[Floor[sfloor].Monster[selected].map_section] / 10430.37835) * px2 +
        cos(-rev[Floor[sfloor].Monster[selected].map_section] / 10430.37835) * py2;

      px2 := mpx;
      px2 := px2 / Zoom;
      px := px + mmx + MidP[Floor[sfloor].Monster[selected].map_section].x + px2;
      px2 := mpy;
      px2 := px2 / Zoom;
      py := py + mmy + MidP[Floor[sfloor].Monster[selected].map_section].y + px2;
    end;
    if stype = 2 then
    begin
      if extractfilename(mapfilenam) = 'map_boss03c.rel' then
      begin
        MidP[0].y := 0;
      end;
      px2 := Floor[sfloor].Obj[selected].Pos_X / Zoom;
      py2 := Floor[sfloor].Obj[selected].Pos_Y / Zoom;
      px := cos(-rev[Floor[sfloor].Obj[selected].map_section] / 10430.37835) * px2 -
        sin(-rev[Floor[sfloor].Obj[selected].map_section] / 10430.37835) * py2;
      py := sin(-rev[Floor[sfloor].Obj[selected].map_section] / 10430.37835) * px2 +
        cos(-rev[Floor[sfloor].Obj[selected].map_section] / 10430.37835) * py2;

      px2 := mpx;
      px2 := px2 / Zoom;
      px := px + mmx + MidP[Floor[sfloor].Obj[selected].map_section].x + px2;
      px2 := mpy;
      px2 := px2 / Zoom;
      py := py + mmy + MidP[Floor[sfloor].Obj[selected].map_section].y + px2;
    end;
    p := Point(Round(px),Round(py));
    DrawGuideLines(p, true);
  end;
end;

procedure TForm1.Image2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; x, y: integer);
begin
  if (Button = mbleft) and (smDrag.Checked) and (mdrag = 2) then
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
    end;
  end;
  if mdown = 1 then
  begin
    Image2.PopupMenu.Popup(mouse.CursorPos.x, mouse.CursorPos.y);
    mpcx := mouse.CursorPos.x;
    mpcy := mouse.CursorPos.y;
  end;
  mdown := 0;
  mdrag := 0;
  DrawMap;
end;

procedure TForm1.Image2Paint(Sender: TObject);
begin
  Image2.Canvas.Draw(0, 0, BBRelBmp);
end;

procedure TForm1.FormShow(Sender: TObject);
var
  f: textfile;
  s, b: ansistring;
  x, y, z, ma, l, i, mylang: integer;
  m, fl, arglist: tstringlist;
  fx: textfile;
  Reg: TRegistry;
  flp: TMemoryStream;
begin
  If tag = 0 then
  begin
    selectionBMP := TBitmap.Create;
    SetImage1Colors;
    clientdataset1.CreateDataSet;
    clientdataset2.CreateDataSet;
    showbmp.ShortCut := TextToShortCut('`');
    showbitmapoverlays1.ShortCut := TextToShortCut('`');
    BMPCache := TDictionary<string, TBitmap>.Create;
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

        // Calculate the in-game values for warp objects based on their rotation
        CalculateWarpOffsets(ObjTemplate[x].data.unknow6 + rev[ObjTemplate[x].data.map_section]);

        if ma = 12 then
          ObjTemplate[x].data.unknow7 := strtoint(s);

        if ma = 13 then
        begin
          if ((ObjTemplate[x].data.Skin = 3) or (ObjTemplate[x].data.Skin = 321) or (ObjTemplate[x].data.Skin = 697)) and not showdata then
            ObjTemplate[x].data.unknow8 := strtoint(s) - warpx
          else
            ObjTemplate[x].data.unknow8 := strtoint(s);
        end;
        if ma = 14 then
          ObjTemplate[x].data.unknow9 := strtoint(s);
        if ma = 15 then
        begin
          if ((ObjTemplate[x].data.Skin = 3) or (ObjTemplate[x].data.Skin = 321) or (ObjTemplate[x].data.Skin = 697)) and not showdata then
            ObjTemplate[x].data.unknow10 := strtoint(s) - warpz
          else
            ObjTemplate[x].data.unknow10 := strtoint(s);
        end;

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

    if fileexists('asmargs.txt') then
      fl.LoadFromFile('asmargs.txt')
    else
    begin
      fmScriptTE.AddArgs1.Checked := false;
      fmScriptTE.AddArgs1.Enabled := false;
    end;

    // Load asm argument list
    if fmScriptTE.AddArgs1.Enabled then
    begin
      x := 0;
      arglist := TStringList.Create;
      while x < fl.count do
      begin
          arglist.StrictDelimiter := True;
          arglist.Delimiter := ' ';
          arglist.DelimitedText := fl.Strings[x];
          if arglist.count > 2 then
          begin
            trystrtoint('$' + arglist[0],integer(asmarg[x].opcodeid));
            asmarg[x].argtype := arglist[1];
            trystrtoint(arglist[2],asmarg[x].argnum);
          end;
          inc(x);
      end;
      arglist.Free;
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
        if Reg.ValueExists('MainTheme') then
        begin
          fmThemes.ComboBox1.ItemIndex := Reg.ReadInteger('MainTheme');
        end
        else fmThemes.ComboBox1.ItemIndex := 29; // Windows default
        // Set dark mode based on theme
        if (TStyleManager.ActiveStyle.GetStyleColor(scListBox) <> clWhite)
        and TStyleManager.IsCustomStyleActive then
          darkmode := true;
        if Reg.ValueExists('TENoteFontName') then
          fmScriptTE.txtNotes.Font.Name := Reg.ReadString('TENoteFontName');
        if Reg.ValueExists('TENoteFontSize') then
          fmScriptTE.txtNotes.Font.Size := Reg.ReadInteger('TENoteFontSize');
        if Reg.ValueExists('TENoteFontStyle') then
          fmScriptTE.txtNotes.Font.Style := Tfontstyles(byte(Reg.ReadInteger('TENoteFontStyle')));
        if Reg.ValueExists('TENoteColor') then
          fmScriptTE.txtNotes.Font.Color := Reg.ReadInteger('TENoteColor');
        if Reg.ValueExists('TENoteBackgroundColor') then
          fmScriptTE.txtNotes.Color := Reg.ReadInteger('TENoteBackgroundColor');
        if Reg.ValueExists('ThemeModified') then
          thememodified := Reg.ReadBool('ThemeModified');
        if Reg.ValueExists('TETheme') then
          texttheme := Reg.ReadInteger('TETheme');
        if Reg.ValueExists('TopCollapsed') and Reg.ReadBool('TopCollapsed') then
          SetTopCollapsed(true);
        if DirectoryExists(path + 'Text editor\Themes') then
        begin
          with fmScriptTE do
          begin
            Changetheme1.Enabled := true;
            if texttheme = -1 then
              ChangeTheme(Default1)
            else if texttheme = 0 then
              ChangeTheme(Blue1)
            else if texttheme = 1 then
              ChangeTheme(Classic1)
            else if texttheme = 2 then
              ChangeTheme(Darcula1)
            else if texttheme = 3 then
              ChangeTheme(DarkIcon1)
            else if texttheme = 4 then
              ChangeTheme(Dark1)
            else if texttheme = 5 then
              ChangeTheme(Darker1)
            else if texttheme = 6 then
              ChangeTheme(Dracula1)
            else if texttheme = 7 then
              ChangeTheme(FluentNight1)
            else if texttheme = 8 then
              ChangeTheme(GitHubDark1)
            else if texttheme = 9 then
              ChangeTheme(MonokaiDistilled1)
            else if texttheme = 10 then
              ChangeTheme(Monokai1)
            else if texttheme = 11 then
              ChangeTheme(Oblivion1)
            else if texttheme = 12 then
              ChangeTheme(Obsid1)
            else if texttheme = 13 then
              ChangeTheme(Ocean1)
            else if texttheme = 14 then
              ChangeTheme(Oceanic1)
            else if texttheme = 15 then
              ChangeTheme(Okaidia1)
            else if texttheme = 16 then
              ChangeTheme(Purple1)
            else if texttheme = 17 then
              ChangeTheme(Twilight1)
            else if texttheme = 18 then
              ChangeTheme(VisualStudioDark1)
            else if texttheme = 19 then
              ChangeTheme(VisualStudio1)
            else if texttheme = 20 then
              ChangeTheme(Windows11Dark1);
          end;
        end;
        if thememodified then
        begin
          Reg.WriteBool('ThemeModified',thememodified);
          UncheckThemes;
          if Reg.ValueExists('TEFontName') then
            fmScriptTE.TextEdit.Fonts.Text.name := Reg.ReadString('TEFontName');
          if Reg.ValueExists('TEFontSize') then
            fmScriptTE.TextEdit.Fonts.Text.size := Reg.ReadInteger('TEFontSize');
          if Reg.ValueExists('TEFontStyle') then
            fmScriptTE.TextEdit.Fonts.Text.Style := Tfontstyles(byte(Reg.ReadInteger('TEFontStyle')));
          fmScriptTE.TextEdit.Fonts.Text.Pitch := fpFixed;
          // Set theme and text editor colors
          if Reg.ValueExists('TELabelColor') then
            fmScriptTE.TextEdit.Colors.EditorMethodNameForeground := Reg.ReadInteger('TELabelColor');
          if Reg.ValueExists('TEOpcodeColor') then
            fmScriptTE.TextEdit.Colors.EditorReservedWordForeground := Reg.ReadInteger('TEOpcodeColor');
          if Reg.ValueExists('TERegisterColor') then
            fmScriptTE.TextEdit.Colors.EditorSymbolForeground := Reg.ReadInteger('TERegisterColor');
          if Reg.ValueExists('TEValueColor') then
          begin
            fmScriptTE.TextEdit.Colors.EditorNumberForeground := Reg.ReadInteger('TEValueColor');
            fmScriptTE.TextEdit.Colors.EditorHexNumberForeground := Reg.ReadInteger('TEValueColor');
          end;
          if Reg.ValueExists('TESTRColor') then
            fmScriptTE.TextEdit.Colors.EditorCommentForeground := Reg.ReadInteger('TESTRColor');
          if Reg.ValueExists('TEStringColor') then
            fmScriptTE.TextEdit.Colors.EditorStringForeground := Reg.ReadInteger('TEStringColor');
          if Reg.ValueExists('TEAnnoColor') then
            fmScriptTE.TextEdit.Colors.EditorDirectiveForeground := Reg.ReadInteger('TEAnnoColor');
        end;
        if Reg.ValueExists('Lang') then
          mylang := Reg.ReadInteger('Lang');
        if mylang = 0 then English1.Checked := true
        else if mylang = 1 then French1.Checked := true
        else if mylang = 2 then Spanish1.Checked := true
        else if mylang = 3 then Russian1.Checked := true
        else if mylang = 4 then
        begin
          Japanese1.Checked := true;
          SetManualHotkeys;
        end;

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
        if Reg.ValueExists('DistanceLimit') then
          distancelimit := Reg.ReadInteger('DistanceLimit');
        if Reg.ValueExists('TextEditZoom') then
          texteditzoom := Reg.ReadInteger('TextEditZoom');
        if Reg.ValueExists('SnapRotate') then
          snaprotate := Reg.ReadBool('SnapRotate');
       if Reg.ValueExists('SnapYValue') then
          snapyvalue := Reg.ReadBool('SnapYValue');
        if Reg.ValueExists('SnapDistance') then
          snapdistance := Reg.ReadBool('SnapDistance');
        if Reg.ValueExists('AnchorEnabled') then
          anchorenabled := Reg.ReadBool('AnchorEnabled');
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
        if Reg.ValueExists('Follow3D') then
          follow3D := Reg.ReadBool('Follow3D');
        if Reg.ValueExists('ShowData') then
          showdata := Reg.ReadBool('ShowData');
        if Reg.ValueExists('ShowDecimal') then
          ShowDecimal := Reg.ReadBool('ShowDecimal');
        if Reg.ValueExists('ShowGrid') then
          ShowGrid := Reg.ReadBool('ShowGrid');
        if Reg.ValueExists('EditGrid') then
          editgrid := Reg.ReadBool('EditGrid');
        if Reg.ValueExists('AddArgs') then
          addargs := Reg.ReadBool('AddArgs');
        if Reg.ValueExists('HideNOPs') then
          hidenops := Reg.ReadBool('HideNOPs');
        if Reg.ValueExists('HideAnnotations') then
          hideanno := Reg.ReadBool('HideAnnotations');
        if Reg.ValueExists('ShowBMP') then
          showbitmaps := Reg.ReadBool('ShowBMP');
        if Reg.ValueExists('MarkerBrightness') then
          markerbrightness := Reg.ReadInteger('MarkerBrightness');
        if Reg.ValueExists('OutlineWidth') then
          outlinewidth := Reg.ReadInteger('OutlineWidth');
        if Reg.ValueExists('CountFilter') then
          countfilter := Reg.ReadInteger('CountFilter');
        if Reg.ValueExists('SearchWholeWords') then
          searchwholewords := Reg.ReadBool('SearchWholeWords');
        if Reg.ValueExists('SearchMatchCase') then
          searchmatchcase := Reg.ReadBool('SearchMatchCase');
        if Reg.ValueExists('SearchEngine') then
          searchengine := Reg.ReadInteger('SearchEngine');
        if Reg.ValueExists('ReplaceSelectionOnly') then
          replaceselectiononly := Reg.ReadBool('ReplaceSelectionOnly');
        if Reg.ValueExists('3DMoveSpeed') then
          movespeed := Reg.ReadInteger('3DMoveSpeed');
        if Reg.ValueExists('DataDisplay') then
          dta := Reg.ReadInteger('DataDisplay');
        if Reg.ValueExists('3DAutoAdjustSect') then
          autoadjustsect := Reg.ReadBool('3DAutoAdjustSect');
        if Reg.ValueExists('3DAutoAdjustY') then
          autoadjustY := Reg.ReadBool('3DAutoAdjustY');
        if Reg.ValueExists('TEHeight') then
          TEHeight := Reg.ReadInteger('TEHeight');
        if Reg.ValueExists('TEWidth') then
          TEWidth := Reg.ReadInteger('TEWidth');
        if Reg.ValueExists('TEState') then
          TEState := Reg.ReadInteger('TEState');
        if Reg.ValueExists('NotesWidth') then
          NotesWidth := Reg.ReadInteger('NotesWidth');
        if Reg.ValueExists('NotesVisible') then
          NotesVisible := Reg.ReadBool('NotesVisible');
        if Reg.ValueExists('MinimapVisible') then
          MinimapVisible := Reg.ReadBool('MinimapVisible');
        if Reg.ValueExists('CoordSize') then
          coordsize := Reg.ReadInteger('CoordSize');
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
    fl.Clear;
    if fileexists('Eng.txt') then
    begin
      fl.LoadFromFile('Eng.txt');
      flp.LoadFromFile('Eng.txt');
    end;
    // Rebuild Eng.txt if it's incomplete or doesn't exist
    if fl.Count < High(EnglishUIText) + 1 then
    begin
      fl.Clear;
      flp.Clear;
      for i := 0 to High(EnglishUIText) do
        fl.add(EnglishUIText[i]);
      // Back up original
      if fileexists('Eng.txt') then
        TFile.Copy(path + 'Eng.txt', path + 'Eng.txt.back', true);
      fl.SaveToFile('Eng.txt');
      flp.LoadFromFile('Eng.txt');
    end;
    if mylang = 1 then
    begin
      flp.Clear;
      if fileexists('fra.txt') then
        flp.LoadFromFile('fra.txt')
      else
        PikaGetFile(flp, 'fra.txt', path + 'config.ppk', 'Build By Schthack');
    end;
    if mylang = 2 then
    begin
        if fileexists('spa.txt') then
          flp.LoadFromFile('spa.txt')
        else
          PikaGetFile(flp, 'spa.txt', path + 'config.ppk', 'Build By Schthack');
    end;
    if mylang = 3 then
    begin
      flp.Clear;
      flp.LoadFromFile('ru.txt');
    end;
    if mylang = 4 then
    begin
      flp.Clear;
      flp.LoadFromFile('jp.txt');
    end;

    if snapenabled then
      FSnapOptions.seDistanceLimit.Enabled := anchorenabled;
    smDrag.Checked := dragenabled;
    FSnapOptions.chkDistancelimit.Checked := anchorenabled;
    FSnapOptions.chkSnap.Checked := snapenabled;
    FSnapOptions.chkSnapDistance.Enabled := snapenabled;
    FSnapOptions.chkSnapRotate.Enabled := snapenabled;
    FSnapOptions.chkSnapYValue.Enabled := snapenabled;
    FSnapOptions.chkDistancelimit.Enabled := snapenabled;
    FSnapOptions.seSnapTolerance.Enabled := snapenabled;
    Form7.chkAutoAxis.Checked := autoaxis;
    fmRotation.chkAutoAxis.Checked := autoaxis;
    FSnapOptions.seSnapTolerance.Value := snapvalue;
    FSnapOptions.chkSnapRotate.Checked := snaprotate;
    FSnapOptions.chkSnapYValue.Checked := snapyvalue;
    FSnapOptions.chkSnapDistance.Checked := snapdistance;

    smDisableIndicator.Checked := disableindicator;
    form17.chkFullscreen.Checked := fullscreen;
    form17.chkFollow.Checked := follow3D;

    if showdata then
      form7.btnToggleData.Caption := GetLanguageString(467)
    else
      form7.btnToggleData.Caption := GetLanguageString(468);

    if showdecimal then
    begin
      form4.Decimal1.Checked := true;
      form4.Hex1.Checked := false;
      fmScriptTE.Decimal1.Checked := true;
      fmScriptTE.Hex1.Checked := false;
    end
    else
    begin
      form4.Hex1.Checked := true;
      form4.Decimal1.Checked := false;
      fmScriptTE.Hex1.Checked := true;
      fmScriptTE.Decimal1.Checked := false;
    end;

    if showgrid then
      ShowGrids
    else
      HideGrids;

    if editgrid then
      EnableGridEdit
    else
      DisableGridEdit;

    fmScriptTE.AddArgs1.Checked := addargs;
    form4.HideNOPs1.Checked := hidenops;
    fmScriptTE.HideNOPs1.Checked := hidenops;
    fmScriptTE.Annotations1.Checked := hideanno;

    form1.showbmp.Checked := showbitmaps;
    SetBrightness(markerbrightness);
    SetOutlineWidth(outlinewidth);

    form31.cbShow.ItemIndex := countfilter;

    FSnapOptions.seDistanceLimit.Value := distancelimit;
    FPlacementOptions.nbOffsetX.Value := OffsetX;
    FPlacementOptions.nbOffsetY.Value := OffsetY;
    FPlacementOptions.nbOffsetZ.Value := OffsetZ;
    FPlacementOptions.seDefaultSect.Value := DefaultSect;
    FPlacementOptions.nbDefaultX.Value := DefaultX;
    FPlacementOptions.nbDefaultY.Value := DefaultY;
    FPlacementOptions.nbDefaultZ.Value := DefaultZ;

    SetTextZoom(texteditzoom);
    fmScriptTE.Wholewords1.Checked := searchwholewords;
    fmScriptTE.Matchcase1.Checked := searchmatchcase;
    SetSearchEngine(searchengine);
    fmReplace.Selectiononly1.Checked := replaceselectiononly;

    if TEState = Ord(wsMaximized) then
      fmScriptTE.WindowState := wsMaximized
    else
    begin
      fmScriptTE.Height := TEHeight;
      fmScriptTE.Width := TEWidth;
    end;

    // Work around to avoid misalignment of search bar after resizing text editor
    fmScriptTE.Edit2.Show;
    fmScriptTE.Edit2.Hide;

    fmScriptTE.NotesPanel.Width := NotesWidth;
    fmScriptTE.Splitter1.Left := fmScriptTE.NotesPanel.Left;
    if NotesVisible then
      fmScriptTE.Notes1Click(nil);

    if MinimapVisible then
      fmScriptTE.Minimap1Click(nil);

    SetCoordSize(coordsize);

    LoadLanguageStrings(flp);
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
  f, idx, room: integer;
  s: string;
begin
  s := 'All chunks|*.*|Objects only|*o.dat|Monsters only|*e.dat|Events only|*.evt' +
                        '|Random spawn data only|*r.dat';
  if Combobox1.ItemIndex > 0 then
  begin
    room := strtoint(Combobox1.Items[Combobox1.ItemIndex]);
    s := s + '|Section ' + inttostr(room) + ' objects only|*s' + inttostr(room) + '_o.dat';
    s := s + '|Section ' + inttostr(room) + ' monsters only|*s' + inttostr(room) + '_e.dat';
  end;
  SaveDialog1.Filter := s;
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
      if (SaveDialog1.FilterIndex = 1) or (SaveDialog1.FilterIndex = 5) then
      begin
        f := filecreate(SaveDialog1.filename + 'r.dat');
        filewrite(f, Floor[CheckListBox1.ItemIndex].d04count, 4);
        filewrite(f, Floor[CheckListBox1.ItemIndex].d04[0], Floor[CheckListBox1.ItemIndex].d04count);
        filewrite(f, Floor[CheckListBox1.ItemIndex].d05count, 4);
        filewrite(f, Floor[CheckListBox1.ItemIndex].d05[0], Floor[CheckListBox1.ItemIndex].d05count);
        fileclose(f);
      end;
      if SaveDialog1.FilterIndex = 6 then
      begin
        f := filecreate(SaveDialog1.filename + 's' + inttostr(room) + '_o.dat');
        for idx := 0 to Floor[CheckListBox1.ItemIndex].ObjCount - 1 do
          if Floor[CheckListBox1.ItemIndex].Obj[idx].map_section = room then
            filewrite(f, Floor[CheckListBox1.ItemIndex].Obj[idx], $44);
        fileclose(f);
      end;
      if SaveDialog1.FilterIndex = 7 then
      begin
        f := filecreate(SaveDialog1.filename + 's' + inttostr(room) + '_e.dat');
        for idx := 0 to Floor[CheckListBox1.ItemIndex].MonsterCount - 1 do
          if Floor[CheckListBox1.ItemIndex].Monster[idx].map_section = room then
            filewrite(f, Floor[CheckListBox1.ItemIndex].Monster[idx], $48);
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
  x, y, f, o, j, i, F2, F1, s1, s2, z, bl, dl: integer;
  d: dword;
  txt: array [0 .. 1] of ansichar;
  h: TNPCGroupeHeader;
  fn, b: ansistring;
  tmp: array [0 .. $3FF] of ansichar;
  di, da, db: pansichar;
  qtmp: array [0 .. 99] of pansichar;
  qtmpsize, qtmppos: array [0 .. 99] of integer;
  mh: ansistring;
  cleantitle: widestring;
begin

  SaveDialog1.Filter :=
    'Quest file|*.bin|Server Quest file(PC)|*.qst|Server Quest file(DC)|*.qst|Server Quest file(GC)|*.qst|Server Quest file(BB)'
    + '|*.qst|Download Quest file(DC)|*.qst|Download Quest file(PC)|*.qst|Download Quest file(GC)|*.qst|Download Quest file(Xbox)|*.qst'
    + '|Compressed Quest file(PC)|*.bin|Compressed Quest file(DC)|*.bin|Compressed Quest file(GC)|*.bin|Compressed Quest file(BB)|*.bin'
    + '|Uncompressed Quest file(PC)|*.bin|Uncompressed Quest file(DC)|*.bin|Uncompressed Quest file(GC)|*.bin|Uncompressed Quest file(BB)|*.bin'
    + '|Quest project|*.qprj';

  SaveDialog1.FilterIndex := lsatsaveformat;
  if SaveDialog1.Execute then
  begin
    // Save quest notes
    if not DirectoryExists(path + 'notes') then
      CreateDir(path + 'notes');
    cleantitle := SanitizeFileName(title);
    if (cleantitle <> '') and DirectoryExists(path + 'notes')
    and (fmScriptTE.txtNotes.Lines.Count > 0) then
      fmScriptTE.txtNotes.Lines.SaveToFile(path + 'notes\' + cleantitle + ' notes' + '.txt');

    lsatsaveformat := SaveDialog1.FilterIndex;
    isedited := false;
    ClearShadow;
    FullQuestFile := SaveDialog1.filename;
    if SaveDialog1.FilterIndex = 18 then
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

    if (SaveDialog1.FilterIndex = 10) or (SaveDialog1.FilterIndex = 14) then
    begin
      AsmMode := 0;
      isdc := false;
    end;
    if (SaveDialog1.FilterIndex = 11) or (SaveDialog1.FilterIndex = 15) then
    begin
      AsmMode := 0;
      isdc := true;
    end;
    if (SaveDialog1.FilterIndex = 12) or (SaveDialog1.FilterIndex = 16) then
    begin
      AsmMode := 2;
      isdc := false;
    end;
    if (SaveDialog1.FilterIndex = 13) or (SaveDialog1.FilterIndex = 17) then
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

    // Save STR/HEX label data
    for i:= 0 to 1000 do
    begin
      if (datablock[i] <> -1) and ((datablockT[i] = T_STRDATA) or (datablockT[i] = T_DATA)) then
      begin
        move(datablock[i], di[F1], 4);
        move(datablockT[i], di[F1 + 4], 1);
        inc(F1, 5);
        inc(F2, 5);
      end;
    end;

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
          // Make sure rooms are saved in the correct order
          sFloor := x;
          form15.LoadRandomData;
          form15.SaveD04;
          sFloor := CheckListBox1.ItemIndex;
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

procedure TForm1.Selection1Click(Sender: TObject);
begin
  Rowselection1Click(nil);
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
  x, y, z, f: integer;
  h: TNPCGroupeHeader;
begin
  OpenDialog1.Filter := 'Objects|*o.dat;*d.dat|Monsters|*e.dat|Events|*.evt' +
                        '|Random spawn data|*r.dat' +
                        '|Append objects|*o.dat;*d.dat|Append monsters|*e.dat';
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
    if OpenDialog1.FilterIndex = 4 then
    begin
      f := fileopen(OpenDialog1.filename, $40);
      Floor[x].d04count := 0;
      Floor[x].d05count := 0;
      fileread(f, Floor[x].d04count, 4);
      fileread(f, Floor[x].d04[0], Floor[x].d04count);
      fileread(f, Floor[x].d05count, 4);
      fileread(f, Floor[x].d05[0], Floor[x].d05count);
      if (Floor[x].d04count > 0) or (Floor[x].d05count > 0) then
        button12.Enabled := true
      else button12.Enabled := false;
    end;
    if OpenDialog1.FilterIndex = 5 then
    begin
      f := fileopen(OpenDialog1.filename, $40);
      y := fileseek(f, 0, 2) div $44;
      z := Floor[x].ObjCount;
      inc(Floor[x].ObjCount,y);
      fileseek(f, 0, 0);
      fileread(f, Floor[x].Obj[z], y * $44);
      fileclose(f);
      CheckListBox1Click(Form1);
    end;
    if OpenDialog1.FilterIndex = 6 then
    begin
      f := fileopen(OpenDialog1.filename, $40);
      y := fileseek(f, 0, 2) div $48;
      z := Floor[x].MonsterCount;
      inc(Floor[x].MonsterCount,y);
      fileseek(f, 0, 0);
      fileread(f, Floor[x].Monster[z], y * $48);
      fileclose(f);
      CheckListBox1Click(Form1);
    end;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  x, y, s, next: integer;
  p1, p2: pansichar;
begin
  if Selected > -1 then
  begin
    if showgrid and (sender <> DBGrid1) then
    begin
      ClientDataSet1.DisableControls;
      ClientDataSet2.DisableControls;

      // Save the current row positions
      if sType = 1 then
        next := ClientDataSet1.RecNo
      else
        next := ClientDataSet2.RecNo;
    end;
    s := Selected;
    isedited := true;
    HideIndicator();
    MoveSel := -1;
    if sender <> DBGrid1 then
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
      // Clear parent IDs
      if Floor[sFloor].Obj[selected].Skin = 10000 then
      begin
        for x := 0 to Floor[sfloor].MonsterCount - 1 do
          if Floor[sFloor].Monster[x].unknow4 = Floor[sFloor].Obj[selected].id then
            Floor[sFloor].Monster[x].unknow4 := 0;
        for x := 0 to Floor[sfloor].ObjCount - 1 do
          if Floor[sFloor].Obj[x].id = Floor[sFloor].Obj[selected].id then
            Floor[sFloor].Obj[x].id := 0;
      end;

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
    indelete := true;
    CheckListBox1Click(Form1);
    indelete := false;
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
        transform1.Enabled := true;
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
        transform1.Enabled := true;
      end;
    end;

    if showgrid and (sender <> DBGrid1) then
    begin
      if sType = 1 then
      begin
        gridtype := 1;
        // Refresh floor data
        LoadFloorGrids;

        if Floor[sfloor].MonsterCount = 0 then
        begin
          Selected := -1;
          Button2.Enabled := false;
          Button1.Enabled := false;
          Button3.Enabled := false;
          smEdit.Enabled := false;
          smDelete.Enabled := false;
          smMove.Enabled := false;
          transform1.Enabled := false;
        end
        else
        begin
          // Return to the last row
          if next > ClientDataSet1.RecordCount then
            ClientDataSet1.Last
          else
            ClientDataSet1.RecNo := next;
          Selected := ClientDataSet1.FieldByName('#').AsInteger;
        end;
        form1.Listbox1.ItemIndex := selected;
      end;

      if sType = 2 then
      begin
        gridtype := 2;
        // Refresh floor data
        LoadFloorGrids;

        if Floor[sfloor].ObjCount = 0 then
        begin
          Selected := -1;
          Button2.Enabled := false;
          Button1.Enabled := false;
          Button3.Enabled := false;
          smEdit.Enabled := false;
          smDelete.Enabled := false;
          smMove.Enabled := false;
          transform1.Enabled := false;
        end
        else
        begin
          // Return to the last row
          if next > ClientDataSet2.RecordCount then
            ClientDataSet2.Last
          else
            ClientDataSet2.RecNo := next;
          Selected := ClientDataSet2.FieldByName('#').AsInteger;
        end;
        form1.Listbox2.ItemIndex := selected;
      end;

      Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
      ClientDataSet1.EnableControls;
      ClientDataSet2.EnableControls;
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
      if (FloorObjID[Floor[sfloor].floorid].ids[FFilter, y] = ObjTemplate[x].data.Skin)
      or (ObjTemplate[x].data.Skin = 10000) or (ObjTemplate[x].data.Skin = 11000) then
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
    placerandom := false;
    placelookat := false;
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
    if form13.focused then
    begin
      MoveSel := -1;
      HideIndicator();
    end;
    LoadFloorGrids;
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
    placerandom := false;
    placelookat := false;
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
    if form13.focused then
    begin
      MoveSel := -1;
      HideIndicator();
    end;
    LoadFloorGrids;
  end;
end;

procedure TForm1.byGroup1Click(Sender: TObject);
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
      if Floor[sfloor].Obj[x].grp = v then
      begin
        move(Floor[sfloor].Obj[x], m[i], sizeof(TObj));
        inc(i);
      end;
    inc(v);
  end;
  move(m[0], Floor[sfloor].Obj[0], sizeof(TObj) * Floor[sfloor].ObjCount);
  CheckListBox1Click(Form1);
end;

procedure TForm1.byGroup2Click(Sender: TObject);
begin
  bygroup1Click(nil);
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

procedure TForm1.byRoom3Click(Sender: TObject);
begin
  byroom1Click(nil);
end;

procedure TForm1.byRoom4Click(Sender: TObject);
begin
  byroom2Click(nil);
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

procedure TForm1.byType3Click(Sender: TObject);
begin
  bytype1Click(nil);
end;

procedure TForm1.byType4Click(Sender: TObject);
begin
  bytype2Click(nil);
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

procedure TForm1.byWave2Click(Sender: TObject);
begin
  bywave1Click(nil);
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
  DBGrid1.Options := DBGrid1.Options - [dgMultiSelect];
  DBGrid2.Options := DBGrid2.Options - [dgMultiSelect];
end;

procedure TForm1.Image2Click(Sender: TObject);
var
  x, d, pz, i, z, y, j, k, l, closest, polyidx: integer;
  lastwarpx, lastwarpz, lastposx, lastposz: single;
  px, py, px2, py2, px3, py3, di, pz2, diff, diffmin: double;
  worldOffsetX, worldOffsetY: double;
  localOffsetX, localOffsetY: double;
  parentRot, parentScale: double;
  objsnap: Boolean;
  objsnapX, objsnapY: word;
begin
  if showgrid and editgrid then
    form1.GroupBox1.SetFocus;
  DBGrid1.Options := DBGrid1.Options - [dgMultiSelect];
  DBGrid2.Options := DBGrid2.Options - [dgMultiSelect];
  if MoveSel > -1 then
  begin
    snapvalue := FSnapOptions.seSnapTolerance.Value;
    distancelimit := FSnapOptions.seDistanceLimit.Value;
    if not placerandom then
      HideIndicator();
    // find the nearest zone
    // extract the real px, py
    SetUndow;
    if ctrldw then
    begin
      if MoveType = 1 then
      begin
        if not firstdrop then
        begin
          inc(Floor[sfloor].MonsterCount);
          if have3d then
          begin
            setlength(MyMonst, Floor[sfloor].MonsterCount);
            MyMonstCount := Floor[sfloor].MonsterCount;
            MyMonst[Floor[sfloor].MonsterCount - 1] := t3ditem.Create(myscreen);
          end;
          for x := 0 to sizeof(TMonster) - 1 do
            pansichar(@Floor[sfloor].Monster[Floor[sfloor].MonsterCount - 1])[x] :=
              pansichar(@Floor[sfloor].Monster[MoveSel])[x];
        end;
        ShowIndicator();
        MoveSel := Floor[sfloor].MonsterCount - 1;
      end;
      if MoveType = 2 then
      begin
        if not firstdrop then
        begin
          inc(Floor[sfloor].ObjCount);
          if have3d then
          begin
            setlength(MyObj, Floor[sfloor].ObjCount);
            MyObjCount := Floor[sfloor].ObjCount;
            MyObj[Floor[sfloor].ObjCount - 1] := nil;
          end;
          for x := 0 to sizeof(TObj) - 1 do
            pansichar(@Floor[sfloor].Obj[Floor[sfloor].ObjCount - 1])[x] := pansichar(@Floor[sfloor].Obj[MoveSel])[x];
        end;
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
    if (shiftdw and not placerandom) or (xdown or zdown) then
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
      if (MoveType = 2) and (Floor[sfloor].Obj[MoveSel].Skin = 11000) then
        d := 0;
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

    if placerandom then
    begin
      form15.LoadRandomData;
      AddRoomEntry(d, px, py, pz2);
      // Save data and redraw the map
      form15.SaveD04;
      DrawMap;
      exit;
    end;

    diffmin := Double.MaxValue;
    closest := -1;

    if MoveType = 1 then
    begin
      lastposx :=  Floor[sfloor].Monster[MoveSel].Pos_X;
      lastposz := Floor[sfloor].Monster[MoveSel].Pos_Y;
      Floor[sfloor].Monster[MoveSel].map_section := d;
      Floor[sfloor].Monster[MoveSel].Pos_X := px;
      Floor[sfloor].Monster[MoveSel].Pos_Y := py;
      // look around to find the best pz
      if not altdw or firstdrop then
        Floor[sfloor].Monster[MoveSel].Pos_Z := pz2;

      if (FSnapOptions.chkSnap.Checked) or (sdown) then // S key
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
                  // Save closest snap target
                  diff := abs(Floor[sfloor].Monster[MoveSel].Pos_Y - Floor[sfloor].Monster[j].Pos_Y);
                  if ((diff <= distancelimit) and (FSnapOptions.chkDistancelimit.Checked))
                  or (not FSnapOptions.chkDistancelimit.Checked) then
                  begin
                    Floor[sfloor].Monster[MoveSel].Pos_X := Floor[sfloor].Monster[j].Pos_X;
                    // Match monster's rotations if enabled
                    if FSnapOptions.chkSnapRotate.Checked then
                      Floor[sfloor].Monster[MoveSel].Direction := Floor[sfloor].Monster[j].Direction;
                    // Match monster's Y value if enabled
                    if FSnapOptions.chkSnapYValue.Checked and not altdw then
                      Floor[sfloor].Monster[MoveSel].Pos_Z := Floor[sfloor].Monster[j].Pos_Z;
                    if (diff < diffmin) and (j <> MoveSel) then
                    begin
                      diffmin := diff;
                      closest := j;
                    end;
                  end;
                end;
              end;
          end;
        end;
        if closest > -1 then
          AdjustDistanceY(closest);

        diffmin := Double.MaxValue;
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
                  // Save closest snap target
                  diff := abs(Floor[sfloor].Monster[MoveSel].Pos_X - Floor[sfloor].Monster[j].Pos_X);
                  if ((diff <= distancelimit) and (FSnapOptions.chkDistancelimit.Checked))
                  or (not FSnapOptions.chkDistancelimit.Checked) then
                  begin
                    Floor[sfloor].Monster[MoveSel].Pos_Y := Floor[sfloor].Monster[j].Pos_Y;
                    if FSnapOptions.chkSnapRotate.Checked then
                      Floor[sfloor].Monster[MoveSel].Direction := Floor[sfloor].Monster[j].Direction;
                    if FSnapOptions.chkSnapYValue.Checked and not altdw then
                      Floor[sfloor].Monster[MoveSel].Pos_Z := Floor[sfloor].Monster[j].Pos_Z;
                    if (diff < diffmin) and (j <> MoveSel) then
                    begin
                      diffmin := diff;
                      closest := j;
                    end;
                  end;
                end;
              end;
          end;
        end;
        if closest > -1 then
          AdjustDistanceX(closest);
      end;

      // Check for snap objects
      objsnap := false;
      polyidx := -1;
      for j := 0 to Floor[sfloor].ObjCount - 1 do
      begin
        // Check if this object is a snap polygon
        if Floor[sfloor].Obj[j].Skin = 10000 then
        begin
          px3 := px;
          py3 := py;
          polyidx := j;
          if TrySnapToPolygon(
            px3,
            py3,
            Floor[sfloor].Obj[j],
            Floor[sFloor].Obj[j].unknow9,
            Floor[sfloor].Monster[MoveSel].map_section
          ) then
          begin
            Floor[sfloor].Monster[MoveSel].Pos_X := px3;
            Floor[sfloor].Monster[MoveSel].Pos_Y := py3;
            // Update Y position
            if Floor[sFloor].Obj[j].unknow13 = 1 then
              Floor[sfloor].Monster[MoveSel].Pos_Z := Floor[sFloor].Obj[j].Pos_Z;
            if Floor[sFloor].Obj[j].Action = 1 then
              LookAt2D(selected, sType, SectionToMouseX(j,2), SectionToMouseY(j,2));

            // Save the parent ID
            Floor[sfloor].Monster[MoveSel].unknow4 := Floor[sfloor].Obj[j].id;

            // Calculate offset in world space
            worldOffsetX := Floor[sfloor].Monster[MoveSel].Pos_X - Floor[sfloor].Obj[j].Pos_X;
            worldOffsetY := Floor[sfloor].Monster[MoveSel].Pos_Y - Floor[sfloor].Obj[j].Pos_Y;

            // Transform to parent's local space
            parentRot := Floor[sfloor].Obj[j].unknow6 / 10430.37835;
            localOffsetX := cos(parentRot) * worldOffsetX - sin(parentRot) * worldOffsetY;
            localOffsetY := sin(parentRot) * worldOffsetX + cos(parentRot) * worldOffsetY;

            // Normalize by parent scale
            parentScale := Floor[sfloor].Obj[j].unknow8 * 20.0;
            if parentScale <> 0 then
            begin
              localOffsetX := localOffsetX / parentScale;
              localOffsetY := localOffsetY / parentScale;
            end;

            // Store as normalized offsets (multiply by 100 to preserve precision)
            Floor[sfloor].Monster[MoveSel].Unknow1 := word(SmallInt(round(localOffsetX * 100)));
            Floor[sfloor].Monster[MoveSel].Unknow2 := word(SmallInt(round(localOffsetY * 100))) +
                                                       (Floor[sfloor].Monster[MoveSel].Unknow2 and $ffff0000);
            objsnap := true;
          end;
        end;
      end;
      if (polyidx <> -1) and not objsnap and (Floor[sfloor].Monster[MoveSel].unknow4 = Floor[sfloor].Obj[polyidx].id) then
        Floor[sfloor].Monster[MoveSel].unknow4 := 0;

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

      // Revert values if the X or Z keys are pressed
      if (Selected > -1) and (zdown) then
        Floor[sfloor].Monster[MoveSel].Pos_X := lastposx
      else if (Selected > -1) and (xdown) then
        Floor[sfloor].Monster[MoveSel].Pos_Y := lastposz;

      if have3d then
      begin
        GenerateMonsterName(Floor[sfloor].Monster[MoveSel], MoveSel, 2);
      end;
      ListBox1Click(Form1);
    end;
    if MoveType = 2 then
    begin
      Floor[sfloor].Obj[MoveSel].map_section := d;
      lastposx :=  Floor[sfloor].Obj[MoveSel].Pos_X;
      lastposz := Floor[sfloor].Obj[MoveSel].Pos_Y;
      Floor[sfloor].Obj[MoveSel].Pos_X := px;
      Floor[sfloor].Obj[MoveSel].Pos_Y := py;
      if not altdw or firstdrop then
        Floor[sfloor].Obj[MoveSel].Pos_Z := pz2;

      if (FSnapOptions.chkSnap.Checked) or (sdown) then // S key
      begin
        // X axis snap for objects
        for j := 0 to Floor[sfloor].ObjCount - 1 do
        begin
          for i := 0 to snapvalue do
          begin
              // Make sure both are visible and sections are the same
              if (Floor[sfloor].Obj[j].map_section = Floor[sfloor].Obj[MoveSel].map_section) and
              ((Floor[sfloor].Obj[j].grp = showgrp) or (showgrp = -1)) then
              begin
                if ((round(Floor[sfloor].Obj[j].Pos_X + i)) = round(px))
                or ((round(Floor[sfloor].Obj[j].Pos_X - i)) = round(px)) then
                begin
                  // Save closest snap target
                  diff := abs(Floor[sfloor].Obj[MoveSel].Pos_Y - Floor[sfloor].Obj[j].Pos_Y);
                  if ((diff <= distancelimit) and (FSnapOptions.chkDistancelimit.Checked))
                  or (not FSnapOptions.chkDistancelimit.Checked) then
                  begin
                    Floor[sfloor].Obj[MoveSel].Pos_X := Floor[sfloor].Obj[j].Pos_X;
                    // Match object's rotations if enabled
                    if (FSnapOptions.chkSnapRotate.Checked) then
                    begin
                      for k := 0 to RotateCount - 1 do
                        if floor[sfloor].Obj[MoveSel].Skin = RotateItm[k] then
                          break;
                      if k >= RotateCount then
                        floor[sfloor].Obj[MoveSel].unknow6 := floor[sfloor].Obj[j].unknow6;
                      if (k < RotateCount) and (floor[sfloor].Obj[MoveSel].Skin = floor[sfloor].Obj[j].Skin) then
                      begin
                        floor[sfloor].Obj[MoveSel].unknow5 := floor[sfloor].Obj[j].unknow5;
                        floor[sfloor].Obj[MoveSel].unknow6 := floor[sfloor].Obj[j].unknow6;
                        floor[sfloor].Obj[MoveSel].unknow7 := floor[sfloor].Obj[j].unknow7;
                      end;
                    end;
                    // Match object's Y value if enabled
                    if FSnapOptions.chkSnapYValue.Checked and not altdw then
                      Floor[sfloor].Obj[MoveSel].Pos_Z := Floor[sfloor].Obj[j].Pos_Z;
                    if (diff < diffmin) and (j <> MoveSel) then
                    begin
                      diffmin := diff;
                      closest := j;
                    end;
                  end;
                end;
              end;
          end;
        end;
        if closest > -1 then
          AdjustDistanceY(closest);

        diffmin := Double.MaxValue;
        closest := -1;

        // Z axis snap for objects
        for j := 0 to Floor[sfloor].ObjCount - 1 do
        begin
          for i := 0 to snapvalue do
          begin
              // Make sure both are visible and sections are the same
              if (Floor[sfloor].Obj[j].map_section = Floor[sfloor].Obj[MoveSel].map_section) and
              ((Floor[sfloor].Obj[j].grp = showgrp) or (showgrp = -1)) then
              begin
                if ((round(Floor[sfloor].Obj[j].Pos_Y + i)) = round(py))
                or ((round(Floor[sfloor].Obj[j].Pos_Y - i)) = round(py)) then
                begin
                  // Save closest snap target
                  diff := abs(Floor[sfloor].Obj[MoveSel].Pos_X - Floor[sfloor].Obj[j].Pos_X);
                  if ((diff <= distancelimit) and (FSnapOptions.chkDistancelimit.Checked))
                  or (not FSnapOptions.chkDistancelimit.Checked) then
                  begin
                    Floor[sfloor].Obj[MoveSel].Pos_Y := Floor[sfloor].Obj[j].Pos_Y;
                    if (FSnapOptions.chkSnapRotate.Checked) then
                    begin
                      for k := 0 to RotateCount - 1 do
                        if floor[sfloor].Obj[MoveSel].Skin = RotateItm[k] then
                          break;
                      if k >= RotateCount then
                        floor[sfloor].Obj[MoveSel].unknow6 := floor[sfloor].Obj[j].unknow6;
                      if (k < RotateCount) and (floor[sfloor].Obj[MoveSel].Skin = floor[sfloor].Obj[j].Skin) then
                      begin
                        floor[sfloor].Obj[MoveSel].unknow5 := floor[sfloor].Obj[j].unknow5;
                        floor[sfloor].Obj[MoveSel].unknow6 := floor[sfloor].Obj[j].unknow6;
                        floor[sfloor].Obj[MoveSel].unknow7 := floor[sfloor].Obj[j].unknow7;
                      end;
                    end;
                    if FSnapOptions.chkSnapYValue.Checked and not altdw then
                      Floor[sfloor].Obj[MoveSel].Pos_Z := Floor[sfloor].Obj[j].Pos_Z;
                    if (diff < diffmin) and (j <> MoveSel) then
                    begin
                      diffmin := diff;
                      closest := j;
                    end;
                  end;
                end;
              end;
          end;
        end;
        if closest > -1 then
          AdjustDistanceX(closest);
      end;

      // Check for any snap objects
      objsnap := false;
      polyidx := -1;
      for j := 0 to Floor[sfloor].ObjCount - 1 do
      begin
        // Check if this object is a snap polygon
        if (Floor[sfloor].Obj[j].Skin = 10000) and (j <> MoveSel) then
        begin
          px3 := px;
          py3 := py;
          polyidx := j;
          if TrySnapToPolygon(
            px3,
            py3,
            Floor[sfloor].Obj[j],
            Floor[sFloor].Obj[j].unknow9,
            Floor[sfloor].Obj[MoveSel].map_section
          ) then
          begin
            Floor[sfloor].Obj[MoveSel].Pos_X := px3;
            Floor[sfloor].Obj[MoveSel].Pos_Y := py3;
            // Update Y position
            if Floor[sFloor].Obj[j].unknow13 = 1 then
              Floor[sfloor].Obj[MoveSel].Pos_Z := Floor[sFloor].Obj[j].Pos_Z;
            if Floor[sFloor].Obj[j].Action = 1 then
              LookAt2D(selected, sType, SectionToMouseX(j,2), SectionToMouseY(j,2));

            // Save the parent ID
            Floor[sfloor].Obj[MoveSel].id := Floor[sfloor].Obj[j].id;

            // Calculate offset in world space
            worldOffsetX := Floor[sfloor].Obj[MoveSel].Pos_X - Floor[sfloor].Obj[j].Pos_X;
            worldOffsetY := Floor[sfloor].Obj[MoveSel].Pos_Y - Floor[sfloor].Obj[j].Pos_Y;

            // Transform to parent's local space
            parentRot := Floor[sfloor].Obj[j].unknow6 / 10430.37835;
            localOffsetX := cos(parentRot) * worldOffsetX - sin(parentRot) * worldOffsetY;
            localOffsetY := sin(parentRot) * worldOffsetX + cos(parentRot) * worldOffsetY;

            // Normalize by parent scale
            parentScale := Floor[sfloor].Obj[j].unknow8 * 20.0;
            if parentScale <> 0 then
            begin
              localOffsetX := localOffsetX / parentScale;
              localOffsetY := localOffsetY / parentScale;
            end;

            // Store as normalized offsets (multiply by 100 to preserve precision)
            Floor[sfloor].Obj[MoveSel].Unknow1 := word(SmallInt(round(localOffsetX * 100)));
            Floor[sfloor].Obj[MoveSel].Unknow2 := word(SmallInt(round(localOffsetY * 100))) +
                                                   (Floor[sfloor].Obj[MoveSel].Unknow2 and $ffff0000);
            objsnap := true;
          end;
        end;
      end;
      if (polyidx <> -1) and (polyidx <> MoveSel) and not objsnap and (Floor[sfloor].Obj[MoveSel].id = Floor[sfloor].Obj[polyidx].id)
      then Floor[sfloor].Obj[MoveSel].id := 0;

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

      // Revert values if the X or Z keys are pressed
      if (Selected > -1) and (zdown) then
        Floor[sfloor].Obj[MoveSel].Pos_X := lastposx
      else if (Selected > -1) and (xdown) then
        Floor[sfloor].Obj[MoveSel].Pos_Y := lastposz;

      // Calculate warp offsets when moving to a new section
      if ((Floor[sfloor].Obj[MoveSel].Skin = 3) or (Floor[sfloor].Obj[MoveSel].Skin = 321) or (Floor[sfloor].Obj[MoveSel].Skin = 697))
      and not showdata then
      begin
        lastwarpx := Floor[sfloor].Obj[MoveSel].unknow8 + warpx;
        lastwarpz := Floor[sfloor].Obj[MoveSel].unknow10 + warpz;

        CalculateWarpOffsets(Floor[sfloor].Obj[MoveSel].unknow6 + rev[Floor[sfloor].Obj[MoveSel].map_section]);

        Floor[sfloor].Obj[MoveSel].unknow8 := lastwarpx - warpx;
        Floor[sfloor].Obj[MoveSel].unknow10 := lastwarpz - warpz;
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
    if ctrldw then
    begin
      // Form1.CheckListBox1Click(form1);
      if MoveType = 1 then
      begin
        ShowIndicator();
        MoveSel := Floor[sfloor].MonsterCount - 1;
        if not firstdrop then
          ListBox1.Items.Add('#' + inttostr(MoveSel) + ' - ' + GenerateMonsterName(Floor[sfloor].Monster[MoveSel],
            MoveSel, 0));
        Selected := MoveSel;
        LoadFloorGrids;
      end;
      if MoveType = 2 then
      begin
        ShowIndicator();
        MoveSel := Floor[sfloor].ObjCount - 1;
        if not firstdrop then
          ListBox2.Items.Add('#' + inttostr(MoveSel) + ' - ' + GetObjName(Floor[sfloor].Obj[MoveSel].Skin));
        Selected := MoveSel;
        LoadFloorGrids;
      end;
      DrawMap;
    end;
    firstdrop := false;
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

        if placelookat then
        begin
          if (mpcx >= round(px) - round(6 / Zoom)) and (mpcx <= round(px) + round(6 / Zoom)) and
          (mpcy >= round(py) - round(6 / Zoom)) and (mpcy <= round(py) + round(6 / Zoom)) then
          begin
            LookAt2D(selected, sType, px, py);
            exit;
          end;
        end;

        if (mpcx >= round(px) - round(6 / Zoom)) and (mpcx <= round(px) + round(6 / Zoom)) and
          (mpcy >= round(py) - round(6 / Zoom)) and (mpcy <= round(py) + round(6 / Zoom))
          and not smDrag.Checked and not placelookat then
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

        if placelookat then
        begin
          if (mpcx >= round(px) - round(6 / Zoom)) and (mpcx <= round(px) + round(6 / Zoom)) and
          (mpcy >= round(py) - round(6 / Zoom)) and (mpcy <= round(py) + round(6 / Zoom)) then
          begin
            LookAt2D(selected, sType, px, py);
            exit;
          end;
        end;

        if (mpcx >= round(px) - round(6 / Zoom)) and (mpcx <= round(px) + round(6 / Zoom)) and
          (mpcy >= round(py) - round(6 / Zoom)) and (mpcy <= round(py) + round(6 / Zoom))
          and not smDrag.Checked and not placelookat then
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
      if placelookat then
      begin
        LookAt2D(selected, sType, mpcx, mpcy);
        exit;
      end;
      if not smDrag.Checked then
        lastimgclick := gettickcount();
  end;
end;

procedure TForm1.btnRedoClick(Sender: TObject);
var
  x, s: integer;
begin
  s := selected;

  if redocount = 0 then
    exit;

  isedited := true;

  move(Floor[0], FloorUn[undocount], sizeof(TFloor) * 40);
  inc(undocount);
  dec(redocount);

  if redocount = 0 then
  begin
    btnRedo.Enabled := false;
    smRedo.Enabled := false;
  end;

  Button11.Enabled := true;
  smUndo.Enabled := true;

  move(FloorRedo[redocount], Floor[0], sizeof(TFloor) * 40);

  ctrldw := true;
  inundo := true;
  Form1.CheckListBox1Click(Form1);
  inundo := false;
  if s > -1 then
  begin
    if sType = 1 then
    begin
      if s < Form1.ListBox1.count then
      begin
        Selected := s;
        gridtype := 1;
        Form1.ListBox1.ItemIndex := s;
        Button2.Enabled := true;
        Button1.Enabled := true;
        Button3.Enabled := true;
        smEdit.Enabled := true;
        smDelete.Enabled := true;
        smMove.Enabled := true;
        transform1.Enabled := true;
      end;
    end;
    if sType = 2 then
    begin
      if s < Form1.ListBox2.count then
      begin
        Selected := s;
        gridtype := 2;
        Form1.ListBox2.ItemIndex := s;
        Button2.Enabled := true;
        Button1.Enabled := true;
        Button3.Enabled := true;
        smEdit.Enabled := true;
        smDelete.Enabled := true;
        smMove.Enabled := true;
        transform1.Enabled := true;
      end;
    end;
    LoadFloorGrids;
    DrawMap;
  end;

  ctrldw := false;
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

    if Floor[CheckListBox1.ItemIndex].Unknow[15] = $32 then
    begin
      form8.Memo2.Lines.Add('random_waves:');
      form8.Memo2.Lines.Add('');
      form8.Memo2.Lines.Add('');
    end;

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
      if Floor[CheckListBox1.ItemIndex].Unknow[15] = $32 then
        form8.Memo2.Lines.Add('    Mindelay: ' + inttostr(Floor[CheckListBox1.ItemIndex].Unknow[y + 12] +
          (Floor[CheckListBox1.ItemIndex].Unknow[y + 13] * 256)))
      else
        form8.Memo2.Lines.Add('    Delay: ' + inttostr(Floor[CheckListBox1.ItemIndex].Unknow[y + 12] +
          (Floor[CheckListBox1.ItemIndex].Unknow[y + 13] * 256)));

      if Floor[CheckListBox1.ItemIndex].Unknow[15] = $32 then
      begin
        form8.Memo2.Lines.Add('    Maxdelay: ' + inttostr(Floor[CheckListBox1.ItemIndex].Unknow[y + 14] +
          (Floor[CheckListBox1.ItemIndex].Unknow[y + 15] * 256)));
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
  s: string;
begin
  s:=GetLanguageString(79);
  if isedited then
  begin
    if MessageDlg(s, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
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
  if previewstate > 0 then
    ResetPreviewState;
  undocount := 0;
  redocount := 0;
  Button11.Enabled := false;
  smUndo.Enabled := false;
  btnRedo.Enabled := false;
  smRedo.Enabled := false;
  TrFnc.DeleteChildren;
  TrData.DeleteChildren;
  TrReg.DeleteChildren;
  Tropc.DeleteChildren;
  TsData.Clear;
  TsFnc.Clear;
  TsReg.Clear;
  Tsopc.Clear;
  fmScriptTE.txtNotes.Clear;
  fmScriptTE.BuildNoteLookup;
  for x := 0 to 30 do
  begin
    Floor[x].MonsterCount := 0;
    Floor[x].ObjCount := 0;
    Floor[x].UnknowCount := 0;
    CheckListBox1.Checked[x] := false;
    CheckListBox1.Items.Strings[x] := '';
  end;
  if not fmScriptTE.Visible then
  begin
    form4.ListBox1.Items.Clear;
    form4.ListBox1.Items.Add('0:      ret ')
  end
  else
  begin
    fmScriptTE.TextEdit.Lines.Clear;
    fmScriptTE.TextEdit.Lines.Add('0:      ret ');
    TextEdited := true;
  end;
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

  UpdateWindowTitle;
  ClientDataSet1.EmptyDataSet;
  ClientDataSet2.EmptyDataSet;
  DBGrid1.Options := DBGrid1.Options - [dgIndicator];
  DBGrid2.Options := DBGrid2.Options - [dgIndicator];
  Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
  DrawMap;
end;

procedure TForm1.Episode21Click(Sender: TObject);
var
  x: integer;
  s: string;
begin
  s:=GetLanguageString(79);
  if isedited then
  begin
    if MessageDlg(s, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
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
  if previewstate > 0 then
    ResetPreviewState;
  undocount := 0;
  redocount := 0;
  Button11.Enabled := false;
  smUndo.Enabled := false;
  btnRedo.Enabled := false;
  smRedo.Enabled := false;
  TrFnc.DeleteChildren;
  TrData.DeleteChildren;
  TrReg.DeleteChildren;
  Tropc.DeleteChildren;
  TsData.Clear;
  TsFnc.Clear;
  TsReg.Clear;
  Tsopc.Clear;
  fmScriptTE.txtNotes.Clear;
  fmScriptTE.BuildNoteLookup;
  for x := 0 to 30 do
  begin
    Floor[x].MonsterCount := 0;
    Floor[x].ObjCount := 0;
    Floor[x].UnknowCount := 0;
    CheckListBox1.Checked[x] := false;
    CheckListBox1.Items.Strings[x] := '';
  end;
  if not fmScriptTE.Visible then
  begin
    form4.ListBox1.Items.Clear;
    form4.ListBox1.Items.Add('0:      ' + getopcodename($F8BC) + ' 00000001');
    form4.ListBox1.Items.Add('        ret ')
  end
  else
  begin
    fmScriptTE.TextEdit.Lines.Clear;
    fmScriptTE.TextEdit.Lines.Add('0:      ' + getopcodename($F8BC) + ' 00000001');
    fmScriptTE.TextEdit.Lines.Add('        ret ');
    TextEdited := true;
  end;
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
  UpdateWindowTitle;
  ClientDataSet1.EmptyDataSet;
  ClientDataSet2.EmptyDataSet;
  DBGrid1.Options := DBGrid1.Options - [dgIndicator];
  DBGrid2.Options := DBGrid2.Options - [dgIndicator];
  Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
  DrawMap;
end;

procedure TForm1.Episode41Click(Sender: TObject);
var
  x: integer;
  s: string;
begin
  s:=GetLanguageString(79);
  if isedited then
  begin
    if MessageDlg(s, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
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
  if previewstate > 0 then
    ResetPreviewState;
  undocount := 0;
  redocount := 0;
  Button11.Enabled := false;
  smUndo.Enabled := false;
  btnRedo.Enabled := false;
  smRedo.Enabled := false;
  TrFnc.DeleteChildren;
  TrData.DeleteChildren;
  TrReg.DeleteChildren;
  Tropc.DeleteChildren;
  TsData.Clear;
  TsFnc.Clear;
  TsReg.Clear;
  Tsopc.Clear;
  fmScriptTE.txtNotes.Clear;
  fmScriptTE.BuildNoteLookup;
  for x := 0 to 30 do
  begin
    Floor[x].MonsterCount := 0;
    Floor[x].ObjCount := 0;
    Floor[x].UnknowCount := 0;
    CheckListBox1.Checked[x] := false;
    CheckListBox1.Items.Strings[x] := '';
  end;
  if not fmScriptTE.Visible then
  begin
    form4.ListBox1.Items.Clear;
    form4.ListBox1.Items.Add('0:      ' + getopcodename($F8BC) + ' 00000002');
    form4.ListBox1.Items.Add('        ret ')
  end
  else
  begin
    fmScriptTE.TextEdit.Lines.Clear;
    fmScriptTE.TextEdit.Lines.Add('0:      ' + getopcodename($F8BC) + ' 00000002');
    fmScriptTE.TextEdit.Lines.Add('        ret ');
    TextEdited := true;
  end;
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
  UpdateWindowTitle;
  ClientDataSet1.EmptyDataSet;
  ClientDataSet2.EmptyDataSet;
  DBGrid1.Options := DBGrid1.Options - [dgIndicator];
  DBGrid2.Options := DBGrid2.Options - [dgIndicator];
  Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
  DrawMap;
end;

procedure TForm1.Button11Click(Sender: TObject);
var
  x, s: integer;
begin
  s := selected;
  if undocount = 0 then
    exit;
  move(Floor[0], FloorRedo[redocount], sizeof(TFloor) * 40);
  inc(redocount);
  dec(undocount);
  if undocount = 0 then
  begin
    Button11.Enabled := false;
    smUndo.Enabled := false;
  end;
  btnRedo.Enabled := true;
  smRedo.Enabled := true;
  isedited := true;
  move(FloorUn[undocount], Floor[0], sizeof(TFloor) * 40);
  ctrldw := true;
  inundo := true;
  Form1.CheckListBox1Click(Form1);
  inundo := false;
  if s > -1 then
  begin
    if sType = 1 then
    begin
      if s < Form1.ListBox1.count then
      begin
        Selected := s;
        gridtype := 1;
        Form1.ListBox1.ItemIndex := s;
        Button2.Enabled := true;
        Button1.Enabled := true;
        Button3.Enabled := true;
        smEdit.Enabled := true;
        smDelete.Enabled := true;
        smMove.Enabled := true;
        transform1.Enabled := true;
      end;
    end;
    if sType = 2 then
    begin
      if s < Form1.ListBox2.count then
      begin
        Selected := s;
        gridtype := 2;
        Form1.ListBox2.ItemIndex := s;
        Button2.Enabled := true;
        Button1.Enabled := true;
        Button3.Enabled := true;
        smEdit.Enabled := true;
        smDelete.Enabled := true;
        smMove.Enabled := true;
        transform1.Enabled := true;
      end;
    end;
    LoadFloorGrids;
    DrawMap;
  end;

  ctrldw := false;
end;

procedure TForm1.SetUndow();
var
  x: integer;
  unchanged: Boolean;
begin
  redocount := 0;
  btnRedo.Enabled := false;
  smRedo.Enabled := false;

  unchanged := true;
  if undocount > 0 then
    unchanged := CompareMem(@Floor[0], @FloorUn[undocount], sizeof(TFloor) * 40);
  if not unchanged or (undocount = 0) then
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
end;

function TForm1.PartialSearch(strings: TStrings; const substr: string): integer;
var
  idx: integer;
  sortedIndices: TList<integer>;
begin
  // Default; not found
  result := -1;

  // Create a list of indices
  sortedIndices := TList<integer>.Create;
  try
    for idx := 0 to strings.Count - 1 do
      sortedIndices.Add(idx);

    // Sort indices by string length
    sortedIndices.Sort(TComparer<integer>.Construct(
      function(const Left, Right: integer): integer
      begin
        result := strings[Left].Length - strings[Right].Length;
      end
    ));

    // Search in order of length
    for idx in sortedIndices do
    begin
      if ContainsText(strings[idx], substr) then
      begin
        result := idx;
        exit;
      end;
    end;
  finally
    sortedIndices.Free;
  end;
end;

procedure TForm1.Showbitmapoverlays1Click(Sender: TObject);
begin
  showbmpclick(nil);
end;

procedure TForm1.MapRenderWireframe1Click(Sender: TObject);
begin
  mapRenderMode := 0;
  MapRenderWireframe1.Checked := True;
  MapRenderTopographic1.Checked := False;
  // Wireframe colors triangles per-flag, not by height — Height shading
  // has no effect here, so disable the menu item to make that explicit.
  MapRenderHeightShading1.Enabled := False;
  BBRelFileName := ''; // force reload
  cachedOutlineFor := ''; cachedOutlineCount := 0;
  DrawMap;
end;

procedure TForm1.MapRenderTopographic1Click(Sender: TObject);
begin
  mapRenderMode := 1;
  MapRenderWireframe1.Checked := False;
  MapRenderTopographic1.Checked := True;
  MapRenderHeightShading1.Enabled := True;
  BBRelFileName := ''; // force reload
  cachedOutlineFor := ''; cachedOutlineCount := 0;
  DrawMap;
end;

procedure TForm1.MapRenderHeightShading1Click(Sender: TObject);
begin
  topoHeightShading := not topoHeightShading;
  MapRenderHeightShading1.Checked := topoHeightShading;
  DrawMap;
end;

procedure TForm1.SetTopCollapsed(collapsed: Boolean);
// Compute every position from design constants scaled by current monitor DPI.
// No reliance on cached runtime state — robust against any prior layout.
const
  designShift          = 220;
  designTopLabel4      = 228;
  designTopLabel5      = 226;
  designTopLabel6      = 228;
  designTopLabel7      = 250;
  designTopButton5     = 226;
  designTopButton6     = 226;
  designTopCheckBox1   = 226;
  designTopComboBox1   = 266;
  designTopButton9     = 302;
  designTopButton4     = 326;
  designTopButton3     = 356;
  designTopButton2     = 386;
  designTopButton1     = 410;
  designTopBtnCollapse = 226;
  designTopPanel2      = 244;
  designPanel2BottomMargin = 506 - (244 + 240); // 22 px from form bottom
var
  panel2BottomPx, newPanel2TopPx: integer;
  function S(designVal: integer): integer;
  begin
    Result := MulDiv(designVal, Self.PixelsPerInch, 96);
  end;
begin
  if collapsed = topCollapsed then exit;

  panel2BottomPx := ClientHeight - S(designPanel2BottomMargin);
  if collapsed then
    newPanel2TopPx := S(designTopPanel2 - designShift)
  else
    newPanel2TopPx := S(designTopPanel2);

  Label2.Visible := not collapsed;
  Label3.Visible := not collapsed;
  PageControl1.Visible := not collapsed;
  ListBox1.Visible := not collapsed;
  ListBox2.Visible := not collapsed;
  Panel1.Visible := not collapsed;

  if collapsed then
  begin
    Label4.Top         := S(designTopLabel4      - designShift);
    Label5.Top         := S(designTopLabel5      - designShift);
    Label6.Top         := S(designTopLabel6      - designShift);
    Label7.Top         := S(designTopLabel7      - designShift);
    Button5.Top        := S(designTopButton5     - designShift);
    Button6.Top        := S(designTopButton6     - designShift);
    CheckBox1.Top      := S(designTopCheckBox1   - designShift);
    ComboBox1.Top      := S(designTopComboBox1   - designShift);
    Button9.Top        := S(designTopButton9     - designShift);
    Button4.Top        := S(designTopButton4     - designShift);
    Button3.Top        := S(designTopButton3     - designShift);
    Button2.Top        := S(designTopButton2     - designShift);
    Button1.Top        := S(designTopButton1     - designShift);
    btnCollapseTop.Top := S(designTopBtnCollapse - designShift);
  end
  else
  begin
    Label4.Top         := S(designTopLabel4);
    Label5.Top         := S(designTopLabel5);
    Label6.Top         := S(designTopLabel6);
    Label7.Top         := S(designTopLabel7);
    Button5.Top        := S(designTopButton5);
    Button6.Top        := S(designTopButton6);
    CheckBox1.Top      := S(designTopCheckBox1);
    ComboBox1.Top      := S(designTopComboBox1);
    Button9.Top        := S(designTopButton9);
    Button4.Top        := S(designTopButton4);
    Button3.Top        := S(designTopButton3);
    Button2.Top        := S(designTopButton2);
    Button1.Top        := S(designTopButton1);
    btnCollapseTop.Top := S(designTopBtnCollapse);
  end;

  Panel2.SetBounds(Panel2.Left, newPanel2TopPx,
                   Panel2.Width, panel2BottomPx - newPanel2TopPx);

  topCollapsed := collapsed;
  if collapsed then
    btnCollapseTop.Caption := #9660 // black down arrow — click to expand
  else
    btnCollapseTop.Caption := #9650; // black up arrow — click to collapse

  DrawMap;
end;

procedure TForm1.btnCollapseTopClick(Sender: TObject);
var
  Reg: TRegistry;
begin
  SetTopCollapsed(not topCollapsed);
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\schthack\qedit', true) then
    begin
      Reg.WriteBool('TopCollapsed', topCollapsed);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TForm1.showbmpClick(Sender: TObject);
var
  x: integer;
  t: single;
  Reg: TRegistry;
begin
  showbmp.Checked := not showbmp.Checked;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
  if Reg.OpenKey('\Software\Microsoft\schthack\qedit', true) then
  begin
    Reg.WriteBool('ShowBMP', showbmp.Checked);
    Reg.CloseKey;
  end;
  finally
    Reg.Free;
  end;
  if showbmp.Checked then
  begin
    // Create the folder if it doesn't exist
    if not directoryexists(path + 'img') then
      CreateDir(path + 'img');

    form14.Caption := GetLanguageString(506);
    form14.Label1.Hide;
    form14.ProgressBar1.max := preseti - 1;
    // Generate new object bitmaps if they don't exist
    for x := 0 to preseti - 1 do
    begin
      form14.ProgressBar1.Position := x;
      form14.Repaint;
      if not fileexists(path + 'img\i' + inttohex(ObjTemplate[x].data.Skin, 2) + '.bmp') then
      begin
        form14.Show;
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
          Generateobj(ObjTemplate[x].data, -2);
          if objitm.Color and $FFFFFF = $FFFFFF then
            objitm.Color := $FEFEFE;
          objitm.Visible := true;
          t := objitm.GetLargessVertex;
          objscreen.LookAt(0, t, -(t * 1.7), 0, t / 2, 0);
          objitm.SetRotation(15, 0, 0);
          objscreen.RenderSurface;
          objscreen.GetBitmap(selectionBMP);
          selectionBMP.SaveToFile(path + 'img\i' + inttohex(ObjTemplate[x].data.Skin, 2) + '.bmp');
        end
      end;
    end;
  end;
  Drawmap;
  form14.Hide;
  form14.Caption := GetLanguageString(260);
  form14.ProgressBar1.Position := 1;
  form14.Label1.Show;
end;

procedure TForm1.Smallfont1Click(Sender: TObject);
begin
  SetCoordSize(0);
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
    LoadFloorGrids;
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

procedure TForm1.InvertYrotation1Click(Sender: TObject);
begin
  if selected > -1 then
  begin
    SetUndow;
    isedited := true;
    if sType = 1 then
    begin
      Floor[sFloor].Monster[selected].Direction :=
      Floor[sFloor].Monster[selected].Direction + 32768;
      Floor[sFloor].Monster[selected].Direction :=
      Floor[sFloor].Monster[selected].Direction mod 65536;

      if have3d then
        GenerateMonsterName(Floor[sfloor].Monster[selected],selected,2);
    end;
    if sType = 2 then
    begin
      Floor[sFloor].Obj[selected].unknow6 :=
      Floor[sFloor].Obj[selected].unknow6 + 32768;
      Floor[sFloor].Obj[selected].unknow6 :=
      Floor[sFloor].Obj[selected].unknow6 mod 65536;

      if have3d then
      begin
         myobj[selected].Free;
         Generateobj(Floor[sfloor].obj[selected],selected);
      end;
    end;
    DrawMap;
    LoadFloorGrids;
  end;
end;

procedure TForm1.InvertYrotation2Click(Sender: TObject);
begin
  InvertYrotation1Click(nil);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  s: ansistring;
begin
  // MenueDrawItemX(form1.MainMenu1);
  have3d := false;
  MoveSel := -1;
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
  if key = 88 then
    xdown := true;
  if key = 90 then
    zdown := true;
  if (key = 37) and (previewstate > 0) then
  begin
    key := 0;
    previewpaused := true;
    if previewstate > 1 then
    begin
      Dec(previewstate);
      DrawPreviewState(previewstate);
    end;
  end;
  if (key = 39) and (previewstate > 0) then
  begin
    key := 0;
    previewpaused := true;
    if previewstate < Floor[CheckListBox1.ItemIndex].Unknow[8] then
    begin
      Inc(previewstate);
      DrawPreviewState(previewstate);
    end;
  end;
  if (key = 32) and (previewstate > 0) then
  begin
    key := 0;
    previewpaused := not previewpaused;
    DrawMap;
  end;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = ' ') and (previewstate > 0) then
    key := #0;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  ddown := false;
  fdown := false;
  sdown := false;
  xdown := false;
  zdown := false;
end;

procedure TForm1.DrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
begin
  MenueDrawItem(Sender, ACanvas, ARect, Selected);
end;

procedure TForm1.Mediumfont1Click(Sender: TObject);
begin
  SetCoordSIze(1);
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

procedure TForm1.MirrorXposition1Click(Sender: TObject);
begin
  if selected > -1 then
  begin
    SetUndow;
    isedited := true;
    if sType = 1 then
    begin
      Floor[sFloor].Monster[selected].Pos_X :=
      -Floor[sFloor].Monster[selected].Pos_X;

      if have3d then
        GenerateMonsterName(Floor[sfloor].Monster[selected],selected,2);
    end;
    if sType = 2 then
    begin
      Floor[sFloor].Obj[selected].Pos_X :=
      -Floor[sFloor].Obj[selected].Pos_X;

      if have3d then
      begin
         myobj[selected].Free;
         Generateobj(Floor[sfloor].obj[selected],selected);
      end;
    end;
    DrawMap;
    LoadFloorGrids;
  end;
end;

procedure TForm1.MirrorZposition1Click(Sender: TObject);
begin
  if selected > -1 then
  begin
    SetUndow;
    isedited := true;
    if sType = 1 then
    begin
      Floor[sFloor].Monster[selected].Pos_Y :=
      -Floor[sFloor].Monster[selected].Pos_Y;

      if have3d then
        GenerateMonsterName(Floor[sfloor].Monster[selected],selected,2);
    end;
    if sType = 2 then
    begin
      Floor[sFloor].Obj[selected].Pos_Y :=
      -Floor[sFloor].Obj[selected].Pos_Y;

      if have3d then
      begin
         myobj[selected].Free;
         Generateobj(Floor[sfloor].obj[selected],selected);
      end;
    end;
    DrawMap;
    LoadFloorGrids;
  end;
end;

procedure TForm1.MirrorZposition2Click(Sender: TObject);
begin
  MirrorZposition1Click(nil);
end;

procedure TForm1.Monstercount1Click(Sender: TObject);
begin
  form31.ShowModal;
end;

procedure TForm1.Move1Click(Sender: TObject);
begin
  if not (Screen.ActiveForm = fmScriptTE) then
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

procedure TForm1.Width3Click(Sender: TObject);
begin
  SetOutlineWidth(3);
end;

procedure TForm1.Newitem1Click(Sender: TObject);
begin
  Button4Click(nil);
end;

procedure TForm1.Newmonster1Click(Sender: TObject);
begin
  if fmScriptTE.Focused then
    fmScriptTE.Notes1Click(nil)
  else Button9Click(nil);
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
end;

procedure TForm1.smRedoClick(Sender: TObject);
begin
  btnRedoClick(nil);
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

procedure TForm1.smUndoClick(Sender: TObject);
begin
  Button11Click(nil);
end;

procedure TForm1.smSnapOptionsClick(Sender: TObject);
begin
  FSnapOptions.Showmodal;
  // Update based on snap preferences
  snapvalue := FSnapOptions.seSnapTolerance.Value;
  snaprotate := FSnapOptions.chkSnapRotate.Checked;
  snapyvalue := FSnapOptions.chkSnapYValue.Checked;
  snapdistance := FSnapOptions.chkSnapDistance.Checked;
end;

procedure TForm1.SnapOptions2Click(Sender: TObject);
begin
  smSnapOptionsClick(nil);
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
  x, int, i, y, z, offset: integer;
  flt: Single;
begin
  move(Floor[sfloor].d05[0], y, 4);
  move(Floor[sfloor].d05[8], z, 4);
  if z = 0 then
    form15.StringGrid1.RowCount := 1
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
    form15.StringGrid2.RowCount := 1
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
  move(Floor[sfloor].d04[4], i, 4);
  move(Floor[sfloor].d04[8], z, 4);
  move(Floor[sfloor].d04[y+4], offset, 4);
  inc(i, offset);
  form15.ListBox1.Clear;
  SetLength(roomdata, z+1);
  for x := 1 to z do
  begin
    move(Floor[sfloor].d04[y], int, 4);
    // Store room data
    roomdata[x].roomnum := int and $FFFF;
    roomdata[x].numentries := int div $10000;
    SetLength(roomdata[x].data, roomdata[x].numentries * 28);
    move(Floor[sfloor].d04[i], roomdata[x].data[0], roomdata[x].numentries * 28);

    form15.ListBox1.Items.Add(inttostr(int and $FFFF) + ' (' + inttostr(int div $10000) + GetLanguageString(82));
    inc(y, 8);
    inc(i, roomdata[x].numentries * 28);
  end;
  if z > 0 then
  begin
    form15.ListBox1.Selected[0] := true;
    form15.ListBox1.ItemIndex := 0;
    form15.ListBox1Click(Form1);
  end
  else form15.StringGrid3.RowCount := 0;
  if Sender <> Button14 then
    form15.ShowModal;
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
  form33.Show;
end;

procedure TForm1.Button14Click(Sender: TObject);
begin
  fmRotation.Showmodal;
  if fmRotation.modalresult = 1 then
  begin
    placerandom := true;
    lblStatus.Caption := GetLanguageString(434);
    if not Form1.smDisableIndicator.Checked then
      lblStatus.Show;
    lblModifiers.Hide;
    MoveType := 0;
    MoveSel := 0;
  end;
end;

procedure TForm1.Button15Click(Sender: TObject);
var
  idx: integer;
  Reg: TRegistry;
  selectedstyle: string;
begin
  fmThemes.ShowModal;
  if fmThemes.modalresult = 1 then
  begin
    idx := fmThemes.ComboBox1.ItemIndex;
    selectedstyle := fmThemes.ComboBox1.Items[idx];
    if selectedstyle = 'Windows (Default)' then selectedstyle := 'Windows';
    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey('\Software\Microsoft\schthack\qedit', true) then
      begin
        Reg.WriteInteger('MainTheme', idx);
        // Reset the marker brightness if switching between dark and light mode
        if (darkmode and (TStyleManager.Style[selectedstyle].GetStyleColor(scListBox) = clWhite))
        or (not darkmode and (TStyleManager.Style[selectedstyle].GetStyleColor(scListBox) <> clWhite))
        or (darkmode and (selectedstyle = 'Windows')) then
          Reg.WriteInteger('MarkerBrightness', 0);
        Reg.CloseKey;
      end;
    finally
      Reg.Free;
    end;
    if selectedstyle <> TStyleManager.ActiveStyle.Name then
    begin
      if MessageDlg(GetLanguageString(438),
      mtConfirmation, [mbYes, mbNo], 0) = mrYes
      then
      begin
        form1.Close;
        if form1.ClosedSuccessfully then
        begin
          ShellExecute(0, 'open', PChar(ParamStr(0)), nil,
          PChar(ExtractFilePath(ParamStr(0))),
          SW_SHOWNORMAL);
        end;
      end;
    end;
  end;
end;

procedure TForm1.About1Click(Sender: TObject);
begin
  form16.ShowModal;
end;

procedure TForm1.Width2Click(Sender: TObject);
begin
  SetOutlineWidth(2);
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

procedure TForm1.Lists1Click(Sender: TObject);
var
  Reg: TRegistry;
begin
  showgrid := false;
  HideGrids;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\schthack\qedit', true) then
    begin
      Reg.WriteBool('ShowGrid', false);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TForm1.Itemslistbb1Click(Sender: TObject);
var
  i, x: integer;
begin
  for x := 0 to 63 do
    for i := 0 to 13 do
      form19.StringGrid1.Cells[i, x + 1] := inttohex(BBData[(x * 14) + i + 36], 8);
  form19.ShowModal;
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
   if Form4.edit1.Focused then
    Form4.edit1.CutToClipboard
   else if fmScriptTE.TextEdit.Focused then
    fmScriptTE.TextEdit.CutToClipboard
   else if fmScriptTE.Edit2.Focused then
    fmScriptTE.Edit2.CutToClipboard
   else if fmScriptTE.txtNotes.Focused then
    fmScriptTE.txtNotes.CutToClipboard
   else if (have3d) and (form13.BorderStyle = bsNone) and (not form13.Focused) then
    Form1.WindowState := wsMinimized
   else if (have3d) and (form13.BorderStyle = bsNone) and (form13.Focused) then
   begin
    Form1.WindowState := wsNormal;
    Form1.BringToFront;
    if form4.Visible then form4.BringToFront;
    if fmScriptTE.Visible then fmScriptTE.BringToFront;
   end;
end;

procedure TForm1.High1Click(Sender: TObject);
begin
  SetBrightness(1);
end;

procedure TForm1.Hotkeys1Click(Sender: TObject);
begin
  fmHotkeys.ShowModal;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DBGrid1.Options := DBGrid1.Options - [dgMultiSelect];
  DBGrid2.Options := DBGrid2.Options - [dgMultiSelect];
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbRight) and (mdown = 0) then
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
  if previewstate = 0 then
  begin
    EnemyWave1.Enabled := true;
    tm := TMenuItem.Create(EnemyWave1);
    tm.Caption := GetLanguageString(83);
    tm.RadioItem := true;
    if showwave = -1 then tm.Checked := true;
    tm.tag := -1;
    tm.OnClick := EnemyWave1Click;
    EnemyWave1.Add(tm);
    y := CountNumberOfWave;
    for x := 0 to y do
    begin
      tm := TMenuItem.Create(EnemyWave1);
      tm.Caption := GetLanguageString(84) + inttostr(x);
      tm.RadioItem := true;
      if x = showwave then tm.Checked := true;
      tm.tag := x;
      tm.OnClick := EnemyWave1Click;
      if (x > 0) and (x mod 20 = 19) then
        tm.Break := mbBarBreak;
      EnemyWave1.Add(tm);
    end;
    tm := TMenuItem.Create(EnemyWave1);
    tm.Caption := GetLanguageString(514);
    tm.RadioItem := true;
    if showwave = 65536 then tm.Checked := true;
    tm.tag := 65536;
    tm.OnClick := EnemyWave1Click;
    if (x > 0) and (x mod 20 = 19) then
        tm.Break := mbBarBreak;
    EnemyWave1.Add(tm);
  end
  else EnemyWave1.Enabled := false;


  Itemsgroupe1.Clear;
  tm := TMenuItem.Create(Itemsgroupe1);
  tm.Caption := GetLanguageString(83);
  tm.RadioItem := true;
  if showgrp = -1 then tm.Checked := true;
  tm.tag := -1;
  tm.OnClick := Itemsgroupe1Click;
  Itemsgroupe1.Add(tm);
  y := CountNumberOfGrp;
  for x := 0 to y do
  begin
    tm := TMenuItem.Create(Itemsgroupe1);
    tm.Caption := GetLanguageString(85) + inttostr(x);
    tm.RadioItem := true;
    if x = showgrp then tm.Checked := true;
    tm.tag := x;
    tm.OnClick := Itemsgroupe1Click;
    if (x > 0) and (x mod 20 = 19) then
      tm.Break := mbBarBreak;
    Itemsgroupe1.Add(tm);
  end;
  tm := TMenuItem.Create(Itemsgroupe1);
  tm.Caption := GetLanguageString(514);
  tm.RadioItem := true;
  if showgrp = 65536 then tm.Checked := true;
  tm.tag := 65536;
  tm.OnClick := Itemsgroupe1Click;
  if (x > 0) and (x mod 20 = 19) then
        tm.Break := mbBarBreak;
  Itemsgroupe1.Add(tm);
end;

procedure TForm1.Edit1Click(Sender: TObject);
begin
  Button2Click(nil);
end;

procedure TForm1.Edit2Click(Sender: TObject);
begin
  Celledit1Click(nil);
end;

procedure TForm1.EnemyWave1Click(Sender: TObject);
var
  x: integer;
begin
  showwave := TMenuItem(Sender).tag;
  DrawMap;
  if have3d then
  begin
    if previewstate > 0 then
    begin
      for x := 0 to Floor[sfloor].MonsterCount - 1 do
        if (Floor[sfloor].Monster[x].Unknow5 = showwave)
        and (Floor[sfloor].Monster[x].map_section = prevsection)
        then
          MyMonst[x].Visible := true
        else
          MyMonst[x].Visible := false;
    end
    else
    begin
      for x := 0 to Floor[sfloor].MonsterCount - 1 do
        if (Floor[sfloor].Monster[x].Unknow5 = showwave) or (showwave = -1) then
          MyMonst[x].Visible := true
        else
          MyMonst[x].Visible := false;
    end;
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

procedure TForm1.FormActivate(Sender: TObject);
begin
  LoadFloorGrids;
  if showgrid then
    form1.Switchgridtab1.Enabled := true;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Reg: TRegistry;
  flp: TMemoryStream;
  s: string;
begin
  FClosedSuccessfully := False;
  s:=GetLanguageString(55);
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
    if MessageDlg(s, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      Form1.Save1Click(Form1);
      if isedited then
      begin
        Action := caNone;
        FClosedSuccessfully := False;
        exit;
      end;
    end;
  end;
  if have3d then
    myscreen.Free3d;
  if objscreen <> nil then
    objscreen.Free3d;
  ClearShadow;
  FClosedSuccessfully := True;
  // Free the BMP cache
  ClearBMPCache;
  selectionBMP.Free;
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
  x, y, i, c, l, ep, k, d, evt, evtcount, offset: integer;
  s, cmd, b: ansistring;
  mfound: Boolean;
  Rect: TRect;
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
            errors.Add(GetLanguageString(457) + inttostr(x));
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
          errors.Add(GetLanguageString(456) + inttostr(x));
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
      // Check random monster entries
      if ver > 0 then
      begin
        sFloor := x;
        form15.LoadRandomData;
        sFloor := form1.CheckListBox1.ItemIndex;
        // Room data
        if Floor[x].d04count > 0 then
        begin
          for i := 0 to length(roomdata) - 1 do
          begin
            if roomdata[i].numentries > 32 then
              warn.Add(GetLanguageString(458) + inttostr(x)
              + GetLanguageString(459)
              + inttostr(roomdata[i].roomnum)
              + GetLanguageString(460));
          end;
        end;
        // Config data
        if Floor[x].d05count > 0 then
        begin
          for i := 1 to form15.StringGrid2.RowCount - 1 do
          begin
            if strtointdef(form15.StringGrid2.Cells[3,i],-1) <= 0 then
              warn.Add(GetLanguageString(461) + inttostr(i)
              + GetLanguageString(463)
              + inttostr(x));
            for y := 1 to form15.StringGrid1.RowCount - 1 do
              if strtointdef(form15.StringGrid2.Cells[2,i],-1) =
              strtointdef(form15.StringGrid1.Cells[8,y],-2) then break;
            if y >= form15.StringGrid1.RowCount then
              warn.Add(GetLanguageString(462) + inttostr(i)
              + GetLanguageString(463)
              + inttostr(x));
          end;
        end;
      end;
      move(Floor[x].Unknow[8], evtcount, 4);
      for y := 0 to Floor[x].MonsterCount - 1 do
      begin
        // Check that the monster is part of a map event on the floor
        if (Floor[x].Unknow[15] <> $32) and (evtcount > 0) and
        (not IsNPC(Floor[x].Monster[y])) then
        begin
          offset := 16;
          mfound := false;
          for evt := 1 to evtcount do
          begin
            if (Floor[x].Monster[y].map_section = (Floor[x].Unknow[offset + 8] +
                Floor[x].Unknow[offset + 9] * 256)) and
                (Floor[x].Monster[y].unknow5 = (Floor[x].Unknow[offset + 10] +
                Floor[x].Unknow[offset + 11] * 256))
            then
            begin
              mfound := true;
              break;
            end;
            inc(offset, 20);
          end;
          if not mfound then
            warn.add(GetLanguageString(503) + inttostr(y) + GetLanguageString(504) + inttostr(x));
        end;
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
              begin
                warn.Add(GetLanguageString(96) + ' ' + inttostr(round(Floor[x].Monster[y].Action)) +
                  GetLanguageString(97) + inttostr(y) + GetLanguageString(98) + ' ' + inttostr(x));
                // Enable compatibility check extra buttons
                unusedlabel := true;
              end;
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
          if (i = FloorObjID[Floor[x].floorid].count[ver]) and (FloorObjID[Floor[x].floorid].count[ver] <> 0)
          and (Floor[x].Obj[y].Skin <> 10000) and (Floor[x].Obj[y].Skin <> 11000) then
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
  if fmScriptTE.Visible then
    form4.Show;
  unusedlabel := false;
  TestCompatibility(0, form27.er[0], form27.wa[0]);
  TestCompatibility(1, form27.er[1], form27.wa[1]);
  form27.er[2] := form27.er[1];
  form27.wa[2] := form27.wa[1];
  TestCompatibility(2, form27.er[3], form27.wa[3]);
  TestCompatibility(3, form27.er[4], form27.wa[4]);
  // Keep the current index if it's a refresh
  if Sender <> form27 then
    form27.ListBox1.ItemIndex := 0;
  form27.ListBox1Click(form27);
  if Sender <> form27 then
  begin
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
    tm.RadioItem := true;
    if mapfile[CheckListBox1.ItemIndex] = path + 'map\' + mapfilename[mapid[Floor[CheckListBox1.ItemIndex].floorid] + x-1] then
      tm.Checked := true;
    tm.Caption := GetLanguageString(111) + ' ' + inttostr(x);
    tm.OnClick := Layout11Click;
    PopupMenu2.Items.Add(tm);
  end;
end;

procedure TForm1.Previewevents1Click(Sender: TObject);
var
  x, zoomsteps: integer;
  scale: double;
begin
  if Floor[CheckListBox1.ItemIndex].Unknow[8] > 0 then
  begin
    // Set up the map and save the previous state
    prevwave := showwave;
    prevgroup := showgrp;
    prevmwave := form9.SpinEdit1.Value;
    prevroomID := form1.ComboBox1.ItemIndex;
    prevx := mpx;
    prevy := mpy;
    prevppx := ppx;
    prevppy := ppy;
    prevppz := ppz;
    prevvr := vr;
    prevvz := vz;
    prevzoom := zoom;

    // Set starting zoom based on map size
    scale := Min(Image2.Width, Image2.Height) / 213;
    zoomsteps := Round(Sqrt(scale) * 6);
    zoom := 5.0;
      for x := 1 to zoomsteps do
        Button6Click(nil);

    // Set the starting state and start the timer
    previewpaused := false;
    previewstate := 1;
    DrawPreviewState(previewstate);
    tmPreview.Enabled := False;
    tmPreview.Interval := tmPreview.Interval;
    tmPreview.Enabled := True;
    lblPreview.Show;
  end;
end;

procedure TForm1.Label5MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    if (Button = mbRight) and (mdown = 0) then
      PopupMenu4.Popup(mouse.CursorPos.x, mouse.CursorPos.y);
end;

procedure TForm1.Largefont1Click(Sender: TObject);
begin
  SetCoordSize(2);
end;

procedure TForm1.Layout11Click(Sender: TObject);
var
  x, i, c, pos, k, y, z, okfnd: integer;
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
  if not fmScriptTE.Visible then
  begin
    for c := i downto 0 do
    begin
      if copy(form4.ListBox1.Items.Strings[c], 9, length(mapbb)) = mapbb then
      begin
        modetouse := 2;
        s := copy(form4.ListBox1.Items.Strings[c], 10 + length(mapbb), 2);
        if showdecimal then
        begin
          z := strtoint(s);
          s := inttohex(z);
        end;
        if hextoint(s) = x then
        begin
          pos := c;
          b := copy(form4.ListBox1.Items.Strings[c], 1, 8) + mapbb + ' ' + GetDisplayValue(x, 2) + ', ' +
            GetDisplayValue(Floor[CheckListBox1.ItemIndex].floorid, 4) + ', ' + GetDisplayValue(TMenuItem(Sender).tag, 2) + ', 00';
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
        strtofind := leti + ' R' + inttostr(regused) + ', ' + GetDisplayValue(x, 8);
        regcount := 4;
      end;
      if copy(form4.ListBox1.Items.Strings[c], 9, length(mappc)) = mappc then
      begin
        modetouse := 0;
        s := copy(form4.ListBox1.Items.Strings[c], 10 + length(mappc), 3); // the reg
        pos := c;
        regused := strtoint(s);
        strtofind := leti + ' R' + inttostr(regused) + ', ' + GetDisplayValue(x, 8);
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
          b := b + leti + ' R' + inttostr(regused) + ', ' + GetDisplayValue(x, 8);
          form4.ListBox1.Items.insert(pos, b);
          y := 0;
          if regcount = 4 then
          begin
            form4.ListBox1.Items.insert(pos + 1, '        ' + leti + ' R' + inttostr(regused + 1) + ', ' +
              GetDisplayValue(Floor[CheckListBox1.ItemIndex].floorid, 8));
            y := 1;
          end;
          form4.ListBox1.Items.insert(pos + y + 1, '        ' + leti + ' R' + inttostr(regused + 1 + y) + ', 00000000');
          form4.ListBox1.Items.insert(pos + y + 2, '        ' + leti + ' R' + inttostr(regused + 2 + y) + ', ' +
            GetDisplayValue(TMenuItem(Sender).tag, 8));
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
        form4.ListBox1.Items.insert(c, '0:      ' + mapbb + ' ' + GetDisplayValue(x, 2) + ', ' +
          GetDisplayValue(Floor[CheckListBox1.ItemIndex].floorid, 4) + ', ' + GetDisplayValue(TMenuItem(Sender).tag, 2) + ', 00');
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
        b := '0:      ' + leti + ' R' + inttostr(regused) + ', ' + GetDisplayValue(x, 8);
        form4.ListBox1.Items.insert(pos, b);
        y := 0;
        if regcount = 4 then
        begin
          form4.ListBox1.Items.insert(pos + 1, '        ' + leti + ' R' + inttostr(regused + 1) + ', ' +
            GetDisplayValue(Floor[CheckListBox1.ItemIndex].floorid, 8));
          y := 1;
        end;
        form4.ListBox1.Items.insert(pos + y + 1, '        ' + leti + ' R' + inttostr(regused + 1 + y) + ', 00000000');
        form4.ListBox1.Items.insert(pos + y + 2, '        ' + leti + ' R' + inttostr(regused + 2 + y) + ', ' +
          GetDisplayValue(TMenuItem(Sender).tag, 8));
        form4.ListBox1.Items.insert(pos + y + 3, '        ' + leti + ' R' + inttostr(regused + 3 + y) + ', 00000000');
        if modetouse = 0 then
          form4.ListBox1.Items.insert(pos + y + 4, '        ' + mappc + 'R60')
        else
          form4.ListBox1.Items.insert(pos + y + 4, '        ' + mapgc + 'R60')
      end;
    end;
  end
  else
  begin
    i := fmScriptTE.TextEdit.Lines.Count - 1;
    TextEdited := true;
    for c := i downto 0 do
    begin
      if copy(fmScriptTE.TextEdit.Lines[c], 9, length(mapbb)) = mapbb then
      begin
        modetouse := 2;
        s := copy(fmScriptTE.TextEdit.Lines[c], 10 + length(mapbb), 2);
        if showdecimal then
        begin
          z := strtoint(s);
          s := inttohex(z);
        end;
        if hextoint(s) = x then
        begin
          pos := c;
          b := copy(fmScriptTE.TextEdit.Lines[c], 1, 8) + mapbb + ' ' + GetDisplayValue(x, 2) + ', ' +
            GetDisplayValue(Floor[CheckListBox1.ItemIndex].floorid, 4) + ', ' + GetDisplayValue(TMenuItem(Sender).tag, 2) + ', 00';
          fmScriptTE.TextEdit.Lines[c] := b;
          okfnd := 1;
          break;
        end;
      end;
      if copy(fmScriptTE.TextEdit.Lines[c], 9, length(mapgc)) = mapgc then
      begin
        modetouse := 1;
        pos := c;
        s := copy(fmScriptTE.TextEdit.Lines[c], 10 + length(mapgc), 3); // the reg
        regused := strtoint(s);
        strtofind := leti + ' R' + inttostr(regused) + ', ' + GetDisplayValue(x, 8);
        regcount := 4;
      end;
      if copy(fmScriptTE.TextEdit.Lines[c], 9, length(mappc)) = mappc then
      begin
        modetouse := 0;
        s := copy(fmScriptTE.TextEdit.Lines[c], 10 + length(mappc), 3); // the reg
        pos := c;
        regused := strtoint(s);
        strtofind := leti + ' R' + inttostr(regused) + ', ' + GetDisplayValue(x, 8);
        regcount := 3;
      end;
      if strtofind <> '' then
      begin
        if strtofind = copy(fmScriptTE.TextEdit.Lines[c], 9, length(fmScriptTE.TextEdit.Lines[c]) - 8) then
        begin
          k := c;
          b := copy(fmScriptTE.TextEdit.Lines[c], 1, 8);
          while k < pos do
          begin // delete all reg
            // scan for any matching reg
            for y := regused to regused + regcount do
            begin
              s := leti + ' R' + inttostr(y) + ', ';
              if copy(fmScriptTE.TextEdit.Lines[k], 9, length(s)) = s then
              begin
                fmScriptTE.TextEdit.Lines.Delete(k);
                dec(pos);
                break;
              end;
            end;
            if y > regused + regcount then
              inc(k); // didnt match
          end;
          // here insert all at the pos
          b := b + leti + ' R' + inttostr(regused) + ', ' + GetDisplayValue(x, 8);
          fmScriptTE.TextEdit.Lines.Insert(pos, b);
          y := 0;
          if regcount = 4 then
          begin
            fmScriptTE.TextEdit.Lines.Insert(pos + 1, '        ' + leti + ' R' + inttostr(regused + 1) + ', ' +
              GetDisplayValue(Floor[CheckListBox1.ItemIndex].floorid, 8));
            y := 1;
          end;
          fmScriptTE.TextEdit.Lines.Insert(pos + y + 1, '        ' + leti + ' R' + inttostr(regused + 1 + y) + ', 00000000');
          fmScriptTE.TextEdit.Lines.Insert(pos + y + 2, '        ' + leti + ' R' + inttostr(regused + 2 + y) + ', ' +
            GetDisplayValue(TMenuItem(Sender).tag, 8));
          fmScriptTE.TextEdit.Lines.Insert(pos + y + 3, '        ' + leti + ' R' + inttostr(regused + 3 + y) + ', 00000000');
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
        if copy(fmScriptTE.TextEdit.Lines[c], 1, 8) = '0:      ' then
          break;
      if c > -1 then
        if copy(fmScriptTE.TextEdit.Lines[c], 1, 8) = '0:      ' then
        begin
          fmScriptTE.TextEdit.Lines[c] := '  ' + copy(fmScriptTE.TextEdit.Lines[c], 3,
            length(fmScriptTE.TextEdit.Lines[c]) - 2);
        end;
      // dec(c);
      if modetouse = 2 then
      begin
        if c = -1 then
          inc(c);
        fmScriptTE.TextEdit.Lines.Insert(c, '0:      ' + mapbb + ' ' + GetDisplayValue(x, 2) + ', ' +
          GetDisplayValue(Floor[CheckListBox1.ItemIndex].floorid, 4) + ', ' + GetDisplayValue(TMenuItem(Sender).tag, 2) + ', 00');
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
        b := '0:      ' + leti + ' R' + inttostr(regused) + ', ' + GetDisplayValue(x, 8);
        fmScriptTE.TextEdit.Lines.Insert(pos, b);
        y := 0;
        if regcount = 4 then
        begin
          fmScriptTE.TextEdit.Lines.Insert(pos + 1, '        ' + leti + ' R' + inttostr(regused + 1) + ', ' +
            GetDisplayValue(Floor[CheckListBox1.ItemIndex].floorid, 8));
          y := 1;
        end;
        fmScriptTE.TextEdit.Lines.Insert(pos + y + 1, '        ' + leti + ' R' + inttostr(regused + 1 + y) + ', 00000000');
        fmScriptTE.TextEdit.Lines.Insert(pos + y + 2, '        ' + leti + ' R' + inttostr(regused + 2 + y) + ', ' +
          GetDisplayValue(TMenuItem(Sender).tag, 8));
        fmScriptTE.TextEdit.Lines.Insert(pos + y + 3, '        ' + leti + ' R' + inttostr(regused + 3 + y) + ', 00000000');
        if modetouse = 0 then
          fmScriptTE.TextEdit.Lines.Insert(pos + y + 4, '        ' + mappc + 'R60')
        else
          fmScriptTE.TextEdit.Lines.Insert(pos + y + 4, '        ' + mapgc + 'R60')
      end;
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
  if (have3d) and (form13.Focused) and (form13.BorderStyle = bsNone)
  and (previewstate = 0) then
    form13.close
  else if fmScriptTE.Edit2.Focused then
  begin
    fmScriptTE.Edit2.Hide;
    fmScriptTE.TextEdit.ClearSelection
  end
  else if fmScriptTE.txtNotes.Focused then
    fmScriptTE.Notes1Click(nil)
  else if Screen.ActiveForm = form12 then
    form12.Close
  else if Screen.ActiveForm = form17 then
    form17.Close
  else
  begin
    MoveSel := -1;
    HideIndicator();
    placerandom := false;
    placelookat := false;
    if previewstate > 0 then
    begin
      ResetPreviewState;
      DrawMap;
    end;
  end;
end;

procedure TForm1.Celledit1Click(Sender: TObject);
var
  Reg: TRegistry;
begin
  EnableGridEdit;
  editgrid := true;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\schthack\qedit', true) then
    begin
      Reg.WriteBool('EditGrid', true);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
  LoadFloorGrids;
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

procedure TForm1.tmPreviewTimer(Sender: TObject);
begin
  if (previewstate = 0) or (previewpaused) then
    Exit;

  if previewstate >= Floor[CheckListBox1.ItemIndex].Unknow[8]
  then
  begin
    previewpaused := true;
    DrawMap;
    Exit;
  end;
  if previewstate < Floor[CheckListBox1.ItemIndex].Unknow[8] then
  begin
    Inc(previewstate);
    DrawPreviewState(previewstate);
  end;
end;

procedure TForm1.Undo1Click(Sender: TObject);
begin
  if not form4.edit1.Focused and not fmScriptTE.TextEdit.Focused
  and not fmScriptTE.Edit2.Focused and not fmScriptTE.txtNotes.Focused then
    Button11Click(nil)
  else if form4.edit1.Focused then
    form4.edit1.Undo
  else if fmScriptTE.TextEdit.Focused then
    fmScriptTE.Undo1Click(nil)
  else if fmScriptTE.Edit2.focused then
    fmScriptTE.Edit2.Undo
  else if fmScriptTE.txtNotes.focused then
    fmScriptTE.txtNotes.Undo;
end;

procedure TForm1.English1Click(Sender: TObject);
var
  Reg: TRegistry;
  flp: TMemoryStream;
begin
  UncheckLanguages;
  English1.Checked := true;
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
  if fileexists(path + 'eng.txt') then
    flp.LoadFromFile(path + 'eng.txt');
  LoadLanguageStrings(flp);
  SetInterfaceText;
  flp.Free;
end;

procedure TForm1.French1Click(Sender: TObject);
var
  Reg: TRegistry;
  flp: TMemoryStream;
begin
  UncheckLanguages;
  French1.Checked := true;
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
  if fileexists(path + 'fra.txt') then
    flp.LoadFromFile(path + 'fra.txt')
  else
    PikaGetFile(flp, 'fra.txt', path + 'config.ppk', 'Build By Schthack');
  // flp.LoadFromFile('span.txt');
  LoadLanguageStrings(flp);
  SetInterfaceText;
  flp.Free;
end;

procedure TForm1.Grids1Click(Sender: TObject);
var
  Reg: TRegistry;
begin
  showgrid := true;
  ShowGrids;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\schthack\qedit', true) then
    begin
      Reg.WriteBool('ShowGrid', true);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TForm1.Exporttextfortranslation1Click(Sender: TObject);
var
  s, b: widestring;
  f, x, y, re, z, i, c: integer;
begin
  if fmScriptTE.Visible then
    form4.Show;
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

procedure TForm1.Texteditor1Click(Sender: TObject);
begin
  fmScriptTE.Show;
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
  if fmScriptTE.Visible then
    form4.Show;
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
  UncheckLanguages;
  Spanish1.Checked := true;
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
  if fileexists(path + 'spa.txt') then
    flp.LoadFromFile(path + 'spa.txt')
  else
    PikaGetFile(flp, 'spa.txt', path + 'config.ppk', 'Build By Schthack');
  // flp.LoadFromFile('span.txt');
  LoadLanguageStrings(flp);
  SetInterfaceText;
  flp.Free;
end;

procedure TForm1.Switchgridtab1Click(Sender: TObject);
begin
  if (Screen.ActiveForm = form1) and showgrid then
  begin
    if pagecontrol1.ActivePage = tabsheet1 then pagecontrol1.ActivePage := tabsheet2
    else pagecontrol1.ActivePage := tabsheet1;
  end;
end;

procedure TForm1.SwitchScriptEditor1Click(Sender: TObject);
begin
  if (Screen.ActiveForm = form1) or form13.Focused then
    form1.MirrorXposition1Click(nil)
  else
  begin
    if fmScriptTE.Visible then
      form4.Show
    else if form4.Visible then
      fmScriptTE.Show;
  end;
end;

procedure TForm1.Switchtab1Click(Sender: TObject);
begin
  Switchgridtab1Click(nil);
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
  if TStyleManager.IsCustomStyleActive then
    pagecontrol1.Width := (((Form1.Width - 190)) - 18)
  else
    pagecontrol1.Width := (((Form1.Width - 190)) - 14);
  lblModifiers.Left := lblStatus.Left + lblStatus.Width + 6;
  DrawMap;
end;

end.
