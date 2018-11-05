//
//  LogicManager.swift
//  Model
//
//  Created by Zackory Cramer on 11/4/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class LogicManager : NSObject {
	
	weak var _nodeQueryDelegate: QueryNodeDelegate?
	
	private var _queries = Set<CustomQuery>()
	private var _logic: LogicSystem!
	
	func initializeLogicSystem(_ delegate: AssertionDelegate) {
		_logic = LogicSystem(delegate)
	}
	
	func gatherQuery() {
		_logic.clearEvalutations()
		if let nodeQueries = _nodeQueryDelegate?.getQueries() {
			_queries = _queries.union(nodeQueries)
		}
		for query in _queries {
			_logic.addPremise(Premise(query))
		}
		_logic.printUnevaluatedPremises()
	}
	
	func evaluateQueries() {
		_logic.evaluateAll()
		_logic.forEveryFact { (premise, result) in
			guard let cq = premise.getCustomQuery() else { return }
			switch cq {
			case let .ShapeNowMove(shapeNode):
				//shapeNode.advance()
				print("new position for ", shapeNode)
			default:
				return
			}
		}
		_logic.printEverything()
	}
	
	func flushQueries() {
		_queries.removeAll()
	}
	
}

protocol QueryNodeDelegate: NSObjectProtocol {
	func getQueries() -> Set<CustomQuery>
}
