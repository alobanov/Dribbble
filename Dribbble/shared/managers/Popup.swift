//
//  Popup.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 09.09.16.
//  Copyright © 2016 Lobanov Aleksey. All rights reserved.
//

import Foundation
import SwiftMessages
import PopupDialog

class Popup {
  static let shared = Popup() // Singletone
  private init() {}
  
  
  func show(_ title: String, body: String) {
    let popup = MessageView.viewFromNib(layout: .CardView)
    popup.configureTheme(.error)
    
    popup.backgroundView.backgroundColor = UIColor.white
    popup.titleLabel?.textColor = UIColor.black
    popup.bodyLabel?.textColor = UIColor.darkGray
    popup.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    popup.bodyLabel?.font = UIFont.systemFont(ofSize: 13)
    
    popup.configureContent(title: title, body: body, iconImage: nil,
                           iconText:nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: { _ in SwiftMessages.hide() })
    
    popup.button?.isHidden = true
    var warningConfig = SwiftMessages.Config()
    warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
    warningConfig.dimMode = .gray(interactive: true)
    
    SwiftMessages.show(config: warningConfig, view: popup)
  }
  
  func noInternet() {
    let popup = MessageView.viewFromNib(layout: .CardView)
    popup.configureTheme(.error)
    popup.configureContent(title: "No internet", body: "Check your internet connection")
    
    popup.button?.isHidden = true
    var warningConfig = SwiftMessages.Config()
    warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
    warningConfig.dimMode = .gray(interactive: false)
    warningConfig.duration = .forever
    
    SwiftMessages.show(config: warningConfig, view: popup)
  }
  
  func hide() {
    SwiftMessages.hide()
  }
  
  func showNavError(_ err: NSError) {
    let popup = MessageView.viewFromNib(layout: .TabView)
    popup.configureTheme(.error)
    
    popup.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    popup.bodyLabel?.font = UIFont.systemFont(ofSize: 13)
    
    popup.configureContent(title: "", body: err.localizedDescription)
    
    popup.button?.isHidden = true
    var warningConfig = SwiftMessages.Config()
    warningConfig.presentationContext = .automatic
    warningConfig.duration = .seconds(seconds: 3)
    warningConfig.dimMode = .none
    
    SwiftMessages.show(config: warningConfig, view: popup)
  }
  
  func showCriticalError(_ err: NSError, closeHandler:(() -> Void)?) {
    let popup = MessageView.viewFromNib(layout: .CardView)
    popup.configureTheme(.error)
    
    popup.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    popup.bodyLabel?.font = UIFont.systemFont(ofSize: 13)
    
    popup.configureContent(title: "Error (code: \(err.code))",
                           body: err.localizedDescription,
                           iconImage: nil,
                           iconText: "😧",
                           buttonImage: nil,
                           buttonTitle: "",
                           buttonTapHandler: { _ in
                            if let b = closeHandler {
                              b()
                            }
                            SwiftMessages.hide()
    })
    
    popup.button?.tintColor = UIColor.white
    popup.button?.backgroundColor = UIColor.clear
    popup.button?.isHidden = false
    var warningConfig = SwiftMessages.Config()
    warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
    warningConfig.duration = .forever
    warningConfig.dimMode = .gray(interactive: false)
    
    SwiftMessages.show(config: warningConfig, view: popup)
  }
  
  func showAlertError(_ error: NSError) {
    let ok = CancelButton(title: "Ok") {}
    self.showAlert("Error (code: \(error.code))", subtitle: error.localizedDescription, buttons: [ok])
  }
  
  func showAlert(_ title: String, subtitle: String, buttons: [PopupDialogButton]) {
    // Prepare the popup assets
    let title = title
    let message = subtitle
    
    // Create the dialog
    let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal)
    
    // Add buttons to dialog
    // Alternatively, you can use popup.addButton(buttonOne)
    // to add a single button
    popup.addButtons(buttons)

    // Present dialog
    self.presentController().present(popup, animated: true, completion: nil)
  }
  
  private func presentController() -> UIViewController {
    let keyWindow: UIWindow = UIApplication.shared.delegate!.window!!
    return keyWindow.rootViewController!;
  }
}
