object Form32: TForm32
  Left = 0
  Top = 0
  Caption = 'Vector list'
  ClientHeight = 412
  ClientWidth = 670
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 13
  object StringGrid1: TStringGrid
    Left = 0
    Top = 0
    Width = 670
    Height = 329
    Align = alTop
    ColCount = 6
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goFixedRowDefAlign]
    TabOrder = 0
    OnKeyPress = StringGrid1KeyPress
    OnSelectCell = StringGrid1SelectCell
    OnSetEditText = StringGrid1SetEditText
    ColWidths = (
      104
      108
      110
      100
      102
      115)
    RowHeights = (
      24
      24
      24
      24
      24)
  end
  object Button1: TButton
    Left = 8
    Top = 335
    Width = 57
    Height = 25
    Caption = 'Up'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 71
    Top = 335
    Width = 57
    Height = 25
    Caption = 'Down'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 338
    Top = 335
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 248
    Top = 335
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 4
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 570
    Top = 368
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 5
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 480
    Top = 368
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 6
    OnClick = Button6Click
  end
end
