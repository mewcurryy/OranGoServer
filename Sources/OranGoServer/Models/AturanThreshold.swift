//
//  AturanThreshold.swift
//  OranGoServer
//
//  Created by Davin P on 16/08/26.
//


import Fluent
import Vapor

final class AturanThreshold: Model, Content, @unchecked Sendable {
    static let schema = "aturan_threshold"

    @ID(custom: .id, generatedBy: .database)
    var id: Int?

    @Parent(key: "retail_grade_id")
    var retailGrade: RetailGrade

    @OptionalField(key: "diameter_min")
    var diameterMin: Double?

    @OptionalField(key: "diameter_maks")
    var diameterMaks: Double?

    @OptionalField(key: "berat_min")
    var beratMin: Double?

    @OptionalField(key: "berat_maks")
    var beratMaks: Double?

    @OptionalField(key: "warna_oranye")
    var warnaOranye: Double?

    init() {}

    init(id: Int? = nil, retailGradeID: RetailGrade.IDValue,
         diameterMin: Double? = nil, diameterMaks: Double? = nil,
         beratMin: Double? = nil, beratMaks: Double? = nil, warnaOranye: Double? = nil) {
        self.id = id
        self.$retailGrade.id = retailGradeID
        self.diameterMin = diameterMin
        self.diameterMaks = diameterMaks
        self.beratMin = beratMin
        self.beratMaks = beratMaks
        self.warnaOranye = warnaOranye
    }
}
