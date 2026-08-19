import Fluent
import FluentPostgresDriver
import FluentSQLiteDriver
import Vapor
import NIOSSL // Wajib ditambahkan untuk mengatur SSL

func configure(_ app: Application) async throws {
    
    if let databaseURL = Environment.get("DATABASE_URL") {
        var postgresConfig = try SQLPostgresConfiguration(url: databaseURL)
        
        var tlsConfig = TLSConfiguration.makeClientConfiguration()
        tlsConfig.certificateVerification = .none
        postgresConfig.coreConfiguration.tls = .require(try .init(configuration: tlsConfig))
        app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
        
    } else {
        app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    }

    app.migrations.add(CreateGrade())
    app.migrations.add(SeedGrade())
    app.migrations.add(CreateRetailGrade())
    app.migrations.add(CreateMachine())
    app.migrations.add(CreateBatch())
    app.migrations.add(CreateHasilSortir())
    app.migrations.add(RemoveIdempotencyKeyFromHasilSortir())
    app.migrations.add(AddThresholdFieldsToRetailGrade())
    app.migrations.add(MigrateAturanThresholdIntoRetailGrade())
    app.migrations.add(DropAturanThreshold())
    try routes(app)
}
