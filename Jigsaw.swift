//
//  Jigsaw.swift
//  RNPuzzle
//
//  Created by DerekYang on 2018/12/12.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import UIKit

class Jigsaw {
    
    var blockSize = 9
    var colNum = 3
    
    var parentView: UIView!
    var clock: Clock? = nil
    
    var gesturesArray = [UISwipeGestureRecognizer]()
    
    
    
//    var parent : PlayVC!
    
    
    init(parentView: UIView, img: UIImage, clock: Clock, row: Int, col: Int) {
        
//        self.parent = parent
        self.parentView = parentView
        self.clock = clock
        
        let rowNum = (row > 3) ? row : 3
        self.colNum = (col > 3) ? col : 3
        self.blockSize = rowNum * self.colNum
        
        setImageAndAccess(image: img, rowNum: row, colNum: col)
    }
    
    func setImageAndAccess(image: UIImage, rowNum: Int, colNum: Int) {
 
        var imagesList = [UIImage]()
        let unitWidth = image.size.width / CGFloat(colNum)
        let unitHeight = image.size.height / CGFloat(rowNum)
        for i in 0 ..< blockSize {
            let row = CGFloat(i / colNum)
            let col = CGFloat(i % colNum)
            let rect = CGRect(x: col * unitWidth, y: row * unitHeight, width: unitWidth, height: unitHeight)
            if let subImg = image.subImage(rect) {
                imagesList.append(subImg)
            }
        }
        
        let randomArray = RandomArray.init(max: blockSize)
        for tag in 1 ..< blockSize {
            if let imageView : UIImageView = self.parentView.viewWithTag(tag) as? UIImageView {
                let rand = randomArray.randArray[tag-1]
                let image : UIImage = imagesList[rand]
                imageView.image = image
                imageView.image?.accessibilityLabel = "\(rand)"
            }
            
        }
        
        
        if let lastView = self.parentView.viewWithTag(blockSize) as? UIImageView {
            lastView.image = UIImage(named: "white")
            lastView.image?.accessibilityLabel = "\(blockSize)"
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
            var targetView : UIImageView!
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
        return self.parentView.viewWithTag(spaceTag) as? UIImageView
    }
    
    func getSpaceTag() -> Int {
        for tag in 1 ... self.blockSize {
            if let imgView = self.parentView.viewWithTag(tag) as? UIImageView,
            let img = imgView.image {
//                print(img.accessibilityLabel)
                if img.accessibilityLabel == "\(blockSize)" {
                    return tag
                }
            }
        }
        return -1
    }
    
    
    func swapImage(senderImageView : UIImageView, destinationImageView: UIImageView){
        
        let swapImage = destinationImageView.image
        destinationImageView.image = senderImageView.image
        senderImageView.image = swapImage
        
    }
    
    func calculateScore() -> String {
        guard let timer = self.clock else {
            return "?"
        }
        
        if (timer.minutes < 1) {
            return "SS"
        } else if (timer.minutes < 3) {
            return "S"
        } else if (timer.minutes < 5) {
            return "A"
        } else if (timer.minutes >= 5 && timer.minutes < 10) {
            return "B"
        } else if (timer.minutes >= 10 && timer.minutes < 20) {
            return "C"
        } else {
            return "D"
        }
        
        
    }
    
    
}

extension UIImage {
    func subImage(_ rect: CGRect) -> UIImage? {
        //将UIImage转换成CGImageRef
        if let sourceImageRef = self.cgImage,
            let newImageRef =  sourceImageRef.cropping(to: rect) {
            
            //将CGImageRef转换成UIImage
            let newImage = UIImage.init(cgImage: newImageRef)
            
            //返回剪裁后的图片
            return newImage
        }
        return nil
    }
}
