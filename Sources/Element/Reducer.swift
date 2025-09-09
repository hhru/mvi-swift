import Foundation

public protocol Reducer: Sendable {
    associatedtype State: Equatable
    associatedtype Effect

    func process(state: State, effect: Effect) -> State
}
