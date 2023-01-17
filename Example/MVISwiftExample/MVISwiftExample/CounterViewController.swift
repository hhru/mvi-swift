import UIKit

class CounterViewController: UIViewController {

    private let feature: CounterFeature

    init(feature: CounterFeature) {
        self.feature = feature
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Counter"
        view.backgroundColor = .white

        print(feature.state.value)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        feature.accept(.increaseCounter)
        print(feature.state.value)

        feature.accept(.decreaseCounter)
        print(feature.state.value)
    }
}
