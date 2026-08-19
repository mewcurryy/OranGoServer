import Vapor
import Fluent

struct CreateRetailGradeRequest: Content {
    var retailName: String
    var diameterMin: Double?
    var diameterMaks: Double?
    var beratMin: Double?
    var beratMaks: Double?
    var warnaOranye: Double?
}

struct UpdateRetailGradeRequest: Content {
    var retailName: String?
    var aktif: Bool?
    var diameterMin: Double?
    var diameterMaks: Double?
    var beratMin: Double?
    var beratMaks: Double?
    var warnaOranye: Double?
}

struct UpdateThresholdRequest: Content {
    var diameterMin: Double?
    var diameterMaks: Double?
    var beratMin: Double?
    var beratMaks: Double?
    var warnaOranye: Double?
}

struct RetailGradeController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let group = routes.grouped("api", "retail-grades")
        group.get(use: index)
        group.post(use: create)
        group.group(":id") { idGroup in
            idGroup.get(use: show)
            idGroup.patch(use: update)
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
        let retailGrade = RetailGrade(
            retailName: input.retailName, aktif: false,
            diameterMin: input.diameterMin, diameterMaks: input.diameterMaks,
            beratMin: input.beratMin, beratMaks: input.beratMaks,
            warnaOranye: input.warnaOranye
        )
        try await retailGrade.save(on: req.db)
        return retailGrade
    }

    func show(req: Request) async throws -> RetailGrade {
        guard let id = req.parameters.get("id", as: Int.self),
              let retailGrade = try await RetailGrade.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        return retailGrade
    }

    func update(req: Request) async throws -> RetailGrade {
        guard let id = req.parameters.get("id", as: Int.self),
              let retailGrade = try await RetailGrade.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        let input = try req.content.decode(UpdateRetailGradeRequest.self)
        if let v = input.retailName { retailGrade.retailName = v }
        if let v = input.aktif { retailGrade.aktif = v }
        try await retailGrade.save(on: req.db)
        return retailGrade
    }

    func updateThreshold(req: Request) async throws -> RetailGrade {
        guard let id = req.parameters.get("id", as: Int.self),
              let retailGrade = try await RetailGrade.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        let input = try req.content.decode(UpdateThresholdRequest.self)
        if let v = input.diameterMin { retailGrade.diameterMin = v }
        if let v = input.diameterMaks { retailGrade.diameterMaks = v }
        if let v = input.beratMin { retailGrade.beratMin = v }
        if let v = input.beratMaks { retailGrade.beratMaks = v }
        if let v = input.warnaOranye { retailGrade.warnaOranye = v }
        try await retailGrade.save(on: req.db)
        return retailGrade
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

        try await retailGrade.delete(on: req.db)
        return .noContent
    }
}
