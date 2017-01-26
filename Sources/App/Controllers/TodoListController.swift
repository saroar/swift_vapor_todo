import Vapor
import HTTP

final class TodoListController: ResourceRepresentable {

    func index(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: TodoList.all().makeNode())
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        var todoList = try request.todoList()
        try todoList.save()
        return todoList
    }
    
    func show(request: Request, todoList: TodoList) throws -> ResponseRepresentable {
        return todoList
    }
    
    func update(request: Request, todoList: TodoList) throws -> ResponseRepresentable {
        let new = try request.todoList()
        var todoList = todoList
        todoList.title = new.title
        todoList.done = new.done
        try todoList.save()
        return todoList
    }
    
    func delete(request: Request, todoList: TodoList) throws -> ResponseRepresentable {
        try todoList.delete()
        return JSON([:])
    }

    func makeResource() -> Resource<TodoList> {
        return Resource(
            index: index,
            store: create,
            show: show,
            modify: update,
            destroy: delete
        )
    }
}

extension Request {
    func todoList() throws -> TodoList {
        guard let json = json else { throw Abort.badRequest }
        return try TodoList(node: json)
    }
}
