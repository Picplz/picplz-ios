//
//  Concept.swift
//  Features
//
//  Created by 임영택 on 3/18/26.
//

/// 뷰에서만 사용할 분위기 모델
public struct Concept: Identifiable, Equatable, Hashable {
  public let id: Int
  public var keyword: String
  public var isSelected: Bool = false
  public let isUserDefined: Bool

  mutating func editKeyword(to newKeyword: String) {
    if isUserDefined {
      keyword = newKeyword
    }
  }

  mutating func toggle() {
    isSelected.toggle()
  }
  
  static var defaultConcepts: [Concept] {
    [
      Concept(id: 0, keyword: "캐주얼", isUserDefined: false),
      Concept(id: 1, keyword: "고급미", isUserDefined: false),
      Concept(id: 2, keyword: "심플", isUserDefined: false),
      Concept(id: 3, keyword: "단아", isUserDefined: false),
      Concept(id: 4, keyword: "몽환적", isUserDefined: false),
      Concept(id: 5, keyword: "빈티지", isUserDefined: false),
      Concept(id: 6, keyword: "청량", isUserDefined: false),
      Concept(id: 7, keyword: "화려", isUserDefined: false),
      Concept(id: 8, keyword: "퇴폐적", isUserDefined: false),
      Concept(id: 9, keyword: "키치", isUserDefined: false),
      Concept(id: 10, keyword: "힙스터", isUserDefined: false),
    ]
  }
}
