//
//  Fact.swift
//  Logic
//
//  Created by Zackory Cramer on 11/1/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class Facts: Hashable {
	
	private var _premises = Dictionary<Premise, Result>()
	
	func hasEvaluatedPremise(_ premise: Premise) -> Bool {
		return _premises[premise] != nil
	}
	
	func resultForPremise(_ premise: Premise) -> Result? {
		return _premises[premise]
	}
	
	func dictionary() -> Dictionary<Premise, Result> {
		return _premises
	}
	
	/// Adds the evaluated fact to the dictionary.
	/// - Returns: Wether the premise was successfully inserted, false otherwise.
	///
	func addEvaluatedPremise(_ premise: Premise, _ result: Result) -> Bool {
		guard _premises[premise] == nil else { return _premises[premise] == result }
		_premises[premise] = result
		return true
	}
	
	func removeAll() {
		_premises.removeAll()
	}
	
	func printFacts() {
		print("Facts   =====")
		for (q, r) in _premises {
			print("\(q.description) is \(r)")
		}
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(_premises)
	}
	
	init() {
		
	}
	
	static func == (lhs: Facts, rhs: Facts) -> Bool {
		return lhs._premises == rhs._premises
	}
}
