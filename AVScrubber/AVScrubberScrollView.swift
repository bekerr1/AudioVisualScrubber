//
//  AVScrubberScrollView.swift
//  AVScrubber
//
//  Created by brendan kerr on 1/1/17.
//  Copyright © 2017 Vetch. All rights reserved.
//

import UIKit

class AVScrubberScrollView: UIScrollView {

    
    
    override init(frame: CGRect) {
        print("CustomScrollInit")
        super.init(frame: frame)
        showsHorizontalScrollIndicator = false
        bounces = false
        backgroundColor = UIColor.cyan
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
