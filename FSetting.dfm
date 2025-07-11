object Form6: TForm6
  Left = 192
  Top = 114
  BorderStyle = bsDialog
  Caption = 'Common setting'
  ClientHeight = 134
  ClientWidth = 232
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poOwnerFormCenter
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 18
    Width = 57
    Height = 13
    Caption = 'Language : '
  end
  object Label2: TLabel
    Left = 18
    Top = 54
    Width = 77
    Height = 13
    Caption = 'Quest Number : '
  end
  object ComboBox1: TComboBox
    Left = 114
    Top = 16
    Width = 103
    Height = 22
    Style = csOwnerDrawFixed
    ItemIndex = 1
    TabOrder = 0
    Text = 'English'
    Items.Strings = (
      'Korean / Japanese / Chinesse'
      'English'
      'German'
      'Francais'
      'Spanish')
  end
  object SpinEdit1: TSpinEdit
    Left = 114
    Top = 54
    Width = 101
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 1
    Value = 0
  end
  object Button1: TButton
    Left = 72
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    TabOrder = 2
    OnClick = Button1Click
  end
end
