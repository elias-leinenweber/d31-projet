SET SERVEROUTPUT ON;
CREATE OR REPLACE PACKAGE GestionCommandes IS
	PROCEDURE AfficheProchainesCommandes;
	PROCEDURE CoutLigneCommande(numcommande commande.numc%TYPE,
	    numtarif tarif.numt%TYPE);
	PROCEDURE CoutCommande(numcommande commande.numc%TYPE);
	PROCEDURE GainJour(jour date);
	PROCEDURE GainsMois(annee NUMBER, mois NUMBER);--TODO vérifier les types
	PROCEDURE Facture(numcom commande.numc%TYPE);
	PROCEDURE MeilleureCommandeMoisCourant; /* coût avec réduction */
END GestionCommandes;
/

/* 6. Créez un package GestionCommandes comprenant : */
CREATE OR REPLACE PACKAGE BODY GestionCommandes IS
END;
/
