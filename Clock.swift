//
//  Clock.swift
//  RNPuzzle
//
//  Created by DerekYang on 2018/12/12.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation

@objc protocol ClockDelegate {
    @objc func handleCountUp(time: String)
}

class Clock {
     
    var timer : Timer!
    var seconds = 0
    var minutes = 0

    weak var delegate: ClockDelegate? = nil
    

    init() {
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(countUp), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    
    @objc fileprivate func countUp() {
        
        seconds += 1
        var secondsStr = "00"
        var minutesStr = "00"
        
        if(seconds >= 60) {
            minutes += 1
            seconds = 0
        }
     
        secondsStr = (seconds < 10) ? "0\(seconds)" : "\(seconds)"
        
        minutesStr = (minutes < 10) ? "0\(minutes)" : "\(minutes)"
        
        let timerStr = "\(minutesStr) : \(secondsStr)"
        
        self.delegate?.handleCountUp(time: timerStr)
        
    }

 
    
    

}
