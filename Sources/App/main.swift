import Vapor
import VaporPostgreSQL

let drop = Droplet()

do {
    try drop.addProvider(VaporPostgreSQL.Provider.self)
} catch {
    assertionFailure("Error adding provider: \(error)")
}

drop.preparations.append(TodoList.self)
drop.preparations.append(TodoItem.self)

let todoLists = TodoListController()
drop.get("api", handler: todoLists.index)
drop.put("api", handler: todoLists.create)

let todoItems = TodoItemController()
drop.get("api_items", handler: todoItems.index)
drop.put("api_items", handler: todoItems.create)

drop.run()
