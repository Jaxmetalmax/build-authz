{ This file is part of buildauthz

  Copyright (C) 2012 Max J. Rodríguez Beltran ing.maxjrb@gmail.com

  This source is free software; you can redistribute it and/or modify it under
  the terms of the GNU General Public License as published by the Free
  Software Foundation; either version 2 of the License, or (at your option)
  any later version.

  This code is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  A copy of the GNU General Public License is available on the World Wide Web
  at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
  to the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
  MA 02111-1307, USA.
}


unit buildauthz;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  ComCtrls, ActnList, StdCtrls, Buttons, Grids, Menus, ExtCtrls, acercade;

type

  { TfrmBuildAuthz }

  TfrmBuildAuthz = class(TForm)
    AddComboGrupo: TAction;
    AddComboUser: TAction;
    ActionList1: TActionList;
    btnLectEscr: TBitBtn;
    btnLectTodos: TBitBtn;
    btnLectura: TBitBtn;
    btnRestricted: TBitBtn;
    btnSeleccionaDir: TBitBtn;
    btnLimpia: TBitBtn;
    btnAddRow: TBitBtn;
    btnAddCol: TBitBtn;
    Cancela: TAction;
    CargaArchivo: TAction;
    cmbUsuarios: TComboBox;
    cmbGrupos: TComboBox;
    GroupBox1: TGroupBox;
    imglstTreeview: TImageList;
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
    lstGrupos: TListBox;
    grdGrupos: TStringGrid;
    Memo1: TMemo;
    Memo2: TMemo;
    pmBorraGrupo: TMenuItem;
    pmBorra: TMenuItem;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    svdlgAuthz: TSaveDialog;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    ToolBar1: TToolBar;
    btnNuevo: TToolButton;
    btnBuildAuthz: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    btnCarga: TToolButton;
    btnAcercade: TToolButton;
    ToolButton4: TToolButton;
    btnGuarda: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    btnCerrar: TToolButton;
    TreeView1: TTreeView;
    txtUsuario: TEdit;
    GuardaArchivo: TAction;
    ImageList1: TImageList;
    Label1: TLabel;
    lstUsuarios: TListBox;
    NuevoUsuario: TAction;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    txtGrupo: TEdit;
    procedure AddComboGrupoExecute(Sender: TObject);
    procedure AddComboUserExecute(Sender: TObject);
    procedure btnBuildAuthzClick(Sender: TObject);
    procedure btnCargaClick(Sender: TObject);
    procedure btnGuardaClick(Sender: TObject);
    procedure btnLectTodosClick(Sender: TObject);
    procedure btnNuevoClick(Sender: TObject);
    procedure btnSeleccionaDirClick(Sender: TObject);
    procedure btnLimpiaClick(Sender: TObject);
    procedure btnAddColClick(Sender: TObject);
    procedure btnAddRowClick(Sender: TObject);
    procedure btnLectEscrClick(Sender: TObject);
    procedure btnLecturaClick(Sender: TObject);
    procedure btnRestrictedClick(Sender: TObject);
    procedure cmbGruposEditingDone(Sender: TObject);
    procedure cmbUsuariosEditingDone(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure grdGruposSelectEditor(Sender: TObject; aCol, aRow: Integer;
      var Editor: TWinControl);
    procedure lstGruposDblClick(Sender: TObject);
    procedure lstUsuariosDblClick(Sender: TObject);
    procedure pmBorraClick(Sender: TObject);
    procedure pmBorraGrupoClick(Sender: TObject);
    procedure btnCerrarClick(Sender: TObject);
    procedure btnAcercadeClick(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
    procedure txtGrupoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure txtUsuarioKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
  private
    { private declarations }
  public
    { public declarations }
    procedure AddDirectorios(elNodo: TTreeNode; cPath: String);
    procedure LimpiaControles();
    procedure CargaTreeview(cPath: String);
  end;

var
  frmBuildAuthz: TfrmBuildAuthz;

implementation

{$R *.lfm}

{ TfrmBuildAuthz }


procedure TfrmBuildAuthz.FormCreate(Sender: TObject);
begin
    //definimos las opciones de carga y guardado del gridview
    //para que cargue la configuración completa de este.
    grdGrupos.SaveOptions := [soDesign,soPosition,soAttributes,soContent];
end;

procedure TfrmBuildAuthz.FormShow(Sender: TObject);
begin
    //Al mostrarse siempre limpiar controles
    LimpiaControles();
end;

procedure TfrmBuildAuthz.btnNuevoClick(Sender: TObject);
begin
    {
      Proceso que invoca el al procedure "LimpiaControles" para comenza
      un proyecto nuevo.
    }
    LimpiaControles();
    frmBuildAuthz.Caption:='Build Authz';
end;

procedure TfrmBuildAuthz.btnCargaClick(Sender: TObject);
var
  lcArchivoConfig: TStringList;
  lnInicio, lnNodo, lnItems: integer;
  lcFileName: string;
begin
    {
      Proceso para cargar la configuración del proyecto guardado.
    }
    if OpenDialog1.Execute then begin
        {
         creamos un stringlist donde cargaremos en memoria
         el archivo de configuración
        }

        lcArchivoConfig := TStringList.Create;
        lcArchivoConfig.LoadFromFile(OpenDialog1.FileName);

        if lcArchivoConfig[1] <> '[Sección Grupos]'then begin

            lstUsuarios.Items.Clear;
            lnInicio:=1;

            {
             Vamos leyendo las secciones del archivo de configuración
             y limpiamos los controles donde cargaremos esa información
             antes de cargarla.
            }
            {sección de lista de usuarios}
            repeat
                lstUsuarios.Items.Add(lcArchivoConfig[lnInicio]);
                lnInicio:=lnInicio+1;
            until lcArchivoConfig[lnInicio] = '[Sección Grupos]';
            lnInicio:=lnInicio+1;

            {sección de lista de grupos}
            lstGrupos.Items.Clear;
            repeat
                lstGrupos.Items.Add(lcArchivoConfig[lnInicio]);
                lnInicio:=lnInicio+1;
            until lcArchivoConfig[lnInicio] = '[Sección Treeview]';

            {Carga de treeview}
            TreeView1.Items.Clear;
            TreeView1.LoadFromFile(OpenDialog1.FileName+'.trv');
            lnItems:=TreeView1.Items.Count;
            lnInicio:=lnInicio+1;
            for lnNodo:=0 to lnItems-1 do begin
                TreeView1.Items.Item[lnNodo].ImageIndex:=0;
                TreeView1.Items.Item[lnNodo].SelectedIndex:=0;
            end;
            lnInicio:=lnInicio+2;

            {Carga de vista previa}
            Memo1.Lines.Clear;
            repeat
                Memo1.Lines.Append(lcArchivoConfig[lnInicio]);
                lnInicio:=lnInicio+1;
            until lcArchivoConfig[lnInicio] = '[Sección Grid]';
            lnInicio:=lnInicio+2;

            {Carga de grid}
            grdGrupos.Clear;
            grdGrupos.LoadFromFile(OpenDialog1.FileName+'.xml');
            grdGrupos.Refresh;
            lnInicio:=lnInicio+1;

            {Carga de combobox de usuarios}
            cmbUsuarios.Items.Clear;
            repeat
                cmbUsuarios.Items.Append(lcArchivoConfig[lnInicio]);
                lnInicio:=lnInicio+1;
            until lcArchivoConfig[lnInicio] = '[Sección combogrupo]';
            lnInicio:=lnInicio+1;

            {Carga de combobox de grupos}
            cmbGrupos.Items.Clear;
            repeat
                cmbGrupos.Items.Append(lcArchivoConfig[lnInicio]);
                lnInicio:=lnInicio+1;
            until lcArchivoConfig[lnInicio] = '[fin]';

            lcArchivoConfig.Free;

            lcFileName:=OpenDialog1.FileName;

            Delete(lcFileName,Length(lcFileName)-6,7);
            frmBuildAuthz.Caption:= 'Build Authz - ' + lcFileName;
        end;
    end;
end;

procedure TfrmBuildAuthz.btnGuardaClick(Sender: TObject);
var
  lcArchivo: TextFile;
  lnInicio: integer;
  lcFileName: String;
begin
    {
      Proceso para guardar la configuración del proyecto guardado.
    }

    if SaveDialog1.Execute then begin
        AssignFile(lcArchivo,SaveDialog1.FileName);
        try
            Rewrite(lcArchivo);
            WriteLn(lcArchivo,'#Proyecto de configuración Authz');

            for lnInicio:=0 to lstUsuarios.Items.Count-1 do begin
                WriteLn(lcArchivo,lstUsuarios.Items[lnInicio]);
            end;

            WriteLn(lcArchivo,'[Sección Grupos]');

            for lnInicio:=0 to lstGrupos.Items.Count-1 do begin
                WriteLn(lcArchivo,lstGrupos.Items[lnInicio]);
            end;

            WriteLn(lcArchivo,'[Sección Treeview]');
            TreeView1.SaveToFile(SaveDialog1.FileName+'.trv');
            WriteLn(lcArchivo,SaveDialog1.FileName+'.trv');

            WriteLn(lcArchivo,'[Sección vista previa]');
            for lnInicio:=0 to Memo1.Lines.Count-1 do begin
                WriteLn(lcArchivo,Memo1.Lines[lnInicio]);
            end;

            WriteLn(lcArchivo,'[Sección Grid]');
            grdGrupos.SaveToFile(SaveDialog1.FileName+'.xml');
            WriteLn(lcArchivo,SaveDialog1.FileName+'.xml');

            WriteLn(lcArchivo,'[Sección combouser]');
            for lnInicio:=0 to cmbUsuarios.Items.Count-1 do begin
                WriteLn(lcArchivo,cmbUsuarios.Items[lnInicio]);
            end;

            WriteLn(lcArchivo,'[Sección combogrupo]');
            for lnInicio:=0 to cmbGrupos.Items.Count-1 do begin
                WriteLn(lcArchivo,cmbGrupos.Items[lnInicio]);
            end;

            WriteLn(lcArchivo,'[fin]');
        finally
            CloseFile(lcArchivo);
        end;
        lcFileName:=SaveDialog1.FileName;

        Delete(lcFileName,Length(lcFileName)-6,7);
        frmBuildAuthz.Caption:= 'Build Authz - ' + lcFileName;
    end;
end;

procedure TfrmBuildAuthz.btnBuildAuthzClick(Sender: TObject);
var
  lnCol, lnRow: integer;
  lcGrupo: string;
begin
    {
      Proceso para armar el archivo authz que usaremos
      para nuestro repositorio.
    }
    if svdlgAuthz.Execute then begin
        Memo2.Lines.Append(' ');
        Memo2.Lines.Append('[groups]');
        {
         Ciclo para armar los grupos, en base al grid.
        }
        for lnRow:=1 to grdGrupos.RowCount-1 do begin
            lcGrupo:='';
            for lnCol:=0 to grdGrupos.Columns.Count-1 do begin
                {
                 Si es la primer columna, escribe el nombre
                 del grupo y concatena un '='.
                }
                if lnCol = 0 then begin
                   lcGrupo:= grdGrupos.Cells[lnCol,lnRow]+' = ' ;
                end
                else begin
                    if grdGrupos.Cells[lnCol,lnRow] <> '' then begin
                       lcGrupo := lcGrupo+grdGrupos.Cells[lnCol,lnRow]+',';
                    end;
                end;
            end;
            //borramos la ultima coma
            Delete(lcGrupo,Length(lcGrupo),1);
            Memo2.Lines.Append(lcGrupo);
        end;

        Memo2.Lines.Append('');

        //anexamos el contenido de la vista previa
        //la cual contiene nuestros grupos y permisos
        //asignados a los directorios
        for lnRow:=0 to Memo1.Lines.Count-1 do begin
            Memo2.Lines.Append(Memo1.Lines[lnRow]);
        end;

        Memo2.Lines.SaveToFile(svdlgAuthz.FileName);
        ShowMessage('Archivo guardado.');
    end;
end;

procedure TfrmBuildAuthz.btnCerrarClick(Sender: TObject);
begin
    {
      Proceso para cerrar la aplicación.
    }
    frmBuildAuthz.Close;
end;

procedure TfrmBuildAuthz.btnAcercadeClick(Sender: TObject);
begin
    frmAcercade.ShowModal;
end;

procedure TfrmBuildAuthz.txtUsuarioKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    {
      Proceso que acciona la "acción" del actionlist para añadir grupo a la lista
      de grupos al presionar "enter"
    }
    if Key = 13 then ActionList1.ActionByName('AddComboUser').Execute;
end;

procedure TfrmBuildAuthz.txtGrupoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    {
      Proceso que acciona la "acción" del actionlist para añadir usuario a la lista
      de usuarios al presionar "enter"
    }
    if Key = 13 then ActionList1.ActionByName('AddComboGrupo').Execute;
end;

procedure TfrmBuildAuthz.AddComboUserExecute(Sender: TObject);
begin
    {
      Proceso de actionlist para añadir usuario a la lista
      de usuarios al presiona "enter"
    }
    if txtUsuario.Text <> '' then begin
        lstUsuarios.Items.Append(txtUsuario.Text);
        cmbUsuarios.Items.Append(txtUsuario.Text);
        txtUsuario.Text:='';
    end;
end;

procedure TfrmBuildAuthz.lstUsuariosDblClick(Sender: TObject);
var
   index: integer;
begin
    {
      Proceso que agrega el usuario seleccionado a la vista previa
      de permisos.
    }
    index := lstUsuarios.ItemIndex;

    if index > -1 then begin
        Memo1.Lines.Add(lstUsuarios.Items[index]);
    end;
end;

procedure TfrmBuildAuthz.pmBorraClick(Sender: TObject);
var
  index: integer;
  c: integer;
  r: integer;
  lcFound: boolean;
begin
    {
      Proceso para borrar usuario de la lista de usuarios y combobox de usuarios
      si el usuario seleccionado se encuentra en el grid, el usuario no puede
      ser borrado hasta ser borrado del grid.
    }
    index := lstUsuarios.ItemIndex;
    lcFound:= False;

    if index > -1 then begin
        for c:=0 to grdGrupos.Columns.Count-1 do begin
            for r:=1 to grdGrupos.RowCount-1 do begin
                if lstUsuarios.Items[index] = grdGrupos.Cells[c,r] then begin
                   ShowMessage('No puede borrar usuario si se encuentra en un grupo');
                   lcFound:=True;
                   Break;
                end;
            end;
        end;

        if not lcFound then begin
           lstUsuarios.Items.Delete(index);
           cmbUsuarios.Items.Delete(index);
        end;

    end;

end;

procedure TfrmBuildAuthz.pmBorraGrupoClick(Sender: TObject);
var
  index, r: integer;
  lcFound: boolean;
begin
    {
      Proceso para borrar grupo de la lista de grupos y combobox de grupos
      si el grupo seleccionado se encuentra en el grid, el grupo no puede
      ser borrado hasta ser borrado del grid.
    }
    index := lstGrupos.ItemIndex;
    lcFound:= False;

    if index > -1 then begin
        for r:=1 to grdGrupos.RowCount-1 do begin
            if lstGrupos.Items[index] = grdGrupos.Cells[0,r] then begin
                ShowMessage('No puede borrar grupo si se encuentra en el grid');
                lcFound:=True;
                Break;
            end;
        end;

        if not lcFound then begin
           lstGrupos.Items.Delete(index);
           cmbGrupos.Items.Delete(index);
        end;
    end;
end;

procedure TfrmBuildAuthz.AddComboGrupoExecute(Sender: TObject);
begin
    {
      Proceso de actionlist para añadir grupo a la lista
      de grupos al presiona "enter"
    }
    if txtGrupo.Text <> '' then begin
        lstGrupos.Items.Append(txtGrupo.Text);
        cmbGrupos.Items.Append(txtGrupo.Text);
        txtGrupo.Text:='';
    end;
end;

procedure TfrmBuildAuthz.lstGruposDblClick(Sender: TObject);
var
  index: integer;
begin
    {
      Proceso que agrega el grupo seleccionado a la vista previa
      de permisos.
    }
    index := lstGrupos.ItemIndex;

    if index > -1 then begin
        Memo1.Lines.Add('@'+lstGrupos.Items[index]);
    end;

end;

procedure TfrmBuildAuthz.grdGruposSelectEditor(Sender: TObject; aCol,
  aRow: Integer; var Editor: TWinControl);
begin
    {
      Proceso para asignar el control combobox, ya sea de usuarios
      o grupos, dependiendo de la columna seleccionada en el grid
    }
    if (aCol > 0) AND (aRow > 0) then begin
        if cmbUsuarios.Items.Count > 0 then begin
            cmbUsuarios.BoundsRect := grdGrupos.CellRect(aCol, aRow);
            cmbUsuarios.Text:=grdGrupos.Cells[grdGrupos.Col, grdGrupos.Row];
            Editor:=cmbUsuarios;
        end
    end
    else if (aCol = 0) AND (aRow > 0) then begin
        if cmbGrupos.Items.Count > 0 then begin
            cmbGrupos.BoundsRect := grdGrupos.CellRect(aCol, aRow);
            cmbGrupos.Text:=grdGrupos.Cells[grdGrupos.Col, grdGrupos.Row];
            Editor:=cmbGrupos;
        end
    end;
end;

procedure TfrmBuildAuthz.btnAddColClick(Sender: TObject);
var
  columnnew: TGridColumn;
begin
    {
      Proceso para agregar una columna para un usuario mas al grid
      *nota: como al crear el grid en su propiedad columns, se agregaron
      columnas, su propiedad colcount se vuelve de solo lectura, y se
      tienen que agregar columnas como en este proceso.
    }
    columnnew := grdGrupos.Columns.Add;
    columnnew.Width:=100;
    columnnew.Title.Caption:=' ';
end;

procedure TfrmBuildAuthz.btnAddRowClick(Sender: TObject);
begin
    {
      Proceso para agregar un renglón para un grupo mas al grid
      *nota: caso contrario, el grid no tiene una propiedad para agregar rebglones,
      entonces su propiedad rowcount se puede aumentar en tiempo de ejecución
      y se agrega renglones.
    }
    grdGrupos.RowCount:=grdGrupos.RowCount+1;
end;

procedure TfrmBuildAuthz.btnSeleccionaDirClick(Sender: TObject);
begin
    {
      Proceso para agregar estructura del repositorio al cual daremos permisos
    }

    if SelectDirectoryDialog1.Execute then begin
        CargaTreeview(SelectDirectoryDialog1.FileName);
    end;

end;

procedure TfrmBuildAuthz.AddDirectorios(elNodo: TTreeNode; cPath: String);
var
    sr: TSearchRec;
    lcFileAttr: Integer;
    theNewNode : tTreeNode;
begin
    {
      Proceso que es llamado por el proceso para agregar estructura del
      repositorio, este proceso es llamado recursivamente dependiendo
      de la profundidad de directorios que tenga el directorio raiz seleccionado.
    }
    {$IFDEF UNIX}
        lcFileAttr:= 48;
    {$ELSE}
        lcFileAttr:= faDirectory;
    {$ENDIF}

    if FindFirst(cPath+PathDelim+'*', faDirectory, sr) = 0 then begin
        repeat
            if sr.Attr = lcFileAttr then begin
                if (sr.Name = '.') or (sr.Name = '..') then continue;
                    theNewNode := TreeView1.Items.AddChild(elNodo,elNodo.Text+'/'+sr.name);
                    theNewNode.ImageIndex:=0;
                    theNewNode.SelectedIndex:=0;
                    AddDirectorios(theNewNode,cPath+PathDelim+sr.Name);
            end;
        until FindNext(sr) <> 0;
        FindClose(sr);
    end;

end;

procedure TfrmBuildAuthz.TreeView1DblClick(Sender: TObject);
var
  nivel: integer;
begin
    {
      Proceso que agrega al memo(vista previa) la ruta del directorio seleccionada
      en el treeview
    }
    nivel:= TreeView1.Selected.Level;

    if nivel = 0 then begin;
        Memo1.Lines.Add('[/]');
    end;

    if  nivel >= 1 then begin
        Memo1.Lines.Append('');
        Memo1.Lines.Append('[/' +TreeView1.Selected.Text+']');
    end;

end;

procedure TfrmBuildAuthz.btnLecturaClick(Sender: TObject);
begin
    {
      Proceso que agrega permisos de lectura al usuario o grupo
    }
    Memo1.Lines[Memo1.Lines.Count-1]:=Memo1.Lines[Memo1.Lines.Count-1]+' = r';
end;

procedure TfrmBuildAuthz.btnLectEscrClick(Sender: TObject);
begin
    {
      Proceso que agrega permisos de lectura y escritura al usuario o grupo
    }
    Memo1.Lines[Memo1.Lines.Count-1]:=Memo1.Lines[Memo1.Lines.Count-1]+' = rw';
end;

procedure TfrmBuildAuthz.btnLectTodosClick(Sender: TObject);
begin
    {
      Proceso que agrega permisos de lectura a todos
    }
    Memo1.Lines.Append('* = r');
end;

procedure TfrmBuildAuthz.btnRestrictedClick(Sender: TObject);
begin
    {
      Proceso que restringe todos los permisos a todo aquel que no sea
      un usuario o grupo
    }
    Memo1.Lines.Append(' * = ');
end;

procedure TfrmBuildAuthz.btnLimpiaClick(Sender: TObject);
begin
    {
      Proceso para limpiar la vista previa
    }
    Memo1.Lines.Clear;
end;

procedure TfrmBuildAuthz.cmbGruposEditingDone(Sender: TObject);
begin
    grdGrupos.Cells[grdGrupos.Col, grdGrupos.Row]:=cmbGrupos.Text;
end;

procedure TfrmBuildAuthz.cmbUsuariosEditingDone(Sender: TObject);
begin
    grdGrupos.Cells[grdGrupos.Col, grdGrupos.Row]:=cmbUsuarios.Text;
end;

procedure TfrmBuildAuthz.LimpiaControles();
begin
    txtUsuario.Text:='';
    lstUsuarios.Items.Clear;
    txtGrupo.Text:='';
    lstGrupos.Items.Clear;
    TreeView1.Items.Clear;
    Memo1.Clear;
    cmbGrupos.Items.Clear;
    cmbUsuarios.Items.Clear;
    grdGrupos.Clean;
    txtUsuario.SetFocus;
end;

procedure TfrmBuildAuthz.CargaTreeview(cPath: String);
var
  lcSearch: TSearchRec;
  lcFileAttr: integer;
  lcFatherNode: TTreeNode;
  lcChildNode: TTreeNode;
  lcPath: String;
begin
    {
      Proceso para agregar estructura del repositorio al cual daremos permisos
    }
    {$IFDEF UNIX}
        lcFileAttr:= 48;
    {$ELSE}
        lcFileAttr:= faDirectory;
    {$ENDIF}
    //SelectDirectoryDialog1.Execute;
    //lcPath:=SelectDirectoryDialog1.FileName;
    lcPath:=cPath;
    TreeView1.Items.Clear;

    if Length(lcPath) > 0 then begin
        //se comento ya que causaba error al crear y despues cargar contenido de otro treeview
        //lcFatherNode:= TTreeNode.Create(TreeView1.Items);
        lcFatherNode:= TreeView1.Items.AddFirst(lcFatherNode, lcPath); // se añade el nodo raiz
        lcFatherNode.ImageIndex:=0;
        lcFatherNode.SelectedIndex:=0;
        lcFatherNode.Expanded:=True;
    end;

    lcPath:=lcPath+PathDelim;

    If FindFirst(lcPath+'*',faDirectory,lcSearch)=0 then begin
        repeat
            if lcSearch.Attr = lcFileAttr then begin
                if (lcSearch.Name = '.') or (lcSearch.Name = '..') then continue;
                lcChildNode:= TreeView1.Items.AddChild(lcFatherNode,lcSearch.Name);
                lcChildNode.ImageIndex:=0;
                lcChildNode.SelectedIndex:=0;
                AddDirectorios(lcChildNode,lcPath+lcSearch.Name);
            end;
        until FindNext(lcSearch) <> 0;
        FindClose(lcSearch);
    end;

    TreeView1.Refresh;
end;

end.

