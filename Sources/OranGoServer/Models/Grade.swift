//
//  Grade.swift
//  OranGoServer
//
//  Created by Davin P on 16/08/26.
//


import Fluent
import Vapor

final class Grade: Model, Content, @unchecked Sendable {
    static let schema = "grade"

    @ID(custom: .id, generatedBy: .database)
    var id: Int?

    @Field(key: "kelas_grading")
    var kelasGrading: String   // "A", "B", "C", "EDIBLE", "REJECT"

    @Field(key: "label")
    var label: String

    @Field(key: "warna_tampilan")
    var warnaTampilan: String

    init() {}

    init(id: Int? = nil, kelasGrading: String, label: String, warnaTampilan: String) {
        self.id = id
        self.kelasGrading = kelasGrading
        self.label = label
        self.warnaTampilan = warnaTampilan
    }
}