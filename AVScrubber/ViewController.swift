//
//  ViewController.swift
//  AVScrubber
//
//  Created by brendan kerr on 12/29/16.
//  Copyright © 2016 Vetch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var scrubber: AVScrubberView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let audioFileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "trimmedMP3-45", ofType: "m4a")!)
        //let fakeURL = URL(fileURLWithPath: "FalsePath.")
        scrubber = AVScrubberView(frame: CGRect(x: 0, y: view.frame.size.height/2 - 50, width: view.frame.size.width, height: 100), audioFileURL: audioFileURL)
        view.addSubview(scrubber)
    }
    
    
    

}
