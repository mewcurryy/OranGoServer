//
//  CreateRetailGrade.swift
//  OranGoServer
//
//  Created by Davin P on 16/08/26.
//


import Fluent
import FluentSQL

struct CreateRetailGrade: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("retail_grade")
            .field("id", .int, .identifier(auto: true))
            .field("retail_name", .string, .required)
            .field("dibuat_pada", .datetime, .required)
            .field("aktif", .bool, .required, .sql(.default(false)))
            .field("catatan", .string)
            .create()
    }
    func revert(on database: any Database) async throws {
        try await database.schema("retail_grade").delete()
    }
}
