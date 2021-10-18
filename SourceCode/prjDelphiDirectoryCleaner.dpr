program prjDelphiDirectoryCleaner;

{$APPTYPE CONSOLE}

// DeleteFile ve FindClose metotlar�n�n d�zg�n �al��abilmesi i�in
// uses k�sm�nda WinTypes uniti, SysUtils'in �n�nde olmal�d�r
// Yoksa FindClose metodunda a�a��daki koddaki gibi TSearchRec
// yerine Cardinal t�r�nde parametre al�yor
// bu nokta �nemli dikkat edilmeli
uses
  Windows, WinTypes, SysUtils;

var
  directoryPath: string;


// bu metot recursive bir �ekilde belirtilen klas�r� dola��yor
// varsa alt klas�r�ne gidiyor
// yoksa da dosyan�n isimlerini kontrol ediyor
// dosya uzant�s� .dcu olan veya .~ gibi olan b�t�n dosyalar�
// tek tek siliyor
// sildi�i dosyalar�n bilgilerini de console �zerinde g�steriyor

procedure DeleteTempFiles(directoryPath: string);
var
  deleteFileRec: TSearchRec;
  result: Integer;
begin
  result := FindFirst(directoryPath + '\*.*', faDirectory, deleteFileRec);
  while result = 0 do
  begin
    if (deleteFileRec.Name <> '.') and (deleteFileRec.Name <> '..') then
    begin
      DeleteTempFiles(directoryPath + '\' + deleteFileRec.Name);
    end;
    result := FindNext(deleteFileRec);
  end;
  FindClose(deleteFileRec);

  result := FindFirst(directoryPath + '\*.~*', faAnyFile, deleteFileRec);
  while result = 0 do
  begin
    if not DeleteFile(PAnsiChar(directoryPath + deleteFileRec.Name)) then
    begin
      FileSetAttr(directoryPath + deleteFileRec.Name, 0);
      DeleteFile(PAnsiChar(directoryPath + '\' + deleteFileRec.Name));
      Writeln('The file ' + directoryPath + '\' + deleteFileRec.Name + ' has been deleted');
    end;
    result := FindNext(deleteFileRec);
  end;
  FindClose(deleteFileRec);

  result := FindFirst(directoryPath + '\*.dcu', faAnyFile, deleteFileRec);
  while result = 0 do
  begin
    if not DeleteFile(PAnsiChar(directoryPath + deleteFileRec.Name)) then
    begin
      FileSetAttr(directoryPath + deleteFileRec.Name, 0);
      DeleteFile(PAnsiChar(directoryPath + '\' + deleteFileRec.Name));
      Writeln('The file ' + directoryPath + '\' + deleteFileRec.Name + ' has been deleted');
    end;
    result := FindNext(deleteFileRec);
  end;
  FindClose(deleteFileRec);
end;

// program bir console application
// burada �nemli olan nokta ise
// e�er bu exe dosyas� �al��t�r�l�rken parametre alm��sa
// ald��� parametre dosyalar�n silinece�i dizin oluyor ve
// ilgili metoda y�nlendiriyor
// parametre almazsa bulundu�u klas�rdeki dosyalar� silmeye ba�l�yor
begin
  if ParamCount = 1 then
  begin
    directoryPath := ParamStr(1);
    if DirectoryExists(directoryPath) then
    begin
      DeleteTempFiles(directoryPath);
    end;
  end
  else
  begin
    directoryPath := GetCurrentDir;
    DeleteTempFiles(directoryPath);
  end;
//  Writeln(directoryPath);
//  Writeln('Press a key to terminate program');
//  Readln(a);
end.

