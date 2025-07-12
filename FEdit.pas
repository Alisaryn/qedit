unit FEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ValEdit, StdCtrls, ComCtrls, ExtCtrls, registry, main;

type
  TForm7 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Label1: TLabel;
    TrackBar1: TTrackBar;
    Label2: TLabel;
    Label3: TLabel;
    StringGrid1: TStringGrid;
    Image2: TImage;
    chkAutoAxis: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure TrackBar1Change(Sender: TObject);
    Procedure UpdateItemData();
    Procedure UpdateMonsterData();
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure StringGrid1Enter(Sender: TObject);
    procedure StringGrid1Exit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chkAutoAxisMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

  private
    { Private declarations }
  public
    { Public declarations }
    EObjData:Tobj;
    EMonsterData:Tmonster;
  end;
  Procedure DrawRotation(Rot:word);
  procedure CellEdited(ACol, ARow: Integer; const Value: string);

var
  Form7: TForm7;
  editrow:integer;
  editcol:integer;

implementation

uses Unit1, D3DEngin;

{$R *.dfm}

Procedure tform7.UpdateItemData;
var x,y:integer;
    t:tstringlist;
begin
    Form7.StringGrid1.Cells[1,0]:=inttostr(integer(EObjData.Skin));
        Form7.StringGrid1.Cells[1,1]:=inttostr(integer(EObjData.Unknow1));
        Form7.StringGrid1.Cells[1,2]:=inttostr(integer(EObjData.unknow2));
        Form7.StringGrid1.Cells[1,3]:=inttostr(integer(EObjData.id));
        Form7.StringGrid1.Cells[1,4]:=inttostr(integer(EObjData.grp));
        Form7.StringGrid1.Cells[1,5]:=inttostr(integer(EObjData.Map_Section));
        Form7.StringGrid1.Cells[1,6]:=inttostr(integer(EObjData.unknow5));
        Form7.StringGrid1.Cells[1,7]:=floattostrf(EObjData.Pos_X,ffFixed,10,4);
        Form7.StringGrid1.Cells[1,8]:=floattostrf(EObjData.Pos_z,ffFixed,10,4);
        Form7.StringGrid1.Cells[1,9]:=floattostrf(EObjData.Pos_y,ffFixed,10,4);
        Form7.TrackBar1.Position:=-round(EObjData.Pos_z * 10);
        {form1.DrawZBBRELFile(mapfilenam,EObjData.Pos_X +
            midpz[EObjData.map_section].X
            ,EObjData.Pos_y+midpz[EObjData.map_section].y
            ,miz[EObjData.Map_Section]);    }
        {Form7.StringGrid1.Cells[1,10]:=inttostr(integer(EObjData.unknow5));
        Form7.StringGrid1.Cells[1,11]:=inttostr(integer(EObjData.unknow6));
        Form7.StringGrid1.Cells[1,12]:=inttostr(integer(EObjData.unknow7));  }
        y:=10;
        DrawRotation(-(EObjData.unknow6+rev[EObjData.Map_Section]));
        StringGrid1.RowCount:=y;
        t:=GetObjParam(EObjData.Skin);
        for x:=0 to t.Count-1 do begin
            if (t.Strings[x] <> '') and (t.Strings[x] <> '-') then begin
                StringGrid1.RowCount:=y+1;
                StringGrid1.Cells[0,y]:=t.Strings[x];
                if x = 0 then StringGrid1.Cells[1,y]:=inttostr(integer(EObjData.unknow5));
                if x = 1 then StringGrid1.Cells[1,y]:=inttostr(integer(EObjData.unknow6));
                if x = 2 then StringGrid1.Cells[1,y]:=inttostr(integer(EObjData.unknow7));

                if x = 3 then StringGrid1.Cells[1,y]:=floattostrf(EObjData.unknow8,ffFixed,10,4);
                if x = 4 then StringGrid1.Cells[1,y]:=floattostrf(EObjData.unknow9,ffFixed,10,4);
                if x = 5 then StringGrid1.Cells[1,y]:=floattostrf(EObjData.unknow10,ffFixed,10,4);
                if x = 6 then StringGrid1.Cells[1,y]:=inttostr(integer(EObjData.obj_id));
                if x = 7 then StringGrid1.Cells[1,y]:=inttostr(integer(EObjData.action));
                if x = 8 then StringGrid1.Cells[1,y]:=inttostr(integer(EObjData.unknow13));
                if x = 9 then StringGrid1.Cells[1,y]:=inttostr(integer(EObjData.unknow14));
                inc(y);
            end;
        end;
end;

Procedure tform7.UpdateMonsterData;
var x,y:integer;
    t:tstringlist;
begin
    y:=0;
        StringGrid1.RowCount:=y;
        Form7.TrackBar1.Position:=-round(EMonsterData.Pos_z * 10);
        DrawRotation(-(EMonsterData.Direction+rev[EMonsterData.Map_Section]));
        t:=GetMonsterParam(EMonsterData.Skin);   
        for x:=0 to t.Count-1 do begin
            if (t.Strings[x] <> '') and (t.Strings[x] <> '-') then begin
                StringGrid1.RowCount:=y+1;
                StringGrid1.Cells[0,y]:=t.Strings[x];

                if x = 0 then StringGrid1.Cells[1,y]:=inttostr(integer(EMonsterData.Skin));
                if x = 1 then StringGrid1.Cells[1,y]:=inttostr(integer(EMonsterData.Unknow1));
                if x = 2 then StringGrid1.Cells[1,y]:=inttostr(integer(EMonsterData.unknow2 and $ffff));
                if x = 3 then StringGrid1.Cells[1,y]:=inttostr(integer(EMonsterData.unknow2 div $10000));
                if x = 4 then StringGrid1.Cells[1,y]:=inttostr(integer(EMonsterData.unknow3));
                if x = 5 then StringGrid1.Cells[1,y]:=inttostr(integer(EMonsterData.unknow4));
                if x = 6 then StringGrid1.Cells[1,y]:=inttostr(integer(EMonsterData.map_section));
                if x = 7 then StringGrid1.Cells[1,y]:=inttostr(integer(EMonsterData.unknow5));
                if x = 8 then
                    StringGrid1.Cells[1,y]:=inttostr(integer(EMonsterData.unknow6));
                if x = 9 then StringGrid1.Cells[1,y]:=floattostrf(EMonsterData.Pos_X,ffFixed,10,4);
                if x = 10 then StringGrid1.Cells[1,y]:=floattostrf(EMonsterData.Pos_Z,ffFixed,10,4);
                if x = 11 then StringGrid1.Cells[1,y]:=floattostrf(EMonsterData.Pos_Y,ffFixed,10,4);
                if x = 12 then StringGrid1.Cells[1,y]:=inttostr(integer(EMonsterData.unknow7));
                if x = 13 then StringGrid1.Cells[1,y]:=inttostr(integer(EMonsterData.Direction));
                if x = 14 then StringGrid1.Cells[1,y]:=inttostr(integer(EMonsterData.unknow8));
                //if x = 15 then StringGrid1.Cells[1,y]:=inttostr(integer(EMonsterData.unknow9));
                if x = 15 then StringGrid1.Cells[1,y]:=floattostrf(EMonsterData.Movement_data,ffFixed,10,4);
                 if x = 16 then StringGrid1.Cells[1,y]:=floattostrf(EMonsterData.Unknow10,ffFixed,10,4);
                 if x = 17 then StringGrid1.Cells[1,y]:=floattostrf(EMonsterData.unknow11,ffFixed,10,4);
                 if x = 18 then StringGrid1.Cells[1,y]:=floattostrf(EMonsterData.Char_id,ffFixed,10,4);
                 if x = 19 then StringGrid1.Cells[1,y]:=floattostrf(EMonsterData.Action,ffFixed,10,4);
                 if x = 20 then StringGrid1.Cells[1,y]:=inttostr(integer(EMonsterData.Movement_flag));
                 if x = 21 then StringGrid1.Cells[1,y]:=inttostr(integer(EMonsterData.unknow_flag));

                inc(y);
            end;
        end;
end;

Procedure DrawRotation(Rot:word);
var rt:word;
    px2,px3,py2,py3:single;
begin
    form7.Image2.Canvas.Brush.Color:=clwhite;
    form7.Image2.Canvas.FillRect(form7.Image2.Canvas.ClipRect);

    form7.Image2.Canvas.Brush.Color:=$008000;
    Form7.Image2.Canvas.Chord(7,5,97,90,90,5,90,5);

    form7.Image2.Canvas.Brush.Color:=$01D2FF;
    Form7.Image2.Canvas.Chord(45,41,60,55,0,0,0,0);

    rt:=rot;
    px2:=0;
    py2:=41;
    px3 := cos(rt/10430.37835)*px2 - sin(rt/10430.37835)*py2;
    py3 := sin(rt/10430.37835)*px2 + cos(rt/10430.37835)*py2;
    form7.Image2.Canvas.PenPos:=point(52+round(px3),48+round(py3));
    px2:=5;
    py2:=20;
    px3 := cos(rt/10430.37835)*px2 - sin(rt/10430.37835)*py2;
    py3 := sin(rt/10430.37835)*px2 + cos(rt/10430.37835)*py2;
    form7.Image2.Canvas.lineto(52+round(px3),48+round(py3));
    px2:=-5;
    py2:=20;
    px3 := cos(rt/10430.37835)*px2 - sin(rt/10430.37835)*py2;
    py3 := sin(rt/10430.37835)*px2 + cos(rt/10430.37835)*py2;
    form7.Image2.Canvas.lineto(52+round(px3),48+round(py3));
    px2:=0;
    py2:=41;
    px3 := cos(rt/10430.37835)*px2 - sin(rt/10430.37835)*py2;
    py3 := sin(rt/10430.37835)*px2 + cos(rt/10430.37835)*py2;
    form7.Image2.Canvas.lineto(52+round(px3),48+round(py3));

    px2:=0;
    py2:=31;
    px3 := cos(rt/10430.37835)*px2 - sin(rt/10430.37835)*py2;
    py3 := sin(rt/10430.37835)*px2 + cos(rt/10430.37835)*py2;
    form7.Image2.Canvas.FloodFill(52+round(px3),48+round(py3),$008000,fsSurface);
end;

procedure TForm7.Button1Click(Sender: TObject);
begin
    isedited:=true;
    if stype = 1 then begin
        {Floor[sfloor].Monster[selected].Skin:=strtoint64(Form7.StringGrid1.Cells[1,0]);
        Floor[sfloor].Monster[selected].Unknow1:=strtoint64(Form7.StringGrid1.Cells[1,1]);
        Floor[sfloor].Monster[selected].unknow2:=strtoint(Form7.StringGrid1.Cells[1,2])+(strtoint(Form7.StringGrid1.Cells[1,3])*$10000);
        Floor[sfloor].Monster[selected].unknow3:=strtoint64(Form7.StringGrid1.Cells[1,4]);
        Floor[sfloor].Monster[selected].unknow4:=strtoint64(Form7.StringGrid1.Cells[1,5]);
        Floor[sfloor].Monster[selected].map_section:=strtoint64(Form7.StringGrid1.Cells[1,6]);
        Floor[sfloor].Monster[selected].Unknow5:=strtoint64(Form7.StringGrid1.Cells[1,7]);
        Floor[sfloor].Monster[selected].unknow6:=strtoint64(Form7.StringGrid1.Cells[1,8]);
        Floor[sfloor].Monster[selected].Pos_X:=strtofloat(Form7.StringGrid1.Cells[1,9]);
        Floor[sfloor].Monster[selected].Pos_z:=strtofloat(Form7.StringGrid1.Cells[1,10]);
        Floor[sfloor].Monster[selected].Pos_y:=strtofloat(Form7.StringGrid1.Cells[1,11]);
        Floor[sfloor].Monster[selected].unknow7:=strtoint64(Form7.StringGrid1.Cells[1,12]);
        Floor[sfloor].Monster[selected].Direction:=strtoint64(Form7.StringGrid1.Cells[1,13]);
        Floor[sfloor].Monster[selected].unknow8:=strtoint64(Form7.StringGrid1.Cells[1,14]);
        Floor[sfloor].Monster[selected].unknow9:=strtoint64(Form7.StringGrid1.Cells[1,15]);
        Floor[sfloor].Monster[selected].Movement_data:=strtofloat(Form7.StringGrid1.Cells[1,16]);
        Floor[sfloor].Monster[selected].Unknow10:=strtofloat(Form7.StringGrid1.Cells[1,17]);
        Floor[sfloor].Monster[selected].unknow11:=strtofloat(Form7.StringGrid1.Cells[1,18]);
        Floor[sfloor].Monster[selected].Char_id:=strtofloat(Form7.StringGrid1.Cells[1,19]);
        Floor[sfloor].Monster[selected].Action:=strtofloat(Form7.StringGrid1.Cells[1,20]);
        Floor[sfloor].Monster[selected].Movement_flag:=strtoint64(Form7.StringGrid1.Cells[1,21]);
        Floor[sfloor].Monster[selected].unknow_flag:=strtoint64(Form7.StringGrid1.Cells[1,22]); }

        move(EMonsterData,Floor[sfloor].Monster[selected],sizeof(tmonster));
        if have3d then
            form1.listbox1.Items.Strings[selected]:='#'+inttostr(selected)+' - '+GenerateMonsterName(Floor[sfloor].Monster[selected],selected,2)
        else
            form1.listbox1.Items.Strings[selected]:='#'+inttostr(selected)+' - '+GenerateMonsterName(Floor[sfloor].Monster[selected],selected,0);
    end;
    If stype = 2 then begin
        {Floor[sfloor].obj[selected].Skin:=strtoint64(StringGrid1.Cells[1,0]);
        Floor[sfloor].obj[selected].Unknow1:=strtoint64(StringGrid1.Cells[1,1]);
        Floor[sfloor].obj[selected].unknow2:=strtoint64(StringGrid1.Cells[1,2]);
        Floor[sfloor].obj[selected].id:=strtoint(StringGrid1.Cells[1,3]);
        Floor[sfloor].obj[selected].grp:=strtoint(StringGrid1.Cells[1,4]);
        Floor[sfloor].obj[selected].Map_Section:=strtoint64(StringGrid1.Cells[1,5]);
        Floor[sfloor].obj[selected].unknow5:=strtoint64(StringGrid1.Cells[1,6]);
        Floor[sfloor].obj[selected].Pos_X:=strtofloat(StringGrid1.Cells[1,7]);
        Floor[sfloor].obj[selected].Pos_z:=strtofloat(StringGrid1.Cells[1,8]);
        Floor[sfloor].obj[selected].Pos_y:=strtofloat(StringGrid1.Cells[1,9]);
        Floor[sfloor].obj[selected].unknow5:=strtoint64(StringGrid1.Cells[1,10]);
        Floor[sfloor].obj[selected].unknow6:=strtoint64(StringGrid1.Cells[1,11]);
        Floor[sfloor].obj[selected].unknow7:=strtoint64(StringGrid1.Cells[1,12]);
        Floor[sfloor].obj[selected].unknow8:=strtofloat(StringGrid1.Cells[1,13]);
        Floor[sfloor].obj[selected].unknow9:=strtofloat(StringGrid1.Cells[1,14]);
        Floor[sfloor].obj[selected].unknow10:=strtofloat(StringGrid1.Cells[1,15]);
        Floor[sfloor].obj[selected].obj_id:=strtoint64(StringGrid1.Cells[1,16]);
        Floor[sfloor].obj[selected].action:=strtoint(StringGrid1.Cells[1,17]);
        Floor[sfloor].obj[selected].unknow13:=strtoint64(StringGrid1.Cells[1,18]);
        Floor[sfloor].obj[selected].unknow14:=strtoint64(StringGrid1.Cells[1,19]);   }
        move(EObjData,Floor[sfloor].obj[selected],sizeof(tobj));
        if have3d then begin
            if myobj[selected] <> nil then
            myobj[selected].Free;
            myobj[selected]:=nil;
            Generateobj(Floor[sfloor].Obj[selected],selected);
            //form1.listbox1.Items.Strings[selected]:=GenerateMonsterName(Floor[sfloor].Monster[selected],selected,2);
         end;
         form1.ListBox2.Items.Strings[selected]:='#'+inttostr(selected)+' - '+GetObjName(Floor[sfloor].Obj[selected].skin);

    end;
    Form1.DrawMap;
    close;
end;

procedure TForm7.StringGrid1Enter(Sender: TObject);
begin
    editcol:=-1;
    editrow:=-1;
end;

procedure TForm7.StringGrid1Exit(Sender: TObject);
begin
    if (EditCol <> -1) and (EditRow <> -1) then
    begin
      CellEdited(EditCol, EditRow, StringGrid1.Cells[1,EditRow]);
      EditCol := -1;
      EditRow := -1;
    end;
end;

procedure TForm7.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
    if acol = 0 then canselect:=false;
end;

procedure TForm7.TrackBar1Change(Sender: TObject);
var y,x:integer;
    t:tstringlist;
begin
    if stype = 2 then begin
        Form7.StringGrid1.Cells[1,8]:=floattostr(0-(trackbar1.Position/10));
        EObjData.Pos_z:=strtofloat(StringGrid1.Cells[1,8]);
    end;
    if stype = 1 then begin
        //
        y:=0;
        t:=GetMonsterParam(EMonsterData.Skin);
        for x:=0 to t.Count-1 do begin
            if (t.Strings[x] <> '') and (t.Strings[x] <> '-') then begin
                if x = 10 then begin
                    Form7.StringGrid1.Cells[1,y]:=floattostr(0-(trackbar1.Position / 10));
                    EMonsterData.Pos_z:=0-(trackbar1.Position / 10);
                end;
                inc(y);
            end;
        end;
    end;

end;

procedure TForm7.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
     if (ACol <> EditCol) or (ARow <> EditRow) then
      begin
        if (EditCol <> -1) and (editrow <> -1) then
        CellEdited(EditCol, EditRow,StringGrid1.Cells[1,EditRow]);
        EditCol := ACol;
        EditRow := ARow;
      end;
end;

procedure CellEdited(ACol, ARow: Integer; const Value: string);
var t:tstringlist;
    x,y:integer;
    v:widestring;
begin
  with form7 do begin
    if acol = 1 then begin
    v:=value;
    while pos(#13,V) > 0 do delete(v,pos(#13,V),1);
    while pos(#10,V) > 0 do delete(v,pos(#10,V),1);
    StringGrid1.Cells[1,aRow]:=v;
    if stype = 1 then begin
        //
        y:=0;
        t:=GetMonsterParam(EMonsterData.Skin);
        for x:=0 to t.Count-1 do begin
            if (t.Strings[x] <> '') and (t.Strings[x] <> '-') then begin
                //StringGrid1.RowCount:=y+1;
                //StringGrid1.Cells[0,y]:=t.Strings[x];
                if y = arow then begin
                if x = 0 then EMonsterData.skin:=strtoint64(StringGrid1.Cells[1,y]);
                if x = 1 then EMonsterData.Unknow1:=strtoint64(StringGrid1.Cells[1,y]);
                if x = 2 then EMonsterData.unknow2:=strtoint64(StringGrid1.Cells[1,y])+(EMonsterData.unknow2 and $ffff0000);
                if x = 3 then EMonsterData.unknow2:=(strtoint64(StringGrid1.Cells[1,y])*$10000)+(EMonsterData.unknow2 and $FFFF);
                if x = 4 then EMonsterData.unknow3:=strtoint64(StringGrid1.Cells[1,y]);
                if x = 5 then EMonsterData.unknow4:=strtoint64(StringGrid1.Cells[1,y]);
                if x = 6 then EMonsterData.map_section:=strtoint64(StringGrid1.Cells[1,y]);
                if x = 7 then EMonsterData.Unknow5:=strtoint64(StringGrid1.Cells[1,y]);
                if x = 8 then EMonsterData.unknow6:=strtoint64(StringGrid1.Cells[1,y]);
                if x = 9 then EMonsterData.Pos_X:=strtofloat(StringGrid1.Cells[1,y]);
                if x = 10 then EMonsterData.Pos_Z:=strtofloat(StringGrid1.Cells[1,y]);
                if x = 11 then EMonsterData.Pos_Y:=strtofloat(StringGrid1.Cells[1,y]);
                if x = 12 then EMonsterData.unknow7:=strtoint64(StringGrid1.Cells[1,y]);
                if x = 13 then EMonsterData.Direction:=strtoint64(StringGrid1.Cells[1,y]);
                if x = 14 then EMonsterData.unknow8:=strtoint64(StringGrid1.Cells[1,y]);
                if x = 15 then EMonsterData.Movement_data:=strtofloat(StringGrid1.Cells[1,y]);
                if x = 16 then EMonsterData.Unknow10:=strtofloat(StringGrid1.Cells[1,y]);
                if x = 17 then EMonsterData.unknow11:=strtofloat(StringGrid1.Cells[1,y]);
                if x = 18 then EMonsterData.Char_id:=strtofloat(StringGrid1.Cells[1,y]);
                if x = 19 then EMonsterData.action:=strtofloat(StringGrid1.Cells[1,y]);
                if x = 20 then EMonsterData.Movement_flag:=strtoint64(StringGrid1.Cells[1,y]);
                if x = 21 then EMonsterData.unknow_flag:=strtoint64(StringGrid1.Cells[1,y]);
                          
                if x = 10 then trackbar1.Position:=-round((strtofloat(StringGrid1.Cells[1,y])*10));
                if x = 13 then drawrotation(-(EMonsterData.Direction+rev[EMonsterData.Map_Section]));
                end;
                inc(y);
            end;
        end;
    end;

    if stype = 2 then begin
        if arow = 0 then begin EObjData.Skin:=strtoint64(StringGrid1.Cells[1,0]); UpdateItemData; end;
        if arow = 1 then EObjData.Unknow1:=strtoint64(StringGrid1.Cells[1,1]);
        if arow = 2 then EObjData.unknow2:=strtoint64(StringGrid1.Cells[1,2]);
        if arow = 3 then EObjData.id:=strtoint(StringGrid1.Cells[1,3]);
        if arow = 4 then EObjData.grp:=strtoint(StringGrid1.Cells[1,4]);
        if arow = 5 then EObjData.Map_Section:=strtoint64(StringGrid1.Cells[1,5]);
        if arow = 6 then EObjData.unknow5:=strtoint64(StringGrid1.Cells[1,6]);
        if arow = 7 then EObjData.Pos_X:=strtofloat(StringGrid1.Cells[1,7]);
        if arow = 8 then EObjData.Pos_z:=strtofloat(StringGrid1.Cells[1,8]);
        if arow = 9 then EObjData.Pos_y:=strtofloat(StringGrid1.Cells[1,9]);

        y:=10;
        t:=GetObjParam(EObjData.Skin);
        for x:=0 to t.Count-1 do begin
            if (t.Strings[x] <> '') and (t.Strings[x] <> '-') then begin
                //StringGrid1.RowCount:=y+1;
                //StringGrid1.Cells[0,y]:=t.Strings[x];
                if y = arow then begin
                if x = 0 then EObjData.unknow5:=strtoint64(StringGrid1.Cells[1,y]);
                if x = 1 then EObjData.unknow6:=strtoint64(StringGrid1.Cells[1,y]);
                if x = 2 then EObjData.unknow7:=strtoint64(StringGrid1.Cells[1,y]);
                if x = 3 then EObjData.unknow8:=strtofloat(StringGrid1.Cells[1,y]);
                if x = 4 then EObjData.unknow9:=strtofloat(StringGrid1.Cells[1,y]);
                if x = 5 then EObjData.unknow10:=strtofloat(StringGrid1.Cells[1,y]);
                if x = 6 then EObjData.obj_id:=strtoint64(StringGrid1.Cells[1,y]);
                if x = 7 then EObjData.action:=strtoint(StringGrid1.Cells[1,y]);
                if x = 8 then EObjData.unknow13:=strtoint64(StringGrid1.Cells[1,y]);
                if x = 9 then EObjData.unknow14:=strtoint64(StringGrid1.Cells[1,y]);


                if x = 1 then DrawRotation(-(EObjData.unknow6+rev[EObjData.Map_Section]));
                end;
                inc(y);
            end;
        end;

        if arow = 8 then trackbar1.Position:=-round(strtofloat(StringGrid1.Cells[1,8])*10);
    end;
    end;
  end;
end;

procedure TForm7.Image2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i,diff,diffmin,closest,sx,sy,rt,xx,yy:integer;
    t:tstringlist;
    rtvalues: Array of integer;
begin
    // Static values for precise rotation
    rtvalues := [0, 4096, 8192, 12288, 16384, 20480, 24576, 28672,
                32768, 36864, 40960, 45056, 49152, 53248, 57344, 65535];
    sx:=x-52;
    sy:=y-48;
    if (sx<>0) and (sy<>0) then begin
    if (sx>0) and (sy>0) then begin
        if sx>sy then rt:=$4000-round(sy/(sqrt(sqr(sx)+sqr(sy)) )*10430.37835)
        else rt:=round(sx/(sqrt(sqr(sx)+sqr(sy)) )*10430.37835);
    end;

    if (sx>0) and (sy<0) then begin
        if abs(sx)>abs(sy) then rt:=$4000-round(sy/(sqrt(sqr(sx)+sqr(sy)) )*10430.37835)
        else rt:=$8000-round(sx/(sqrt(sqr(sx)+sqr(sy)) )*10430.37835);
    end;

    if (sx<0) and (sy<0) then begin
        if abs(sx)>abs(sy) then rt:=$C000+round(sy/(sqrt(sqr(sx)+sqr(sy)) )*10430.37835)
        else rt:=$8000-round(sx/(sqrt(sqr(sx)+sqr(sy)) )*10430.37835);
    end;

    if (sx<0) and (sy>0) then begin
        if abs(sx)>abs(sy) then rt:=$C000+round(sy/(sqrt(sqr(sx)+sqr(sy)) )*10430.37835)
        else rt:=$10000+round(sx/(sqrt(sqr(sx)+sqr(sy)) )*10430.37835);
    end;
    end else begin
    if sx = 0 then begin
        if sy>0 then rt:=0
        else rt:=$8000;
    end;


    if sy = 0 then begin
        if sx>0 then rt:=$4000
        else rt:=$C000;
    end;
    end;


    if chkAutoAxis.Checked then
    begin
      // Find the closest rotation value to the user's selection
      closest := rtvalues[0];
      diffmin := abs(rtvalues[0] - rt);
      for i := 0 to High(rtvalues) do
      begin
        diff := abs(rt - rtvalues[i]);
        if diff < diffmin then
        begin
          diffmin := diff;
          closest := i;
        end;
      end;
      // Set the new value
      rt := rtvalues[closest];
    end;

    if stype = 1 then begin
        EMonsterData.Direction:=(rt-rev[EMonsterData.Map_Section]) and $ffff;
        yy:=0;
        t:=GetMonsterParam(EMonsterData.Skin);
        for xx:=0 to t.Count-1 do begin
            if (t.Strings[xx] <> '') and (t.Strings[xx] <> '-') then begin
                if xx = 13 then Form7.StringGrid1.Cells[1,yy]:=inttostr(EMonsterData.Direction);
                inc(yy);
                end;
            end;

    end;
    if stype = 2 then begin
        EObjData.unknow6:=(rt-rev[EObjData.Map_Section]) and $ffff;
        yy:=10;                
        t:=GetObjParam(EObjData.Skin);
        for xx:=0 to t.Count-1 do begin
            if (t.Strings[xx] <> '') and (t.Strings[xx] <> '-') then begin
                if xx = 1 then Form7.StringGrid1.Cells[1,yy]:=inttostr(EObjData.unknow6 );
                inc(yy);
                end;
            end;

    end;

    DrawRotation(-rt);//-()*10430.37835));

    //52,48
end;

procedure TForm7.chkAutoAxisMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
  if Reg.OpenKey('\Software\Microsoft\schthack\qedit', true) then
  begin
    Reg.WriteBool('AutoAxis', chkAutoAxis.Checked);
    Reg.CloseKey;
  end;
  finally
    Reg.Free;
  end;
end;

procedure TForm7.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  stringGrid1.EditorMode:=false;
  button1.SetFocus;
end;

procedure TForm7.FormShow(Sender: TObject);
    var
  myRect: TGridRect;
begin
  myRect.Left := 1;
  myRect.Top := 0;
  myRect.Right := 1;
  myRect.Bottom := 0;
  stringGrid1.Selection := myRect;
  stringGrid1.ScrollBy(0,0);
  stringGrid1.EditorMode:=true;
  stringGrid1.EditorMode:=false;
end;

procedure TForm7.Image1DblClick(Sender: TObject);
var px,py,xx,z,yy:single;
    t:tstringlist;
    x,y:integer;
begin
    if stype = 1 then begin
        xx:=EMonsterData.Pos_X;
        yy:=EMonsterData.Pos_Y;
        px := cos(rev[EMonsterData.map_section]/10430.37835)*xx - sin(rev[EMonsterData.map_section]/10430.37835)*yy;
        py := sin(rev[EMonsterData.map_section]/10430.37835)*xx + cos(rev[EMonsterData.map_section]/10430.37835)*yy;
        px:=midpz[EMonsterData.map_section].X+px;
        py:=midpz[EMonsterData.map_section].y+py;
        z:=form1.YFromBBRELFile(px,py)-miz[EMonsterData.map_section];
    end;

    if stype = 2 then begin
        xx:=EObjData.Pos_X;
        yy:=EObjData.Pos_Y;
        px := cos(rev[EObjData.map_section]/10430.37835)*xx - sin(rev[EObjData.map_section]/10430.37835)*yy;
        py := sin(rev[EObjData.map_section]/10430.37835)*xx + cos(rev[EObjData.map_section]/10430.37835)*yy;
        px:=midpz[EObjData.map_section].X+px;
        py:=midpz[EObjData.map_section].y+py;
        z:=form1.YFromBBRELFile(px,py)-miz[EObjData.map_section];
    end;


    trackbar1.Position:=round(-(z * 10));


    if stype = 1 then begin
        EMonsterData.Pos_z:=z;
        y:=0;
        t:=GetMonsterParam(EMonsterData.Skin);
        for x:=0 to t.Count-1 do begin
            if (t.Strings[x] <> '') and (t.Strings[x] <> '-') then begin
                if x = 10 then begin
                    Form7.StringGrid1.Cells[1,y]:=floattostrf(EMonsterData.Pos_Z,ffFixed,10,4);
                end;
                inc(y);
            end;
        end;
    end;

    if stype = 2 then begin
        Form7.StringGrid1.Cells[1,8]:=floattostrf(Z,ffFixed,10,4);
        EObjData.Pos_z:=z;
    end;

end;

end.
