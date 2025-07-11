object Form16: TForm16
  Left = 192
  Top = 114
  BorderStyle = bsDialog
  Caption = 'About'
  ClientHeight = 304
  ClientWidth = 332
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poMainFormCenter
  TextHeight = 13
  object Label1: TLabel
    Left = 20
    Top = 14
    Width = 284
    Height = 24
    Caption = 'PSO Quest Editor by Schthack'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 20
    Top = 44
    Width = 222
    Height = 20
    Caption = 'Suport pso DC, PC, GC, BB'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Memo1: TMemo
    Left = 20
    Top = 84
    Width = 293
    Height = 181
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'Credit:'
      ''
      'Coder:'
      'Schthack'
      ''
      'First ASM file:'
      'Myria'
      'Clara'
      ''
      'ASM Update:'
      'Lee '#9#9#9'(over 50% of the asm)'
      'Aleron Ives'#9#9
      'Gatten'
      'Schthack'
      ''
      'Quest file format:'
      'Schthack'
      'Lee'#9#9#9'(chalenge mode data)'
      ''
      '3D Maps structure:'
      'Schthack'
      ''
      '3D model structure:'
      'Kryslin '
      ''
      'Object and Monster model research:'
      'Lee'
      'Schthack'
      'Firefox'
      ''
      'Special thanks to:'
      'AleronIves'
      'Lee'
      'Firefox276'
      'for theire suggestion and being very good'
      'guinea pigs')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Button1: TButton
    Left = 134
    Top = 276
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = Button1Click
  end
end
