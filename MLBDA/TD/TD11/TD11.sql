-- Question 1
SELECT name, population, ARRAY_LENGTH(organisation) as nb_orga
FROM country c
WHERE population > 50 000 000
ORDER BY population DESC

-- Question 2
SELECT name
FROM country
WHERE 
    ARRAY_LENGTH(continents) = 2 
    AND
    ANY c IN continent SATISFIES (continents.percentage > 50) END

-- Question 3
SELECT name
FROM country
WHERE EVERY n IN neighbors SATISFIES n.length > 100
-- Un peu comme table() en SQL : ça duplique par le nombre d'élément de la liste pour faire la recherche 


-- Question 4
SELECT name
FROM country
WHERE 
    name IN (SELECT country FROM mountains)
    AND
    name IN (SELECT country FROM deserts)
-- Ne fonctionne pas ! en counchbase

SELECT name
FROM country
WHERE 
    any m in mountain satisfies m.name = name
    any d in deserts satisfies d.name = name
-- Ne fonctionne pas non plus mdr ! 

SELECT Country FROM Mountains
INTERSECT
SELECT Country FROM Desert

-- Question 5
SELECT Country FROM Mountains
EXCEPT -- Equivalent de DIFFERENCE en SQL
SELECT Country FROM Desert

-- Question 6
SELECT DISTINCT c.continent
FROM Country UNNEST continents AS c
-- Encore proche de table() de sql3
-- Pareil, pour un pays avec deux contiennts comme l'Egypte, ça va produire deux lignes pour l'égypte

-- Question 7
SELECT DISTINCT o
FROM Country UNNEST organizations AS o

-- Question 8
SELECT m.name, m.elevation
FROM Mountains UNNEST moutains AS m
WHERE country = "France"
-- Structure du résultat : [{name, elevetation}, {name, elevation}]
-- Autre solution
SELECT mountains
FROM Mountains 
WHERE country = "France"
-- Structure du résultat : [[{name, elevation}, {name, elevation}]]

-- Question 9 : List comprehension
SELECT name, ARRAY c.continent FOR c ON continents END, ARRAY_LENGTH(neighbots) AS NB_VOISIN
FROM Country
WHERE ARRAY_LENGTH(continents) > 1

-- Question 10 : Array aggregate
SELECT org, ARRAY_AGG(c.name) AS list_name, SUM(c.population) AS total_pop
FROM Country c UNNEST organization as org
GROUP BY o
HAVING COUNT(*) > 4
-- | Org | c.nom    | c.population |
-- |-----|----------|--------------|
-- | UN  | Country1 | 1142         |
-- |     | Country2 | 21432        |
-- |     | ...      | 123123       |
-- => Le ARRAY_AGG transforme la colonne c.nom en une liste. 
-- => Le COUNT compte le nombre de ligne par org
-- => Le SUM somme sur c.population

-- Question 11
SELECT name, capital, d.deserts
FROM Country c INNER JOIN Deserts m ON (c.name = d.country)
-- Il faut potentiellement toujours utiliser INNER JOIN et pas que JOIN tout seul pour pas qu'il confonde avec la syntaxe de JOIN ON KEY

-- Question 12
SELECT name, d.deserts, m.moutains
FROM Country 
    INNER JOIN Deserts d ON (c.name = d.country)
    INNER JOIN Mountains m ON (c.name = m.country)
WHERE 
    ARRAY_LENGTH(d.deserts) > 1
    AND
    ARRAY_LENGTH(m.moutains) > 1
-- IDK si ça marche mais comme tout à l'heure y'a plus simple
-- CORRECTION
SELECT 
    m.country,
    ARRAY m.name FOR m IN m.moutains END AS list_montagne
    ARRAY d.name FOR d IN d.deserts END as list_deserts
FROM Mountains AS m INNER JOIN Deserts d ON (m.country = c.country)


-- Question 13
-- CORRECTION
SELECT t.country, ARRAY mt.name FOR mt IN m.mountains END as List_mountain
FROM ( -- Question 5
    SELECT Country FROM Mountains
    EXCEPT 
    SELECT Country FROM Desert
) t INNER JOIN Mountains m on (t.country = m.country)

-- Question 14
SELECT b.name, b.capital
FROM Country c UNNEST neigbors AS n INNER JOIN Country b ON (n.name = b.name)
WHERE c.name = 'France' -- on peut utiliser lower 

-- Question 16
SELECT org
FROM Country c UNNEST organization AS org
GROUP BY organization
ORDER BY SUM(c.population)
LIMIT 1

-- Question 17
