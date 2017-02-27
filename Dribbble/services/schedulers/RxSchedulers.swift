//
//  RxSchedulers.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 09.08.16.
//  Copyright © 2016 Lobanov Aleksey. All rights reserved.
//

import Foundation
import RxSwift

class Schedulers {
  static let shared = Schedulers() // Singletone
  
  let backgroundWorkScheduler: ImmediateSchedulerType
  let mainScheduler: SerialDispatchQueueScheduler
  
  let queueRequestNetwork: DispatchQueue! // single
  
  let backgroundQueue: DispatchQueue! // single
  
  private init() {
    let operationQueue = OperationQueue()
    operationQueue.maxConcurrentOperationCount = 1
    operationQueue.qualityOfService = QualityOfService.userInitiated
    backgroundWorkScheduler = OperationQueueScheduler(operationQueue: operationQueue)
    
    queueRequestNetwork = DispatchQueue(label: "ru.dribbble", attributes: DispatchQueue.Attributes.concurrent)
    
    mainScheduler = MainScheduler.instance
    backgroundQueue = DispatchQueue(label: "ru.dribbble.lobanov", qos: .background, attributes: [.concurrent])
  }
}
