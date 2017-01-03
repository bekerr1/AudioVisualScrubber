//
//  AVScrubberViewModel.swift
//  AVScrubber
//
//  Created by brendan kerr on 1/2/17.
//  Copyright © 2017 Vetch. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct AVScrubberViewModel {
    
    //Models
    
    //ViewModel Stuff
    var scrubberShape: ScrubberShape = .rounded
    var scrubberColor: ScrubberColor = .defaultWhite
    let realSeconds = 5
    var scrubberScreenPts: CGFloat?
    //Variables
    var headerIsVisible: Variable<Bool>
    var scrubberOffsetAmount: Variable<UIEdgeInsets>
    //Didset Reactions
    var scrubberOffset: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            scrubberOffsetAmount.value = scrubberOffset
        }
    }
    
    init() {
        scrubberOffsetAmount = Variable(UIEdgeInsets.zero)
        headerIsVisible = Variable(false)
    }
    
    func processAudioFile(at url: URL?) -> [Float]? {
        
//        //Simplified version of below, is short and sweet but bad for debugging
//        guard let goodAudio = url, FileManager.default.fileExists(atPath: goodAudio.path), let audioData = AVSampleProcessingModel(screenPts: scrubberScreenPts!, realSeconds: realSeconds, audioSource: goodAudio) else {
//            print("Some condition above wasnt met")
//            return nil
//        }
//        
//        return audioData.processedData
//        
        
        if let goodAudio = url {
            if FileManager.default.fileExists(atPath: goodAudio.path) {
                print("File exists, try to process it!")
                if let audioData = AVSampleProcessingModel(screenPts: scrubberScreenPts!, realSeconds: realSeconds, audioSource: goodAudio) {
                    return audioData.processedData
                } else {
                    print("ProcessingModel Init Returned Nil")
                    return nil
                }
            } else {
                print("File was found to not exist at given path.")
                return nil
            }
        } else {
            fatalError("Bad url - development specific fatal error.")
        }
        return nil
    }
    
    
    
}



struct AVSampleProcessingViewModel {
    
    var audioCount = 0
    var audioFiles: [URL] = []
}
