import RxSwift

extension Observable where Element: Equatable {
    func ignore(_ value: Element) -> Observable<Element> {
        return filter { (e) -> Bool in
            return value != e
        }
    }
}

protocol OptionalType {
    associatedtype Wrapped
    
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    var value: Wrapped? {
        return self
    }
}

extension ObservableType where E : Equatable {
  public func ignore(_ valuesToIgnore: E ...) -> Observable<E> {
    return self.asObservable().filter { !valuesToIgnore.contains($0) }
  }
  
  public func ignore<S: Sequence>(_ valuesToIgnore : S) -> Observable<E> where S.Iterator.Element == E {
    return self.asObservable().filter { !valuesToIgnore.contains($0) }
  }
  
  public func ignoreWhen(_ predicate: @escaping (E) throws -> Bool) -> Observable<E> {
    return self.asObservable().filter { try !predicate($0) }
  }
}

extension Observable where Element: OptionalType {
    func filterNil() -> Observable<Element.Wrapped> {
        return flatMap { (element) -> Observable<Element.Wrapped> in
            if let value = element.value {
                return .just(value)
            } else {
                return .empty()
            }
        }
    }
    
    func replaceNilWith(_ nilValue: Element.Wrapped) -> Observable<Element.Wrapped> {
        return flatMap { (element) -> Observable<Element.Wrapped> in
            if let value = element.value {
                return .just(value)
            } else {
                return .just(nilValue)
            }
        }
    }
}

private let backgroundScheduler = SerialDispatchQueueScheduler(qos: DispatchQoS.default)

extension Observable {
    func mapReplace<T>(_ value: T) -> Observable<T> {
        return map { _ -> T in
            return value
        }
    }
    
    func dispatchAsyncMainScheduler() -> Observable<E> {
        return self.observeOn(backgroundScheduler).observeOn(MainScheduler.instance)
    }
}

extension Observable {
    func mapToOptional() -> Observable<Optional<Element>> {
        return map { Optional($0) }
    }
}

func sendDispatchCompleted<T>(_ observer: AnyObserver<T>) {
//    dispatch_get_main_queue().asynchronously() {
//        observer.onCompleted()
//    }
}
