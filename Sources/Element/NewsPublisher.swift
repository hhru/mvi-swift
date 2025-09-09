public protocol NewsPublisher: Sendable {
    associatedtype State: Equatable
    associatedtype Action
    associatedtype Effect
    associatedtype News

    func process(action: Action, effect: Effect, state: State) -> News?
}
