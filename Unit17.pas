unit Unit17;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, registry;

type
  TForm17 = class(TForm)
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    ComboBox2: TComboBox;
    Button1: TButton;
    Label4: TLabel;
    ComboBox4: TComboBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    chkFullscreen: TCheckBox;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form17: TForm17;

implementation

uses main;

{$R *.dfm}

procedure TForm17.Button1Click(Sender: TObject);
var Reg: TRegistry;
begin
     Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\schthack\qedit', True) then
   begin
      Reg.WriteInteger('Video',combobox1.ItemIndex);
      Reg.WriteInteger('Frame',combobox2.ItemIndex);
      Reg.WriteInteger('AA',dword(checkbox1.checked));
      Reg.WriteInteger('Dist',combobox4.ItemIndex);
      Reg.WriteInteger('SkyDome',dword(checkbox2.checked));
      Reg.WriteBool('Fullscreen3D',chkFullscreen.Checked);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
    inherited;
  end;

  if have3d then begin
      myscreen.ViewDistance:=0;
      if form17.ComboBox4.ItemIndex = 0 then myscreen.ViewDistance:=500;
      if form17.ComboBox4.ItemIndex = 1 then myscreen.ViewDistance:=900;
      if form17.ComboBox4.ItemIndex = 2 then myscreen.ViewDistance:=1500;
      if form17.ComboBox4.ItemIndex = 0 then myscreen.ItemDistance:=500;
      if form17.ComboBox4.ItemIndex = 1 then myscreen.ItemDistance:=800;
      if form17.ComboBox4.ItemIndex = 2 then myscreen.ItemDistance:=1000;
      if form17.ComboBox4.ItemIndex = 3 then myscreen.ItemDistance:=1200;
      if myscreen.ViewDistance <> 0 then
        myscreen.Setclipping(myscreen.ViewDistance)
      else myscreen.Setclipping(0);
      if form17.CheckBox1.Checked then myscreen.Antializing:=true
      else myscreen.Antializing:=false;
  end
  else
  // Re-render screen next time with new settings.
  if myscreen <> nil then
  begin
    myscreen.Free;
    myscreen := nil;
  end;

  close;
end;

end.
