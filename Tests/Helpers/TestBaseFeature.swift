import Foundation
import OpenCombine
import OpenCombineDispatch

@testable import MVISwift

enum TestFeatureConstants {
    static let initialState = TestState()
    static let bootstrapedState = TestState(id: "Bootstrapped state")
    static let initialCounter = 100
    static let initialLoading = false
    static let divisorForModuloInConditionalWish = 3
    static let conditionalMultiplier = 10
    static let instantFulfillAmount1 = 2
    static let instantFulfillAmount2 = 100
    static let delayedFulfillAmount = 5
    static let loopBackInitialState = TestState(id: "Loopback initial state")
    static let loopBackState1 = TestState(id: "Loopback state 1")
    static let loopBackState2 = TestState(id: "Loopback state 2")
    static let loopBackState3 = TestState(id: "Loopback state 3")
}

typealias TestBaseFeature = BaseFeature<
    TestState,
    TestWish,
    DefaultBootstrapper<TestAction>,
    DefaultWishToAction<TestWish>,
    TestActor,
    TestReducer,
    TestPostProcessor,
    TestNewsPublisher
>

struct TestState: FeatureState {
    var id: String = ""
    var counter: Int = TestFeatureConstants.initialCounter
    var loading: Bool = TestFeatureConstants.initialLoading
}

enum TestWish: Equatable {
    case unfulfillable
    case maybeFulfillable
    case fulfillableInstantly1
    case fulfillableInstantly2
    case fulfillableAsync(delay: Int)
    case translatesTo3Effects
    case loopbackWishInitial
    case loopbackWish1
    case loopbackWish2
    case loopbackWish3
    case increaseCounterBy(value: Int)
    case bootstrap
    case postProcessingRequired
}

typealias TestAction = TestWish

enum TestEffect {
    case startedAsync
    case instantEffect(amount: Int)
    case finishedAsync(amount: Int)
    case conditionalThingHappened(multiplier: Int)
    case multipleEffect1
    case multipleEffect2
    case multipleEffect3
    case loopbackEffectInitial
    case loopbackEffect1
    case loopbackEffect2
    case loopbackEffect3
    case bootstrap
    case mustBePostProcessed
}

enum TestNews {
    case loopback
}

final class TestActor: Actor {

    struct Log: Equatable {
        let state: TestState
        let action: TestAction
    }

    let scheduler = DispatchQueue.OCombine.testScheduler
    var invocationLog: [Log] = []

    func process(state: TestState, action: TestAction) -> AnyPublisher<TestEffect, Never> {

        invocationLog.append(.init(state: state, action: action))

        switch action {
        case .unfulfillable:
            return .empty()

        case .maybeFulfillable:
            return conditional(state: state)

        case .fulfillableInstantly1:
            return fulfill(amount: TestFeatureConstants.instantFulfillAmount1)

        case .fulfillableInstantly2:
            return fulfill(amount: TestFeatureConstants.instantFulfillAmount2)

        case .fulfillableAsync(delay: let delay):
            return asyncJob(delay: delay)

        case .translatesTo3Effects:
            return emit3Effects()

        case .loopbackWishInitial:
            return .just(.loopbackEffectInitial)

        case .loopbackWish1:
            return .just(.loopbackEffect1)

        case .loopbackWish2:
            return .just(.loopbackEffect2)

        case .loopbackWish3:
            return .just(.loopbackEffect3)

        case .increaseCounterBy(value: let value):
            return .just(.instantEffect(amount: value))

        case .bootstrap:
            return .just(.bootstrap)

        case .postProcessingRequired:
            return .just(.mustBePostProcessed)
        }
    }

    private func conditional(state: TestState) -> AnyPublisher<TestEffect, Never> {
        if state.counter % TestFeatureConstants.divisorForModuloInConditionalWish == 0 {
            return .just(.conditionalThingHappened(multiplier: TestFeatureConstants.conditionalMultiplier))
        } else {
            return .empty()
        }
    }

    private func fulfill(amount: Int) -> AnyPublisher<TestEffect, Never> {
        .just(.instantEffect(amount: amount))
    }

    private func asyncJob(delay: Int) -> AnyPublisher<TestEffect, Never> {
        Just<Int>(TestFeatureConstants.delayedFulfillAmount)
            .delay(for: .init(integerLiteral: delay), scheduler: scheduler)
            .map { TestEffect.finishedAsync(amount: $0) }
            .prepend(TestEffect.startedAsync)
            .eraseToAnyPublisher()
    }

    private func emit3Effects() -> AnyPublisher<TestEffect, Never> {
        [TestEffect.multipleEffect1, .multipleEffect2, .multipleEffect3]
            .publisher
            .eraseToAnyPublisher()
    }
}

final class TestReducer: Reducer {

    func process(state: TestState, effect: TestEffect) -> TestState {
        var state = state

        switch effect {
        case .startedAsync:
            state.loading = true

        case .instantEffect(amount: let amount):
            state.counter += amount

        case .finishedAsync(amount: let amount):
            state.counter += amount
            state.loading = false

        case .conditionalThingHappened(multiplier: let multiplier):
            state.counter *= multiplier

        case .multipleEffect1:
            break

        case .multipleEffect2:
            break

        case .multipleEffect3:
            break

        case .loopbackEffectInitial:
            state = TestFeatureConstants.loopBackInitialState

        case .loopbackEffect1:
            state = TestFeatureConstants.loopBackState1

        case .loopbackEffect2:
            state = TestFeatureConstants.loopBackState2

        case .loopbackEffect3:
            state = TestFeatureConstants.loopBackState3

        case .bootstrap:
            state = TestFeatureConstants.bootstrapedState

        case .mustBePostProcessed:
            break
        }

        return state
    }
}

final class TestNewsPublisher: NewsPublisher {

    func process(action: TestAction, effect: TestEffect, state: TestState) -> TestNews? {
        switch effect {
        case .loopbackEffect1:
            return .loopback

        default:
            return nil
        }
    }
}

final class TestPostProcessor: PostProcessor {

    func process(action: TestAction, effect: TestEffect, state: TestState) -> TestAction? {
        switch effect {
        case .mustBePostProcessed:
            return .fulfillableInstantly1

        default:
            return nil
        }
    }
}
