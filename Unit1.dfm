object Form1: TForm1
  Left = 337
  Top = 255
  Width = 918
  Height = 548
  Caption = #1052#1072#1088#1082#1080#1088#1086#1074#1082#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 649
    Top = 32
    Height = 485
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 910
    Height = 32
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 0
    object PlusButton: TSpeedButton
      Left = 688
      Top = 1
      Width = 30
      Height = 30
      GroupIndex = 1
      Caption = '+'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object MinusButton: TSpeedButton
      Left = 728
      Top = 1
      Width = 30
      Height = 30
      GroupIndex = 1
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object KIZ: TEdit
      Left = 5
      Top = 6
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object OKButton: TButton
      Left = 776
      Top = 3
      Width = 65
      Height = 25
      Caption = 'OK'
      Default = True
      TabOrder = 1
      OnClick = OKButtonClick
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 32
    Width = 649
    Height = 485
    Align = alLeft
    DataSource = DataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'STATUS'
        Title.Caption = #1057#1090#1074#1090#1091#1089
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'KIZ'
        Title.Caption = #1052#1072#1088#1082#1080#1088#1086#1074#1082#1072
        Width = 456
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'QUANT'
        Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'IndAttr'
        Title.Caption = #1048#1085#1076#1091#1089#1090#1088#1080#1072#1083#1100#1085#1099#1081' '#1072#1090#1090#1088#1080#1073#1091#1090#1098
        Visible = True
      end>
  end
  object Panel2: TPanel
    Left = 652
    Top = 32
    Width = 258
    Height = 485
    Align = alClient
    TabOrder = 2
    OnResize = Panel2Resize
    object NOTE: TLabel
      Left = 8
      Top = 40
      Width = 3
      Height = 13
    end
    object NOMEN_CODE: TEdit
      Left = 8
      Top = 8
      Width = 177
      Height = 21
      TabOrder = 0
    end
    object NOMEN_NAME: TRichEdit
      Left = 8
      Top = 64
      Width = 217
      Height = 369
      TabOrder = 1
    end
    object AddButton: TButton
      Left = 8
      Top = 440
      Width = 217
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 2
    end
  end
  object MT: TRxMemoryData
    Active = True
    FieldDefs = <
      item
        Name = 'KIZ'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'QUANT'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Q1'
        DataType = ftInteger
      end
      item
        Name = 'Q2'
        DataType = ftInteger
      end
      item
        Name = 'IndAttr'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'STATUS'
        DataType = ftString
        Size = 20
      end>
    Left = 144
    Top = 96
  end
  object DataSource1: TDataSource
    DataSet = MT
    Left = 280
    Top = 48
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 488
    Top = 112
  end
end
