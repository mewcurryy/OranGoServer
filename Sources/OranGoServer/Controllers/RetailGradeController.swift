//
//  RetailGradeController.swift
//  OranGoServer
//
//  Created by Davin P on 16/08/26.
//

import Vapor
import Fluent

struct ThresholdInput: Content {
    var gradeKelas: String   // "A", "B", "C", "EDIBLE"
    var diameterMin: Double?
    var diameterMaks: Double?
    var beratMin: Double?
    var beratMaks: Double?
    var warnaOranye: Double?
}

struct CreateRetailGradeRequest: Content {
    var retailName: String
    var aktif: Bool?
    var catatan: String?
    var thresholds: [ThresholdInput]
}

struct RetailGradeDetail: Content {
    var retailGrade: RetailGrade
    var thresholds: [AturanThreshold]
}

struct RetailGradeController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let group = routes.grouped("api", "retail-grades")
        group.get(use: index)
        group.post(use: create)
        group.group(":id") { $0.get(use: show) }
    }

    func index(req: Request) async throws -> [RetailGrade] {
        try await RetailGrade.query(on: req.db).all()
    }

    func create(req: Request) async throws -> RetailGrade {
        let input = try req.content.decode(CreateRetailGradeRequest.self)
        let retailGrade = RetailGrade(retailName: input.retailName, aktif: input.aktif ?? false, catatan: input.catatan)
        try await retailGrade.save(on: req.db)

        for t in input.thresholds {
            guard let grade = try await Grade.query(on: req.db)
                .filter(\.$kelasGrading == t.gradeKelas)
                .first() else {
                throw Abort(.badRequest, reason: "Grade \(t.gradeKelas) tidak ditemukan")
            }
            let threshold = AturanThreshold(
                retailGradeID: try retailGrade.requireID(),
                gradeID: try grade.requireID(),
                diameterMin: t.diameterMin, diameterMaks: t.diameterMaks,
                beratMin: t.beratMin, beratMaks: t.beratMaks,
                warnaOranye: t.warnaOranye
            )
            try await threshold.save(on: req.db)
        }
        return retailGrade
    }

    func show(req: Request) async throws -> RetailGradeDetail {
        guard let id = req.parameters.get("id", as: Int.self),
              let retailGrade = try await RetailGrade.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        let thresholds = try await AturanThreshold.query(on: req.db)
            .filter(\.$retailGrade.$id == id)
            .all()
        return RetailGradeDetail(retailGrade: retailGrade, thresholds: thresholds)
    }
}
