
REM Modifier cette variable en fonction du dossier contenant les jar telechargees

set XERCES_HOME=D:\nuage\ens\mlbda\tp\tme-dtd-etu

set CP1=%XERCES_HOME%\xml-apis.jar
set CP1=%CP1%;%XERCES_HOME%\xercesSamples.jar
set CP1=%CP1%;%XERCES_HOME%\xercesImpl.jar

java -cp "%CP1%" sax.Counter -v %1


