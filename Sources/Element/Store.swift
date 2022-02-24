import Combine

public protocol Store: AnyObject {
    associatedtype State: FeatureState
    associatedtype Wish

    var state: CurrentValueSubject<State, Never> { get }

    func accept(_ wish: Wish)
}
