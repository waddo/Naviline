# Naviline

Naviline is useful navigation stack to create path structure in your app.

[![Version](https://img.shields.io/cocoapods/v/Naviline.svg?style=flat)](https://cocoapods.org/pods/Naviline)
[![License](https://img.shields.io/cocoapods/l/Naviline.svg?style=flat)](https://cocoapods.org/pods/Naviline)
[![Platform](https://img.shields.io/cocoapods/p/Naviline.svg?style=flat)](https://cocoapods.org/pods/Naviline)

## Example

Base controller where you want to add Naviline should be NavilineController subclass.

```
class ViewController: NavilineController {

    var naviline: Naviline
    var navigationContentView: UIView

    init() {
        let configurator = NavilineConfigurator.defaultConfigurator()
        configurator.colors[.backgroundColor] = .red
        configurator.colors[.homeBackgroundColor] = .red
        configurator.colors[.selectedTextColor] = .blue
        configurator.colors[.textColor] = .white

        configurator.fonts[.boldFont] = UIFont.boldSystemFont(ofSize: 16.0)
        configurator.fonts[.regularFont] = UIFont.systemFont(ofSize: 14.0)

        configurator.height = 44.0

        self.naviline = Naviline(configurator: configurator)
        self.navigationContentView = UIView()

        super.init(nibName: nil, bundle: nil)
    }
    
    ...
    
}
```

Every content view controller should be NavilineContentController subclass. 
After initialisation call setup method to set base controller for Naviline and set home content controller.
```
    let contentController = ContentViewController(index: naviline.size, title: "Title")
    contentController.navilineController = self
    naviline.setup(with: self, homeContentController: contentController)
```
Don't forget to set frames/constraints for naviline and navigationContentView and add them as subviews. In reason of Naviline great flexibility you should do additional work to place UI components on the screen. 

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

Naviline is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Naviline'
```

## Author

Anton Rodzik

## License

Naviline is available under the MIT license. See the LICENSE file for more info.
