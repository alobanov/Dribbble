//
//  TableView+ReusableView.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 07.08.16.
//  Copyright © 2016 Lobanov Aleksey. All rights reserved.
//

import Foundation
import class UIKit.UITableViewCell
import class UIKit.UITableView

protocol ReusableView: class {
    static var reuseIdentifier: String {get}
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {
}

extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath, andtype:T.Type) -> T where T: ReusableView {
        guard let cell = self.dequeueReusableCell(withIdentifier: andtype.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }
}
