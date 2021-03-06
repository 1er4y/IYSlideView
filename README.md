# IYSlideView

[![CI Status](http://img.shields.io/travis/Ильнур Ягудин/IYSlideView.svg?style=flat)](https://travis-ci.org/Ильнур Ягудин/IYSlideView)
[![Version](https://img.shields.io/cocoapods/v/IYSlideView.svg?style=flat)](http://cocoapods.org/pods/IYSlideView)
[![License](https://img.shields.io/cocoapods/l/IYSlideView.svg?style=flat)](http://cocoapods.org/pods/IYSlideView)
[![Platform](https://img.shields.io/cocoapods/p/IYSlideView.svg?style=flat)](http://cocoapods.org/pods/IYSlideView)

## What this pod can do?
 
![](http://i.giphy.com/FfkIYzYcv7M2c.gif) ![](http://i.giphy.com/cmrQxYRSW0Bu8.gif) ![](http://i.giphy.com/V3liUqUjaVukU.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
In example project, you will see fife examples with different gestures. 

## Requirements
* iOS 9.1 and higher
* Swift 3
* Xcode 8.0 

## Installation
Installation in 2 parts: Setup in Storyboard and Setup in Code

1. **Part - Setup in Storyboard:**

	1.1. Open your `Storyboard` file, select your controller and drag&drop empty `UIView`. This view will be your slider view.
	
	![](http://i.giphy.com/10370MRqROnTCE.gif) 
	
	1.2. If you want, drag&drop in your slider view `Button`. In this instruction, we will use Button.
	
	![](http://i.giphy.com/hMFLej7VsD9WE.gif)
	
	1.3. Select your created View and in `Interface Builder`, click on `Identity Inspector` tab and in fields `Custom Class` and `Module` type `IYSlideView`
	
	![](http://i.giphy.com/v6vp7mQs9vW48.gif)
	
	1.4. After that, add to your empty view constraints:	`Horizontal in container`, `Space from Top`, and `Width` with `Height`
	
	![](http://i.giphy.com/tSui6Mcl0136E.gif)
	
	1.5. Click on `Connections Inspector` tab, you will see three outlets: `dragButtom`, `height`, `width`. Connect them to constraints of slider view and button. 
	
	![](http://i.giphy.com/ARweKXwXcDRXW.gif)

2. **Part - Setup in code:**

	2.1. Open your `View Controller` class and add following line in imports 
	```swift
	import IYSlideView
	```

	2.2. Now, you need implement `IYSlideViewProtocols`. For do that, add:
	```swift
	class <nameOfYourVc>: UIViewController, IYSlideViewProtocols {
	....
	}
	```

	2.3. Then, you need implement minimum one required protocol method:
	```swift
	func slideViewPresentViewController(_ containerView: UIView) {
	}
	```

	2.4. Add following line in your `View Controller` to create `Outlet` with slider view and **connect them from 	`Storyboard`.**:
	```swift
	@IBOutlet weak var sliderView: IYSlideView!
	```
	
	2.5. In method `viewDidLoad` in your VC add this lines:
	```swift
	sliderView.settings.dragDirection = .down //Drag direction is required
	sliderView.delegate = self //required
	```

	2.6. Finally, add this lines in `slideViewPresentViewController` method (this method we implemented earlier):
	```swift 
	let controller = self.storyboard?.instantiateViewController(withIdentifier: "	<PresentingViewControllerStoryboardID>")
	self.addChildViewController(controller!)
	controller?.view.frame = containerView.bounds
	containerView.addSubview(controller!.view)
	self.didMove(toParentViewController: self)
	```
Note: Replace `PresentingViewControllerStoryboardID` with `StoryboardID` of `View Controller` that you want present in slider view.

## Result
![](http://i.giphy.com/MpkqTEpss2vkY.gif)

## Cocoa Pods

IYSlideView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "IYSlideView"
```

## Additional Info

For more examples, please clone repo Example and open in Xcode. You will see 5 different examples. 


## Author

Ilnur Yagudin, 1er4yy@gmail.com

## License

IYSlideView is available under the MIT license. See the LICENSE file for more info.
