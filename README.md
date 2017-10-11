# XUI

[![CI Status](http://img.shields.io/travis/Lessica/XUI.svg?style=flat)](https://travis-ci.org/Lessica/XUI)
[![Version](https://img.shields.io/cocoapods/v/XUI.svg?style=flat)](http://cocoapods.org/pods/XUI)
[![License](https://img.shields.io/cocoapods/l/XUI.svg?style=flat)](http://cocoapods.org/pods/XUI)
[![Platform](https://img.shields.io/cocoapods/p/XUI.svg?style=flat)](http://cocoapods.org/pods/XUI)

Want to make a configuration UITableView in 5 minutes? Let's do it!

XUI is a drop-in replacement for "[Settings Application Schema](https://developer.apple.com/library/content/documentation/PreferenceSettings/Conceptual/SettingsApplicationSchemaReference/Introduction/Introduction.html#//apple_ref/doc/uid/TP40007005-SW1)" on iOS. It allows application to show preferences view controller by creating a simple configuration bundle (much like "Settings.bundle").

XUI also provides more components than private framework "[Preferences.framework](http://iphonedevwiki.net/index.php/Preferences.framework)" and "[Settings Application Schema](https://developer.apple.com/library/content/documentation/PreferenceSettings/Conceptual/SettingsApplicationSchemaReference/Introduction/Introduction.html#//apple_ref/doc/uid/TP40007005-SW1)":

- Group
- Link (Child Pane)
- Switch
- Button (Action)
- TextField / SecureTextField
- Radio / Checkbox Group
- Segment Group
- Single Selection Option List
- Multiple Selection Option List
- Ordered Multiple Selection Option List
- Slider
- Stepper
- DateTime Picker
- TitleValue
- StaticText
- Textarea
- Image
- File Selector

Sorry for the inconvenience, but there's no English reference for now. I recommend you use \"Google Translate\" on the page below.

See more (Simplified Chinese): https://www.zybuluo.com/xxtouch/note/716787

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

![Demo](https://raw.githubusercontent.com/Lessica/XUI/master/Design/IMG_0716.jpg)

## Requirements

- Xcode 7 or above
- Objective-C (ARC is required)
- iOS >= 7.0
- iPhone / iPad compatible.

## Installation

XUI is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'XUI', :git => "https://github.com/Lessica/XUI.git"
```

## Author

Lessica, i.82@me.com

## License

XUI is available under the MIT license. See the LICENSE file for more info.

## Related Projects

- [InAppSettings](https://github.com/kgn/InAppSettings)
- [SettingsKit](https://github.com/mlnlover11/SettingsKit)
- [LicenseGenerator-iOS](https://github.com/carloe/LicenseGenerator-iOS)
- [PrefsMate](https://github.com/caiyue1993/PrefsMate)
