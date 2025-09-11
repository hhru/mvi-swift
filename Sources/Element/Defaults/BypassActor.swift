import Combine

public struct BypassActor<State: Equatable, Action>: Actor, Sendable {

    public init() { }

    public func process(state: State, action: Action) -> AnyPublisher<Action, Never> {
        Just(action)
            .eraseToAnyPublisher()
    }
}
