import Foundation

public protocol Reducer {
    associatedtype State: Equatable
    associatedtype Effect

    func process(state: State, effect: Effect) -> State
}
