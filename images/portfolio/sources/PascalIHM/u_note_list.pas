unit u_note_list;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, Grids, StdCtrls, u_liste;

type

  { Tf_note_list }

  Tf_note_list = class(TF_liste)
    procedure Init (affi : boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  f_note_list: Tf_note_list;

implementation

{$R *.lfm}

uses u_feuille_style;

procedure Tf_note_list.Init (affi : boolean);
begin
pnl_titre.Visible := false;
style.panel_travail(pnl_btn);
style.panel_travail(pnl_affi);
style.grille (sg_liste);
sg_liste.Columns[2].Alignment:=taRightJustify;
pnl_btn_page.Hide;
btn_line_detail.Hide;
pnl_btn_page.Visible := false;
pnl_btn_ligne.Visible := false;
end;

end.

