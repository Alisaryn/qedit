object Form11: TForm11
  Left = 368
  Top = 155
  BorderStyle = bsDialog
  Caption = 'Description'
  ClientHeight = 189
  ClientWidth = 202
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poMainFormCenter
  TextHeight = 13
  object Label1: TLabel
    Left = 10
    Top = 8
    Width = 84
    Height = 13
    Caption = 'Long descriptoin: '
  end
  object Button1: TButton
    Left = 64
    Top = 158
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = Button1Click
  end
  object UnicodeMemo1: TMemo
    Left = 6
    Top = 26
    Width = 189
    Height = 125
    TabOrder = 0
  end
end
