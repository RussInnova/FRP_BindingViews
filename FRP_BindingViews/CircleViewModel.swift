//
//  CircleViewModel.swift
//  FRP_BindingViews
//
//  Created by Keith Russell on 6/21/16.
//  Copyright © 2016 Keith Russell. All rights reserved.
//

import ChameleonFramework
import Foundation
import RxSwift
import RxCocoa

class CircleViewModel {
    
    var centerVariable = Variable<CGPoint?>(CGPointZero) // Create one variable that will be changed and observed
    var backgroundColorObservable: Observable<UIColor>! // Create observable that will change backgroundColor based on center
    
    init() {
        setup()
    }
    
    func setup () {
        //when we get a new center emit a new color
        backgroundColorObservable = centerVariable.asObservable()
            .map { center in
                guard let center = center else { return UIColor.flatten(UIColor.blackColor())()}
                let red: CGFloat = ((center.x + center.y) % 255.0) / 255.0 // We just manipulate red, but you can do w/e
                let green: CGFloat = 0.0
                let blue: CGFloat = 0.0
                
                return UIColor.flatten(UIColor(red: red, green: green, blue: blue, alpha: 1.0))()
        }
    }
    
    
}