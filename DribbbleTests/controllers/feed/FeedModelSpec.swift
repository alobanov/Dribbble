//
//  FeedModelSpec.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 20.01.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

import Quick
import Nimble
import RxSwift
import RxCocoa
import RealmSwift


@testable
import Dribbble

//class FeedControllerMock: FeedInput {
//  
//}
//
//class FeedRouterMock: FeedRouterInput {
//  func passDataToNextScene(segue: UIStoryboardSegue){}
//  func navigateToShot(byId: Int){}
//}
//
//class FeedModelSpec: QuickSpec {
//  
//  var modelPublic: FeedOutput!
//  var modelTestable: FeedViewModelTestable!
//  var bag: DisposeBag = DisposeBag()
//  var api = Networking.mockNetworking()
//  var appSettings = AppSettingsStorage.shared
//  
//  override func spec() {
//    describe("Feed items request") {
//      
//      var testRealm: Realm!
//      
//      beforeSuite {
//        testRealm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "test"))
//        let model: FeedViewModel = FeedViewModel(dependencies: FeedViewModel.InputDependencies(view: FeedControllerMock(), router: FeedRouterMock(), api: self.api, realm: testRealm, appSettings: self.appSettings))
//        
//        self.modelPublic = model as FeedOutput
//        self.modelTestable = model as FeedViewModelTestable
//        
//        let btn = UIButton()
//        let btnDriver = btn.rx.tap.asDriver()
//        self.modelPublic.confRx(changeLayoutTap: btnDriver)
//        btn.sendActions(for: .touchUpInside)
//      }
//      
//      describe("Pagination test") {
//        it("Subscribu to datasource") {
//          var page=1
//          
//          self.modelPublic.datasourceItems.asObservable()
//            // skip 2 step: 1. Initialization with []; 2. first empty cache
//            .skip(2)
//            .subscribe(onNext: { list in
//              
//              if page == 1 {
//                let section: ModelSection = list[0]
//                expect(section.items.count).to(equal(50)) // Have 100 elements
//              }
//              
//              if page == 2 {
//                let section: ModelSection = list[0]
//                expect(section.items.count).to(equal(100)) // Have 100 elements
//              }
//              
//              page+=1
//            }).addDisposableTo(self.bag)
//        }
//        
//        it("Obtain first page") {
//          self.modelPublic.refreshTrigger.onNext()
//        }
//        
//        it("Obtain second page") {
//          waitUntil(timeout: 1) { done in
//            self.modelPublic.loadNextPageTrigger.onNext()
//            done()
//          }
//        }
//      }
//    
//      describe("Test private methods") {
//        it("load first page and test private methods") {
//          NetworkMock.api.request(DribbbleAPI.shots(page: 1, list: nil, timeframe: nil, date: nil, sort: nil))
//            .mapJSONObjectArray(ShotModel.self)
//            .subscribe(onNext: { shots in
//              
//              // TEST prepare DB model for datasource
//              let ponsoItems = shots.map { $0.feedModel() }
//              let wrappedShotModels = self.modelTestable.prepareForDatasource(list: ponsoItems)
//              expect(wrappedShotModels.count).to(equal(1))
//              
//              // TEST of single section model
//              let section: ModelSection = wrappedShotModels[0]
//              expect(section.items.count).to(equal(50))
//              
//              // TEST of section item model (ponso)
//              let sectionItem: ModelSectionItem = section.items[0]
//              expect(sectionItem.model.unic).toEventuallyNot(beNil())
//              expect(sectionItem.model.unic).to(equal("2017-01-18T10:00:03Z3224893"))
//              
//              // TEST of realm, all objects saved in previus testcase
//              let items = testRealm.objects(ShotModel.self)
//              expect(items.count).to(equal(100))
//              
//              // TEST saving firs page in Userdefaults
//              self.modelTestable.saveFirstPage(by: ponsoItems)
//              let cachedPonsoShots = self.modelTestable.prepareFirstPageFromCache()
//              expect(cachedPonsoShots.count).to(equal(50))
//              
//            }).addDisposableTo(self.bag)
//        }
//      }
//    }
//  }
//}
