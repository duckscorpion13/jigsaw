//
//  Clock.swift
//  Puzzle
//
//  Created by Derek on 2019/6/27.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation

@objc protocol ClockDelegate {
  @objc optional func handleTimesUp(hours: Int, minutes: Int, seconds: Int)
}

class Clock {
  
  var timer : Timer!
  var m_hours = 0
  var m_minutes = 0
  var m_seconds = 0
  
  weak var delegate: ClockDelegate? = nil
  
  init() {
    timer = Timer(timeInterval: 1.0, target: self, selector: #selector(countUp), userInfo: nil, repeats: true)
    RunLoop.current.add(timer!, forMode: .common)
  }
  
  @objc fileprivate func countUp() {
    
    m_seconds += 1
    
    if(m_seconds >= 60) {
      m_minutes += 1
      m_seconds = 0
    }
    
    if(m_minutes >= 60) {
      m_hours += 1
      m_minutes = 0
    }
    
    self.delegate?.handleTimesUp?(hours: m_hours, minutes: m_minutes, seconds: m_seconds)
  }
}
