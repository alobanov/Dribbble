//
//  CommentCellModel.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 17.02.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import UIKit.UIFont

struct CommentCellModel: ModelItemDatasourseble, PonsoUnicIdentifirable {
  var uid: Int = 1
  var text = ""
  var textHTML = ""
  var likes = ""
  var avatarPath = ""
  var date = ""
  var unic: String?
  
  init(comment: ShotCommentModel) {
    if let t = comment.body {
      text = t.removeAllHTMPTags()
      textHTML = t.deleteHTMLTags(tags: ["p", "br"])
    }
    
    likes = " \(comment.likes_count)"
    uid = comment.commentId
    date = "Today" //comment.created_at
    
    if let path = comment.user?.avatar_url {
      avatarPath = path
    }
    
    unic = "\(uid)"
  }
}

extension CommentCellModel {
    func height(byWidth: CGFloat) -> CGFloat {
        let defaultPartAttributes = AZTextFrameAttributes(string: self.text, width: byWidth, font: UIFont.systemFont(ofSize: 15))
        let firstHeight = AZTextFrame(attributes: defaultPartAttributes).height + 20
        return firstHeight
    }
}

extension String {
  func removeAllHTMPTags() -> String {
    return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil).replacingOccurrences(of: "\n", with: "")
  }
  
  func deleteHTMLTag(tag:String) -> String {
    return self.replacingOccurrences(of: "(?i)</?\(tag)\\b[^<]*>", with: "", options: .regularExpression, range: nil)
  }
  
  func deleteHTMLTags(tags:[String]) -> String {
    var mutableString = self
    for tag in tags {
      mutableString = mutableString.deleteHTMLTag(tag: tag)
    }
    return mutableString
  }
}
