unit uFLX_Log;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

procedure FLX_WriteLog(const AModule, AMessage: string);

implementation

const
  FLX_LOG_MAX_SIZE = 5 * 1024 * 1024;  // 5 MB rotación
  FLX_LOG_RETENTION_DAYS = 90;         // Borrar logs con más de 90 días
  FLX_LOG_MAX_FILES = 200;             // Máximo de archivos permitidos

var
  LogDir: string;
  LogBaseName: string;

// ============================================================
// Devuelve nombre de log del día actual
// ============================================================
function FLX_GetTodayLogFileName: string;
var
  DatePart: string;
begin
  DatePart := FormatDateTime('yyyymmdd', Date);
  Result := IncludeTrailingPathDelimiter(LogDir) +
            LogBaseName + '_' + DatePart + '.log';
end;

// ============================================================
// Obtener tamaño de fichero
// ============================================================
function FLX_GetFileSize(const AFileName: string): Int64;
var
  FS: TFileStream;
begin
  Result := -1;
  if not FileExists(AFileName) then Exit;

  FS := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    Result := FS.Size;
  finally
    FS.Free;
  end;
end;

// ============================================================
// Rotación por tamaño
// ============================================================
procedure FLX_RotateIfNeeded(const AFileName: string);
var
  Size: Int64;
  NewName, TS: string;
begin
  try
    Size := FLX_GetFileSize(AFileName);
    if (Size >= 0) and (Size >= FLX_LOG_MAX_SIZE) then
    begin
      TS := FormatDateTime('yyyymmdd_hhnnss', Now);
      NewName := IncludeTrailingPathDelimiter(LogDir) +
                 LogBaseName + '_' + TS + '.log';
      RenameFile(AFileName, NewName);
    end;
  except
    // Silencioso
  end;
end;

// ============================================================
// LIMPIEZA AUTOMÁTICA
// ============================================================
procedure FLX_CleanupOldLogs;
var
  SR: TSearchRec;
  FullPath: string;
  FileDate: TDateTime;
  FilesList: TStringList;
  i: Integer;
begin
  FilesList := TStringList.Create;
  try
    if FindFirst(LogDir + '*.log', faAnyFile, SR) = 0 then
    begin
      repeat
        FullPath := LogDir + SR.Name;

        // Obtener fecha del fichero
        FileDate := FileDateToDateTime(SR.Time);

        // #1 — Eliminación por antigüedad
        if (Now - FileDate) > FLX_LOG_RETENTION_DAYS then
        begin
          DeleteFile(FullPath);
          Continue;
        end;

        // #2 — Guardar para control de exceso de ficheros
        FilesList.Add(FullPath);

      until FindNext(SR) <> 0;
      FindClose(SR);
    end;

    // #3 — Si hay más ficheros que el límite, borrar los más antiguos
    if FilesList.Count > FLX_LOG_MAX_FILES then
    begin
      FilesList.Sort; // Ordena por nombre → coincide con antigüedad por fecha en nombre
      for i := 0 to FilesList.Count - FLX_LOG_MAX_FILES - 1 do
        DeleteFile(FilesList[i]);
    end;

  finally
    FilesList.Free;
  end;
end;

// ============================================================
// ESCRITURA DE LOG
// ============================================================
procedure FLX_WriteLog(const AModule, AMessage: string);
var
  F: TextFile;
  FileName: string;
  Linea: string;
begin
  try
    ForceDirectories(LogDir);

    FileName := FLX_GetTodayLogFileName;

    FLX_RotateIfNeeded(FileName);

    AssignFile(F, FileName);
    if FileExists(FileName) then
      Append(F)
    else
      Rewrite(F);

    Linea :=
      FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) +
      ' [' + AModule + '] ' + AMessage;

    Writeln(F, Linea);
    CloseFile(F);
  except
    // Silencioso
  end;
end;

// ============================================================
// INITIALIZATION
// ============================================================
initialization
  LogDir :=
    IncludeTrailingPathDelimiter(
      GetEnvironmentVariable('HOME')
    ) + '.local/share/verifactu/logs/';

  LogBaseName := 'facturlinex';

  // Ejecuta limpieza automática al arrancar
  FLX_CleanupOldLogs;

end.

