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
    var gradeKelas: String   // hasil grading yang SUDAH dihitung di Mac, bukan server
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
        var query = HasilSortir.query(on: req.db)
        if let batchId: Int = req.query["batchId"] {
            query = query.filter(\.$batch.$id == batchId)
        }
        return try await query.sort(\.$waktuScan, .descending).all()
    }

    func create(req: Request) async throws -> HasilSortir {
        guard req.headers.first(name: "X-API-Key") == Environment.get("DEVICE_API_KEY") else {
            throw Abort(.unauthorized)
        }

        let input = try req.content.decode(CreateHasilSortirRequest.self)

        guard let batch = try await Batch.find(input.batchId, on: req.db) else {
            throw Abort(.badRequest, reason: "Batch tidak ditemukan")
        }
        let retailGradeId = batch.$retailGrade.id   // tetap diambil dari batch, bukan dikirim device

        guard let grade = try await Grade.query(on: req.db)
            .filter(\.$kelasGrading == input.gradeKelas)
            .first() else {
            throw Abort(.badRequest, reason: "Grade '\(input.gradeKelas)' tidak ditemukan")
        }

        let hasil = HasilSortir(
            batchID: input.batchId,
            gradeID: try grade.requireID(),
            retailGradeID: retailGradeId,
            waktuScan: Date(),
            diameter: input.diameter,
            berat: input.berat,
            warnaOranye: input.warnaOranye,
            bentukWajar: input.bentukWajar
        )
        try await hasil.save(on: req.db)
        return hasil
    }
}
