import OpenCombine

public struct BypassActor<State: Equatable, Action>: Actor {

    public init() { }

    public func process(state: State, action: Action) -> AnyPublisher<Action, Never> {
        Just(action)
            .eraseToAnyPublisher()
    }
}
