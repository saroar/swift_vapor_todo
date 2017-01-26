import Vapor
import HTTP

final class TodoItemController: ResourceRepresentable {
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: TodoItem.all().makeNode())
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        var todoItem = try request.todoItem()
        try todoItem.save()
        return todoItem
    }
    

    func show(request: Request, todoItem: TodoItem) throws -> ResponseRepresentable {
        return todoItem
    }
    
    func update(request: Request, todoItem: TodoItem) throws -> ResponseRepresentable {
        let new = try request.todoItem()
        var todoItem = todoItem
        todoItem.title = new.title
        try todoItem.save()
        return todoItem
    }
    
    func delete(request: Request, todoItem: TodoItem) throws -> ResponseRepresentable {
        try todoItem.delete()
        return JSON([:])
    }
    
    func makeResource() -> Resource<TodoItem> {
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
    func todoItem() throws -> TodoItem {
        guard let json = json else { throw Abort.badRequest }
        return try TodoItem(node: json)
    }
}
