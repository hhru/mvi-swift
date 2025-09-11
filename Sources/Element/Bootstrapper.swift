import Combine

public protocol Bootstrapper: Sendable {
    associatedtype Action

    func bootstrap() -> AnyPublisher<Action, Never>
}
