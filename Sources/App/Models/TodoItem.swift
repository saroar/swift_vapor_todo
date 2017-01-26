import Vapor
import Fluent
import Foundation

final class TodoItem: Model {
    var id: Node?
    var title: String = ""
    
    init(title: String) {
        self.title = title
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        title = try node.extract("title")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "title": title
        ])
    }
}

extension TodoItem: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create("todoitems") { todoitems in
            todoitems.id()
            todoitems.string("title")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("todoitems")
    }
}
