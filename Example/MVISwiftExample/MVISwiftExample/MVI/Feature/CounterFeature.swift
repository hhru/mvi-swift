import MVISwift

final class CounterFeature: BaseFeature<
    CounterState,
    CounterWish,
    DefaultBootstrapper<CounterAction>,
    DefaultWishToAction<CounterWish>,
    CounterActor,
    CounterReducer,
    CounterPostProcessor,
    CounterNewsPublisher
> {

    init() {
        super.init(
            initialState: CounterState(counter: 0),
            bootstrapper: DefaultBootstrapper(firstAction: .increaseCounter),
            wishToAction: DefaultWishToAction<CounterWish>(),
            actor: CounterActor(),
            reducer: CounterReducer(),
            postProcessor: CounterPostProcessor(),
            newsPublisher: CounterNewsPublisher()
        )
    }
}
