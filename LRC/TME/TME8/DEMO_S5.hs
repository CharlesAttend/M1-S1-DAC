module DEMO_S5 where 

import Data.List
import EREL

data Agent = Ag Int deriving (Eq,Ord)

a,b,c,d,e :: Agent
a = Ag 0; b = Ag 1; c = Ag 2; d = Ag 3; e = Ag 4

instance Show Agent where
  show (Ag 0) = "a"; show (Ag 1) = "b"; 
  show (Ag 2) = "c"; show (Ag 3) = "d" ; 
  show (Ag 4) = "e";  
  show (Ag n) = 'a': show n 

data Prp = P Int | Q Int | R Int | S Int deriving (Eq,Ord)
instance Show Prp where 
  show (P 0) = "p"; show (P i) = "p" ++ show i 
  show (Q 0) = "q"; show (Q i) = "q" ++ show i 
  show (R 0) = "r"; show (R i) = "r" ++ show i
  show (S 0) = "s"; show (S i) = "s" ++ show i

data EpistM state = Mo
             [state]
             [Agent]
             [(state,[Prp])]
             [(Agent,Erel state)]
             [state]  deriving (Eq,Show)

example1 :: EpistM Int
example1 = Mo 
 [0..3]
 [a,b,c]
 []
 [(a,[[0],[1],[2],[3]]),(b,[[0],[1],[2],[3]]),(c,[[0..3]])]
 [1]

example2 :: EpistM Int
example2 = Mo 
 [0..3]
 [a,b,c] 
 [(0,[P 0,Q 0]),(1,[P 0]),(2,[Q 0]),(3,[])]
 [(a,[[0..3]]),(b,[[0..3]]),(c,[[0..3]])]
 [0..3]

rel :: Agent -> EpistM a -> Erel a
rel ag (Mo _ _ _ rels _) = apply rels ag

initM :: (Num state, Enum state) => 
         [Agent] -> [Prp] -> EpistM state
initM ags props = (Mo worlds ags val accs points) 
  where 
    worlds  = [0..(2^k-1)]
    k       = length props
    val     = zip worlds (sortL (powerList props))
    accs    = [ (ag,[worlds]) | ag  <- ags        ]
    points  = worlds

powerList  :: [a] -> [[a]]
powerList  [] = [[]]
powerList  (x:xs) = 
  (powerList xs) ++ (map (x:) (powerList xs))

sortL :: Ord a => [[a]] -> [[a]]
sortL  = sortBy 
  (\ xs ys -> if length xs < length ys 
                then LT
              else if length xs > length ys 
                then GT
              else compare xs ys) 

data Form a = Top 
            | Info a
            | Prp Prp 
            | Ng (Form a)
            | Conj [Form a]
            | Disj [Form a]
            | Kn Agent (Form a)
          deriving (Eq,Ord,Show)

impl :: Form a -> Form a -> Form a
impl form1 form2 = Disj [Ng form1, form2]

isTrueAt :: Ord state => 
            EpistM state -> state -> Form state -> Bool
isTrueAt m w Top = True 
isTrueAt m w (Info x) = w == x
isTrueAt
  m@(Mo worlds agents val acc points) w (Prp p) = let 
   props = apply val w
  in
   elem p props 
isTrueAt m w (Ng f) = not (isTrueAt m w f)
isTrueAt m w (Conj fs) = and (map (isTrueAt m w) fs)
isTrueAt m w (Disj fs) = or  (map (isTrueAt m w) fs)
isTrueAt
 m@(Mo worlds agents val acc points) w (Kn ag f) = let 
    r = rel ag m 
    b = bl r w 
  in 
    and (map (flip (isTrueAt m) f) b) 

isTrue :: Ord a => EpistM a -> Form a -> Bool
isTrue m@(Mo worlds agents val acc points) f = 
  all (\w -> isTrueAt m w f) points

upd_pa :: Ord state => 
          EpistM state -> Form state -> EpistM state
upd_pa m@(Mo states agents val rels actual) f = 
  (Mo states' agents val' rels' actual') 
   where 
   states' = [ s | s <- states, isTrueAt m s f ]
   val'    = [ (s, ps) | (s,ps) <- val, s `elem` states' ]
   rels'   = [(ag,restrict states' r) | (ag,r) <- rels ]
   actual' = [ s | s <- actual, s `elem` states' ]

upds_pa ::  Ord state => 
            EpistM state -> [Form state] -> EpistM state
upds_pa = foldl upd_pa

sub :: Eq a => [(Prp,Form a)] -> Prp -> Form a
sub subst p = 
  if elem p (map (\ (x,_) -> x) subst) 
    then apply subst p 
    else (Prp p)

upd_pc :: Ord state => [Prp] -> EpistM state 
                    -> [(Prp,Form state)] -> EpistM state
upd_pc ps m@(Mo states agents val rels actual) sb = 
  (Mo states agents val' rels actual) 
   where 
   val' = [ (s, [p | p <- ps, isTrueAt m s (sub sb p)]) 
                                          | s <- states ]

upds_pc :: Ord state => [Prp] -> EpistM state 
                     -> [[(Prp,Form state)]] -> EpistM state
upds_pc ps = foldl (upd_pc ps)

sexample =  [(P i, Kn a (Info i)) | i <- [0..3 ]]
             ++
            [(Q i, Kn b (Info i)) | i <- [0..3 ]]
             ++
            [(R i, Kn c (Info i)) | i <- [0..3 ]]

exampleprops = [P i | i <- [0..3 ]]
                ++
               [Q i | i <- [0..3 ]]
                ++
               [R i | i <- [0..3 ]]

upd_pi :: (state -> state) -> EpistM state -> EpistM state
upd_pi f m@(Mo states agents val rels actual) = 
  Mo 
  (map f states)
  agents
  (map (\ (x,ps) -> (f x,ps)) val)
  (map (\ (ag,erel) -> (ag, map (map f) erel)) rels)
  (map f actual)

bools = [True,False]

initBar :: EpistM (Bool,Bool,Bool)
initBar = Mo states [a,b,c] [] rels [(True,True,True)] 
  where 
  states = [ (b1,b2,b3) | b1 <- bools,  
                          b2 <- bools,  
                          b3 <- bools ]
  rela = (a,[[(True,x,y)  | x <- bools, y <- bools],
             [(False,x,y) | x <- bools, y <- bools]])
  relb = (b,[[(x,True,y)  | x <- bools, y <- bools],
             [(x,False,y) | x <- bools, y <- bools]])
  relc = (c,[[(x,y,True)  | x <- bools, y <- bools],
             [(x,y,False) | x <- bools, y <- bools]])
  rels = [rela,relb,relc]

allBeer :: Form (Bool,Bool,Bool)
allBeer = Info (True,True,True)
 
ignA, ignB, ignC :: Form  (Bool,Bool,Bool)
ignA = Conj [Ng (Kn a allBeer), Ng (Kn a (Ng allBeer))]
ignB = Conj [Ng (Kn b allBeer), Ng (Kn b (Ng allBeer))]
ignC = Conj [Ng (Kn c allBeer), Ng (Kn c (Ng allBeer))]

knowC, knowC' :: Form  (Bool,Bool,Bool)
knowC  = Kn c allBeer
knowC' = Kn c (Ng allBeer)

barModel1 = upd_pa initBar ignA

barModel2 = upd_pa barModel1 ignB

barModel3 = upd_pa barModel2 knowC

barModel3' = upd_pa barModel2 knowC'

pairs :: [(Int,Int)]
pairs  = [ (x,y) |  x <- [2..100], y <- [2..100], 
                    x < y, x+y <= 100 ]

msnp :: EpistM (Int,Int)
msnp = (Mo pairs [a,b] [] acc pairs)
  where 
  acc   = [ (a, [ [ (x1,y1) | (x1,y1) <- pairs,  
                               x1+y1 == x2+y2 ] |
                                 (x2,y2) <- pairs ] ) ]
          ++
          [ (b, [ [ (x1,y1) | (x1,y1) <- pairs,  
                               x1*y1 == x2*y2 ] |
                                 (x2,y2) <- pairs ] ) ]

statement_1 = 
  Conj [ Ng (Kn b (Info p)) | p <- pairs ]

statement_1e = 
  Conj [ Info p `impl` Ng (Kn b (Info p)) | p <- pairs ]

k_a_statement_1e = Kn a statement_1e

statement_2 = 
  Disj [ Kn b (Info p) | p <- pairs ]

statement_2e = 
  Conj [ Info p `impl` Kn b (Info p) | p <- pairs ]

statement_3 = 
  Disj [ Kn a (Info p) | p <- pairs ]

statement_3e =  
  Conj [ Info p `impl` Kn a (Info p) | p <- pairs ]

solution = upds_pa msnp 
           [k_a_statement_1e,statement_2e,statement_3e]

init_mud :: EpistM (Bool,Bool,Bool)
init_mud = Mo states [a,b,c] [] rels [(False,True,True)] 
  where 
  states = [ (m1,m2,m3) | m1 <- bools,  
                          m2 <- bools,  
                          m3 <- bools ]
  rela = (a,[[(True,x,y),(False,x,y)] | x <- bools, 
                                        y <- bools])
  relb = (b,[[(x,True,y),(x,False,y)] | x <- bools, 
                                        y <- bools])
  relc = (c,[[(x,y,True),(x,y,False)] | x <- bools, 
                                        y <- bools])
  rels = [rela,relb,relc]

father :: Form (Bool,Bool,Bool)
father = Ng (Info (False,False,False))

kn_a = Disj [Kn a (Disj [Info (True,x,y) | x <- bools, 
                                           y <- bools]), 
             Kn a (Disj [Info (False,x,y) | x <- bools, 
                                            y <- bools ])]

kn_b = Disj [Kn b (Disj [Info (x,True,y) | x <- bools, 
                                           y <- bools]), 
             Kn b (Disj [Info (x, False,y) | x <- bools, 
                                             y <- bools ])]

kn_c = Disj [Kn c (Disj [Info (x,y,True) | x <- bools, 
                                           y <- bools]), 
             Kn c (Disj [Info (x,y,False) | x <- bools, 
                                            y <- bools ])]

dont_know :: Form (Bool,Bool,Bool)
dont_know = Conj [Ng kn_a, Ng kn_b, Ng kn_c]

mod1 = upd_pa init_mud father
mod2 = upd_pa mod1 dont_know
mod3 = upd_pa mod2 (Conj [kn_b,kn_c])

solution3 = upds_pa init_mud
          [father,dont_know,Conj [kn_b,kn_c]]

bTables :: Int -> [[Bool]]
bTables 0 = [[]]
bTables n = map (True:) (bTables (n-1)) 
            ++ map (False:) (bTables (n-1))

initN :: Int -> EpistM [Bool]
initN n = Mo states agents [] rels points where 
  states = bTables n 
  agents = map Ag [1..n]
  rels = [(Ag i, [[tab1++[True]++tab2,tab1++[False]++tab2] |
                   tab1 <- bTables (i-1), 
                   tab2 <- bTables (n-i) ]) | i <- [1..n] ]
  points = [False: take (n-1) (repeat True)]

fatherN :: Int -> Form [Bool]
fatherN n = Ng (Info (take n (repeat False)))

kn :: Int -> Int -> Form [Bool]
kn n i = Disj [Kn (Ag i) (Disj [Info (tab1++[True]++tab2) |
                        tab1 <- bTables (i-1), 
                        tab2 <- bTables (n-i) ]),
               Kn (Ag i) (Disj [Info (tab1++[False]++tab2) |
                        tab1 <- bTables (i-1), 
                        tab2 <- bTables (n-i) ])]

dont :: Int -> Form [Bool] 
dont n = Conj [Ng (kn n i) | i <- [1..n] ]

knowN n = Conj [kn n i | i <- [2..n] ]

solveN :: Int -> EpistM [Bool]
solveN n = upds_pa (initN n) (f:istatements ++ [knowN n]) 
  where 
  f = fatherN n
  istatements = take (n-2) (repeat (dont n))

initPrison :: EpistM (Int,[Int])
initPrison = let x = (0,[]) in 
  Mo 
   [x]
   [a]
   [(x,[])]
   [(a,[[x]])]
   [x]

counted :: Int -> [Int] -> [Int]
counted i xs = if elem i xs then xs else insert i xs 

light = [P 0] 

interrog :: EpistM (Int,[Int]) -> Int -> EpistM (Int,[Int]) 
interrog (Mo [(i,is)] [a] val _ _) 0 = let 
  ys = apply val (i,is) 
  i' = if ys == light then i+1 else i
  x  = (i',is)
 in 
  Mo [x] [a] [(x,[])] [(a,[[x]])] [x]

interrog (Mo [(i,is)] [a] val _ _) k = let 
  ys  = apply val (i,is) 
  is' = if ys == light then is else (counted k is)
  ys' = if elem k is then ys else light 
  x   = (i,is')
 in 
  Mo [x] [a] [(x,ys')] [(a,[[x]])] [x]

inter :: EpistM (Int,[Int]) -> [Int] -> EpistM (Int,[Int]) 
inter = foldl' interrog

check k (Mo [(i,_)] _ _ _ _) = k == i+1 

process :: Int -> [Int]
process k = cycle [0..k-1]

protocol :: Int -> [Int] -> [EpistM (Int,[Int])]
protocol k = protocol' initPrison where 
  protocol' m (i:is) 
    | check k m = [m]
    | otherwise =  m : protocol' (interrog m i) is

measure :: Int -> [Int] -> Int
measure k pr = length (protocol k pr) - 1

data UpdateM state = UM
  [state]
  [Agent]
  [(state,Form state)]
  [(Agent,Erel state)]
  [state] deriving (Eq,Show)

type FUM state = [Agent] -> UpdateM state

fum1 :: FUM Int
fum1 = \ ags -> UM 
  [0,1]
  ags
  [(0,Disj [Prp (P 0),Prp (Q 0)]),(1,Top)]
  ((a,[[0],[1]]): [(b,[[0,1]]) | b <- ags \\ [a] ])
  [0]

upd :: Ord state => 
       EpistM state -> FUM state -> EpistM (state,state)
upd m@(Mo states agents val rels actual) fum = 
  Mo states' agents' val' rels' actual' 
  where 
  UM events agents' pre susp aevent = fum agents 
  states' = [ (s,e) | s <- states, e <- events, 
                      isTrueAt m s (apply pre e) ]
  val'    = [ ((s,e),props) | (s,props) <- val, 
                               e        <- events, 
                               elem (s,e) states'  ]
  rels'   =  [ (ag1, restrictedProd r s states') | 
                                  (ag1,r) <- rels, 
                                  (ag2,s) <- susp,
                                   ag1 == ag2      ]
  actual' = [ (a,e) | a <- actual, 
                      e <- aevent, elem (a,e) states' ]

convrt :: Eq state => 
           EpistM state -> EpistM Int
convrt (Mo states agents val rels actual) = 
 Mo states' agents val' rels' actual'
   where 
    states' = map f states
    val'    = map (\ (x,y) -> (f x,y)) val
    rels'   = map (\ (x,r) -> (x, map (map f) r)) rels
    actual' = map f actual
    f       = apply (zip states [0..])

