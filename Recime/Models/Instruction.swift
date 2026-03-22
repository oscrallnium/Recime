//
//  Instruction.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/23/26.
//

struct Instruction: Codable, Identifiable, Hashable {
    var id: Int { step }
    let step: Int
    let title: String
    let description: String
    let timerMinutes: Int?
}
