import UIKit

class TodoCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    func setupCell(for todo: TodoModel) {
        titleLabel.text = todo.title
        tagLabel.text = todo.tags.map {
            "#" + $0
        }.joined(separator: " ")
        descriptionLabel.text = todo.description
        let dateTuple = Date().dateConverter(value: todo.date)
        dateLabel.text = dateTuple.0
        timeLabel.text = dateTuple.1
    }
}
