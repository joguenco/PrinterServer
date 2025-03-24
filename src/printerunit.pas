unit PrinterUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Interfaces, Printers, OSPrinters;

type

  { TPrinterPos }

  TPrinterPos = class
  private
    procedure WriteString(S: string);
    procedure OpenCashDrawer;
    procedure CutPaper;
  public
    procedure Ping;
  end;

var
  PrinterPos: TPrinterPos;

implementation

procedure TPrinterPos.WriteString(S: string);
var
  Written: integer;
begin
  Printer.Write(S[1], Length(S), Written);
end;

procedure TPrinterPos.Ping;
var
  i: integer;
begin
  with Printer do
  try
    RawMode := True;
    BeginDoc;
    OpenCashDrawer;
    WriteString('Pong' + LineEnding);
    for i := 1 to 6 do
      WriteString(LineEnding);
    CutPaper;
  finally
    EndDoc;
  end;

end;

procedure TPrinterPos.OpenCashDrawer;
var
  prnfile: System.Text;
  buffer: string;
begin
  try
    AssignFile(prnfile, 'opencashdrawer.txt');
    Reset(prnfile);

    while not EOF(prnfile) do
    begin
      Readln(prnfile, buffer);
      WriteString(buffer);
    end;

  finally
    CloseFile(prnfile);
  end;
end;

procedure TPrinterPos.CutPaper;
var
  prnfile: System.Text;
  buffer: string;
begin
  try
    AssignFile(prnfile, 'cutpaper.txt');
    Reset(prnfile);

    while not EOF(prnfile) do
    begin
      Readln(prnfile, buffer);
      WriteString(buffer);
    end;

  finally
    CloseFile(prnfile);
  end;
end;

end.
