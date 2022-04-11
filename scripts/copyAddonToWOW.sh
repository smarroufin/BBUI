#!/bin/sh

if [[ "$OSTYPE" == "darwin"* ]]; then
  rm -rf /Applications/World\ of\ Warcraft/_retail_/Interface/AddOns/BBUI/*
  cp ../BBUI.toc /Applications/World\ of\ Warcraft/_retail_/Interface/AddOns/BBUI/BBUI.toc
  cp ../main.lua /Applications/World\ of\ Warcraft/_retail_/Interface/AddOns/BBUI/main.lua
else
  echo 'Unsupported OS'
fi
