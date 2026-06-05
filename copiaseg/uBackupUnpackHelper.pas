unit uBackupUnpackHelper;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Dialogs, Process, FileCtrl;

procedure FLX_UnpackBackupInteractive(AOwner: TComponent; const AHomeUsr: string);

implementation

function ShellQuote(const S: string): string;
begin
  Result := '''' + StringReplace(S, '''', '''"''"''', [rfReplaceAll]) + '''';
end;

procedure FLX_UnpackBackupInteractive(AOwner: TComponent; const AHomeUsr: string);
var
  OD: TOpenDialog;
  SD: TSelectDirectoryDialog;
  Pass, DestBase, ArchivePath, Cmd: string;
  P: TProcess;
begin
  OD := TOpenDialog.Create(AOwner);
  SD := TSelectDirectoryDialog.Create(AOwner);
  try
    OD.Title := 'Seleccionar backup comprimido';
    OD.Filter := 'Backups 7z|*.7z|Todos los archivos|*.*';
    OD.InitialDir := IncludeTrailingPathDelimiter(AHomeUsr) + 'backups' + PathDelim + 'facturlinex';

    if not OD.Execute then
      Exit;

    ArchivePath := OD.FileName;

    DestBase := IncludeTrailingPathDelimiter(AHomeUsr) + 'restores';
    SD.Title := 'Seleccionar carpeta de destino';
    SD.InitialDir := DestBase;
    if not SD.Execute then
      Exit;
    DestBase := SD.FileName;

    Pass := '';
    if not InputQuery('Descomprimir backup', 'Introduzca la contraseña del backup:', Pass) then
      Exit;
    if Trim(Pass) = '' then
    begin
      ShowMessage('Debe indicar la contraseña del backup.');
      Exit;
    end;

    Cmd :=
      'sudo /usr/local/sbin/flx_unpack_backup.sh ' +
      ShellQuote(ArchivePath) + ' ' +
      ShellQuote(Pass) + ' ' +
      ShellQuote(DestBase) +
      '; echo; echo "Proceso finalizado. Pulse ENTER para cerrar..."; read dummy';

    P := TProcess.Create(nil);
    try
      P.Executable := 'x-terminal-emulator';
      P.Parameters.Add('-e');
      P.Parameters.Add('bash');
      P.Parameters.Add('-lc');
      P.Parameters.Add(Cmd);
      P.Options := [];
      P.Execute;
    finally
      P.Free;
    end;
  finally
    SD.Free;
    OD.Free;
  end;
end;

end.
