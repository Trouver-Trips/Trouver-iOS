#!/bin/bash

set -eo pipefail

xcodebuild -workspace ./../Trouver.xcworkspace \
            -scheme Trouver \
            -destination platform=iOS\ Simulator,OS=14.5,name=iPhone\ 12 \
            clean test | xcpretty
