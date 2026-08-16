//
//  CreateBatch.swift
//  OranGoServer
//
//  Created by Davin P on 16/08/26.
//


import Fluent

struct CreateBatch: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("batch")
            .field("id", .int, .identifier(auto: true))
            .field("machine_id", .int, .required, .references("machine", "id"))
            .field("retail_grade_id", .int, .required, .references("retail_grade", "id"))
            .field("kode_batch", .string, .required)
            .field("mulai_pada", .datetime, .required)
            .field("selesai_pada", .datetime)
            .unique(on: "kode_batch")
            .create()
    }
    func revert(on database: any Database) async throws {
        try await database.schema("batch").delete()
    }
}
