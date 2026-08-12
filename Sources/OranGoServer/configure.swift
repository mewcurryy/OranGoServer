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

    // Mendaftarkan tabel ke database
    app.migrations.add(CreateSortingResult())

    try routes(app)
}
