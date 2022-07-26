//
//  String+Ext.swift
//  Pr2503
//
//  Created by Stanislav Rassolenko on 7/23/22.
//

import Foundation

extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }

    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
    
    func intoArray(interval n: Int) -> [String] {
        var result: [String] = []
        let characters = Array(self)
        stride(from: 0, to: characters.count, by: n).forEach {
            result.append(String(characters[$0..<min($0+n, characters.count)]))
        }
        return result
    }
}

func indexOf(character: Character, _ array: [String]) -> Int {
    return array.firstIndex(of: String(character)) ?? 0
}

func characterAt(index: Int, _ array: [String]) -> Character {
    return index < array.count ? Character(array[index])
                               : Character("")
}
