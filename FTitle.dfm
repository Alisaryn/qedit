object Form2: TForm2
  Left = 192
  Top = 114
  BorderStyle = bsDialog
  Caption = 'Quest title'
  ClientHeight = 71
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poMainFormCenter
  TextHeight = 13
  object Label1: TLabel
    Left = 12
    Top = 14
    Width = 29
    Height = 13
    Caption = 'Title : '
  end
  object Button1: TButton
    Left = 224
    Top = 32
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 12
    Top = 32
    Width = 203
    Height = 21
    AutoSize = False
    MaxLength = 32
    TabOrder = 0
  end
end
