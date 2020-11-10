CREATE TABLE historique_tarifs (
    CONSTRAINT pk_historique_tarifs
    PRIMARY KEY (idt),
    idt            NUMBER GENERATED ALWAYS AS IDENTITY,
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
    date_fin_tarif DATE
);
