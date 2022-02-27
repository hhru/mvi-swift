//___FILEHEADER___

import MVISwift
import Combine

final class ___VARIABLE_productName:identifier___Bootstrapper: Bootstrapper {

    private let bootstrapSubject = PassthroughSubject<___VARIABLE_productName:identifier___Action, Never>()
    private var cancellableBag = Set<AnyCancellable>()

    func bootstrap() -> AnyPublisher<___VARIABLE_productName:identifier___Action, Never> {
        return bootstrapSubject.eraseToAnyPublisher()
    }
}
