//: Playground - noun: a place where people can play

import UIKit

var array = [3, 4, 5, 1]


// sorting

let first = array.sort{$0 < $1}.last

first


// array of types conforming to a protocol

protocol SomeProtocol : Equatable
{
}

func ==<T : SomeProtocol>(lhs: T, rhs: T) -> Bool
{
    return true
}

struct SomeStruct : SomeProtocol
{
}

let a : Array<SomeProtocol> = Array<SomeProtocol>()

let someStruct = SomeStruct()

a.indexOf(someStruct)







