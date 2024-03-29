//
//  GameVC.swift
//  Puzzle
//
//  Created by Derek on 2019/6/27.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class GameVC: UIViewController {
  var m_col = 3
  var m_row = 3
  
  var contentView: UIView!
  
  var timeLbl: UILabel? = nil
  
  var m_image: UIImage!
  
  var m_clock : Clock!
  var imgViewsList = [UIImageView]()
  var puzzleGame: Puzzle!
  
  convenience init(image: UIImage, row: Int = 3, col: Int = 3) {
    self.init()
    
    self.m_row = row
    
    self.m_col = col
    
    self.m_image = image
  }
  
  fileprivate func setupStack() {
    let mainStack = UIStackView()
    mainStack.axis = .vertical
    mainStack.alignment = .fill
    
    self.contentView.addSubview(mainStack)
    
    mainStack.translatesAutoresizingMaskIntoConstraints = false
    mainStack.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
    mainStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    mainStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
    mainStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
    mainStack.distribution = .fillEqually
    
    
    for i in 0 ..< self.m_row {
      let subStack = UIStackView()
      subStack.axis = .horizontal
      subStack.alignment = .fill
      subStack.spacing = 5
      subStack.distribution = .fillEqually
      
      for j in 0 ..< self.m_col {
        let view = UIImageView()
        view.tag = i * m_col + j + 1
        subStack.addArrangedSubview(view)
        
        self.imgViewsList.append(view)
      }
      mainStack.addArrangedSubview(subStack)
    }
  }
  
  override func viewDidLoad() {
    
    self.navigationController?.navigationBar.isHidden = true
    
    self.setupHeaderUI()
    
    self.setupStack()
    
    self.addGestures()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    settingGame()
  }
  
  fileprivate func setupHeaderUI() {
    
    let titleView = UIView(frame: CGRect.zero)
    self.view.addSubview(titleView)
    titleView.translatesAutoresizingMaskIntoConstraints = false
    if #available(iOS 11.0, *) {
      titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    } else {
      titleView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    titleView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    titleView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    titleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    self.contentView = UIView(frame: CGRect.zero)
    self.view.addSubview(self.contentView)
    self.contentView.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.topAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
    self.contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    self.contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    self.contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    
    let hintBtn = UIButton(frame:  CGRect.zero)
    hintBtn.addTarget(self, action: #selector(self.showHint(_:)), for: .touchUpInside)
    hintBtn.setTitle("Hint", for: [])
    titleView.addSubview(hintBtn)
    hintBtn.translatesAutoresizingMaskIntoConstraints = false
    hintBtn.topAnchor.constraint(equalTo: titleView.topAnchor).isActive = true
    hintBtn.bottomAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
    hintBtn.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 20).isActive = true
    hintBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
    
    let leaveBtn = UIButton(frame:  CGRect.zero)
    leaveBtn.addTarget(self, action: #selector(self.leave(_:)), for: .touchUpInside)
    leaveBtn.setTitle("Leave", for: [])
    titleView.addSubview(leaveBtn)
    leaveBtn.translatesAutoresizingMaskIntoConstraints = false
    leaveBtn.topAnchor.constraint(equalTo: titleView.topAnchor).isActive = true
    leaveBtn.bottomAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
    leaveBtn.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -20).isActive = true
    leaveBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
    
    self.timeLbl = UILabel(frame:  CGRect.zero)
    if let lbl = self.timeLbl {
      titleView.addSubview(lbl)
      lbl.textColor = UIColor.yellow
      lbl.translatesAutoresizingMaskIntoConstraints = false
      lbl.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
      lbl.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
    }
  }
  
  
  fileprivate func settingGame() {
    
    self.m_clock = Clock.init()
    self.m_clock.delegate = self
    
    puzzleGame = Puzzle.init(self.view, img: self.m_image, row: self.m_row, col: self.m_col)
  }
  
  
  
  // MARK: handle game swipper
  fileprivate func addGestures() {
    
    let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left, .up, .down]
    for direction in directions {
      
      let imageGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe))
      imageGesture.direction = direction
      
      self.view.addGestureRecognizer(imageGesture)
    }
  }
  
  @objc fileprivate func handleSwipe(sender: UISwipeGestureRecognizer) {
    if let spaceView = puzzleGame.getSpaceView(),
      let targetView = puzzleGame.getMoveView(direction: sender.direction) {
      puzzleGame.swapImage(sourse: targetView, destination: spaceView)
      if puzzleGame.isWin(){
        endRound()
      }
    }
  }
  
  
  
  @objc fileprivate func leave(_ sender: UIButton) {
    self.m_clock.timer.invalidate()
    self.dismiss(animated: true)
  }
  
  
  @objc fileprivate func showHint(_ sender: UIButton) {
    let alert = UIAlertController(title: "Hint", message: " Target", preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
    
    let imgView = UIImageView(image: self.m_image)
    imgView.contentMode = .scaleToFill
    imgView.frame = CGRect(x: 0, y: 0, width: alert.view.frame.width/6, height: alert.view.frame.height/6)
    alert.view.addSubview(imgView)
    
    self.present(alert, animated: true, completion:nil)
  }
  
  fileprivate func endRound(){
    
    // stop timer
    m_clock.timer.invalidate()
    
    let rank = calculateScore()
    let alert = UIAlertController(title: "Success", message: " Rank : " + rank, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,
                                  handler: { _ in
                                    self.dismiss(animated: true)
    }))
    self.present(alert, animated: true, completion:nil)
    
  }
  func calculateScore() -> String {
    guard let timer = m_clock else {
      return "🦴"
    }
    
    if (timer.m_minutes < 1) {
      return "🥘🥘🥘"
    } else if (timer.m_minutes < 3) {
      return "🍱🍱"
    } else if (timer.m_minutes < 5) {
      return "🍔"
    } else if (timer.m_minutes >= 5 && timer.m_minutes < 10) {
      return "🍝"
    } else if (timer.m_minutes >= 10 && timer.m_minutes < 20) {
      return "🍙"
    } else {
      return "🥩"
    }
  }
}

extension GameVC: ClockDelegate {
  func handleTimesUp(hours: Int, minutes: Int, seconds: Int) {
    let numberFormatter = NumberFormatter()
    //设置number显示样式
    numberFormatter.numberStyle = .none //四舍五入的整数
    numberFormatter.formatWidth = 2 //补齐10位
    numberFormatter.paddingCharacter = "0" //不足位数用0补
    numberFormatter.paddingPosition = .beforePrefix  //补在前面
    //格式化
    if let formatHH = numberFormatter.string(from: NSNumber(value: hours)),
      let formatMM = numberFormatter.string(from: NSNumber(value: minutes)),
      let formatSS = numberFormatter.string(from: NSNumber(value: seconds)) {
      self.timeLbl?.text =   "\(formatHH) : \(formatMM) : \(formatSS)"
    }
  }
}




