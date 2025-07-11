object Form13: TForm13
  Left = 192
  Top = 114
  Caption = '3D View'
  ClientHeight = 475
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OnClose = FormClose
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnKeyUp = FormKeyUp
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnShow = FormShow
  TextHeight = 13
  object Timer1: TTimer
    Interval = 25
    OnTimer = Timer1Timer
    Left = 58
    Top = 8
  end
end
