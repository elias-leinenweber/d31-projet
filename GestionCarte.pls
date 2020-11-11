SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE GestionCarte IS
	PROCEDURE PizzasSansIng(nomIng ingredient.libelle%TYPE);
	PROCEDURE PizzasSansCat(libCat categorie_ing.libelle%TYPE);
	PROCEDURE AfficheCarte;
	PROCEDURE ModifTarif(numpiz pizza.numpiz%TYPE, taille tarif.taille%TYPE, montant tarif.prix%TYPE);
END GestionCarte;
/

/* 5. Créez un package GestionCarte comprenant : */
CREATE OR REPLACE PACKAGE BODY GestionCarte IS
/*
 *    a) un sous-programme PizzasSansIng(nomIng) qui affiche les noms des pizzas
 *       qui ne contiennent pas l'ingrédient passé en paramètre.
 */
PROCEDURE PizzasSansIng(nomIng ingredient.libelle%TYPE)
AS
	CURSOR curPizzaSansIng IS
	SELECT nompiz
	  FROM pizza
	 WHERE numpiz NOT IN
	       (SELECT pizza
	          FROM composition
	         WHERE ing IN
	               (SELECT numing
	                  FROM ingredient
	                 WHERE LOWER(libelle) = LOWER(nomIng)));
BEGIN
	DBMS_OUTPUT.PUT_LINE('Noms des pizzas qui ne contiennent pas de ' || nomIng || ' :');
	FOR recPizza IN curPizzaSansIng LOOP
		DBMS_OUTPUT.PUT_LINE(recPizza.nompiz);
	END LOOP;
END PizzasSansIng;

/*
 *    b) un sous-programme PizzaSansCat(libCat) qui affiche les noms des pizzas
 *       qui ne contiennent pas d'ingrédient de la catégorie passée en
 *       paramètre.
 */
PROCEDURE PizzasSansCat(libCat categorie_ing.libelle%TYPE)
AS
	CURSOR curPizzaSansCat IS
	SELECT nompiz
	  FROM pizza
	 WHERE numpiz NOT IN
	       (SELECT pizza
	          FROM composition
	         WHERE ing IN
	               (SELECT numing
	                  FROM ingredient
	                 WHERE categorie IN
	                       (SELECT numcat
	                          FROM categorie_ing
	                         WHERE LOWER(libelle) = LOWER(libCat))));
BEGIN
	DBMS_OUTPUT.PUT_LINE('Noms des pizzas ne contenant pas de ' || libCat || ' :');
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
	CURSOR curPizzaIng IS
	SELECT p.numpiz, INITCAP(p.nompiz) nomPizza,
	       LISTAGG(i.libelle, ', ') WITHIN GROUP(ORDER BY i.libelle) listeIng
	  FROM pizza p
	       JOIN composition co
	       ON p.numpiz = co.pizza
	       JOIN ingredient i
	       ON co.ing = i.numing
	 GROUP BY p.numpiz, INITCAP(p.nompiz);

	CURSOR curTaillePrix(numpiz pizza.numpiz%TYPE) IS
	SELECT taille, prix
	  FROM tarif
	 WHERE pizza = numpiz
	 ORDER BY taille;
BEGIN
	FOR recPizzaIng IN curPizzaIng LOOP
		DBMS_OUTPUT.PUT_LINE('|- ' || recPizzaIng.nomPizza || ' : ' || recPizzaIng.listeIng);
		FOR recTaillePrix IN curTaillePrix(recPizzaIng.numpiz) LOOP
			DBMS_OUTPUT.PUT_LINE('| |- ' || recTaillePrix.taille || ' personnes : ' || recTaillePrix.prix || ' euros');
		END LOOP;
	END LOOP;
END AfficheCarte;

/*
 *    d) un sous-programme ModifTarif(numpiz, taille, montant) qui permet de
 *       modifier le prix d'une pizza en s'assurant de la cohérence du nouveau
 *       prix (le prix reste positif et le prix est supérieur (inférieur) au
 *       prix d'une pizza du même type et de taille inférieure (supérieure)).
 */
PROCEDURE ModifTarif(numpiz pizza.numpiz%TYPE, taille tarif.taille%TYPE, montant tarif.prix%TYPE)
AS
	CURSOR curPrixPizzaPetite IS
	SELECT prix
	  FROM tarif
	 WHERE pizza = numpiz
	   AND tarif.taille < taille;
	
	CURSOR curPrixPizzaGrande IS
	SELECT prix
	  FROM tarif
	 WHERE pizza = numpiz
	   AND tarif.taille > taille;
BEGIN
	IF (montant < 0) THEN
		RAISE INVALID_NUMBER;
	END IF;

	FOR recPrix IN curPrixPizzaPetite LOOP
		IF (montant < recPrix.prix) THEN
			RAISE INVALID_NUMBER;
		END IF;
	END LOOP;

	FOR recPrix IN curPrixPizzaGrande LOOP
		IF (montant > recPrix.prix) THEN
			RAISE INVALID_NUMBER;
		END IF;
	END LOOP;

	UPDATE tarif
	   SET prix = montant
	 WHERE pizza = numpiz
	   AND tarif.taille = taille;
END ModifTarif;
END;
/
