object fOptions: TfOptions
  Left = 221
  Top = 175
  ActiveControl = pc
  BorderStyle = bsDialog
  BorderWidth = 8
  Caption = 'Options'
  ClientHeight = 280
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  ScreenSnap = True
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 245
    Width = 400
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    object bOK: TButton
      Left = 0
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = bOKClick
    end
    object bCancel: TButton
      Left = 80
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object pc: TPageControl
    Left = 0
    Top = 0
    Width = 400
    Height = 245
    ActivePage = tsDisplay
    Align = alClient
    TabOrder = 0
    object tsMain: TTabSheet
      Caption = 'Main'
      ImageIndex = 2
      object Label3: TLabel
        Left = 8
        Top = 8
        Width = 72
        Height = 13
        Caption = 'Working folder:'
      end
      object deWorkingDir: TJvDirectoryEdit
        Left = 92
        Top = 4
        Width = 297
        Height = 21
        DialogKind = dkWin32
        DialogText = 'Browse for folder'
        ButtonHint = 'Browse|Browses for a folder.'
        ButtonFlat = True
        TabOrder = 0
        Text = 'deWorkingDir'
      end
    end
    object tsDisplay: TTabSheet
      Caption = 'Display'
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 94
        Height = 13
        Caption = 'Default time display:'
      end
      object Label4: TLabel
        Left = 196
        Top = 52
        Width = 50
        Height = 13
        Caption = 'Threshold:'
      end
      object Label5: TLabel
        Left = 328
        Top = 52
        Width = 56
        Height = 13
        Caption = 'milliseconds'
      end
      object cbTimeDisplay: TComboBox
        Left = 120
        Top = 4
        Width = 137
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        Items.Strings = (
          'Milliseconds'
          'Percentages')
      end
      object cbShowFullPath: TCheckBox
        Left = 8
        Top = 32
        Width = 245
        Height = 17
        Caption = 'Show full path as default'
        TabOrder = 1
      end
      object cbHideLibFuncs: TCheckBox
        Left = 8
        Top = 72
        Width = 213
        Height = 17
        Caption = 'Hide library functions as default'
        TabOrder = 4
      end
      object cbHideFastFuncs: TCheckBox
        Left = 8
        Top = 52
        Width = 169
        Height = 17
        Caption = 'Hide fast functions as default'
        TabOrder = 2
      end
      object seFastThreshold: TJvSpinEdit
        Left = 260
        Top = 48
        Width = 65
        Height = 21
        Alignment = taRightJustify
        Thousands = True
        MaxValue = 1000.000000000000000000
        MinValue = 1.000000000000000000
        Value = 1.000000000000000000
        TabOrder = 3
      end
    end
    object tsPrivacy: TTabSheet
      Caption = 'Privacy'
      ImageIndex = 1
      DesignSize = (
        392
        217)
      object GroupBox1: TGroupBox
        Left = 4
        Top = 4
        Width = 381
        Height = 93
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Recent files'
        TabOrder = 0
        object Label2: TLabel
          Left = 8
          Top = 68
          Width = 151
          Height = 13
          Caption = 'Maximum number of recent files:'
        end
        object cbTrackMRU: TCheckBox
          Left = 8
          Top = 16
          Width = 365
          Height = 17
          Caption = 'Track recently opened files'
          TabOrder = 0
        end
        object cbClearMRUOnExit: TCheckBox
          Left = 8
          Top = 36
          Width = 161
          Height = 17
          Caption = 'Clear recent list on exit'
          TabOrder = 1
        end
        object bClearMRU: TButton
          Left = 180
          Top = 32
          Width = 125
          Height = 25
          Caption = 'Clear recent list now'
          TabOrder = 2
          OnClick = bClearMRUClick
        end
        object seMaxMRUCount: TJvSpinEdit
          Left = 176
          Top = 64
          Width = 49
          Height = 21
          Alignment = taRightJustify
          MaxValue = 9.000000000000000000
          MinValue = 1.000000000000000000
          Value = 1.000000000000000000
          TabOrder = 3
        end
      end
    end
  end
end
