program TimageParaBase64;

uses
  Vcl.Forms,
  uHelpersImagensBase64 in 'Classes\uHelpersImagensBase64.pas',
  uConexao in 'Classes\uConexao.pas',
  uImagem in 'Classes\uImagem.pas',
  fCadastroProduto in 'Form\fCadastroProduto.pas' {frmCadastroProduto};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmCadastroProduto, frmCadastroProduto);
  Application.Run;
end.
