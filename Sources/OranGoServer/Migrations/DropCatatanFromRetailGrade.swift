//
//  DropCatatanFromRetailGrade.swift
//  OranGoServer
//
//  Created by Davin P on 19/08/26.
//


import Fluent

struct DropCatatanFromRetailGrade: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("retail_grade")
            .deleteField("catatan")
            .update()
    }
    func revert(on database: Database) async throws {
        try await database.schema("retail_grade")
            .field("catatan", .string)
            .update()
    }
}