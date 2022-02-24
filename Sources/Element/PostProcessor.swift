public protocol PostProcessor {
    associatedtype State: Equatable
    associatedtype Action
    associatedtype Effect

    func process(action: Action, effect: Effect, state: State) -> Action?
}
