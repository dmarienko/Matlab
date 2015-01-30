MATLAB=/usr/local/MATLAB/R2013a/java/
JLIB=mwswing.jar
javac -source 1.7 -target 1.7 -cp ./net-neilcsmith-praxis-laf.jar:$MATLAB/jarext/jgoodies-looks.jar:$MATLAB/jar/util.jar:$MATLAB/jar/$JLIB:. com/mathworks/mwswing/plaf/PlafUtils.java
mkdir ./tmp
cd ./tmp
cp ../$JLIB .
jar -xf $JLIB
rm -f $JLIB
cp -rv ../com .
jar cmf META-INF/MANIFEST.MF $JLIB com/
