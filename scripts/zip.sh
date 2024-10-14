#!/bin/zsh

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

GROUP="io/github/kapimc"
PROJECT="kapi"
VERSION="$1"

M2_REPO="/mnt/c/Users/Owner/.m2/repository"
SONATYPE=".sonatype"

mkdir -p "$SONATYPE"

mkdir -p "tmp/$GROUP/$PROJECT"
cp -r "$M2_REPO/$GROUP/$PROJECT/$VERSION" "tmp/$GROUP/$PROJECT"
if [ "$?" -ne 0 ]; then
  echo "Error: failed to copy files from $M2_REPO/$GROUP/$PROJECT/$VERSION to tmp/$GROUP/$PROJECT"
  exit 1
fi

cd tmp
zip -r "../$SONATYPE/$PROJECT-$VERSION.zip" .
if [ "$?" -ne 0 ]; then
  echo "Error: failed to create ZIP file at $SONATYPE/$PROJECT-$VERSION.zip"
  exit 1
fi
cd ..

rm -rf "tmp"
if [ "$?" -ne 0 ]; then
  echo "Error: failed to delete tmp directory"
  exit 1
fi

echo "Successfully created ZIP file at $SONATYPE/$PROJECT-$VERSION.zip"
