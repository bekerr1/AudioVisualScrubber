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
import RxSwift
import RxCocoa


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

enum AVProcessingState {
    case waiting
    case processing
    case finished(Int)
    case Error(String)
}

class AVScrubberView: UIView {
    
    //Dispose
    var disposeBag: DisposeBag = DisposeBag()
    
    //Subviews
    var scrubberScrollView: AVScrubberScrollView!
    let noAudioLabel: AVNoAudioLabel!
    let scrubberHeaderView: AVScrubberHeaderView!
    var sampleViews: [AVSamplesView] = []
    //ViewModel
    var scrubberViewModel: AVScrubberViewModel
    //Other
    var baseSubviewFrame: CGRect
    var validAudioFiles: [URL] = []
    var audioCount: Int {
        didSet {
            addLatestSamplesView()
        }
    }
    var audioProcessingState: AVProcessingState = .waiting

    init(frame f: CGRect, scrollOrientation or: ScrollOrientation = .middle, audioFileURL url: URL?) {
        
        baseSubviewFrame = CGRect(x: 0, y: 0, width: f.width, height: f.height)
        scrubberScrollView = AVScrubberScrollView(frame: baseSubviewFrame)
        noAudioLabel = AVNoAudioLabel(frame: CGRect(x: 0, y: 0, width: f.width + 300, height: f.height))
        scrubberViewModel = AVScrubberViewModel()
        scrubberHeaderView = AVScrubberHeaderView()
        audioCount = 0
        
        super.init(frame: f)
        
        scrubberViewModel.scrubberScreenPts = frame.size.width
        addSampleView(from: url)
        scrubberScrollView.contentInset = orientScrollView(or)
        
        //Observable with Bind To used - Questionable UI qualities?
//        scrubberViewModel.scrubberOffsetAmount
//            .asObservable()            
//            .bindTo(scrubberScrollView.rx_inset)
//            .addDisposableTo(disposeBag)
        
        //Driver with Drive Used - Driver Qualities guaranteed
        scrubberViewModel.headerIsVisible
            .asDriver()
            .drive(scrubberHeaderView.rx.isHidden)
            .addDisposableTo(disposeBag)
        
        addSubview(scrubberScrollView)
        //finalAdjustments()
        backgroundColor = UIColor.blue
        
        //scrubberScrollView.contentSize = CGRect(x: 0, y: 0, width: f.width + 300, height: f.height).size
        //scrubberScrollView.addSubview(noAudioLabel)
        //scrubberScrollView.zoomScale = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeScrubberOrientation(to or: ScrollOrientation) {
        scrubberViewModel.scrubberOffset = orientScrollView(or)
    }
    
    fileprivate func orientScrollView(_ or: ScrollOrientation) -> UIEdgeInsets {
        switch or {
        case .standard:
            return UIEdgeInsets.zero
        case .middle:
            return UIEdgeInsetsMake(0.0, frame.size.width/2, 0.0, frame.size.width/2)
        case .custom(let inset):
            return UIEdgeInsetsMake(0.0, inset, 0.0, inset)
        }
    }
    
    
//    func finalAdjustments() {
//        for v in sampleViews {
//            v.adjustFrameToFit(totalAudioTracks: sampleViews.count)
//        }
//    }
    
    func addSampleView(from url: URL?) {
        createSamplesView(from: url)
        
    }
    
    func createSamplesView(from url: URL?) {
        
        if let processedSamples = scrubberViewModel.processAudioFile(at: url) {
            validAudioFiles.append(url!)
            let newSampleView = AVSamplesView(withSamples: processedSamples, referenceFrame: baseSubviewFrame)
            print(newSampleView.frame)
            scrubberScrollView.contentSize = newSampleView.frame.size
            sampleViews.append(newSampleView)
            //finished processing successful here
        } else {
            //let e_mesg = "No Audio Samples Available."
            //let newSampleView = AVSamplesView(withErrorMsg: e_msg)
            print("Couldnt create samples from URL")
            //Finished processing error here
        }
        audioCount += 1
    }
    
    func addLatestSamplesView() {
        print("Should add new sampleview to scrollview as subview")
        scrubberScrollView.addSubview(sampleViews.last!)
    }
    
    func createBatchSamplesView(from urls: [URL]) {
        print("Should be used when creating scrubber with multiple sample views")
    }
}




//    init(frame f: CGRect, scrollOrientation or: ScrollOrientation = .middle, audioFileURLs urls: URL...) {
//
//        baseSubviewFrame = CGRect(x: 0, y: 0, width: f.width, height: f.height)
//        scrubberScrollView = AVScrubberScrollView(frame: baseSubviewFrame)
//        noAudioLabel = AVNoAudioLabel(frame: CGRect(x: 0, y: 0, width: f.width + 300, height: f.height))
//        scrubberViewModel = AVScrubberViewModel()
//        scrubberHeaderView = AVScrubberHeaderView()
//
//
//        super.init(frame: f)
//
//        //orientScrollView(or)
//
//        for url in urls {
//            if FileManager.default.fileExists(atPath: url.path) {
//                print("File Exists, try to prcess.")
////                if let validSampView = createSamplesView(from: url) {
////                    sampleViews.append(validSampView)
////                }
//            } else {
//                print("File was found to not exist at given path.")
//            }
//        }
//        if sampleViews.isEmpty {
//            print("Could not obtain any sample views from given data")
//            addSubview(noAudioLabel)
//        }
//        insertSubview(scrubberScrollView, belowSubview: noAudioLabel)
//        finalAdjustments()
//        backgroundColor = UIColor.blue
//
//        //scrubberScrollView.contentSize = CGRect(x: 0, y: 0, width: f.width + 300, height: f.height).size
//        //scrubberScrollView.addSubview(noAudioLabel)
//        //scrubberScrollView.zoomScale = 0.5
//    }

