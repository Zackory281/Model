//
//  PremiseTable.swift
//  Logic
//
//  Created by Zackory Cramer on 11/3/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class PremiseTable {
	
	private var _premiseDirection = Dictionary<Premise, Premise>()
	
	func addPremiseDirection(iftrue premise1: Premise, ifTrue premise2: Premise) {
		_premiseDirection[premise1] = premise2
	}
	
	func getDirectionForPremise(_ premise: Premise) -> Premise? {
		return _premiseDirection[premise]
	}
	
}
