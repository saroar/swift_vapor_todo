import Vapor
import Fluent
import Foundation

final class TodoList: Model {
    
    var id: Node?
    
    var title: String = ""
    var done: Bool = false
    
    init(title: String, done: Bool) {
        self.title = title
        self.done = false
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        title = try node.extract("title")
        done = try node.extract("done")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "title": title,
            "done": done
        ])
    }
}

extension TodoList: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create("todolists") { todolists in
            todolists.id()
            todolists.string("title")
            todolists.bool("done")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("todolists")
    }
}
