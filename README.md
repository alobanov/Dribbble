# Client for Dribbble write with ❤️ and MVVM + Rx + Moya

This is an example project to demonstrate MVVM ([Model-View-ViewModel](https://en.wikipedia.org/wiki/Model_View_ViewModel)) architecture with [RxSwift](https://github.com/ReactiveX/RxSwift). For network layer used a [Moya framework](https://github.com/Moya/Moya).

## Requirements

- Xcode 8.4 or later
- [Dribble](https://github.com/settings/tokens) personal access token, to setup it use [cocoapods-keys](https://github.com/orta/cocoapods-keys)

## Keys
```
plugin 'cocoapods-keys', {
    :project => "Dribbble",
    :keys => [
      "DribbbleClientID",
      "DribbbleClientSecret",
      "DribbbleClientAccessToken"
    ]}
```    
Then running pod install will prompt for the keys not yet set and you can ensure everyone has the same setup.
