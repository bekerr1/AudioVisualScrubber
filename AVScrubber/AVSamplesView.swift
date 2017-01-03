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
    let sizePerSample: CGFloat = 2.0
    let sizeBetweenSamples: CGFloat = 3.0
    let referenceFrame: CGRect
    let samplesToGraph: [Float]
    
    init(withSamples s: [Float], referenceFrame f: CGRect) {
        print("SampleView init")
        referenceFrame = f
        samplesToGraph = s
        let frameWidth = CGFloat(s.count) * sizePerSample
        let frame = CGRect(x: f.origin.x, y: f.origin.y, width: frameWidth, height: f.height)
        super.init(frame: frame)
        backgroundColor = UIColor.black
        
    }
    
    override func draw(_ rect: CGRect) {
        //Drawing
        print("SampleView Draw")
        let ctx = UIGraphicsGetCurrentContext()
        let halfHeight = frame.size.height/2
        var currentX: CGFloat = 0.0
        
        ctx?.setAllowsAntialiasing(true)
        ctx?.setShouldAntialias(true)
        ctx?.setStrokeColor(UIColor.lightGray.cgColor)
        ctx?.setLineCap(CGLineCap.round)
        ctx?.setLineWidth(sizePerSample)
        ctx?.move(to: CGPoint(x: currentX, y: halfHeight))
        
        let largestSample = samplesToGraph.sorted().last!
        
        for sample in samplesToGraph {
            let sampleRatio = sample / largestSample
            let drawHeight = halfHeight - (CGFloat(sampleRatio) * halfHeight)
            ctx?.addLine(to: CGPoint(x: currentX, y: drawHeight))
            
            currentX += sizeBetweenSamples
            ctx?.move(to: CGPoint(x: currentX, y: halfHeight))
        }
        
        ctx?.strokePath()
    }
    
    func drawTopChannel(using sample: Float) {
        
    }
    
    func drawBottomChannel(using sample: Float) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func adjustFrameToFit(totalAudioTracks t: Int) {
        
        setNeedsDisplay()
    }


}










