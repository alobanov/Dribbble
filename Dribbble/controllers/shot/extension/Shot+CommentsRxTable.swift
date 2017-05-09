//
//  Shot+CommentsRxTable.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 17.02.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import RxDataSources
import Infinity

// Collection view RxDataSource
extension ShotViewController {
  
  // MARK: Configurate Rx DataSource
  
  func rxTableViewDataSource(_ dataSource: RxTableViewSectionedAnimatedDataSource<ModelSection>) {
    dataSource.configureCell = {(dataSource, table, idxPath, _) in
      
      let item: ModelSectionItem = try! dataSource.model(at: idxPath) as! ModelSectionItem
      guard let cell = table.dequeueReusableCell(withIdentifier: CommentShotCell.cellIdentifier, for: idxPath) as? CommentShotCell else {
        return UITableViewCell()
      }
      
      // Reloadeble cell
      cell.reload(with: item.model)
      
      return cell
    }
  }
}

extension ShotViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    let item: ModelSectionItem = try! self.dataSource!.model(at: indexPath) as! ModelSectionItem
    guard let model = item.model as? CommentCellModel else {
     return 0
    }
    
    let bounds = UIScreen.main.bounds
    let width = bounds.size.width
    
    return model.height(byWidth: width - 25)
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return UITableViewAutomaticDimension
  }
}
