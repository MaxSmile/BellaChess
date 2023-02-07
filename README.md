# Bella Chess

A Flutter Chess game project.

## Description 

Play classic chess on your Android with Bella Chess. Easy-to-use interface, multiple difficulty levels, and customizable options.

### Short Description:
Bella Chess is a classic chess game for Android devices. It features an elegant and simple user interface, making it easy to play against the computer or another player.

### Long Description:
Bella Chess is a beautifully designed chess game for Android devices. It offers a classic chess experience with all the features you would expect from a top-quality chess game. The app features an elegant and simple user interface, which makes it easy to play against the computer or another player. The game includes various difficulty levels, so you can play at your own pace. It also has a built-in tutorial that will help you learn the game if you are new to chess. You can also customize the look and feel of the game by choosing from a variety of different chess piece sets and board styles. Whether you're a seasoned chess player or new to the game, Bella Chess is the perfect app for you.


## TODO

Integration with bellachess.org

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Flutter CLI crib

## Test on device connected

To list devices available:

`
flutter devices
`

Second column reperesents devices ID. Then:

`
flutter run -d 09071FDD4002GR
`

where 09071FDD4002GR is some device id


 ## Test in iPhone simulator

`
open -a Simulator
flutter run -d iPhone
`


## Build APK

`
flutter build apk
`

## Release keys generation

`
keytool -genkey -v -keystore ./upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload -storetype JKS
`


## Versionning

* in pubspec.yml version: 1.0.0+1

* change to version: 1.0.0+2

* flutter build ios --release-name --release-number will update version in ios

* flutter pub get && flutter run will update version for android (android/local.properties)

in case of troubles:

`
flutter clean

flutter pub cache repair 

flutter pub get 

flutter run

`

# Release build

Android 
`
flutter build appbundle 
`

iOS
`
flutter build ipa
`

## if ios buld error

Try:

`
flutter clean
`

delete /ios/Pods
delete /ios/Podfile.lock

`
flutter pub get
`

from inside ios folder: `pod install`

`
flutter run
`
