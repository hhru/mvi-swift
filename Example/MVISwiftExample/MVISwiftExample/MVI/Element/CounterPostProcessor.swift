import MVISwift

struct CounterPostProcessor: PostProcessor {

    func process(action: CounterAction, effect: CounterEffect, state: CounterState) -> CounterAction? {
        nil
    }
}
