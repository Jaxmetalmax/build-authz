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
program authzmanager;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, buildauthz, acercade;

{$R *.res}

begin
  Application.Title:='Build Authz V1.0';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfrmBuildAuthz, frmBuildAuthz);
  Application.CreateForm(TfrmAcercade, frmAcercade);
  Application.Run;
end.

