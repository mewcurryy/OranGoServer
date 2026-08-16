//
//  CreateAturanThreshold.swift
//  OranGoServer
//
//  Created by Davin P on 16/08/26.
//


import Fluent

struct CreateAturanThreshold: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("aturan_threshold")
            .field("id", .int, .identifier(auto: true))
            .field("retail_grade_id", .int, .required, .references("retail_grade", "id"))
            .field("grade_id", .int, .required, .references("grade", "id"))
            .field("diameter_min", .double)
            .field("diameter_maks", .double)
            .field("berat_min", .double)
            .field("berat_maks", .double)
            .field("warna_oranye", .double)
            .unique(on: "retail_grade_id", "grade_id")
            .create()
    }
    func revert(on database: any Database) async throws {
        try await database.schema("aturan_threshold").delete()
    }
}
