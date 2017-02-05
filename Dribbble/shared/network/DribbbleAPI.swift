//
//  DribbbleAPI.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 18.01.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Alamofire

private extension String {
  var URLEscapedString: String {
    return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
  }
}

enum DribbbleAPI {
  //
  // Shots http://developer.dribbble.com/v1/shots/
  //
  case shots(page: Int, list: String?, timeframe: String?, date: Date?, sort: String?)
}

extension DribbbleAPI : TargetType {
  /// The method used for parameter encoding.
  public var parameterEncoding: ParameterEncoding {
    return URLEncoding.default
  }
  
  public var task: Task {
    switch self {
    default:
      return .request
    }
  }
  
  var base: String { return "https://api.dribbble.com/v1/" }
  var baseURL: URL {
    return URL(string: base)!
  }
  
  var path: String {
    switch self {
    case .shots(_, _, _, _, _):
      return "shots"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .shots:
      return HTTPMethod.get
    }
  }
  
  var parameters: [String: Any]? {
    switch self {
    case .shots(let page, let list, let timeframe, let date, let sort):
      var shotsPrm = [String: AnyObject]()
      shotsPrm["page"] = page as AnyObject?
      shotsPrm["per_page"] = 50 as AnyObject?
      if let l = list {shotsPrm["list"] = l as AnyObject?}
      if let t = timeframe {shotsPrm["timeframe"] = t as AnyObject?}
      if let d = date {shotsPrm["date"] = d as AnyObject?}
      if let s = sort {shotsPrm["sort"] = s as AnyObject?}
      print(shotsPrm)
      
      return shotsPrm
    }
  }
  
  var sampleData: Data {
    switch self {
    case .shots(let page, _, _, _, _):
      if page == 1 {
        return JSONReader.readJSONData("Feed")
      }
      
      return JSONReader.readJSONData("FeedPage2")
    }
  }
  
  var multipartBody: [Moya.MultipartFormData]? {
    return []
    //    switch self {
    //    case .registrateNewClient(_, _, let imageData):
    //      guard let data = imageData else { return nil }
    //      let mdata = MultipartFormData(provider: .data(data), name: "file_avatar", fileName: "photo.jpg", mimeType: "image/jpeg")
    //      return [mdata]
    //    default:
    //      return []
    //    }
  }
}

func urlTransform(_ route: TargetType) -> String {
  return route.baseURL.appendingPathComponent(route.path).absoluteString
}
