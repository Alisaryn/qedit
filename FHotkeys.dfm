object fmHotkeys: TfmHotkeys
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Placement Modifiers'
  ClientHeight = 203
  ClientWidth = 282
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 38
    Height = 16
    Caption = '[Ctrl]:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 30
    Width = 33
    Height = 16
    Caption = '[Alt]:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 52
    Width = 45
    Height = 16
    Caption = '[Shift]:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 8
    Top = 74
    Width = 26
    Height = 16
    Caption = '[D]:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 8
    Top = 96
    Width = 24
    Height = 16
    Caption = '[F]:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 8
    Top = 118
    Width = 25
    Height = 16
    Caption = '[S]:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 75
    Top = 9
    Width = 28
    Height = 15
    Caption = 'Copy'
  end
  object Label8: TLabel
    Left = 75
    Top = 119
    Width = 55
    Height = 15
    Caption = 'Snap align'
  end
  object Label9: TLabel
    Left = 75
    Top = 97
    Width = 158
    Height = 15
    Caption = 'Set at offset selection position'
  end
  object Label10: TLabel
    Left = 75
    Top = 75
    Width = 115
    Height = 15
    Caption = 'Set at default position'
  end
  object Label11: TLabel
    Left = 75
    Top = 31
    Width = 164
    Height = 15
    Caption = 'Disable automatic Y placement'
  end
  object Label12: TLabel
    Left = 75
    Top = 53
    Width = 195
    Height = 15
    Caption = 'Disable automatic section placement'
  end
  object Label13: TLabel
    Left = 8
    Top = 140
    Width = 41
    Height = 16
    Caption = '[Esc]:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label14: TLabel
    Left = 75
    Top = 140
    Width = 95
    Height = 15
    Caption = 'Cancel placement'
  end
  object btnClose: TButton
    Left = 95
    Top = 169
    Width = 75
    Height = 25
    Caption = 'Close'
    Default = True
    TabOrder = 0
    OnClick = btnCloseClick
  end
end
