//
//  String+NSAttributedString.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 05.09.16.
//  Copyright © 2016 Lobanov Aleksey. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

extension String {
  var attributedStringFromHtml: NSAttributedString? {
      let attributedString = try! NSMutableAttributedString(data: self.data(using: String.Encoding.utf8)!,
                                                            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                            documentAttributes: nil)
      
      let s: NSString = attributedString.string as NSString
      attributedString.addAttributes([NSFontAttributeName:UIFont(name: "Georgia", size: 13.0)!], range: s.range(of: self))
      return attributedString
  }
}


extension NSMutableAttributedString {  
  func green(_ text: String) -> NSMutableAttributedString {
    let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor("4EA33E")]
    let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
    self.append(boldString)
    return self
  }
  
  func normal(_ text:String)->NSMutableAttributedString {
    let normal =  NSAttributedString(string: text)
    self.append(normal)
    return self
  }
}
