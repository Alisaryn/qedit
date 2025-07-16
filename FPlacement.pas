unit FPlacement;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin, registry,
  Vcl.NumberBox, Math;

type
  TFPlacementOptions = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox3: TGroupBox;
    btnSave: TButton;
    seDefaultSect: TSpinEdit;
    seSnapTolerance: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    nbOffsetX: TNumberBox;
    nbOffsetY: TNumberBox;
    nbOffsetZ: TNumberBox;
    nbDefaultZ: TNumberBox;
    nbDefaultY: TNumberBox;
    nbDefaultX: TNumberBox;
    btnReset: TButton;
    chkSnapRotate: TCheckBox;
    chkSnapDistance: TCheckBox;
    procedure btnSaveClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FPlacementOptions: TFPlacementOptions;

implementation

{$R *.dfm}

procedure TFPlacementOptions.btnSaveClick(Sender: TObject);
var Reg: TRegistry;
begin
  // Save all placement values to the registry
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\schthack\qedit', true) then
    begin
      Reg.WriteFloat('OffsetX', nbOffsetX.Value);
      Reg.WriteFloat('OffsetY', nbOffsetY.Value);
      Reg.WriteFloat('OffsetZ', nbOffsetZ.Value);
      Reg.WriteInteger('DefaultSect', seDefaultSect.Value);
      Reg.WriteFloat('DefaultX', nbDefaultX.Value);
      Reg.WriteFloat('DefaultY', nbDefaultY.Value);
      Reg.WriteFloat('DefaultZ', nbDefaultZ.Value);
      Reg.WriteInteger('SnapValue', seSnapTolerance.Value);
      Reg.WriteBool('SnapRotate', chkSnapRotate.Checked);
      Reg.WriteBool('SnapDistance', chkSnapDistance.Checked);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
    close;
end;

procedure TFPlacementOptions.FormCreate(Sender: TObject);
begin
  // Set minimum and maximum bounds for input
  nbOffsetX.MinValue := single.MinValue;
  nbOffsetX.MaxValue := single.MaxValue;
  nbOffsetY.MinValue := single.MinValue;
  nbOffsetY.MaxValue := single.MaxValue;
  nbOffsetZ.MinValue := single.MinValue;
  nbOffsetZ.MaxValue := single.MaxValue;

  seDefaultSect.MinValue := 0;
  seDefaultSect.MaxValue := High(word);
  nbDefaultX.MinValue := single.MinValue;
  nbDefaultX.MaxValue := single.MaxValue;
  nbDefaultY.MinValue := single.MinValue;
  nbDefaultY.MaxValue := single.MaxValue;
  nbDefaultZ.MinValue := single.MinValue;
  nbDefaultZ.MaxValue := single.MaxValue;

  seSnapTolerance.MinValue := 0;
  seSnapTolerance.MaxValue := High(integer);
end;

procedure TFPlacementOptions.btnResetClick(Sender: TObject);
begin
  // Reset values to their defaults
  nbOffsetX.Value := 0.0;
  nbOffsetY.Value := 0.0;
  nbOffsetZ.Value := 0.0;
  seDefaultSect.Value := 0;
  nbDefaultX.Value := 0.0;
  nbDefaultY.Value := 0.0;
  nbDefaultZ.Value := 0.0;
  seSnapTolerance.Value := 10;
  chkSnapRotate.Checked := false;
  chkSnapDistance.Checked := false;
end;

end.
