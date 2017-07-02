//
//  main.swift
//  ElgamalAlgorithm
//
//  Created by Artem Misesin on 5/29/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import Foundation

func randomInt(min: Int, max: Int) -> Int {
    return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}

func getPrimes(to n: Int) -> [Int] {
    let xmody = (1...n)
        .map { x in (1...n).map { y in x % y } }
    
    let primes = xmody
        .map { mods in
            mods.enumerated()
                .filter { y, mod in mod == 0 }
                .map { y, mod in y + 1 } // divisors for x
        }
        .enumerated()
        .filter { x, zs in
            guard let z0 = zs.first, let z1 = zs.last, zs.count <= 2 else {
                return false
            }
            return z0 == 1 && z1 == x + 1
        }
        .map { x, _ in x + 1 }
    
    return primes
}

var M = 230

var primeArray = getPrimes(to: 500)

print(primeArray)

var p = 0

while (p < M){
    var number = randomInt(min: 5, max: primeArray.count - 1)
    
    p = primeArray[number]
}

print(p)

var g = randomInt(min: 2, max: p - 1)

print("g \(g)")

var x = randomInt(min: 2, max: p - 1)

print("x \(x)")

func level(_ f1: Int, to f2: Int) -> Int{
    var temp = f1
    for _ in 1..<f2{
        temp *= f1
    }
    return temp
}

func isPrime(_ number: Int) -> Bool {
    return number > 1 && !(2..<number).contains { number % $0 == 0 }
}

func reduce(_ a: Int, mod: Int) -> Int{
    var a1 = 0
    var tmp = a % mod
    while true {
        a1 = randomInt(min: 0, max: mod)
        if (a1 % mod == tmp){
            return a1
        }
    }
}

func modulo(of num: Int, power: Int, to mod: Int) -> Int{
    var a1 = reduce(num, mod: mod)
    var p = 1
    var i = 1
    while (i <= power){
        p *= a1
        p = reduce(p, mod: mod)
        i += 1
    }
    return p
}
//var y = level(g, to: x)%p
var y = modulo(of: g, power: x, to: p)

print("y \(y)")

var publicKey = (p, g, y)
var privateKey = x

var k = randomInt(min: 2, max: p - 1)

print("k \(k)")

//var a = level(g, to: k)%p
var a = modulo(of: g, power: k, to: p)

print("a \(a)")

//var b = (level(y, to: k)*M)%p
var b = modulo(of: y, power: k, to: p)
b = modulo(of: b*M, power: 1, to: p)

print("b \(b)")

var encrypted = (a, b)

var newM = modulo(of: a, power: p - 1 - x, to: p) // b*level(a, to: p - 1 - x)
newM = modulo(of: b * newM, power: 1, to: p)

print("M \(newM)")
