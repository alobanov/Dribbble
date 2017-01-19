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
    model.confRx(signin: testRequest.rx.tap.asDriver())
    
    model.title.asObservable()
      .bindTo(self.rx.title)
      .addDisposableTo(disposeBag)
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
  }
}


