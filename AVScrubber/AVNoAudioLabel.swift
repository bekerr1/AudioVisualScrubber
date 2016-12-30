//
//  AVNoAudioLabel.swift
//  AVScrubber
//
//  Created by brendan kerr on 12/26/16.
//  Copyright © 2016 Vetch. All rights reserved.
//

import UIKit

class AVNoAudioLabel: UILabel {
    
    let noAudioText: String = "No Audio Supplied!"
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.gray
        text = noAudioText
        textAlignment = .center
        lineBreakMode = .byWordWrapping
        font = UIFont(name: "System", size: 17.0)
        adjustsFontSizeToFitWidth = true
        numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
