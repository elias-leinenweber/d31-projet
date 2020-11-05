/*
 * 7. Créez un trigger HistoTarifs qui alimente une table
 *    historique_tarifs(numt, numpiz, taille, prix, date_deb_tarif,
 *    date_fin_tarif) en cas de modification de tarif.
*/

/*
 * Création de la table historique_tarifs (tous les champs doivent être
 * renseignés).
 */
CREATE TABLE historique_tarifs(
    CONSTRAINT pk_historique_tarifs
    PRIMARY KEY (numt, date_deb_tarif),
    numt           NUMBER(2)   NOT NULL,
                   CONSTRAINT fk_historique_tarifs_numt
                   FOREIGN KEY (numt)
                   REFERENCES tarif,
    pizza          NUMBER(2)   NOT NULL,
                   CONSTRAINT fk_historique_tarifs_pizza
                   FOREIGN KEY (pizza)
                   REFERENCES pizza,
    taille         NUMBER(1)   NOT NULL,
    prix           NUMBER(4,2) NOT NULL,
    date_deb_tarif DATE        NOT NULL,
    date_fin_tarif DATE        NOT NULL
);

/* Création du trigger. */
CREATE OR REPLACE TRIGGER HistoTarifs
BEGIN
END;
/
