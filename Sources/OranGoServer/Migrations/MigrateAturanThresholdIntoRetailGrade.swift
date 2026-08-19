//
//  MigrateAturanThresholdIntoRetailGrade.swift
//  OranGoServer
//
//  Created by Davin P on 19/08/26.
//


import Fluent
import FluentSQL

struct MigrateAturanThresholdIntoRetailGrade: AsyncMigration {
    func prepare(on database: Database) async throws {
        guard let sql = database as? SQLDatabase else { return }
        try await sql.raw("""
            UPDATE retail_grade rg
            SET diameter_min = at.diameter_min,
                diameter_maks = at.diameter_maks,
                berat_min = at.berat_min,
                berat_maks = at.berat_maks,
                warna_oranye = at.warna_oranye
            FROM aturan_threshold at
            WHERE at.retail_grade_id = rg.id
        """).run()
    }
    func revert(on database: Database) async throws {
        // data migration, sengaja no-op saat revert
    }
}