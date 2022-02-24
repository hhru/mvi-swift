public struct EmptyPostProcessor<Action, Effect, State: Equatable>: PostProcessor {

    public init() { }

    public func process(action: Action, effect: Effect, state: State) -> Action? {
        nil
    }
}
