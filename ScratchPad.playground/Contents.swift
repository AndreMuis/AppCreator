//: Playground - noun: a place where people can play

import UIKit

var array = [3, 4, 5, 1]


// sorting

let first = array.sort{$0 < $1}.last

first


class SomeClass : UICollectionViewDataSource
{
    @objc func doSomething()
    {
        print("doSomething")
    }
}


let someClass = SomeClass()

someClass.doSomething()


