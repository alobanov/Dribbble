//
//  UIAlertController+Additional.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 11.08.16.
//  Copyright © 2016 Lobanov Aleksey. All rights reserved.
//

import UIKit

extension UIAlertController {
    class func showError(_ error: NSError) -> UIAlertController {
        let alertController = self.init(title: "Error (code: \(error.code))", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        return alertController
    }
}
