//
//  GradeController.swift
//  OranGoServer
//
//  Created by Davin P on 16/08/26.
//


import Vapor
import Fluent

struct GradeController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        routes.grouped("api", "grades").get(use: index)
    }
    func index(req: Request) async throws -> [Grade] {
        try await Grade.query(on: req.db).all()
    }
}