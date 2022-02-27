import MVISwift

enum CounterNews {
    case animate
}

struct CounterNewsPublisher: NewsPublisher {

    func process(action: CounterAction, effect: CounterEffect, state: CounterState) -> CounterNews? {
        nil
    }
}
