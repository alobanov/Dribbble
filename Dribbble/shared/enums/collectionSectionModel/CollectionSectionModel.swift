//
//  CollectionSectionModel.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 18.01.17.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import RxDataSources

protocol ModelItemDatasourseble {
  var unic: String? { get }
}

extension Array where Element : ModelItemDatasourseble {
  func prepareForDatasource() -> [ModelSection] {
    var renderItemsData: [ModelSectionItem] = []
    renderItemsData = self.map { ModelSectionItem(model: $0) }
    return [ModelSection(items: renderItemsData)]
  }
}

/**
 *  Reloadeble protocol for all registration cell
 */
protocol CellReloadeble {
  func reload(with model: ModelItemDatasourseble)
}

/**
 Datasource model (based on RxDatasource)
 
 - PersonalInformationSection: section of personal information
 */

struct ModelSection {
  var header: String
  var items: [ModelSectionItem]
  
  init(items: [ModelSectionItem], header: String = "") {
    self.header = header
    self.items = items
  }
}

extension ModelSection: AnimatableSectionModelType {
  typealias Item = ModelSectionItem
  typealias Identity = String
  
  var identity: String {
    return header
  }
  
  
  
  init(original: ModelSection, items: [Item]) {
    self = original
    self.items = items
  }
}

struct ModelSectionItem {
  var model: ModelItemDatasourseble
  
  init(model: ModelItemDatasourseble) {
    self.model = model
  }
}

extension ModelSectionItem: IdentifiableType, Equatable {
  var identity: String {
    return model.unic ?? "undifined unic"
  }
}

// equatable, this is needed to detect changes
func == (lhs: ModelSectionItem, rhs: ModelSectionItem) -> Bool {
  return lhs.identity == rhs.identity
}
