import MVISwift

struct CounterReducer: Reducer {

    func process(state: CounterState, effect: CounterEffect) -> CounterState {
        switch effect {
        case .add(let number):
            return CounterState(counter: state.counter + number)
        case .substract(let number):
            return CounterState(counter: state.counter - number)
        }
    }
}
