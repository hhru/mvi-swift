import Combine

public protocol Actor: Sendable {
    associatedtype State: Equatable
    associatedtype Action
    associatedtype Effect

    func process(state: State, action: Action) -> AnyPublisher<Effect, Never>
}
