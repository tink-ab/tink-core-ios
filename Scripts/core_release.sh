#!/bin/sh
echo Enter new pod spec version:
read newVersion

git checkout master
git pull
git checkout -b rc-$newVersion

sed -i "" "s/[0-9]\.[0-9]\.[0-9]/$newVersion/g" TinkCore.podspec
sed -i "" "s/[0-9]\.[0-9]\.[0-9]/$newVersion/g" project.yml

git commit -am"Update version"

make format
git commit -am"Format project"

rm -rf ./build
rm -rf ./TinkCore.xcframework

make cartage-project
make framework

mv ./build/TinkCore.xcframework ./

git add .
git commit -m"Update framework"

echo Done! Push this your private fork of Tink Core
