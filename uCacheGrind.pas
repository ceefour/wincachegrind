{**
 * Cache grind parser unit.
 *
 * First, some terminology:
 *
 * Function: A function definition.
 * Instance: An execution of a function.
 * Main: The main program.
 * Section: Subprograms that get executed. This is at least the main program,
 *   plus additional destructors, exit procedures, etc.
 *
 * Total time: The sum of time of all instances of a function.
 * Average time: The average time of all instances of a function.
 * Self time: The time spent by a function exclusive of the called functions.
 * Cum time: The time spent by a function including all of its called functions.
 *}

unit uCacheGrind;

interface

uses Classes, SysUtils, JclStrHashMap, RegExpr;

type
  // Types
  (**
   * Time in milliseconds.
   *)
  TProfTime = Double;

  (**
   * These are good for display purposes.
   *)
  TFuncKind = (fkUnknown, fkRoot, fkSection, fkFunc, fkConstructor, fkDestructor,
    fkPublicMethod, fkPrivateMethod, fkStaticMethod, fkInclude, fkLibFunc);

  TProgressEvent = procedure(Sender: TObject; Position, Max: Integer;
    Status: string) of object;

  // Forward definitions
  TProfInstance = class;
  TProfFunc = class;
  TCacheGrind = class;

  {**
   * An "instance" of a function.
   *}
  TProfInstance = class
  private
    FCalls: TList;
    FFunc: TProfFunc;
    FCumTime: TProfTime;
    FSelfTime: TProfTime;
    FLine: Integer;
    FCaller: TProfInstance;
    FParserLine: Integer;
    FParserCallLine: Integer;
    FIndex: Integer;
    FData: TObject;
    function GetCalls(AIndex: Integer): TProfInstance;
    function GetCacheGrind: TCacheGrind;
    function GetName: string;
    function GetCallCount: Integer;
    function GetFileName: string;
    function GetKind: TFuncKind;
    function GetCumPercent: Double;
    function GetSelfPercent: Double;
    function GetShortFileName: string;
    function GetShortName: string;
  public
    property CacheGrind: TCacheGrind read GetCacheGrind;
    property CallCount: Integer read GetCallCount;
    property Caller: TProfInstance read FCaller write FCaller;
    (**
     * A list of instances that this instance calls.
     *
     * Note that the objects in this list are not managed or freed
     * by {@link TProfInstance}, but instead they're managed by
     * their respective {@link TProfFunc}.
     *)
    property Calls[AIndex: Integer]: TProfInstance read GetCalls;
    (**
     * Cum stands for cumulative.
     *
     * I know it sounds "funny". So don't get horny! ;-)
     *)
    property CumPercent: Double read GetCumPercent;
    (**
     * Cum stands for cumulative.
     *
     * I know it sounds "funny". So don't get horny! ;-)
     *)
    property CumTime: TProfTime read FCumTime write FCumTime;
    (**
     * Any user-specified data. You can use this e.g. for user interfaces.
     *)
    property Data: TObject read FData write FData;
    (**
     * Shortcut for Func.FileName.
     *)
    property FileName: string read GetFileName;
    property Func: TProfFunc read FFunc;
    (**
     * Index in TProfFunc Instances list.
     *)
    property Index: Integer read FIndex;
    (**
     * Shortcut for Func.Kind.
     *)
    property Kind: TFuncKind read GetKind;
    {**
     * The line number of the function call in the source instance.
     *}
    property Line: Integer read FLine write FLine;
    (**
     * Shortcut for Func.Name.
     *)
    property Name: string read GetName;
    property ParserCallLine: Integer read FParserCallLine write FParserCallLine;
    property ParserLine: Integer read FParserLine write FParserLine;
    property SelfTime: TProfTime read FSelfTime write FSelfTime;
    property SelfPercent: Double read GetSelfPercent;
    property ShortFileName: string read GetShortFileName;
    property ShortName: string read GetShortName;

    procedure Analyze;
    constructor Create(AFunc: TProfFunc; AIndex: Integer);
    destructor Destroy; override;
    procedure GetMerged(AList: TList);
    procedure InsertCall(AIndex: Integer; ATarget: TProfInstance);
    procedure Reset;
  end;

  {**
   * Function information.
   *}
  TProfFunc = class
  private
    FFileName: string;
    FInstances: TList;
    FName: string;
    FCacheGrind: TCacheGrind;
    FKind: TFuncKind;
    FTotCumTime: TProfTime;
    FTotSelfTime: TProfTime;
    function GetInstances(AIndex: Integer): TProfInstance;
    function GetInstanceCount: Integer;
    function GetShortFileName: string;
    function GetShortName: string;
    function GetAvgCumPercent: Double;
    function GetAvgCumTime: TProfTime;
    function GetAvgSelfPercent: Double;
    function GetAvgSelfTime: TProfTime;
    function GetTotCumPercent: Double;
    function GetTotSelfPercent: Double;
  public
    property AvgCumPercent: Double read GetAvgCumPercent;
    property AvgCumTime: TProfTime read GetAvgCumTime;
    property AvgSelfPercent: Double read GetAvgSelfPercent;
    property AvgSelfTime: TProfTime read GetAvgSelfTime;
    property CacheGrind: TCacheGrind read FCacheGrind;
    property FileName: string read FFileName;
    property InstanceCount: Integer read GetInstanceCount;
    property Instances[AIndex: Integer]: TProfInstance read GetInstances;
    property Kind: TFuncKind read FKind write FKind;
    property Name: string read FName;
    property ShortFileName: string read GetShortFileName;
    property ShortName: string read GetShortName;
    property TotCumPercent: Double read GetTotCumPercent;
    property TotCumTime: TProfTime read FTotCumTime;
    property TotSelfPercent: Double read GetTotSelfPercent;
    property TotSelfTime: TProfTime read FTotSelfTime;

    function AddInstance: TProfInstance;
    procedure Analyze;
    constructor Create(ACacheGrind: TCacheGrind;
      AName, AFileName: string);
    destructor Destroy; override;
    function IndexOfInstance(AInst: TProfInstance): Integer;
    procedure Reset;
  end;

  {**
   * CacheGrind parser engine.
   *}
  TCacheGrind = class
  private
    FFuncs: TList;
    FCmd: string;
    FMain: TProfInstance;
    FSections: TList;
    FVersion: string;
    FRoot: TProfInstance;
    FOnLoadProgress: TProgressEvent;
    FOnAnalyzeProgress: TProgressEvent;
    FAnalyzeMax: Integer;
    FAnalyzePosition: Integer;
    FOwner: TObject;
    FSummaryExists: Boolean;
    FMap: TStringHashMap;
    FMapTraits: TCaseSensitiveTraits;
    function CreateInstance(AName, AFileName: string): TProfInstance;
    function GetFuncs(AIndex: Integer): TProfFunc;
    function GetFuncCount: Integer;
    function GetSectionCount: Integer;
    function GetSections(AIndex: Integer): TProfInstance;
  public
    property AnalyzePosition: Integer read FAnalyzePosition write FAnalyzePosition;
    property AnalyzeMax: Integer read FAnalyzeMax;
    property Cmd: string read FCmd;
    property FuncCount: Integer read GetFuncCount;
    property Funcs[AIndex: Integer]: TProfFunc read GetFuncs;
    property Main: TProfInstance read FMain;
    (**
     * A map of function names to function definitions.
     *
     * This is used to speed up loading profiler file and finding a function definition.
     *)
    property Map: TStringHashMap read FMap;
    property MapTraits: TCaseSensitiveTraits read FMapTraits;
    property OnAnalyzeProgress: TProgressEvent read FOnAnalyzeProgress write FOnAnalyzeProgress;
    property OnLoadProgress: TProgressEvent read FOnLoadProgress write FOnLoadProgress;
    property Owner: TObject read FOwner;
    property Root: TProfInstance read FRoot;
    property SectionCount: Integer read GetSectionCount;
    (**
     * List of sections.
     *
     * Note that the instances here are managed by each {@link TProfFunc},
     * so the list here only stores pointers, but do not manage or free the
     * objects.
     *
     * This is actually a shortcut for Root.Calls.
     *)
    property Sections[AIndex: Integer]: TProfInstance read GetSections;
    {**
     * Determines whether the profiler file contains a "summary:" line.
     *
     * If this is False, it usually means the file is not valid.
     *}
    property SummaryExists: Boolean read FSummaryExists;
    property Version: string read FVersion;

    procedure Clear;
    constructor Create(AOwner: TObject);
    destructor Destroy; override;
    function FindFunc(AName: string): TProfFunc;
    {**
     * Loads and parses a cachegrind.out file.
     *
     * Development note: Please don't use any regex here (for speed).
     * You can freely use regex on other parts of the code, maybe
     * except Analyze()-related.
     *
     * @param HeaderOnly If True, it will only parse the header and
     *   then return.
     *}
    procedure Load(AFileName: string; HeaderOnly: Boolean = False);
    procedure ReAnalyze;
    procedure Reset;
  end;

implementation

(**
 * Compares time with threshold (10 microsecond)
 *)
function SameTime(A, B: TProfTime): Boolean;
begin
  if Abs(A-B) < 0.010 then
    Result := True
  else
    Result := False;
end;

{ TProfInstance }

procedure TProfInstance.Analyze;
var
  I: Integer;
begin
  // report
  CacheGrind.AnalyzePosition := CacheGrind.AnalyzePosition + 1;
  // be a bit lazy so updates won't be too fast
  if CacheGrind.AnalyzePosition mod 1000 = 0 then begin
    if Assigned(CacheGrind.OnAnalyzeProgress) then begin
      CacheGrind.OnAnalyzeProgress(CacheGrind,
        CacheGrind.AnalyzePosition, CacheGrind.AnalyzeMax,
        'Analyzing '+ Name +'...');
    end;
  end;
  // propagate
  for I := 0 to CallCount - 1 do begin
    Calls[I].Analyze;
  end;
  // special case
  if Kind in [fkRoot, fkSection] then begin
    CumTime := SelfTime;
    for I := 0 to CallCount - 1 do begin
      CumTime := CumTime + Calls[I].CumTime;
    end;
  end;
end;

constructor TProfInstance.Create(AFunc: TProfFunc; AIndex: Integer);
begin
  inherited Create;
  FFunc := AFunc;
  FCalls := TList.Create;
  FIndex := AIndex;
end;

destructor TProfInstance.Destroy;
begin
  // we do NOT free objects in FCalls
  FCalls.Free;
  inherited;
end;

function TProfInstance.GetCacheGrind: TCacheGrind;
begin
  Result := Func.CacheGrind;
end;

function TProfInstance.GetCallCount: Integer;
begin
  Result := FCalls.Count;
end;

function TProfInstance.GetCalls(AIndex: Integer): TProfInstance;
begin
  Result := TProfInstance(FCalls[AIndex]);
end;

function TProfInstance.GetCumPercent: Double;
begin
  if (Caller = nil) or (Caller.CumTime <= 0) then
    Result := 100.0
  else
    Result := CumTime * 100.0 / Caller.CumTime;
end;

function TProfInstance.GetFileName: string;
begin
  Result := Func.FileName;
end;

function TProfInstance.GetKind: TFuncKind;
begin
  Result := Func.Kind;
end;

(**
 * Returns merged function calls from this instance
 * and all its children.
 *
 * Before calling, make sure AList is empty.
 *
 * Returned value is a list of TProfFunc.
 * @param AList Output.
 *)
procedure TProfInstance.GetMerged(AList: TList);
var
  I: Integer;
begin
  for I := 0 to CallCount - 1 do begin
    if AList.IndexOf(Calls[I].Func) < 0 then
      AList.Add(Calls[I].Func);
    Calls[I].GetMerged(AList);
  end;
end;

function TProfInstance.GetName: string;
begin
  Result := Func.Name;
end;

function TProfInstance.GetSelfPercent: Double;
begin
  if (Caller = nil) or (Caller.CumTime <= 0) then
    Result := 0.0
  else
    Result := SelfTime * 100.0 / Caller.CumTime;
end;

function TProfInstance.GetShortFileName: string;
begin
  Result := Func.ShortFileName;
end;

function TProfInstance.GetShortName: string;
begin
  Result := Func.ShortName;
end;

procedure TProfInstance.InsertCall(AIndex: Integer; ATarget: TProfInstance);
begin
  FCalls.Insert(AIndex, ATarget);
  ATarget.Caller := Self;
end;

procedure TProfInstance.Reset;
var
  I: Integer;
begin
  // reset this instance

  // propagate
  for I := 0 to CallCount - 1 do
    Calls[I].Reset;
end;

{ TProfFunc }

function TProfFunc.AddInstance: TProfInstance;
var
  Inst: TProfInstance;
begin
  Inst := TProfInstance.Create(Self, FInstances.Count);
  FInstances.Add(Inst);
  Result := Inst;
end;

procedure TProfFunc.Analyze;
var
  I: Integer;
begin
  for I := 0 to InstanceCount - 1 do begin
    FTotCumTime := FTotCumTime + Instances[I].CumTime;
    FTotSelfTime := FTotSelfTime + Instances[I].SelfTime;
  end;
end;

constructor TProfFunc.Create(ACacheGrind: TCacheGrind; AName,
  AFileName: string);

function IsCons(S: string): Boolean;
var
  I: Integer;
  A, B: string;
begin
  I := Pos('->', S);
  if I >= 1 then begin
    A := Copy(S, 1, I - 1);
    B := Copy(S, I + 2, Length(S) - I - 1);
    Result := A = B;
  end else
    Result := False;
end;

function IsDest(S: string): Boolean;
var
  I: Integer;
  A, B: string;
begin
  I := Pos('->', S);
  if I >= 1 then begin
    A := Copy(S, 1, I - 1);
    B := Copy(S, I + 2, Length(S) - I - 1);
    Result := B = '_' + A;
  end else
    Result := False;
end;

begin
  inherited Create;
  FCacheGrind := ACacheGrind;
  FName := AName;
  FFileName := AFileName;
  FInstances := TList.Create;
  // analyze Name to get Kind
  FKind := fkFunc;
  if (Pos('include::', AName) = 1)
    or (Pos('include_once::', AName) = 1)
    or (Pos('require::', AName) = 1)
    or (Pos('require_once::', AName) = 1) then
    FKind := fkInclude
  else if (Pos('php::', AName) = 1) then
    FKind := fkLibFunc
  else if IsCons(AName) then
    FKind := fkConstructor
  else if IsDest(AName) then
    FKind := fkDestructor
  else if (Pos('->object', AName) <> 0)
    or (Pos('__construct', AName) <> 0)
    or (Pos('::pear', AName) <> 0) then
    FKind := fkConstructor
  else if (Pos('__destruct', AName) <> 0)
    or (Pos('_object', AName) <> 0)
    or (Pos('::_pear', AName) <> 0) then
    FKind := fkDestructor
  else if (Pos('::_', AName) <> 0) or (Pos('->_', AName) <> 0) then
    FKind := fkPrivateMethod
  else if (Pos('::', AName) <> 0) then
    FKind := fkStaticMethod
  else if Pos('->', AName) <> 0 then
    FKind := fkPublicMethod;
end;

destructor TProfFunc.Destroy;
var
  I: Integer;
begin
  for I := 0 to FInstances.Count - 1 do
    TProfInstance(FInstances[I]).Free;
  FInstances.Free;
  inherited;
end;

function TProfFunc.GetAvgCumPercent: Double;
begin
  if CacheGrind.Root.CumTime > 0 then
    Result := AvgCumTime * 100.0 / CacheGrind.Root.CumTime
  else
    Result := 100.0;
end;

function TProfFunc.GetAvgCumTime: TProfTime;
begin
  Result := TotCumTime / InstanceCount;
end;

function TProfFunc.GetAvgSelfPercent: Double;
begin
  if CacheGrind.Root.CumTime > 0 then
    Result := AvgSelfTime * 100.0 / CacheGrind.Root.CumTime
  else
    Result := 0.0;
end;

function TProfFunc.GetAvgSelfTime: TProfTime;
begin
  Result := TotSelfTime / InstanceCount;
end;

function TProfFunc.GetInstanceCount: Integer;
begin
  Result := FInstances.Count;
end;

function TProfFunc.GetInstances(AIndex: Integer): TProfInstance;
begin
  Result := TProfInstance(FInstances[AIndex]);
end;

function TProfFunc.GetShortFileName: string;
begin
  if Pos('php:', FFileName) <> 1 then
    Result := ExtractFileName(FFileName)
  else
    Result := FFileName;
end;

function TProfFunc.GetShortName: string;
var
  I: Integer;
begin
  if Kind = fkRoot then
    Result := ExtractFileName(FName)
  else begin
    if (Pos('include::', FName) = 1) or (Pos('include_once::', FName) = 1)
      or (Pos('require::', FName) = 1) or (Pos('require_once::', FName) = 1) then
    begin
      I := Pos('::', FName);
      Result := Copy(FName, 1, I + 1) + ExtractFileName(Copy(FName, I + 2, Length(FName) - I - 1));
    end else
      Result := FName;
  end;
end;

function TProfFunc.GetTotCumPercent: Double;
begin
  if CacheGrind.Root.CumTime > 0 then
    Result := TotCumTime * 100.0 / CacheGrind.Root.CumTime
  else
    Result := 100.0;
end;

function TProfFunc.GetTotSelfPercent: Double;
begin
  if CacheGrind.Root.CumTime > 0 then
    Result := TotSelfTime * 100.0 / CacheGrind.Root.CumTime
  else
    Result := 0.0;
end;

function TProfFunc.IndexOfInstance(AInst: TProfInstance): Integer;
begin
  Result := FInstances.IndexOf(AInst);
end;

procedure TProfFunc.Reset;
begin
  FTotCumTime := 0;
  FTotSelfTime := 0;
end;

{ TCacheGrind }

procedure TCacheGrind.Clear;
var
  I: Integer;
begin
  FCmd := '';
  FMain := nil;
  FRoot := nil;
  for I := 0 to FFuncs.Count - 1 do
    TProfFunc(FFuncs[I]).Free;
  FFuncs.Clear;
  FSections.Clear;
  FMap.Clear;
  FVersion := '';
end;

constructor TCacheGrind.Create;
begin
  inherited Create;
  FOwner := AOwner;
  FFuncs := TList.Create;
  FSections := TList.Create;
  FMapTraits := TCaseSensitiveTraits.Create;
  FMap := TStringHashMap.Create(FMapTraits, 1023);
end;

function TCacheGrind.CreateInstance(AName,
  AFileName: string): TProfInstance;
var
  Func: TProfFunc;
  Inst: TProfInstance;
begin
  Func := FindFunc(AName);
  if Func = nil then begin
    Func := TProfFunc.Create(Self, AName, AFileName);
    FFuncs.Add(Func);
    FMap.Add(Func.Name, Func);
  end;
  Inst := Func.AddInstance;
  Result := Inst;
end;

destructor TCacheGrind.Destroy;
begin
  Clear;
  FreeAndNil(FMap);
  FreeAndNil(FMapTraits);
  FreeAndNil(FSections);
  FreeAndNil(FFuncs);
  inherited;
end;

(**
 * Finds a function with the specified name.
 *
 * Now it uses JCL's TStringHashMap to speed up the search operation.
 * @param AName Function name to find.
 * @return Found function, or nil if not found.
 *)
function TCacheGrind.FindFunc(AName: string): TProfFunc;
begin
  Result := nil;
  FMap.Find(AName, Result);
end;

function TCacheGrind.GetFuncCount: Integer;
begin
  Result := FFuncs.Count;
end;

function TCacheGrind.GetFuncs(AIndex: Integer): TProfFunc;
begin
  Result := TProfFunc(FFuncs[AIndex]);
end;

function TCacheGrind.GetSectionCount: Integer;
begin
  Result := FRoot.CallCount;
end;

function TCacheGrind.GetSections(AIndex: Integer): TProfInstance;
begin
  Result := FRoot.Calls[AIndex];
end;

procedure TCacheGrind.Load(AFileName: string; HeaderOnly: Boolean);
type
  PCallBuffer = ^TCallBuffer;
  TCallBuffer = record
    Name: string;
    Line, ParserLine: Integer;
    CumTime: TProfTime;
  end;

var
  State: (stHeader, stEvents, stBody, stDone);
  F: TextFile;
  S, CurFL, CurFN, A, B: string;
  CurInst, LastInst: TProfInstance;
  Stack, Buffer: TList;
  I, P, ParserLine: Integer;
  Compresseds: TStringHashMap;

function Uncompress(section: string; raw: string): string;
var
  id: string;
  key: string;
  _content: PString;
begin
  with TRegExpr.Create do try
    // check if this is an assignment of compression
    Expression := '\((\d+)\)\s*(.*)';
    if Exec(raw) then begin
      id := Match[1];
      key := section + '-' + id;
      if Match[2] <> '' then begin
        // this is an assignment
        New(_content);
        _content^ := Match[2];
        Compresseds.Add(key, _content);
        Result := Match[2];
      end else begin
        // this is an uncompression
        Result := PString(Compresseds.Data[key])^;
      end;
    end else begin
      // otherwise just return as-is
      Result := raw;
    end;
  finally Free;
  end;
end;

procedure Error(Msg: string);
var
  S: string;
  I: Integer;
  Cur: TProfInstance;
  CB: PCallBuffer;

function FormatInst(Inst: TProfInstance): string;
begin
  Result := Inst.Name +' ('+ Inst.FileName +':'+ IntToStr(Inst.ParserLine) +')'
    + ' Cum:'+ Format('%.0f', [Inst.CumTime*1000]) +' Self:'+ Format('%.0f', [Inst.SelfTime*1000]);
end;

begin
  S := #13#10 + Msg;
  S := S + #13#10 + 'cachegrind.out line number: ' + IntToStr(ParserLine);
  if CurInst = nil then
    S := S + #13#10 + 'CurInst: NULL'
  else
    S := S + #13#10 + 'CurInst: '+ FormatInst(CurInst);
{  if CurTarget = nil then
    S := S + #13#10 + 'CurTarget: NULL'
  else
    S := S + #13#10 + 'CurTarget: '+ FormatInst(CurTarget);}
  if Stack.Count = 0 then
    S := S + #13#10 + 'Stack: empty'
  else begin
    for I := 0 to Stack.Count - 1 do begin
      Cur := TProfInstance(Stack[I]);
      S := S + #13#10 + 'Stack['+ IntToStr(I) +']: '+ FormatInst(Cur);
    end;
  end;
  if Buffer.Count = 0 then
    S := S + #13#10 + 'Call buffer: empty'
  else begin
    for I := 0 to Buffer.Count - 1 do begin
      CB := PCallBuffer(Buffer[I]);
      S := S + #13#10 + 'Call buffer['+ IntToStr(I) +']: '+ CB^.Name +
        ' Line:' + IntToStr(CB^.Line) + ' Cum:' + Format('%.0f', [CB^.CumTime * 1000]);
    end;
  end;
  S := S + #13#10;
  raise Exception.Create(S);
end;

procedure ClearBuffer;
var
  I: Integer;
begin
  for I := 0 to Buffer.Count - 1 do
    Dispose(PCallBuffer(Buffer[I]));
  Buffer.Clear;
end;

  function FreeHashData(AUserData: Pointer; AStr: string; var APtr: PString): Boolean;
  begin
    Dispose(APtr);
    Result := True;
  end;

var
  CurBuf: PCallBuffer;
  Target: TProfInstance;
  TargetIndex: Integer;
  TextBuf: array[0..65535] of Char;
begin
  Clear;
  AssignFile(F, AFileName);
  if HeaderOnly then
    FileMode := fmOpenRead or fmShareDenyNone
  else
    FileMode := fmOpenRead or fmShareDenyWrite;
  System.Reset(F);
  // use bigger text buffer
  SetTextBuf(F, TextBuf, SizeOf(TextBuf));
  try
    State := stHeader;
    CurFL := '';
    CurFN := '';
    CurInst := nil;
    LastInst := nil;
    CurBuf := nil;
    FSummaryExists := False;
    Stack := TList.Create;
    Buffer := TList.Create;
    Compresseds := TStringHashMap.Create(TCaseSensitiveTraits.Create, 100000);
    ParserLine := 1;
    try
      while not Eof(F) do begin
        Readln(F, S);
        case State of
          stHeader: begin
            if Copy(S, 1, 9) = 'version: ' then
              FVersion := Copy(S, 9 + 1, Length(S) - 9)
            else if Copy(S, 1, 5) = 'cmd: ' then
              FCmd := Copy(S, 5 + 1, Length(S) - 5)
            else if S = '' then begin
              if HeaderOnly then
                State := stDone
              else
                State := stEvents;
            end;
          end;
          stEvents: begin
            if S = '' then
              State := stBody;
          end;
          stBody: begin
            if Copy(S, 1, 3) = 'fl=' then begin
              CurFL := Uncompress('fl', Copy(S, 3 + 1, Length(S) - 3) )
            end else if Copy(S, 1, 3) = 'fn=' then begin
              CurFN := Uncompress('fn', Copy(S, 3 + 1, Length(S) - 3) );
              if CurFL = '' then Error('Parser error: fl is not valid.');
              if CurFN = '' then Error('Parser error: fn is not valid.');
              CurInst := CreateInstance(CurFN, CurFL); // TODO: SLOW!
              CurInst.ParserLine := ParserLine;
              Stack.Add(CurInst);
            end else if (Length(S) >= 3) and (S[1] in ['0'..'9']) then begin
              P := Pos(' ', S);
              if P <= 0 then Error('Parser error: Invalid <line> <time> <???> statement.');
              A := Copy(S, 1, P - 1);
              B := Copy(S, P + 1, Length(S) - P);
              // remove the "unknown", or whatever, if exists
              P := Pos(' ', B);
              if (P >= 1) then B := Copy(B, 1, P - 1);
              if CurInst = nil then begin
                if LastInst = Main then
                  CurInst := Main
                else
                  Error('Parser error: Parsing '+ S +': Current instance is NULL.');
              end;
              if CurBuf <> nil then begin
                CurBuf^.Line := StrToInt(A);
                CurBuf^.CumTime := StrToInt64(B) / 1000;
              end else
                CurInst.SelfTime := StrToInt64(B) / 1000;
            end else if Copy(S, 1, 4) = 'cfn=' then begin
              // must have inst first
              if CurInst = nil then Error('Parser error: Parsing '+ S +': Current instance is NULL.');
              // get function name
              A := Uncompress('fn', Copy(S, 4 + 1, Length(S) - 4) );
              // add to call buffer
              New(CurBuf);
              Buffer.Add(CurBuf);
              CurBuf^.Name := A;
              CurBuf^.Line := 0;
              CurBuf^.CumTime := 0;
              CurBuf^.ParserLine := ParserLine;
            end else if Copy(S, 1, 8) = 'summary:' then begin
              // we should have the main instance right here
              if LastInst = nil then Error('Parser error: LastInst should contain main function instance now.');
              FMain := LastInst;
              CurInst := nil;
              FSummaryExists := True;
            end else if S = '' then begin
              // add pending buffers
              // TODO: this is also the slow point
              while Buffer.Count > 0 do begin
                CurBuf := PCallBuffer(Buffer[Buffer.Count - 1]);
                Target := nil;
                TargetIndex := -1;
                // we start from Count - 2 because the last item is always
                // the current instance, so it can't possibly be the target
                for I := Stack.Count - 2 downto 0 do begin
                  if TProfInstance(Stack[I]).Name = CurBuf^.Name then begin
                    Target := TProfInstance(Stack[I]);
                    TargetIndex := I;
                    Break;
                  end;
                end;
                // no target?
                if Target = nil then Error('Cannot find call target.');
                // update target's CumTime: this one is the correct one
                Target.CumTime := CurBuf^.CumTime;
                // set Line as well
                Target.Line := CurBuf^.Line;
                // debug info
                Target.ParserCallLine := CurBuf^.ParserLine;
                // looks OK
                // delete this buffer
                Buffer.Remove(CurBuf);
                Dispose(CurBuf);
                CurBuf := nil;
                // insert this target at the FIRST index
                // since we're doing stack rollup here, we actually
                // have to reverse things a lot (*confusing!!!*)
                CurInst.InsertCall(0, Target);
                // remove from stack
                Stack.Delete(TargetIndex);
              end;
              // then clear, ready for next statement
              CurFL := '';
              CurFN := '';
              // save CurInst, it may well be the main function instance
              if CurInst <> nil then
                LastInst := CurInst;
              CurInst := nil;
            end;
          end;
        end;
        // be a bit lazy on updating
        if ParserLine mod 1000 = 0 then begin
          // call OnLoadProgress
          if Assigned(OnLoadProgress) then begin
            if FileSize(F) > 0 then
              OnLoadProgress(Self, FilePos(F), FileSize(F),
                Format('Parsing... %d%% complete.', [FilePos(F) * 100 div FileSize(F)]));
          end;
        end;
        // post
        Inc(ParserLine);
        // done?
        if State = stDone then
          Break;
      end;
      if not HeaderOnly then begin
        // at this point buffer MUST be empty
        if Buffer.Count <> 0 then Error('Call buffer is not empty.');
        // when we reach here the stack should contain only sections
        // like the main function instance and exit procedures
        if Stack.Count < 1 then Error('Parser error: At this point at least main instance is expected.');
        FRoot := CreateInstance(Cmd, Cmd);
        FRoot.Func.Kind := fkRoot;
        for I := Stack.Count - 1 downto 0 do begin
          CurInst := TProfInstance(Stack[I]);
          // they're sections
          CurInst.Func.Kind := fkSection;
          // add this
          FRoot.InsertCall(0, TProfInstance(Stack[I]));
        end;
        // bye stack
        Stack.Clear;
      end;
    finally
      Compresseds.Iterate(nil, @FreeHashData);
      Compresseds.Free;
      Stack.Free;
      Buffer.Free;
    end;
  finally
    CloseFile(F);
  end;
end;

procedure TCacheGrind.ReAnalyze;
var
  I: Integer;
begin
  Reset;
  // analyze instances
  if Root <> nil then
    Root.Analyze;
  // analyze functions (a bit later)
  for I := 0 to FFuncs.Count - 1 do begin
    TProfFunc(FFuncs[I]).Analyze;
  end;
end;

procedure TCacheGrind.Reset;
var
  I: Integer;
begin
  FAnalyzePosition := 0;
  FAnalyzeMax := 0;
  for I := 0 to FFuncs.Count - 1 do begin
    Inc(FAnalyzeMax, TProfFunc(FFuncs[I]).InstanceCount);
    TProfFunc(FFuncs[I]).Reset;
  end;
  if Root <> nil then
    Root.Reset;
end;

end.
