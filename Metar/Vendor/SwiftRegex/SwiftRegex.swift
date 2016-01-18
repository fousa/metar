//
//  SwiftRegex.swift
//  SwiftRegex
//
//  Created by Gregory Todd Williams on 6/7/14.
//  Copyright (c) 2014 Gregory Todd Williams. All rights reserved.
//

import Foundation



infix operator =~ {}

func =~ (value: String, pattern: String) -> RegexMatchResult { // tailor:disable

    let nsstr = value as NSString // we use this to access the NSString methods like .length and .substringWithRange(NSRange)
    let options = NSRegularExpressionOptions(rawValue: 0)
    let result: NSRegularExpression
    do {
        result = try NSRegularExpression(pattern: pattern, options: options)
    } catch {
        return RegexMatchResult(items: [])
    }
    let all = NSRange(location: 0, length: nsstr.length)
    let moptions = NSMatchingOptions(rawValue: 0)
    var matches: Array<String> = []
    result.enumerateMatchesInString(value, options: moptions, range: all) { (result, flags, ptr) -> Void in
        if let result = result {
            let string = nsstr.substringWithRange(result.range)
            matches.append(string)
        }
    }
    return RegexMatchResult(items: matches)
}

struct RegexMatchCaptureGenerator: GeneratorType {

    mutating func next() -> String? {
        if items.isEmpty {
            return nil
        }
        let ret = items[0]
        items = items[1..<items.count]
        return ret
    }

    var items: ArraySlice<String>
}

struct RegexMatchResult: SequenceType, BooleanType {

    var items: Array<String>

    func generate() -> RegexMatchCaptureGenerator {
        return RegexMatchCaptureGenerator(items: items[0..<items.count])
    }

    var boolValue: Bool {
        return items.count > 0
    }
    subscript (i: Int) -> String {
        return items[i]
    }
}
