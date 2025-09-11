public protocol WishToAction: Sendable {
    associatedtype Wish
    associatedtype Action

    func convert(_ wish: Wish) -> Action
}
