//
//  CreateMachine.swift
//  OranGoServer
//
//  Created by Davin P on 16/08/26.
//


import Fluent

struct CreateMachine: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("machine")
            .field("id", .int, .identifier(auto: true))
            .field("machine_name", .string, .required)
            .field("lokasi", .string)
            .field("status_koneksi", .string, .required)
            .field("terakhir_terlihat", .datetime)
            .field("threshold_aktif_id", .int, .required, .references("retail_grade", "id"))
            .unique(on: "machine_name")
            .create()
    }
    func revert(on database: any Database) async throws {
        try await database.schema("machine").delete()
    }
}
