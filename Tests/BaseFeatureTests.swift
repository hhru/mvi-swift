import Foundation
import XCTest
import OpenCombine

@testable import MVISwift

final class BaseFeatureTests: XCTestCase {

    private var actor: TestActor!
    private var feature: TestBaseFeature!

    private var cancellableBag: Set<AnyCancellable>!

    private var states: [TestState] = []

    override func setUp() {
        super.setUp()

        actor = TestActor()
        feature = makeFeature()
        cancellableBag = Set<AnyCancellable>()
    }

    override func tearDown() {
        super.tearDown()

        states = []
    }

    private func makeFeature(
        bootstrapper: DefaultBootstrapper<TestAction>? = nil
    ) -> TestBaseFeature {
        TestBaseFeature(
            initialState: TestFeatureConstants.initialState,
            bootstrapper: bootstrapper,
            wishToAction: DefaultWishToAction<TestWish>(),
            actor: actor,
            reducer: TestReducer(),
            postProcessor: TestPostProcessor(),
            newsPublisher: TestNewsPublisher()
        )
    }

    private func makeStateSubscription() {
        feature
            .state
            .sink { [unowned self] state in
                self.states.append(state)
            }
            .store(in: &cancellableBag)
    }

    func testIfThereAreNoWishesFeatureOnlyEmitsInitialState() {
        // when
        makeStateSubscription()

        // then
        XCTAssertEqual(1, states.count)
    }

    func testEmitedInitialStateIsCorrect() {
        // when
        makeStateSubscription()

        // then
        XCTAssertEqual(TestFeatureConstants.initialState, states.first!)
    }

    func testActionEmitedByBootstrapperLeadsToCorrectStateChange() {
        // given
        feature = makeFeature(bootstrapper: DefaultBootstrapper(firstAction: .bootstrap))

        // when
        makeStateSubscription()

        // then
        XCTAssertEqual(1, states.count)
        XCTAssertEqual(TestFeatureConstants.bootstrapedState, states.last!)
    }

    func testActionsEmitedByBootstrapperLeadsToCorrectStateChanges() {
        // given
        let increment = 50
        feature = makeFeature(bootstrapper: DefaultBootstrapper(
            actions: [.bootstrap, .increaseCounterBy(value: increment)]
        ))

        // when
        makeStateSubscription()

        // then
        XCTAssertEqual(
            TestState(
                id: TestFeatureConstants.bootstrapedState.id,
                counter: TestFeatureConstants.initialCounter + increment
            ),
            states.last!
        )
    }

    func testThereShouldBeNoStateEmissionsBesidesTheInitialOneForUnfulfillableWishes() {
        // given
        let wishes: [TestWish] = [.unfulfillable, .unfulfillable, .unfulfillable]

        // when
        makeStateSubscription()

        wishes.forEach(feature.accept)

        // then
        XCTAssertEqual(1, states.count)
    }

    func testThereShouldBeSameAmountOfStatesAsWishesThatTranslate1to1toEffectsPlusOneForInitialState() {
        // given
        let wishes: [TestWish] = [.fulfillableInstantly1, .fulfillableInstantly1, .fulfillableInstantly1]

        // when
        makeStateSubscription()

        wishes.forEach(feature.accept)

        // then
        XCTAssertEqual(1 + wishes.count, states.count)
    }

    func testThereShouldBe3TimesAsManyStatesAsWishesThatTranslate1to3toEffectsPlusOneForInitialState() {
        // given
        let wishes: [TestWish] = [.translatesTo3Effects, .translatesTo3Effects, .translatesTo3Effects]

        // when
        makeStateSubscription()

        wishes.forEach(feature.accept)

        // then
        XCTAssertEqual(1 + wishes.count * 3, states.count)
    }

    func testLastStateCorrectlyReflectsExpectedChangesInSimpleCase() {
        // given
        let wishes: [TestWish] = [.fulfillableInstantly1, .fulfillableInstantly1, .fulfillableInstantly1]

        let expectedCounter = TestFeatureConstants.initialCounter
            + wishes.count
            * TestFeatureConstants.instantFulfillAmount1

        // when
        makeStateSubscription()

        wishes.forEach(feature.accept)

        // then
        let lastState = states.last

        XCTAssertEqual(expectedCounter, lastState?.counter)
        XCTAssertEqual(false, lastState?.loading)
    }

    func testStatesMatchesExpectationInAsyncCase() {
        // given
        let delay = 1
        let wishes: [TestWish] = [.fulfillableAsync(delay: delay), .fulfillableInstantly2]

        let expectedThirdCounter = TestFeatureConstants.initialCounter + TestFeatureConstants.instantFulfillAmount2
        let expectedFinalCounter = expectedThirdCounter + TestFeatureConstants.delayedFulfillAmount
        let expectedStates = [
            TestState(counter: TestFeatureConstants.initialCounter, loading: false),
            TestState(counter: TestFeatureConstants.initialCounter, loading: true),
            TestState(counter: expectedThirdCounter, loading: true),
            TestState(counter: expectedFinalCounter, loading: false)
        ]

        // when
        makeStateSubscription()

        wishes.forEach(feature.accept)

        actor.scheduler.advance(by: .init(integerLiteral: delay + 1))

        // then
        XCTAssertEqual(expectedStates, states)
    }

    func testTheNumberOfStateEmissionsShouldReflectTheNumberOfEffectsPlusOneForInitialStateInComplexCase() {
        // given
        let wishes: [TestWish] = [
            .fulfillableInstantly1, // maps to 1 effect
            .fulfillableInstantly1, // maps to 1 effect
            .maybeFulfillable,      // maps to 0 effects
            .unfulfillable,         // maps to 0 effects
            .fulfillableInstantly1, // maps to 1 effect
            .fulfillableInstantly1, // maps to 1 effect
            .maybeFulfillable,      // maps to 1 effect
            .translatesTo3Effects   // maps to 3 effect
        ]

        // when
        makeStateSubscription()

        wishes.forEach(feature.accept)

        // then
        XCTAssertEqual(1 + 8, states.count)
    }

    func testLastStateCorrectlyReflectsExpectedChangesInComplexCase() {
        // given
        let wishes: [TestWish] = [
            .fulfillableInstantly1, // should increase +2 (total 102)
            .fulfillableInstantly1, // should increase +2 (total 104)
            .maybeFulfillable,      // should not increase in this case
            .unfulfillable,         // should not do anything
            .fulfillableInstantly1, // should increase +2 (total 106)
            .fulfillableInstantly1, // should increase +2 (total 108)
            .maybeFulfillable,      // should multiply by 10 (total 1080)
            .translatesTo3Effects   // should not affect state
        ]

        let expectedCounter = (TestFeatureConstants.initialCounter
            + TestFeatureConstants.instantFulfillAmount1 * 4)
            * TestFeatureConstants.conditionalMultiplier

        // when
        makeStateSubscription()

        wishes.forEach(feature.accept)

        // then
        let lastState = states.last

        XCTAssertEqual(expectedCounter, lastState?.counter)
        XCTAssertEqual(false, lastState?.loading)
    }

    func testLoopbackFromNewsToMultipleWishesHasAccessToCorrectLatestState() {
        // given
        let expectedActorInvocationLog: [TestActor.Log] = [
            .init(state: TestFeatureConstants.initialState, action: TestAction.loopbackWishInitial),
            .init(state: TestFeatureConstants.loopBackInitialState, action: TestAction.loopbackWish1),
            .init(state: TestFeatureConstants.loopBackState1, action: TestAction.loopbackWish2),
            .init(state: TestFeatureConstants.loopBackState2, action: TestAction.loopbackWish3)
        ]

        // when
        feature
            .news
            .sink { [unowned feature] news in
                if news == .loopback {
                    feature?.accept(.loopbackWish2)
                    feature?.accept(.loopbackWish3)
                }
            }
            .store(in: &cancellableBag)

        feature.accept(.loopbackWishInitial)
        feature.accept(.loopbackWish1)

        // then
        XCTAssertEqual(4, actor.invocationLog.count)
        XCTAssertEqual(expectedActorInvocationLog, actor.invocationLog)
    }

    func testActionEmitedByPostProcessorHandledAsExpected() {
        // given
        let expectedActorInvocationLog: [TestActor.Log] = [
            .init(state: TestFeatureConstants.initialState, action: TestAction.postProcessingRequired),
            .init(state: TestFeatureConstants.initialState, action: TestAction.fulfillableInstantly1)
        ]

        // when
        feature.accept(.postProcessingRequired)

        // then
        XCTAssertEqual(2, actor.invocationLog.count)
        XCTAssertEqual(expectedActorInvocationLog, actor.invocationLog)
    }

    func testNoMemoryLeaksInBaseFeature() {
        // given
        feature = makeFeature(bootstrapper: DefaultBootstrapper(firstAction: .bootstrap))

        let wishes: [TestWish] = [
            .loopbackWish1,
            .fulfillableAsync(delay: 1),
            .postProcessingRequired,
            .fulfillableInstantly1
        ]

        weak var weakFeature = feature

        // when
        wishes.forEach(feature.accept)

        feature = nil//makeFeature()

        // then
        XCTAssertNil(weakFeature)
    }
}
