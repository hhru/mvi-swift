import OpenCombine

public struct DefaultBootstrapper<Action>: Bootstrapper {

    public let actions: [Action]

    public init(firstAction: Action) {
        self.actions = [firstAction]
    }

    public init(actions: [Action]) {
        self.actions = actions
    }

    public func bootstrap() -> AnyPublisher<Action, Never> {
        actions.publisher.eraseToAnyPublisher()
    }
}
