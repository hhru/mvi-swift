//___FILEHEADER___

import MVISwift

typealias ___VARIABLE_productName:identifier___Feature = BaseFeature<
    ___VARIABLE_productName:identifier___State,
    ___VARIABLE_productName:identifier___Wish,
    ___VARIABLE_productName:identifier___Bootstrapper,
    ___VARIABLE_productName:identifier___WishToAction,
    ___VARIABLE_productName:identifier___Actor,
    ___VARIABLE_productName:identifier___Reducer,
    ___VARIABLE_productName:identifier___PostProcessor,
    ___VARIABLE_productName:identifier___NewsPublisher
>

struct ___VARIABLE_productName:identifier___State: FeatureState { }

enum ___VARIABLE_productName:identifier___Wish { }

typealias ___VARIABLE_productName:identifier___Action = ___VARIABLE_productName:identifier___Wish

enum ___VARIABLE_productName:identifier___Effect { }

enum ___VARIABLE_productName:identifier___News { }

// MARK: - Elements

typealias ___VARIABLE_productName:identifier___WishToAction = DefaultWishToAction<___VARIABLE_productName:identifier___Wish>

typealias ___VARIABLE_productName:identifier___Bootstrapper = DefaultBootstrapper<___VARIABLE_productName:identifier___Action>

typealias ___VARIABLE_productName:identifier___NewsPublisher = EmptyNewsPublisher<___VARIABLE_productName:identifier___Action, ___VARIABLE_productName:identifier___Effect, ___VARIABLE_productName:identifier___State, ___VARIABLE_productName:identifier___News>

typealias ___VARIABLE_productName:identifier___PostProcessor = EmptyPostProcessor<___VARIABLE_productName:identifier___Action, ___VARIABLE_productName:identifier___Effect, ___VARIABLE_productName:identifier___State>
