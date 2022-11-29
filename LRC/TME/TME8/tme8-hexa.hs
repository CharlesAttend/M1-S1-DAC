module TME7hexa

where
import Data.List
import DEMO_S5

-- les agents sont a,b,c
-- les cartes sont les caracteres r,v,j

allHands = [('r','v','j'),('r','j','v'),('j','r','v'),('j','v','r'),('v','r','j'),('v','j','r')]
rela = (a,[[('r','v','j'),('r','j','v')],[('j','r','v'),('j','v','r')],[('v','r','j'),('v','j','r')]])
relb = (b,[[('r','v','j'),('j','v','r')],[('r','j','v'),('v','j','r')],[('v','r','j'),('j','r','v')]])
relc = (c,[[('r','v','j'),('v','r','j')],[('j','v','r'),('v','j','r')],[('j','r','v'),('r','j','v')]])
rels = [rela,relb,relc]


-- definition de holds_a_rouge, holds_a_jaune, holds_a_vert etc

holds_a_rouge = Disj [Info('r','v','j'),Info('r','j','v')]
holds_a_jaune = Disj [Info('j','v','r'),Info('j','r','v')]
holds_a_verte = Disj [Info('v','r','j'),Info('v','j','r')]
holds_b_rouge = Disj [Info('v','r','j'),Info('j','r','v')]
holds_b_jaune = Disj [Info('v','j','r'),Info('r','j','v')]
holds_b_verte = Disj [Info('r','v','j'),Info('j','v','r')]
holds_c_rouge = Disj [Info('j','v','r'),Info('v','j','r')]
holds_c_jaune = Disj [Info('r','v','j'),Info('v','r','j')]
holds_c_verte = Disj [Info('j','r','v'),Info('r','j','v')]


model0 :: EpistM (Char,Char,Char)
model0 = Mo allHands [a,b,c] [] rels []

