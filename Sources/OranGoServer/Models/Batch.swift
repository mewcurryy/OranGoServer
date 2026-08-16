//
//  Batch.swift
//  OranGoServer
//
//  Created by Davin P on 16/08/26.
//


import Fluent
import Vapor

final class Batch: Model, Content, @unchecked Sendable {
    static let schema = "batch"

    @ID(custom: .id, generatedBy: .database)
    var id: Int?

    @Parent(key: "machine_id")
    var machine: Machine

    @Parent(key: "retail_grade_id")
    var retailGrade: RetailGrade

    @Field(key: "kode_batch")
    var kodeBatch: String

    @Field(key: "mulai_pada")
    var mulaiPada: Date

    @OptionalField(key: "selesai_pada")
    var selesaiPada: Date?

    init() {}

    init(id: Int? = nil, machineID: Machine.IDValue, retailGradeID: RetailGrade.IDValue,
         kodeBatch: String, mulaiPada: Date, selesaiPada: Date? = nil) {
        self.id = id
        self.$machine.id = machineID
        self.$retailGrade.id = retailGradeID
        self.kodeBatch = kodeBatch
        self.mulaiPada = mulaiPada
        self.selesaiPada = selesaiPada
    }
}