#!/bin/bash
cd packages/bestfriends
flutter pub get
cd ../..
flutter pub get
scripts/compile.sh
