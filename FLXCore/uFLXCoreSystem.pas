unit uFLXCoreSystem;
{$mode objfpc}{$H+}
interface
uses Classes, SysUtils, uFLXCorePaths;
type TFLXSystemTools=record OpenSSL,MariaDB,MySQL,Rsync,XdgOpen,Gio:string; end;
function FLXDetectSystemTools:TFLXSystemTools;
function FLXOpenSSLAvailable:Boolean;
function FLXMariaDBClientAvailable:Boolean;
implementation
function FLXDetectSystemTools:TFLXSystemTools; begin Result.OpenSSL:=FLXExecutablePath('openssl'); Result.MariaDB:=FLXExecutablePath('mariadb'); Result.MySQL:=FLXExecutablePath('mysql'); Result.Rsync:=FLXExecutablePath('rsync'); Result.XdgOpen:=FLXExecutablePath('xdg-open'); Result.Gio:=FLXExecutablePath('gio'); end;
function FLXOpenSSLAvailable:Boolean; begin Result:=FLXExecutablePath('openssl')<>''; end;
function FLXMariaDBClientAvailable:Boolean; begin Result:=(FLXExecutablePath('mariadb')<>'') or (FLXExecutablePath('mysql')<>''); end;
end.
