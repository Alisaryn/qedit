program Qedit;

uses
  Forms,
  SysUtils,
  windows,
  main in 'main.pas' {Form1},
  FTitle in 'FTitle.pas' {Form2},
  FInfo in 'FInfo.pas' {Form3},
  FScrypt in 'FScrypt.pas' {Form4},
  Unit1 in 'Unit1.pas',
  TCom in 'TCom.pas' {Form5},
  FSetting in 'FSetting.pas' {Form6},
  FEdit in 'FEdit.pas' {Form7},
  Unit8 in 'Unit8.pas' {Form8},
  Unit9 in 'Unit9.pas' {Form9},
  Unit10 in 'Unit10.pas' {Form10},
  Unit11 in 'Unit11.pas' {Form11},
  PikaPackage in 'PikaPackage.pas',
  Unit12 in 'Unit12.pas' {Form12},
  Unit13 in 'Unit13.pas' {Form13},
  D3DEngin in 'D3DEngin.pas',
  Unit14 in 'Unit14.pas' {Form14},
  Unit15 in 'Unit15.pas' {Form15},
  Unit16 in 'Unit16.pas' {Form16},
  Unit17 in 'Unit17.pas' {Form17},
  Unit18 in 'Unit18.pas' {Form18},
  Unit19 in 'Unit19.pas' {Form19},
  NPCBuild in 'NPCBuild.pas' {Form20},
  EnemyStat in 'EnemyStat.pas' {Form21},
  Unit22 in 'Unit22.pas' {Form22},
  Unit23 in 'Unit23.pas' {Form23},
  FEnemyResist in 'FEnemyResist.pas' {Form24},
  FEnemyAttack in 'FEnemyAttack.pas' {Form25},
  FEnemyMov in 'FEnemyMov.pas' {Form26},
  FCompat in 'FCompat.pas' {Form27},
  MyConst in 'MyConst.pas',
  FFloatEdit in 'FFloatEdit.pas' {Form28},
  Unit29 in 'Unit29.pas' {Form29},
  crc32 in 'crc32.pas',
  FFFilter in 'FFFilter.pas' {Form30},
  Vcl.Themes,
  Vcl.Styles,
  FMonsDet in 'FMonsDet.pas' {Form31},
  FVector in 'FVector.pas' {Form32},
  FSymbolChat in 'FSymbolChat.pas' {Form33},
  FAsmModeSel in 'FAsmModeSel.pas' {Form34},
  FPlacement in 'FPlacement.pas' {FPlacementOptions},
  FHotkeys in 'FHotkeys.pas' {fmHotkeys};

{$R *.res}

begin
  if lowercase(extractfilename(application.ExeName)) = '_qedit.exe' then begin
      while not copyfile(pchar(application.exename),pchar(extractfilepath(application.ExeName)+'qedit.exe'),false) do sleep(1000);
      Startonl;
  end else begin
    if fileexists(extractfilepath(application.ExeName)+'_qedit.exe') then begin
        while not deletefile(pchar(extractfilepath(application.ExeName)+'_qedit.exe')) do sleep(100);
    end;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TForm7, Form7);
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TForm9, Form9);
  Application.CreateForm(TForm10, Form10);
  Application.CreateForm(TForm11, Form11);
  Application.CreateForm(TForm12, Form12);
  Application.CreateForm(TForm13, Form13);
  Application.CreateForm(TForm14, Form14);
  Application.CreateForm(TForm15, Form15);
  Application.CreateForm(TForm16, Form16);
  Application.CreateForm(TForm17, Form17);
  Application.CreateForm(TForm18, Form18);
  Application.CreateForm(TForm19, Form19);
  Application.CreateForm(TForm20, Form20);
  Application.CreateForm(TForm21, Form21);
  Application.CreateForm(TForm22, Form22);
  Application.CreateForm(TForm23, Form23);
  Application.CreateForm(TForm24, Form24);
  Application.CreateForm(TForm25, Form25);
  Application.CreateForm(TForm26, Form26);
  Application.CreateForm(TForm27, Form27);
  Application.CreateForm(TForm28, Form28);
  Application.CreateForm(TForm29, Form29);
  Application.CreateForm(TForm30, Form30);
  Application.CreateForm(TForm31, Form31);
  Application.CreateForm(TForm32, Form32);
  Application.CreateForm(TForm33, Form33);
  Application.CreateForm(TForm34, Form34);
  Application.CreateForm(TFPlacementOptions, FPlacementOptions);
  Application.CreateForm(TfmHotkeys, fmHotkeys);
  Application.Run;
  end;
end.
