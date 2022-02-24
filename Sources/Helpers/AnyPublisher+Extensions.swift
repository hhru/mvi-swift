import Foundation
import Combine

extension AnyPublisher {

    static func fail(error: Failure) -> AnyPublisher<Output, Failure> {
        Fail(error: error).eraseToAnyPublisher()
    }

    static func just(_ output: Output) -> AnyPublisher<Output, Failure> {
        Just(output)
            .setFailureType(to: Failure.self)
            .eraseToAnyPublisher()
    }

    static func fail(_ failure: Failure) -> AnyPublisher<Output, Failure> {
        Fail(error: failure)
            .eraseToAnyPublisher()
    }

    static func empty() -> AnyPublisher<Output, Failure> {
        Empty()
            .setFailureType(to: Failure.self)
            .eraseToAnyPublisher()
    }
}
