object Form9: TForm9
  Left = 271
  Top = 204
  BorderStyle = bsDialog
  Caption = 'Add Monster'
  ClientHeight = 169
  ClientWidth = 345
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poMainFormCenter
  TextHeight = 13
  object Label1: TLabel
    Left = 170
    Top = 6
    Width = 127
    Height = 13
    Caption = 'Select the monster to add :'
  end
  object Image1: TImage
    Left = 6
    Top = 8
    Width = 150
    Height = 150
  end
  object Label2: TLabel
    Left = 170
    Top = 60
    Width = 63
    Height = 13
    Caption = 'Set to wave :'
  end
  object ComboBox1: TComboBox
    Left = 168
    Top = 24
    Width = 165
    Height = 22
    Style = csOwnerDrawFixed
    Sorted = True
    TabOrder = 0
    OnChange = ComboBox1Change
  end
  object Button1: TButton
    Left = 256
    Top = 132
    Width = 75
    Height = 25
    Caption = 'Add'
    Default = True
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 170
    Top = 132
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = Button2Click
  end
  object SpinEdit1: TSpinEdit
    Left = 262
    Top = 56
    Width = 71
    Height = 22
    MaxValue = 128
    MinValue = 0
    TabOrder = 3
    Value = 0
  end
end
