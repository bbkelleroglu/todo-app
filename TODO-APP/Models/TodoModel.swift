import Foundation

class TodoModel {
    var title: String
    var description: String?
    var tags: [String]
    var date: Date
    var completed: Bool
    let notificationId: String

    init(title: String, description: String?, tags: [String], date: Date, completed: Bool = false) {
        self.title = title
        self.description = description
        self.tags = tags
        self.date = date
        self.completed = completed
        self.notificationId = UUID().uuidString
    }
}
