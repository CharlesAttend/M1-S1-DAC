module EREL where
import Data.List

infix 1 ==> 
(==>) :: Bool -> Bool -> Bool
p ==> q = (not p) || q

forall :: [a] -> (a -> Bool) -> Bool
forall = flip all

apply :: Eq a => [(a,b)] -> a -> b
apply t = \ x -> maybe undefined id (lookup x t)

restrTable :: Eq a => [a] -> [(a,b)] -> [(a,b)]
restrTable xs t = [ (x,y) | (x,y) <- t, elem x xs ]

type Rel a = [(a,a)]

merge :: Ord a => [a] -> [a] -> [a]
merge xs [] = xs 
merge [] ys = ys 
merge (x:xs) (y:ys) = case compare x y of 
  EQ -> x : merge xs ys
  LT -> x : merge xs (y:ys)
  GT -> y : merge (x:xs) ys

mergeL :: Ord a => [[a]] -> [a]
mergeL = foldl' merge []

domR :: Ord a => Rel a -> [a]
domR [] = []
domR ((x,y):pairs) = mergeL [[x],[y],domR pairs]

cprod :: [a] -> [b] -> [(a,b)]
cprod xs ys = [(x,y) | x <- xs, y <- ys ]

totalR :: [a] -> Rel a 
totalR xs = cprod xs xs 

lfp :: Eq a => (a -> a) -> a -> a
lfp f x | x == f x  = x
        | otherwise = lfp f (f x)

tc :: Ord a => [(a,a)] -> [(a,a)] 
tc r = lfp (\ s -> (s `merge` (r@@s))) r

infixr 5 @@

(@@) :: Eq a => Rel a -> Rel a -> Rel a
r @@ s = 
  nub [ (x,z) | (x,y) <- r, (w,z) <- s, y == w ]

type Erel a = [[a]]

overlap :: Ord a => [a] -> [a] -> Bool
overlap [] ys = False
overlap xs [] = False
overlap (x:xs) (y:ys) = case compare x y of 
  EQ -> True
  LT -> overlap xs (y:ys) 
  GT -> overlap (x:xs) ys

isPart :: Ord a => Erel a -> Bool
isPart []     = True
isPart (b:bs) = all (not.overlap b) bs && 
                isPart bs

domE :: Ord a => Erel a -> [a]
domE = mergeL

rank :: Ord a => Erel a -> Int
rank r = let 
   dom = domE r
 in 
   length dom - length r

bl :: Eq a => Erel a -> a -> [a]
bl r x = head (filter (elem x) r)

related :: Eq a => Erel a -> a -> a -> Bool
related p x y = elem y (bl p x)

fct2equiv :: Eq a => (b -> a) -> b -> b -> Bool
fct2equiv f x y = f x == f y

fct2erel :: (Eq a,Eq b) => (b -> a) -> [b] -> Erel b
fct2erel f [] = []
fct2erel f (x:xs) = let 
   xblock = x: filter (\ y -> f x == f y) xs 
   rest   = xs \\ xblock
 in 
   xblock: fct2erel f rest

totalE :: [a] -> Erel a
totalE xs = [xs]

cfct2rel :: Eq a => [a] -> (a -> a -> Bool) -> Rel a
cfct2rel domain f = 
  [(x,y) | (x,y) <- totalR domain, f x y ]

erel2rel :: Ord a => Erel a -> Rel a 
erel2rel r = 
  [(x,y) | (x,y) <- totalR (domE r), elem y (bl r x) ]

cfct2erel :: Eq a => 
             [a] -> (a -> a -> Bool) -> Erel a
cfct2erel [] r = []
cfct2erel (x:xs) r = xblock : cfct2erel rest r
  where 
  (xblock,rest) = (x:filter (r x) xs, 
                   filter (not . (r x)) xs)

sublist :: Ord a => [a] -> [a] -> Bool
sublist [] ys = True
sublist xs [] = False
sublist (x:xs) (y:ys) = case compare x y of 
  LT -> False
  EQ -> sublist xs ys 
  GT -> sublist (x:xs) ys

finer :: Ord a => Erel a -> Erel a -> Bool
finer r s = all (\xs -> any (sublist xs) s) r

coarser :: Ord a => Erel a -> Erel a -> Bool
coarser r s = finer s r 

fusion :: Ord a => [[a]] -> Erel a
fusion [] = []
fusion (b:bs) = let 
   cs = filter (overlap b) bs
   xs = mergeL (b:cs)
   ds = filter (overlap xs) bs
 in 
   if cs == ds 
     then xs : fusion (bs \\ cs)
     else fusion (xs : bs)

rel2erel :: Ord a => Rel a -> Erel a
rel2erel []  = []
rel2erel ((x,y):pairs) = let 
   xypairs = filter (\ (u,v) -> 
             elem u [x,y] || elem v [x,y]) pairs
   rest    = pairs \\ xypairs 
   xyblock = domR ((x,y):xypairs)
 in 
   fusion (xyblock : rel2erel rest)

concatE :: Ord a => Erel a -> Erel a -> Erel a
concatE r s = fusion [ merge b (bl s x) | b <- r, x <- b ]

r = [[1,2],[3]]
s = [[1],[2,3]]

unionRel ::  Ord a => Erel a -> Erel a -> Erel a
unionRel r s = fusion (r++s)

unionRels :: Ord a => [Erel a] -> Erel a
unionRels = foldl1' unionRel

restrict :: Ord a => [a] -> Erel a -> Erel a 
restrict domain =  nub . filter (/= []) 
                   . map (filter (flip elem domain)) 

split :: Ord a => Erel a -> [a] -> (Erel a, Erel a)
split r xs = let 
   domain = domE r 
   ys     = domain \\ xs
 in 
   (restrict xs r, restrict ys r)

intersectRel ::  Ord a => Erel a -> Erel a -> Erel a
intersectRel r [] = []
intersectRel r (b:bs) = let 
   (xs,ys) = split r b 
 in 
   xs ++ intersectRel ys bs

intersectRels :: Ord a => [Erel a] -> Erel a
intersectRels = foldl1' intersectRel

fission :: Ord a => Erel a -> Erel a
fission [] = []
fission (b:bs) = let 
   xs = filter (overlap b) bs
   ys = bs \\ xs
   zs = [ [b\\c, c\\b, b `intersect` c] | c <- xs ]
   us = filter (/= []) $ concat zs
 in 
   if xs == [] then b: fission bs 
   else fission (us++ys)

prod :: Erel a -> Erel b -> Erel (a,b)
prod r s = [ [ (x,y) | x <- b, y <- c ] | b <- r, c <- s ]

restrictedProd :: (Eq a,Eq b) => 
                   Erel a -> Erel b -> [(a,b)] -> Erel (a,b)
restrictedProd r s domain = 
  [ [ (x,y) | x <- b, y <- c, elem (x,y) domain ] | 
              b <- r, c <- s ]

restrictedProdT :: (Eq a, Ord b, Ord c) => 
         [(a,Erel b)] -> [(a,Erel c)] 
          -> [(b,c)] -> [(a,Erel (b,c))] 
restrictedProdT table1 table2 domain = 
   [ (i, restrictedProd r s domain) | 
      (i,r) <- table1, (j,s) <- table2, i == j ] 

convert :: Ord a => [b] -> [(t, Erel a)] -> [(t, Erel b)]
convert newstates table = let
   sts = states table 
   f = apply (zip sts newstates)
 in
   [ (a,map (map f) erel) | (a,erel) <- table ]

convertMapping :: Ord a => [b] -> [(t, Erel [a])] 
                        -> ( [(t, Erel b)] , [(a,b)] )
convertMapping newstates table = let
   sts = states table 
   mapping = (zip sts newstates)
   f = apply mapping
   bisiMapping = concat [ [ (x,y) | x <- list ] | 
                             (list,y) <- mapping ]
 in
   ( [ (a,map (map f) erel) | 
            (a,erel) <- table ] , bisiMapping )

eqs2erel :: Ord a => Rel a -> Erel a
eqs2erel = rel2erel

ineqsProp :: Ord a => Rel a -> Erel a -> Bool
ineqsProp [] _ = True
ineqsProp ((x,y):pairs) p = let 
    domain = domE p 
    check (u,v) = 
      elem u domain && elem v domain
        ==> bl p u /= bl p v 
  in
    check (x,y) && ineqsProp pairs p

consistentCs :: Ord a => Rel a -> Rel a -> Bool
consistentCs eqs ineqs = 
  ineqsProp ineqs (eqs2erel eqs)

gendomain :: Ord a => a -> [Erel a] -> [a]
gendomain x rs = head (fusion $ [x]: concat rs)

genD :: Ord a => a -> [(b,Erel a)] -> [a]
genD x = gendomain x . map snd

sameVal :: (Eq a,Eq b) => [(a,b)] -> a -> a -> Bool
sameVal = fct2equiv.apply 

initPartition :: (Eq a,Eq b) => [(a,b)] -> [a] -> [[a]]
initPartition = fct2erel.apply

agents :: [(a,Erel b)] -> [a]
agents = map fst 

states :: Ord b => [(a,Erel b)] -> [b]
states = domE.snd.head 

accBlocks :: (Eq a,Eq b) => 
           [(a,Erel b)] -> [[b]] -> a -> b -> [[b]]
accBlocks table part ag s = let 
    rel = apply table ag
    xs  = bl rel s
  in 
    nub [ bl part x | x <- xs ]

sameAB :: (Eq a,Eq b) => 
          [(a,Erel b)] -> [[b]] -> b -> b -> Bool
sameAB table part s t = let 
   ags = agents table
   f   = accBlocks table part
 in 
   and [ f ag s == f ag t | ag <- ags ]

refineStep :: (Eq a,Eq b) => 
              [(a,Erel b)] -> [[b]] -> [[b]]
refineStep table p = let 
   f bl = 
    (cfct2erel bl (sameAB table p) ++)
 in 
   foldr f [] p

refine :: (Eq a,Eq b) => 
          [(a,Erel b)] -> [[b]] -> [[b]]
refine table = lfp (refineStep table)

minimize :: (Eq a, Ord b, Eq c) => 
            [(a,Erel b)] -> [(b,c)] -> [(a,Erel [b])]
minimize table val = let 
   sts   = states table
   initP = initPartition val sts
   sts'  = refine table initP
   f     = bl sts'
 in 
   [ (a, map (nub.(map f)) erel) | (a, erel) <- table ]

table = [(1,[[1,2,3],[4,5,6]]), (2,[[1,2,3,4,5,6]])]
val   = map (\ n -> (n,even n)) [1..6]

mini = minimize table val

bisim :: (Eq a, Enum a, Ord b, Eq c, Num d, Enum d) => 
         [(a, Erel b)] -> [(b,c)] -> [(a, Erel d)]
--bisim table f = convert [0..] $ minimize table f
bisim = (convert [0..] .)  .  minimize

example = bisim table val

