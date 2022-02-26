import Foundation
import OpenCombine

// swiftlint:disable generic_type_name
open class BaseFeature<
    State: FeatureState,
    Wish,
    B: Bootstrapper,
    WTA: WishToAction,
    A: Actor,
    R: Reducer,
    PP: PostProcessor,
    NP: NewsPublisher
>: Feature where
    State == R.State,
    State == A.State,
    State == PP.State,
    State == NP.State,
    Wish == WTA.Wish,
    B.Action == A.Action,
    B.Action == WTA.Action,
    B.Action == PP.Action,
    B.Action == NP.Action,
    A.Effect == R.Effect,
    A.Effect == PP.Effect,
    A.Effect == NP.Effect {

    public typealias State = State
    public typealias News = NP.News
    public typealias Action = WTA.Action
    public typealias Effect = A.Effect

    // MARK: - Private variables

    private let bootstrapper: B?
    private let wishToAction: WTA
    private let actor: A
    private let reducer: R
    private let postProcessor: PP?
    private let newsPublisher: NP?

    private let stateSubject: CurrentValueSubject<State, Never>
    private let newsSubject: PassthroughSubject<News, Never>
    private let actionSubject: PassthroughSubject<Action, Never>

    // MARK: - Public variables

    public var cancellableBag = Set<AnyCancellable>()

    public var news: AnyPublisher<NP.News, Never> {
        newsSubject
            .eraseToAnyPublisher()
    }

    public var state: CurrentValueSubject<State, Never> {
        stateSubject
    }

    // MARK: - Initializers

    public init(
        initialState: State,
        bootstrapper: B?,
        wishToAction: WTA,
        actor: A,
        reducer: R,
        postProcessor: PP?,
        newsPublisher: NP?
    ) {
        self.bootstrapper = bootstrapper
        self.wishToAction = wishToAction
        self.actor = actor
        self.reducer = reducer
        self.postProcessor = postProcessor
        self.newsPublisher = newsPublisher

        self.stateSubject = CurrentValueSubject(initialState)
        self.newsSubject = PassthroughSubject()
        self.actionSubject = PassthroughSubject()

        actionSubject
            .sink { [weak self] action in
                guard let self = self else {
                    return
                }

                self.invokeActor(state: self.stateSubject.value, action: action)
            }
            .store(in: &cancellableBag)

        bootstrapper?
            .bootstrap()
            .sink { [weak self] action in
                self?.actionSubject.send(action)
            }
            .store(in: &cancellableBag)
    }

    // MARK: - Public methods

    public func accept(_ wish: Wish) {
        let action = wishToAction.convert(wish)
        actionSubject.send(action)
    }

    // MARK: - Private methods

    private func invokeActor(state: State, action: Action) {
        actor
            .process(state: state, action: action)
            .sink { [weak self] effect in
                guard let self = self else {
                    return
                }

                self.invokeReducer(state: self.stateSubject.value, action: action, effect: effect)
            }
            .store(in: &cancellableBag)
    }

    private func invokeReducer(state: State, action: Action, effect: Effect) {
        let newState = reducer.process(state: state, effect: effect)

        stateSubject.send(newState)

        invokePostProcessor(action: action, effect: effect, state: newState)
        invokeNewsPublisher(action: action, effect: effect, state: newState)
    }

    private func invokePostProcessor(action: Action, effect: Effect, state: State) {
        postProcessor?
            .process(action: action, effect: effect, state: state)
            .map(actionSubject.send)
    }

    private func invokeNewsPublisher(action: Action, effect: Effect, state: State) {
        newsPublisher?
            .process(action: action, effect: effect, state: state)
            .map(newsSubject.send)
    }
}

// MARK: - Convenience Initializers

extension BaseFeature where A == BypassActor<State, B.Action> {

    public convenience init(
        reducerFeatureWithInitialState initialState: State,
        bootstrapper: B? = nil,
        wishToAction: WTA,
        reducer: R,
        postProcessor: PP? = nil,
        newsPublisher: NP? = nil
    ) {
        self.init(
            initialState: initialState,
            bootstrapper: bootstrapper,
            wishToAction: wishToAction,
            actor: BypassActor(),
            reducer: reducer,
            postProcessor: postProcessor,
            newsPublisher: newsPublisher
        )
    }
}

extension BaseFeature where A == BypassActor<State, B.Action>, WTA == DefaultWishToAction<A.Action> {

    public convenience init(
        reducerFeatureWithInitialState initialState: State,
        bootstrapper: B? = nil,
        reducer: R,
        postProcessor: PP? = nil,
        newsPublisher: NP? = nil
    ) {
        self.init(
            initialState: initialState,
            bootstrapper: bootstrapper,
            wishToAction: DefaultWishToAction(),
            actor: BypassActor(),
            reducer: reducer,
            postProcessor: postProcessor,
            newsPublisher: newsPublisher
        )
    }
}

extension BaseFeature: BindableFeature { }

// swiftlint:enable generic_type_name
