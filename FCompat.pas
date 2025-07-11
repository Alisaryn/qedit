unit FCompat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ImgList, System.ImageList;

type
  TForm27 = class(TForm)
    ListBox1: TListBox;
    Label1: TLabel;
    Memo1: TMemo;
    Button1: TButton;
    ImageList1: TImageList;
    procedure Button1Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
    Er,wa:array[0..4] of tstringlist;
  end;

var
  Form27: TForm27;

implementation

{$R *.dfm}

procedure TForm27.Button1Click(Sender: TObject);
begin
    close;
end;

procedure TForm27.ListBox1Click(Sender: TObject);
begin
    memo1.Clear;
    if (wa[listbox1.ItemIndex].Count = 0) and (er[listbox1.ItemIndex].Count = 0) then Memo1.Lines.Add('This quest should be fully compatible with this version.')
    else begin
        if er[listbox1.ItemIndex].Count > 0 then begin
            memo1.lines.Add('Errors:');
            memo1.lines.AddStrings(er[listbox1.ItemIndex]);
            memo1.lines.Add('');
        end;
        if wa[listbox1.ItemIndex].Count > 0 then begin
            memo1.lines.Add('Warnings:');
            memo1.lines.AddStrings(wa[listbox1.ItemIndex]);
        end;
    end;
end;

procedure TForm27.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
    listbox1.Canvas.Brush.Color:=$FFFFFF;
    if state <> [] then listbox1.Canvas.Brush.Color:=$D4B7B6;
    listbox1.Canvas.FillRect(rect);

    if er[index].Count > 0 then imagelist1.Draw(listbox1.Canvas,0,rect.top,0)
    else if wa[index].Count > 0 then imagelist1.Draw(listbox1.Canvas,0,rect.top,1)
    else imagelist1.Draw(listbox1.Canvas,0,rect.top,2);

    listbox1.Canvas.TextOut(24,rect.top+5,listbox1.Items.Strings[index]);
end;

end.
