import UIKit
@IBDesignable
class AddTodoCellComponentView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
}
@IBDesignable
class AddTodoCellComponent: Component {
    private weak var view: AddTodoCellComponentView!

    var titleText: String? {
        get { return view.titleLabel.text }
        set { view.titleLabel.text = newValue }
    }

    var textFieldText: String? {
        get { return view.textField.text }
        set { view.textField.text = newValue }
    }

    var textFieldPlaceholder: String? {
        get { return view.textField.placeholder }
        set { view.textField.placeholder = newValue }
    }
    var textFieldIsHidden: Bool? {
        get { return view.textField.isHidden }
        set { view.textField.isHidden = newValue ?? true }
    }
    var labelIsHidden: Bool? {
        get { return view.titleLabel.isHidden }
        set { view.titleLabel.isHidden = newValue ?? true }
    }

    override func didLoad(subview: UIView) {
        view = (subview as! AddTodoCellComponentView)
    }
}
