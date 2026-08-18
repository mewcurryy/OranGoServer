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
            $0.delete(use: delete)
        }
    }
    
    func index(req: Request) async throws -> [Batch] {
        try await Batch.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> Batch {
        let input = try req.content.decode(CreateBatchRequest.self)
        
        // cek apakah retail grade ada di DB atau tidak
        guard let retailGrade = try await RetailGrade.find(input.retailGradeId, on: req.db) else {
            throw Abort(.notFound, reason: "RetailGrade dengan id \(input.retailGradeId) tidak ditemukan")
        }
        
        let batch = Batch(
            machineID: input.machineId,
            retailGradeID: input.retailGradeId,
            kodeBatch: "",
            mulaiPada: Date()
        )
        try await batch.save(on: req.db)
        
        guard let id = batch.id else {
            throw Abort(.internalServerError, reason: "Gagal mendapatkan ID batch dari database")
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let dateString = formatter.string(from: batch.mulaiPada)
        
        batch.kodeBatch = "B-\(dateString)-\(String(format: "%03d", id))"
        
        try await batch.save(on: req.db)
        
        if !retailGrade.aktif {
            retailGrade.aktif = true
            try await retailGrade.save(on: req.db)
        }
        
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
    
    // for race condition (if there is a device sending the sorting results and we want to delete the batch at the same time
    func delete(req: Request) async throws -> HTTPStatus {
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.notFound)
        }

        try await req.db.transaction { db in
            guard let batch = try await Batch.find(id, on: db) else {
                throw Abort(.notFound)
            }
            try await HasilSortir.query(on: db)
                .filter(\.$batch.$id == id)
                .delete()
            try await batch.delete(on: db)
        }

        return .noContent
    }
}
