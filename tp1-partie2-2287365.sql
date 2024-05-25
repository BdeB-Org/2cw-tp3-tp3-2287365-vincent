    1. Rédigez les requêtes qui affiche la description pour les trois tables. Le nom des champs et leur type. /2
desc outils_outil
desc outils_emprunt
desc outils_outil;

    2. Rédigez la requête qui affiche la liste de tous les usagers, sous le format prénom « espace » nom de famille (indice : concaténation). /2
SELECT prenom ||' '|| nom_famille
FROM outils_usager;

    3. Rédigez la requête qui affiche le nom des villes où habitent les usagers, en ordre alphabétique, le nom des villes va apparaître seulement une seule fois. /2
SELECT ville
FROM outils_usager
DISTINCT BY ville
ORDER BY ville;

    4. Rédigez la requête qui affiche toutes les informations sur tous les outils en ordre alphabétique sur le nom de l’outil puis sur le code. /2
SELECT *
FROM outils_outil
ORDER BY nom,  code_outil;

    5. Rédigez la requête qui affiche le numéro des emprunts qui n’ont pas été retournés. /2
SELECT num_emprunt AS “Numero d’emprunt”
FROM outils_emprunt
WHERE date_retour = false;

    6. Rédigez la requête qui affiche le numéro des emprunts faits avant 2014. /3
SELECT num_emprunt AS "Numero d'emprunt"
FROM outils_emprunt
WHERE EXTRACT(YEAR FROM date_retour) < 2014;

    7. Rédigez la requête qui affiche le nom et le code des outils dont la couleur début par la lettre « j » (indice : utiliser UPPER() et LIKE) /3
SELECT nom, code_outil
FROM outils_outil
WHERE upper(caracteristiques) LIKE 'J%';

    8. Rédigez la requête qui affiche le nom et le code des outils fabriqués par Stanley. /2
SELECT UPPER (nom, code_outil)
FROM outils_outil
WHERE fabricant = 'STANLEY';

    9. Rédigez la requête qui affiche le nom et le fabricant des outils fabriqués de 2006 à 2008 (ANNEE). /2
SELECT nom, fabricant
FROM outils_outil
WHERE annee BETWEEN 2006 AND 2008;

    10. Rédigez la requête qui affiche le code et le nom des outils qui ne sont pas de « 20 volt ». /3
SELECT LOWER (code_outil, nom)
FROM outils_outil
WHERE caracteristiques = '%20 volts';

    11. Rédigez la requête qui affiche le nombre d’outils qui n’ont pas été fabriqués par Makita. /2
SELECT COUNT(*) AS nombre_outils
FROM outils_outil
WHERE LOWER (fabricant) != ‘makita’;
    12. Rédigez la requête qui affiche les emprunts des clients de Vancouver et Regina. Il faut afficher le nom complet de l’usager, le numéro d’emprunt, la durée de l’emprunt et le prix de l’outil (indice : n’oubliez pas de traiter le NULL possible (dans les dates et le prix) et utilisez le IN). /5
SELECT LOWER (oe.num_emprunt, concat( ou.prenom, ou.nom_famille) AS full_name, datediff(oe.date_retour, oe.date_emprunt) AS duration, oo.prix)
FROM outils_usager ou
JOIN outils_emprunt oe
ON oe.num_usager = ou.num_usager JOIN outils_outil oo
ON oo.code_outil = oe.code_outil
WHERE ou.ville IN ('vancouver', 'regina');

    13. Rédigez la requête qui affiche le nom et le code des outils empruntés qui n’ont pas encore été retournés. /4
SELECT nom, code_outil
FROM outils_outil
WHERE code_outil IN (
SELECT code_outil
FROM outils_emprunt
WHERE date_retour IS NULL);

    14. Rédigez la requête qui affiche le nom et le courriel des usagers qui n’ont jamais fait d’emprunts. (Indice : IN avec sous-requête) /3
SELECT nom_famille ||' '|| prenom AS "Nom de l'usager", courriel
FROM outils_usager
WHERE num_usager NOT IN (
        SELECT num_usager
        FROM outils_emprunt);

    15. Rédigez la requête qui affiche le code et la valeur des outils qui n’ont pas été empruntés. (Indice : utiliser une jointure externe – LEFT OUTER, aucun NULL dans les nombres) /4
SELECT outils_outil.code_outil, coalesce(outils_outil.prix, 0)
FROM outils_outil
LEFT OUTER JOIN outils_emprunt
ON outils_outil.code_outil = outils_emprunt.code_outil
WHERE outils_emprunt.code_outil IS NULL;

    16. Rédigez la requête qui affiche la liste des outils (nom et prix) qui sont de marque Makita et dont le prix est supérieur à la moyenne des prix de tous les outils. Remplacer les valeurs absentes par la moyenne de tous les autres outils. /4
SELECT nom,
COALESCE(
CASE 
WHEN prix > (SELECT AVG(prix) FROM outils_outil) THEN prix 
ELSE NULL 
END,
(SELECT AVG(prix) FROM outils_outil)) AS prix
FROM outils_outil
WHERE LOWER (fabricant) = 'makita';

    17. Rédigez la requête qui affiche le nom, le prénom et l’adresse des usagers et le nom et le code des outils qu’ils ont empruntés après 2014. Triés par nom de famille. /4
SELECT outils_usager.nom_famille, outils_usager.prenom, outils_usager.adresse, outils_outil.nom, outils_outil.code_outil
FROM outils_usager
JOIN outils_emprunt
ON outils_usager.num_usager = outils_emprunt.num_usager JOIN outils_outil
ON outils_emprunt.code_outil = outils_outil.code_outil
WHERE outils_emprunt.date_emprunt < 2014
ORDER BY outils_usager.nom_famille;

    18. Rédigez la requête qui affiche le nom et le prix des outils qui ont été empruntés plus qu’une fois. /4
SELECT ou.nom, ou.prix
FROM outils_outil ou
JOIN oe.outils_emprunt ON ou.code_outil = oe.code_outil
GROUP BY ou.code_outil, ou.nom, ou.prix
HAVING COUNT(*) > 1;

    19. Rédigez les trois requêtes qui affiche le nom, l’adresse et la ville de tous les usagers qui ont fait des emprunts en utilisant la méthode indiquée ci-bas : /6
    • Une jointure
SELECT outils_usager.nom, outils_usager.adresse, outils_usager.ville
FROM users u
JOIN outils_emprunt oe ON u.id = oe.id_user;

    • IN
SELECT outils_usager.nom, outils_usager.adresse, outils_usager.ville
FROM users u
WHERE u.id IN (SELECT id_user FROM outils_emprunts);

    • EXISTS
SELECT outils_usager.nom, outils_usager.adresse, outils_usager.ville
FROM users u
WHERE EXISTS (SELECT 1 FROM emprunts e WHERE e.id_user = u.id_utilisateur);

    20. Rédigez la requête qui affiche la moyenne du prix des outils par marque. /3
SELECT round(AVG(prix), 2) AS "Moyenne des prix", fabricant
FROM outils_outil
GROUP BY fabricant;

    21. Rédigez la requête qui affiche la somme des prix des outils empruntés par ville, en ordre décroissant de valeur. /4
SELECT emprunts.ville, SUM(outils.prix) AS total_prix_outils
FROM emprunts
INNER JOIN outils
ON emprunts.id_outil = outils.id
GROUP BY emprunts.ville
ORDER BY total_prix_outils DESC;

    22. Rédigez la requête pour insérer un nouvel outil en donnant une valeur pour chacun des attributs. /2
INSERT INTO outils_outil (
    nom, prix
) VALUES (
    'Nom', 'Prix');
    23. Rédigez la requête pour insérer un nouvel outil en indiquant seulement son nom, son code et son année. /2
INSERT INTO outils_outil (nom, code, annee) 
VALUES ('Nom', 'Code', 'Annee');

    24. Rédigez la requête pour effacer les deux outils que vous venez d’insérer dans la table. /2
DELETE FROM outils_outil
WHERE outil IN (SELECT MAX(outil) FROM outils_outil);

    25. Rédigez la requête pour modifier le nom de famille des usagers afin qu’ils soient tous en majuscules. /2
UPDATE outils_usagers SET outils_usager.nom_famille = upper(outils_usager.nom_famille);