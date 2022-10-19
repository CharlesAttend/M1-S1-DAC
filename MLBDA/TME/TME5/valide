#!/bin/bash



# option -v = validation ON




export XERCES_HOME="$HOME/mlbda/tme-dtd/dossier espace"

export CP1="$XERCES_HOME/xml-apis.jar"
export CP1="$CP1:$XERCES_HOME/xercesSamples.jar"
export CP1="$CP1:$XERCES_HOME/xercesImpl.jar"


# on utilise le parser sax

# option -v = validation ON

java -cp "$CP1" sax.Counter -v $*

# si le document est valide, alors cela affiche le nombre de noeuds.
