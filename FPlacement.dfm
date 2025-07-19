object FPlacementOptions: TFPlacementOptions
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Placement Options'
  ClientHeight = 450
  ClientWidth = 217
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 95
    Width = 10
    Height = 13
    Caption = 'Z:'
  end
  object Label2: TLabel
    Left = 32
    Top = 65
    Width = 10
    Height = 13
    Caption = 'Y:'
  end
  object Label3: TLabel
    Left = 32
    Top = 35
    Width = 10
    Height = 13
    Caption = 'X:'
  end
  object Label4: TLabel
    Left = 31
    Top = 221
    Width = 10
    Height = 13
    Caption = 'Y:'
  end
  object Label5: TLabel
    Left = 31
    Top = 251
    Width = 10
    Height = 13
    Caption = 'Z:'
  end
  object Label6: TLabel
    Left = 31
    Top = 191
    Width = 10
    Height = 13
    Caption = 'X:'
  end
  object Label7: TLabel
    Left = 31
    Top = 161
    Width = 39
    Height = 13
    Caption = 'Section:'
  end
  object Label8: TLabel
    Left = 27
    Top = 319
    Width = 106
    Height = 13
    Caption = 'Snap tolerance (units):'
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 8
    Width = 185
    Height = 121
    Caption = 'Offset selection'
    TabOrder = 0
  end
  object GroupBox3: TGroupBox
    Left = 16
    Top = 135
    Width = 185
    Height = 148
    Caption = 'Default placement'
    TabOrder = 15
  end
  object btnSave: TButton
    Left = 72
    Top = 376
    Width = 75
    Height = 25
    Caption = 'Save'
    Default = True
    TabOrder = 13
    OnClick = btnSaveClick
  end
  object seDefaultSect: TSpinEdit
    Left = 112
    Top = 158
    Width = 73
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 4
    Value = 0
  end
  object seSnapTolerance: TSpinEdit
    Left = 148
    Top = 316
    Width = 41
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 10
    Value = 0
  end
  object nbOffsetX: TNumberBox
    Left = 112
    Top = 38
    Width = 73
    Height = 21
    Decimal = 3
    Mode = nbmFloat
    TabOrder = 1
  end
  object nbOffsetY: TNumberBox
    Left = 112
    Top = 65
    Width = 73
    Height = 21
    Decimal = 3
    Mode = nbmFloat
    TabOrder = 2
  end
  object nbOffsetZ: TNumberBox
    Left = 112
    Top = 92
    Width = 73
    Height = 21
    Decimal = 3
    Mode = nbmFloat
    TabOrder = 3
  end
  object nbDefaultZ: TNumberBox
    Left = 112
    Top = 249
    Width = 73
    Height = 21
    Decimal = 3
    Mode = nbmFloat
    TabOrder = 7
  end
  object nbDefaultY: TNumberBox
    Left = 112
    Top = 220
    Width = 73
    Height = 21
    Decimal = 3
    Mode = nbmFloat
    TabOrder = 6
  end
  object nbDefaultX: TNumberBox
    Left = 112
    Top = 191
    Width = 73
    Height = 21
    Decimal = 3
    Mode = nbmFloat
    TabOrder = 5
  end
  object btnReset: TButton
    Left = 72
    Top = 407
    Width = 75
    Height = 25
    Caption = 'Defaults'
    TabOrder = 14
    OnClick = btnResetClick
  end
  object chkSnapRotate: TCheckBox
    Left = 23
    Top = 289
    Width = 98
    Height = 17
    Caption = 'Snap rotation'
    TabOrder = 8
  end
  object chkSnapDistance: TCheckBox
    Left = 112
    Top = 289
    Width = 98
    Height = 17
    Caption = 'Snap distance'
    TabOrder = 9
  end
  object seDistanceLimit: TSpinEdit
    Left = 148
    Top = 344
    Width = 41
    Height = 22
    Enabled = False
    MaxValue = 0
    MinValue = 0
    TabOrder = 12
    Value = 0
  end
  object chkDistancelimit: TCheckBox
    Left = 28
    Top = 346
    Width = 111
    Height = 17
    Caption = 'Anchor limit (units):'
    TabOrder = 11
    OnClick = chkDistanceLimitClick
  end
end
