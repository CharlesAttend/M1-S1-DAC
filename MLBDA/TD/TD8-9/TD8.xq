(:~~~~~~~~~~~~ Exercice 1 ~~~~~~~~~~~~:)
(:~~~~~~~~~~~~ Exercice 1 ~~~~~~~~~~~~:)

(:~ Question 1 ~:)
<result>{
    for $m in //menu
    return <
}
</result>

(:~ Question 2 ~:)
(:~ Question 3 ~:)
<result>{
    for $r in //restaurant
    where $r/@etoile=2
    return <restaurant nom="{$r/@nom}">
        {
            for $m in $r/menu
            return <menu nom="{$m/@nom}"/>
        }
        </restaurant>
}</result>

(:~ Question 4 ~:)
<result>{
    for $r in //restaurant
    let $d := //vile[@nom=$r/@ville]/@departement
    return <restaurant nom="{$r/@nom}" departement="{$d}"/>
}</result>

(:~ Question 5 ~:)
<result>{
    for $r in //restaurant
    let $t := //ville[@nom = $r/@ville]/plusBeauMonument/@tarif
    (:~ Heuresement que le monument est unique sinon on aurait des problèmes dans l'égalité ~:)
    where $r/menu/@prix = $t
    return 
        <result>
            <restaurant nom="{$r/@nom}"/>
            <tarif_monument prix="{$t}"/>
        </result>
}</result>

(:~~~~~~~~~~~~ Exercice 2 ~~~~~~~~~~~~:)

(:~ Question 1 ~:)
<result>{
    for $b in //book[publisher="Addison Wesley" and @year > 1991]
    return 
        <book year="{$b/@year}">
            {$b/title}
        </book>
}</result>

(:~ Question 2 ~:)
<result>{
    for $b in //book, $t in $b/title, $a in $b/author
    return
        <result>
            {$t}
            {$a}
        </result>
}</result>

(:~ Question 3 ~:)
(:~ <result>{
    for $b in //book
    for $a in $b/author
    return 
        <result>
            {$b/title}
            {$a}
        </result>
}</result> ~:)
(:~ Correction ~:)
<result>{
    for $b in //book
    return 
        <result>
            {$b/title}
            {$b/author}
        </result>
}</result>

(:~ Question 4 ~:)
<result>{
    for $a in //author,
        $b in //book[author = $a]
    return 
        <result>
            {$a}
            {$b/title}
        </result>
}</result>

(:~ Correction ~:)
(:~ On pourait penser à un distict-values(//author) mais ça renvoie la concatenation du texte de la balise author ~:)
(:~ D'après le prof il faut ruser (mais je vois pas le problème) ~:)
(:~ A tester en TME ma solution ~:)
<result>{
    for $l in distinct-values(//last),
        $f in distinct-values(//first[parent author/last=$l])
    return 
        <result>
            <author>
                <last>{$l}</last>
                <first>{$f}</first>
            <author>
            {//book[author/last = $l and author/first=$f]/title}
        </result>
}</result>


(:~ S4ENTRAINER PLUS !!!!! CORRECTION SUR MATTERMSOT ~:)