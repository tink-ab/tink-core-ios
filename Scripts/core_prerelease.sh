#!/bin/sh
echo "Enter new pod spec version:"
read newVersion

if [[ $newVersion =~ ^([0-9]{1,2}\.){2}[0-9]{1,10}$ ]]; then
git checkout master
git pull
git checkout -b prerelease-$newVersion
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

make carthage-project

xcodebuild -project TinkCore.xcodeproj -target "TinkCore_iOS" build | xcpretty
swift test

make framework

mv ./build/TinkCore.xcframework ./

git add .
git commit -m"Update framework"

zip -r TinkCore.xcframework.zip TinkCore.xcframework

checksum=`swift package compute-checksum TinkCore.xcframework.zip`

old_path="path: \"TinkCore.xcframework\""
new_path="url: \"https://github.com/tink-ab/tink-core-ios/releases/download/$version/TinkCore.xcframework.zip\", checksum: \"$checksum\""
sed -i '' "s|$old_path|$new_path|" Package.swift

git add .
git commit -m "Package.swift checksum update"

gh pr create --repo tink-ab/tink-core-ios-private -t "$newVersion Prerelease" -b "Release candidate for Tink Core prerelease." -r tink-ab/ios-maintainer

echo "Pre-release PR has been created! 🎉"
