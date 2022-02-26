import OpenCombine

public protocol Feature: Store {
    associatedtype News

    var cancellableBag: Set<AnyCancellable> { get set }

    var news: AnyPublisher<News, Never> { get }
}
