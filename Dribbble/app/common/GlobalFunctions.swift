import RxSwift
import ReachabilitySwift
import Moya

private let reachabilityManager = ReachabilityManager()

// An observable that completes when the app gets online (possibly completes immediately).
func connectedToInternetOrStubbing() -> Observable<Bool> {
  let online = reachabilityManager.reach
//      let stubbing = Observable.just(true)
  
  return online
}

func responseIsOK(_ response: Response) -> Bool {
  return response.statusCode == 200
}

func delay(_ delay:Double, closure: @escaping ()->()) {
  let when = DispatchTime.now() + delay
  DispatchQueue.main.asyncAfter(deadline: when){
    // Your code with delay
    closure()
  }
}

func removeDuplicates<E: Hashable>(source: Array<E>) -> Array<E> {
  var alreadyThere = Set<E>()
  return source.flatMap { (post) -> E? in
    guard !alreadyThere.contains(post) else { return nil }
    alreadyThere.insert(post)
    return post
  }
}

func detectDevelopmentEnvironment() -> Bool {
  var developmentEnvironment = false
  #if DEBUG || (arch(i386) || arch(x86_64)) && os(iOS)
    developmentEnvironment = true
  #endif
  return developmentEnvironment
}

private class ReachabilityManager: NSObject {
  let _reach = ReplaySubject<Bool>.create(bufferSize: 1)
  var reach: Observable<Bool> {
    return _reach.asObservable()
  }
  
  private let reachability: Reachability? = {
    let reachability = Reachability()
    return reachability
  }()
  
  override init() {
    super.init()
    
    reachability?.whenReachable = { [weak self] reachability in
      DispatchQueue.main.async {
        self?._reach.onNext(true)
      }
    }
    
    reachability?.whenUnreachable = { [weak self] reachability in
      DispatchQueue.main.async {
        self?._reach.onNext(false)
      }
    }
    
    do {
      try reachability?.startNotifier()
    } catch {
      print("Unable to start notifier")
    }
    _reach.onNext(reachability!.isReachable)
  }
}

func roundToPlaces(value: Double, decimalPlaces: Int) -> Double {
  let divisor = pow(10.0, Double(decimalPlaces))
  return round(value * divisor) / divisor
}
