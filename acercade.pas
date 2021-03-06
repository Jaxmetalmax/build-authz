{ This file is part of buildauthz

  Copyright (C) 2012 Max J. Rodríguez Beltran ing.maxjrb@gmail.com

  This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

unit acercade;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF WINDOWS}
  win32proc,
  {$ENDIF}
  Classes, SysUtils, FileUtil, Forms,
  Controls, Graphics, Dialogs, ComCtrls, StdCtrls, LCLIntf;

type

  { TfrmAcercade }

  TfrmAcercade = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    PageControl1: TPageControl;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure StaticText2Click(Sender: TObject);
    procedure StaticText3Click(Sender: TObject);
    procedure StaticText4Click(Sender: TObject);
  private
    { private declarations }
    function OSVersion:String;
  public
    { public declarations }
  end;

var
  frmAcercade: TfrmAcercade;

implementation

{$R *.lfm}

{ TfrmAcercade }

procedure TfrmAcercade.FormClick(Sender: TObject);
begin
     frmAcercade.Close;
end;

procedure TfrmAcercade.Button1Click(Sender: TObject);
begin
    frmAcercade.Close;
end;

procedure TfrmAcercade.FormCreate(Sender: TObject);
var
  lcOsver: string;
begin
    lcOsver:=OSVersion;
    Label3.Caption := 'Compilado para: S.O. ' + lcOsver;
end;

procedure TfrmAcercade.Label5Click(Sender: TObject);
begin
    OpenURL('http://jax-metalmax.blogspot.mx/2012/09/svn-control-de-acceso-con-authz.html');
end;

procedure TfrmAcercade.StaticText1Click(Sender: TObject);
begin
    OpenURL('http://jaxmaxblogit.tk');
end;

procedure TfrmAcercade.StaticText2Click(Sender: TObject);
begin
  OpenURL('http://www.apache.org/licences/LICENCE-2.0');
end;

procedure TfrmAcercade.StaticText3Click(Sender: TObject);
begin
  OpenURL('http://www.gnu.org/licences/');
end;

procedure TfrmAcercade.StaticText4Click(Sender: TObject);
begin
  OpenURL('https://code.google.com/p/build-authz/');
end;

Function TfrmAcercade.OSVersion:String;
begin
    {$IFDEF Linux}
        OSVersion := 'Linux Kernel';
    {$ELSE}
    {$IFDEF LCLcarbon}
        OSVersion := 'Mac Os X';
    {$IFDEF UNIX}
        OSVersion := 'Unix ';
    {$ELSE}
    {$IFDEF WINDOWS}
        if WindowsVersion = wv95 then OSVersion := 'Windows 95 '
   	    else if WindowsVersion = wvNT4 then OSVersion := 'Windows NT v.4 '
   	    else if WindowsVersion = wv98 then OSVersion := 'Windows 98 '
  	    else if WindowsVersion = wvMe then OSVersion := 'Windows ME '
  	    else if WindowsVersion = wv2000 then OSVersion := 'Windows 2000 '
  	    else if WindowsVersion = wvXP then OSVersion := 'Windows XP '
  	    else if WindowsVersion = wvServer2003 then OSVersion := 'Windows Server 2003 '
  	    else if WindowsVersion = wvVista then OSVersion := 'Windows Vista '
  	    else if WindowsVersion = wv7 then OSVersion := 'Windows 7 '
  	    else OSVersion:= 'Windows ';
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
end;

end.
