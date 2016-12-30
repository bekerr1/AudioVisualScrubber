//
//  AVScrubber.swift
//  AVScrubber
//
//  Created by brendan kerr on 12/26/16.
//  Copyright © 2016 Vetch. All rights reserved.
//


/*
 Scrubber needs to be created with a frame. The frame ends up being the size of the scroll view.  The scroll view represents the audio scrubber and the view is basically the container.
 
*/
import UIKit

enum ScrollOrientation {
    case standard
    case middle
    case custom(CGFloat)
}

enum ScrubberColor: Int {
    case red
    case blue
}

///Options to pass the scrubber view to customize the look of the strubber.

enum ScrubberOptions {
    ///Sets the scrubber to these colors
    case customColorSet(ScrubberColor, ScrubberColor, ScrubberColor, ScrubberColor)
    ///Changes the scrubber to draw square
    case square
    ///Changes the scrubber to draw rounded
    case rounded
    
}


class AVScrubberView: UIView {
    
    var scrubberModel: AVScrubberModel!
    let scrubberScrollView: UIScrollView!
    let noAudioLabel: AVNoAudioLabel!

    init(frame f: CGRect, scrollOrientation or: ScrollOrientation = .standard, audioFileURL url: URL?, scrubberOptions options: [ScrubberOptions]? = nil) {
        
        let baseSubviewFrame = CGRect(x: 0, y: 0, width: f.width, height: f.height)
        scrubberScrollView = UIScrollView(frame: baseSubviewFrame)
        noAudioLabel = AVNoAudioLabel(frame: baseSubviewFrame)
        
        super.init(frame: f)
        
        orientScrollView(or)
        scrubberModel = AVScrubberModel(screenPts: frame.size.width/2, realSeconds: 15)
        
        
        if let goodAudio = url {
            if FileManager.default.fileExists(atPath: goodAudio.path) {
                print("File exists, try to process it!")
                scrubberModel.processAudioData(goodAudio)
            } else {
                print("File was found to not exist a given path.")
                addSubview(noAudioLabel)
            }
        } else {
            fatalError("Bad url - development specific fatal error.")
        }
        insertSubview(scrubberScrollView, belowSubview: noAudioLabel)

        scrubberScrollView.backgroundColor = UIColor.cyan
        backgroundColor = UIColor.blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func orientScrollView(_ or: ScrollOrientation) {
        switch or {
        case .standard:
            scrubberScrollView.contentInset = UIEdgeInsets.zero
        case .middle:
            scrubberScrollView.contentInset = UIEdgeInsetsMake(0.0, frame.size.width/2, 0.0, 0.0)
        case .custom(let inset):
            scrubberScrollView.contentInset = UIEdgeInsetsMake(0.0, inset, 0.0, 0.0)
        }
    }
}
