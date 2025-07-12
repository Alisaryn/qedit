object FPlacementOptions: TFPlacementOptions
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Placement Options'
  ClientHeight = 443
  ClientWidth = 249
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 24
    Top = 95
    Width = 10
    Height = 15
    Caption = 'Z:'
  end
  object Label2: TLabel
    Left = 24
    Top = 65
    Width = 10
    Height = 15
    Caption = 'Y:'
  end
  object Label3: TLabel
    Left = 24
    Top = 35
    Width = 10
    Height = 15
    Caption = 'X:'
  end
  object Label4: TLabel
    Left = 23
    Top = 237
    Width = 10
    Height = 15
    Caption = 'Y:'
  end
  object Label5: TLabel
    Left = 23
    Top = 267
    Width = 10
    Height = 15
    Caption = 'Z:'
  end
  object Label6: TLabel
    Left = 23
    Top = 207
    Width = 10
    Height = 15
    Caption = 'X:'
  end
  object Label7: TLabel
    Left = 23
    Top = 177
    Width = 42
    Height = 15
    Caption = 'Section:'
  end
  object Label8: TLabel
    Left = 24
    Top = 322
    Width = 118
    Height = 15
    Caption = 'Snap tolerance (units):'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 233
    Height = 121
    Caption = 'Offset selection'
    TabOrder = 0
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 146
    Width = 233
    Height = 159
    Caption = 'Default placement'
    TabOrder = 12
  end
  object btnSave: TButton
    Left = 87
    Top = 374
    Width = 75
    Height = 25
    Caption = 'Save'
    Default = True
    TabOrder = 10
    OnClick = btnSaveClick
  end
  object seDefaultSect: TSpinEdit
    Left = 104
    Top = 174
    Width = 121
    Height = 24
    MaxValue = 0
    MinValue = 0
    TabOrder = 4
    Value = 0
  end
  object seSnapTolerance: TSpinEdit
    Left = 168
    Top = 319
    Width = 57
    Height = 24
    MaxValue = 0
    MinValue = 0
    TabOrder = 8
    Value = 0
  end
  object nbOffsetX: TNumberBox
    Left = 104
    Top = 32
    Width = 121
    Height = 23
    Decimal = 3
    Mode = nbmFloat
    TabOrder = 1
  end
  object nbOffsetY: TNumberBox
    Left = 104
    Top = 65
    Width = 121
    Height = 23
    Decimal = 3
    Mode = nbmFloat
    TabOrder = 2
  end
  object nbOffsetZ: TNumberBox
    Left = 104
    Top = 94
    Width = 121
    Height = 23
    Decimal = 3
    Mode = nbmFloat
    TabOrder = 3
  end
  object nbDefaultZ: TNumberBox
    Left = 104
    Top = 265
    Width = 121
    Height = 23
    Decimal = 3
    Mode = nbmFloat
    TabOrder = 7
  end
  object nbDefaultY: TNumberBox
    Left = 104
    Top = 236
    Width = 121
    Height = 23
    Decimal = 3
    Mode = nbmFloat
    TabOrder = 6
  end
  object nbDefaultX: TNumberBox
    Left = 104
    Top = 207
    Width = 121
    Height = 23
    Decimal = 3
    Mode = nbmFloat
    TabOrder = 5
  end
  object btnReset: TButton
    Left = 87
    Top = 405
    Width = 75
    Height = 25
    Caption = 'Defaults'
    TabOrder = 11
    OnClick = btnResetClick
  end
  object chkSnapRotate: TCheckBox
    Left = 23
    Top = 343
    Width = 98
    Height = 17
    Caption = 'Snap rotation'
    TabOrder = 9
  end
end
