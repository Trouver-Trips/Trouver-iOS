#!/bin/bash

set -eo pipefail

xcodebuild -project ./../Trouver.xcodeproj \
           -scheme Trouver \
           -destination platform=iOS\ Simulator,OS=15.0,name=iPhone\ 13 \
           clean test | xcpretty
