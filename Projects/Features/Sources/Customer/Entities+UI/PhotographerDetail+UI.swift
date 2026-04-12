//
//  PhotographerDetail+UI.swift
//  Features
//
//  Created by 임영택 on 4/12/26.
//

import Domain

extension PhotographerDetail {
  var locationsText: String {
    locations.joined(separator: ", ")
  }

  var keywordsText: String {
    keywords.joined(separator: ", ")
  }

  var equipmentsText: String {
    equipments.joined(separator: ", ")
  }
}
