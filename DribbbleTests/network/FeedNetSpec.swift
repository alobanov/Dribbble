//
//  FeedNetSpec.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 18.01.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

import Quick
import Nimble
import RxSwift

@testable
import Dribbble

class FeedNetSpec: QuickSpec {
  
  var shots: [ShotModel]?
  var bag: DisposeBag = DisposeBag()
  
  override func spec() {
    describe("Feed items request") {

      beforeEach {
        NetworkMock.api.request(DribbbleAPI.shots(page: 1, list: nil, timeframe: nil, date: nil, sort: nil))
          .mapJSONObjectArray(ShotModel.self)
          .subscribe(onNext: { shots in
            self.shots = shots
          }).addDisposableTo(self.bag)
      }

      it("not empty") {
        expect(self.shots?.count).to(equal(50))
        expect(self.shots?[0]).toEventuallyNot(beNil())
      }
      
      it("Contain first shot") {
        if let shot = self.shots?[0] {
          // numbers
          expect(shot.comments).to(equal(17))
          expect(shot.height).to(equal(300))
          expect(shot.width).to(equal(400))
          expect(shot.likes).to(equal(377))
          expect(shot.shotId).to(equal(3224893))
          
          // dates
          let formatter = DateFormatter()
          formatter.timeZone = TimeZone(secondsFromGMT: 0)
          formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
          formatter.locale = NSLocale.current as Locale!
          formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
          
          let created_at = formatter.date(from: "2017-01-18T10:00:01Z")!
          let updated_at = formatter.date(from: "2017-01-18T10:00:03Z")!
          
          expect(shot.created_at as? Date).to(equal(created_at))
          expect(shot.updated_at as? Date).to(equal(updated_at))
          
          // nested objects
          expect(shot.image).toEventuallyNot(beNil())
          expect(shot.user).toEventuallyNot(beNil())
        }
      }
    }
  }
}
