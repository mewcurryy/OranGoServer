//
//  SortingResult.swift
//  OranGoServer
//
//  Created by Davin P on 11/08/26.
//


import Fluent
import Vapor

final class SortingResult: Model, Content, @unchecked Sendable {
    static let schema = "sorting_results"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "batch_id")
    var batchId: String

    @Field(key: "grade")              // "A", "B", "C", "Edible", "Reject"
    var grade: String

    @Field(key: "weight_gram")
    var weightGram: Double

    @Field(key: "diameter_cm")
    var diameterCm: Double

    @Field(key: "orange_color_percent")
    var orangeColorPercent: Double

    @Field(key: "device_id")          // misal "MesinSorting1"
    var deviceId: String

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() {}

    init(id: UUID? = nil, batchId: String, grade: String, weightGram: Double,
         diameterCm: Double, orangeColorPercent: Double, deviceId: String) {
        self.id = id
        self.batchId = batchId
        self.grade = grade
        self.weightGram = weightGram
        self.diameterCm = diameterCm
        self.orangeColorPercent = orangeColorPercent
        self.deviceId = deviceId
    }
}