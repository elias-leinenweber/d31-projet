SET SERVEROUTPUT ON FORMAT WRAPPED;

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
	CURSOR pizzasSansIng IS
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
	FOR pizza IN pizzasSansIng LOOP
		DBMS_OUTPUT.PUT_LINE(' - ' || pizza.nompiz);
	END LOOP;
END PizzasSansIng;

/*
 *    b) un sous-programme PizzaSansCat(libCat) qui affiche les noms des pizzas
 *       qui ne contiennent pas d'ingrédient de la catégorie passée en
 *       paramètre.
 */
PROCEDURE PizzasSansCat(libCat categorie_ing.libelle%TYPE)
AS
	CURSOR pizzasSansCat IS
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
	FOR pizza IN pizzasSansCat LOOP
		DBMS_OUTPUT.PUT_LINE(' - ' || pizza.nompiz);
	END LOOP;
END PizzasSansCat;

/*
 *    c) un sous-programme AfficheCarte qui affiche les informations concernant
 *       les pizzas de la carte (ingrédients, tarifs en fonction des tailles
 *       ordonnés par taille).
 */
PROCEDURE AfficheCarte
AS
	CURSOR pizzasIng IS
	SELECT p.numpiz, INITCAP(p.nompiz) nom, LISTAGG(i.libelle, ', ') WITHIN GROUP(ORDER BY i.libelle) listeIng
	  FROM pizza p
	       JOIN composition c
	       ON p.numpiz = c.pizza
	       JOIN ingredient i
	       ON c.ing = i.numing
	 GROUP BY p.numpiz, INITCAP(p.nompiz);

	CURSOR lignesTaillePrix(numpiz pizza.numpiz%TYPE) IS
	SELECT taille, prix
	  FROM tarif
	 WHERE pizza = numpiz
	 ORDER BY taille;
BEGIN
	FOR pizzaIng IN pizzasIng LOOP
		DBMS_OUTPUT.PUT_LINE('|- ' || pizzaIng.nom || ' : ' || pizzaIng.listeIng);
		FOR ligneTaillePrix IN lignesTaillePrix(pizzaIng.numpiz) LOOP
			DBMS_OUTPUT.PUT_LINE('| |- ' || ligneTaillePrix.taille || ' personnes : ' || ligneTaillePrix.prix || ' euros');
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
	CURSOR prixPizzasPlusPetites IS
	SELECT prix
	  FROM tarif
	 WHERE pizza = numpiz
	   AND tarif.taille < ModifTarif.taille;
	
	CURSOR prixPizzasPlusGrandes IS
	SELECT prix
	  FROM tarif
	 WHERE pizza = numpiz
	   AND tarif.taille > ModifTarif.taille;
BEGIN
	IF (montant < 0) THEN
		RAISE INVALID_NUMBER;
	END IF;

	FOR recPrix IN prixPizzasPlusPetites LOOP
		IF (montant < recPrix.prix) THEN
			RAISE INVALID_NUMBER;
		END IF;
	END LOOP;

	FOR recPrix IN prixPizzasPlusGrandes LOOP
		IF (montant > recPrix.prix) THEN
			RAISE INVALID_NUMBER;
		END IF;
	END LOOP;

	UPDATE tarif
	   SET prix = montant
	 WHERE pizza = numpiz
	   AND tarif.taille = ModifTarif.taille;
END ModifTarif;
END;
/
