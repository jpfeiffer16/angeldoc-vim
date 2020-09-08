#!/bin/sh

mkdir -p $HOME/.angeldoc/bin
rm -rf $HOME/.angeldoc/bin

LATEST_RELEASE=$(wget -qO- "https://api.github.com/repos/jpfeiffer16/AngelDoc/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')


wget -P $HOME/.angeldoc/bin "https://github.com/jpfeiffer16/AngelDoc/releases/download/$LATEST_RELEASE/AngelDoc.zip"

echo "https://github.com/jpfeiffer16/AngelDoc/releases/download/$LATEST_RELEASE/AngelDoc.zip"

unzip $HOME/.angeldoc/bin/AngelDoc.zip -d $HOME/.angeldoc/bin/

