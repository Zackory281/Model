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
	}
	
	func evaluateQueries() -> Bool {
		let ret = _logic.evaluateAll()
		defer {
			//_logic.printEverything()
		}
		return ret
	}
	
	func imposeFacts() {
		//guard let nodeController = _nodeController else { print("Shape node controller not setup in Logic Manager returning from making moves."); return}
		_logic.forEveryFact { (premise, result) in
			guard let cq = premise.getCustomQuery(), result.getBool() == true else { return }
			switch cq {
			case let .ShapeNowMove(shapeNode):
				shapeNode._state = .Moving
			default:
				return
			}
		}
	}
	func flushQueries() {
		_queries.removeAll()
	}
	
	func tick(_ tick :TickU) {
		if _shouldEval {
			flushQueries()
			gatherQuery()
			if evaluateQueries() {
				imposeFacts()
			}
		}
//		if tick % 2 == 1 {
//		} else {
//		}
	}
	
	private var _shouldEval = true
	
}

protocol QueryNodeDelegate: NSObjectProtocol {
	func getQueries() -> Set<CustomQuery>
}
