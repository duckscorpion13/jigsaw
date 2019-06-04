//
//  BaseVC.swift
//  Test
//
//  Created by DerekYang on 2018/5/21.
//  Modified by DerekYang on 2018/10/16.
//  Copyright © 2018 DerekYang. All rights reserved.
//
//  Check List
//
//v1.0
// v 1. Info.plist -> App Transport Security... -> Allow Arbitrary Loads = true
//  2. statusBarView.backgroundColor
//  3. JSON API URL
//  4. optional(Push Notifications)
// v 5. clearCache
// v 6. windows.open handle
// v 7. Fabric
// v 8. Layout Rotate Test in iPhoneX & <ios10 devices
// v 9. support ios >= 9.0(check App size must > 6MB)
//
//v2.0
// v 1. support use the other WkWebVC for windows.open
// v 2. Add UserAgent deviceInfo
// v 3. Info.plist -> Privacy - Camera Usage Description/Photo Library Usage Description
// v 4. dynamic close button
//
//v2.0.6
// v 1. openSafari()
//
//v2.1
//  1. use DomainList
// v 2. openWebView()
//  3. Info.plist -> Localized resources can be mixed = YES
//
//v2.2
//  1. Target -> Info -> URL Types
//  2. Appdelegate:
//         //Scheme Links
//         func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool
//         {
//              if let baseVC = app.keyWindow?.rootViewController as? BaseVC,
//              let key = url.host {
//                  baseVC.checkKey(key)
//              }
//              return true
//         }
//  3. Version Update Setting: Targets->General->Set Build(first : 0)
//  4. check API_LINK_URL & API_UPDATE_URL
//  5. Universal Link : Capabilities -> Assosiated Domain
//  6. Scheme Link : Info.plist -> URL type -> Item 0 -> URL Schemes -> Item 0 = Merchant


import UIKit
import SafariServices
import AuthenticationServices

public let API_LINK_URL = "https://promo.tk/api/app/property"
public let API_UPDATE_URL = "https://promo.tk/api/app/latest?os=ios"

public struct ST_JSON_LINK_INFO: Codable
{
  let url: String?
}

public struct ST_JSON_VERSION_INFO: Codable
{
  let os: String?
  let version: String?
  let build: Int
  let url: String?
  let description: String?
  let createdAt: String?
}

class BaseVC: WkWebVC {
  let USER_DEFAULT_LINK = "USER_DEFAULT_LINK"
  
  let m_color = 0//
  
  var isFirst = true
  var authSession: NSObject?//SFAuthenticationSession?//ASWebAuthenticationSession?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if(self.m_color > 0) {
      let red = CGFloat((m_color&0xFF0000)>>16) / CGFloat(0xFF)
      let green = CGFloat((m_color&0x00FF00)>>8) / CGFloat(0xFF)
      let blue = CGFloat(m_color&0x0000FF) / CGFloat(0xFF)
      UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    //        print(UIDevice.current.identifierForVendor?.uuidString)
    
    //        self.urlStr = "https://1384308.site123.me/"
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.m_closeBtn?.isHidden = self.m_isRoot
    deviceRotated()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    deviceRotated()
  }
  
  
  @objc func deviceRotated()
  {
    switch UIDevice.current.orientation {
    case .landscapeLeft, .landscapeRight :
      self.m_topConstraint?.constant = 0
    case .unknown, .portrait :
      self.m_topConstraint?.constant = 20
    default:
      break
    }
  }
  
  func getCookieProc(url: URL)
  {
    //Initialize auth session
    if #available(iOS 12.0, *) {
      self.authSession = ASWebAuthenticationSession(url: url,
                                                    callbackURLScheme: "",
                                                    completionHandler: { (callBack: URL?, error: Error? ) in
                                                      guard error == nil, let successURL = callBack else {
                                                        //                                                                print(error!)
                                                        return
                                                      }
                                                      //                                                            print(successURL.absoluteString)
                                                      if let key = successURL.host {
                                                        //                                                                print(key)
                                                        UIPasteboard.general.string = key
                                                      }
      })
      if let session = self.authSession as? ASWebAuthenticationSession {
        session.start()
      }
    } else if #available(iOS 11.0, *) {
      self.authSession = SFAuthenticationSession(url: url,
                                                 callbackURLScheme: "",
                                                 completionHandler: { (callBack: URL?, error: Error? ) in
                                                  guard error == nil, let successURL = callBack else {
                                                    //                                                            print(error!)
                                                    return
                                                  }
                                                  //                                                        print(successURL.absoluteString)
                                                  if let key = successURL.host {
                                                    //                                                            print(key)
                                                    UIPasteboard.general.string = key
                                                  }
      })
      if let session = self.authSession as? SFAuthenticationSession {
        session.start()
      }
    } else {
      let safariVC = SFSafariViewController(url: url)
      safariVC.delegate = self
      self.present(_: safariVC, animated: true, completion: nil)
    }
  }
  
  func checkKey(_ key: String)
  {
    guard let url = URL(string: API_LINK_URL) else {
      return
    }
    HttpMethod.httpRequest(url: url,
                           params: ["fp" : key],
                           success: { data in
                            if let info = try? JSONDecoder().decode(ST_JSON_LINK_INFO.self, from: data),
                              let urlStr = info.url {
                              self.setLocalLink(urlStr)
                            }
    },
                           failure: { packet in
                            if let url = URL(string: API_LINK_URL) {
                              self.getCookieProc(url: url)
                            }
    })
  }
  
  func setLocalLink(_ str: String) {
    
    UserDefaults.standard.set(str, forKey: USER_DEFAULT_LINK)
    UserDefaults.standard.synchronize()
    self.m_urlStr = str
  }
  
  func getLocalLink() -> URL? {
    if let link = UserDefaults.standard.object(forKey: USER_DEFAULT_LINK),
      let linkStr = link as? String,
      let url = URL(string: linkStr) {
      return url
    }
    return nil
  }
}


extension UIApplication {
  var statusBarView: UIView? {
    if responds(to: Selector(("statusBar"))) {
      return value(forKey: "statusBar") as? UIView
    }
    return nil
  }
}


extension BaseVC: SFSafariViewControllerDelegate {
  func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
    controller.dismiss(animated: false, completion: nil)
  }
  
  func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    controller.dismiss(animated: false, completion: nil)
  }
}



