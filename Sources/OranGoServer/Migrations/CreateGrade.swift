//
//  CreateGrade.swift
//  OranGoServer
//
//  Created by Davin P on 16/08/26.
//


import Fluent

struct CreateGrade: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("grade")
            .field("id", .int, .identifier(auto: true))
            .field("kelas_grading", .string, .required)
            .field("label", .string, .required)
            .field("warna_tampilan", .string, .required)
            .unique(on: "kelas_grading")
            .create()
    }
    func revert(on database: any Database) async throws {
        try await database.schema("grade").delete()
    }
}
