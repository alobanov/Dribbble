//
//  Feed+RxCollectionView.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 18.01.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import RxDataSources

// Collection view RxDataSource
extension FeedViewController {
  func confRxCollectionView() {
    guard let viewModel = self.viewModel else { return }
    
    collectionView.registerCell(by: ShotSmallCell.cellIdentifier)
    
    let dataSource = RxCollectionViewSectionedAnimatedDataSource<ModelSection>()
    rxTableViewDataSource(dataSource)
    
    viewModel.datasourceItems
      .asObservable()
      .bindTo(self.collectionView.rx.items(dataSource: dataSource))
      .addDisposableTo(bag)
    
    collectionView.rx.setDelegate(self)
      .addDisposableTo(bag)
    
    self.dataSource = dataSource
  }
  
  // MARK: Configurate Rx DataSource
  
  func rxTableViewDataSource(_ dataSource: RxCollectionViewSectionedAnimatedDataSource<ModelSection>) {
    dataSource.configureCell = {(dataSource, collectionView, idxPath, _) in
      
      let item: ModelSectionItem = try! dataSource.model(at: idxPath) as! ModelSectionItem
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShotSmallCell.cellIdentifier, for: idxPath) as? ShotSmallCell else {
        return UICollectionViewCell(frame: CGRect.zero)
      }
      
      // Reloadeble cell
      cell.imageTask?.cancel()
      cell.reload(with: item.model)
      
      return cell
    }
    
    collectionView.rx.modelSelected(ModelSectionItem.self)
      .subscribe(onNext: {[weak self] model in
        self?.tableSelectWithModel(model: model)
      }).addDisposableTo(bag)
  }
  
  // MARK: Table cell action
  
  func tableSelectWithModel(model: ModelSectionItem) {
    print(model)
  }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FeedViewController : UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
      return layout.itemSize
    } else {
      return CGSize(width: 0, height: 0)
    }
  }
  
  func createLayout(_ type: CurrentLayout) -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    let spacing = FeedConstants.spacingDefault.rawValue
    
    layout.itemSize = self.getSizeForLayout(type)
    layout.minimumInteritemSpacing = spacing
    layout.minimumLineSpacing = spacing
    layout.sectionInset = UIEdgeInsets(top: spacing, left: 0.0, bottom: spacing, right: 0.0)
    
    return layout
  }
  
  func getSizeForLayout(_ type: CurrentLayout) -> CGSize {
    let screenWidth = UIScreen.main.bounds.width
    var width: CGFloat = 0.0
    let heightStatisticOffset: CGFloat = FeedConstants.heightStatisticOffset.rawValue
    let spacing = FeedConstants.spacingDefault.rawValue
    
    switch type {
    case .medium:
      width = (screenWidth - spacing) / 2.0
    case .large:
      width = screenWidth
    default:
      width = (screenWidth - spacing * 2) / 3.0
    }
    
    let widthFactor = ShotSize.width / width
    let height = ShotSize.height / widthFactor
    return CGSize(width: width, height: height + heightStatisticOffset)
  }
}
