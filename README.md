# SFImagePicker

[![CI Status](https://img.shields.io/travis/saafaaari/SFImagePicker.svg?style=flat)](https://travis-ci.org/saafaaari/SFImagePicker)
[![Version](https://img.shields.io/cocoapods/v/SFImagePicker.svg?style=flat)](https://cocoapods.org/pods/SFImagePicker)
[![License](https://img.shields.io/cocoapods/l/SFImagePicker.svg?style=flat)](https://cocoapods.org/pods/SFImagePicker)
[![Platform](https://img.shields.io/cocoapods/p/SFImagePicker.svg?style=flat)](https://cocoapods.org/pods/SFImagePicker)
[![SwiftPM](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager/)

## Usage

##### Info.plist
To be able to request permission to the users photo library you need to add this to your Info.plist
```
<key>NSPhotoLibraryUsageDescription</key>
<string>Why you want to access photo library</string>
```

##### Image picker
```swift
import BSImagePicker

let imagePicker = SFImagePicker()

presentImagePicker(imagePicker, animated: true) { (imageManager) in
  // User selected an asset. Do something with it. Perhaps begin processing/upload?
} onDeSelction: { (imageManager) in
  // User deselected an asset. Cancel whatever you did when asset was selected.
} onFinish: { (imageManagers) in
  // User finished selection images.
} onCancel: { (imageManagers) in
  // User canceled selection.
}
```

##### SFImageManager
You need to get the image through acquired imageManager.
```swift
let imageView = UIImageView()
let size = CGSize(width: 30, height: 30)
imageManager.request(size: size) { image, _ in
  imageView.imageID = imageManager.assetID
  imageView.image = image!
}
```

##### Settings
Users can set the selector to their liking.
```swift
picker.settings.selection.max = 3 // maximum number of select
picker.settings.selection.min = 2 // minimum number of select
picker.settings.ui.selectedIndicatorColor = .green // indicator color
picker.settings.ui.selectedIndicatorTextColor = .black // indicator text color
picker.settings.fetchOptions.isSynchronous = false // Synchronous & Asynchronous
picker.settings.fetchOptions.deliveryMode = .fastFormat // delivery mode
```


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SFImagePicker is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SFImagePicker'
```

## Author

saafaaari, 111dltldnjs@gmail.com

## License

SFImagePicker is available under the MIT license. See the LICENSE file for more info.

## Simulator

| Main | Detail |
|--|--|
|<img src="https://github.com/Siwon-L/SFImagePicker/assets/91936941/3d369f67-f0c6-45b6-9a8f-074c148b133e" width="200">|<img src="https://github.com/Siwon-L/SFImagePicker/assets/91936941/75049b40-5e94-4df0-9f53-bd1176cfd108" width="200">|
