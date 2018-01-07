TARGETS="ar71xx-generic brcm2708-bcm2708 ipq806x ramips-mt7621 ar71xx-mikrotik brcm2708-bcm2709 x86-64 ar71xx-nand brcm2708-bcm2710 ramips-rt305x x86-generic ramips-mt7620 sunxi x86-geode"
BRANCH=$1
BUILDPATH=$2

cd $HOME

if [ "$BRANCH" == "" ]; then
    echo "Buildbranche angeben: stable, experimental, beta"
    exit 1;
fi

if [ "$2" == "" ]; then
    echo "Buildordner angeben."
    echo "Beispiel: build.sh $BRANCH gluon/"
    exit 2;
fi
    
cd $BUILDPATH

for x in $TARGETS;
do
    echo make clean GLUON_TARGET=$x
done

git pull
make update
echo cd $HOME/$BUILDPATH/output
if [ -e $HOME/$BUILDPATH/output/image ]; then
    echo rm -rf *
fi

for x in $TARGETS;
do
    make GLUON_TARGET=$x GLUON_BRANCH=$BRANCH -j4 GLUON_REGION=eu BROKEN=1
done
