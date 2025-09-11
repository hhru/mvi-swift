//
//  MVICancellableBag.swift
//  MVISwift
//
//  Created by a.maksimkin on 09.09.2025.
//

@preconcurrency import Combine
import Foundation

public final class MVICancellableBag: IdentifiableObject, @unchecked Sendable {

    private var storage: Set<AnyHashable> = []
    private var queue: DispatchQueue!

    public init() {
        queue = DispatchQueue(
            label: "\(Self.self): \(self.objectID)",
            qos: .userInitiated,
            attributes: .concurrent
        )
    }

    public func store(_ cancellable: AnyCancellable) {
        queue.async(flags: .barrier) {
            self.storage.insert(cancellable as AnyHashable)
        }
    }

    public func store<T: Combine.Cancellable>(_ cancellable: T) {
        store(Combine.AnyCancellable(cancellable))
    }

    public func removeAll() {
        queue.sync {
            self
                .storage
                .lazy
                .compactMap { $0 as? Combine.AnyCancellable }
                .forEach { $0.cancel() }

            self.storage.removeAll()
        }
    }
}

extension Cancellable {

    public func store(in bag: MVICancellableBag) {
        bag.store(self)
    }
}

public protocol IdentifiableObject: AnyObject { }

extension IdentifiableObject {

    public var objectID: String {
        "\(Unmanaged.passUnretained(self).toOpaque())"
    }
}
