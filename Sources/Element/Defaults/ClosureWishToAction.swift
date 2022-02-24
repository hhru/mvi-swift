public struct ClosureWishToAction<Wish, Action>: WishToAction {

    private var wishToAction: (Wish) -> Action

    public init(_ wishToAction: @escaping (Wish) -> Action) {
        self.wishToAction = wishToAction
    }

    public func convert(_ wish: Wish) -> Action {
        wishToAction(wish)
    }
}

extension BaseFeature where WTA == ClosureWishToAction<Wish, A.Action> {

    public convenience init(
        initialState: State,
        bootstrapper: B? = nil,
        wishToAction: @escaping (Wish) -> A.Action,
        actor: A,
        reducer: R,
        postProcessor: PP? = nil,
        newsPublisher: NP? = nil
    ) {
        self.init(
            initialState: initialState,
            bootstrapper: bootstrapper,
            wishToAction: ClosureWishToAction(wishToAction),
            actor: actor,
            reducer: reducer,
            postProcessor: postProcessor,
            newsPublisher: newsPublisher
        )
    }
}
