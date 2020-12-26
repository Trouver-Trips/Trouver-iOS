#!/bin/bash

set -eo pipefail

xcodebuild -project src/Trouver/Trouver.xcodeproj \
            -scheme Trouver \
            -destination platform=iOS\ Simulator,OS=14.2,name=iPhone\ 12 \
            clean test | xcpretty
