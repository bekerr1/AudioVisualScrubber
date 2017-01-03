//
//  AVScrubberViewModel.swift
//  AVScrubber
//
//  Created by brendan kerr on 1/2/17.
//  Copyright © 2017 Vetch. All rights reserved.
//

import Foundation
import RxSwift

class AVScrubberViewModel {
    
    var scrubberOffsetAmount: Variable<UIEdgeInsets>
    var scrubberOffset: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            scrubberOffsetAmount.value = scrubberOffset
        }
    }
    
    init() {
        scrubberOffsetAmount = Variable(UIEdgeInsets.zero)
    }
    
    
    
}



struct AVSampleProcessingViewModel {
    
    var audioCount = 0
    var audioFiles: [URL] = []
}
