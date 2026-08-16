//
//  HasilSortirController.swift
//  OranGoServer
//
//  Created by Davin P on 16/08/26.
//

import Vapor
import Fluent

struct CreateHasilSortirRequest: Content {
    var batchId: Int
    var gradeKelas: String
    var retailGradeId: Int
    var diameter: Double
    var berat: Double
    var warnaOranye: Double
    var bentukWajar: Bool
}

struct HasilSortirController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let group = routes.grouped("api", "hasil-sortir")
        group.get(use: index)
        group.post(use: create)
    }

    func index(req: Request) async throws -> [HasilSortir] {
        try await HasilSortir.query(on: req.db)
            .sort(\.$waktuScan, .descending)
            .all()
    }

    func create(req: Request) async throws -> HasilSortir {
        guard req.headers.first(name: "X-API-Key") == Environment.get("DEVICE_API_KEY") else {
            throw Abort(.unauthorized)
        }

        guard let idempotencyKey = req.headers.first(name: "Idempotency-Key") else {
            throw Abort(.badRequest, reason: "Idempotency-Key header wajib diisi")
        }

        if let existing = try await HasilSortir.query(on: req.db)
            .filter(\.$idempotencyKey == idempotencyKey)
            .first() {
            return existing
        }

        let input = try req.content.decode(CreateHasilSortirRequest.self)

        guard let grade = try await Grade.query(on: req.db)
            .filter(\.$kelasGrading == input.gradeKelas)
            .first() else {
            throw Abort(.badRequest, reason: "Grade tidak ditemukan")
        }

        let hasil = HasilSortir(
            batchID: input.batchId,
            gradeID: try grade.requireID(),
            retailGradeID: input.retailGradeId,
            waktuScan: Date(),
            diameter: input.diameter,
            berat: input.berat,
            warnaOranye: input.warnaOranye,
            bentukWajar: input.bentukWajar,
            idempotencyKey: idempotencyKey
        )
        try await hasil.save(on: req.db)
        return hasil
    }
}
