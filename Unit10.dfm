object Form10: TForm10
  Left = 278
  Top = 250
  BorderStyle = bsDialog
  Caption = 'Add Objects'
  ClientHeight = 177
  ClientWidth = 382
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poMainFormCenter
  TextHeight = 13
  object Label1: TLabel
    Left = 194
    Top = 18
    Width = 116
    Height = 13
    Caption = 'Select an object to add :'
  end
  object ComboBox1: TComboBox
    Left = 194
    Top = 36
    Width = 177
    Height = 22
    Style = csOwnerDrawFixed
    Sorted = True
    TabOrder = 0
    OnChange = ComboBox1Change
  end
  object Button1: TButton
    Left = 294
    Top = 138
    Width = 77
    Height = 25
    Caption = 'Add'
    Default = True
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 194
    Top = 138
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Panel1: TPanel
    Left = 6
    Top = 14
    Width = 177
    Height = 149
    TabOrder = 3
  end
  object UnicodeStringGrid1: TStringGrid
    Left = 196
    Top = 62
    Width = 173
    Height = 18
    BorderStyle = bsNone
    ColCount = 2
    DefaultRowHeight = 18
    RowCount = 1
    FixedRows = 0
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goEditing]
    ParentFont = False
    TabOrder = 4
    ColWidths = (
      64
      103)
  end
  object UnicodeStringGrid2: TStringGrid
    Left = 196
    Top = 62
    Width = 173
    Height = 54
    BorderStyle = bsNone
    ColCount = 2
    DefaultRowHeight = 18
    RowCount = 3
    FixedRows = 0
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goEditing]
    ParentFont = False
    TabOrder = 5
    Visible = False
    ColWidths = (
      64
      103)
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Left = 336
    Top = 82
  end
end
