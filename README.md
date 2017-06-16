# Kuery

[![Build Status](https://www.bitrise.io/app/6c18477b4b7fa507/status.svg?token=YawzB8weVKp_uqJ-DhdkXg)](https://www.bitrise.io/app/6c18477b4b7fa507)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/Kuery.svg)](https://cocoapods.org/pods/Kuery)
[![Platform](https://img.shields.io/cocoapods/p/Kuery.svg)](https://cocoapods.org/pods/Kuery)

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

The following code i a compile error occurs.

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
