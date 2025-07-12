object Form7: TForm7
  Left = 192
  Top = 114
  BorderStyle = bsDialog
  Caption = 'Edit'
  ClientHeight = 445
  ClientWidth = 462
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 13
  object Image1: TImage
    Left = 350
    Top = 22
    Width = 105
    Height = 200
    OnDblClick = Image1DblClick
  end
  object Label1: TLabel
    Left = 350
    Top = 4
    Width = 46
    Height = 13
    Caption = 'Y position'
  end
  object Label2: TLabel
    Left = 104
    Top = 416
    Width = 125
    Height = 13
    Caption = 'Base Y value of the zone: '
  end
  object Label3: TLabel
    Left = 274
    Top = 416
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Image2: TImage
    Left = 350
    Top = 230
    Width = 105
    Height = 93
    OnMouseDown = Image2MouseDown
  end
  object Button1: TButton
    Left = 12
    Top = 412
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = Button1Click
  end
  object TrackBar1: TTrackBar
    Left = 392
    Top = 16
    Width = 19
    Height = 213
    Max = 1500
    Min = -1500
    Orientation = trVertical
    Frequency = 10
    TabOrder = 1
    ThumbLength = 15
    TickMarks = tmBoth
    TickStyle = tsNone
    OnChange = TrackBar1Change
  end
  object StringGrid1: TStringGrid
    Left = 4
    Top = 4
    Width = 333
    Height = 400
    ColCount = 2
    DefaultRowHeight = 18
    FixedCols = 0
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    ParentFont = False
    TabOrder = 2
    OnEnter = StringGrid1Enter
    OnExit = StringGrid1Exit
    OnSelectCell = StringGrid1SelectCell
    OnSetEditText = StringGrid1SetEditText
    ColWidths = (
      132
      175)
  end
  object chkAutoAxis: TCheckBox
    Left = 371
    Top = 329
    Width = 75
    Height = 17
    Caption = 'Auto-axis'
    TabOrder = 3
    OnMouseUp = chkAutoAxisMouseUp
  end
end
