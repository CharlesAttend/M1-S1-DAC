/*Exo 2*/
/* T-BOX */
subs(chat,felin).                                    /* ligne 3 */
subs(felin,mammifere).
subs(mammifere,animal).
subs(canide,mammifere).
subs(chien,canide).
subs(canide,chien).
subs(canari,animal).
subs(animal,etreVivant).
subs(lion,felin).
subs(lion,carnivoreExc).
subs(carnivoreExc,predateur).
subs(chihuahua,and(chien,pet)).                      /* ligne 14 */
subs(souris,mammifere).
subs(and(animal,some(aMaitre)),pet).                 /* ligne 16 */
subs(pet,some(aMaitre)).
subs(animal,some(mange)).
subs(some(aMaitre),all(aMaitre,personne)).           /* ligne 19 */
subs(and(animal,plante),nothing).
subs(and(all(mange,nothing),some(mange)),nothing).   /* ligne 21 */
equiv(carnivoreExc,all(mange,animal)).               /* ligne 22 */
equiv(herbivoreExc,all(mange,plante)).
