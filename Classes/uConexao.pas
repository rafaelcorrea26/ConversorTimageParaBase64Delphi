unit uConexao;

interface

uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, Vcl.Dialogs, Vcl.Forms;

Type
  TConexao = class(TInterfacedObject)
  private
    FConexao: TFDConnection;
    function DevolveCaminhoBanco: string;
    function Diretorio: string;
    function CriaBancoDados: Boolean;

    class var FObjetoConexao: TConexao;
    class function GetObjetoConexao: TConexao; static;

  public
    constructor Create;
    destructor Destroy; override;
    function ConnectionBD: TFDConnection;
    class procedure ReleaseMe;

    class property ObjetoConexao: TConexao read GetObjetoConexao write FObjetoConexao;

  end;

implementation

uses
  System.SysUtils;

{ TConexao }

function TConexao.ConnectionBD: TFDConnection;
begin
  Result := FConexao;
end;

constructor TConexao.Create;
begin
  FConexao := TFDConnection.Create(nil);
  FConexao.Params.DriverID := 'FB';
  FConexao.Params.Database := DevolveCaminhoBanco;
  FConexao.Params.UserName := 'SYSDBA';
  FConexao.Params.Password := 'masterkey';
  FConexao.Connected := true;
  // showmessage('Banco conectou!.');
end;

function TConexao.CriaBancoDados: Boolean;
begin
  FConexao.ExecSQL(' CREATE TABLE IMAGENS (                   ' +
    ' ID             INTEGER NOT NULL,                        ' +
    ' IMAGEM_BASE64  BLOB SUB_TYPE 0 SEGMENT SIZE 80,         ' +
    ' ID_PRODUTO     INTEGER,                                 ' +
    'NUMERO_IMAGEM  INTEGER                                   ');
end;

destructor TConexao.Destroy;
begin
  FreeAndNil(FConexao);
  inherited;
end;

function TConexao.DevolveCaminhoBanco: string;
var
  lArquivoTxT: TextFile;
  lHost: string;
  lLocal: string;
  lCaminho, lTipo: string;
  ConfiguracaoINI: string;

begin
  ConfiguracaoINI := Diretorio + 'configuracao.ini';

  if FileExists(ConfiguracaoINI) then
  begin
    AssignFile(lArquivoTxT, ConfiguracaoINI);
    Reset(lArquivoTxT);
    Readln(lArquivoTxT, lHost);
    Readln(lArquivoTxT, lLocal);
    Readln(lArquivoTxT, lTipo);
    lHost := trim(Copy(lHost, 6, 100));
    lLocal := trim(Copy(lLocal, 7, 150));
    lTipo := trim(Copy(lTipo, 6, 15));

    CloseFile(lArquivoTxT);
    lCaminho := lHost + ':' + lLocal;

    Result := lCaminho;
  end;
end;

function TConexao.Diretorio: string;
var
  lDiretorio: string;

begin
  lDiretorio := ExtractFilePath(Application.exeName);
  if Copy(lDiretorio, Length(lDiretorio), 1) <> '\' then
  begin
    lDiretorio := lDiretorio + '\';
  end;

  Result := lDiretorio;
end;

class function TConexao.GetObjetoConexao: TConexao;
begin
  if NOT Assigned(FObjetoConexao) then
  begin
    FObjetoConexao := TConexao.Create;
  end;

  Result := FObjetoConexao;
end;

class procedure TConexao.ReleaseMe;
begin
  if Assigned(FObjetoConexao) then
  begin
    FreeAndNil(FObjetoConexao);
  end;
end;

initialization

finalization

TConexao.ReleaseMe;

end.
