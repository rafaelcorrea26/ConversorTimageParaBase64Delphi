unit fCadastroProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls, Vcl.StdCtrls, DB, clipbrd, jpeg, Datasnap.Provider,
  Datasnap.DBClient, System.Types, FireDAC.Comp.Client, uConexao, System.ImageList, Vcl.ImgList,
  Vcl.Grids, Vcl.DBGrids, uImagem, uHelpersImagensBase64;

type
  TfrmCadastroProduto = class(TForm)
    pnlTitulo: TPanel;
    pnlBotoes: TPanel;
    pnlCentral: TPanel;
    btnSair: TButton;
    btnSalvar: TButton;
    pnlImagem1: TPanel;
    imgPrincipal: TImage;
    imlIconsBlack24dp: TImageList;
    btnCarregar: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnCarregarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure IncluirImagem;
    procedure CarregaImagem;

  public
    { Public declarations }
  end;

var
  frmCadastroProduto: TfrmCadastroProduto;

implementation

{$R *.dfm}

procedure TfrmCadastroProduto.btnSairClick(Sender: TObject);
begin
  close;
end;

procedure TfrmCadastroProduto.btnSalvarClick(Sender: TObject);
begin
  try
    IncluirImagem;
    ShowMessage('Imagem Salva com sucesso.');
    close;
  except
    on E: Exception do
    begin
      ShowMessage('Problema ao alterar/incluir a imagem');
    end;
  end;
end;

procedure TfrmCadastroProduto.btnCarregarClick(Sender: TObject);
begin
  CarregaImagem;
end;

procedure TfrmCadastroProduto.FormCreate(Sender: TObject);
begin
  imgPrincipal.Popup;
end;

procedure TfrmCadastroProduto.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmCadastroProduto.FormShow(Sender: TObject);
begin
  CarregaImagem;
end;

procedure TfrmCadastroProduto.IncluirImagem;
var
  lImagem: TImagem;
begin
  lImagem := TImagem.Create;
  try
    lImagem.IMAGEM_BASE64 := imgPrincipal.Base64;
    lImagem.ID_PRODUTO := 1;
    lImagem.NUMERO_IMAGEM := 1;
    lImagem.incluir(True);
  finally
    lImagem.Free;
  end;
end;

procedure TfrmCadastroProduto.CarregaImagem;
var
  lImagem: TImagem;
begin
  lImagem := TImagem.Create;
  try
    lImagem.CarregaImagens(imgPrincipal);
  finally
    lImagem.Free;
  end;

end;

end.
