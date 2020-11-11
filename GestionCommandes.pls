SET SERVEROUTPUT ON FORMAT WRAPPED;

CREATE OR REPLACE PACKAGE GestionCommandes IS
	PROCEDURE AfficheProchainesCommandes;
	 FUNCTION CoutLigneCommande(numcom commande.numc%TYPE, numtarif tarif.numt%TYPE)
	   RETURN REAL;
	 FUNCTION CoutCommande(numcom commande.numc%TYPE)
	   RETURN REAL;
	 FUNCTION GainJour(jour DATE)
	   RETURN REAL;
	 FUNCTION GainMois(annee NUMBER, mois NUMBER)
	   RETURN REAL;
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
	CURSOR prochainesCommandes IS
	SELECT c.numc, dateheure_cmd, adresse1, adresse2, codepostal, ville,
	       SUM(l.quantite) qtePizza
	  FROM commande c
	       JOIN ligne_cmd l
	       ON c.numc = l.numc
	 WHERE dateheure_cmd >= SYSDATE
	   AND dateheure_cmd <= SYSDATE + INTERVAL '1' HOUR
	   AND etat IS NULL
	 GROUP BY c.numc, dateheure_cmd,adresse1, adresse2, codepostal, ville
	 ORDER BY dateheure_cmd;
BEGIN
	DBMS_OUTPUT.PUT_LINE('---------------------------------------');
	FOR cmd IN prochainesCommandes LOOP
		DBMS_OUTPUT.PUT_LINE('Numéro de commande : ' || cmd.numc);
		DBMS_OUTPUT.PUT_LINE('Quantité de pizzas : ' || cmd.qtePizza);
		DBMS_OUTPUT.PUT_LINE('Ville : ' || cmd.ville);
		DBMS_OUTPUT.PUT_LINE('Adresse : ' || cmd.adresse1);
		IF cmd.adresse2 IS NOT NULL THEN
			DBMS_OUTPUT.PUT_LINE('Complément d''adresse : ' || cmd.adresse2);
		END IF;
		DBMS_OUTPUT.PUT_LINE('Code postal : ' || cmd.codepostal);
		DBMS_OUTPUT.PUT_LINE('---------------------------------------');
	END LOOP;
END AfficheProchainesCommandes;

/*
 *    b) un sous-programme CoutLigneCommande(numcom, numtarif) qui retourne le
 *       coût d'une ligne de la commande (en tenant compte des éventuelles
 *       remises).
 */
FUNCTION CoutLigneCommande(numcom commande.numc%TYPE, numtarif tarif.numt%TYPE)
RETURN REAL
AS
	cout	REAL;
BEGIN
	SELECT ((100 - NVL(l.remise, 0)) / 100) * l.quantite * t.prix
	  INTO cout
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
RETURN REAL
AS
	cout	REAL;

	CURSOR lignesCmd IS
	SELECT numc, tarif
	  FROM ligne_cmd
	 WHERE numc = numcom;
BEGIN
	cout := 0;

	FOR ligneCmd IN lignesCmd LOOP
		cout := cout + CoutLigneCommande(ligneCmd.numc, ligneCmd.tarif);
	END LOOP;

	RETURN cout;
END CoutCommande;

/*
 *    d) un sous-programme GainJour(date) qui retourne le montant gagné le jour
 *       passé en paramètre.
 */
FUNCTION GainJour(jour DATE)
RETURN REAL
AS
	gain	REAL;

	CURSOR commandesJour IS
	SELECT numc
	  FROM commande
	 WHERE TO_CHAR(dateheure_cmd, 'DD/MM/YYYY') = TO_CHAR(jour, 'DD/MM/YYYY');
BEGIN
	gain := 0;

	FOR cmdJour IN commandesJour LOOP
		gain := gain + CoutCommande(cmdJour.numc);
	END LOOP;

	RETURN gain;
END GainJour;

/*
 *    e) un sous-programme GainMois(annee, mois) qui retourne le montant gagné
 *       sur un mois donné.
 */
FUNCTION GainMois(annee NUMBER, mois NUMBER)
RETURN REAL
AS
	gain	REAL;

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
END GainMois;

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
	total	REAL;

	CURSOR lignesFacture IS
	SELECT UPPER(p.nompiz) pizza, t.taille taille, l.quantite qte,
	       t.prix pu, l.quantite * t.prix total_pre_r,
	       (NVL(remise, 0) / 100) * l.quantite * t.prix remise,
	       CoutLigneCommande(l.numc, t.numt) total
	  FROM ligne_cmd l
	       JOIN tarif t
	       ON l.tarif = t.numt
	       JOIN pizza p
	       ON t.pizza = p.numpiz
	 WHERE l.numc = numcom;
BEGIN
	SELECT dateheure_cmd
	  INTO datec
	  FROM commande
	 WHERE numc = numcom;
	
	SELECT SUM(l.quantite * t.prix)
	  INTO total
	  FROM ligne_cmd l
	       JOIN tarif t
	       ON l.tarif = t.numt
	 WHERE l.numc = numcom;

	DBMS_OUTPUT.PUT_LINE('                PIZZERIA PRONTO                ');
	DBMS_OUTPUT.PUT_LINE('===============================================');
	DBMS_OUTPUT.PUT_LINE('Commande n° ' || numcom || '          Date : ' || TO_CHAR(datec, 'DD/MM/YYYY'));
	DBMS_OUTPUT.PUT_LINE('===============================================');
	DBMS_OUTPUT.PUT_LINE('Piz. (tail.)  Qté PU Total av.r Rem. Total ap.r');
	DBMS_OUTPUT.PUT_LINE('-----------------------------------------------');
	FOR lf IN lignesFacture LOOP
		DBMS_OUTPUT.PUT_LINE(lf.pizza || ' (' || lf.taille ||
		    ' pers.)  ' || lf.qte || ' ' || lf.pu || ' ' ||
		    lf.total_pre_r || ' ' || lf.remise || ' ' || lf.total);
	END LOOP;
	DBMS_OUTPUT.PUT_LINE('===============================================');
	DBMS_OUTPUT.PUT_LINE('Total avec remise : ' || CoutCommande(numcom));
	DBMS_OUTPUT.PUT_LINE('Remise : ' || (total - CoutCommande(numcom)));
END Facture;

/*
 *    g) un sous-programme MeilleureCommandeMoisCourant qui affiche le numéro
 *       et le coût de la commande de coût le plus élevé pour le mois en cours,
 *       jusqu'à présent
 */
PROCEDURE MeilleureCommandeMoisCourant
AS
	/*
	 * On utlise un curseur pour pouvoir afficher plusieurs commandes dans
	 * le cas où il y a plusieurs meilleures commandes.
	 */
	CURSOR meilleuresCmd IS
	SELECT numc, CoutCommande(numc) cout
	  FROM commande
	 WHERE TO_CHAR(SYSDATE, 'MM/YYYY') = TO_CHAR(dateheure_cmd, 'MM/YYYY')
	   AND CoutCommande(numc) =
	       (SELECT MAX(CoutCommande(numc))
	          FROM commande
	         WHERE TO_CHAR(SYSDATE, 'MM/YYYY') = TO_CHAR(dateheure_cmd, 'MM/YYYY'));
BEGIN
	DBMS_OUTPUT.PUT_LINE('---------------------------------------');
	FOR meilleureCmd IN meilleuresCmd LOOP
		DBMS_OUTPUT.PUT_LINE('Meilleure commande du mois : ' || meilleureCmd.numc);
		DBMS_OUTPUT.PUT_LINE('Avec un coût de : ' || meilleureCmd.cout);
		DBMS_OUTPUT.PUT_LINE('---------------------------------------');
	END LOOP;
END MeilleureCommandeMoisCourant;
END;
/
