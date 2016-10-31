//
//  LeftToRightController.swift
//  IYSlideView
//
//  Created by Ilnur Yagudin on 31/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import IYSlideView

class LeftToRightController: UIViewController, IYSlideViewProtocols {
	
	
	@IBOutlet weak var sliderView: IYSlideView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		sliderView.settings.dragDirection = .right
		sliderView.delegate = self
		
		// Do any additional setup after loading the view.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func slideViewPresentViewController(_ containerView: UIView) {
		let controller = self.storyboard?.instantiateViewController(withIdentifier: "sliderViewPresentingController")
		self.addChildViewController(controller!)
		controller?.view.frame = containerView.bounds
		containerView.addSubview(controller!.view)
		self.didMove(toParentViewController: self)
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
