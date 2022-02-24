public protocol WishToAction {
    associatedtype Wish
    associatedtype Action

    func convert(_ wish: Wish) -> Action
}
