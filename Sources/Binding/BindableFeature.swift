import Foundation
import Combine

public protocol BindableFeature { }

extension BindableFeature where Self: Feature {

    public func bindTo(_ publisher: AnyPublisher<Self.Wish, Never>) {
        publisher
            .sink { [weak self] wish in
                self?.accept(wish)
            }
            .store(in: &cancellableBag)
    }
}
