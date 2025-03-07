unit u_detail_inscription;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Grids, Menus, u_modele, u_loaddataset;

type

  { Tf_detail_inscription }

  Tf_detail_inscription = class(TForm)
    btn_retour: TButton;
    btn_annuler: TButton;
    btn_valider: TButton;
    cbb_sexe: TComboBox;
    cbb_filiere: TComboBox;
    edt_filiere: TEdit;
    edt_sexe: TEdit;
    edt_tel: TEdit;
    edt_portable: TEdit;
    edt_mail: TEdit;
    edt_ville: TEdit;
    edt_cp: TEdit;
    edt_adresse: TEdit;
    edt_nom: TEdit;
    edt_prenom: TEdit;
    edt_num: TEdit;
    lbl_moy_fil: TLabel;
    lbl_moy_etud: TLabel;
    lbl_titre: TLabel;
    lbl_filiere: TLabel;
    lbl_tel: TLabel;
    lbl_contact: TLabel;
    lbl_adresse: TLabel;
    lbl_prenom: TLabel;
    lbl_nom: TLabel;
    lbl_num: TLabel;
    lbl_ident: TLabel;
    lbl_portable: TLabel;
    lbl_mail: TLabel;
    mmo_filiere: TMemo;
    pnl_releve_note: TPanel;
    pnl_note_titre: TPanel;
    pnl_note: TPanel;
    pnl_filiere: TPanel;
    pnl_contact: TPanel;
    pnl_adresse: TPanel;
    pnl_ident: TPanel;
    pnl_detail: TPanel;
    pnl_btn: TPanel;
    pnl_titre: TPanel;
    procedure btn_annulerClick(Sender: TObject);
    procedure btn_retourClick(Sender: TObject);
    procedure cbb_filiereChange(Sender: TObject);
    procedure edt_filiereExit(Sender: TObject);
    procedure init ( idinf : string; affi : boolean);
    procedure detail ( idinf : string);
    procedure edit ( idinf : string);
    procedure add;
    procedure delete ( idinf : string);
    procedure edt_Enter (Sender : TObject );
  private
    procedure affi_page;
    procedure affi_filiere (num : string);
    function affi_erreur_saisie (erreur : string; lbl : TLabel; edt : TEdit) : boolean;
  public
    { public declarations }
  end;

var
  f_detail_inscription: Tf_detail_inscription;

implementation

{$R *.lfm}

uses u_feuille_style, u_list_inscription, u_note_list;

{ Tf_detail_inscription }

Var oldvaleur : string; // utilisée dans la modification pour comparer l’ancienne valeur avec la saisie
id : string; // variable active dans toute l'unité, contenant l'id inscription affichée
procedure Tf_detail_inscription.Init ( idinf : string; affi : boolean);
begin
style.panel_travail (pnl_titre);
style.panel_travail (pnl_btn);
style.panel_travail (pnl_detail);
style.panel_travail (pnl_ident);
style.label_titre (lbl_ident);
style.panel_travail (pnl_contact);
style.label_titre (lbl_contact);
style.panel_travail (pnl_adresse);
style.label_titre (lbl_adresse);
style.panel_travail (pnl_note);
style.panel_travail (pnl_filiere);
style.label_titre (lbl_filiere); style.memo_info (mmo_filiere);
style.label_titre (lbl_titre);
style.label_titre (lbl_moy_etud);
style.label_titre (lbl_moy_fil);
// initialisation filiere
edt_filiere.clear;
edt_filiere.ReadOnly :=affi;
mmo_filiere.clear;
mmo_filiere.ReadOnly :=true;
// initialisation contact
edt_tel.clear;
edt_tel.ReadOnly :=affi;
edt_portable.clear;
edt_portable.ReadOnly :=affi;
edt_mail.clear;
edt_mail.ReadOnly :=affi;
// initialisation adresse
edt_adresse.clear;
edt_adresse.ReadOnly :=affi;
edt_cp.clear;
edt_cp.ReadOnly :=affi;
edt_ville.clear;
edt_ville.ReadOnly :=affi;
// initialisation identification
edt_num.clear;
edt_num.ReadOnly :=affi;
edt_sexe.clear;
edt_sexe.ReadOnly :=affi;
edt_nom.clear;
edt_nom.ReadOnly :=affi;
edt_prenom.clear;
edt_prenom.ReadOnly :=affi;

btn_retour.visible :=affi; // visible quand affichage détail
btn_valider.visible :=NOT affi; // visible quand ajout/modification inscription
btn_annuler.visible :=NOT affi; // visible quand ajout/modification inscription
f_note_list.affi_data(modele.inscription_note(id));
// initialisation releve de notes
f_note_list.borderstyle := bsNone;
f_note_list.parent := pnl_releve_note;
f_note_list.align := alClient;
f_note_list.borderstyle := bsNone;
f_note_list.init(affi);
id := idinf;
f_note_list.affi_data(modele.inscription_note(idinf));
f_note_list.show;
IF NOT ( id = '') // affichage/modification
THEN affi_page;
show;
end;

procedure Tf_detail_inscription.edt_filiereExit(Sender: TObject);
begin
  edt_filiere.text := TRIM(cbb_filiere.text);
IF NOT ( edt_filiere.text = oldvaleur )
THEN affi_filiere (edt_filiere.text);
end;

procedure Tf_detail_inscription.btn_retourClick(Sender: TObject);
begin
  close;
end;

procedure Tf_detail_inscription.cbb_filiereChange(Sender: TObject);
begin
  affi_filiere (cbb_filiere.text);
  lbl_moy_fil.Caption := modele.moy_filiere(cbb_filiere.text);
end;

procedure Tf_detail_inscription.btn_annulerClick(Sender: TObject);
begin
  close;
end;

procedure Tf_detail_inscription.affi_page;
var
	flux : TLoadDataSet;

begin
     flux   := modele.inscription_num(id);
     flux.read;
     edt_num.text	:= flux.Get('id');
     edt_sexe.text	:= flux.Get('civ');
     edt_nom.text       := flux.get('nom');
     edt_prenom.text	:= flux.Get('prenom');
     edt_adresse.text	:= flux.Get('adresse');
     edt_cp.text	:= flux.Get('cp');
     edt_ville.text	:= flux.Get('ville');
     edt_tel.text	:= flux.Get('telephone');
     edt_portable.text	:= flux.Get('portable');
     edt_mail.text	:= flux.Get('mel');
     edt_filiere.text   := flux.Get('code');
     flux.destroy;
     affi_filiere	(edt_filiere.text);
end;

procedure Tf_detail_inscription.detail (idinf : string);
begin
init (idinf, true); // mode affichage
pnl_titre.caption := 'Détail d''une inscription';
btn_retour.setFocus;
edt_num.ReadOnly := true;
edt_nom.ReadOnly := true;
edt_prenom.ReadOnly := true;
edt_sexe.ReadOnly := true;
edt_adresse.ReadOnly := true;
edt_cp.ReadOnly := true;
edt_ville.ReadOnly := true;
edt_tel.ReadOnly := true;
edt_portable.ReadOnly := true;
edt_mail.ReadOnly := true;
edt_filiere.ReadOnly := true;
pnl_note.Visible := true;
cbb_sexe.Visible := false;
cbb_filiere.Visible :=false;
edt_sexe.Visible := true;
edt_filiere.Visible := true;
lbl_moy_etud.Caption := modele.moy_inscrit(idinf);
lbl_moy_fil.Caption := modele.moy_filiere(edt_filiere.text);
end;

procedure Tf_detail_inscription.edit (idinf : string);
begin
init (idinf, false);
pnl_titre.caption := 'Modification d''une inscription';
edt_num.ReadOnly := true;
pnl_note.Visible := true;
cbb_sexe.text := (edt_sexe.text);
cbb_filiere.text := (edt_filiere.text);
edt_filiere.Visible := false;
edt_sexe.Visible := false;
cbb_sexe.Visible := true;
cbb_filiere.Visible := true;
lbl_moy_etud.Caption := modele.moy_inscrit(idinf);
lbl_moy_fil.Caption := modele.moy_filiere(cbb_filiere.text);
end;

procedure Tf_detail_inscription.add;
begin
init ('',false); // pas de numéro d'inscription
pnl_titre.caption := 'Nouvelle inscription';
edt_num.setFocus;
pnl_note.Visible := false;
edt_sexe.Visible := false;
edt_filiere.Visible := false;
cbb_sexe.Visible := true;
cbb_filiere.Visible := true;
cbb_filiere.text := '';
affi_filiere (cbb_filiere.Text);
end;


procedure Tf_detail_inscription.delete (idinf : string);
begin
IF messagedlg ('Demande de confirmation'
,'Confirmez-vous la suppression de l''inscription n°' +idinf
,mtConfirmation, [mbYes,mbNo], 0, mbNo) = mrYes
THEN BEGIN
// suppression dans la base, complété par la suite
f_list_inscription.line_delete;
END;
end;

procedure Tf_detail_inscription.edt_Enter(Sender :
TObject);
begin
oldvaleur := TEdit(Sender).text;
end;


procedure Tf_detail_inscription.affi_filiere (num : string);
var
ch : string;
begin
mmo_filiere.clear;
if num = ''
then mmo_filiere.lines.add('Filière non identifié.')
else begin
ch := modele.inscription_filiere(num);
    if  ch = ''	then mmo_filiere.lines.add('Filière inconnue.')
    else begin
            mmo_filiere.lines.text := ch;
            ch := modele.inscription_filiere(num);
end;
end;
end;
function Tf_detail_inscription.affi_erreur_saisie (erreur : string; lbl : TLabel; edt : TEdit) : boolean;
begin
lbl.caption := erreur;
if NOT (erreur = '')
then begin
edt.setFocus;
result := false;
end
else result := true;
end;


end.

