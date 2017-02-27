//
//  UIViewController+Navigation.swift
//  Tavern
//
//  Created by Lobanov Aleksey on 14.02.16.
//  Copyright © 2016 Lobanov Aleksey. All rights reserved.
//

import UIKit

extension UIViewController {
  
//    open override class func initialize() {
//
//        // make sure this isn't a subclass
//        if self !== UIViewController.self {
//            return
//        }
//      
//      self.nsh_swizzleInstanceMethod(self,
//                                     original: #selector(UIViewController.viewWillAppear(_:)),
//                                     replacement: #selector(UIViewController.nsh_viewWillAppear(_:)))
//      
//      self.nsh_swizzleInstanceMethod(self,
//                                     original: #selector(UIViewController.viewWillDisappear(_:)),
//                                     replacement: #selector(UIViewController.nsh_viewWillDisappear(_:)))
//      
//    }
//    
//    static func nsh_swizzleInstanceMethod(_ c: AnyClass, original: Selector, replacement: Selector) {
//        let originalMethod = class_getInstanceMethod(c, original)
//        let swizzledMethod = class_getInstanceMethod(c, replacement)
//        
//        let didAddMethod = class_addMethod(c, original,
//            method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
//        
//        if didAddMethod {
//            class_replaceMethod(c, replacement, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
//        } else {
//            method_exchangeImplementations(originalMethod, swizzledMethod)
//        }
//    }
//    
//    // MARK: - Method Swizzling
//    
//    func nsh_viewWillAppear(_ animated: Bool) {
//        self.nsh_viewWillAppear(animated)
//        
//        if self.nsh_shouldNavigationHide() {
//            self.showNavigationBar(false)
//        }
//        
//        if nsh_shouldStatusbarHide() {
//            if let statusBarWindow: UIWindow = UIApplication.shared.value(forKey: "statusBarWindow") as? UIWindow {
//                UIView.animate(withDuration: nsh_shouldUseAnimation() ? 0.3 : 0, animations: { _ in
//                    statusBarWindow.alpha = 0
//                })
//            }
//        }
//    }
//    
//    func nsh_viewWillDisappear(_ animated: Bool) {
//        self.nsh_viewWillDisappear(animated)
//        
//        if self.nsh_shouldNavigationHide() {
//            self.showNavigationBar(true)
//        }
//        
//        if nsh_shouldStatusbarHide() {
//            if let statusBarWindow: UIWindow = UIApplication.shared.value(forKey: "statusBarWindow") as? UIWindow {
//                UIView.animate(withDuration: nsh_shouldUseAnimation() ? 0.3 : 0, animations: { _ in
//                    statusBarWindow.alpha = 1
//                })
//            }
//        }
//    }
//    
//    func nsh_shouldNavigationHide() -> Bool {
//        return false
//    }
//    
//    func nsh_shouldStatusbarHide() -> Bool {
//        return false
//    }
//    
//    func nsh_shouldUseAnimation() -> Bool {
//        return false
//    }
}
