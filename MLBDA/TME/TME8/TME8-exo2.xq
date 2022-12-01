(:~~~~~~~  Exercice 2 ~~~~~~~:)
(: Question 1 :)
(: <tournois>{
  for $annee in distinct-values(//rencontre/annee)
  for $lieu in distinct-values(//rencontre[annee=$annee]/lieutournoi)
  order by $lieu
  order by $annee ascending
  return 
    <tournoi>
      <tournoi lieu="{$lieu}" annee="{$annee}">
      </tournoi>
    </tournoi>
}</tournois> :)

(: Question 2 :)
(: J'ai pas trouvé un order by correct :)
<tournois>{
  for $annee in distinct-values(//rencontre/annee)
  for $lieu in distinct-values(//rencontre[annee=$annee]/lieutournoi)
  order by $lieu
  order by $annee ascending
  return 
    <tournoi>
      <tournoi lieu="{$lieu}" annee="{$annee}">
        {
          for $nbjoueur in //gain[annee=$annee and lieutournoi=$lieu]/nujoueur
          let $joueur := //joueur[nujoueur = $nbjoueur]
          
          return 
            <participant nom="{$joueur/nom}" prenom="{$joueur/prenom}">
            </participant>
        }
      </tournoi>
    </tournoi>
}</tournois>
