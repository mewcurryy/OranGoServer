//
//  RetailGradeController.swift
//  OranGoServer
//
//  Created by Davin P on 16/08/26.
//

import Vapor
import Fluent

struct ThresholdInput: Content {
    var diameterMin: Double?
    var diameterMaks: Double?
    var beratMin: Double?
    var beratMaks: Double?
    var warnaOranye: Double?
}

struct CreateRetailGradeRequest: Content {
    var retailName: String
    var catatan: String?
    var threshold: ThresholdInput
    // aktif TIDAK ada di sini lagi — retail grade baru selalu dibuat aktif=false.
    // Aktifkan lewat PATCH /api/retail-grades/:id setelah dipasang ke mesin.
}

struct UpdateRetailGradeAktifRequest: Content {
    var aktif: Bool
}

struct UpdateThresholdRequest: Content {
    var diameterMin: Double?
    var diameterMaks: Double?
    var beratMin: Double?
    var beratMaks: Double?
    var warnaOranye: Double?
}

struct RetailGradeDetail: Content {
    var retailGrade: RetailGrade
    var threshold: AturanThreshold?
}

struct RetailGradeController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let group = routes.grouped("api", "retail-grades")
        group.get(use: index)
        group.post(use: create)
        group.group(":id") { idGroup in
            idGroup.get(use: show)
            idGroup.patch(use: updateAktif)
            idGroup.delete(use: delete)
            idGroup.group("threshold") {
                $0.patch(use: updateThreshold)
            }
        }
    }

    func index(req: Request) async throws -> [RetailGrade] {
        try await RetailGrade.query(on: req.db).all()
    }

    func create(req: Request) async throws -> RetailGrade {
        let input = try req.content.decode(CreateRetailGradeRequest.self)
        let retailGrade = RetailGrade(retailName: input.retailName, aktif: false, catatan: input.catatan)
        try await retailGrade.save(on: req.db)

        let threshold = AturanThreshold(
            retailGradeID: try retailGrade.requireID(),
            diameterMin: input.threshold.diameterMin,
            diameterMaks: input.threshold.diameterMaks,
            beratMin: input.threshold.beratMin,
            beratMaks: input.threshold.beratMaks,
            warnaOranye: input.threshold.warnaOranye
        )
        try await threshold.save(on: req.db)

        return retailGrade
    }

    func show(req: Request) async throws -> RetailGradeDetail {
        guard let id = req.parameters.get("id", as: Int.self),
              let retailGrade = try await RetailGrade.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        let threshold = try await AturanThreshold.query(on: req.db)
            .filter(\.$retailGrade.$id == id)
            .first()
        return RetailGradeDetail(retailGrade: retailGrade, threshold: threshold)
    }

    // PATCH /api/retail-grades/:id — aktifkan / nonaktifkan retail grade ini
    func updateAktif(req: Request) async throws -> RetailGrade {
        guard let id = req.parameters.get("id", as: Int.self),
              let retailGrade = try await RetailGrade.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        let input = try req.content.decode(UpdateRetailGradeAktifRequest.self)
        retailGrade.aktif = input.aktif
        try await retailGrade.save(on: req.db)
        return retailGrade
    }

    // PATCH /api/retail-grades/:id/threshold — ubah nilai Min/Max/warna, tanpa ganti status aktif
    func updateThreshold(req: Request) async throws -> AturanThreshold {
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest)
        }
        guard let threshold = try await AturanThreshold.query(on: req.db)
            .filter(\.$retailGrade.$id == id)
            .first() else {
            throw Abort(.notFound, reason: "Threshold untuk retail grade ini belum ada")
        }
        let input = try req.content.decode(UpdateThresholdRequest.self)
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
              let retailGrade = try await RetailGrade.find(id, on: req.db) else {
            throw Abort(.notFound)
        }

        let dipakaiMachine = try await Machine.query(on: req.db)
            .filter(\.$thresholdAktif.$id == id)
            .first() != nil
        let dipakaiBatch = try await Batch.query(on: req.db)
            .filter(\.$retailGrade.$id == id)
            .first() != nil

        guard !dipakaiMachine, !dipakaiBatch else {
            throw Abort(.conflict, reason: "Retail grade ini masih dipakai oleh machine atau batch, tidak bisa dihapus")
        }

        try await AturanThreshold.query(on: req.db)
            .filter(\.$retailGrade.$id == id)
            .delete()

        try await retailGrade.delete(on: req.db)
        return .noContent
    }
}
