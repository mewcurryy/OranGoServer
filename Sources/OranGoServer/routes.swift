import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: GradeController())
    try app.register(collection: RetailGradeController())
    try app.register(collection: MachineController())
    try app.register(collection: BatchController())
    try app.register(collection: HasilSortirController())
}
