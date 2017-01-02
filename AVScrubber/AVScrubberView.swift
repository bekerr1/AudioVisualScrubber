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

enum ScrubberColorOption: Int {
    case red
    case blue
}

///Options to pass the scrubber view to customize the look of the strubber.

enum ScrubberColor {
    ///Sets the scrubber to these colors
    case customColorSet(ScrubberColorOption, ScrubberColorOption, ScrubberColorOption, ScrubberColorOption)
    case defaultWhite
    case defaultGrey
    
}

enum ScrubberShape {
    case square
    case rounded
}


class AVScrubberView: UIView {
    
    //var scrubberModel: AVScrubberModel!
    let scrubberScrollView: AVScrubberScrollView!
    let noAudioLabel: AVNoAudioLabel!
    var audioCount = 0
    var scrubberShape: ScrubberShape = .rounded
    var scrubberColor: ScrubberColor = .defaultWhite
    var audioFiles: [URL] = []
    var sampleViews: [AVSamplesView] = []
    var baseSubviewFrame: CGRect
    
    let realSeconds = 15
    lazy var scrubberScreenPts: CGFloat = {
        return self.frame.size.width/2
    }()

    
    init(frame f: CGRect, scrollOrientation or: ScrollOrientation = .middle, audioFileURLs urls: URL...) {
        
        baseSubviewFrame = CGRect(x: 0, y: 0, width: f.width, height: f.height)
        scrubberScrollView = AVScrubberScrollView(frame: baseSubviewFrame)
        noAudioLabel = AVNoAudioLabel(frame: CGRect(x: 0, y: 0, width: f.width + 300, height: f.height))
        
        super.init(frame: f)
        
        orientScrollView(or)
        
        
        for url in urls {
            if FileManager.default.fileExists(atPath: url.path) {
                print("File Exists, try to prcess.")
                if let validSampView = createSamplesView(from: url) {
                    sampleViews.append(validSampView)
                }
            } else {
                print("File was found to not exist at given path.")
            }
        }
        if sampleViews.isEmpty {
            print("Could not obtain any sample views from given data")
            addSubview(noAudioLabel)
        }
        insertSubview(scrubberScrollView, belowSubview: noAudioLabel)
        finalAdjustments()
        backgroundColor = UIColor.blue
        
        //scrubberScrollView.contentSize = CGRect(x: 0, y: 0, width: f.width + 300, height: f.height).size
        //scrubberScrollView.addSubview(noAudioLabel)
        //scrubberScrollView.zoomScale = 0.5
    }
    

    init(frame f: CGRect, scrollOrientation or: ScrollOrientation = .middle, audioFileURL url: URL?) {
        
        baseSubviewFrame = CGRect(x: 0, y: 0, width: f.width, height: f.height)
        scrubberScrollView = AVScrubberScrollView(frame: baseSubviewFrame)
        noAudioLabel = AVNoAudioLabel(frame: CGRect(x: 0, y: 0, width: f.width + 300, height: f.height))
        
        super.init(frame: f)
        
        orientScrollView(or)
        
        if let goodAudio = url {
            if FileManager.default.fileExists(atPath: goodAudio.path) {
                print("File exists, try to process it!")
                if let sampleView = createSamplesView(from: goodAudio) {
                    sampleViews.append(sampleView)
                }
                
            } else {
                print("File was found to not exist at given path.")
            }
        } else {
            fatalError("Bad url - development specific fatal error.")
        }
        
        if sampleViews.isEmpty {
            print("Could not obtain any sample views from given data")
            addSubview(noAudioLabel)
        }
        insertSubview(scrubberScrollView, belowSubview: noAudioLabel)
        finalAdjustments()
        backgroundColor = UIColor.blue
        
        //scrubberScrollView.contentSize = CGRect(x: 0, y: 0, width: f.width + 300, height: f.height).size
        //scrubberScrollView.addSubview(noAudioLabel)
        //scrubberScrollView.zoomScale = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func finalAdjustments() {
        for v in sampleViews {
            v.adjustFrameToFit(totalAudioTracks: sampleViews.count)
        }
    }
    
    
    func orientScrollView(_ or: ScrollOrientation) {
        switch or {
        case .standard:
            scrubberScrollView.contentInset = UIEdgeInsets.zero
        case .middle:
            scrubberScrollView.contentInset = UIEdgeInsetsMake(0.0, frame.size.width/2, 0.0, frame.size.width/2)
        case .custom(let inset):
            scrubberScrollView.contentInset = UIEdgeInsetsMake(0.0, inset, 0.0, inset)
        }
    }
    
    
    func createSamplesView(from url: URL) -> AVSamplesView? {
        
        if let audioData = AVSampleProcessingModel(screenPts: scrubberScreenPts, realSeconds: realSeconds, audioSource: url) {
            audioFiles.append(url)
            return audioData.drawSamples(using: baseSubviewFrame)
        }
        return nil
    }
}
