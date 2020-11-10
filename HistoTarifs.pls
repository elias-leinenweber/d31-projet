/*
 * 7. Créez un trigger HistoTarifs qui alimente une table
 *    historique_tarifs(idt, numt, numpiz, taille, prix, date_deb_tarif,
 *    date_fin_tarif) en cas de modification de tarif.
*/
CREATE OR REPLACE TRIGGER
HistoTarifs
AFTER UPDATE OR INSERT ON tarif
BEGIN
	IF (inserting) THEN
		INSERT INTO historique_tarifs (numt, pizza, taille, prix, date_deb_tarif, date_fin_tarif)
		VALUES (:NEW.numt, :NEW.numpiz, :NEW.taille, :NEW.prix, SYSDATE, NULL);
	ELSIF (updating) THEN
		UPDATE historique_tarifs
		   SET date_fin_tarif = SYSDATE
		 WHERE numt = :NEW.numt
		   AND date_deb_tarif = NULL;
	END IF;
END;
/
