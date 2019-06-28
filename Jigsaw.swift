//
//  Puzzle.swift
//  Puzzle
//
//  Created by Derek on 2019/6/27.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import UIKit

let DEF_DEBUG_MODE = false

class Puzzle {
  
  var blockSize = 9
  var colNum = 3
  
  var parentView: UIView!
  
  var gesturesArray = [UISwipeGestureRecognizer]()
  
  var m_imagesList = [UIImage]()
  
  var defaultWhiteIndex = 0
  
  init(_ parent: UIView, img: UIImage, row: Int = 3, col: Int = 3) {
    
    self.parentView = parent
    
    let rowNum = (row < 3) ? 3 : row
    self.colNum = (col < 3) ? 3 : col
    self.blockSize = rowNum * self.colNum
    
    setupImage(image: img, rowNum: row, colNum: col)
  }
  
  func setupImage(image: UIImage, rowNum: Int, colNum: Int) {
    
    let total = rowNum * colNum
    self.m_imagesList.removeAll()
    let unitWidth = image.size.width / CGFloat(colNum)
    let unitHeight = image.size.height / CGFloat(rowNum)
    for i in 0 ..< total {
      let row = CGFloat(i / colNum)
      let col = CGFloat(i % colNum)
      let rect = CGRect(x: col * unitWidth, y: row * unitHeight, width: unitWidth, height: unitHeight)
      if let subImg = image.subImage(rect) {
        self.m_imagesList.append(subImg)
      }
    }
    
    var randomArray = [Int]()
    if(DEF_DEBUG_MODE) {
      for i in 1...total {
        randomArray.append(i)
      }
    } else {
      while randomArray.count < total {
        let number = Int.random(in: 1...total)
        if let _ = randomArray.firstIndex(of: number) {
          
        } else {
          randomArray.append(number)
        }
      }
    }
    //    print(randomArray)
    
    for tag in 1 ... randomArray.count {
      let rand = randomArray[tag-1]
      if let imageView = self.parentView.viewWithTag(tag) as? UIImageView {
        let image = self.m_imagesList[rand - 1]
        imageView.image = image
        if let img = imageView.image {
          img.accessibilityLabel = "\(rand)"
        }
      }
    }
    
    if let whiteView = self.parentView.viewWithTag(randomArray[0]) as? UIImageView {
      whiteView.image = UIImage(named: "white")
      self.defaultWhiteIndex = randomArray[randomArray[0]-1]
      whiteView.image?.accessibilityLabel = "\(self.defaultWhiteIndex)"
    }
  }
  
  func isWin() -> Bool {
    for tag in 1 ... blockSize {
      if let targetImageView = self.parentView.viewWithTag(tag) as? UIImageView,
        let img = targetImageView.image {
        if img.accessibilityLabel != "\(tag)" {
          return false
        }
      }
    }
    return true
  }
  
  func getMoveView(direction : UISwipeGestureRecognizer.Direction) -> UIImageView? {
    let spaceTag = getSpaceTag()
    if(spaceTag > 0) {
      var targetView: UIImageView!
      if (direction == .right) {
        targetView = self.parentView.viewWithTag(spaceTag - 1) as? UIImageView
      } else if (direction == .left) {
        targetView = self.parentView.viewWithTag(spaceTag + 1) as? UIImageView
      } else if (direction == .up) {
        targetView = self.parentView.viewWithTag(spaceTag + self.colNum) as? UIImageView
      } else if (direction == .down) {
        targetView = self.parentView.viewWithTag(spaceTag - self.colNum) as? UIImageView
      }
      return targetView
    } else {
      return nil
    }
  }
  
  func getSpaceView() -> UIImageView? {
    let spaceTag = getSpaceTag()
//    print("spaceTag=\(spaceTag)")
    return self.parentView.viewWithTag(spaceTag) as? UIImageView
  }
  
  func getSpaceTag() -> Int {
    for tag in 1 ... self.blockSize {
      if let imgView = self.parentView.viewWithTag(tag) as? UIImageView,
        let img = imgView.image {
        //                print(img.accessibilityLabel ?? "accessibilityLabel")
        if img.accessibilityLabel == "\(self.defaultWhiteIndex)" {
          return tag
        }
      }
    }
    return self.blockSize
  }
  
  func swapImage(sourse: UIImageView, destination: UIImageView){
    let swapImage = destination.image
    destination.image = sourse.image
    sourse.image = swapImage
  }
}

extension UIImage {
  func subImage(_ rect: CGRect) -> UIImage? {
    if let sourceImageRef = self.cgImage,
      let newImageRef =  sourceImageRef.cropping(to: rect) {
      let img = UIImage.init(cgImage: newImageRef)
      return img
    }
    return nil
  }
}
