# Cours 1

https://www-master.ufr-info-p6.jussieu.fr/parcours/ima/bima/

TP : correction avec échantillonnage random
Une semaine pour les faire, il veut qu'on aille plus loins que les question ? 
40% CC et 50% Exam, pas de DS1 

Prise en compte de la perception dans le traitement d'image (sinon on ferait du traitement de signal) : exemple des illusions d'optiques

## Encodage d'image
### RBG
RGB = un cube, 
Limite de RGB :
- Les 3 caneaux sont très corrélé => Information redondante 
- Problème pour utiliser des distances euclidienne : certaine couleurs sont proche en distance mais sont pas du tout pareil
Extention : 
- D'autre représentation : ACP 
- Utiliser des model plus proche de l'humais : HSV 

### HSV 
HSV = un cone 
- Value : Moyenne de RGB 
- Hue : De la trigo comme c'est un cercle 
- Saturation : De la trigo comme c'est un cercle 

Brightness : juste la moyenne des valeur de l'image 
Contrast : C'est lié à la distance entre le min et le max qu'on définie pour le niveau de gris. On regarde la distance entre les valeur min et max, on peut utiliser l'écart type. 

3 niveaux d'analyse/de compréhension des images:
- Low : image => image
    - Compression 
    - Restauration (retirer le bruit)
    - Filtrage (trouver uniquement les contours)
    - Segmentation (un pixel = un label)
    - 
- Mid : image => Attributes 
- High : image => understanding (semantic description)
Proche du processing fait par les réseaux de neurone



