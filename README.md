# zoom_sdk_plugin

A flutter customized UI Zoom SDK plugin

*Note*: Test on real IOS devices. For now, only supported IOS

## Zoom SDK Version
- [ IOS ] v5.9.3.2512

## Features

- [x] Zoom init

- [x] Join meeting
  - [ ] public/private room

- [x] Custom UI
  - [x] Get remote user video
  - [x] Get local user video

- [x] Supported iPad

- [ ] Functions

  - [x] Leave meeting
  - [x] Switch camera front/back
  - [x] Toggle camera on/off
  - [ ] Mirror video
  - [ ] User video zoom in/ zoom out
  - [ ] Toggle Audio on/off

- [ ] Supported Android

## Installation

```shell script
$ flutter pub get
$ flutter pub run zoom_sdk_plugin:unzip_zoom_sdk
```

### IOS

Add two rows to the `ios/Runner/Info.plist`:

```xml
<!-- Camera permission -->
<key>NSCameraUsageDescription</key>
<string>Need to use the camera for call</string>
<!-- Mic permission -->
<key>NSMicrophoneUsageDescription</key>
<string>Need to use the microphone for call</string>
```

Disable BITCODE in the `ios/Podfile`:

```
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
```



