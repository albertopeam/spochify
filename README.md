# Spochify

[![Build Status](https://travis-ci.com/albertopeam/spochify.svg?branch=master)](https://travis-ci.com/albertopeam/spochify)
[![Swift Version](https://img.shields.io/badge/Swift-4.2-F16D39.svg?style=flat)](https://developer.apple.com/swift)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Spochify is a example of usage of RXSwift using the [Spotify API](https://developer.spotify.com/documentation/web-api/) 
The app itself shows categories, playlists, albums and songs. It provides a player to listen the audio samples that spotify provides(30 secs), the player can be controlled from the system player and it shows the playing song in the lock screen. Some of the features are only available in real devices.

![Alt Spochify](https://github.com/albertopeam/spochify/blob/master/art/spochify.gif)

## ToDo
* Add unit testing
* Replace `UserDefaults` by `Keychain`
* Improve navigation
* Update `Player` player to become more reactive

## Installation

To use the app is mandatory to create an app in the Spotify Dashboard and create a plist with the needed information, follow the next steps to do it.

1. You need to access Spotify [dashboard](https://developer.spotify.com/dashboard/)
2. Once access is granted, create a new app entry, more info on [Spotify](https://developer.spotify.com/documentation/general/guides/app-settings/). If you want to understand the authorization process(Implicit Grant Flow) you can check more information on [Spotify](https://developer.spotify.com/documentation/general/guides/authorization-guide/#implicit-grant-flow)
3. Once created the app we need two strings to make the app work:
   1. Client id
   2. Redirect Uri
4. Create an file called `"SpotifyCredentials.plist"` with the following format and replace the default values with the `client id` and `redirect uri` that we have obtained from Spotify dashboard
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>redirectUri</key>
	<string>YOUR-REDIRECT-URI</string>
	<key>clientId</key>
	<string>YOUR-CLIENT-ID</string>
</dict>
</plist>
```

Use [Carthage](https://github.com/Carthage/Carthage) to install required dependencies.

```bash
carthage bootstrap --platform ios
```

## Usage

Now you can run the app, to start using it you need to login with any Spotify account. Then you can explore the sections and play the sample tracks.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)