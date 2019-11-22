import UIKit

class Component: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func loadView() {
        let className = String(describing: type(of: self))
        let view = (Bundle(for: type(of: self)).loadNibNamed(className, owner: nil, options: nil)!.first as! UIView)
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        didLoad(subview: view)
    }
    func didLoad(subview: UIView) {}
}
