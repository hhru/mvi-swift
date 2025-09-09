import Combine

public protocol Feature: Store {
    associatedtype News

    var cancellableBag: MVICancellableBag { get }

    var news: AnyPublisher<News, Never> { get }
}
