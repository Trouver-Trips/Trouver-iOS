#!/bin/bash

set -eo pipefail

xcodebuild -workspace src/Trouver/Trouver.xcworkspace \
            -scheme Trouver \
            -destination platform=iOS\ Simulator,OS=14.0,name=iPhone\ 12 \
            clean test | xcpretty