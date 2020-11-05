SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE GestionCarte IS
	PROCEDURE PizzasSansIng(nomIng ingredient.numing%TYPE);
	PROCEDURE PizzasSansCat(libCat categorie_ing.numcat%TYPE);
	PROCEDURE AfficheCarte;
	PROCEDURE ModifTarif(numpiz pizza.numpiz%TYPE, taille tarif.taille%TYPE,
	    montant tarif.prix%TYPE);
END GestionCarte;
/

/* 5. Créez un package GestionCarte comprenant : */
CREATE OR REPLACE PACKAGE BODY GestionCarte IS
/*
 *    a) un sous-programme PizzasSansIng(nomIng) qui affiche les noms des pizzas
 *       qui ne contiennent pas l'ingrédient passé en paramètre.
 */
PROCEDURE PizzasSansIng(nomIng ingredient.numing%TYPE)
AS
	CURSOR curPizzaSansIng IS
	SELECT nompiz
	  FROM pizza
	 WHERE numpiz NOT IN
	       (SELECT pizza
	          FROM composition
	         WHERE ing = nomIng);
BEGIN
	DBMS_OUTPUT.PUT_LINE(
	    'Noms des pizzas qui ne contiennent pas l''ingrédient ' || nomIng ||
	    ' :');
	FOR recPizza IN curPizzaSansIng LOOP
		DBMS_OUTPUT.PUT_LINE(recPizza.nompiz);
	END LOOP;
END PizzasSansIng;

/*
 *    b) un sous-programme PizzaSansCat(libCat) qui affiche les noms des pizzas
 *       qui ne contiennent pas d'ingrédient de la catégorie passée en
 *       paramètre.
 */
PROCEDURE PizzasSansCat(libCat categorie_ing.numcat%TYPE)
AS
	/* TODO Mettre à jour la requête */
	CURSOR curPizzaSansCat IS
	SELECT nompiz
	  FROM pizza
	 WHERE numpiz NOT IN
	       (SELECT pizza
	          FROM composition
	         WHERE ing != nomIng);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Noms des pizzas ne contenant pas d''ingrédient de
	    la catégorie :');
	FOR recPizza IN curPizzaSansCat LOOP
		DBMS_OUTPUT.PUT_LINE(recPizza.nompiz);
	END LOOP;
END PizzasSansCat;

/*
 *    c) un sous-programme AfficheCarte qui affiche les informations concernant
 *       les pizzas de la carte (ingrédients, tarifs en fonction des tailles
 *       ordonnés par taille).
 */
PROCEDURE AfficheCarte
AS
BEGIN
END AfficheCarte;

END;
/

