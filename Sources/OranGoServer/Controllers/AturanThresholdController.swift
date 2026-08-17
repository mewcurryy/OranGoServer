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
    var gradeId: Int
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
        let threshold = AturanThreshold(
            retailGradeID: input.retailGradeId,
            gradeID: input.gradeId,
            diameterMin: input.diameterMin,
            diameterMaks: input.diameterMaks,
            beratMin: input.beratMin,
            beratMaks: input.beratMaks,
            warnaOranye: input.warnaOranye
        )
        try await threshold.save(on: req.db)
        return threshold
    }
}
