//
//  RandArray.swift
//  RNPuzzle
//
//  Created by DerekYang on 2018/12/12.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation

class RandomArray {
    
    var randArray = [Int]()

    
    init(max: Int) {
        var numbersArray = [Int]()
        for i in 1 ..< max {
            numbersArray.append(i)
        }
        randArray = self.shuffle(arrayIn: numbersArray)
    }

    fileprivate func shuffle(arrayIn: [Int]) -> [Int] {
        var arrayOut = arrayIn
        for i in 0 ..< arrayIn.count {
            let randIndex = Int(arc4random_uniform(UInt32(arrayIn.count)))
            let tmpValue = arrayOut[i]
            arrayOut[i] = arrayOut[randIndex]
            arrayOut[randIndex] = tmpValue
        }
//        print(arrayOut)
        return arrayOut
    }
    
}
