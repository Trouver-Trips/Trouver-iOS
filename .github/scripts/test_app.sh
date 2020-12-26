#!/bin/bash

set -eo pipefail

xcodebuild -workspace src/Trouver/Trouver.xcodeproj \
            -scheme Trouver \
            -destination platform=iOS\ Simulator,OS=14.2,name=iPhone\ 12 \
            clean test | xcpretty
