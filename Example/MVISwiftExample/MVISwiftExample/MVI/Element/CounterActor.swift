import MVISwift

import Foundation
import Combine

extension AnyPublisher {

    public static func fail(error: Failure) -> AnyPublisher<Output, Failure> {
        Fail(error: error).eraseToAnyPublisher()
    }

    public static func just(_ output: Output) -> AnyPublisher<Output, Failure> {
        Just(output)
            .setFailureType(to: Failure.self)
            .eraseToAnyPublisher()
    }

    public static func fail(_ failure: Failure) -> AnyPublisher<Output, Failure> {
        Fail(error: failure)
            .eraseToAnyPublisher()
    }

    public static func empty() -> AnyPublisher<Output, Failure> {
        Empty()
            .setFailureType(to: Failure.self)
            .eraseToAnyPublisher()
    }
}

class CounterActor: Actor {

    func process(state: CounterState, action: CounterAction) -> AnyPublisher<CounterEffect, Never> {
        switch action {
        case .increaseCounter:
            return .just(.add(1))

        case .decreaseCounter:
            return .just(.substract(1))
        }
    }
}
