unit uConfig;

interface

uses Classes;

type
  TTimeDisplay = (tdMs, tdPercent);

  (**
   * Holds configuration options and other system-wide data
   * (sorry, no user-specific stuff).
   *)
  TConfig = class
  private
    FMRU: TStringList;
    FMRUTitles: TStringList;
    FClearMRUOnExit: Boolean;
    FHideLibFuncs: Boolean;
    FTrackMRU: Boolean;
    FShowFullPath: Boolean;
    FTimeDisplay: TTimeDisplay;
    FMaxMRUCount: Integer;
    FWorkingDir: string;
    FHideFastFuncs: Boolean;
    FFastThreshold: Integer;
    FEditorPath: string;
    procedure SetMaxMRUCount(const Value: Integer);
  public
    property ClearMRUOnExit: Boolean read FClearMRUOnExit write FClearMRUOnExit;
    property FastThreshold: Integer read FFastThreshold write FFastThreshold;
    property HideFastFuncs: Boolean read FHideFastFuncs write FHideFastFuncs;
    property HideLibFuncs: Boolean read FHideLibFuncs write FHideLibFuncs;
    property MaxMRUCount: Integer read FMaxMRUCount write SetMaxMRUCount;
    property MRU: TStringList read FMRU;
    property MRUTitles: TStringList read FMRUTitles;
    property TimeDisplay: TTimeDisplay read FTimeDisplay write FTimeDisplay;
    property TrackMRU: Boolean read FTrackMRU write FTrackMRU;
    property ShowFullPath: Boolean read FShowFullPath write FShowFullPath;
    property WorkingDir: string read FWorkingDir write FWorkingDir;
    property EditorPath: string read FEditorPath write FEditorPath;

    procedure AddMRU(AFileName, ATitle: string);
    procedure ClearMRU;
    constructor Create;
    destructor Destroy; override;
    procedure Load;
    procedure PurgeMRU;
    procedure Save;
  end;

implementation

uses IniFiles, SysUtils, Forms, ShlObj;

{ TConfig }

(**
 * Adds an MRU entry.
 *
 * Note that this function will do nothing if TrackMRU is disabled.
 *)
procedure TConfig.AddMRU(AFileName, ATitle: string);
begin
  if not TrackMRU then Exit;
  if MRU.IndexOf(AFileName) >= 0 then begin
    MRUTitles.Delete(MRU.IndexOf(AFileName));
    MRU.Delete(MRU.IndexOf(AFileName));
  end;
  MRU.Insert(0, AFileName);
  MRUTitles.Insert(0, ATitle);
  PurgeMRU;
end;

procedure TConfig.ClearMRU;
begin
  MRU.Clear;
  MRUTitles.Clear;
end;

constructor TConfig.Create;
begin
  FMRU := TStringList.Create;
  FMRUTitles := TStringList.Create;
  // set defaults
  TimeDisplay := tdMs;
  TrackMRU := True;
  MaxMRUCount := 4;
  FastThreshold := 1;
end;

destructor TConfig.Destroy;
begin
  FMRUTitles.Free;
  FMRU.Free;
  inherited;
end;

procedure TConfig.Load;
var
  F: TIniFile;
  I: Integer;
begin
  F := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'WinCacheGrind.ini');
  try
    // Main
    WorkingDir := F.ReadString('Main', 'WorkingDir', WorkingDir);
    // Display
    TimeDisplay := TTimeDisplay(F.ReadInteger('Display', 'TimeDisplay', Ord(TimeDisplay)));
    HideFastFuncs := F.ReadBool('Display', 'HideFastFuncs', HideFastFuncs);
    FastThreshold := F.ReadInteger('Display', 'FastThreshold', FastThreshold);
    HideLibFuncs := F.ReadBool('Display', 'HideLibFuncs', HideLibFuncs);
    ShowFullPath := F.ReadBool('Display', 'ShowFullPath', ShowFullPath);
    // Privacy
    TrackMRU := F.ReadBool('Privacy', 'TrackMRU', TrackMRU);
    ClearMRUOnExit := F.ReadBool('Privacy', 'ClearMRUOnExit', ClearMRUOnExit);
    MaxMRUCount := F.ReadInteger('Privacy', 'MaxMRUCount', MaxMRUCount);
    // MRU
    ClearMRU;
    for I := 0 to F.ReadInteger('MRU', 'Count', 0) - 1 do begin
      MRU.Add(F.ReadString('MRU', 'Entry' + IntToStr(I), ''));
      MRUTitles.Add(F.ReadString('MRU', 'Title' + IntToStr(I), 'Untitled'));
    end;
    //editor
    EditorPath := F.ReadString('Editor', 'EditorPath', '');
  finally
    F.Free;
  end;
end;

(**
 * Deletes excessive MRU entries.
 *)
procedure TConfig.PurgeMRU;
begin
  while MRU.Count > MaxMRUCount do begin
    MRU.Delete(MRU.Count - 1);
    MRUTitles.Delete(MRUTitles.Count - 1);
  end;
end;

procedure TConfig.Save;
var
  F: TIniFile;
  I: Integer;
begin
  F := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'WinCacheGrind.ini');
  try
    // Main
    F.WriteString('Main', 'WorkingDir', WorkingDir);
    // Display
    F.WriteInteger('Display', 'TimeDisplay', Ord(TimeDisplay));
    F.WriteBool('Display', 'HideFastFuncs', HideFastFuncs);
    F.WriteInteger('Display', 'FastThreshold', FastThreshold);
    F.WriteBool('Display', 'HideLibFuncs', HideLibFuncs);
    F.WriteBool('Display', 'ShowFullPath', ShowFullPath);
    // Privacy
    F.WriteBool('Privacy', 'TrackMRU', TrackMRU);
    F.WriteBool('Privacy', 'ClearMRUOnExit', ClearMRUOnExit);
    F.WriteInteger('Privacy', 'MaxMRUCount', MaxMRUCount);
    // MRU
    F.EraseSection('MRU');
    F.WriteInteger('MRU', 'Count', MRU.Count);
    for I := 0 to MRU.Count - 1 do begin
      F.WriteString('MRU', 'Entry' + IntToStr(I), MRU[I]);
      F.WriteString('MRU', 'Title' + IntToStr(I), MRUTitles[I]);
    end;
    //editor
    F.WriteString('Editor', 'EditorPath', EditorPath);
  finally
    F.Free;
  end;
end;

procedure TConfig.SetMaxMRUCount(const Value: Integer);
begin
  FMaxMRUCount := Value;
  PurgeMRU;
end;

end.
