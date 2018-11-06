//
//  Vocab.swift
//  Logic
//
//  Created by Zackory Cramer on 11/1/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

enum Noun: Int, CustomStringConvertible {
	var description: String { return String(UnicodeScalar(0x1F34E + self.rawValue)!)}
	case A = 0
	case B = 1
	case C = 2
	case D = 3
	case NULL = 4
	func next() -> Noun {
		return Noun.init(rawValue: (rawValue + 1) % Noun.NULL.rawValue)!
	}
}

class Result: NSObject {
	
	override var debugDescription: String { return _null ? "nil" : "b: \(_bool) g: \(_grade)"}
	override var description: String { return _null ? "nil" : "b: \(_bool) g: \(_grade)"}
	private var _bool, _null: Bool
	private var _grade: Int8
	
	func getBool() -> Bool? {
		return _null ? nil : _bool
	}
	
	func getGrade() -> Int8 {
		return _grade
	}
	
	func getOppositeClone() -> Result {
		return Result(!_bool, _grade)
	}
	
	func matches(_ result: Result) -> Bool{
		return self._bool == result._bool && self._grade == result._grade && self._null == result._null
	}
	
	init(_ bool: Bool, _ grade: Int8) {
		_bool = bool
		_grade = grade
		_null = false
	}
}

extension Result {
	static func &(rhs: Result, lhs: Result) -> Result? {
		guard !rhs._null && !lhs._null else { return nil}
		return Result(rhs._bool && lhs._bool, min(rhs.getGrade(), lhs.getGrade()))
	}
	
	static func |(rhs: Result, lhs: Result) -> Result? {
		guard !rhs._null && !lhs._null else { return nil}
		return Result(rhs._bool || lhs._bool, max(rhs.getGrade(), lhs.getGrade()))
	}
}

class Premise: Hashable, CustomStringConvertible {
	
	var description: String { return _query?.description ?? _customQuery!.description }
	let _query: Query?
	let _customQuery: CustomQuery?
	
	func hasQuery() -> Bool {
		return _query != nil
	}
	
	func getQuery() -> Query? {
		return _query
	}
	
	func getCustomQuery() -> CustomQuery? {
		return _customQuery
	}
	
	init(_ query: Query?) {
		_query = query
		_customQuery = nil
	}
	
	init(_ query: CustomQuery?) {
		_customQuery = query
		_query = nil
	}
	
	static func == (lhs: Premise, rhs: Premise) -> Bool {
		return lhs._query == rhs._query && lhs._customQuery == rhs._customQuery
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(_query)
		hasher.combine(_customQuery)
	}
}

enum Query: Equatable, Hashable, CustomStringConvertible {
	
	var description: String {
		switch self {
		case let .And(q1, q2):
			return "(\(q1) and \(q2))"
		case let .Or(q1, q2):
			return "(\(q1) or \(q2))"
		case let .Not(q1):
			return "(not \(q1)"
		case let .Is(q1):
			return "(is \(q1))"
		case let .IsTrue(n):
			return "(is \(n))"
		}
	}
	
	case And(Premise, Premise)
	case Or(Premise, Premise)
	case Not(Premise)
	case Is(Premise)
	case IsTrue(Noun)
}

class Condition {
	
}
