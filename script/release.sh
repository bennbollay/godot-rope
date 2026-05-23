V=$1

if [ "$V" == "" ]; then
	echo Missing version
	exit -1
fi

git push
git tag v${V}
git push --tags

rm -rf rope-2d
rm rope-2d-${V}.zip

mkdir rope-2d
cp -r rope/* rope-2d
echo ${V} >rope-2d/VERSION
cp README.md rope-2d/
cp LICENSE rope-2d/
cd rope-2d/
sed -i "" "s/res:\/\/rope\//res:\/\/addons\/rope-2d\//g" *
cd ..
zip -r rope-2d-${V}.zip rope-2d/
