(:~~~~~~~ Exercice 1 ~~~~~~~:)
(: Question 1 :)
(: //person[@id = "person0"]/name :)
(: for $p in //person
where $p/@id = "person0"
return $p/name :)

(: Question 2 :)
(: for $a in //open_auctions/auction[position() < 4]
return 
  <result>
    {$a/initial}
  </result> :)

(: Question 3 :)
(: for $a in //open_auctions/auction[position() < 4]
let $first := $a/bidder[position() = 1]/increase/text()
let $last := $a/bidder[position() = last()]/increase/text()
return 
  <result id="{$a/@id}">
    <first>{$first}</first>
    <last>{$last}</last>
  </result> :)

(: Question 4 :)
(: //price[text() > 480] :)

(: Question 5 :)
(: //africa/item/name :)

(: Question 6 :)
(: Avec le let ça renvoie aussi les object sans prix :)
(: let $price := //closed_auctions/auction[itemref/@item = $object/@id]/price :)
(: for $object in //africa/item,
    $price in //closed_auctions/auction[itemref/@item = $object/@id]/price
return 
  <res>
    {$object/name}
    {$price}
  </res> :)

(: Question 7 :)
(: let $person := //person[not(homepage)]
return count($person) :)