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

class FeedViewController: UIViewController, FeedInput {
  // MARK: properties IBOutlets
  @IBOutlet weak var testRequest: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  
  // MARK: - Properties
  // dependencies
  var viewModel: FeedOutput?
  var dataSource: RxCollectionViewSectionedAnimatedDataSource<ModelSection>?
  
  // Private    
  var disposeBag: DisposeBag = DisposeBag()
  var currentLayout: CurrentLayout = CurrentLayout.medium
  
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
    self.configureRx()
    self.confRxCollectionView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    self.viewModel?.router.passDataToNextScene(segue: segue)
  }
  
  // MARK: Configuration
  
  func configureRx() {
    guard let model = viewModel else { return }
    model.confRx(signin: Driver.just())
    
    model.title.asObservable()
      .bindTo(self.rx.title)
      .disposed(by: disposeBag)
    
    model.loadingState.subscribe(onNext: {[weak self] (state) in
      switch state {
      case .normal, .error, .empty:
        delay(1, closure: { 
          self?.collectionView.fty.infiniteScroll.end()
          self?.collectionView.fty.pullToRefresh.end()
        })
        break
      default: break
        // nothing
      }
    }).disposed(by: disposeBag)
    
    model.displayError.subscribe(onNext: { err in
      Popup.showNavError(err)
    }).disposed(by: disposeBag)
    
    let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    collectionView.fty.pullToRefresh.add(animator: animator) { _ in
      model.refreshTrigger.onNext()
    }
    
    let animator2 = DefaultInfiniteAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    collectionView.fty.infiniteScroll.add(animator: animator2) { _ in
      model.loadNextPageTrigger.onNext()
    }
    
    // refresh first page on start
    model.refreshTrigger.onNext()
  }
  
  func configureUI() {
    self.title = "RxController"
    
  }
  
  // MARK: - Action
  
  // MARK: - FeedInput
//  func show(error: NSError) {
//    
//  }
  
  // MARK: - Additional
  
  deinit {
    print("FeedViewController dead")
    
    collectionView.fty.pullToRefresh.remove()
    collectionView.fty.infiniteScroll.remove()
    collectionView.fty.clear()
  }
}


