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

class FeedControllerMock: FeedInput {
  
}

class FeedRouterMock: FeedRouterInput {
  func passDataToNextScene(segue: UIStoryboardSegue) {}
  func navigateTo() {}
}

class FeedModelSpec: QuickSpec {
  
  var model: FeedViewModel!
  var modelTestable: FeedViewModelTestable!
  var bag: DisposeBag = DisposeBag()
  var api = Networking.mockNetworking()
  var appSettings = AppSettingsStorage.shared
  
  override func spec() {
    describe("Feed items request") {
      
      var testRealm: Realm!
      
      beforeEach {
        testRealm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "test"))
        self.model = FeedViewModel(dependencies: (view: FeedControllerMock(), router: FeedRouterMock(), api: self.api, realm: testRealm, appSettings: self.appSettings))
        self.modelTestable = self.model as FeedViewModelTestable
      }
      
      it("test public protocol FeedOutput") {
        self.model.items
          .skip(2) // skip twice !!!
          .subscribe(onNext: { list in
            expect(list.count).to(equal(1))
            let section: ModelSection = list[0]
            expect(section.items.count).to(equal(50))
        }).addDisposableTo(self.bag)
        
        let btn = UIButton()
        let btnDriver = btn.rx.tap.asDriver()
        
        self.model.confRx(signin: btnDriver)
        btn.sendActions(for: .touchUpInside)
        
        self.model.title.asObservable()
          .subscribe(onNext: { s in
            expect(s).to(equal("Rx Request"))
          }).addDisposableTo(self.bag)
      }
      
      it("test private potocol FeedViewModelTestable") {
        NetworkMock.api.request(DribbbleAPI.shots(page: 1, list: nil, timeframe: nil, date: nil, sort: nil))
          .mapJSONObjectArray(ShotModel.self, realm: testRealm)
          .subscribe(onNext: { shots in
            let wrappedShotModels = self.modelTestable.prepareShotList(list: shots)
            
            // TEST of mock request result
            expect(wrappedShotModels.count).to(equal(1))
            
            // TEST of section
            let section: ModelSection = wrappedShotModels[0]
            expect(section.identity).to(equal(""))
            
            // TEST of section item
            let sectionItem: ModelSectionItem = section.items[0]
            expect(sectionItem.model.unic).toEventuallyNot(beNil())
            expect(sectionItem.model.unic).to(equal("Optional(2017-01-18T10:00:03Z)"))
            
            // TEST of realm object saving
            let items = testRealm.objects(ShotModel.self)
            expect(items.count).to(equal(50))
            
            // TEST saving firs page
            self.modelTestable.saveFirstPageIDs(ids: [3225396,3224770])
            let cachedShots = self.modelTestable.prepareShotsFirstPage()
            expect(cachedShots[0].items.count).to(equal(2))
            
          }).addDisposableTo(self.bag)
      }
      
    }
  }
}
