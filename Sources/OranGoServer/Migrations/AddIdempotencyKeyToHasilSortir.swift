//
//  AddIdempotencyKeyToHasilSortir.swift
//  OranGoServer
//
//  Created by Davin P on 16/08/26.
//


import Fluent

struct AddIdempotencyKeyToHasilSortir: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("hasil_sortir")
            .field("idempotency_key", .string)
            .unique(on: "idempotency_key")
            .update()
    }
    func revert(on database: Database) async throws {
        try await database.schema("hasil_sortir")
            .deleteField("idempotency_key")
            .update()
    }
}