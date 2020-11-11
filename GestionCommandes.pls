SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE GestionCommandes IS
	PROCEDURE AfficheProchainesCommandes;
	 FUNCTION CoutLigneCommande(numcom commande.numc%TYPE, numtarif tarif.numt%TYPE)
	   RETURN tarif.prix%TYPE;
	 FUNCTION CoutCommande(numcom commande.numc%TYPE)
	   RETURN tarif.prix%TYPE;
	 FUNCTION GainJour(jour DATE)
	   RETURN tarif.prix%TYPE;
	 FUNCTION GainMois(annee NUMBER, mois NUMBER)
	   RETURN tarif.prix%TYPE;
	PROCEDURE Facture(numcom commande.numc%TYPE);
	PROCEDURE MeilleureCommandeMoisCourant;
END GestionCommandes;
/

/* 6. Créez un package GestionCommandes comprenant : */
CREATE OR REPLACE PACKAGE BODY GestionCommandes IS
/*
 *    a) un sous-programme AfficheProchainesCommandes qui affiche pour chaque
 *       commande à livrer dans la prochaine heure, son numéro avec la quantité
 *       de pizzas commandées tous types confondus, la ville et l'adresse où
 *       livrer, par ordre d'heure de livraison croissant.
 */
PROCEDURE AfficheProchainesCommandes
AS
	CURSOR curProchainesCommandes IS
	SELECT c.numc,dateheure_cmd, adresse1, adresse2, codepostal, ville, SUM(l.quantite) qtPiz
	  FROM commande c
	       JOIN ligne_cmd l
	       ON c.numc = l.numc
	 WHERE dateheure_cmd >= SYSDATE
	   AND dateheure_cmd <= SYSDATE + INTERVAL '1' HOUR
	   AND etat IS NULL
	 GROUP BY c.numc, dateheure_cmd,adresse1, adresse2, codepostal, ville
	 ORDER BY dateheure_cmd;

BEGIN
	FOR cmd IN curProchainesCommandes LOOP
		DBMS_OUTPUT.PUT_LINE('Numéro commande : '|| cmd.numc);
		DBMS_OUTPUT.PUT_LINE('Quantité de pizzas : '|| cmd.qtPiz);
		DBMS_OUTPUT.PUT_LINE('Ville : '|| cmd.ville);
		DBMS_OUTPUT.PUT_LINE('Adresse : '||cmd.adresse1);
		IF cmd.adresse2 IS NOT NULL THEN
			DBMS_OUTPUT.PUT_LINE('Complément d''adresse : '|| cmd.adresse2);
		END IF;
		DBMS_OUTPUT.PUT_LINE('Code postal : '|| cmd.codepostal);
	END LOOP
END AfficheProchainesCommandes;

/*
 *    b) un sous-programme CoutLigneCommande(numcom, numtarif) qui retourne le
 *       coût d'une ligne de la commande (en tenant compte des éventuelles
 *       remises).
 */
FUNCTION CoutLigneCommande(numcom commande.numc%TYPE, numtarif tarif.numt%TYPE)
RETURN tarix.prix%TYPE
AS
	cout	tarif.prix%TYPE;
BEGIN
	SELECT ((100 - NVL(l.remise, 0)) / 100) * l.quantite * t.prix INTO cout
	  FROM ligne_cmd l
	       JOIN tarif t
	       ON l.tarif = t.numt
	 WHERE l.numc = numcom
	   AND l.tarif = numtarif;

	RETURN cout;
END CoutLigneCommande;

/*
 *    c) un sous-programme CoutCommande(numcom) qui retourne le coût total d'une
 *       commande (en tenant compte des éventuelles remises).
 */
FUNCTION CoutCommande(numcom commande.numc%TYPE)
RETURN tarif.prix%TYPE
AS
	cout	tarif.prix%TYPE;

	CURSOR curLigneCmd IS
	SELECT numc, tarif
	  FROM ligne_cmd
	 WHERE numc = numcom;
BEGIN
	cout := 0;

	FOR recLigneCmd IN curLigneCmd LOOP
		cout := cout + CoutLigneCommande(recLigneCmd.numc, recLigneCmd.tarif);
	END LOOP;

	RETURN cout;
END CoutCommande;

/*
 *    d) un sous-programme GainJour(date) qui retourne le montant gagné le jour
 *       passé en paramètre.
 */
FUNCTION GainJour(jour DATE)
RETURN tarif.prix%TYPE
AS
	gain	tarif.prix%TYPE;

	CURSOR curCmdJour IS
	SELECT numc
	  FROM commande
	 WHERE TO_CHAR(dateheure_cmd, 'DD/MM/YYYY') = TO_CHAR(jour, 'DD/MM/YYYY');
BEGIN
	gain := 0;

	FOR recCmdJour IN curCmdJour LOOP
		gain := gain + CoutCommande(recCmdJour.numc);
	END LOOP;

	RETURN gain;
END GainJour;

/*
 *    e) un sous-programme GainMois(annee, mois) qui retourne le montant gagné
 *       sur un mois donné.
 */
FUNCTION GainMois(annee NUMBER, mois NUMBER)
RETURN tarif.prix%TYPE
AS
	gain	tarif.prix%TYPE;

	CURSOR commandesDuMois IS
	SELECT numc
	  FROM commande
	 WHERE EXTRACT(YEAR FROM dateheure_cmd) = annee
	   AND EXTRACT(MONTH FROM dateheure_cmd) = mois;
BEGIN
	gain := 0;

	FOR commande IN commandesDuMois LOOP
		gain := gain + CoutCommande(commande.numc);
	END LOOP;

	RETURN gain;
END GainsMois;

/*
 *    f) un sous-programme Facture(numcom) qui affiche le détail d'une commande
 *       (le nom de la pizzeria, date de la commande, noms des pizzas et
 *       tailles, quantité commandée, prix à l'unité, total de la ligne de
 *       commande sans remise, total de la remise, total de la ligne avec
 *       remise, montant de la commande avec remise, montant total de la
 *       remise).
 */
PROCEDURE Facture(numcom commande.numc%TYPE)
AS
	datec	commande.dateheure_cmd%TYPE;

	--CURSOR curLigneFacture IS
BEGIN
	SELECT dateheure_cmd
	  INTO datec
	  FROM commande
	 WHERE numc = numcom;

	DBMS_OUTPUT.PUT_LINE('                PIZZERIA PRONTO                ');
	DBMS_OUTPUT.PUT_LINE('===============================================');
	DBMS_OUTPUT.PUT_LINE('Commande n° ' || numcom || '   Date : ' || datec);
	DBMS_OUTPUT.PUT_LINE('===============================================');
	DBMS_OUTPUT.PUT_LINE('Pizza                          Qté P.U. Montant');
	DBMS_OUTPUT.PUT_LINE('-----------------------------------------------');
	FOR EVER LOOP
		DBMS_OUTPUT.PUT_LINE(piz || '  ' || qte || ' ' || pu || ' ' || montant);
	END LOOP;
END Facture;

/*
 *    g) un sous-programme MeilleureCommandeMoisCourant qui affiche le numéro
 *       et le coût de la commande de coût le plus élevé pour le mois en cours,
 *       jusqu'à présent
 */
PROCEDURE MeilleureCommandeMoisCourant
AS
	meilleureCmd		commande.numc%TYPE;
	coutMeilleureCmd	tarif.prix%TYPE;
BEGIN
	SELECT numc, CoutCommande(numc)
	  INTO (meilleureCmd,coutMeilleureCmd)
	  FROM commande
	 WHERE TO_CHAR(SYSDATE, 'MM/YYYY') = TO_CHAR(dateheure_cmd, 'MM/YYYY')
	   AND CoutCommande(numc) =
	       (SELECT MAX(CoutCommande(numc))
	          FROM commande
	         WHERE TO_CHAR(SYSDATE, 'MM/YYYY') = TO_CHAR(dateheure_cmd, 'MM/YYYY'));

	DBMS_OUTPUT.PUT_LINE('Meilleure commande du mois : ' || meilleureCmd);
	DBMS_OUTPUT.PUT_LINE('Avec un coût de : ' || coutMeilleureCmd);
END MeilleureCommandeMoisCourant;
END;
/
