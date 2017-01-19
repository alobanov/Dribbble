//
//  JSONReader.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 27.07.16.
//  Copyright © 2016 Lobanov Aleksey. All rights reserved.
//

import Foundation
import ObjectMapper

class JSONReader {

  class func readFromJSON<T: Mappable>(_ filename: String) -> T? {
    return Mapper<T>().map(JSONString: JSONReader.readJSONString(filename)!)
  }

  class func readJSONString(_ filename: String) -> String? {
    return String(data: readJSONData(filename), encoding: String.Encoding.utf8)
  }

  class func readJSONData(_ filename: String) -> Data {
    return FileReader.readFileData(filename, fileExtension: "json")
  }

}
