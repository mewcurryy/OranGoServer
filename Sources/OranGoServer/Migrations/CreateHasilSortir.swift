//
//  CreateHasilSortir.swift
//  OranGoServer
//
//  Created by Davin P on 16/08/26.
//


import Fluent

struct CreateHasilSortir: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("hasil_sortir")
            .field("id", .int, .identifier(auto: true))
            .field("batch_id", .int, .required, .references("batch", "id"))
            .field("grade_id", .int, .required, .references("grade", "id"))
            .field("retail_grade_id", .int, .required, .references("retail_grade", "id"))
            .field("waktu_scan", .datetime, .required)
            .field("diameter", .double, .required)
            .field("berat", .double, .required)
            .field("warna_oranye", .double, .required)
            .field("bentuk_wajar", .bool, .required)
            .create()
    }
    func revert(on database: any Database) async throws {
        try await database.schema("hasil_sortir").delete()
    }
}
