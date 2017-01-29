import Vapor
import Fluent
import Foundation

final class TodoItem: Model {
    var id: Node?
    var title: String = ""
    var todolistId: Node?
    
    init(title: String, todolistId: Node? = nil) {
        self.title = title
        self.todolistId = todolistId
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        title = try node.extract("title")
        todolistId = try node.extract("todolist_id")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "title": title,
            "todolist_id": todolistId
        ])
    }
}

extension TodoItem: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create("todoitems") { todoitems in
            todoitems.id()
            todoitems.string("title")
            todoitems.parent(TodoList.self, optional: false)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("todoitems")
    }
}
