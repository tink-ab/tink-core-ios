#!/bin/sh
echo Enter new pod spec version:
read newVersion

if [[ $newVersion =~ ^([0-9]{1,2}\.){2}[0-9]{1,10}$ ]]; then
git checkout master
git pull
git checkout -b rc-$newVersion
else
  echo "$newVersion is not in the right format."
  exit
fi

sed -i "" 's/  spec.version      = "[0-9]\.[0-9]\.[0-9]"/  spec.version      = "'$newVersion'"/' TinkCore.podspec
sed -i "" 's/      MARKETING_VERSION: [0-9]\.[0-9]\.[0-9]/      MARKETING_VERSION: '$newVersion'/' project.yml

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
