//
//  IYSlideView.swift
//  slideviewpod
//
//  Created by Ilnur Yagudin on 28.09.16.
//  Copyright © 2016 Sendl. All rights reserved.
//

import Foundation
import UIKit

//MARK: Protocols for sending events in parent View Controller
@objc public protocol IYSlideViewProtocols: NSObjectProtocol {
	
	///Calling when slide view is completely opened on full size. NOT Required.
	@objc optional func slideViewDidOpen()
	
	///Calling when slide view is completely closed to his initial size. NOT Required.
    @objc optional func slideViewDidClosed()
	
	///Calling when slide view is prepared to expand and animation of expanding begin. NOT Required.
    @objc optional func slideViewWillOpen()
	
	///Calling when slide view is prepared to collapse his initial size and animation of closing begin. NOT Required.
    @objc optional func slideViewWillClosed()
	
	///Calling when user make tap on dragging button if button exist. NOT Required.
	@objc optional func slideViewDragButtonTouched(sender: UIView)
	
	///REQUIRED. Implement this protocol to showing your own content in slide view.
    func slideViewPresentViewController(_ containerView: UIView)
}

//MARK: Settings struct for slider view with different parameters
///Settings structure for customization slider view. Required only gragging direction.
public struct IYViewSettings {
     public var animationSpeed: Double = 0.55
     public var delay: Double = 0
     public var damping: CGFloat = 0.75
     public var initialVelocity: CGFloat = 0.25
     public var animationOptions: UIViewAnimationOptions = [UIViewAnimationOptions.curveEaseIn]
     public var paddingLeft: CGFloat = 16
     public var paddingRight: CGFloat = 16
	 public var paddingBottom: CGFloat = 16
     public var paddingTop: CGFloat = 16
	 public var dragDirection: IYSlideDirection?
     public var dragDistance: CGFloat = 80
}

public enum IYSlideDirection {
    case up
    case down
    case left
    case right
}
///Enum instead bool flag may be useful for adding custom view states, example: currentExpanding state
private enum IYSlideState {
    case expanded
    case closed
}

//MARK: beginning implementation
open class IYSlideView: UIView {
    
    //Public variables
	open var delegate: IYSlideViewProtocols? {
		didSet {
			guard let container = controllerContainer else {
				print("IYSliderView: Container not initialized")
				return
			}
			delegate?.slideViewPresentViewController(container)
			container.alpha = 0
			addContainerConstraints()
		}
	}
    open var settings: IYViewSettings = IYViewSettings()
    
    //Private variables. Don't change this vars externally
    @IBOutlet private weak var dragButton: UIButton?
    @IBOutlet private weak var width: NSLayoutConstraint!
    @IBOutlet private weak var height: NSLayoutConstraint!
    private var dragRecognizer: UIPanGestureRecognizer!
    private var controllerContainer: UIView?
    private var viewState: IYSlideState = IYSlideState.closed
    private var parentViewHeight: CGFloat = UIScreen.main.bounds.height
    private var parentViewWidth: CGFloat = UIScreen.main.bounds.width
    private var maxExpandingHeight: CGFloat = UIScreen.main.bounds.height
    private var maxExpandingWidth: CGFloat = UIScreen.main.bounds.width
    private var sliderViewInitialHeight: CGFloat?
    private var slideViewInitialWidth: CGFloat?
    
    //MARK: Initialization
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        initControllerContainer()
        initDragGesture()
        sliderViewInitialHeight = height.constant
        slideViewInitialWidth = width.constant
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        if let parentView = superview {
            parentViewHeight = parentView.bounds.height
            parentViewWidth = parentView.bounds.width
        }
        guard let dragDirection = settings.dragDirection else {
            print("IYSliderView: You must set dragging direction first!")
            return
        }
        switch dragDirection {
        case .up:
            maxExpandingHeight = parentViewHeight - (parentViewHeight - frame.maxY) - settings.paddingTop
            maxExpandingWidth = parentViewWidth - (settings.paddingLeft + settings.paddingRight)
        case .down:
            maxExpandingHeight = parentViewHeight  - frame.minY - settings.paddingBottom
            maxExpandingWidth = parentViewWidth - (settings.paddingLeft + settings.paddingRight)
        case .left:
            maxExpandingHeight = parentViewHeight - settings.paddingTop - settings.paddingBottom
            maxExpandingWidth = parentViewWidth - (parentViewWidth - frame.maxX) - settings.paddingLeft
        case .right:
            maxExpandingHeight = parentViewHeight - (settings.paddingTop + settings.paddingBottom)
            maxExpandingWidth = parentViewWidth - settings.paddingRight - frame.minX
        }
    }
    
    private func initControllerContainer() {
        //init container
        controllerContainer = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.frame.width, height: self.frame.height)))
        controllerContainer?.backgroundColor = UIColor.black
		
        //checking that's everything is ok
        guard let controllerContainer = controllerContainer else {
            print("IYSliderView: Can't initialize controller container in view")
            return
        }
        
        addSubview(controllerContainer)
    }
	
	//setup and add constraints for container
	private func addContainerConstraints() {
		guard let controllerContainer = controllerContainer else {
			print("IYSliderView: Can't initialize controller container in view")
			return
		}
		guard let dragDirection = settings.dragDirection else {
			print("IYSliderView: Drag direction is not setted. Set direction first!")
			return
		}
		var horizontalFormat: String?
		var verticalFormat: String?
		var fitHorizontalToSuperviewConstraint: [NSLayoutConstraint]?
		var fitVerticalToSuperviewConstraint: [NSLayoutConstraint]?
		var views: [String: AnyObject]?
		
		if let dragButton = self.dragButton {
			views = ["controllerContainer":controllerContainer, "dragButton": dragButton]
			switch dragDirection {
			case .down:
				horizontalFormat = "H:|-0-[controllerContainer]-0-|"
				verticalFormat = "V:|-0-[controllerContainer]-0-[dragButton]"
			case .up:
				horizontalFormat = "H:|-0-[controllerContainer]-0-|"
				verticalFormat = "V:[dragButton]-0-[controllerContainer]-0-|"
			case .left:
				horizontalFormat = "H:[dragButton]-0-[controllerContainer]-0-|"
				verticalFormat = "V:|-0-[controllerContainer]-0-|"
			case .right:
				horizontalFormat = "H:|-0-[controllerContainer]-0-[dragButton]"
				verticalFormat = "V:|-0-[controllerContainer]-0-|"
			}
		} else {
			views = ["controllerContainer":controllerContainer]
			horizontalFormat = "H:|-0-[controllerContainer]-0-|"
			verticalFormat = "V:|-0-[controllerContainer]-0-|"
		}
		
		controllerContainer.translatesAutoresizingMaskIntoConstraints = false
		
		var allConstraints = [NSLayoutConstraint]()
		guard let horizontalConstraints = horizontalFormat else {
			print("IYSliderView: Can't setup horizontal container constraints")
			return
		}
		guard let verticalConstraints = verticalFormat else {
			print("IYSliderView: Can't setup vertical container constraints")
			return
		}
		guard let viewsForConstraints = views else {
			print("IYSliderView: Can't use views to add constraints")
			return
		}
		
		fitHorizontalToSuperviewConstraint = NSLayoutConstraint.constraints(withVisualFormat: horizontalConstraints, options: NSLayoutFormatOptions(), metrics: nil, views: viewsForConstraints)
		fitVerticalToSuperviewConstraint = NSLayoutConstraint.constraints(withVisualFormat: verticalConstraints, options: NSLayoutFormatOptions(), metrics: nil, views: viewsForConstraints)
		
		guard let initedHorizontalConstraints = fitHorizontalToSuperviewConstraint else {
			print("IYSliderView: Can't init horizontal constraints")
			return
		}
		guard let initedVerticalConstraints = fitVerticalToSuperviewConstraint else {
			print("IYSliderView: Can't init vertical constraints")
			return
		}
		
		allConstraints += initedHorizontalConstraints
		allConstraints += initedVerticalConstraints
		
		//enable const
		NSLayoutConstraint.activate(allConstraints)
	}
	
    private func initDragGesture() {
        dragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(sender:)))
        addGestureRecognizer(dragRecognizer)
		if let dragButton = dragButton {
			dragButton.addTarget(self, action: #selector(dragButtonTouch(sender:)), for: .touchUpInside)
		}
    }
    
    //MARK: Dragging gesture handler
    @objc private func handleDrag(sender: UIPanGestureRecognizer) {
        
        guard let parentView = superview else {
            print("IYSliderView: Can't get access to superview")
            return
        }
        guard let viewInitialWidth = slideViewInitialWidth else {
            print("IYSliderView: Can't calculate slider initial width. Maybe you forget add Width constraint?")
            return
        }
        guard let viewInitialHeight = sliderViewInitialHeight else {
            print("IYSliderView: Can't calculate slider initial height. Maybe you forget add Height constraint?")
            return
        }
        guard let dragDirection = settings.dragDirection else {
            print("IYSliderView: You must set drag direction first!")
            return
        }
        
        let translation = sender.translation(in: parentView)
        let currentTranslationValue = getValue(forDirection: dragDirection, inTranslation: translation)
        switch sender.state {
        case .changed:
            switch viewState {
            case .closed:
                if currentTranslationValue > 0 {
                    width.constant = viewInitialWidth + abs(currentTranslationValue)
                    height.constant = viewInitialHeight + abs(currentTranslationValue)
                    if currentTranslationValue > settings.dragDistance {
                        delegate?.slideViewWillOpen?()
                        sender.isEnabled = false
                        expandView(animated: true)
                    }
                }
            case .expanded:
                if currentTranslationValue < 0 {
                    height.constant = maxExpandingHeight - abs(currentTranslationValue)
                    width.constant = maxExpandingWidth - abs(currentTranslationValue)
                    if abs(currentTranslationValue) > settings.dragDistance {
                        delegate?.slideViewWillClosed?()
                        sender.isEnabled = false
                        collapseView(animated: true)
                    }
                }
            }
        case .ended:
            switch viewState {
            case .closed:
                if currentTranslationValue < settings.dragDistance  {
                    sender.isEnabled = false
                    collapseToStartedForm(animated: true)
                }
            case .expanded:
                if currentTranslationValue < settings.dragDistance {
                    sender.isEnabled = false
                    expandToStartedForm(animated: true)
                }
            }
        default: break
        }
    }
    
    private func getValue(forDirection: IYSlideDirection, inTranslation: CGPoint) -> CGFloat{
        switch forDirection {
        case .down:
            return inTranslation.y
        case .up:
            return -inTranslation.y
        case .right:
            return inTranslation.x
        case .left:
            return -inTranslation.x
        }
    }
	
	//Handle drag button touch, if drag button exist
	@objc private func dragButtonTouch(sender: UIButton) {
		if dragButton != nil {
			delegate?.slideViewDragButtonTouched?(sender: self)
		}
	}
    
    //MARK: Animation methods.
    /*
     For a better customization, these methods I wrote separately to have had the opportunity to change anything on each type of animation.
     */
    
    //method, for when slider view expanding on full size
    private func expandView(animated: Bool) {
        guard let parentView = superview else {
            print("IYSliderView: Can't get access to superview")
            return
        }
        
        height.constant = maxExpandingHeight
        width.constant = maxExpandingWidth
        if animated {
            UIView.animate(withDuration: settings.animationSpeed, delay: settings.delay, usingSpringWithDamping: settings.damping, initialSpringVelocity: settings.initialVelocity, options: settings.animationOptions, animations: {
                parentView.layoutIfNeeded()
				self.controllerContainer?.alpha = 1
            }) { (completed) in
                if completed {
                    self.viewState = .expanded
                    self.dragRecognizer.isEnabled = true
                    self.delegate?.slideViewDidOpen?()
                }
            }
        } else {
            parentView.layoutIfNeeded()
            viewState = .expanded
            dragRecognizer.isEnabled = true
            delegate?.slideViewDidOpen?()
			self.controllerContainer?.alpha = 1
        }
    }
    
    //method, for when slider view collapsing to inital size
    private func collapseView(animated: Bool) {
        guard let parentView = superview else {
            print("IYSliderView: Can't get access to superview")
            return
        }
        guard let viewInitialWidth = slideViewInitialWidth else {
            print("IYSliderView: Can't calculate slider view initial width. Maybe you forget add Width constraint?")
            return
        }
        guard let viewInitialHeight = sliderViewInitialHeight else {
            print("IYSliderView: Can't calculate slider view initial height. Maybe you forget add Height constraint?")
            return
        }
        height.constant = viewInitialHeight
        width.constant = viewInitialWidth
        if animated {
            UIView.animate(withDuration: settings.animationSpeed, delay: settings.delay, usingSpringWithDamping: settings.damping, initialSpringVelocity: settings.initialVelocity, options: settings.animationOptions, animations: {
                parentView.layoutIfNeeded()
				self.controllerContainer?.alpha = 0
            }) { (completed) in
                if completed {
                    self.viewState = .closed
                    self.dragRecognizer.isEnabled = true
                    self.delegate?.slideViewDidClosed?()
                }
            }
        } else {
            parentView.layoutIfNeeded()
            viewState = .closed
            dragRecognizer.isEnabled = true
            delegate?.slideViewDidClosed?()
			controllerContainer?.alpha = 0
        }
    }
    
    //this method calling when user start to drag view from NOT EXPANDED state, but release finger earlier than need and view starts to
    //collapse in his initial state
    private func collapseToStartedForm(animated: Bool) {
        guard let parentView = superview else {
            print("IYSliderView: Can't get access to superview")
            return
        }
        guard let viewInitialWidth = slideViewInitialWidth else {
            print("IYSliderView: Can't calculate slider view initial width. Maybe you forget add Width constraint?")
            return
        }
        guard let viewInitialHeight = sliderViewInitialHeight else {
            print("IYSliderView: Can't calculate slider view initial height. Maybe you forget add Height constraint?")
            return
        }
        
        height.constant = viewInitialHeight
        width.constant = viewInitialWidth
        if animated {
            UIView.animate(withDuration: settings.animationSpeed, delay: settings.delay, usingSpringWithDamping: settings.damping, initialSpringVelocity: settings.initialVelocity, options: settings.animationOptions, animations: {
                parentView.layoutIfNeeded()
            }) { (completed) in
                if completed {
                    self.dragRecognizer.isEnabled = true
                }
            }
        } else {
            parentView.layoutIfNeeded()
            self.dragRecognizer.isEnabled = true
        }
        
    }
    
    //this method calling, when user start to drag view to close him from FULLY EXPANDED state, but release finger too early and view starts to expand on full size again
    private func expandToStartedForm(animated: Bool) {
        guard let parentView = superview else {
            print("IYSliderView: Can't get access to superview")
            return
        }
        
        height.constant = maxExpandingHeight
        width.constant = maxExpandingWidth
        if animated {
            UIView.animate(withDuration: settings.animationSpeed, delay: settings.delay, usingSpringWithDamping: settings.damping, initialSpringVelocity: settings.initialVelocity, options: settings.animationOptions, animations: {
                parentView.layoutIfNeeded()
            }) { (completed) in
                if completed {
                    self.dragRecognizer.isEnabled = true
                }
            }
        } else {
            parentView.layoutIfNeeded()
            self.dragRecognizer.isEnabled = true
        }
        
    }
    
    //MARK: Public methods for working with slider view
    ///This can be useful to update size of expanded slider view, for example, when his parent view size change, or update for your custom size. WARNING: THIS METHOD INCLUDE PADDINGS
    public func updateExpandedViewSizeTo(size: CGSize, animated: Bool) {
        if case IYSlideState.expanded = viewState {
            height.constant = size.height - settings.paddingTop - settings.paddingBottom
            width.constant = size.width - settings.paddingRight - settings.paddingLeft
            guard let parentView = superview else {
                print("IYSliderView: Animated size changing is unavialable, because superview not available")
                layoutIfNeeded()
                return
            }
            if animated {
                UIView.animate(withDuration: settings.animationSpeed, delay: settings.delay, usingSpringWithDamping: settings.damping, initialSpringVelocity: settings.initialVelocity, options: settings.animationOptions, animations: {
                    parentView.layoutIfNeeded()
                })
            }
        }
    }
    ///This can be useful for updating size of closed view.
    public func updateClosedViewSizeTo(size: CGSize, animated: Bool) {
        if case IYSlideState.closed = viewState {
            height.constant = size.height
            width.constant = size.width
            guard let parentView = superview else {
                print("IYSliderView: Animated size change is unavialable, because superview is not available")
                layoutIfNeeded()
                return
            }
            if animated {
                UIView.animate(withDuration: settings.animationSpeed, delay: settings.delay, usingSpringWithDamping: settings.damping, initialSpringVelocity: settings.initialVelocity, options: settings.animationOptions, animations: {
                    parentView.layoutIfNeeded()
                })
            }
        }
    }
    ///Closing slide view with animation or not
    public func closeSlideView(animated: Bool) {
        if case IYSlideState.expanded = viewState {
            delegate?.slideViewWillClosed?()
            collapseView(animated: animated)
        }
    }
    ///Expand slide view with animation or not
    public func openSlideView(animated: Bool) {
        if case IYSlideState.closed = viewState {
            delegate?.slideViewWillOpen?()
            expandView(animated: animated)
        }
    }
    ///Return bool value TRUE if view current is closed, and FALSE if view is open
    public func isClosed() -> Bool {
        switch viewState {
        case .closed:
            return true
        case .expanded:
            return false
        }
    }
    
}
