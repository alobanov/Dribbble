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

class ShotViewController: UIViewController {
  
  // MARK: properties IBOutlets
  // properties
  @IBOutlet weak var tableView: UITableView!
    
  // MARK: - Properties
  // dependencies
  var viewModel: ShotOutput?
  
  // Private
  var bag: DisposeBag = DisposeBag()
  var dataSource: RxTableViewSectionedAnimatedDataSource<ModelSection>?
  
  var obtainCommentsNextPage = PublishSubject<Void>()
  var refreshComments = PublishSubject<Void>()
  
  // MARK: Life Cycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  // MARK: - View Live Circle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    self.confUI()
    try! self.configureRx()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Navigation
  
  // MARK: Configuration
  
  func configureRx() throws {
    guard let model = viewModel else {
      fatalError("Need set view model")
    }
    
    let input = ShotViewModel.Input(refreshComments: refreshComments,
                                    obtainComments: obtainCommentsNextPage)
    let output = model.configure(input: input)
    
    output.title.bind(to: self.rx.title).addDisposableTo(bag)
    
    output.loadingState.subscribe(onNext: {[weak self] (state) in
      switch state {
      case .normal, .error, .empty:
        self?.stopCommentActivity()
        break
        
      default: break
        // nothing
      }
    }).disposed(by: bag)

    output.paginationState.asObservable().subscribe(onNext: {[weak self] state in
      switch state {
      case .morePage:
        self?.enableInfinityScroll(state: true)
        break
        
      default:
        self?.enableInfinityScroll(state: false)
        break
      }
    }).addDisposableTo(bag)
    
    output.displayError.subscribe(onNext: { err in
      Popup.showNavError(err)
    }).disposed(by: bag)
    
    // refresh first page on start
    self.refreshComments.onNext()
    
    let animator2 = DefaultInfiniteAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    tableView.fty.infiniteScroll.add(animator: animator2) { [weak self] _ in
      self?.obtainCommentsNextPage.onNext()
    }
    
    let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 10, width: 24, height: 24))
    tableView.fty.pullToRefresh.add(animator: animator) { [weak self] _ in
      self?.refreshComments.onNext()
    }
    tableView.fty.infiniteScroll.isEnabled = false
    
    let dataSource = RxTableViewSectionedAnimatedDataSource<ModelSection>()
    dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .fade,
                                                               reloadAnimation: .fade,
                                                               deleteAnimation: .fade)
    rxTableViewDataSource(dataSource)
    
    output.datasourceItems
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .addDisposableTo(bag)
    
    self.tableView.rx.setDelegate(self).addDisposableTo(bag)
    
    self.dataSource = dataSource
  }
  
  func confUI() {
    self.title = "RxController"
    
    tableView.registerCell(by: CommentShotCell.cellIdentifier)
  }
  
  // MARK: - Additional
  
  func stopCommentActivity() {
    delay(1, closure: {
      self.tableView.fty.infiniteScroll.end()
      self.tableView.fty.pullToRefresh.end()
    })
  }
  
  func enableInfinityScroll(state: Bool) {
    self.tableView.fty.infiniteScroll.isEnabled = state
  }
  
  deinit {
    tableView.fty.pullToRefresh.remove()
    tableView.fty.infiniteScroll.remove()
    tableView.fty.clear()
    print("ShotViewController dead")
  }
}


