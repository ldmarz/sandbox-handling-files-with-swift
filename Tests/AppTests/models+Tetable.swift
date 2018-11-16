//
//  models+Tetable.swift
//  App
//
//  Created by Lenin Martinez on 11/13/18.
//

import Foundation
@testable import App
import FluentPostgreSQL

extension Files {
    static func create(url: String = "someNiceUrl", typeFile: String = ".png", asoc: String = "ms-account", hash: String = "123qeqwe1dq", on connection: PostgreSQLConnection) throws -> Files {
        let file = Files(url: url, typeFile: typeFile, asoc: asoc, hash: hash)
        return try file.save(on: connection).wait()
    }
}
