import SegueManager
import UIKit
import UserNotifications

class ToDoListViewController: SegueManagerViewController, TodoModelDelegate {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    private var displayedTodos: [TodoModel] {
        return ((searchBar.text?.isEmpty ?? true) ? todoList : todoSearched).filter {
            segmentedControl.selectedSegmentIndex == 2 || $0.completed == (segmentedControl.selectedSegmentIndex == 1)
        }
    }
    private var todoSearched = [TodoModel]()
    private var todoList = [TodoModel]()
    private let faker = FakerTodos()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater = self
        return searchController
    }()

    private var searchBar: UISearchBar { searchController.searchBar }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
    }
    private func setupSearchBar() {
        definesPresentationContext = true
        searchBar.barStyle = .default
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "TODO Search"
        self.navigationItem.searchController = searchController
    }
    @IBAction private func segmentedChanged(_ sender: Any) {
        tableView.reloadData()
    }
    @IBAction private func fakeTodo(_ sender: Any) {
        todoList.append(faker.fakeTodoGenerator())
        tableView.reloadData()
    }
    func generateTodoModel(todoModel: TodoModel, controller: AddTodoViewController) {
        print("Delegate is working.")
        todoList.append(todoModel)
        todoList.sort { first, second -> Bool in
            first.date < second.date
        }
        generateNofitication(todoItem: todoModel)
        navigationController?.popViewController(animated: true)
        tableView.reloadData()
    }
    func didEditTodoModel(todoModel: TodoModel, controller: AddTodoViewController) {
        navigationController?.popViewController(animated: true)
        tableView.reloadData()
    }

    func deleteTodoModel(todoModel: TodoModel, controller: AddTodoViewController) {
        todoList.removeAll {
            $0 === todoModel
        }
        navigationController?.popViewController(animated: true)
        tableView.reloadData()
    }

    @IBAction private func addItem(_ sender: Any) {
        guard let addTodoController = R.storyboard.main.addTodoController() else { return }
        addTodoController.delegate = self
        self.navigationController?.pushViewController(addTodoController, animated: true)
    }
}
extension ToDoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if displayedTodos.isEmpty == true {
            let emptyLabel = UILabel(frame: self.view.bounds)
            emptyLabel.text = "Nothing Todo :)"
            emptyLabel.textAlignment = .center
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = .none
            return 0
        } else {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
            return displayedTodos.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.todoCell, for: indexPath)!
        cell.setupCell(for: displayedTodos[indexPath.row])
        return cell
    }
}
extension ToDoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todoData = displayedTodos[indexPath.row]
        performSegue(withIdentifier: R.segue.toDoListViewController.editTodo) { segue in
            segue.destination.todoItem = todoData
            segue.destination.navigationTitle = "Modify Todo"
            segue.destination.delegate = self
        }
    }
    func generateNofitication(todoItem: TodoModel) {
        if !todoItem.completed {
            let content = UNMutableNotificationContent()
            content.title = "Todo"
            content.subtitle = "Your Todo: \(todoItem.title)"
            content.sound = UNNotificationSound.default
            content.badge = 1
            let date = todoItem.date
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                             from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: todoItem.notificationId,
                                                content: content,
                                                trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let todoItem = displayedTodos[indexPath.row]
        generateNofitication(todoItem: todoItem)
        let title = todoItem.completed ? "Uncomplete" : "Completed"
        let action = UIContextualAction(style: .normal, title: title) { _, _, completionHandler in
            todoItem.completed.toggle()
            if self.segmentedControl.selectedSegmentIndex == 2 {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                tableView.deleteRows(at: [indexPath], with: .middle)
            }
            completionHandler(true)
        }
        action.backgroundColor = todoItem.completed ? .red : .green
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
}

extension ToDoListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            tableView.reloadData()
            return }
        let searchedText = todoList.filter {
            $0.tags.contains(text) ||
                $0.title.contains(text) ||
                $0.description?.contains(text) ?? false
        }
        self.todoSearched = searchedText
        tableView.reloadData()
    }
}
