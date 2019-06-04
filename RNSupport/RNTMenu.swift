//
//  RNTGame.swift
//  fngame
//
//  Created by DerekYang on 2018/3/2.
//  Modified by DerekYang on 2018/12/05.
//  Copyright © 2018年 Facebook. All rights reserved.
//

class RNTMenu: UIView
{
  
  lazy var myVC: UIViewController? = {
    guard let parentVC = parentViewController else {
      return nil
    }
  
    let mystoryboard = UIStoryboard.init(name: "Main", bundle:nil)
    let vc = mystoryboard.instantiateViewController(withIdentifier: "MenuVC")
    parentVC.addChild(vc)
    addSubview(vc.view)
    vc.view.frame = bounds
    vc.didMove(toParent: parentVC)
    return vc
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  required init?(coder aDecoder: NSCoder) { fatalError("nope") }
  
  override func layoutSubviews()
  {
    super.layoutSubviews()
    
    self.myVC?.view.frame = bounds
  }
}

extension UIView {
  var parentViewController: UIViewController? {
    var parentResponder: UIResponder? = self
    while parentResponder != nil {
      parentResponder = parentResponder!.next
      if let viewController = parentResponder as? UIViewController {
        return viewController
      }
    }
    return nil
  }
}



