import Fluent
import FluentPostgresDriver
import FluentSQLiteDriver
import Vapor

public func configure(_ app: Application) async throws {
    if let databaseURL = Environment.get("DATABASE_URL") {
        // Production: pakai Postgres dari Railway
        try app.databases.use(.postgres(url: databaseURL), as: .psql)
    } else {
        // Local development: pakai SQLite
        app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    }

    app.migrations.add(CreateSortingResult())

    try routes(app)
}
