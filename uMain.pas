unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, Menus, ActnList, XPStyleActnCtrls, ActnMan,
  ImgList, XPMan, AppEvnts, uConfig, ExtCtrls, StdActns, JvComponent,
  JvChangeNotify, JvTabBar, JvAppInst;

type
  TExplorerSort = (esFileName, esTitle, esModified, esSize);
  PExplorerData = ^TExplorerData;
  TExplorerData = record
    FileName: string;
    Title: string;
    Modified: TDateTime;
    Size: Integer;
  end;
  TfMain = class(TForm)
    sb: TStatusBar;
    il: TImageList;
    mm: TMainMenu;
    am: TActionManager;
    aFileOpen: TAction;
    aFileExit: TAction;
    miFile: TMenuItem;
    Open1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    od: TOpenDialog;
    ae: TApplicationEvents;
    miMRUSep: TMenuItem;
    aFileClose: TAction;
    Close1: TMenuItem;
    aHelpReadMe: TAction;
    aHelpAbout: TAction;
    Help1: TMenuItem;
    ReadMe1: TMenuItem;
    N2: TMenuItem;
    About1: TMenuItem;
    aHelpLicense: TAction;
    ViewLicense1: TMenuItem;
    miWindow: TMenuItem;
    aFileReload: TAction;
    N3: TMenuItem;
    Reload1: TMenuItem;
    aFileCloseAll: TAction;
    CloseAll1: TMenuItem;
    aFileReloadAll: TAction;
    ReloadAll1: TMenuItem;
    aToolsOptions: TAction;
    ools1: TMenuItem;
    Options1: TMenuItem;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    lvExplorer: TListView;
    sExplorer: TSplitter;
    aViewExplorer: TAction;
    WindowCascade1: TWindowCascade;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowTileVertical1: TWindowTileVertical;
    WindowMinimizeAll1: TWindowMinimizeAll;
    WindowArrange1: TWindowArrange;
    View1: TMenuItem;
    Cascade1: TMenuItem;
    ileHorizontally1: TMenuItem;
    ileVertically1: TMenuItem;
    Arrange1: TMenuItem;
    N6: TMenuItem;
    MinimizeAll1: TMenuItem;
    CloseAll2: TMenuItem;
    Explorer1: TMenuItem;
    ToolButton9: TToolButton;
    ToolButton8: TToolButton;
    aViewRefreshExplorer: TAction;
    RefreshExplorer1: TMenuItem;
    aExplorerOpen: TAction;
    pmExplorer: TPopupMenu;
    Open2: TMenuItem;
    N7: TMenuItem;
    RefreshExplorer2: TMenuItem;
    Explorer2: TMenuItem;
    tUpdateStatusBar: TTimer;
    Close2: TMenuItem;
    ilIcons: TImageList;
    cn: TJvChangeNotify;
    tRefreshExplorer: TTimer;
    tbTabs: TJvTabBar;
    AppInstances: TJvAppInstances;
    procedure FormShow(Sender: TObject);
    procedure AppInstancesCmdLineReceived(Sender: TObject; CmdLine: TStrings);
    procedure tbTabsTabSelected(Sender: TObject; Item: TJvTabBarItem);
    procedure tbTabsTabClosed(Sender: TObject; Item: TJvTabBarItem);
    procedure aFileOpenExecute(Sender: TObject);
    procedure miFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure aFileExitExecute(Sender: TObject);
    procedure aFileCloseUpdate(Sender: TObject);
    procedure aFileCloseExecute(Sender: TObject);
    procedure aHelpReadMeExecute(Sender: TObject);
    procedure aHelpAboutExecute(Sender: TObject);
    procedure aHelpLicenseExecute(Sender: TObject);
    procedure miWindowClick(Sender: TObject);
    procedure aFileReloadUpdate(Sender: TObject);
    procedure aFileReloadExecute(Sender: TObject);
    procedure aFileCloseAllExecute(Sender: TObject);
    procedure aFileCloseAllUpdate(Sender: TObject);
    procedure aFileReloadAllExecute(Sender: TObject);
    procedure aFileReloadAllUpdate(Sender: TObject);
    procedure aToolsOptionsExecute(Sender: TObject);
    procedure aViewExplorerUpdate(Sender: TObject);
    procedure aViewExplorerExecute(Sender: TObject);
    procedure lvExplorerData(Sender: TObject; Item: TListItem);
    procedure aViewRefreshExplorerUpdate(Sender: TObject);
    procedure aViewRefreshExplorerExecute(Sender: TObject);
    procedure lvExplorerColumnClick(Sender: TObject; Column: TListColumn);
    procedure aExplorerOpenUpdate(Sender: TObject);
    procedure aExplorerOpenExecute(Sender: TObject);
    procedure lvExplorerKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvExplorerDblClick(Sender: TObject);
    procedure tUpdateStatusBarTimer(Sender: TObject);
    procedure aeDeactivate(Sender: TObject);
    procedure aeIdle(Sender: TObject; var Done: Boolean);
    procedure cnChangeNotify(Sender: TObject; Dir: String;
      Actions: TJvChangeActions);
    procedure tRefreshExplorerTimer(Sender: TObject);
  private
    { Private declarations }
    FConfig: TConfig;
    FExplorerList: TList;
    FExplorerSort: TExplorerSort;
    FLastMDIChildCount: Integer;
    FLastActiveMDIChild: TCustomForm;
    procedure miMRUClick(Sender: TObject);
    procedure WindowItemClick(Sender: TObject);
    procedure WMDropFiles(var M: TMessage); message WM_DROPFILES;
    procedure SetExplorerSort(const Value: TExplorerSort);
  public
    { Public declarations }
    property Config: TConfig read FConfig;
    property ExplorerList: TList read FExplorerList;
    property ExplorerSort: TExplorerSort read FExplorerSort write SetExplorerSort;

    procedure ClearExplorer;
    procedure Open(AFileName: string);
    procedure OpenEditor(AFileName: string; AOwner: TComponent = nil; Line: Integer = 0);
    procedure RefreshExplorer;
    procedure RefreshTabs;
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

uses uDoc, Shellapi, uOptions, uCacheGrind, DateUtils, JclFileUtils, uEditor;

function ExplorerSort(A, B: Pointer): Integer;
var
  DA, DB: PExplorerData;
begin
  Result := 0;
  DA := PExplorerData(A);
  DB := PExplorerData(B);
  case fMain.ExplorerSort of
    esFileName: Result := CompareText(DA.FileName, DB.FileName);
    esTitle: Result := CompareText(DA.Title, DB.Title);
    esModified: Result := CompareDateTime(DB.Modified, DA.Modified);
    esSize: Result := DB.Size - DA.Size;
  end;
  if Result = 0 then
    Result := CompareText(DA.FileName, DB.FileName);
end;

procedure TfMain.aFileOpenExecute(Sender: TObject);
begin
  od.InitialDir := Config.WorkingDir;
  if od.Execute then
    Open(od.FileName);
end;

procedure TfMain.miFileClick(Sender: TObject);
var
  mi: TMenuItem;
  I: Integer;
begin
  // delete last MRU
  for I := miFile.Count - 1 downto miMRUSep.MenuIndex + 1 do begin
    mi := miFile[I];
    if Pos('miMRUEntry', mi.Name) = 1 then
      mi.Free;
  end;
  // recreate them
  if Config.MRUTitles.Count > 0 then begin
    miMRUSep.Visible := false;
    for I := 0 to Config.MRUTitles.Count - 1 do begin
      mi := TMenuItem.Create(mm);
      mi.Name := 'miMRUEntry' + IntToStr(I);
      mi.Caption := IntToStr(I+1) + '. ' +Config.MRUTitles[I];
      mi.Tag := I;
      mi.Hint := 'Opens '+ Config.MRUTitles[I] +' ('+ Config.MRU[I] + ').';
      mi.OnClick := miMRUClick;
      mi.ImageIndex := 9;
      miFile.Insert(miMRUSep.MenuIndex + I + 1, mi);
    end;
  end else
    miMRUSep.Visible := false;
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
  FConfig := TConfig.Create;
  FConfig.Load;
  FExplorerList := TList.Create;
  // accept drag and drop
  DragAcceptFiles(Handle, True);
  // visuals
  ExplorerSort := esModified;
  RefreshExplorer;
  RefreshTabs;
end;

procedure TfMain.FormDestroy(Sender: TObject);
begin
  if Config.ClearMRUOnExit then
    Config.ClearMRU;
  FConfig.Save;
  FConfig.Free;
end;

procedure TfMain.aFileExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfMain.Open(AFileName: string);
var
  I: Integer;
  Form: TfDoc;
begin
  for I := 0 to MDIChildCount - 1 do begin
    if MDIChildren[I] is TfDoc then begin
      Form := MDIChildren[I] as TfDoc;
      if SameText(Form.FileName, AFileName) then begin
        Form.Show;
        Form.SetFocus;
        Exit;
      end;
    end;
  end;
  // open in new window
  Form := TfDoc.Create(Application);
  try
    if MDIChildCount = 1 then
      Form.WindowState := wsMaximized;
    Form.Open(AFileName);
    Form.Show;
  except
    Form.Free;
    raise;
  end;
  lvExplorer.Invalidate;
end;

procedure TfMain.miMRUClick(Sender: TObject);
var
  mi: TMenuItem;
begin
  mi := Sender as TMenuItem;
  Open(Config.MRU[mi.Tag]);
end;

procedure TfMain.aFileCloseUpdate(Sender: TObject);
begin
  aFileClose.Enabled := ActiveMDIChild <> nil;
end;

procedure TfMain.aFileCloseExecute(Sender: TObject);
begin
  ActiveMDIChild.Close;
end;

procedure TfMain.aHelpReadMeExecute(Sender: TObject);
begin
  ShellExecute(Handle, '', PChar(ExtractFilePath(Application.ExeName) + 'README.txt'),
    '', '', SW_SHOWNORMAL);
end;

procedure TfMain.aHelpAboutExecute(Sender: TObject);
var
  VI: TJclFileVersionInfo;
begin
  VI := TJclFileVersionInfo.Create(Application.ExeName);
  try
    MessageDlg(
      'WinCacheGrind version '+ VI.BinFileVersion + #13#10 +
      'Copyright (C) 2005 Hendy Irawan'#13#10 +
      #13#10 +
      'Contact information:'#13#10 +
      'E-mail: ceefour@gauldong.net'#13#10 +
      'Web: http://wincachegrind.sourceforge.net/'#13#10 +
      #13#10 +
      'This program is licensed under GNU General Public License version ' +
      '2 or later.'#13#10 +
      'See GPL.txt for more information.', mtInformation, [mbOK], 0);
  finally
    FreeAndNil(VI);
  end;
end;

procedure TfMain.aHelpLicenseExecute(Sender: TObject);
begin
  ShellExecute(Handle, '', PChar(ExtractFilePath(Application.ExeName) + 'gpl.txt'),
    '', '', SW_SHOWNORMAL);
end;

procedure TfMain.miWindowClick(Sender: TObject);
var
  I: Integer;
  mi: TMenuItem;
begin
  for I := miWindow.Count - 1 downto 8 do
    miWindow[I].Free;
  if MDIChildCount > 0 then begin
    // create separator
    mi := TMenuItem.Create(mm);
    mi.Caption := '-';
    miWindow.Add(mi);
    // then window list
    for I := 0 to MDIChildCount - 1 do begin
      mi := TMenuItem.Create(mm);
      mi.Caption := MDIChildren[I].Caption;
      mi.OnClick := WindowItemClick;
      if MDIChildren[I] is TfEditor then
        mi.ImageIndex := 20
      else
        mi.ImageIndex := 8;
      mi.Hint := 'Displays '+ MDIChildren[I].Caption;
      mi.Tag := I;
      miWindow.Add(mi);
    end;
  end;
end;

procedure TfMain.WindowItemClick(Sender: TObject);
begin
  MDIChildren[(Sender as TMenuItem).Tag].Show;
end;

procedure TfMain.aFileReloadUpdate(Sender: TObject);
begin
  aFileReload.Enabled := MDIChildCount > 0;
end;

procedure TfMain.aFileReloadExecute(Sender: TObject);
begin
  (ActiveMDIChild as TfDoc).Reload;
end;

procedure TfMain.WMDropFiles(var M: TMessage);
var
  hDrop: THandle;
  Count, I: Integer;
  PC: array[0..65535] of char;
begin
  hDrop := M.wParam;
  try
    Count := DragQueryFile(hDrop, $FFFFFFFF, nil, 0);
    for I := 0 to Count - 1 do begin
      DragQueryFile(hDrop, I, PC, SizeOf(PC));
      Open(PC);
    end;
  finally
    DragFinish(hDrop);
  end;
end;

procedure TfMain.aFileCloseAllExecute(Sender: TObject);
var
  I: Integer;
begin
  for I := MDIChildCount - 1 downto 0 do
    MDIChildren[I].Close;
end;

procedure TfMain.aFileCloseAllUpdate(Sender: TObject);
begin
  aFileCloseAll.Enabled := MDIChildCount > 0;
end;

procedure TfMain.aFileReloadAllExecute(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to MDIChildCount - 1 do
    (MDIChildren[I] as TfDoc).Reload;
end;

procedure TfMain.aFileReloadAllUpdate(Sender: TObject);
begin
  aFileReloadAll.Enabled := MDIChildCount > 0;
end;

procedure TfMain.aToolsOptionsExecute(Sender: TObject);
begin
  fOptions := TfOptions.Create(Self);
  try
    fOptions.ShowModal;
  finally
    FreeAndNil(fOptions);
  end;
  RefreshExplorer;
end;

procedure TfMain.aViewExplorerUpdate(Sender: TObject);
begin
  aViewExplorer.Checked := lvExplorer.Visible;
end;

procedure TfMain.aViewExplorerExecute(Sender: TObject);
begin
  lvExplorer.Visible := not lvExplorer.Visible;
  sExplorer.Visible := lvExplorer.Visible;
  if lvExplorer.Visible then
    RefreshExplorer;
end;

procedure TfMain.ClearExplorer;
var
  I: Integer;
begin
  lvExplorer.Items.Count := 0;
  for I := 0 to ExplorerList.Count - 1 do
    Dispose(PExplorerData(ExplorerList[I]));
  ExplorerList.Clear;
  lvExplorer.Invalidate;
end;

procedure TfMain.RefreshExplorer;
var
  F: TSearchRec;
  Code: Integer;
  CG: TCacheGrind;
  ED: PExplorerData;
begin
  sb.SimplePanel := True;
  Application.Hint := 'Refreshing Explorer list. Please wait...';
  sb.Repaint;
  ClearExplorer;
  if Config.WorkingDir <> '' then begin
    CG := TCacheGrind.Create(Self);
    try
      Code := FindFirst(Config.WorkingDir + '\cachegrind.out.*', faAnyFile, F);
      while Code = 0 do begin
        if F.Attr <> faDirectory then begin
          New(ED);
          ExplorerList.Add(ED);
          ED.FileName := Config.WorkingDir + '\' + F.Name;
          ED.Modified := FileDateToDateTime(F.Time);
          ED.Size := F.Size;
          try
            CG.Load(Config.WorkingDir + '\' + F.Name, True);
            ED.Title := CG.Cmd;
          except
            ED.Title := '(Error: Cannot read file)';
          end;
        end;
        Code := FindNext(F);
      end;
      FindClose(F);
    finally
      FreeAndNil(CG);
    end;
    FExplorerList.Sort(uMain.ExplorerSort);
    // update list
    lvExplorer.Items.Count := ExplorerList.Count;
    lvExplorer.Invalidate;
    // register change notify
    cn.Active := False;
    cn.Notifications[0].Directory := Config.WorkingDir;
    cn.Active := True;
  end;
  Application.Hint := '';
end;

procedure TfMain.lvExplorerData(Sender: TObject; Item: TListItem);
var
  ED: PExplorerData;
  I: Integer;
begin
  if Item.Index < ExplorerList.Count then begin
    ED := PExplorerData(ExplorerList[Item.Index]);
    Item.Caption := ExtractFileName(ED.FileName);
    Item.SubItems.Add(ED.Title);
    Item.SubItems.Add(FormatDateTime('ddddd t', ED.Modified));
    Item.SubItems.Add(Format('%.0n', [ED.Size * 1.0]));
    Item.ImageIndex := 0;
    for I := 0 to MDIChildCount - 1 do begin
      if MDIChildren[I] is TfDoc then
        if SameText((MDIChildren[I] as TfDoc).FileName, ED.FileName) then begin
          Item.ImageIndex := 1;
          Break;
        end;
    end;
  end;
end;

procedure TfMain.aViewRefreshExplorerUpdate(Sender: TObject);
begin
  aViewRefreshExplorer.Enabled := Config.WorkingDir <> '';
end;

procedure TfMain.aViewRefreshExplorerExecute(Sender: TObject);
begin
  RefreshExplorer;
end;

procedure TfMain.SetExplorerSort(const Value: TExplorerSort);
begin
  FExplorerSort := Value;
  FExplorerList.Sort(uMain.ExplorerSort);
  lvExplorer.Invalidate;
end;

procedure TfMain.lvExplorerColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  ExplorerSort := TExplorerSort(Column.Index);
end;

procedure TfMain.aExplorerOpenUpdate(Sender: TObject);
begin
  aExplorerOpen.Enabled := lvExplorer.Selected <> nil;
end;

procedure TfMain.aExplorerOpenExecute(Sender: TObject);
begin
  Open(PExplorerData(ExplorerList[lvExplorer.Selected.Index]).FileName);
end;

procedure TfMain.lvExplorerKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = []) and (Key = VK_RETURN) then
    aExplorerOpen.Execute;
end;

procedure TfMain.lvExplorerDblClick(Sender: TObject);
begin
  aExplorerOpen.Execute;
end;

procedure TfMain.tUpdateStatusBarTimer(Sender: TObject);
begin
  if Application.Hint = '' then
    sb.SimpleText := Format('Allocated memory: %.0n bytes', [AllocMemSize * 1.0])
end;

procedure TfMain.OpenEditor(AFileName: string; AOwner: TComponent; Line: Integer);
var
  I: Integer;
  Editor: TfEditor;
begin
  Editor := nil;
  // first check if this file is already opened
  for I := 1 to MDIChildCount - 1 do begin
    if MDIChildren[I] is TfEditor then
      if SameText((MDIChildren[I] as TfEditor).FileName, AFileName) then begin
        Editor := MDIChildren[I] as TfEditor;
        Break;
      end;
  end;
  if Editor = nil then begin
    if AOwner = nil then AOwner := Application;
    Editor := TfEditor.Create(AOwner);
    Editor.Open(AFileName);
  end;
  Editor.Show;
  Editor.he.SetFocus;
  if Line > 0 then begin
    Editor.he.SetCaret(0, Line - 1);
    Editor.HighlightedLine := Line - 1;
  end;
end;

procedure TfMain.aeDeactivate(Sender: TObject);
begin
  lvExplorer.Invalidate;
end;

procedure TfMain.aeIdle(Sender: TObject; var Done: Boolean);
begin
  if (FLastMDIChildCount <> MDIChildCount) or (FLastActiveMDIChild <> ActiveMDIChild) then begin
    FLastMDIChildCount := MDIChildCount;
    FLastActiveMDIChild := ActiveMDIChild;
    RefreshTabs;
    lvExplorer.Invalidate;
  end;
end;

procedure TfMain.RefreshTabs;
var
  I: Integer;
  tab: TJvTabBarItem;
begin
  tbTabs.Tabs.BeginUpdate;
  try
    tbTabs.Tabs.Clear;
    for I := 0 to MDIChildCount - 1 do begin
      tab := TJvTabBarItem(tbTabs.Tabs.Add());
      if MDIChildren[I] is TfDoc then begin
        tab.Caption := ExtractFileName((MDIChildren[I] as TfDoc).CacheGrind.Cmd);
        tab.ImageIndex := 1;
      end else if MDIChildren[I] is TfEditor then begin
        tab.Caption := ExtractFileName((MDIChildren[I] as TfEditor).FileName);
        tab.ImageIndex := 2;
      end else
        tab.Caption := MDIChildren[I].Caption;
    end;
    if tbTabs.Tabs.Count > 0 then begin
      tbTabs.SelectedTab := tbTabs.Tabs[0];
      tbTabs.Visible := true;
    end else
      tbTabs.Visible := false;
  finally
    tbTabs.Tabs.EndUpdate;
  end;
end;

procedure TfMain.cnChangeNotify(Sender: TObject; Dir: String;
  Actions: TJvChangeActions);
begin
  sb.Panels[0].Text := 'Working folder modification detected.'
    +' Preparing to refresh Explorer file list...';
  sb.SimplePanel := False;
  sb.Repaint;
  tRefreshExplorer.Enabled := False;
  tRefreshExplorer.Enabled := True;
end;

procedure TfMain.tRefreshExplorerTimer(Sender: TObject);
begin
  tRefreshExplorer.Enabled := False;
  RefreshExplorer;
end;

procedure TfMain.tbTabsTabClosed(Sender: TObject; Item: TJvTabBarItem);
begin
  MDIChildren[Item.Index].Close;
end;

procedure TfMain.tbTabsTabSelected(Sender: TObject; Item: TJvTabBarItem);
begin
  if (Item <> nil) and (Item.Index < MDIChildCount) then
    MDIChildren[Item.Index].Show;
end;

procedure TfMain.AppInstancesCmdLineReceived(Sender: TObject;
  CmdLine: TStrings);
var
  i: Integer;
begin
  for i := 0 to CmdLine.Count - 1 do begin
    Open(CmdLine[i]);
  end;
end;

procedure TfMain.FormShow(Sender: TObject);
var
  i: Integer;
begin
  // open stuff from command line
  // Note: You can't move this to onCreate because the MDI form
  // has to be active first before creating an MDI child
  for i := 1 to ParamCount do
    Open(ParamStr(i));
end;

end.
