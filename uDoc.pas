unit uDoc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, uCacheGrind, ExtCtrls, ImgList, XPStyleActnCtrls,
  ActnList, ActnMan, ToolWin, Menus, StdCtrls, uConfig, CommCtrl,
  JvCombobox, JvExStdCtrls;

type
  TListLBLSort = (lsFunction, lsSelf, lsCum, lsFileName, lsLine);
  TListMergedSort = (msFunction, msAvgSelf, msAvgCum, msTotSelf, msTotCum, msCalls);
  TMergedInstancesSort = (misIndex, misSelf, misCum, misCaller, misCallerFile);

  TfDoc = class(TForm)
    ilCacheGrind: TImageList;
    il: TImageList;
    am: TActionManager;
    aViewPercent: TAction;
    aViewMs: TAction;
    mm: TMainMenu;
    View1: TMenuItem;
    Milliseconds1: TMenuItem;
    Percentages1: TMenuItem;
    aViewFullPath: TAction;
    N1: TMenuItem;
    FullPath1: TMenuItem;
    aViewHideLibFuncs: TAction;
    N2: TMenuItem;
    HideLibraryFunctions1: TMenuItem;
    aViewGoToUpOneLevel: TAction;
    N3: TMenuItem;
    UpOneLevel1: TMenuItem;
    pmLBL: TPopupMenu;
    aViewGoToOpen: TAction;
    Open1: TMenuItem;
    UpOneLevel2: TMenuItem;
    aMergedInstancesGoTo: TAction;
    pmMergedInstances: TPopupMenu;
    GoTo1: TMenuItem;
    pmTree: TPopupMenu;
    aTreeOpenEditor: TAction;
    Openineditor1: TMenuItem;
    aTreeShowInfo: TAction;
    Showadvancedinformation1: TMenuItem;
    N4: TMenuItem;
    aLBLShowInfo: TAction;
    N5: TMenuItem;
    Showadvancedinformation2: TMenuItem;
    tb: TToolBar;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton6: TToolButton;
    ToolButton3: TToolButton;
    tv: TTreeView;
    Splitter1: TSplitter;
    Panel1: TPanel;
    pcProfiler: TPageControl;
    tsLBL: TTabSheet;
    lvLBL: TListView;
    tsMerged: TTabSheet;
    Splitter2: TSplitter;
    lvMerged: TListView;
    lvMergedInstances: TListView;
    pInfo: TPanel;
    lInfoName: TLabel;
    lInfo: TLabel;
    lInfoFileName: TLabel;
    iInfo: TImage;
    Panel2: TPanel;
    Label1: TLabel;
    Image1: TImage;
    aProfilerFind: TAction;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    N6: TMenuItem;
    Find1: TMenuItem;
    aLBLOpenEditor: TAction;
    N7: TMenuItem;
    Openineditor2: TMenuItem;
    aTreeGoToRoot: TAction;
    GoToRoot1: TMenuItem;
    N8: TMenuItem;
    UpOneLevel3: TMenuItem;
    GoToRoot2: TMenuItem;
    GoToRoot3: TMenuItem;
    pmMerged: TPopupMenu;
    UpOneLevel4: TMenuItem;
    GoToRoot4: TMenuItem;
    aMergedInstancesOpenEditor: TAction;
    aMergedInstancesShowInfo: TAction;
    N9: TMenuItem;
    N10: TMenuItem;
    Showadvancedinformation3: TMenuItem;
    Openineditor3: TMenuItem;
    aLBLShowOverall: TAction;
    aTreeShowOverall: TAction;
    N11: TMenuItem;
    N12: TMenuItem;
    ShowOverall2: TMenuItem;
    aTreeExpand: TAction;
    aTreeCollapse: TAction;
    aTreeExpandAll: TAction;
    N13: TMenuItem;
    Expand1: TMenuItem;
    ExpandAll1: TMenuItem;
    Collapse1: TMenuItem;
    ShowOverall1: TMenuItem;
    aViewHideFastFuncs: TAction;
    HideFastFunctions1: TMenuItem;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    cbRE: TCheckBox;
    cbFind: TJvComboBox;
    tFind: TTimer;
    lFind: TLabel;
    Panel3: TPanel;
    lMerged: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lvLBLData(Sender: TObject; Item: TListItem);
    procedure tvChange(Sender: TObject; Node: TTreeNode);
    procedure lvLBLDblClick(Sender: TObject);
    procedure lvLBLKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure aViewPercentUpdate(Sender: TObject);
    procedure aViewMsUpdate(Sender: TObject);
    procedure aViewPercentExecute(Sender: TObject);
    procedure aViewMsExecute(Sender: TObject);
    procedure tvExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure aViewFullPathExecute(Sender: TObject);
    procedure aViewFullPathUpdate(Sender: TObject);
    procedure lvMergedData(Sender: TObject; Item: TListItem);
    procedure lvLBLColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvMergedColumnClick(Sender: TObject; Column: TListColumn);
    procedure aViewHideLibFuncsUpdate(Sender: TObject);
    procedure aViewHideLibFuncsExecute(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure aViewGoToUpOneLevelUpdate(Sender: TObject);
    procedure aViewGoToUpOneLevelExecute(Sender: TObject);
    procedure lvMergedInstancesData(Sender: TObject; Item: TListItem);
    procedure aViewGoToOpenUpdate(Sender: TObject);
    procedure aViewGoToOpenExecute(Sender: TObject);
    procedure lvMergedInstancesColumnClick(Sender: TObject;
      Column: TListColumn);
    procedure aMergedInstancesGoToUpdate(Sender: TObject);
    procedure aMergedInstancesGoToExecute(Sender: TObject);
    procedure lvMergedInstancesDblClick(Sender: TObject);
    procedure lvMergedInstancesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure aTreeOpenEditorUpdate(Sender: TObject);
    procedure aTreeOpenEditorExecute(Sender: TObject);
    procedure tvKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure aTreeShowInfoUpdate(Sender: TObject);
    procedure aLBLShowInfoUpdate(Sender: TObject);
    procedure aLBLShowInfoExecute(Sender: TObject);
    procedure aTreeShowInfoExecute(Sender: TObject);
    procedure tvCollapsing(Sender: TObject; Node: TTreeNode;
      var AllowCollapse: Boolean);
    procedure lvMergedSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure aProfilerFindExecute(Sender: TObject);
    procedure cbFindChange(Sender: TObject);
    procedure aLBLOpenEditorUpdate(Sender: TObject);
    procedure aLBLOpenEditorExecute(Sender: TObject);
    procedure aTreeGoToRootExecute(Sender: TObject);
    procedure aTreeGoToRootUpdate(Sender: TObject);
    procedure aMergedInstancesOpenEditorUpdate(Sender: TObject);
    procedure aMergedInstancesOpenEditorExecute(Sender: TObject);
    procedure aMergedInstancesShowInfoUpdate(Sender: TObject);
    procedure aMergedInstancesShowInfoExecute(Sender: TObject);
    procedure aLBLShowOverallExecute(Sender: TObject);
    procedure aLBLShowOverallUpdate(Sender: TObject);
    procedure aTreeShowOverallExecute(Sender: TObject);
    procedure aTreeShowOverallUpdate(Sender: TObject);
    procedure aTreeExpandUpdate(Sender: TObject);
    procedure aTreeExpandExecute(Sender: TObject);
    procedure aTreeCollapseUpdate(Sender: TObject);
    procedure aTreeCollapseExecute(Sender: TObject);
    procedure aTreeExpandAllUpdate(Sender: TObject);
    procedure aTreeExpandAllExecute(Sender: TObject);
    procedure aViewHideFastFuncsUpdate(Sender: TObject);
    procedure aViewHideFastFuncsExecute(Sender: TObject);
    procedure tFindTimer(Sender: TObject);
    procedure cbFindSelect(Sender: TObject);
    procedure cbREClick(Sender: TObject);
  private
    FFileName: string;
    FCacheGrind: TCacheGrind;
    FListLBL, FListMerged, FMergedInstances: TList;
    FTimeDisplay: TTimeDisplay;
    FUseShortName: Boolean;
    FListLBLSort: TListLBLSort;
    FListMergedSort: TListMergedSort;
    FHideLibFuncs: Boolean;
    FMergedInstancesSort: TMergedInstancesSort;
    FHideFastFuncs: Boolean;
    { Private declarations }
    function AddToTree(Parent: TTreeNode; Inst: TProfInstance; Cascade: Boolean): TTreeNode;
    procedure CacheGrindAnalyzeProgress(Sender: TObject; Position, Max: Integer; Status: string);
    procedure CacheGrindLoadProgress(Sender: TObject; Position, Max: Integer; Status: string);
    function GetImageIndex(Kind: TFuncKind): Integer;
    procedure SetTimeDisplay(const Value: TTimeDisplay);
    procedure SetUseShortName(const Value: Boolean);
    procedure SetListLBLSort(const Value: TListLBLSort);
    procedure SetListMergedSort(const Value: TListMergedSort);
    procedure SetHideLibFuncs(const Value: Boolean);
    function GetConfig: TConfig;
    procedure SetMergedInstancesSort(const Value: TMergedInstancesSort);
    procedure SetHideFastFuncs(const Value: Boolean);
  public
    { Public declarations }
    property CacheGrind: TCacheGrind read FCacheGrind;
    property Config: TConfig read GetConfig;
    property FileName: string read FFileName;
    property HideFastFuncs: Boolean read FHideFastFuncs write SetHideFastFuncs;
    property HideLibFuncs: Boolean read FHideLibFuncs write SetHideLibFuncs;
    property ListLBLSort: TListLBLSort read FListLBLSort write SetListLBLSort;
    property ListMergedSort: TListMergedSort read FListMergedSort write SetListMergedSort;
    property MergedInstancesSort: TMergedInstancesSort read FMergedInstancesSort write SetMergedInstancesSort;
    property TimeDisplay: TTimeDisplay read FTimeDisplay write SetTimeDisplay;
    property UseShortName: Boolean read FUseShortName write SetUseShortName;

    procedure ClearListLBL;
    procedure ClearListMerged;
    procedure ClearListMergedInstances;
    procedure ClearLists;
    procedure ClearTree;
    function FormatMs(Ms: TProfTime): string;
    function FormatPercent(Percent: Double): string;
    procedure Open(AFileName: string);
    procedure RefreshTree;
    procedure RefreshListLBL;
    procedure RefreshListMerged;
    procedure RefreshListMergedInstances;
    procedure RefreshLists;
    procedure Reload;
    procedure RepaintLists;
    procedure SelectLBLInstance(AInst: TProfInstance);
    procedure SelectListItem(LV: TListView; AIndex: Integer);
    procedure SelectMergedFunc(AFunc: TProfFunc);
    procedure SelectTreeInstance(AInst: TProfInstance);
    procedure SelectTreeNode(Node: TTreeNode);
    procedure ShowInfo(AInst: TProfInstance);
    procedure ShowMerged(AFunc: TProfFunc);
    procedure SyncTree;
    procedure SyncTreeNode(ANode: TTreeNode);
    procedure UpdateInfo;
  end;

implementation

uses uWait, uMain, RegExpr;

{$R *.dfm}

function CompareDouble(A, B: Double): Integer;
begin
  if A > B then
    Result := 1
  else if B > A then
    Result := -1
  else
    Result := 0;
end;

function LBLSort(A, B: Pointer): Integer;
var
  Form: TfDoc;
  IA, IB: TProfInstance;
begin
  Result := 0;
  IA := TProfInstance(A);
  IB := TProfInstance(B);
  Form := IA.CacheGrind.Owner as TfDoc;
  case Form.ListLBLSort of
    lsFunction: Result := CompareText(IA.Name, IB.Name);
    lsSelf: Result := -CompareDouble(IA.SelfTime, IB.SelfTime);
    lsCum: Result := -CompareDouble(IA.CumTime, IB.CumTime);
    lsFileName: Result := CompareText(IA.FileName, IB.FileName);
  end;
  if Result = 0 then
    Result := CompareText(IA.Name, IB.Name);
end;

function MergedSort(A, B: Pointer): Integer;
var
  Form: TfDoc;
  FA, FB: TProfFunc;
begin
  Result := 0;
  FA := TProfFunc(A);
  FB := TProfFunc(B);
  Form := FA.CacheGrind.Owner as TfDoc;
  case Form.ListMergedSort of
    msFunction: Result := CompareText(FA.Name, FB.Name);
    msAvgSelf: Result := -CompareDouble(FA.AvgSelfTime, FB.AvgSelfTime);
    msAvgCum: Result := -CompareDouble(FA.AvgCumTime, FB.AvgCumTime);
    msTotSelf: Result := -CompareDouble(FA.TotSelfTime, FB.TotSelfTime);
    msTotCum: Result := -CompareDouble(FA.TotCumTime, FB.TotCumTime);
    msCalls: Result := FB.InstanceCount - FA.InstanceCount;
  end;
  if Result = 0 then
    Result := CompareText(FA.Name, FB.Name);
end;

function MergedInstancesSort(A, B: Pointer): Integer;
var
  Form: TfDoc;
  IA, IB: TProfInstance;
begin
  Result := 0;
  IA := TProfInstance(A);
  IB := TProfInstance(B);
  Form := IA.CacheGrind.Owner as TfDoc;
  case Form.MergedInstancesSort of
    misIndex: Result := IA.Index - IB.Index;
    misSelf: Result := -CompareDouble(IA.SelfTime, IB.SelfTime);
    misCum: Result := -CompareDouble(IA.CumTime, IB.CumTime);
    misCaller: Result := CompareText(IA.Caller.Name, IB.Caller.Name);
    misCallerFile: begin
      Result := CompareText(IA.Caller.FileName, IB.Caller.FileName);
      if Result = 0 then
        Result := IA.Line - IB.Line;
    end;
  end;
  if Result = 0 then
    Result := IA.Index - IB.Index;
end;

{ TfDoc }

procedure TfDoc.Open(AFileName: string);
begin
  fWait := TfWait.Create(Self);
  try
    fWait.Show;
    // clear stuff
    ClearLists;
    ClearTree;
    // parse
    CacheGrind.Load(AFileName);
    // add this to MRU
    Config.AddMRU(AFileName, CacheGrind.Cmd);
    // ok
    FFileName := AFileName;
    Caption := CacheGrind.Cmd + ' (' + ExtractFileName(FileName) + ')';
    // Analyzing
    CacheGrind.ReAnalyze;
    // update
    fWait.lWait.Caption := 'Updating tree view...';
    fWait.Update;
    RefreshTree;
    RefreshLists;
    UpdateInfo;
  finally
    fWait.Free;
  end;
end;

procedure TfDoc.FormCreate(Sender: TObject);
begin
  FCacheGrind := TCacheGrind.Create(Self);
  FCacheGrind.OnAnalyzeProgress := CacheGrindAnalyzeProgress;
  FCacheGrind.OnLoadProgress := CacheGrindLoadProgress;
  FListLBL := TList.Create;
  FListMerged := TList.Create;
  FMergedInstances := TList.Create;
  // defaults
  FTimeDisplay := Config.TimeDisplay;
  FUseShortName := not Config.ShowFullPath;
  FHideLibFuncs := Config.HideLibFuncs;
  FListLBLSort := lsCum;
  FListMergedSort := msTotCum;
  // visual stuff
  pcProfiler.ActivePageIndex := 0;
end;

procedure TfDoc.FormDestroy(Sender: TObject);
begin
  ClearLists;
  FreeAndNil(FListLBL);
  FreeAndNil(FMergedInstances);
  FreeAndNil(FListMerged);
  FreeAndNil(FCacheGrind);
end;

procedure TfDoc.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfDoc.ClearTree;
begin
  tv.Items.Clear;
end;

procedure TfDoc.RefreshTree;
var
  RootNode: TTreeNode;
begin
  ClearTree;
  RootNode := AddToTree(nil, CacheGrind.Root, false);
  tv.Selected := RootNode;
  RootNode.Expand(False);
end;

function TfDoc.AddToTree(Parent: TTreeNode; Inst: TProfInstance; Cascade: Boolean): TTreeNode;
var
  Node: TTreeNode;
  I: Integer;
  S: string;
begin
  tv.Items.BeginUpdate;
  try
    if UseShortName then
      S := Inst.ShortName
    else
      S := Inst.Name;
    Node := tv.Items.AddChild(Parent, S);
    Node.Data := Inst;
    Node.ImageIndex := GetImageIndex(Inst.Kind);
    Node.SelectedIndex := Node.ImageIndex;
    Node.HasChildren := Inst.CallCount > 0;
    // link this instance to the tree node so we won't have to perform
    // searches later
    Inst.Data := Node;
    if Cascade then begin
      for I := 0 to Inst.CallCount - 1 do
        AddToTree(Node, Inst.Calls[I], True);
    end;
    Result := Node;
  finally
    tv.Items.EndUpdate;
  end;
end;

procedure TfDoc.ClearListLBL;
begin
  lvLBL.Items.Count := 0;
  FListLBL.Clear;
  lvLBL.Invalidate;
end;

procedure TfDoc.lvLBLData(Sender: TObject; Item: TListItem);
var
  Inst: TProfInstance;
  S: string;
begin
  if (Item.Index >= 0) and (Item.Index < FListLBL.Count) then begin
    Inst := TProfInstance(FListLBL[Item.Index]);
    Item.Data := Inst;
    if UseShortName then
      Item.Caption := Inst.ShortName
    else
      Item.Caption := Inst.Name;
    case TimeDisplay of
      tdMs: begin
        Item.SubItems.Add(FormatMs(Inst.SelfTime));
        Item.SubItems.Add(FormatMs(Inst.CumTime));
      end;
      tdPercent: begin
        Item.SubItems.Add(FormatPercent(Inst.SelfPercent));
        Item.SubItems.Add(FormatPercent(Inst.CumPercent));
      end;
    else
      raise Exception.Create('Unknown time display option.');
    end;
    if UseShortName then
      S := Inst.ShortFileName
    else
      S := Inst.FileName;
    Item.SubItems.Add(S);
    if UseShortName then
      S := Inst.Caller.ShortFileName
    else
      S := Inst.Caller.FileName;
    // Inst.Line is the line number of the *CALLING* function
    if Inst.Line > 0 then
      S := S + ' (' + Format ('%.0n', [Inst.Line * 1.0]) + ')';
    Item.SubItems.Add(S);
    // set image
    Item.ImageIndex := GetImageIndex(Inst.Kind);
  end;
end;

procedure TfDoc.tvChange(Sender: TObject; Node: TTreeNode);
begin
  RefreshLists;
  UpdateInfo;
end;

function TfDoc.GetImageIndex(Kind: TFuncKind): Integer;
begin
  case Kind of
    fkRoot: begin
      if CacheGrind.SummaryExists then
        Result := 1
      else
        Result := 0;
    end;
    fkSection: Result := 2;
    fkFunc: Result := 3;
    fkConstructor: Result := 4;
    fkDestructor: Result := 5;
    fkPublicMethod: Result := 6;
    fkPrivateMethod: Result := 7;
    fkStaticMethod: Result := 8;
    fkInclude: Result := 9;
    fkLibFunc: Result := 10;
  else
    Result := 0;
  end;
end;

procedure TfDoc.lvLBLDblClick(Sender: TObject);
begin
  aViewGoToOpen.Execute;
end;

procedure TfDoc.lvLBLKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Shift = [] then begin
    if Key = VK_RETURN then
      aViewGoToOpen.Execute
    else if Key = VK_BACK then
      aViewGoToUpOneLevel.Execute;
  end else if (Shift = [ssAlt]) and (Key = VK_RETURN) then
    aLBLShowInfo.Execute;
end;

procedure TfDoc.SetTimeDisplay(const Value: TTimeDisplay);
begin
  FTimeDisplay := Value;
  RepaintLists;
end;

procedure TfDoc.aViewPercentUpdate(Sender: TObject);
begin
  aViewPercent.Checked := TimeDisplay = tdPercent;
end;

procedure TfDoc.aViewMsUpdate(Sender: TObject);
begin
  aViewMs.Checked := TimeDisplay = tdMs;
end;

procedure TfDoc.aViewPercentExecute(Sender: TObject);
begin
  TimeDisplay := tdPercent;
end;

procedure TfDoc.aViewMsExecute(Sender: TObject);
begin
  TimeDisplay := tdMs;
end;

procedure TfDoc.SetUseShortName(const Value: Boolean);
begin
  FUseShortName := Value;
  SyncTree;
  RepaintLists;
end;

(**
 * Synchronizes the tree with underlying data.
 *
 * One of the cases when this is called is after a change to
 * {@link UseShortName} property. It will be unwise to refresh
 * the whole tree, so we just rename the nodes' captions accordingly.
 *)
procedure TfDoc.SyncTree;
var
  I: Integer;
begin
  for I := 0 to tv.Items.Count - 1 do
    SyncTreeNode(tv.Items[I]);
end;

procedure TfDoc.SyncTreeNode(ANode: TTreeNode);
var
  Inst: TProfInstance;
  I: Integer;
begin
  Inst := TProfInstance(ANode.Data);
  if UseShortName then
    ANode.Text := Inst.ShortName
  else
    ANode.Text := Inst.Name;
  for I := 0 to ANode.Count - 1 do
    SyncTreeNode(ANode[I]);
end;

procedure TfDoc.CacheGrindAnalyzeProgress(Sender: TObject; Position,
  Max: Integer; Status: string);
begin
  fWait.lWait.Caption := Status;
  fWait.pbWait.Position := Position;
  fWait.pbWait.Max := Max;
  fWait.Update;
end;

procedure TfDoc.CacheGrindLoadProgress(Sender: TObject; Position,
  Max: Integer; Status: string);
begin
  fWait.lWait.Caption := Status;
  fWait.pbWait.Position := Position;
  fWait.pbWait.Max := Max;
  fWait.Update;
end;

procedure TfDoc.tvExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
var
  Inst: TProfInstance;
  I: Integer;
  S: string;
begin
  if Node.HasChildren and (Node.Count = 0) then begin
    tv.Items.BeginUpdate;
    try
      // we do need to expand this
      Inst := TProfInstance(Node.Data);
      for I := 0 to Inst.CallCount - 1 do begin
        if UseShortName then
          S := Inst.Calls[I].ShortName
        else
          S := Inst.Calls[I].Name;
        if not(FHideLibFuncs and (Pos('php::', S) = 1)) then
            AddToTree(Node, Inst.Calls[I], False);
      end;
    finally
      tv.Items.EndUpdate;
    end;
  end;
end;

procedure TfDoc.aViewFullPathExecute(Sender: TObject);
begin
  UseShortName := not UseShortName;
end;

procedure TfDoc.aViewFullPathUpdate(Sender: TObject);
begin
  aViewFullPath.Checked := not UseShortName;
end;

procedure TfDoc.ClearLists;
begin
  ClearListLBL;
  ClearListMerged;
end;

procedure TfDoc.ClearListMerged;
begin
  lvMerged.Items.Count := 0;
  FListMerged.Clear;
  lvMerged.Invalidate;
end;

procedure TfDoc.RefreshListLBL;
var
  Parent, Inst, LastInst: TProfInstance;
  I: Integer;
  Pass: Boolean;
begin
  LastInst := nil;
  if lvLBL.Selected <> nil then
    LastInst := TProfInstance(FListLBL[lvLBL.ItemIndex]);
  ClearListLBL;
  if tv.Selected <> nil then begin
    Parent := TProfInstance(tv.Selected.Data);
    for I := 0 to Parent.CallCount - 1 do begin
      Inst := Parent.Calls[I];
      Pass := True;
      if HideLibFuncs and (Inst.Kind = fkLibFunc) then
        Pass := False
      else if (HideFastFuncs) and (Inst.CumTime < Config.FastThreshold) then
        Pass := False;
      if Pass then
        FListLBL.Add(Inst);
    end;
    if ListLBLSort <> lsLine then
      FListLBL.Sort(LBLSort);
    lvLBL.Items.Count := FListLBL.Count;
    SelectListItem(lvLBL, 0);
    SelectLBLInstance(LastInst);
  end;
  lvLBL.Invalidate;
end;

procedure TfDoc.RefreshListMerged;
var
  Parent: TProfInstance;
  Func, LastFunc: TProfFunc;
  I: Integer;
  Q: string;
  Delete: Boolean;
  RE: TRegExpr;
  SumSelf: TProfTime;
  SumSelfPercent: Double;
  SumCalls: Integer;
begin
  lFind.Caption := '';
  LastFunc := nil;
  if lvMerged.ItemIndex >= 0 then
    LastFunc := TProfFunc(FListMerged[lvMerged.ItemIndex]);
  ClearListMerged;
  SumSelf := 0;
  SumSelfPercent := 0;
  SumCalls := 0;
  if tv.Selected <> nil then begin
    Parent := TProfInstance(tv.Selected.Data);
    Parent.GetMerged(FListMerged);
    // filter
    RE := TRegExpr.Create;
    try
      if cbRE.Checked then begin
        RE.ModifierI := True;
        Q := cbFind.Text;
        if Q <> '' then begin
          try
            RE.Expression := Q;
            RE.Compile;
          except
            Q := '';
            lFind.Caption := 'Pattern invalid';
            lFind.Visible := True;
          end;
        end;
      end else
        Q := Trim(LowerCase(cbFind.Text));
      for I := FListMerged.Count - 1 downto 0 do begin
        Func := TProfFunc(FListMerged[I]);
        // filtering
        Delete := False;
        // filter for hide funcs
        if HideLibFuncs and(Func.Kind = fkLibFunc) then
          Delete := True
        // hide fast funcs
        else if HideFastFuncs and (Func.TotCumTime < Config.FastThreshold) then
          Delete := True
        // find
        else if Q <> '' then begin
          if cbRE.Checked then begin
            if not RE.Exec(Func.Name) then
              Delete := True;
          end else begin
            if (Pos(Q, LowerCase(Func.Name)) <= 0) then
              Delete := True;
          end;
        end;
        if Delete then begin
          FListMerged.Delete(I);
        end else begin
          // calculate sum
          SumSelf := SumSelf + Func.TotSelfTime;
          SumSelfPercent := SumSelfPercent + Func.TotSelfPercent;
          SumCalls := SumCalls + Func.InstanceCount;
        end;
      end;
    finally
      FreeAndNil(RE);
    end;
    // ok, continue
    FListMerged.Sort(MergedSort);
    lvMerged.Items.Count := FListMerged.Count;
    // select last function if available
    SelectListItem(lvMerged, 0);
    SelectMergedFunc(LastFunc);
  end;
  lvMerged.Invalidate;
  lMerged.Caption :=
    ' Sum of total self time: '+ FormatMs(SumSelf) +' ('+ FormatPercent(SumSelfPercent) + ')'
    + '   Sum of calls: '+ Format('%.0n', [SumCalls * 1.0]);
end;

procedure TfDoc.RefreshLists;
begin
  RefreshListLBL;
  RefreshListMerged;
  RefreshListMergedInstances;
end;

procedure TfDoc.lvMergedData(Sender: TObject; Item: TListItem);
var
  Func: TProfFunc;
begin
  if (Item.Index >= 0) and (Item.Index < FListMerged.Count) then begin
    Func := TProfFunc(FListMerged[Item.Index]);
    Item.Data := Func;
    if UseShortName then
      Item.Caption := Func.ShortName
    else
      Item.Caption := Func.Name;
    case TimeDisplay of
      tdMs: begin
        Item.SubItems.Add(FormatMs(Func.AvgSelfTime));
        Item.SubItems.Add(FormatMs(Func.AvgCumTime));
        Item.SubItems.Add(FormatMs(Func.TotSelfTime));
        Item.SubItems.Add(FormatMs(Func.TotCumTime));
      end;
      tdPercent: begin
        Item.SubItems.Add(FormatPercent(Func.AvgSelfPercent));
        Item.SubItems.Add(FormatPercent(Func.AvgCumPercent));
        Item.SubItems.Add(FormatPercent(Func.TotSelfPercent));
        Item.SubItems.Add(FormatPercent(Func.TotCumPercent));
      end;
    else
      raise Exception.Create('Unknown time display option.');
    end;
    Item.SubItems.Add(Format('%.0n', [Func.InstanceCount * 1.0]));
    // set image
    Item.ImageIndex := GetImageIndex(Func.Kind);
  end;
end;

procedure TfDoc.RepaintLists;
begin
  lvLBL.Invalidate;
  lvMerged.Invalidate;
end;

function TfDoc.FormatMs(Ms: TProfTime): string;
begin
  if Ms < 0.1 then
    Result := '-'
  else if Ms < 10 then
    Result := Format('%.1n', [Ms]) + 'ms'
  else
    Result := Format('%.0n', [Ms]) + 'ms';
end;

function TfDoc.FormatPercent(Percent: Double): string;
begin
  if Percent < 0.01 then
    Result := '-'
  else
    Result := Format('%.2f%%', [Percent]);
end;

procedure TfDoc.SetListLBLSort(const Value: TListLBLSort);
begin
  FListLBLSort := Value;
  RefreshListLBL;
end;

procedure TfDoc.SetListMergedSort(const Value: TListMergedSort);
begin
  FListMergedSort := Value;
  RefreshListMerged;
end;

procedure TfDoc.lvLBLColumnClick(Sender: TObject; Column: TListColumn);
begin
  ListLBLSort := TListLBLSort(Column.Index);
end;

procedure TfDoc.lvMergedColumnClick(Sender: TObject; Column: TListColumn);
begin
  ListMergedSort := TListMergedSort(Column.Index);
end;

procedure TfDoc.UpdateInfo;
var
  Inst: TProfInstance;
begin
  if tv.Selected <> nil then begin
    Inst := TProfInstance(tv.Selected.Data);
    lInfoName.Caption := Inst.Name;
    lInfoFileName.Caption := 'File: '+ Inst.FileName;
    lInfo.Caption := 'Self time: '+ FormatMs(Inst.SelfTime) + ' (' + FormatPercent(Inst.SelfPercent) + ')'
      + '   Cumulative time: '+ FormatMs(Inst.CumTime) + ' (' + FormatPercent(Inst.CumPercent) + ')';
    iInfo.Picture.Assign(nil);
    ilCacheGrind.GetBitmap(GetImageIndex(Inst.Kind), iInfo.Picture.Bitmap);
    pInfo.Visible := True;
  end else begin
    pInfo.Visible := False;
  end;
end;

procedure TfDoc.Reload;
begin
  Open(FileName);
end;

procedure TfDoc.SetHideLibFuncs(const Value: Boolean);
begin
  FHideLibFuncs := Value;
  RefreshLists;
end;

procedure TfDoc.aViewHideLibFuncsUpdate(Sender: TObject);
begin
  aViewHideLibFuncs.Checked := HideLibFuncs;
end;

procedure TfDoc.aViewHideLibFuncsExecute(Sender: TObject);
begin
  HideLibFuncs := not HideLibFuncs;
end;

procedure TfDoc.ToolButton1Click(Sender: TObject);
begin
  case TimeDisplay of
    tdMs: TimeDisplay := tdPercent;
    tdPercent: TimeDisplay := tdMs;
  else
    raise Exception.Create('Unrecognize time display option.');
  end;
end;

function TfDoc.GetConfig: TConfig;
begin
  Result := fMain.Config;
end;

procedure TfDoc.aViewGoToUpOneLevelUpdate(Sender: TObject);
begin
  aViewGoToUpOneLevel.Enabled := (tv.Selected <> nil) and (tv.Selected.Parent <> nil);
end;

procedure TfDoc.aViewGoToUpOneLevelExecute(Sender: TObject);
var
  LastInst: TProfInstance;
begin
  if (tv.Selected <> nil) and (tv.Selected.Parent <> nil) then begin
    LastInst := TProfInstance(tv.Selected.Data);
    SelectTreeNode(tv.Selected.Parent);
    RefreshListLBL;
    SelectLBLInstance(LastInst);
  end;
end;

procedure TfDoc.RefreshListMergedInstances;
var
  Func: TProfFunc;
  I: Integer;
begin
  ClearListMergedInstances;
  if lvMerged.Selected <> nil then begin
    Func := TProfFunc(FListMerged[lvMerged.ItemIndex]);
    for I := 0 to Func.InstanceCount - 1 do
      FMergedInstances.Add(Func.Instances[I]);
    if MergedInstancesSort <> misIndex then
      FMergedInstances.Sort(uDoc.MergedInstancesSort);
    lvMergedInstances.Items.Count := FMergedInstances.Count;
    SelectListItem(lvMergedInstances, 0);
  end;
  lvMergedInstances.Invalidate;
end;

procedure TfDoc.ClearListMergedInstances;
begin
  lvMergedInstances.Items.Count := 0;
  FMergedInstances.Clear;
  lvMergedInstances.Invalidate;
end;

procedure TfDoc.lvMergedInstancesData(Sender: TObject; Item: TListItem);
var
  Inst, Cur: TProfInstance;
  S: string;
begin
  if (Item.Index >= 0) and (Item.Index < FMergedInstances.Count) then begin
    Inst := TProfInstance(FMergedInstances[Item.Index]);
    Item.Data := Inst;
    Item.Caption := Format('%.0n', [(Inst.Index + 1) * 1.0]);
    // set image
    Item.ImageIndex := GetImageIndex(Inst.Kind);
    case TimeDisplay of
      tdMs: begin
        Item.SubItems.Add(FormatMs(Inst.SelfTime));
        Item.SubItems.Add(FormatMs(Inst.CumTime));
      end;
      tdPercent: begin
        Item.SubItems.Add(FormatPercent(Inst.SelfPercent));
        Item.SubItems.Add(FormatPercent(Inst.CumPercent));
      end;
    else
      raise Exception.Create('Unknown time display option.');
    end;
    if UseShortName then
      Item.SubItems.Add(Inst.Caller.ShortName)
    else
      Item.SubItems.Add(Inst.Caller.Name);
    if UseShortName then
      S := Inst.Caller.ShortFileName
    else
      S := Inst.Caller.FileName;
    // Inst.Line is the line number of the *CALLING* function
    if Inst.Line > 0 then
      S := S + ' (' + Format ('%.0n', [Inst.Line * 1.0]) + ')';
    Item.SubItems.Add(S);
    // stack trace euy!!! :-P
    S := '';
    Cur := Inst.Caller;
    while Cur <> nil do begin
      if Cur.Caller = nil then Break;
      if S <> '' then S := S + ' « ';
      S := S + Cur.ShortName;
      Cur := Cur.Caller;
    end;
    Item.SubItems.Add(S);
  end;
end;

procedure TfDoc.aViewGoToOpenUpdate(Sender: TObject);
begin
  aViewGoToOpen.Enabled := lvLBL.Selected <> nil;
end;

procedure TfDoc.aViewGoToOpenExecute(Sender: TObject);
begin
  if lvLBL.Selected <> nil then
    SelectTreeInstance(TProfInstance(FListLBL[lvLBL.ItemIndex]));
end;

procedure TfDoc.SetMergedInstancesSort(const Value: TMergedInstancesSort);
begin
  FMergedInstancesSort := Value;
  FMergedInstances.Sort(uDoc.MergedInstancesSort);
  lvMergedInstances.Invalidate;
end;

procedure TfDoc.lvMergedInstancesColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if Column.Index > Ord(High(TMergedInstancesSort)) then
    MessageDlg('Sorting on this column is not supported.', mtInformation,
      [mbOK], 0)
  else
    MergedInstancesSort := TMergedInstancesSort(Column.Index);
end;

{**
 * This function is VERY slow. If possible, use TfDoc.SelectTreeNode().
 *}
procedure TfDoc.SelectTreeInstance(AInst: TProfInstance);
var
  Path: TList;
  Cur: TProfInstance;
  Node, Found: TTreeNode;
  I: Integer;
begin
  // if not the we must perform a search :-(
  Path := TList.Create;
  try
    // generate path
    Cur := AInst;
    while Cur <> nil do begin
      Path.Insert(0, Cur);
      Cur := Cur.Caller;
    end;
    // then find this path in treenode
    // give starting point
    Node := tv.Items[0];
    Path.Delete(0);
    // then loop
    while Path.Count > 0 do begin
      // get the instance to find
      Cur := Path[0];
      Path.Delete(0);
      // expand this node so we have children
      if Node.HasChildren and not Node.Expanded then
        Node.Expand(False);
      // I hope this path is already loaded
      if Cur.Data <> nil then
        Found := TTreeNode(Cur.Data)
      else begin
        // whoops!! we have to perform an exhaustive search :-(
        // search its children
        Found := nil;
        for I := 0 to Node.Count - 1 do begin
          if Node.Item[I].Data = Cur then begin
            Found := Node.Item[I];
            Break;
          end;
        end;
      end;
      // not found?
      if Found = nil then raise Exception.Create('Cannot find tree node.');
      // this is our node
      Node := Found;
    end;
    // then select this
    SelectTreeNode(Node);
  finally
    FreeAndNil(Path);
  end;
end;

procedure TfDoc.aMergedInstancesGoToUpdate(Sender: TObject);
begin
  aMergedInstancesGoTo.Enabled := lvMergedInstances.Selected <> nil;
end;

procedure TfDoc.aMergedInstancesGoToExecute(Sender: TObject);
begin
  SelectTreeInstance(FMergedInstances[lvMergedInstances.ItemIndex]);
  pcProfiler.ActivePage := tsLBL;
  lvLBL.SetFocus;
end;

procedure TfDoc.lvMergedInstancesDblClick(Sender: TObject);
begin
  aMergedInstancesGoTo.Execute;
end;

procedure TfDoc.lvMergedInstancesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = []) and (Key = VK_RETURN) then
    aMergedInstancesGoTo.Execute;
end;

(**
 * Opens a file in the editor.
 *)
procedure TfDoc.aTreeOpenEditorUpdate(Sender: TObject);
begin
  aTreeOpenEditor.Enabled := (tv.Selected <> nil) and (tv.Selected.Parent <> nil);
end;

procedure TfDoc.aTreeOpenEditorExecute(Sender: TObject);
var
  Inst: TProfInstance;
begin
  Inst := TProfInstance(tv.Selected.Data);
  fMain.OpenEditor(Inst.Caller.FileName, Self, Inst.Line);
end;

procedure TfDoc.tvKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = []) and (Key = VK_RETURN) then
    aTreeOpenEditor.Execute;
  if (Shift = []) and (Key = VK_BACK) then
    aViewGoToUpOneLevel.Execute;
  if (Shift = [ssAlt]) and (Key = VK_RETURN) then
    aTreeShowInfo.Execute;
end;

procedure TfDoc.aTreeShowInfoUpdate(Sender: TObject);
begin
  aTreeShowInfo.Enabled := tv.Selected <> nil;
end;

procedure TfDoc.ShowInfo(AInst: TProfInstance);
var
  S: string;
begin
  S := '';
  if not CacheGrind.SummaryExists then
    S := S + 'Warning! This file does not contain a "summary:" line,'
      + ' this usually means the file is not valid.'
      + ' As of xdebug 2.0.0 beta 1, this can happen when you use'
      + ' exit() or die() in your script.'#13#10#13#10;
  S := S + 'Parser information:'#13#10;
  S := S + 'Definition line: ' + Format('%.0n', [AInst.ParserLine * 1.0]) + #13#10;
  S := S + 'Call line: ' + Format('%.0n', [AInst.ParserCallLine * 1.0]);
  MessageDlg(S, mtInformation, [mbOK], 0);
end;

procedure TfDoc.aLBLShowInfoUpdate(Sender: TObject);
begin
  aLBLShowInfo.Enabled := lvLBL.Selected <> nil;
end;

procedure TfDoc.aLBLShowInfoExecute(Sender: TObject);
begin
  ShowInfo(TProfInstance(FListLBL[lvLBL.ItemIndex]));
end;

procedure TfDoc.aTreeShowInfoExecute(Sender: TObject);
begin
  ShowInfo(TProfInstance(tv.Selected.Data));
end;

procedure TfDoc.tvCollapsing(Sender: TObject; Node: TTreeNode;
  var AllowCollapse: Boolean);
begin
  if Node.Parent = nil then
    AllowCollapse := False;
end;

procedure TfDoc.lvMergedSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Selected then
    RefreshListMergedInstances
  else
    ClearListMergedInstances;
end;

procedure TfDoc.aProfilerFindExecute(Sender: TObject);
begin
  pcProfiler.ActivePage := tsMerged;
  cbFind.SetFocus;
  cbFind.SelectAll;
end;

procedure TfDoc.cbFindChange(Sender: TObject);
begin
  tFind.Enabled := False;
  tFind.Enabled := True;
end;

procedure TfDoc.aLBLOpenEditorUpdate(Sender: TObject);
begin
  aLBLOpenEditor.Enabled := lvLBL.Selected <> nil;
end;

procedure TfDoc.aLBLOpenEditorExecute(Sender: TObject);
begin
  fMain.OpenEditor(TProfInstance(FListLBL[lvLBL.ItemIndex]).Caller.FileName,
    Self, TProfInstance(FListLBL[lvLBL.ItemIndex]).Line);
end;

procedure TfDoc.aTreeGoToRootExecute(Sender: TObject);
begin
  SelectTreeNode(tv.Items[0]);
end;

procedure TfDoc.aTreeGoToRootUpdate(Sender: TObject);
begin
  aTreeGoToRoot.Enabled := CacheGrind.Root <> nil;
end;

procedure TfDoc.aMergedInstancesOpenEditorUpdate(Sender: TObject);
begin
  aMergedInstancesOpenEditor.Enabled := lvMergedInstances.Selected <> nil;
end;

procedure TfDoc.aMergedInstancesOpenEditorExecute(Sender: TObject);
begin
  fMain.OpenEditor(TProfInstance(FMergedInstances[lvMergedInstances.ItemIndex]).Caller.FileName,
    Self, TProfInstance(FMergedInstances[lvMergedInstances.ItemIndex]).Line);
end;

procedure TfDoc.aMergedInstancesShowInfoUpdate(Sender: TObject);
begin
  aMergedInstancesShowInfo.Enabled := lvMergedInstances.Selected <> nil;
end;

procedure TfDoc.aMergedInstancesShowInfoExecute(Sender: TObject);
begin
  ShowInfo(TProfInstance(FMergedInstances[lvMergedInstances.ItemIndex]));
end;

procedure TfDoc.ShowMerged(AFunc: TProfFunc);
begin
  // must clear filter first
  cbFind.Text := '';
  FHideFastFuncs := False;
  FHideLibFuncs := False;
  RefreshListMerged();
  // we must switch to parent (and more parents!!) if not found in current view
  while FListMerged.IndexOf(AFunc) < 0 do begin
    if tv.Selected.Parent = nil then
      raise Exception.Create('Cannot find current function in the whole function list (possibly a bug in this program).');
    SelectTreeNode(tv.Selected.Parent);
    // refresh lvMerged
    RefreshListMerged;
  end;
  // then select this function
  SelectMergedFunc(AFunc);
  // set focus
  pcProfiler.ActivePage := tsMerged;
  lvMerged.SetFocus;
end;

procedure TfDoc.aLBLShowOverallExecute(Sender: TObject);
begin
  ShowMerged(TProfInstance(FListLBL[lvLBL.ItemIndex]).Func);
end;

procedure TfDoc.aLBLShowOverallUpdate(Sender: TObject);
begin
  aLBLShowOverall.Enabled := lvLBL.Selected <> nil;
end;

procedure TfDoc.aTreeShowOverallExecute(Sender: TObject);
begin
  ShowMerged(TProfInstance(tv.Selected.Data).Func);
end;

procedure TfDoc.aTreeShowOverallUpdate(Sender: TObject);
begin
  aTreeShowOverall.Enabled := (tv.Selected <> nil) and (tv.Selected.Parent <> nil);
end;

procedure TfDoc.aTreeExpandUpdate(Sender: TObject);
begin
  aTreeExpand.Enabled := (tv.Selected <> nil) and (tv.Selected.HasChildren) and (not tv.Selected.Expanded);
end;

procedure TfDoc.aTreeExpandExecute(Sender: TObject);
begin
  tv.Selected.Expand(False);
  tv.Selected.MakeVisible;
end;

procedure TfDoc.aTreeCollapseUpdate(Sender: TObject);
begin
  aTreeCollapse.Enabled := (tv.Selected <> nil) and (tv.Selected.Expanded) and (tv.Selected.Parent <> nil);
end;

procedure TfDoc.aTreeCollapseExecute(Sender: TObject);
begin
  tv.Selected.Collapse(False);
end;

procedure TfDoc.aTreeExpandAllUpdate(Sender: TObject);
begin
  aTreeExpandAll.Enabled := (tv.Selected <> nil) and (tv.Selected.HasChildren) and (not tv.Selected.Expanded);
end;

procedure TfDoc.aTreeExpandAllExecute(Sender: TObject);
begin
  tv.Items.BeginUpdate;
  try
    tv.Selected.Expand(True);
    tv.Selected.MakeVisible;
  finally
    tv.Items.EndUpdate;
  end;
end;

procedure TfDoc.SelectMergedFunc(AFunc: TProfFunc);
begin
  SelectListItem(lvMerged, FListMerged.IndexOf(AFunc));
end;

procedure TfDoc.SelectLBLInstance(AInst: TProfInstance);
begin
  SelectListItem(lvLBL, FListLBL.IndexOf(AInst));
end;

procedure TfDoc.SelectListItem(LV: TListView; AIndex: Integer);
begin
  if (AIndex >= 0) and (AIndex < LV.Items.Count) then begin
    ListView_EnsureVisible(LV.Handle, AIndex, False);
    ListView_SetItemState(LV.Handle, AIndex, LVIS_FOCUSED or LVIS_SELECTED,
      LVIS_FOCUSED or LVIS_SELECTED);
  end;
  // below doesn't work (unfortunately), and lvMerged.Selected := lvMerged.Items[I] also doesn't work
  // I think there's no VCL programmatical way to select an item in ownerdata listview
//    lvMerged.ItemIndex := I;
  // then show our stuff
end;

procedure TfDoc.SelectTreeNode(Node: TTreeNode);
begin
  if Node <> nil then begin
    Node.MakeVisible;
    tv.Selected := Node;
  end;
end;

procedure TfDoc.SetHideFastFuncs(const Value: Boolean);
begin
  FHideFastFuncs := Value;
  RefreshLists;
end;

procedure TfDoc.aViewHideFastFuncsUpdate(Sender: TObject);
begin
  aViewHideFastFuncs.Checked := HideFastFuncs;
end;

procedure TfDoc.aViewHideFastFuncsExecute(Sender: TObject);
begin
  HideFastFuncs := not HideFastFuncs;
end;

procedure TfDoc.tFindTimer(Sender: TObject);
begin
  tFind.Enabled := False;
  RefreshListMerged;
end;

procedure TfDoc.cbFindSelect(Sender: TObject);
begin
  cbRE.Checked := True;
  tFind.Enabled := False;
  tFind.Enabled := True;
end;

procedure TfDoc.cbREClick(Sender: TObject);
begin
  tFind.Enabled := False;
  tFind.Enabled := True;
end;

end.
