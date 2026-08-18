//
//  BatchController.swift
//  OranGoServer
//
//  Created by Davin P on 16/08/26.
//

import Vapor
import Fluent

struct CreateBatchRequest: Content {
    var machineId: Int
    var retailGradeId: Int
    var kodeBatch: String
}

struct UpdateBatchRequest: Content {
    var selesaiPada: Date?
}

struct BatchController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let group = routes.grouped("api", "batches")
        group.get(use: index)
        group.post(use: create)
        group.group(":id") {
            $0.patch(use: update)
        }
    }
    func index(req: Request) async throws -> [Batch] {
        try await Batch.query(on: req.db).all()
    }
    func create(req: Request) async throws -> Batch {
        let input = try req.content.decode(CreateBatchRequest.self)
        let batch = Batch(machineID: input.machineId, retailGradeID: input.retailGradeId,
                           kodeBatch: input.kodeBatch, mulaiPada: Date())
        try await batch.save(on: req.db)
        return batch
    }

    func update(req: Request) async throws -> Batch {
        guard let id = req.parameters.get("id", as: Int.self),
              let batch = try await Batch.find(id, on: req.db) else {
            throw Abort(.notFound)
        }

        let input = try? req.content.decode(UpdateBatchRequest.self)
        batch.selesaiPada = input?.selesaiPada ?? Date()
        try await batch.save(on: req.db)
        return batch
    }
}
