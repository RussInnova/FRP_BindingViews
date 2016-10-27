//
//  ViewController.swift
//  FRP_BindingViews
//
//  Created by Keith Russell on 6/21/16.
//  Copyright © 2016 Keith Russell. All rights reserved.
//
import ChameleonFramework
import UIKit
import RxSwift
import RxCocoa

@IBDesignable

class ViewController: UIViewController {
    
    var circleView: UIView!
    private var circleViewModel: CircleViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        // Add circle view
        circleView = UIView(frame: CGRect(origin: view.center, size: CGSize(width: 100.0, height: 100.0)))
        circleView.layer.cornerRadius = circleView.frame.width / 2.0
        circleView.center = view.center
        circleView.backgroundColor = UIColor.greenColor()
        view.addSubview(circleView)
        
        circleViewModel = CircleViewModel()
        // Bind the center point of the CircleView to the centerObservable
        circleView
            .rx_observe(CGPoint.self, "center")
            .bindTo(circleViewModel.centerVariable)
            .addDisposableTo(disposeBag)
        
        // Subscribe to backgroundObservable to get new colors from the ViewModel.
        circleViewModel.backgroundColorObservable
            .subscribeNext { [weak self] (backgroundColor) in
                UIView.animateWithDuration(0.1) {
                    self?.circleView.backgroundColor = backgroundColor
                    // Try to get complementary color for given background color
                    let viewBackgroundColor = UIColor.init(complementaryFlatColorOf: backgroundColor, withAlpha: 1.0)
                    // If it is different that the color
                    if viewBackgroundColor != backgroundColor {
                        // Assign it as a background color of the view
                        // We only want different color to be able to see that circle in a view
                        self?.view.backgroundColor = viewBackgroundColor
                    }
                }
            }
            .addDisposableTo(disposeBag)
    
        
        // Add gesture recognizer
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.circleMoved(_:)))
        circleView.addGestureRecognizer(gestureRecognizer)
    }
    
 
    
    func circleMoved (recogniser: UIPanGestureRecognizer)  {
        let location = recogniser.locationInView(view)
        UIView.animateWithDuration(0.1){
            self.circleView.center = location
        }
    }

}

