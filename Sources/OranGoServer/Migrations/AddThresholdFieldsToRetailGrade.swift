//
//  AddThresholdFieldsToRetailGrade.swift
//  OranGoServer
//
//  Created by Davin P on 19/08/26.
//


import Fluent

struct AddThresholdFieldsToRetailGrade: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("retail_grade")
            .field("diameter_min", .double)
            .field("diameter_maks", .double)
            .field("berat_min", .double)
            .field("berat_maks", .double)
            .field("warna_oranye", .double)
            .update()
    }
    func revert(on database: Database) async throws {
        try await database.schema("retail_grade")
            .deleteField("diameter_min")
            .deleteField("diameter_maks")
            .deleteField("berat_min")
            .deleteField("berat_maks")
            .deleteField("warna_oranye")
            .update()
    }
}