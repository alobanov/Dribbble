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
  
  override func spec() {
    describe("Feed items request") {
      
      var testRealm: Realm!
      
      beforeEach {
        testRealm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "test"))
        self.model = FeedViewModel(dependencies: (view: FeedControllerMock(), router: FeedRouterMock(), api: self.api))
        self.modelTestable = self.model as FeedViewModelTestable
      }
      
      it("test public protocol FeedOutput") {
        self.model.items.skip(1).subscribe(onNext: { list in
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
            expect(wrappedShotModels.count).to(equal(1))
            
            let section: ModelSection = wrappedShotModels[0]
            // TEST of section
            expect(section.identity).to(equal(""))
            
            let sectionItem: ModelSectionItem = section.items[0]
            // TEST of section item
            expect(sectionItem.identity).to(equal("3224893"))
            expect(sectionItem.model.unic).toEventuallyNot(beNil())
            expect(sectionItem.model.unic).to(equal("3224893"))
            
            let items = testRealm.objects(ShotModel.self)
            // TEST of realm object saving
            expect(items.count).to(equal(50))
            
          }).addDisposableTo(self.bag)
      }
      
    }
  }
}
