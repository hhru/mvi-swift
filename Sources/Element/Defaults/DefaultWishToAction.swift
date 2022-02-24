public struct DefaultWishToAction<Wish>: WishToAction {
    public typealias Action = Wish

    public init() { }

    public func convert(_ wish: Wish) -> Action {
        wish
    }
}

extension BaseFeature where WTA == DefaultWishToAction<A.Action> {

    public convenience init(
        initialState: State,
        bootstrapper: B? = nil,
        actor: A,
        reducer: R,
        postProcessor: PP? = nil,
        newsPublisher: NP? = nil
    ) {
        self.init(
            initialState: initialState,
            bootstrapper: bootstrapper,
            wishToAction: DefaultWishToAction(),
            actor: actor,
            reducer: reducer,
            postProcessor: postProcessor,
            newsPublisher: newsPublisher
        )
    }
}
