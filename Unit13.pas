unit Unit13;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, D3Dx9, StdCtrls, FPlacement;

type
  TForm13 = class(TForm)
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form13: TForm13;
  lmx,lmy:integer;
  inclick:boolean = false;
  inclickz,inclickx,inclicky:single;
  rotx:integer;
  ini:integer=1024;
  dta:integer=0;
  fog:integer=1;
  rtinc:integer=0;
  rtx,rty,rtz:boolean;
  
  fogCol:dword;
  fogstart,fogtstart:single;
  fogend,fogtend:single;
  fogspeed:dword;
  fogtime:dword;
  fogtcol:dword;
  fogcurrent:dword;
  fogtype:integer=1;
  fogfl1,fogfl2:single;
  fogstep:single;
  Keys:array[0..256] of boolean;

  

implementation

uses main, Unit1, MyConst;

{$R *.dfm}

function GoForward:boolean;
var px,py,pz:single;
begin
    px:=cos(vr);
    py:=sin(vz);
    pz:=(cos(vz))*sin(vr);
    ppx:=ppx+(px*3);
    ppy:=ppy+(py*3);
    ppz:=ppz+(pz*3);
    myscreen.SetView(ppx,ppy,ppz,vr,vz);
end;

function GoBackward:boolean;
var px,py,pz:single;
begin
    px:=cos(vr);
    py:=sin(vz);
    pz:=(cos(vz))*sin(vr);
    ppx:=ppx-(px*3);
    ppy:=ppy-(py*3);
    ppz:=ppz-(pz*3);
    myscreen.SetView(ppx,ppy,ppz,vr,vz);
end;

procedure TForm13.Timer1Timer(Sender: TObject);
var d1,d2,d3:dword;
    f1,f2,f3:double;
    r,g,b,r1,b1,g1:integer;
    x,i:integer;
begin
    if have3d then
    if myscreen <> nil then begin

        //particle
        //particle.SetCoordinate(0,10,0);

        //fog change

       if fogspeed <> 0 then begin
           //get the nes distance
           f3:=integer(fogspeed-gettickcount);
           f1:=((fogstart - fogtstart) / fogtime) * f3;
           f2:=((fogend - fogtend) / fogtime) * f3;
           //the color now
           r:=fogcol and 255;
           g:=(fogcol div 256) and 255;
           b:=(fogcol div $10000) and 255;
           r1:=fogtcol and 255;
           g1:=(fogtcol div 256) and 255;
           b1:=(fogtcol div $10000) and 255;
           r:=r1+((((r - r1) * round(f3)) div fogtime) and 255);
           g:=g1+((((g - g1) * round(f3)) div fogtime) and 255);
           b:=b1+((((b - b1) * round(f3)) div fogtime) and 255);

           if f3>0 then
                myscreen.SetFog(r+(g*256)+(b*$10000),fogtstart+f1,fogtend+f2)
           else begin
               myscreen.SetFog(fogtcol,fogtstart,fogtend);
               fogspeed:=0;
               fogstart:=fogtstart;
               fogend:=fogtend;
               fogcol:=fogtcol;
               if fogtype = 2 then begin
                   fogtend:=fogfl2;
                   fogtime:=round(((abs(fogfl1-fogfl2) / fogstep)/60)*1000);
                   fogspeed:=gettickcount+fogtime;
                   fogtype:=3;
                   if fogtime = 0 then fogspeed:=0;
               end else if fogtype = 3 then begin
                   fogtend:=fogfl1;
                   fogtime:=round(((abs(fogfl1-fogfl2) / fogstep)/60)*1000);
                   fogspeed:=gettickcount+fogtime;
                   fogtype:=2;
                   if fogtime = 0 then fogspeed:=0;
               end
           end;
       end;

       //look if a fog array
       i:=0;
       if fog = 1 then
       for x:=0 to floor[sfloor].ObjCount-1 do begin
       if (floor[sfloor].Obj[x].Skin = 7) or (floor[sfloor].Obj[x].Skin = 24) or (floor[sfloor].Obj[x].Skin = 352) or (floor[sfloor].Obj[x].Skin = 913) then begin
           f1:=sqrt(sqr((MyObj[x].PositionX) - ppx)
                +sqr((MyObj[x].PositionZ-ppz)));
           f1:=sqrt(sqr(f1)+sqr(MyObj[x].PositionY-ppy));
           if f1 < floor[sfloor].Obj[x].unknow8 then begin
                i:=1;
                r:=floor[sfloor].Obj[x].obj_id and 255;
                if floor[sfloor].Obj[x].Skin = 352 then r:=floor[sfloor].Obj[x].action and 255;
                if r <> fogcurrent then begin
                    //in it.... runnnnnnnnnnnnnnnnnnnnn
                    fogtime:=round(fogentry[r].F13*10);
                    if fogspeed <> 0 then begin
                        fogspeed:=gettickcount+(fogtime-(fogspeed-gettickcount));
                        fogstart:=fogtstart;
                        fogend:=fogtend;
                        fogcol:=fogtcol;
                    end else fogspeed:=gettickcount+fogtime;
                   fogtstart:=fogentry[r].F4;
                    fogtend:=fogentry[r].F3;
                    fogtcol:=fogentry[r].F2;
                    fogcurrent:=r;
                    fogtype:=fogentry[r].F1;
                    fogfl1:=fogtend-fogentry[r].F9;
                    fogfl2:=fogtend-fogentry[r].F11;
                    fogstep:=fogentry[r].F7;
                    if fogtype = 2 then begin
                        fogtend:=fogfl1;
                    end;
                    if fogtime = 0 then fogspeed:=0;
                end;
           end;
       end;
       end;
       if i = 0 then begin
        r:=FloorFog[floor[sfloor].floorid];
           if r <> fogcurrent then begin
                    //in it.... runnnnnnnnnnnnnnnnnnnnn
                    fogtime:=round(fogentry[r].F13*10);
                    if fogspeed <> 0 then begin
                        fogspeed:=gettickcount+(fogtime-(fogspeed-gettickcount));
                        fogstart:=fogtstart;
                        fogend:=fogtend;
                        fogcol:=fogtcol;
                    end else fogspeed:=gettickcount+fogtime;
                    fogtstart:=fogentry[r].F4;
                    fogtend:=fogentry[r].F3;
                    fogtcol:=fogentry[r].F2;
                    fogtype:=fogentry[r].F1;
                    fogfl1:=fogtend-fogentry[r].F9;
                    fogfl2:=fogtend-fogentry[r].F11;
                    fogstep:=fogentry[r].F7;
                    if fogtype = 2 then begin
                        fogtend:=fogfl1;
                    end;
                    fogcurrent:=r;

                end;
       end;




        if dta = 0 then
        myscreen.TextOut('X: '+floattostrf(ppx,ffGeneral,6,2)+'  Y: '+floattostrf(ppy,ffGeneral,6,2)+
        '  Z: '+floattostrf(-ppz,ffGeneral,6,2)+'  Rotation: '+
        inttostr(round(vr*10430.37835047) and $ffff)+'/'+inttostr(round(vz*10430.37835047) and $ffff),rect(0,0,640,30),$FFFFFFFF,1)
        else begin
        move(ppx,d1,4);
        move(ppy,d2,4);
        move(ppz,d3,4);
        myscreen.TextOut('X: '+inttohex(d1,8)+'  Y: '+inttohex(d2,8)+
        '  Z: '+inttohex(d3,8)+'  Rotation: '+
        inttohex(round(vr*10430.37835047) and $ffff,8)+'/'+inttohex(round(vz*10430.37835047) and $ffff,8),rect(0,0,640,30),$FFFFFFFF,1);
        end;


        if ini > 0 then begin
            dec(ini);
            myscreen.TextOut('Q = forward, A = backward, D = Togle data format, F = Togle fog effect, R = Auto-rotate',rect(0,form13.Height-65,640,form13.Height-50),$FFFFFFFF,1);
            myscreen.TextOut('Edit: Hold click + CTRL = move, + SHIFT = up/down, + right click = rotate, CTRL + S = Snap',rect(0,form13.Height-50,640,form13.Height-35),$FFFFFFFF,1);
        end;
        myscreen.RenderSurface;
        if Keys[Ord('Q')] then GoForward;
        if Keys[Ord('A')] then GoBackward;

        rtx:=false;
        rty:=false;
        rtz:=false;
        if Keys[Ord('X')] then rtx:=true;
        if Keys[Ord('Y')] then rty:=true;
        if Keys[Ord('Z')] then rtz:=true;



    if selected > -1 then begin
    if stype = 1 then begin
        sel3d.SetCoordinate(mymonst[selected].PositionX ,
            floor[sfloor].Monster[selected].Pos_z+miz[Floor[sfloor].Monster[selected].map_section]+0.5,
            mymonst[selected].Positionz );

    end;
    if stype = 2 then begin
        sel3d.SetCoordinate(MyObj[selected].PositionX ,
            floor[sfloor].obj[selected].Pos_Z+miz[Floor[sfloor].obj[selected].Map_Section]+0.5,
            MyObj[selected].Positionz );

    end;
    sel3d2.SetCoordinate(sel3d.PositionX,sel3d.PositionY,sel3d.PositionZ);
    sel3d.SetRotation(gettickcount / 20,0,0);
    sel3d2.SetRotation(gettickcount / 40,0,0);
    sel3d.Visible:=true;
    sel3d2.Visible:=true;
    end else begin
        sel3d.Visible:=false;
        sel3d2.Visible:=false;
    end;
    end;
end;

procedure TForm13.FormShow(Sender: TObject);
var i:integer;
begin
    timer1.Enabled:=true;
    for i:=0 to 255 do Keys[i]:=false;
end;

procedure TForm13.FormHide(Sender: TObject);
begin
   timer1.Enabled:=false;
   
end;

procedure TForm13.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);

var v,rayOrigin,rayDir:TD3DXVECTOR3;
    m,n:TD3DXMATRIX;
    i,c,j:integer;
    rt:dword;
    px2,px3,py2,py3:single;
begin
    if (shift = [ssleft]) and (not rtx) and (not rty) and (not rtz) then begin
        vz:=vz+((lmy-y)/120);
        if vz > 1.5 then vz:=1.5;
        if vz < -1.5 then vz:=-1.5;
        vr:=vr+((lmx-x)/120);
        lmx:=x;
        lmy:=y;
        myscreen.SetView(ppx,ppy,ppz,vr,vz);
    end;


    //move the monster

    if inclick then
    if  shift = [ssCtrl,ssleft] then begin
        isedited:=true;
        v.x :=  ( ( ( 2.0 * X ) / Width ) - 1 ) / (2);
        v.y := -( ( ( 2.0 * Y ) / Height ) - 1) / (2);
        v.z :=  1.0;

        D3DXMatrixInverse( m, nil, myscreen.matview);
        // This is the direction of the ray from the mouse cursor into the scene...
        rayDir.x := v.x*m._11 + v.y*m._21 + v.z*m._31;
        rayDir.y := v.x*m._12 + v.y*m._22 + v.z*m._32;
        rayDir.z := (v.x*m._13 + v.y*m._23 + v.z*m._33);

        // This is the position of rayDir's head.
        rayOrigin.x := m._41;
        rayOrigin.y := m._42;
        rayOrigin.z := m._43;
        c:=0;
        while ((rayOrigin.y < inclickz-0.7) or (rayOrigin.y > inclickz+0.7)) and (c < 500) do begin
            rayOrigin.x := rayOrigin.x + rayDir.x;
            rayOrigin.y := rayOrigin.y + rayDir.y;
            rayOrigin.z := rayOrigin.z + rayDir.z;
            inc(c);
        end;
        snapvalue := FPlacementOptions.seSnapTolerance.Value;
        if stype = 1 then begin
            mymonst[selected].PositionX:=rayOrigin.x;
            mymonst[selected].PositionZ:=rayOrigin.z;

            rt:=rev[Floor[sfloor].Monster[selected].map_section];
            px2:=rayOrigin.x-midpz[Floor[sfloor].Monster[selected].map_section].x;
            py2:=(-rayOrigin.z)-midpz[Floor[sfloor].Monster[selected].map_section].y;
            px3 := cos(rt/10430.37835)*px2 - sin(rt/10430.37835)*py2;
            py3 := sin(rt/10430.37835)*px2 + cos(rt/10430.37835)*py2;
            floor[sfloor].Monster[selected].Pos_X:=px3;
            floor[sfloor].Monster[selected].Pos_Y:=py3;

            if (Form1.smSnap.Checked) or (Keys[Ord('S')]) then
            begin
              // 3D vertical snap for monsters
              for j := 0 to Floor[sfloor].MonsterCount - 1 do
              begin
                for i := 0 to snapvalue do
                begin
                    if (Floor[sfloor].Monster[j].map_section = Floor[sfloor].Monster[selected].map_section) and
                    ((Floor[sfloor].Monster[j].Unknow5 = showwave) or (showwave = -1)) then
                    begin
                      if ((round(Floor[sfloor].Monster[j].Pos_X + i)) = round(px3))
                      or ((round(Floor[sfloor].Monster[j].Pos_X - i)) = round(px3)) then
                      begin
                        floor[sfloor].Monster[selected].Pos_X := floor[sfloor].Monster[j].Pos_X;
                        mymonst[selected].PositionX := mymonst[j].PositionX;
                        if (FPlacementOptions.chkSnapRotate.Checked) then
                          floor[sfloor].Monster[selected].Direction := floor[sfloor].Monster[j].Direction;
                        GenerateMonsterName(Floor[sfloor].Monster[selected],selected,2);
                      end;
                    end;
                end;
              end;

              // 3D horizontal snap for monsters
              for j := 0 to Floor[sfloor].MonsterCount - 1 do
              begin
                for i := 0 to snapvalue do
                begin
                    if (Floor[sfloor].Monster[j].map_section = Floor[sfloor].Monster[selected].map_section) and
                    ((Floor[sfloor].Monster[j].Unknow5 = showwave) or (showwave = -1)) then
                    begin
                      if ((round(Floor[sfloor].Monster[j].Pos_Y + i)) = round(py3))
                      or ((round(Floor[sfloor].Monster[j].Pos_Y - i)) = round(py3)) then
                      begin
                        floor[sfloor].Monster[selected].Pos_Y := floor[sfloor].Monster[j].Pos_Y;
                        mymonst[selected].PositionY := mymonst[j].PositionY;
                        if (FPlacementOptions.chkSnapRotate.Checked) then
                          floor[sfloor].Monster[selected].Direction := floor[sfloor].Monster[j].Direction;
                        GenerateMonsterName(Floor[sfloor].Monster[selected],selected,2);
                      end;
                    end;
                end;
              end;
            end;

            sel3d.SetCoordinate(mymonst[selected].PositionX ,
                floor[sfloor].Monster[selected].Pos_z+miz[Floor[sfloor].Monster[selected].map_section]+0.5,
                mymonst[selected].Positionz );
        end;
        if stype = 2 then begin
            MyObj[selected].PositionX:=rayOrigin.x;
            MyObj[selected].PositionZ:=rayOrigin.z;
            
            rt:=rev[Floor[sfloor].obj[selected].map_section];
            px2:=rayOrigin.x-midpz[Floor[sfloor].Obj[selected].map_section].x;
            py2:=(-rayOrigin.z)-midpz[Floor[sfloor].Obj[selected].map_section].y;
            px3 := cos(rt/10430.37835)*px2 - sin(rt/10430.37835)*py2;
            py3 := sin(rt/10430.37835)*px2 + cos(rt/10430.37835)*py2;
            floor[sfloor].Obj[selected].Pos_X:=px3;
            floor[sfloor].Obj[selected].Pos_Y:=py3;

            if (Form1.smSnap.Checked) or (Keys[Ord('S')]) then
            begin
              // 3D vertical snap for objects
              for j := 0 to Floor[sfloor].ObjCount - 1 do
              begin
                for i := 0 to snapvalue do
                begin
                    if (Floor[sfloor].Obj[j].map_section = Floor[sfloor].Obj[selected].map_section) and
                    ((Floor[sfloor].Obj[j].Unknow5 = showwave) or (showwave = -1)) then
                    begin
                      if ((round(Floor[sfloor].Obj[j].Pos_X + i)) = round(px3))
                      or ((round(Floor[sfloor].Obj[j].Pos_X - i)) = round(px3)) then
                      begin
                        floor[sfloor].Obj[selected].Pos_X := floor[sfloor].Obj[j].Pos_X;
                        myobj[selected].PositionX := myobj[j].PositionX;
                        if (FPlacementOptions.chkSnapRotate.Checked) then
                          floor[sfloor].Obj[selected].unknow6 := floor[sfloor].Obj[j].unknow6;
                        myobj[selected].Free;
                        Generateobj(floor[sfloor].obj[selected],selected);
                      end;
                    end;
                end;
              end;

              // 3D horizontal snap for objects
              for j := 0 to Floor[sfloor].ObjCount - 1 do
              begin
                for i := 0 to snapvalue do
                begin
                    if (Floor[sfloor].Obj[j].map_section = Floor[sfloor].Obj[selected].map_section) and
                    ((Floor[sfloor].Obj[j].Unknow5 = showwave) or (showwave = -1)) then
                    begin
                      if ((round(Floor[sfloor].Obj[j].Pos_Y + i)) = round(py3))
                      or ((round(Floor[sfloor].Obj[j].Pos_Y - i)) = round(py3)) then
                      begin
                        floor[sfloor].Obj[selected].Pos_Y := floor[sfloor].Obj[j].Pos_Y;
                        myobj[selected].PositionY := myobj[j].PositionY;
                        if (FPlacementOptions.chkSnapRotate.Checked) then
                          floor[sfloor].Obj[selected].unknow6 := floor[sfloor].Obj[j].unknow6;
                        myobj[selected].Free;
                        Generateobj(floor[sfloor].obj[selected],selected);
                      end;
                    end;
                end;
              end;
            end;

            sel3d.SetCoordinate(MyObj[selected].PositionX ,
                floor[sfloor].obj[selected].Pos_Z+miz[Floor[sfloor].obj[selected].Map_Section]+0.5,
                MyObj[selected].Positionz );
        end;

    end;

    //Z move the player
    
    if inclick then
    if  shift = [ssShift,ssleft] then begin
    isedited:=true;
        v.x :=  ( ( ( 2.0 * X ) / Width ) - 1 ) / (2);
        v.y := -( ( ( 2.0 * Y ) / Height ) - 1) / (2);
        v.z :=  1.0;

        D3DXMatrixInverse( m, nil, myscreen.matview);
        // This is the direction of the ray from the mouse cursor into the scene...
        rayDir.x := v.x*m._11 + v.y*m._21 + v.z*m._31;
        rayDir.y := v.x*m._12 + v.y*m._22 + v.z*m._32;
        rayDir.z := (v.x*m._13 + v.y*m._23 + v.z*m._33);

        // This is the position of rayDir's head.
        rayOrigin.x := m._41;
        rayOrigin.y := m._42;
        rayOrigin.z := m._43;

        c:=0;
        while ((rayOrigin.z < inclicky-0.7) or (rayOrigin.z > inclicky+0.7))
            and ((rayOrigin.x < inclickx-0.7) or (rayOrigin.x > inclickx+0.7)) and (c<500) do begin
            rayOrigin.x := rayOrigin.x + rayDir.x;
            rayOrigin.y := rayOrigin.y + rayDir.y;
            rayOrigin.z := rayOrigin.z + rayDir.z;
            inc(c);
        end;
        if stype = 1 then begin
            mymonst[selected].PositionY:=rayOrigin.Y-inclickz+mymonstz[selected];
            floor[sfloor].Monster[selected].Pos_Z:=(rayOrigin.Y-inclickz)-miz[Floor[sfloor].Monster[selected].map_section];


            sel3d.SetCoordinate(mymonst[selected].PositionX ,
                floor[sfloor].Monster[selected].Pos_z+miz[Floor[sfloor].Monster[selected].map_section]+0.5,
                mymonst[selected].Positionz );

        end;
        if stype = 2 then begin
            MyObj[selected].PositionY:=rayOrigin.y-inclickz;
            floor[sfloor].Obj[selected].Pos_Z:=(rayOrigin.Y-inclickz)-miz[Floor[sfloor].Obj[selected].map_section];

            sel3d.SetCoordinate(MyObj[selected].PositionX ,
                floor[sfloor].obj[selected].Pos_Z+miz[Floor[sfloor].obj[selected].Map_Section]+0.5,
                MyObj[selected].Positionz );
        end;

    end;

    if inclick then
    if  (shift = [ssright,ssleft]) or ((shift = [ssleft]) and rty) then begin
    isedited:=true;
         i:=(lmx-x)*200;
         if stype = 1 then begin
         dec(floor[sfloor].Monster[selected].Direction , i);
         GenerateMonsterName(Floor[sfloor].Monster[selected],selected,2);
         end;
         if stype = 2 then begin
             dec(floor[sfloor].obj[selected].unknow6 , i);
             myobj[selected].Free;
             Generateobj(floor[sfloor].obj[selected],selected);
         end;
    end;

    if inclick then
    if ((shift = [ssleft]) and rtx) then begin
    isedited:=true;
         i:=(lmx-x)*200;
         if stype = 2 then begin
             dec(floor[sfloor].obj[selected].unknow5 , i);
             myobj[selected].Free;
             Generateobj(floor[sfloor].obj[selected],selected);
         end;
    end;

    if inclick then
    if ((shift = [ssleft]) and rtz) then begin
    isedited:=true;
         i:=(lmx-x)*200;
         if stype = 2 then begin
             dec(floor[sfloor].obj[selected].unknow7 , i);
             myobj[selected].Free;
             Generateobj(floor[sfloor].obj[selected],selected);
         end;
    end;

    lmx:=x;
    lmy:=y;
end;

procedure TForm13.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var v,rayOrigin,rayDir:TD3DXVECTOR3;
    m,n:TD3DXMATRIX;
    i,c,u1,u2,d1,d2:integer;
begin
    lmx:=x;
    lmy:=y;

    v.x :=  (( ( ( 2.0 * X ) / clientWidth ) - 1 ) / (2))*1.1;
    v.y := (-( ( ( 2.0 * Y ) / clientHeight ) - 1) / (2))/1.4;
    v.z :=  1.0;

    D3DXMatrixInverse( m, nil, myscreen.matview);
    // This is the direction of the ray from the mouse cursor into the scene...
    rayDir.x := ((v.x*m._11) + (v.y*m._21) + (v.z*m._31));
    rayDir.y := ((v.x*m._12) + (v.y*m._22) + (v.z*m._32));
    rayDir.z := ((v.x*m._13) + (v.y*m._23) + (v.z*m._33));

    // This is the position of rayDir's head.
    rayOrigin.x := m._41;
    rayOrigin.y := m._42;
    rayOrigin.z := m._43;

    //here goes trought all the monster to select
    for c:=0 to 400 do begin
        rayOrigin.x := rayOrigin.x + (rayDir.x);
        rayOrigin.y := rayOrigin.y + (rayDir.y);
        rayOrigin.z := rayOrigin.z + (rayDir.z);
        for i:=0 to floor[sfloor].MonsterCount-1 do
            if mymonst[i].Visible then begin
            d1:=mymonst[i].SizeDownX;
            u1:=mymonst[i].SizeUpX;
            d2:=mymonst[i].SizeDownz;
            u2:=mymonst[i].SizeUpz;
            if d1 < -13 then d1:=-13 ;
            if d2 < -13 then d2:=-13 ;
            if u1 > 13 then u1:=13 ;
            if u2 > 13 then u2:=13 ;
            if (rayOrigin.x >= mymonst[i].PositionX+d1) and (rayOrigin.x<=mymonst[i].PositionX+u1)
                and (rayOrigin.y >= mymonst[i].Positiony+mymonst[i].SizeDownY)
                and (rayOrigin.y <= mymonst[i].Positiony+mymonst[i].SizeUpY)
                and (rayOrigin.z >= mymonst[i].PositionZ+d2) and (rayOrigin.z<=mymonst[i].PositionZ+u2) then begin
                    selected:=i;
                    inclickz:=rayOrigin.y;
                    inclickx:=rayOrigin.x;
                    inclicky:=rayOrigin.z;
                    inclick:=true;
                    stype:=1;
                    form1.ListBox1.ItemIndex:=i;
                    form1.drawmap;
                    break;
                end;
        end;
        if i < floor[sfloor].MonsterCount then break;

        for i:=0 to floor[sfloor].ObjCount-1 do
        if MyObj[i].visible then begin
            if (rayOrigin.x >= MyObj[i].PositionX+MyObj[i].SizeDownX) and (rayOrigin.x<=MyObj[i].PositionX+MyObj[i].SizeUpX)
                and (rayOrigin.y >= MyObj[i].Positiony+MyObj[i].SizeDownY)
                and (rayOrigin.y <= MyObj[i].Positiony+MyObj[i].SizeUpY)
                and (rayOrigin.z >= MyObj[i].PositionZ+MyObj[i].SizeDownZ) and (rayOrigin.z<=MyObj[i].PositionZ+MyObj[i].SizeUpZ) then begin
                    selected:=i;
                    inclickz:=rayOrigin.y;
                    inclickx:=rayOrigin.x;
                    inclicky:=rayOrigin.z;
                    inclick:=true;
                    stype:=2;
                    form1.ListBox2.ItemIndex:=i;
                    form1.drawmap;
                    break;
                end;
        end;
        if i < floor[sfloor].ObjCount then break;
        
    end;

end;


{
// Map your mouse screen-coordinates to normalized coordinates in (-1,...,1). Save them in a 3-vector. Assign the Z-coordinate to 1.
D3DXVECTOR3 v;
v.x =  ( ( ( 2.0f * mouse_X ) / ScreenWidth ) - 1 ) / (2);
v.y = -( ( ( 2.0f * mouse_Y ) / ScreenHeight ) - 1) / (2);
v.z =  1.0f;

// Find the inverse of the view matrix and save it in 'm'. Also, define two new vectors to hold the ray origin and direction...
D3DXMATRIX m;
D3DXVECTOR3 rayOrigin,rayDir;
D3DXMatrixInverse( &m, NULL, &(ViewMatrix));

// This is the direction of the ray from the mouse cursor into the scene...
rayDir.x = v.x*m._11 + v.y*m._21 + v.z*m._31;
rayDir.y = v.x*m._12 + v.y*m._22 + v.z*m._32;
rayDir.z = v.x*m._13 + v.y*m._23 + v.z*m._33;

// This is the position of rayDir's head.
rayOrigin.x = m._41;
rayOrigin.y = m._42;
rayOrigin.z = m._43;
                        }

procedure TForm13.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    if inclick then form1.DrawMap;
    inclick:=false;
end;

procedure TForm13.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    timer1.Enabled:=false;
    have3d:=false;
end;

procedure TForm13.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key < 256 then
    Keys[key]:=true;
end;

procedure TForm13.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if key = 'd' then dta:=dta xor 1;
    if key = 'f' then fog:=fog xor 1;
    // Auto-rotate monster/object 90 degrees
    if key = 'r' then
    begin
      if sType = 1 then
      begin
        floor[sfloor].Monster[selected].Direction := rtinc;
        GenerateMonsterName(Floor[sfloor].Monster[selected],selected,2);
      end;
      if sType = 2 then
      begin
        floor[sfloor].Obj[selected].unknow6 := rtinc;
        myobj[selected].Free;
        Generateobj(floor[sfloor].obj[selected],selected);
      end;
      // Increment for next rotation
      if rtinc <= 49152 then
        rtinc := rtinc + 16384
      else rtinc := 0;
    end;
end;

procedure TForm13.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key < 256 then
    Keys[key]:=false;
end;

end.
