//
//  DropAturanThreshold.swift
//  OranGoServer
//
//  Created by Davin P on 19/08/26.
//


import Fluent

struct DropAturanThreshold: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("aturan_threshold").delete()
    }
    func revert(on database: Database) async throws {
        try await database.schema("aturan_threshold")
            .field("id", .int, .identifier(auto: true))
            .field("retail_grade_id", .int, .required, .references("retail_grade", "id"))
            .field("diameter_min", .double)
            .field("diameter_maks", .double)
            .field("berat_min", .double)
            .field("berat_maks", .double)
            .field("warna_oranye", .double)
            .unique(on: "retail_grade_id")
            .create()
    }
}