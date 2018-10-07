# Kuery

<p align="center">
    <a href="https://travis-ci.org/kishikawakatsumi/Kuery">
        <img src="https://travis-ci.org/kishikawakatsumi/Kuery.svg?branch=master&style=flat"
             alt="Build Status">
    </a>
    <a href="https://codecov.io/gh/kishikawakatsumi/Kuery">
        <img src="https://codecov.io/gh/kishikawakatsumi/Kuery/branch/master/graph/badge.svg" alt="Codecov" />
    </a>
    <a href="https://cocoapods.org/pods/Kuery">
        <img src="https://img.shields.io/cocoapods/v/Kuery.svg?style=flat"
             alt="Pods Version">
    </a>
    <a href="http://cocoapods.org/pods/Kuery/">
        <img src="https://img.shields.io/cocoapods/p/Kuery.svg?style=flat"
             alt="Platforms">
    </a>
    <a href="https://github.com/Carthage/Carthage">
        <img src="https://img.shields.io/badge/Carthage-compatible-brightgreen.svg?style=flat"
             alt="Carthage Compatible">
    </a>
    <a href="https://swift.org/">
        <img src="https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat"
             alt="Swift 4.0">
    </a>
    <a href="https://swift.org/">
        <img src="https://img.shields.io/badge/Swift-4.1-orange.svg?style=flat"
             alt="Swift 4.1">
    </a>
    <a href="https://swift.org/">
        <img src="https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat"
             alt="Swift 4.2">
    </a>
</p>

Kuery, a type-safe Core Data query API using Swift 4's Smart KeyPaths. Inspired and borrowed a lot of things from [QueryKit](https://github.com/QueryKit/QueryKit) and [RealmEx](https://github.com/koher/RealmEx).

## Requirements
Kuery is written in Swift 4.

## Installation

### CocoaPods
Kuery is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Kuery'
```

### Carthage
For [Carthage](https://github.com/Carthage/Carthage), add the following to your `Cartfile`:

```ogdl
github "kishikawakatsumi/Kuery"
```

## Description

Kuery provides type safety, code completion and avoidance of typos against `NSPredicate` queries.

### Before

```swift
NSPredicate(format: "name == %@", "Katsumi")
NSPredicate(format: "age > %@", 20)
```

### After

```swift
Query(Person.self).filter(\Person.name == "Katsumi")
Query(Person.self).filter(\Person.age > 20)
```

The following code should be a compile error.

```swift
Query(Person.self).filter(\Person.name > 20) // Compile error
Query(Person.self).filter(\Dog.name == "John") // Compile error
```

## Usage

```Swift
context.perform {
    let results = try Query(Person.self)
        .filter(\Person.name == "Katsumi")
        .execute()
}
```

```Swift
context.perform {
    let results = try Query(Person.self)
        .filter(\Person.age == 36)
        .execute()
}
```

```Swift
context.perform {
    let results = try Query(Person.self)
        .filter(\Person.age > 20)
        .execute()
}
```

```Swift
context.perform {
    let results = try Query(Person.self)
        .filter(\Person.name == "Katsumi")
        .filter(\Person.age == 36)
        .execute()
}
```

```Swift
context.perform {
    let results = try Query(Dog.self)
        .filter(\Dog.owner == person)
        .execute()
}
```

### Feature request for Swift Standard Library

It requires a string representation of `KeyPath` to construct `NSPredicate` from `KeyPath`. However, the API is not officially visible currently. The feature request is tracked at [SR-5220](https://bugs.swift.org/browse/SR-5220).

[[SR-5220] Expose API to retrieve string representation of KeyPath - Swift](https://bugs.swift.org/browse/SR-5220)
