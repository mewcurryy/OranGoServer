//
//  AlterAturanThresholdRemoveGrade.swift
//  OranGoServer
//
//  Created by Davin P on 17/08/26.
//

import Fluent

struct AlterAturanThresholdRemoveGrade: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("aturan_threshold")
            .deleteUnique(on: "retail_grade_id", "grade_id")
            .deleteField("grade_id")
            .unique(on: "retail_grade_id")
            .update()
    }
    func revert(on database: any Database) async throws {
        try await database.schema("aturan_threshold")
            .deleteUnique(on: "retail_grade_id")
            .field("grade_id", .int, .required, .references("grade", "id"))
            .unique(on: "retail_grade_id", "grade_id")
            .update()
    }
}
