V=$1

if [ "$V" == "" ]; then
	echo Missing version
	exit -1
fi

echo git push
echo git tag v${V}
echo git push --tags

rm -rf rope-2d
rm rope-2d-${V}.zip

mkdir rope-2d
cp -r rope/* rope-2d
echo ${V} >rope-2d/VERSION
cp README.md rope-2d/
cp LICENSE rope-2d/
zip -r rope-2d-${V}.zip rope-2d/
