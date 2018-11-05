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
	weak var _nodeController:NodeControlDelegate?
	
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
		_logic.printEverything()
		guard let nodeController = _nodeController else { print("Shape node controller not setup in Logic Manager returning from making moves."); return}
		_logic.forEveryFact { (premise, result) in
			guard let cq = premise.getCustomQuery(), result.getBool() == true else { return }
			switch cq {
			case let .ShapeNowMove(shapeNode):
				nodeController.advance(shapeNode)
				
				print("new position for ", shapeNode)
			default:
				return
			}
		}
	}
	
	func flushQueries() {
		_queries.removeAll()
	}
	
	func tick(_ tick :Int16) {
		if tick % 2 == 1 {
			flushQueries()
			gatherQuery()
		} else {
			evaluateQueries()
		}
	}
	
}

protocol QueryNodeDelegate: NSObjectProtocol {
	func getQueries() -> Set<CustomQuery>
}
