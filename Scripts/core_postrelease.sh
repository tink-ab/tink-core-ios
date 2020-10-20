#!/bin/sh

echo Enter release number: 
read release

if [[ $release =~ ^([0-9]{1,2}\.){2}[0-9]{1,10}$ ]]; then
git checkout master
git pull
git checkout -b public-sync-$release
git pull git@github.com:tink-ab/tink-core-ios master
else
  echo "$release is not in the right format."
  exit
fi

gh pr create --repo tink-ab/tink-core-ios-private -t "Public Sync" -b "Tink Core post release public sync." -r tink-ab/ios-maintainer

git push git@github.com:tink-ab/tink-core-ios-private $release

pod trunk push TinkCore.podspec

echo Tink Core public sync created and pushed to cocoapods! 🎉
