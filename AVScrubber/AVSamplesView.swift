//
//  AVSamplesView.swift
//  AVScrubber
//
//  Created by brendan kerr on 1/1/17.
//  Copyright © 2017 Vetch. All rights reserved.
//

import UIKit

class AVSamplesView: UIView {
    
    //Width of each sample
    let sizePerSample: CGFloat = 1.0
    let referenceFrame: CGRect
    
    init(withSamples s: [Float], referenceFrame f: CGRect) {
        print("SampleView init")
        referenceFrame = f
        let frameWidth = CGFloat(s.count) * sizePerSample
        let frame = CGRect(x: f.origin.x, y: f.origin.y, width: frameWidth, height: f.height)
        super.init(frame: frame)
        
    }
    
    override func draw(_ rect: CGRect) {
        //Drawing
        print("SampleView Draw")
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func adjustFrameToFit(totalAudioTracks t: Int) {
        
        setNeedsDisplay()
    }


}










