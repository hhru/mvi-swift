public struct EmptyNewsPublisher<Action, Effect, State: Equatable, News>: NewsPublisher {

    public init() { }

    public func process(action: Action, effect: Effect, state: State) -> News? {
        nil
    }
}
