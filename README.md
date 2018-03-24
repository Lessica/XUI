# XUI

[![CI Status](http://img.shields.io/travis/Lessica/XUI.svg?style=flat)](https://travis-ci.org/Lessica/XUI)
[![Version](https://img.shields.io/cocoapods/v/XUI.svg?style=flat)](http://cocoapods.org/pods/XUI)
[![License](https://img.shields.io/cocoapods/l/XUI.svg?style=flat)](http://cocoapods.org/pods/XUI)
[![Platform](https://img.shields.io/cocoapods/p/XUI.svg?style=flat)](http://cocoapods.org/pods/XUI)

<p align="center">
<img src="https://raw.githubusercontent.com/Lessica/XUI/master/Design/XUIAboutIcon.png" width="160"/><br />
</p>

Make a configuration UITableView in 5 minutes? Let's do it!

XUI is a **drop-in replacement** for "[Settings Application Schema](https://developer.apple.com/library/content/documentation/PreferenceSettings/Conceptual/SettingsApplicationSchemaReference/Introduction/Introduction.html#//apple_ref/doc/uid/TP40007005-SW1)" on iOS/tvOS. It allows application to show preferences view controller by creating a simple configuration bundle (much like "Settings.bundle").

## Features

- [x] Data Persistence (NSUserDefaults / Custom Adapters)
- [x] Localized Strings / Image Resources
- [x] Custom Cells (Runtime)
- [x] Notifications

## Components

XUI provides more components than private framework "[Preferences.framework](http://iphonedevwiki.net/index.php/Preferences.framework)":

- [x] Group
- [x] Link (Child Pane)
- [x] Switch
- [x] Button (Action)
- [x] TextField
- [x] Radio / Checkbox Group
- [x] Segment Group
- [x] Single Selection Option List
- [x] Multiple Selection Option List
- [x] Ordered Multiple Selection Option List
- [x] Slider
- [x] Stepper
- [x] DateTime Picker
- [x] TitleValue
- [x] StaticText
- [x] Textarea
- [x] Image
- [x] Editable List (Strings)

## Usage

### Presentation

```objective-c
// to specify the path for Settings.bundle
NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];

// to specify the root entry for that bundle
NSString *xuiPath = [[NSBundle bundleWithPath:bundlePath] pathForResource:@"Root" ofType:@"plist"];

// present or push it!
XUIListViewController *xuiController = [[XUIListViewController alloc] initWithPath:xuiPath withBundlePath:bundlePath];
XUINavigationController *navController = [[XUINavigationController alloc] initWithRootViewController:xuiController];
[self presentViewController:navController animated:YES completion:nil];

// directly present XUI from the top most view controller
[XUIListViewController presentFromTopViewControllerWithPath:xuiPath];
```

### Read Configurations

If the key ```defaults``` is not set for any components, configuration will be saved to Standard User Defaults.

```objective-c
NSNumber *enabled = [[NSUserDefaults standardUserDefaults] objectForKey:@"enabled"];
[enabled boolValue];
```

### Notification

Receive notifications named ```XUINotificationEventValueChanged``` from ```[NSNotificationCenter defaultCenter]``` if there is any changes.

### Custom Theme

Change the theme parsed from configuration **before view is loaded**.

```objective-c
xuiController.theme.tintColor = [UIColor yourOwnColor];
```

### Adapter

Create custom adapter to read the interface schema from any format you like: *plist*, *json*, *lua*, etc. Adapter also handles **data persistence** and **notifications**.

### Logger

To know if there is any invalid part in our interface schema...

## Documentation

https://kb.xxtouch.com/XUI/

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

![Demo](https://raw.githubusercontent.com/Lessica/XUI/master/Design/IMG_0716.jpg)

## Requirements

- Xcode 7 or above
- iOS 7 or above
- Objective-C (ARC)
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

- [PrefsMate](https://github.com/caiyue1993/PrefsMate)
- [InAppSettings](https://github.com/kgn/InAppSettings)
- [SettingsKit](https://github.com/mlnlover11/SettingsKit)
- [LicenseGenerator-iOS](https://github.com/carloe/LicenseGenerator-iOS)
