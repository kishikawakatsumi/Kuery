# Kuery

[![Build Status](https://www.bitrise.io/app/6c18477b4b7fa507/status.svg?token=YawzB8weVKp_uqJ-DhdkXg)](https://www.bitrise.io/app/6c18477b4b7fa507)

Kuery, a type-safe Core Data query API using Swift 4's Smart KeyPaths.

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
