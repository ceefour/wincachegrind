object fEditor: TfEditor
  Left = 549
  Top = 427
  Width = 320
  Height = 240
  ActiveControl = he
  Caption = 'Editor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    00000000000000000000000000000000FFFFFFFF00000000F0000FFF00000000
    FFFFFFFF00000000F000000F00000000FFFFFFFF00000000F000000F00000000
    FFFFFFFF00000000F000FFFF00000000FFFFF00000000000F00FF0F000000000
    FFFFF0000000000000000000000000000000000000000000000000000000FFFF
    0000E0070000E0070000E0070000E0070000E0070000E0070000E0070000E007
    0000E0070000E0070000E00F0000E01F0000E03F0000FFFF0000FFFF0000}
  OldCreateOrder = True
  Position = poDefault
  ScreenSnap = True
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 312
    Height = 26
    AutoSize = True
    BorderWidth = 1
    Caption = 'ToolBar1'
    EdgeBorders = []
    Flat = True
    Images = fMain.il
    TabOrder = 0
    object ToolButton1: TToolButton
      Left = 0
      Top = 0
      Action = aFileSave
    end
    object ToolButton2: TToolButton
      Left = 23
      Top = 0
      Action = aFileClose
    end
    object ToolButton3: TToolButton
      Left = 46
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object ToolButton4: TToolButton
      Left = 54
      Top = 0
      Action = aFileRevertToSaved
    end
  end
  object he: TJvHLEditor
    Left = 0
    Top = 26
    Width = 312
    Height = 180
    Cursor = crIBeam
    GutterWidth = 0
    RightMarginColor = clSilver
    Completion.ItemHeight = 13
    Completion.Interval = 800
    Completion.ListBoxStyle = lbStandard
    Completion.CaretChar = '|'
    Completion.CRLF = '/n'
    Completion.Separator = '='
    TabStops = '5 9 13 17 21 25 29 33 37 41 45 49 53 57 61 65 69 73 77'
    SmartTab = False
    BackSpaceUnindents = False
    SelForeColor = clHighlightText
    SelBackColor = clHighlight
    OnGetLineAttr = heGetLineAttr
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabStop = True
    UseDockManager = False
    Highlighter = hlPhp
    Colors.Comment.Style = [fsItalic]
    Colors.Comment.ForeColor = clOlive
    Colors.Comment.BackColor = clWindow
    Colors.Number.ForeColor = clNavy
    Colors.Number.BackColor = clWindow
    Colors.Strings.ForeColor = clPurple
    Colors.Strings.BackColor = clWindow
    Colors.Symbol.ForeColor = clBlue
    Colors.Symbol.BackColor = clWindow
    Colors.Reserved.Style = [fsBold]
    Colors.Reserved.ForeColor = clWindowText
    Colors.Reserved.BackColor = clWindow
    Colors.Identifier.ForeColor = clWindowText
    Colors.Identifier.BackColor = clWindow
    Colors.Preproc.ForeColor = clGreen
    Colors.Preproc.BackColor = clWindow
    Colors.FunctionCall.ForeColor = clWindowText
    Colors.FunctionCall.BackColor = clWindow
    Colors.Declaration.ForeColor = clWindowText
    Colors.Declaration.BackColor = clWindow
    Colors.Statement.Style = [fsBold]
    Colors.Statement.ForeColor = clWindowText
    Colors.Statement.BackColor = clWindow
    Colors.PlainText.ForeColor = clWindowText
    Colors.PlainText.BackColor = clWindow
  end
  object al: TActionList
    Images = fMain.il
    Left = 184
    Top = 60
    object aFileClose: TAction
      Caption = 'Close'
      Hint = 'Close|Closes the current file.'
      ImageIndex = 5
      OnExecute = aFileCloseExecute
    end
    object aFileSave: TAction
      Caption = 'Save'
      Hint = 'Save|Saves the current file.'
      ImageIndex = 22
      ShortCut = 16467
      OnExecute = aFileSaveExecute
      OnUpdate = aFileSaveUpdate
    end
    object aFileRevertToSaved: TAction
      Caption = 'Revert to Saved'
      Hint = 'Revert to Saved|Reloads the file and discards any changes.'
      ImageIndex = 21
      OnExecute = aFileRevertToSavedExecute
      OnUpdate = aFileRevertToSavedUpdate
    end
  end
  object tUpdateStatus: TTimer
    Interval = 100
    OnTimer = tUpdateStatusTimer
    Left = 24
    Top = 172
  end
end
