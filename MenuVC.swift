//
//  ScrollVC.swift
//  RNPuzzle
//
//  Created by DerekYang on 2018/12/12.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class MenuVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  var m_img: UIImage? = nil
  
  @IBOutlet weak var pickView: UIPickerView!
  
  
  let diffcult: [(Int, Int)] = [(3,3), (4,3), (5,3), (6,3),
                                (4,4), (5,4), (6,4),
                                (5,5), (6,5),
                                (6,6)]
  
  var select = (3,3)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    pickView.delegate = self
    pickView.dataSource = self
    
  }
  
  
  @IBAction func clickAlbum(_ sender: UIButton) {
    self.openAlbumVC()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return self.diffcult.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    let item = self.diffcult[row]
    return "\(item.0) row \(item.1) colunm"
  }
  
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    self.select = self.diffcult[row]
  }
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}

extension MenuVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
  
  
  func openAlbumVC() {
    
    let imagePickerVC = UIImagePickerController()
    
    // 設定相片的來源為行動裝置內的相本
    imagePickerVC.sourceType = .photoLibrary
    imagePickerVC.delegate = self
    
    // 設定顯示模式為popover
    imagePickerVC.modalPresentationStyle = (UIDevice.current.userInterfaceIdiom
      == .phone) ? .popover : .fullScreen
    let popover = imagePickerVC.popoverPresentationController
    // 設定popover視窗與哪一個view元件有關連
    popover?.sourceView = self.view
    
    // 以下兩行處理popover的箭頭位置
    popover?.sourceRect = self.view.bounds
    popover?.permittedArrowDirections = .any
    
    //        show(imagePickerVC, sender: self)
    self.present(imagePickerVC, animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
    //        imgView?.image=image
    self.dismiss(animated: true) {
      let vc = GameVC(image: image, row: self.select.0, col: self.select.1)
      self.present(vc, animated: true)
    }
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    self.dismiss(animated: true, completion: nil)
  }
}
