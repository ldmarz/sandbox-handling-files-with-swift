import Vapor
import FluentPostgreSQL

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentPostgreSQLProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    /// Register the configured PostgreSql database to the database config.
    var databases = DatabasesConfig()
    let databaseConfig = PostgreSQLDatabaseConfig(
        hostname: Environment.get("HOST") ?? "localhost",
        username: Environment.get("USERNAME") ?? "postgres",
        database: Environment.get("DATABASE") ?? "files",
        password: Environment.get("PASSWORD") ?? "123456")
    let database = PostgreSQLDatabase(config: databaseConfig)
    
    databases.add(database: database, as: .psql)
    databases.enableLogging(on: .psql)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Files.self, database: .psql)
    services.register(migrations)

}
