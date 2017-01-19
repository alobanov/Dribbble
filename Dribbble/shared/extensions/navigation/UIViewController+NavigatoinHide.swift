//
//  UIViewController+NavigatoinHide.swift
//  Tavern
//
//  Created by Lobanov on 15.12.15.
//  Copyright © 2015 Lobanov Aleksey. All rights reserved.
//

import UIKit

extension UIViewController {
	func showNavigationBar(_ show: Bool) {
    guard let nav = self.navigationController else { return }
		if show {
			nav.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
			nav.navigationBar.shadowImage = nil
			nav.navigationBar.shadowImage = nil
			nav.navigationBar.isTranslucent = true
			nav.view.backgroundColor = UIColor.clear
		} else {
            nav.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            nav.navigationBar.shadowImage = UIImage()
            nav.navigationBar.shadowImage = UIImage()
            nav.navigationBar.isTranslucent = true
            nav.view.backgroundColor = UIColor.clear
		}
	}    
}
