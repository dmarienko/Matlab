MATLAB=/usr/local/MATLAB/R2013a/java/
JLIB=mwswing.jar
javac -source 1.6 -target 1.6 -cp ./net-neilcsmith-praxis-laf.jar:$MATLAB/jarext/jgoodies-looks.jar:$MATLAB/jar/util.jar:$MATLAB/jar/$JLIB:. com/mathworks/mwswing/plaf/PlafUtils.java
mkdir ./tmp
cd ./tmp
cp $MATLAB/jar/$JLIB .
jar -xf $JLIB
rm -f $JLIB
cp -rv ../com .
jar cmf META-INF/MANIFEST.MF $JLIB com/
cp $JLIB $MATLAB/jar/
cd .. && rm -rf tmp
