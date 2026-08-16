//
//  RetailGrade.swift
//  OranGoServer
//
//  Created by Davin P on 16/08/26.
//


import Fluent
import Vapor

final class RetailGrade: Model, Content, @unchecked Sendable {
    static let schema = "retail_grade"

    @ID(custom: .id, generatedBy: .database)
    var id: Int?

    @Field(key: "retail_name")
    var retailName: String

    @Timestamp(key: "dibuat_pada", on: .create)
    var dibuatPada: Date?

    @Field(key: "aktif")
    var aktif: Bool

    @OptionalField(key: "catatan")
    var catatan: String?

    init() {}

    init(id: Int? = nil, retailName: String, aktif: Bool = false, catatan: String? = nil) {
        self.id = id
        self.retailName = retailName
        self.aktif = aktif
        self.catatan = catatan
    }
}