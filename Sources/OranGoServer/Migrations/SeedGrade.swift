//
//  SeedGrade.swift
//  OranGoServer
//
//  Created by Davin P on 16/08/26.
//


import Fluent

struct SeedGrade: AsyncMigration {
    func prepare(on database: any Database) async throws {
        let rows: [(String, String, String)] = [
            ("A", "Grade A", "#FFFFFF"),      // putih
            ("B", "Grade B", "#007AFF"),      // biru
            ("C", "Grade C", "#FFCC00"),      // kuning
            ("EDIBLE", "Edible", "#FF9500"),  // oren
            ("REJECT", "Reject", "#FF3B30")   // merah
        ]
        for row in rows {
            try await Grade(kelasGrading: row.0, label: row.1, warnaTampilan: row.2)
                .save(on: database)
        }
    }
    func revert(on database: any Database) async throws {
        try await Grade.query(on: database).delete()
    }
}
