-- Question 1
SELECT Name FROM Country AS C
    JOIN IsMemeber AS M ON C.Code = M.Country
    JOIN Organisation AS O ON O.Abbreviation = M.Organisation
    WHERE C.Name = "Nation Unis"
    ORDER BY C.Name
-- Correction
SELECT c.Name FROM Country c, IsMember i, Organisation o 
    WHERE c.code = i.country 
    AND i.organisation = o.abreviation 
    AND o.name = 'United nations'
    ORDER BY c.Name;

-- Question 2
-- Quelle population lol ?
SELECT Country, C.Population FROM IsMember AS M
    JOIN Country AS C ON C.Name = M.Country
    JOIN Organisation AS O ON O.Name = M.Organisation
    WHERE O.Name = "Nation Unis"
    ORDER BY C.Population DESC;
-- Correction : OK 

-- Question 3
SELECT Country FROM IsMember AS M
    JOIN Country AS C ON C.Name = M.Country
    JOIN Organisation AS O ON O.Name = M.Organisation
    WHERE NOT O.Name = "Nation Unis";
-- Faux car on a des pays associé à plusieurs orgarnisation 

-- Question 4
SELECT Name FROM Country AS C
    JOIN Border AS B ON B.Country1 = C.code
    JOIN Country AS C2 ON B.Country
    WHERE 
-- Correction
SELECT C2.Name FROM Border B, Country C1, CountryC2
    WHERE C1.Name = 'FR' AND B.Country1 = C1.Code AND B.Country2 = C2.Code
    UNION 
SELECT C2.Name FROM Border B, Country C1, CountryC2
    WHERE C2.Name = 'FR' AND B.Country1 = C1.Code AND B.Country2 = C2.Code

-- Question 5
SELECT  FROM Border B, Country C1, CountryC2
    WHERE (C1.Name = 'FR' OR C2.Name = 'FR ')
    AND B.Country1 = C1.Code AND B.Country2 = C2.Code
-- Correction : 
SELECT o.Name from Border b, Country f, Country v
WHERE f.Name = "France" AND 
    ((f.code = b.country1 AND v.code = b.country2) 
    OR (f.Code = b.Country2 AND v.code = b.Country1))

-- Question 6
SELECT SUM(B.lenght) FROM Border B, Country C1, CountryC2
    WHERE (C1.Name = 'FR' OR C2.Name = 'FR ')
    AND B.Country1 = C1.Code AND B.Country2 = C2.Code
-- Correction : 
SELECT o.Name from Border b, Country f
WHERE f.Name = "France" AND 
    ((f.code = b.country1) 
    OR (f.Code = b.Country2));

-- Question 7
SELECT C.Name, COUNT(F.Country1)+COUNT(V.Country2) FROM Border B, Country F, Country V
    WHERE ((f.code = b.country1) 
    OR (f.Code = b.Country2))
    GROUP BY C.Name;
-- Correction : 
SELECT c.Name, COUNT(*) FROM Border b, Country c
WHERE b.Country1 = c.code OR B.Country2  = c.Code
GROUP BY c.name

-- J4AI GIVE UP? J4AI TOUJOURS FAUX AVEC CE PROF POURQUOI ON A PAS LA DATA BASE PUTAIN
-- Question 8
SELECT c.Name, SUM() FROM Border b, Country c
WHERE b.Country1 = c.code OR B.Country2  = c.Code
GROUP BY c.name
-- Correction : 
DEMANDER 

-- Question 1
-- Correction : 

-- Question 1
-- Correction : 

-- Question 1
-- Correction : 

-- Question 1
-- Correction : 

-- Question 1

-- Question 1

-- Question 1

-- Question 1