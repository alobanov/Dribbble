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
    
    DispatchQueue.global(qos: .userInitiated).async {
      let attr = m.textHTML.htmlAttributedString()
      
      DispatchQueue.main.async {
        self.titleLabel.attributedText = attr
        self.titleLabel.font = UIFont.systemFont(ofSize: 15)
        self.showLabel()
      }
    }
  }
  
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
    self.titleLabel.lineBreakMode = .byWordWrapping
    self.titleLabel.alpha = 0;
  }
  
  func showLabel() {
    UIView.animate(withDuration: 0.4) { 
      self.titleLabel.alpha = 1
    }
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
