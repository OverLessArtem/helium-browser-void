#!/bin/bash

REPO="imputnet/helium-linux"
TPL="srcpkgs/helium-browser-bin/template"

echo "### Checking for Helium Browser updates..."

LATEST_VERSION=$(gh api repos/$REPO/releases/latest --jq .tag_name | sed 's/^v//')
CURRENT_VERSION=$(grep '^version=' "$TPL" | cut -d= -f2)

if [ "$LATEST_VERSION" = "$CURRENT_VERSION" ]; then
    echo "No update required. Current version is: $CURRENT_VERSION"
    exit 0
fi

echo "Updating: $CURRENT_VERSION -> $LATEST_VERSION"

URL_X86="https://github.com/$REPO/releases/download/${LATEST_VERSION}/helium-${LATEST_VERSION}-x86_64_linux.tar.xz"
URL_ARM="https://github.com/$REPO/releases/download/${LATEST_VERSION}/helium-${LATEST_VERSION}-arm64_linux.tar.xz"

echo "Calculating x86_64 checksum..."
CHK_X86=$(curl -L -s "$URL_X86" | sha256sum | awk '{print $1}')

echo "Calculating arm64 checksum..."
CHK_ARM=$(curl -L -s "$URL_ARM" | sha256sum | awk '{print $1}')

if [ -z "$CHK_X86" ] || [ -z "$CHK_ARM" ]; then
    echo "Error: Could not calculate checksums!"
    exit 1
fi

sed -i "s/^version=.*/version=$LATEST_VERSION/" "$TPL"
sed -i "s/^revision=.*/revision=1/" "$TPL"

sed -i "/x86_64)/,/;;/ s/_chk=\".*\"/_chk=\"$CHK_X86\"/" "$TPL"
sed -i "/aarch64)/,/;;/ s/_chk=\".*\"/_chk=\"$CHK_ARM\"/" "$TPL"

echo "### Success! Template updated to $LATEST_VERSION"
