//
//  CommentShotCell.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 17.02.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import UIKit

class CommentShotCell: UITableViewCell, CellReloadeble, CellIdentifiable {
  
  internal static let cellIdentifier = "CommentShotCell"
  @IBOutlet weak var titleLabel: UILabel!
  
  func reload(with model: ModelItemDatasourseble) {
    guard let m = model as? CommentCellModel else { return }
    titleLabel.text = m.text// attributedText = m.text.htmlAttributedString()
//    titleLabel.font = UIFont.systemFont(ofSize: 14)
  }
  
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
    self.titleLabel.lineBreakMode = .byWordWrapping
  }
    
  func test() {
    let text = "This is some text, which incidentally includes a link you may find interesting."
    let fullRange = NSMakeRange(0, (text as NSString).length)
    let linkRange = (text as NSString).range(of: "includes a link")
    let attributedString = NSMutableAttributedString(string: text)
    attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 15), range: fullRange)
    attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: fullRange)
    attributedString.addAttribute(NSLinkAttributeName, value: URL(string: "https://google.com")!, range: linkRange)
    
    let linkTextAttributes = [
      NSUnderlineStyleAttributeName: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue as Int),
      NSForegroundColorAttributeName: UIColor.green
    ]
    
    let highlightedLinkTextAttributes = [
      NSUnderlineStyleAttributeName: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue as Int),
      NSForegroundColorAttributeName: UIColor.red
    ]
  }
  
}

extension String {
  func htmlAttributedString() -> NSAttributedString? {
    guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
    guard let html = try? NSMutableAttributedString(
      data: data,
      options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
      documentAttributes: nil) else { return nil }
    return html
  }
}
