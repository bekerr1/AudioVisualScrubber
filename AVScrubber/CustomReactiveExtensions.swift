//
//  CustomReactiveExtensions.swift
//  AVScrubber
//
//  Created by brendan kerr on 1/2/17.
//  Copyright © 2017 Vetch. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {
    
    //Include the contentInset property of scrollview.  Dont mind if delegate proxy isnt involved, this is only for when user wants to change the inset of the scrubber and to mess with Custom Reactive extensions.
    public var contentInset: AnyObserver<UIEdgeInsets> {
        return UIBindingObserver(UIElement: self.base) { scrollView, inset in
            scrollView.contentInset = inset
        }.asObserver()
    }
}


extension AVScrubberScrollView {
    
    public var rx_inset: AnyObserver<UIEdgeInsets> {
        return UIBindingObserver(UIElement: self) { avScrollView, inset in
            avScrollView.contentInset = inset
            avScrollView.contentOffset = CGPoint(x: -avScrollView.contentInset.left, y: 0.0)
        }.asObserver()
    }
}

