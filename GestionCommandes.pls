SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE GestionCommandes IS
	PROCEDURE AfficheProchainesCommandes;
	PROCEDURE CoutLigneCommande(numcommande commande.numc%TYPE, numtarif tarif.numt%TYPE);
	PROCEDURE CoutCommande(numcommande commande.numc%TYPE);
	PROCEDURE GainJour(jour date);
	PROCEDURE GainsMois(annee NUMBER, mois NUMBER);--TODO vérifier les types
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
IS

BEGIN
END AfficheCarte;

/*
 *    b) un sous-programme CoutLigneCommande(numcom, numtarif) qui retourne le
 *       coût d'une ligne de la commande (en tenant compte des éventuelles
 *       remises).
 */
PROCEDURE CoutLigneCommande(numcommande commande.numc%TYPE, numtarif tarif.numt%TYPE)
IS 
BEGIN
END CoutLigneCommande;

/*
 *    c) un sous-programme CoutCommande(numcom) qui retourne le coût total d'une
 *       commande (en tenant compte des éventuelles remises).
 */
PROCEDURE CoutCommande(numcommande commande.numc%TYPE)
IS
BEGIN
END CoutCommande;

/*
 *    d) un sous-programme GainJour(date) qui retourne le montant gagné le jour
 *       passé en paramètre.
 */
PROCEDURE GainJour(jour date)
IS
BEGIN
END GainJour;

/*
 *    e) un sous-programme GainMois(annee, mois) qui retourne le montant gagné
 *       sur un mois donné.
 */
PROCEDURE GainsMois(annee NUMBER, mois NUMBER)--TODO vérifier les types
IS
BEGIN
END GainsMois;

/*
 *    f) un sous-programme Facture(numcom) qui affiche le détail d'une commande
 *       (le nom de la pizzeria, date de la commande, noms des pizzas et 
 *       tailles, quantité commandée, prix à  l'unité, total de la ligne de 
 *       commande sans remise, total de la remise, total de la ligne avec 
 *       remise, montant de la commande avec remise, montant total de la 
 *       remise).
 */
PROCEDURE Facture(numcom commande.numc%TYPE)
IS
BEGIN
END Facture;

/*
 *    g) un sous-programme MeilleureCommandeMoisCourant qui affiche le numéro 
 *       et le coût dela commande de coût le plus élevé pour le mois en cours, 
 *       jusqu’à présent
 */
PROCEDURE MeilleureCommandeMoisCourant
IS
BEGIN
END MeilleureCommandeMoisCourant;


END;
/
