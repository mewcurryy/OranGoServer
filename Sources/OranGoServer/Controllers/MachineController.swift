//
//  MachineController.swift
//  OranGoServer
//
//  Created by Davin P on 16/08/26.
//

import Vapor
import Fluent

struct CreateMachineRequest: Content {
    var machineName: String
    var lokasi: String?
    var thresholdAktifId: Int
}

struct MachineController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let group = routes.grouped("api", "machines")
        group.get(use: index)
        group.post(use: create)
    }
    func index(req: Request) async throws -> [Machine] {
        try await Machine.query(on: req.db).all()
    }
    func create(req: Request) async throws -> Machine {
        let input = try req.content.decode(CreateMachineRequest.self)
        let machine = Machine(machineName: input.machineName, lokasi: input.lokasi,
                               statusKoneksi: "Terhubung", terakhirTerlihat: Date(),
                               thresholdAktifID: input.thresholdAktifId)
        try await machine.save(on: req.db)
        return machine
    }
}
