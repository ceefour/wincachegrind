unit uOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, uConfig, Mask, JvToolEdit,
  JvMaskEdit, JvSpin, JvExMask;

type
  TfOptions = class(TForm)
    Panel1: TPanel;
    bOK: TButton;
    bCancel: TButton;
    pc: TPageControl;
    tsDisplay: TTabSheet;
    tsPrivacy: TTabSheet;
    GroupBox1: TGroupBox;
    cbTrackMRU: TCheckBox;
    cbClearMRUOnExit: TCheckBox;
    Label1: TLabel;
    cbTimeDisplay: TComboBox;
    cbShowFullPath: TCheckBox;
    cbHideLibFuncs: TCheckBox;
    bClearMRU: TButton;
    Label2: TLabel;
    tsMain: TTabSheet;
    Label3: TLabel;
    deWorkingDir: TJvDirectoryEdit;
    cbHideFastFuncs: TCheckBox;
    Label4: TLabel;
    seFastThreshold: TJvSpinEdit;
    seMaxMRUCount: TJvSpinEdit;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure bClearMRUClick(Sender: TObject);
  private
    function GetConfig: TConfig;
    { Private declarations }
  public
    { Public declarations }
    property Config: TConfig read GetConfig;
  end;

var
  fOptions: TfOptions;

implementation

{$R *.dfm}

uses uMain;

procedure TfOptions.FormCreate(Sender: TObject);
begin
  pc.ActivePageIndex := 0;
  // fill stuff
  // Main
  deWorkingDir.Text := Config.WorkingDir;
  // Display
  cbTimeDisplay.ItemIndex := Ord(Config.TimeDisplay);
  cbHideFastFuncs.Checked := Config.HideFastFuncs;
  seFastThreshold.Value := Config.FastThreshold;
  cbHideLibFuncs.Checked := Config.HideLibFuncs;
  cbShowFullPath.Checked := Config.ShowFullPath;
  // privacy
  cbTrackMRU.Checked := Config.TrackMRU;
  cbClearMRUOnExit.Checked := Config.ClearMRUOnExit;
  seMaxMRUCount.Value := Config.MaxMRUCount;
end;

procedure TfOptions.bOKClick(Sender: TObject);
begin
  // save stuff
  // Main
  Config.WorkingDir := deWorkingDir.Text;
  // Display
  Config.TimeDisplay := TTimeDisplay(cbTimeDisplay.ItemIndex);
  Config.HideFastFuncs := cbHideFastFuncs.Checked;
  Config.FastThreshold := seFastThreshold.AsInteger;
  Config.HideLibFuncs := cbHideLibFuncs.Checked;
  Config.ShowFullPath := cbShowFullPath.Checked;
  // Privacy
  Config.TrackMRU := cbTrackMRU.Checked;
  Config.ClearMRUOnExit := cbClearMRUOnExit.Checked;
  Config.MaxMRUCount := seMaxMRUCount.AsInteger;
  // then save
  Config.Save;
  ModalResult := mrOk;
end;

function TfOptions.GetConfig: TConfig;
begin
  Result := fMain.Config;
end;

procedure TfOptions.bClearMRUClick(Sender: TObject);
begin
  Config.ClearMRU;
  MessageDlg('Recent list cleared.', mtInformation, [mbOK], 0);
end;

end.
