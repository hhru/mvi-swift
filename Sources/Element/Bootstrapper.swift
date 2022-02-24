import Combine

public protocol Bootstrapper {
    associatedtype Action

    func bootstrap() -> AnyPublisher<Action, Never>
}
