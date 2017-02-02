//
//  Feed+RxCollectionView.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 18.01.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import RxDataSources

// Collection view structure
enum CurrentLayout: Int {
  case small
  case medium
  case large
  case count
}

enum FeedConstants: CGFloat {
  case topFilterHideOffset = -460
  case topFilterShowOffset = -30
  case spacingDefault = 5.0
}

// Collection view RxDataSource
extension FeedViewController {
  func confRxCollectionView() {
    guard let viewModel = self.viewModel else { return }
    
    collectionView.registerCell(by: ShotSmallCell.cellIdentifier)
    collectionView.setCollectionViewLayout(self.createLayout(self.currentLayout), animated: true)
    
    let dataSource = RxCollectionViewSectionedAnimatedDataSource<ModelSection>()
    rxTableViewDataSource(dataSource)
    
    viewModel.items
      .asObservable()
      .bindTo(self.collectionView.rx.items(dataSource: dataSource))
      .addDisposableTo(disposeBag)
    
    collectionView.rx.setDelegate(self)
      .addDisposableTo(disposeBag)
    
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
      }).addDisposableTo(disposeBag)
  }
  
  // MARK: Table cell action
  
  func tableSelectWithModel(model: ModelSectionItem) {
    print(model)
  }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FeedViewController : UICollectionViewDelegateFlowLayout {
  
  func updateLayout() {
    self.currentLayout = self.nextLayoutType()
    let layout = createLayout(self.currentLayout)
//    self.updateLayoutIcon()
    self.collectionView?.setCollectionViewLayout(layout, animated: true)
  }
  
//  func updateLayoutIcon() {
//    let icon: FAType!
//    switch self.currentLayout {
//    case .small:
//      icon = FAType.FAThLarge
//    case .medium:
//      icon = FAType.FASquare
//    default:
//      icon = FAType.FATh
//    }
//    
//    self.rightNavButton.FAIcon = icon
//  }
  
  func nextLayoutType() -> CurrentLayout {
    let nextType = 0
    if self.currentLayout.rawValue + 1 == CurrentLayout.count.rawValue {
      return CurrentLayout(rawValue: nextType)!
    }
    
    return CurrentLayout(rawValue: self.currentLayout.rawValue + 1)!
  }
  
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
    let heightStatisticOffset: CGFloat = 20.0
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
