//
//  HasilSortir.swift
//  OranGoServer
//
//  Created by Davin P on 16/08/26.
//

import Fluent
import Vapor

final class HasilSortir: Model, Content, @unchecked Sendable {
    static let schema = "hasil_sortir"

    @ID(custom: .id, generatedBy: .database)
    var id: Int?

    @Parent(key: "batch_id")
    var batch: Batch

    @Parent(key: "grade_id")
    var grade: Grade

    @Parent(key: "retail_grade_id")
    var retailGrade: RetailGrade

    @Field(key: "waktu_scan")
    var waktuScan: Date

    @Field(key: "diameter")
    var diameter: Double

    @Field(key: "berat")
    var berat: Double

    @Field(key: "warna_oranye")
    var warnaOranye: Double

    @Field(key: "bentuk_wajar")
    var bentukWajar: Bool

    init() {}

    init(id: Int? = nil, batchID: Batch.IDValue, gradeID: Grade.IDValue, retailGradeID: RetailGrade.IDValue,
         waktuScan: Date, diameter: Double, berat: Double, warnaOranye: Double, bentukWajar: Bool) {
        self.id = id
        self.$batch.id = batchID
        self.$grade.id = gradeID
        self.$retailGrade.id = retailGradeID
        self.waktuScan = waktuScan
        self.diameter = diameter
        self.berat = berat
        self.warnaOranye = warnaOranye
        self.bentukWajar = bentukWajar
    }
}
