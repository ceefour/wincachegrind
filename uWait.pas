unit uWait;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TfWait = class(TForm)
    lWait: TLabel;
    pbWait: TProgressBar;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fWait: TfWait;

implementation

{$R *.dfm}

procedure TfWait.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfWait.FormDestroy(Sender: TObject);
begin
  fWait := nil;
end;

end.
