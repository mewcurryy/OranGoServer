//
//  SortingResultController.swift
//  OranGoServer
//
//  Created by Davin P on 11/08/26.
//


import Vapor
import Fluent

struct SortingResultController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let group = routes.grouped("api", "sorting-results")
        group.post(use: create)   // Mac kirim data ke sini
        group.get(use: index)     // iPad ambil data dari sini
    }

    // POST /api/sorting-results  — dipanggil dari Mac tiap ada hasil grading baru
    func create(req: Request) async throws -> SortingResult {
        guard req.headers.first(name: "X-API-Key") == Environment.get("DEVICE_API_KEY") else {
            throw Abort(.unauthorized)
        }
        let result = try req.content.decode(SortingResult.self)
        try await result.save(on: req.db)
        return result
    }

    // GET /api/sorting-results  — dipanggil dari iPad buat isi Dashboard
    func index(req: Request) async throws -> [SortingResult] {
        try await SortingResult.query(on: req.db)
            .sort(\.$createdAt, .descending)
            .all()
    }
}
