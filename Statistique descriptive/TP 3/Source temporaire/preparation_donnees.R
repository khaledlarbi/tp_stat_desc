library("data.table")
library("haven")
library("stringr")


donnees <- fread("C:/Users/Khaled/Documents/1A/Statistique descriptive/TP 3/Source temporaire/equipement.csv",
                 stringsAsFactors = FALSE)
donnees <- donnees[substr(ComInsee,1,1) == "2" | substr(ComInsee,1,2) %in% c("59","35"),]

donnees_en_ligne <- melt(donnees, id.vars = c("ComInsee","ComLib"),
                         value.name = "Effectif", variable = "Type",variable.factor = FALSE)

donnees_en_ligne[is.na(Effectif), Effectif := 0]

donnees_pour_sas <- donnees_en_ligne[Type !="Nombre d'équipements sportifs"][, .(ComInsee, Type, Effectif)]
donnees_pour_sas[,Type := substr(Type,1,4)]

donnees_pour_sas[,c("ComInsee","Type","Effectif") := .(as.integer(ComInsee), 
                                                      as.integer(Type),
                                                      as.integer(Effectif))]

write_sas(data = donnees_pour_sas, "C:/Users/Khaled/Documents/1A/Statistique descriptive/TP 3/Source temporaire/equipement.sas7bdat")


#Tables pour format
donnees_en_ligne[Type !="Nombre d'équipements sportifs",
                 .("Numero" = substr(Type,1,4),"Libelle" = substr(Type, start = 8, stop = 1000000L))]

