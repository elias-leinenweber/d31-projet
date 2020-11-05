--DROP TABLE ligne_cmd;
--DROP TABLE commande;
--DROP TABLE livreur;
--DROP TABLE tarif;
--DROP TABLE composition;
--DROP TABLE pizza;
--DROP TABLE ingredient;
--DROP TABLE categorie_ing;




CREATE TABLE categorie_ing(
       numcat NUMBER(2) NOT NULL, 
       libelle VARCHAR(20) NOT NULL, 
       CONSTRAINT pk_categorie_ing PRIMARY KEY (numcat),
       CONSTRAINT u_categorie_ing UNIQUE(libelle)
);

CREATE TABLE ingredient(
       numing NUMBER(2) NOT NULL, 
       libelle VARCHAR(25) NOT NULL, 
       categorie NUMBER(2) NOT NULL, 
       CONSTRAINT pk_ingredient PRIMARY KEY (numing),
       CONSTRAINT u_ingredient_libelle UNIQUE(libelle),
       CONSTRAINT fk_ingredient_categorie FOREIGN KEY (categorie) REFERENCES categorie_ing
); 
 
CREATE TABLE pizza(
       numpiz NUMBER(2) NOT NULL, 
       nompiz VARCHAR(40) NOT NULL, 
       CONSTRAINT pk_pizza PRIMARY KEY (numpiz),
       CONSTRAINT u_pizza_nompiz UNIQUE(nompiz)
); 
 
CREATE TABLE composition(
       pizza NUMBER(2) NOT NULL, 
       ing NUMBER(2) NOT NULL, 
       CONSTRAINT pk_composition PRIMARY KEY (pizza, ing), 
       CONSTRAINT fk_composition_pizza FOREIGN KEY (pizza) REFERENCES pizza, 
       CONSTRAINT fk_composition_ing FOREIGN KEY (ing) REFERENCES ingredient
); 
 
CREATE TABLE tarif(
       numt NUMBER(3) NOT NULL,
       pizza NUMBER(2) NOT NULL, 
       taille NUMBER(1) NOT NULL, 
       datet DATE NOT NULL, 
       prix NUMBER(4,2) NOT NULL, 
       CONSTRAINT pk_tarif  PRIMARY KEY(numt),
       CONSTRAINT fk_tarif_pizza FOREIGN KEY (pizza) REFERENCES pizza, 
       CONSTRAINT c_tarif_taille CHECK (taille IN (2, 4, 8)) 
); 
 
CREATE TABLE livreur(
       numl NUMBER(3) NOT NULL,
       nom VARCHAR(30) NOT NULL, 
       prenom VARCHAR(20) NOT NULL, 
       date_embauche DATE NOT NULL, 
       date_fin_contrat DATE, 
       tel CHAR(10) NOT NULL, 
       CONSTRAINT pk_livreur PRIMARY KEY(numl)
); 
 
CREATE TABLE commande(
       numc NUMBER(8) NOT NULL, 
       nomcli VARCHAR(30) NOT NULL,  
       prenomcli VARCHAR(20), 
       tel CHAR(10) NOT NULL, 
       adresse1 VARCHAR(120) NOT NULL,  
       adresse2 VARCHAR(120), 
       codepostal CHAR(5) NOT NULL, 
       ville VARCHAR (30) NOT NULL, 
       dateheure_cmd DATE NOT NULL, 
       dateheure_liv DATE, 
       livreur NUMBER(3), 
       etat VARCHAR(9),
       CONSTRAINT pk_commande PRIMARY KEY(numc), 
       CONSTRAINT fk_commande_livreur FOREIGN KEY (livreur) REFERENCES livreur 
); 
 
CREATE TABLE ligne_cmd(
       numc NUMBER(8) NOT NULL, 
       tarif NUMBER(3) NOT NULL, 
       quantite NUMBER(2) NOT NULL,  
       remise NUMBER(4,2),
       constraint pk_ligne_cmd  PRIMARY KEY(numc, tarif), 
       CONSTRAINT fk_ligne_cmd_numc FOREIGN KEY (numc) REFERENCES commande,
       CONSTRAINT fk_ligne_cmd_numt FOREIGN KEY (tarif) REFERENCES tarif
);

INSERT INTO categorie_ing VALUES (1, 'fruits et legumes');
INSERT INTO categorie_ing VALUES (2, 'viande');
INSERT INTO categorie_ing VALUES (3, 'produit laitier');
INSERT INTO categorie_ing VALUES (4, 'herbes et épices');
INSERT INTO categorie_ing VALUES (5, 'poisson');
INSERT INTO categorie_ing VALUES (6, 'autre');

INSERT INTO ingredient VALUES (1, 'sauce tomate', 1);
INSERT INTO ingredient VALUES (2, 'tomate fraîche', 1);
INSERT INTO ingredient VALUES (3, 'mozzarella', 3);
INSERT INTO ingredient VALUES (4, 'jambon de parme', 2);
INSERT INTO ingredient VALUES (5, 'chorizo', 2);
INSERT INTO ingredient VALUES (6, 'poivron', 1);
INSERT INTO ingredient VALUES (7, 'crème fraîche', 3);
INSERT INTO ingredient VALUES (8, 'parmesan', 3);
INSERT INTO ingredient VALUES (9, 'gruyère', 3);
INSERT INTO ingredient VALUES (10, 'saumon', 5);
INSERT INTO ingredient VALUES (11, 'ananas', 1);
INSERT INTO ingredient VALUES (12, 'piment', 4);
INSERT INTO ingredient VALUES (13, 'champignon', 1);
INSERT INTO ingredient VALUES (14, 'basilic', 4);
INSERT INTO ingredient VALUES (15, 'taleggio', 3);
INSERT INTO ingredient VALUES (16, 'gorgozola', 3);
INSERT INTO ingredient VALUES (17, 'artichaut', 1);
INSERT INTO ingredient VALUES (18, 'aubergine', 1);
INSERT INTO ingredient VALUES (19, 'courgette', 1);
INSERT INTO ingredient VALUES (20, 'origan', 4);
INSERT INTO ingredient VALUES (21, 'ail', 1);

INSERT INTO pizza VALUES (1, 'Margherita');
INSERT INTO pizza VALUES (2, 'Parma');
INSERT INTO pizza VALUES (3, 'Quattro formaggi');
INSERT INTO pizza VALUES (4, 'Marinara');
INSERT INTO pizza VALUES (5, 'Parmigiana');
INSERT INTO pizza VALUES (6, 'Salmone');
INSERT INTO pizza VALUES (7, 'Peperoni');
INSERT INTO pizza VALUES (8, 'Verde');

INSERT INTO composition VALUES (1, 1);
INSERT INTO composition VALUES (1, 3);
INSERT INTO composition VALUES (1, 14);
INSERT INTO composition VALUES (2, 1);
INSERT INTO composition VALUES (2, 4);
INSERT INTO composition VALUES (2, 2);
INSERT INTO composition VALUES (2, 3);
INSERT INTO composition VALUES (2, 14);
INSERT INTO composition VALUES (3, 1);
INSERT INTO composition VALUES (3, 3);
INSERT INTO composition VALUES (3, 8);
INSERT INTO composition VALUES (3, 15);
INSERT INTO composition VALUES (3, 16);
INSERT INTO composition VALUES (4, 1);
INSERT INTO composition VALUES (4, 20);
INSERT INTO composition VALUES (4, 21);
INSERT INTO composition VALUES (5, 1);
INSERT INTO composition VALUES (5, 3);
INSERT INTO composition VALUES (5, 8);
INSERT INTO composition VALUES (5, 14);
INSERT INTO composition VALUES (5, 18);
INSERT INTO composition VALUES (6, 7);
INSERT INTO composition VALUES (6, 10);
INSERT INTO composition VALUES (6, 3);
INSERT INTO composition VALUES (7, 1);
INSERT INTO composition VALUES (7, 3);
INSERT INTO composition VALUES (7, 6);
INSERT INTO composition VALUES (8, 1);
INSERT INTO composition VALUES (8, 2);
INSERT INTO composition VALUES (8, 6);
INSERT INTO composition VALUES (8, 17);
INSERT INTO composition VALUES (8, 18);
INSERT INTO composition VALUES (8, 19);

INSERT INTO tarif VALUES (1, 1, 2, TO_DATE('10/04/2019','dd/mm/yyyy'), 9);
INSERT INTO tarif VALUES (2, 1, 4, TO_DATE('10/04/2019','dd/mm/yyyy'), 10);
INSERT INTO tarif VALUES (3, 1, 8, TO_DATE('10/04/2019','dd/mm/yyyy'), 11);
INSERT INTO tarif VALUES (4, 2, 2, TO_DATE('23/05/2019','dd/mm/yyyy'), 12);
INSERT INTO tarif VALUES (5, 2, 4, TO_DATE('23/05/2019','dd/mm/yyyy'), 14);
INSERT INTO tarif VALUES (6, 2, 8, TO_DATE('23/05/2019','dd/mm/yyyy'), 16);
INSERT INTO tarif VALUES (7, 3, 2, TO_DATE('28/10/2019','dd/mm/yyyy'), 11);
INSERT INTO tarif VALUES (8, 3, 4, TO_DATE('28/10/2019','dd/mm/yyyy'), 13);
INSERT INTO tarif VALUES (9, 3, 8, TO_DATE('28/10/2019','dd/mm/yyyy'), 15);
INSERT INTO tarif VALUES (10, 4, 2, TO_DATE('21/12/2019','dd/mm/yyyy'), 8);
INSERT INTO tarif VALUES (11, 4, 4, TO_DATE('21/12/2019','dd/mm/yyyy'), 9);
INSERT INTO tarif VALUES (12, 4, 8, TO_DATE('21/12/2019','dd/mm/yyyy'), 10);
INSERT INTO tarif VALUES (13, 5, 2, TO_DATE('29/12/2019','dd/mm/yyyy'), 10.50);
INSERT INTO tarif VALUES (14, 5, 4, TO_DATE('29/12/2019','dd/mm/yyyy'), 12);
INSERT INTO tarif VALUES (15, 5, 8, TO_DATE('29/12/2019','dd/mm/yyyy'), 13.50);
INSERT INTO tarif VALUES (16, 6, 2, TO_DATE('07/01/2020','dd/mm/yyyy'), 13);
INSERT INTO tarif VALUES (17, 6, 4, TO_DATE('07/01/2020','dd/mm/yyyy'), 14.50);
INSERT INTO tarif VALUES (18, 6, 8, TO_DATE('07/01/2020','dd/mm/yyyy'), 16);
INSERT INTO tarif VALUES (19, 7, 2, TO_DATE('15/02/2020','dd/mm/yyyy'), 10);
INSERT INTO tarif VALUES (20, 7, 4, TO_DATE('15/02/2020','dd/mm/yyyy'), 11);
INSERT INTO tarif VALUES (21, 7, 8, TO_DATE('15/02/2020','dd/mm/yyyy'), 12);
INSERT INTO tarif VALUES (22, 8, 2, TO_DATE('24/03/2020','dd/mm/yyyy'), 11.50);
INSERT INTO tarif VALUES (23, 8, 4, TO_DATE('24/03/2020','dd/mm/yyyy'), 13);
INSERT INTO tarif VALUES (24, 8, 8, TO_DATE('24/03/2020','dd/mm/yyyy'), 14.50);

INSERT INTO livreur VALUES (1, 'Meyer', 'Antoine', TO_DATE('10/04/2019','dd/mm/yyyy'), TO_DATE('16/02/2020','dd/mm/yyyy'), '0615432898');
INSERT INTO livreur VALUES (2, 'DUMOULIN', 'Claire', TO_DATE('23/05/2019','dd/mm/yyyy'), NULL, '0687654321');
INSERT INTO livreur VALUES (3, 'Guichard', 'Sébastien', TO_DATE('28/10/2019','dd/mm/yyyy'), NULL, '0645326708');
INSERT INTO livreur VALUES (4, 'RENARD', 'Luc', TO_DATE('11/12/2019','dd/mm/yyyy'), NULL, '0631257687');
INSERT INTO livreur VALUES (5, 'Dupuis', 'Julien', TO_DATE('09/01/2020','dd/mm/yyyy'), NULL, '0616875457');
INSERT INTO livreur VALUES (6, 'Marchand', 'Anne', TO_DATE('08/02/2020','dd/mm/yyyy'), TO_DATE('14/09/2020','dd/mm/yyyy'), '0635498765');
INSERT INTO livreur VALUES (7, 'Ravel', 'Jean', TO_DATE('15/03/2020','dd/mm/yyyy'), TO_DATE('01/04/2020','dd/mm/yyyy'), '0698749875');

INSERT INTO commande VALUES (800, 'Martin', 'Nicolas', '0605432896', 'Rue des jonquilles', 'Residence Le Jardin', 67000, 'Strasbourg',
TO_DATE('20/10/2019, 11:00','dd/mm/yyyy, HH24:MI'), TO_DATE('20/10/2019, 11:05','dd/mm/yyyy, HH24:MI'), 2, 'livré');
INSERT INTO commande VALUES (801, 'Muller', 'Jean', '0615438698', 'Rue des lilas', NULL, 67400, 'Illkirch',
TO_DATE('20/10/2019, 12:30','dd/mm/yyyy, HH24:MI'), TO_DATE('20/10/2019, 12:45','dd/mm/yyyy, HH24:MI'), 3, 'livré');
INSERT INTO commande VALUES (802, 'Barreau', 'Lise', '0615414898', 'Route de Colmar', NULL, 67100, 'STRASBOURG',
TO_DATE('28/10/2019, 20:00','dd/mm/yyyy, HH24:MI'), TO_DATE('28/10/2019, 20:10','dd/mm/yyyy, HH24:MI'), 2, 'livré'); 
INSERT INTO commande VALUES (903, 'Dupontel', 'Aline', '0688745633', 'Route des Vosges', NULL, 67000, 'Strasbourg',
TO_DATE('14/12/2019, 13:15','dd/mm/yyyy, HH24:MI'), TO_DATE('14/12/2019, 13:20','dd/mm/yyyy, HH24:MI'), 1, 'livré');
INSERT INTO commande VALUES (904, 'Thomes', 'Marc', '0686458887', 'Route de Rome', 'Residence Paul Appel', 67000, 'Strasbourg',
TO_DATE('05/01/2020, 18:00','dd/mm/yyyy, HH24:MI'), TO_DATE('05/01/2020, 18:05','dd/mm/yyyy, HH24:MI'), 4, 'livré');
INSERT INTO commande VALUES (954, 'Baron', 'Laurent', '0681256787', 'Route de Boston', NULL, 67000, 'Strasbourg',
TO_DATE('18/03/2020, 19:00','dd/mm/yyyy, HH24:MI'), TO_DATE('18/03/2020, 19:05','dd/mm/yyyy, HH24:MI'), 7, 'livré');
INSERT INTO commande VALUES (1005, 'Loebs', 'Céline', '0605985632', 'Route de Finkwiller', NULL, 67000, 'STRASBOURG',
TO_DATE('22/08/2020, 11:30','dd/mm/yyyy, HH24:MI'), TO_DATE('22/08/2020, 12:00','dd/mm/yyyy, HH24:MI'), 6, 'livré');
INSERT INTO commande VALUES (1006, 'Lison', 'Audrey', '0616467532', 'Route de Lyon', NULL, 67400, 'ILLKIRCH',
TO_DATE('22/09/2020, 11:30','dd/mm/yyyy, HH24:MI'), TO_DATE('22/09/2020, 11:50','dd/mm/yyyy, HH24:MI'), 3, 'livré');
INSERT INTO commande VALUES (1007, 'Martin', 'Gérard', '0644412432', 'Route du marché', 'Résidence des tulipes', 67100, 'STRASBOURG',
TO_DATE('22/10/2020, 12:30','dd/mm/yyyy, HH24:MI'), TO_DATE('22/10/2020, 12:45','dd/mm/yyyy, HH24:MI'), 2, 'livré');
INSERT INTO commande VALUES (1108, 'Vico', 'Louis', '0644258962', 'Rue des dentelles', 'Résidence des fleurs', 67000, 'Strasbourg',
TO_DATE('24/10/2020, 12:30','dd/mm/yyyy, HH24:MI'), TO_DATE('24/10/2020, 12:55','dd/mm/yyyy, HH24:MI'), 4, 'livré');
INSERT INTO commande VALUES (1109, 'Martin', 'Gérard', '0644412432', 'Route du marche', 'Residence des tulipes', 67100, 'Strasbourg',
TO_DATE('31/10/2020, 12:25','dd/mm/yyyy, HH24:MI'), TO_DATE('31/10/2020, 12:40','dd/mm/yyyy, HH24:MI'), 2, 'livré');
INSERT INTO commande VALUES (1210, 'Alain', 'Jacques', '0648443431', 'Allée des papillons', NULL, 67200, 'STRASBOURG',
TO_DATE('03/11/2020, 12:30','dd/mm/yyyy, HH24:MI'), TO_DATE('03/11/2020, 12:40','dd/mm/yyyy, HH24:MI'), 5, 'livré');
INSERT INTO commande VALUES (1310, 'Barreau', 'Lise', '0615414898', 'Route de Colmar', NULL, 67100, 'STRASBOURG',
TO_DATE('04/11/2020, 11:30','dd/mm/yyyy, HH24:MI'), TO_DATE('04/11/2020, 11:40','dd/mm/yyyy, HH24:MI'), 4, 'livré');
INSERT INTO commande VALUES (1311, 'Dupontel', 'Aline', '0688745633', 'Route des Vosges', NULL, 67000, 'Strasbourg',
TO_DATE('04/11/2020, 12:30','dd/mm/yyyy, HH24:MI'), TO_DATE('04/11/2020, 12:45','dd/mm/yyyy, HH24:MI'), 3, 'livraison');
INSERT INTO commande VALUES (1312, 'Thomes', 'Marc', '0686458887', 'Route de Rome', 'Residence Paul Appel', 67000, 'Strasbourg',
TO_DATE('04/11/2020, 12:45','dd/mm/yyyy, HH24:MI'), NULL, NULL, NULL);
INSERT INTO commande VALUES (1313, 'Loebs', 'Céline', '0605985632', 'Route de Finkwiller', NULL, 67000, 'STRASBOURG',
TO_DATE('04/11/2020, 12:50','dd/mm/yyyy, HH24:MI'), NULL, NULL, NULL);

INSERT INTO ligne_cmd VALUES (800, 1, 2, 5);
INSERT INTO ligne_cmd VALUES (800, 4, 1, NULL);
INSERT INTO ligne_cmd VALUES (801, 5, 1, NULL);
INSERT INTO ligne_cmd VALUES (802, 7, 2, NULL);
INSERT INTO ligne_cmd VALUES (903, 11, 2, 5);
INSERT INTO ligne_cmd VALUES (904, 14, 2, 5);
INSERT INTO ligne_cmd VALUES (904, 23, 1, NULL);
INSERT INTO ligne_cmd VALUES (954, 9, 2, NULL);
INSERT INTO ligne_cmd VALUES (954, 17, 1, NULL);
INSERT INTO ligne_cmd VALUES (954, 3, 3, NULL);
INSERT INTO ligne_cmd VALUES (1005, 11, 1, NULL);
INSERT INTO ligne_cmd VALUES (1006, 11, 2, NULL);
INSERT INTO ligne_cmd VALUES (1006, 5, 5, 15);
INSERT INTO ligne_cmd VALUES (1007, 11, 5, NULL);
INSERT INTO ligne_cmd VALUES (1108, 18, 1, NULL);
INSERT INTO ligne_cmd VALUES (1109, 13, 5, 15);
INSERT INTO ligne_cmd VALUES (1109, 20, 1, NULL);
INSERT INTO ligne_cmd VALUES (1210, 4, 1, NULL);
INSERT INTO ligne_cmd VALUES (1210, 19, 1, NULL);
INSERT INTO ligne_cmd VALUES (1310, 9, 1, 5);
INSERT INTO ligne_cmd VALUES (1310, 15, 1, NULL);
INSERT INTO ligne_cmd VALUES (1310, 8, 1, NULL);
INSERT INTO ligne_cmd VALUES (1311, 6, 1, NULL);
INSERT INTO ligne_cmd VALUES (1312, 24, 1, NULL);
INSERT INTO ligne_cmd VALUES (1312, 18, 2, NULL);
INSERT INTO ligne_cmd VALUES (1313, 15, 2, NULL);

commit;
