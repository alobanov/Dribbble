//
//  FileReader.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 27.07.16.
//  Copyright © 2016 Lobanov Aleksey. All rights reserved.
//

import Foundation

class FileReader {

  class func readFileData(_ filename: String, fileExtension: String) -> Data {
    if let path = Bundle(for: self).path(forResource: filename, ofType: fileExtension) {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path),
                              options: NSData.ReadingOptions.mappedIfSafe)
        return data
      } catch let error as NSError {
        print(error.localizedDescription)
      }
    } else {
      print("Could not find file: \(filename).\(fileExtension)")
    }
    return Data()
  }

  class func readFileString(_ filename: String, fileExtension: String) -> String {
    return String(data: readFileData(filename, fileExtension: fileExtension),
                  encoding: String.Encoding.utf8) ?? ""
  }
}
