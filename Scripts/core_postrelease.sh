#!/bin/sh

git checkout master
git pull
pod trunk push TinkCore.podspec --allow-warnings
echo "Tink Core public sync created and pushed to cocoapods! 🎉"
