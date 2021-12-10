# Trouver-iOS

Welcome to the iOS Trouver Client! Our mission to give users an easy to use and visual way to find and save new hikes :)

## Development

### Prerequisites
Xcode 13.1
1. [git-lfs](https://git-lfs.github.com/) - Git Large File System
1. [SwiftLint](https://github.com/realm/SwiftLint) - Linter
1. Add `APIKeys.plist` in the same folder as `Info.plist`

### Running
1. Go to src/Trouver
1. open Trouver.xcodeproj
1. Run the Trouver scheme

### Local Server
1. Install [localtunnel](https://github.com/localtunnel/localtunnel)
1. In Trouver-Core, navigate to NodeApiPlayground
1. Run `node app.js` (Runs on PORT 8080)
1. Open a new terminal and run lt --port 8000
1. Take note of the url (without https) and paste it into the `host` variable on the class `EnvironmentProvider`
1. Deploy the app to simulator/device