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

struct RetailGradeDetail: Content {
    var retailGrade: RetailGrade
    var threshold: AturanThreshold?
}

struct RetailGradeController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let group = routes.grouped("api", "retail-grades")
        group.get(use: index)
        group.post(use: create)
        group.group(":id") {
            $0.get(use: show)
            $0.patch(use: updateAktif)
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

    // PATCH /api/retail-grades/:id untuk aktifkan / nonaktifkan retail grade ini, dipanggil saat retail grade dipasang
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
}
