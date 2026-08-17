//
//  AturanThresholdController.swift
//  OranGoServer
//
//  Created by Davin P on 17/08/26.
//

import Vapor
import Fluent

struct CreateAturanThresholdRequest: Content {
    var retailGradeId: Int
    var diameterMin: Double?
    var diameterMaks: Double?
    var beratMin: Double?
    var beratMaks: Double?
    var warnaOranye: Double?
}

struct UpdateAturanThresholdRequest: Content {
    var diameterMin: Double?
    var diameterMaks: Double?
    var beratMin: Double?
    var beratMaks: Double?
    var warnaOranye: Double?
}

struct AturanThresholdController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let group = routes.grouped("api", "aturan-threshold")
        group.get(use: index)
        group.post(use: create)
        group.group(":id") {
            $0.patch(use: update)
            $0.delete(use: delete)
        }
    }

    func index(req: Request) async throws -> [AturanThreshold] {
        var query = AturanThreshold.query(on: req.db)
        if let retailGradeId: Int = req.query["retailGradeId"] {
            query = query.filter(\.$retailGrade.$id == retailGradeId)
        }
        return try await query.all()
    }

    func create(req: Request) async throws -> AturanThreshold {
        let input = try req.content.decode(CreateAturanThresholdRequest.self)

        // satu retail grade cuma boleh punya satu aturan threshold
        let existing = try await AturanThreshold.query(on: req.db)
            .filter(\.$retailGrade.$id == input.retailGradeId)
            .first()
        guard existing == nil else {
            throw Abort(.conflict, reason: "Retail grade ini sudah punya aturan threshold. Gunakan PATCH untuk mengubahnya.")
        }

        let threshold = AturanThreshold(
            retailGradeID: input.retailGradeId,
            diameterMin: input.diameterMin,
            diameterMaks: input.diameterMaks,
            beratMin: input.beratMin,
            beratMaks: input.beratMaks,
            warnaOranye: input.warnaOranye
        )
        try await threshold.save(on: req.db)
        return threshold
    }

    func update(req: Request) async throws -> AturanThreshold {
        guard let id = req.parameters.get("id", as: Int.self),
              let threshold = try await AturanThreshold.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        let input = try req.content.decode(UpdateAturanThresholdRequest.self)
        if let v = input.diameterMin { threshold.diameterMin = v }
        if let v = input.diameterMaks { threshold.diameterMaks = v }
        if let v = input.beratMin { threshold.beratMin = v }
        if let v = input.beratMaks { threshold.beratMaks = v }
        if let v = input.warnaOranye { threshold.warnaOranye = v }
        try await threshold.save(on: req.db)
        return threshold
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let id = req.parameters.get("id", as: Int.self),
              let threshold = try await AturanThreshold.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        try await threshold.delete(on: req.db)
        return .noContent
    }
}
