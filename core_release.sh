#!/bin/sh
git checkout master
git pull
git checkout -b release-candidate

rm -rf ./build
rm -rf ./TinkCore.xcframework

echo Enter new pod spec version:
read newVersion

sed -i "" "s/[0-9]\.[0-9]\.[0-9]/$newVersion/g" TinkCore.podspec
sed -i "" "s/[0-9]\.[0-9]\.[0-9]/$newVersion/g" project.yml
git commit -am"Update version"

make format
git commit -am"Format project"

make cartage-project
make framework

mv ./build/TinkCore.xcframework ./
git commit -am"Update framework"

echo Done! Push this your private fork of Tink Core
