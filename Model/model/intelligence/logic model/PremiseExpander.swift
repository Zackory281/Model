//
//  QueryExpander.swift
//  Logic
//
//  Created by Zackory Cramer on 11/2/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class QueryExander {
	
	static func getDerivedPremises(_ premise: Premise, _ facts: Facts) -> [Premise]? {
		if let cq = premise.getCustomQuery() {
			guard let p = getDerivedCustomPremises(cq) else {
				return nil
			}
			return [p]
		}
		if let query = premise.getQuery() {
			switch query {
			case let Query.IsTrue(n):
				return [Premise(.IsTrue(n.next()))]
			case let Query.And(p1, p2):
				return [p1, p2]
			case let Query.Or(p1, p2):
				return [p1, p2]
			case let Query.Not(p):
				return [p]
			case let Query.Is(p):
				return [p]
			}
		}
		print("No query! this is bad!")
		return nil
	}
	
}
