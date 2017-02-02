//
//  ShotSmallCell.swift
//  Tavern
//
//  Created by Lobanov Aleksey on 07.11.15.
//  Copyright © 2015 Lobanov Aleksey. All rights reserved.
//

import UIKit
import Kingfisher
import Font_Awesome_Swift

class ShotSmallCell: UICollectionViewCell, CellReloadeble, CellIdentifiable {
  
  internal static let cellIdentifier = "ShotSmallCell"
  var width: CGFloat = 0
  @IBOutlet weak var shotImageView: UIImageView!
  @IBOutlet weak var likeCntLabel: UILabel!
  @IBOutlet weak var likeIcoLabel: UILabel!
  @IBOutlet weak var commentCntLabel: UILabel!
  @IBOutlet weak var commentIcoLabel: UILabel!
  @IBOutlet weak var viewCntLabel: UILabel!
  @IBOutlet weak var viewIcoLabel: UILabel!
  internal var imageTask: RetrieveImageTask?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    self.likeIcoLabel.setFAIcon(icon: FAType.FAHeartO, iconSize: 11)
    self.commentIcoLabel.setFAIcon(icon: FAType.FACommentO, iconSize: 11)
    self.viewIcoLabel.setFAIcon(icon: FAType.FAEye, iconSize: 11)
    
    self.width = (UIScreen.main.bounds.width - FeedConstants.spacingDefault.rawValue*2)/3.0
  }
  
  override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    let alpha: CGFloat = (self.bounds.width == self.width) ? 0 : 1
    
    UIView.animate(withDuration: 0.3, animations: { () -> Void in
      self.viewCntLabel.alpha = alpha
      self.viewIcoLabel.alpha = alpha
      self.commentCntLabel.alpha = alpha
      self.commentIcoLabel.alpha = alpha
      self.layoutIfNeeded()
    })
  }
  
  
  func reload(with model: ModelItemDatasourseble) {
    guard let m = model as? FeedCellModel else { return }
    
    likeCntLabel.text = m.likes
    commentCntLabel.text = m.commnets
    viewCntLabel.text = m.views
    
    if let image = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: m.imagePath) {
      self.shotImageView.image = image
      return
    }
    
    self.imageTask = self.shotImageView.kf
      .setImage(with: URL(string: m.imagePath)!,
                placeholder: nil,
                options: [.transition(ImageTransition.fade(0.3)), .cacheMemoryOnly],
                progressBlock: nil,
                completionHandler: nil)
  }
  
}
