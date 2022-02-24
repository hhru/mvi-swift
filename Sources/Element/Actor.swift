import Combine

public protocol Actor {
    associatedtype State: Equatable
    associatedtype Action
    associatedtype Effect

    func process(state: State, action: Action) -> AnyPublisher<Effect, Never>
}
