# IYSlideView

[![CI Status](http://img.shields.io/travis/Ильнур Ягудин/IYSlideView.svg?style=flat)](https://travis-ci.org/Ильнур Ягудин/IYSlideView)
[![Version](https://img.shields.io/cocoapods/v/IYSlideView.svg?style=flat)](http://cocoapods.org/pods/IYSlideView)
[![License](https://img.shields.io/cocoapods/l/IYSlideView.svg?style=flat)](http://cocoapods.org/pods/IYSlideView)
[![Platform](https://img.shields.io/cocoapods/p/IYSlideView.svg?style=flat)](http://cocoapods.org/pods/IYSlideView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
In example project, you will see fife examples with different gestures. D

## Requirements
iOS 9.1 and higher
Swift 3
Xcode 8.0 

## Installation
Installation in 2 steps:

1 Step:
	1.1 Open your Storyboard file, select your controller and drag&drop empty view. This view will be your slider view.
	1.2 If you want, drag&drop in your slider view Button. In this instruction, we will use Button.
1.3. In Interface Builder, click on Identity Inspector tab and in fields Custom Class and Module type 'IYSlideView'
1.4 After that, add to your empty view constraints:	Horizontal in container, Space from Top, and Width with Height
1.5 Click on Connections Inspector tab, you will see three outlets: dragButtom, height, width. Connect them to constraints of slider view and button. 

2 Step:
2.1 Open your View Controller class and add following line in imports 
```swift
import IYSlideView
```
2.2 Now, you need implement IYSlideViewProtocols. For do that, add:
```swift
class <nameOfYourVc>: UIViewController, IYSlideViewProtocols {
....
}
```
2.3 Then, you need implement minimum one required protocol method:
```swift
func slideViewPresentViewController(_ containerView: UIView) {

}
```
2.4 Add following line in your View Controller to create Outlet with slider view:
```swift
	@IBOutlet weak var sliderView: IYSlideView!
```
and connect them from Storyboard.

Almost done.

2.5 In method viewDidLoad in your VC add this lines:
```swift
	sliderView.settings.dragDirection = .down //Drag direction is required
	sliderView.delegate = self //required
```
2.6 Finally, add this lines in slideViewPresentViewController method (this method we implemented earlier):
```swift 
	let controller = self.storyboard?.instantiateViewController(withIdentifier: "<PresentingViewControllerStoryboardID>")
	self.addChildViewController(controller!)
	controller?.view.frame = containerView.bounds
	containerView.addSubview(controller!.view)
	self.didMove(toParentViewController: self)
```
Note: Replace "PresentingViewControllerStoryboardID" with StoryboardID of View Controller that you want present in slider view.

IYSlideView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "IYSlideView"
```

## Author

Ilnur Yagudin, 1er4yy@gmail.com

## License

IYSlideView is available under the MIT license. See the LICENSE file for more info.
