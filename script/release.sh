V=$1

if [ "$V" == "" ]; then
	echo Missing version
	exit -1
fi

git push
git tag v${V}
git push --tags

rm -rf wip
rm rope2d-${V}.zip

mkdir wip
cp -r rope2d/* wip
cp -r docs wip/docs
cp -r test wip/test
echo ${V} >rope-2d/VERSION
cp README.md wip
cp LICENSE wip

cd wip
sed -i "" "s/res:\/\/rope\//res:\/\/addons\/rope2d\//g" *
zip -r ../rope2d-${V}.zip *
