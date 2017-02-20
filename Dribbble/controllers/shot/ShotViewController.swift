//
//  ShotViewController.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 11.02.17.
//  Copyright (c) 2017 Lobanov Aleksey. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Infinity

class ShotViewController: UIViewController, ShotInput {
  
  // MARK: properties IBOutlets
  // properties
  @IBOutlet weak var tableView: UITableView!
    
  // MARK: - Properties
  // dependencies
  var viewModel: ShotOutput?
  
  // Private
  var bag: DisposeBag = DisposeBag()
  var dataSource: RxTableViewSectionedAnimatedDataSource<ModelSection>?
  
  // MARK: Life Cycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
//    ShotConfigurator.configure(self)
  }
  
  // MARK: - View Live Circle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    self.configureUI()
    self.confRxTableView()
    self.configureRx()
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
    model.confRx()
    
    model.title.asObservable()
      .bindTo(self.rx.title)
      .addDisposableTo(bag)
    
    model.loadingState.subscribe(onNext: {[weak self] (state) in
      switch state {
      case .normal, .error, .empty:
        delay(3, closure: {
          self?.tableView.fty.infiniteScroll.end()
          self?.tableView.fty.pullToRefresh.end()
        })
        break
      default: break
        // nothing
      }
    }).disposed(by: bag)
    
    model.displayError.subscribe(onNext: { err in
      Popup.showNavError(err)
    }).disposed(by: bag)
    
    // refresh first page on start
    model.refreshComments()
    
    let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 10, width: 24, height: 24))
    tableView.fty.pullToRefresh.add(animator: animator) { _ in
      model.refreshComments()
    }
    
    let animator2 = DefaultInfiniteAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    tableView.fty.infiniteScroll.add(animator: animator2) { _ in
      model.obtainCommentsNextPage()
    }
    
    tableView.fty
  }
  
  func configureUI() {
    self.title = "RxController"
  }
  
  // MARK: - Action
  
  // MARK: - ShotInput
//  func show(error: NSError) {
//    
//  }
  
  // MARK: - Additional
  
  deinit {
    tableView.fty.pullToRefresh.remove()
    tableView.fty.infiniteScroll.remove()
    tableView.fty.clear()
    print("ShotViewController dead")
  }
}


