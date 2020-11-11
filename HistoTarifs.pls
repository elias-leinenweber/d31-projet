/*
 * 7. Créez un trigger HistoTarifs qui alimente une table historique_tarifs(idt,
 *    numt, numpiz, taille, prix, date_deb_tarif, date_fin_tarif) en cas de
 *    modification de tarif.
*/
CREATE OR REPLACE TRIGGER
HistoTarifs
AFTER UPDATE ON tarif FOR EACH ROW
BEGIN
	INSERT INTO historique_tarifs (numt, pizza, taille, prix, date_deb_tarif)
	VALUES (:OLD.numt, :OLD.pizza, :OLD.taille, :OLD.prix, :OLD.datet);
END;
/
