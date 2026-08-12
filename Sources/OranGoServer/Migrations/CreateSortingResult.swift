//
//  CreateSortingResult.swift
//  OranGoServer
//
//  Created by Davin P on 11/08/26.
//


import Fluent

struct CreateSortingResult: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("sorting_results")
            .id()
            .field("batch_id", .string, .required)
            .field("grade", .string, .required)
            .field("weight_gram", .double, .required)
            .field("diameter_cm", .double, .required)
            .field("orange_color_percent", .double, .required)
            .field("device_id", .string, .required)
            .field("created_at", .datetime)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("sorting_results").delete()
    }
}
