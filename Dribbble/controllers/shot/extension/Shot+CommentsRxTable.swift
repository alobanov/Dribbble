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
  func confRxTableView() {
    guard let viewModel = self.viewModel else { return }
    
    tableView.registerCell(by: CommentShotCell.cellIdentifier)
    
    let dataSource = RxTableViewSectionedAnimatedDataSource<ModelSection>()
    dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .fade)
    rxTableViewDataSource(dataSource)
    
    viewModel.datasourceItems
      .asObservable()
      .bindTo(tableView.rx.items(dataSource: dataSource))
      .addDisposableTo(bag)
    
    tableView.rx.setDelegate(self)
      .addDisposableTo(bag)
    
    self.dataSource = dataSource
  }
  
  // MARK: Configurate Rx DataSource
  
  func rxTableViewDataSource(_ dataSource: RxTableViewSectionedAnimatedDataSource<ModelSection>) {
    dataSource.configureCell = {(dataSource, table, idxPath, _) in
      
      let item: ModelSectionItem = try! dataSource.model(at: idxPath) as! ModelSectionItem
      guard let cell = table.dequeueReusableCell(withIdentifier: CommentShotCell.cellIdentifier, for: idxPath) as? CommentShotCell else {
        return UITableViewCell()
      }
      
      // Reloadeble cell
//      cell.imageTask?.cancel()
      cell.reload(with: item.model)
      
      return cell
    }
    
    tableView.rx.modelSelected(ModelSectionItem.self)
      .subscribe(onNext: {[weak self] model in
        self?.tableSelectWithModel(model: model)
      }).addDisposableTo(bag)
  }
  
  // MARK: Table cell action
  
  func tableSelectWithModel(model: ModelSectionItem) {
    print(model)
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
