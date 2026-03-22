//
//  ServingsFilter.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/23/26.
//

enum ServingsFilter: String, CaseIterable, Identifiable {
    case all    = "All"
    case small  = "1–2"
    case medium = "3–4"
    case large  = "5+"
 
    var id: String { rawValue }
 
    func matches(_ servings: Int) -> Bool {
        switch self {
        case .all:    true
        case .small:  servings <= 2
        case .medium: (3...4).contains(servings)
        case .large:  servings >= 5
        }
    }
}
