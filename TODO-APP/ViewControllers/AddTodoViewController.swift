import Eureka
import Foundation
import SegueManager
import UIKit
protocol TodoModelDelegate: class {
    func generateTodoModel(todoModel: TodoModel, controller: AddTodoViewController)
    func didEditTodoModel(todoModel: TodoModel, controller: AddTodoViewController)
    func deleteTodoModel(todoModel: TodoModel, controller: AddTodoViewController)
}

class AddTodoViewController: FormViewController {
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    var formData = [String: Any?]()
    weak var delegate: TodoModelDelegate?
    var todoItem: TodoModel?
    var navigationTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        titleForm()
        descriptionForm()
        tagForm()
        dateForm()
        doneButton.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationTitle = navigationTitle {
            self.navigationItem.title = navigationTitle
        } else {
            self.navigationItem.title = "Add Todo"
        }
    }
    func titleForm() {
        form +++ Section("Title")
            <<< TextRow("title") { row in
                row.placeholder = "TODO Title"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                row.value = todoItem?.title
            }.cellUpdate {_, row in
                if !row.isValid {
                    row.placeholderColor = .systemRed
                    row.placeholder = "Title field is required."
                    self.doneButton.isEnabled = false
                } else {
                    row.placeholderColor = .systemGray
                    self.doneButton.isEnabled = true
                }
            }
    }
    func descriptionForm() {
        form +++ Section("Description")
            <<< TextAreaRow("description") { row in
                row.placeholder = "TODO Description"
                row.value = todoItem?.description
            }
    }
    func tagForm() {
        form +++ MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
                                    header: "Tags",
                                    footer: ".Insert adds a 'Add Item' (Add New Tag) button row as last cell.") {
                                        $0.tag = "tags"
                                        $0.addButtonProvider = { section in
                                            return ButtonRow {
                                                $0.title = "Add New Tag"
                                            }
                                        }
                                        $0.multivaluedRowToInsertAt = { index in
                                            return NameRow { rows in
                                                rows.placeholder = "Tag Name"
                                            }
                                        }
                                        let multiValueRow = $0
                                        todoItem?.tags.forEach { tag in
                                            multiValueRow <<< TextRow {
                                                $0.value = tag
                                                $0.placeholder = "Tag Name"
                                            }
                                        }
        }
    }
    func dateForm() {
        form +++ Section("Date Row")
            <<< DateTimeRow("date") {
                $0.value = todoItem?.date ?? Date()
            }
            <<< ButtonRow("deleteButton") {
                $0.title = "Delete"
                $0.cell.tintColor = .systemRed
                $0.hidden = .init(booleanLiteral: todoItem == nil)
            }.onCellSelection({ _, _ in
                guard let todoItemDelete = self.todoItem else { return }
                self.delegate?.deleteTodoModel(todoModel: todoItemDelete, controller: self)
            })
    }
    @IBAction private func doneClicked(_ sender: Any) {
        let todoModel = generateFormData()
        guard let delegate = delegate else { return }
        if todoItem != nil {
            delegate.didEditTodoModel(todoModel: todoModel, controller: self)
        } else {
            delegate.generateTodoModel(todoModel: todoModel, controller: self)
        }
    }

    func generateFormData() -> TodoModel {
        formData = form.values()
        let date = formData["date"] as! Date
        let title = formData["title"] as! String
        let description = formData["description"] as? String
        let tags = formData["tags"] as? [String] ?? []

        if let todoItem = todoItem {
            todoItem.title = title
            todoItem.tags = tags
            todoItem.description = description
            todoItem.date = date
            return todoItem
        }
        return TodoModel(title: title, description: description, tags: tags, date: date)
    }
}
