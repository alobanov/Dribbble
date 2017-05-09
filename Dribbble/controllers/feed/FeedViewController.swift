//
//  FeedViewController.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 18.01.17.
//  Copyright (c) 2017 Lobanov Aleksey. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Infinity
import Kingfisher
import Font_Awesome_Swift

class FeedViewController: UIViewController {
  // MARK: properties IBOutlets
  @IBOutlet weak var collectionView: UICollectionView!
  var rightNavButton: UIBarButtonItem!
  
  // MARK: - Properties
  // dependencies
  var viewModel: FeedOutput?
  
  // Private    
  var bag = DisposeBag()
  
  // MARK: Life Cycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    FeedConfigurator.configure(viewController: self)
  }
  
  // MARK: - View Live Circle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    self.configureUI()
    try! self.configureRx()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: Configuration
  
  func configureRx() throws {
    guard let model = viewModel else {
      fatalError("Need set view model")
    }
    
    let input = FeedViewModel.Input(changeLayoutTap: self.rightNavButton.rx.tap.asDriver(),
                                    selectedCell: self.collectionView.rx.modelSelected(ModelSectionItem.self).asDriver())
    
    let output = model.configure(input: input)
    
    /// Binding output
    
    output.title.bind(to: self.rx.title).disposed(by: bag)
    
    output.loadingState.subscribe(onNext: {[weak self] (state) in
      switch state {
      case .normal, .error, .empty:
        self?.stopCommentActivity()
        break
      default: break
        // nothing
      }
    }).disposed(by: bag)
    
    output.displayError.subscribe(onNext: { err in
      Popup.showNavError(err)
    }).disposed(by: bag)
    
    /// Push to refresh and infinite scroll
    
    let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    collectionView.fty.pullToRefresh.add(animator: animator) { _ in
      output.refreshTrigger.onNext()
    }
    
    let animator2 = DefaultInfiniteAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    collectionView.fty.infiniteScroll.add(animator: animator2) { _ in
      output.loadNextPageTrigger.onNext()
    }
    
    output.currentLayout.asObservable().subscribe(onNext: {[weak self] layout in
        self?.updateLayout(layout: layout)
    }).disposed(by: bag)
    
    output.paginationState.asObservable().subscribe(onNext: {[weak self] state in
      switch state {
      case .firstPage, .endOfList, .undefined:
        self?.enableInfinityScroll(state: false)
        break
        
      case .morePage:
        self?.enableInfinityScroll(state: true)
        break
      }
    }).addDisposableTo(bag)
    
    /// Refresh first page on start
    
    output.refreshTrigger.onNext()
    
    /// Collection view
    
    let dataSource = RxCollectionViewSectionedAnimatedDataSource<ModelSection>()
    rxTableViewDataSource(dataSource)
    
    output.datasourceItems
      .bind(to: self.collectionView.rx.items(dataSource: dataSource))
      .addDisposableTo(bag)
  }
  
  func configureUI() {
    self.rightNavButton = UIBarButtonItem(image: nil, style: UIBarButtonItemStyle.done, target: nil, action: nil)
    self.navigationItem.rightBarButtonItem = self.rightNavButton
    
    collectionView.registerCell(by: ShotSmallCell.cellIdentifier)
  }
  
  // MARK: - Action
  
  // MARK: - Additional
  
  func updateLayout(layout: CurrentLayout) {
    self.rightNavButton.FAIcon = layout.icon
    self.collectionView?.setCollectionViewLayout(createLayout(layout), animated: true)
  }
  
  func enableInfinityScroll(state: Bool) {
    self.collectionView.fty.infiniteScroll.isEnabled = state
  }
  
  func stopCommentActivity() {
    delay(1, closure: {
      self.collectionView.fty.infiniteScroll.end()
      self.collectionView.fty.pullToRefresh.end()
    })
  }
  
  deinit {
    print("FeedViewController dead")

    collectionView.fty.pullToRefresh.remove()
    collectionView.fty.infiniteScroll.remove()
    collectionView.fty.clear()
  }
}


