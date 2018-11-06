//
//  LogicSystem.swift
//  Logic
//
//  Created by Zackory Cramer on 11/1/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class LogicSystem {
	
	private var _evaluator: Evaluator
	private var _assertionCurryer: AssertionCurry?
	
	func addFact(_ premise: Premise, _ result: Result) {
		_evaluator.addFact(premise, result)
	}

	func addPremise(_ premise: Premise) {
		_evaluator.addPremise(premise)
	}
	
	var _poppedPremise: Premise?
	var _shouldEvalute: Bool
	
	func evaluateAll() {
		_shouldEvalute = true
		_evaluator.evaluateAll()
	}
	
	func forEveryFact(_ function: (Premise, Result) -> ()) {
		_evaluator.getFactionary().dictionary().forEach(function)
	}
	
	func clearEvalutations() {
		_evaluator.clearEvaluations()
	}
	
	func printFacts() {
		_evaluator.printFacts()
	}
	
	func printPremises() {
		_evaluator.printPremises()
	}
	
	func printUnevaluatedPremises() {
		_evaluator.printUnevaluatedPremises()
	}
	
	func printEverything() {
		_evaluator.printFacts()
		_evaluator.printPremises()
		_evaluator.printMeta()
	}
	
	init(_ delegate: AssertionDelegate? = nil) {
		_evaluator = Evaluator(AssertionCurry.init(delegate))
		_shouldEvalute = false
	}
	
	/**
	 * Stack the popped Query on top of the stack.
	 * Only call this when you made sure the query
	 * to add is unevaluated.
	 */
//	private func stackDerivedQuery(_ quety: Query, discardPopped: Bool = false) {
//		if !discardPopped, let popped = _poppedQuery {
//			if !_queries.stack(popped) {
//				print("mesteryous existing: ", popped)
//			}
//		}
//		if !_queries.stack(query) {
//			declareSelfEvaluate(on: query)
//			return
//		}
//	}
	
	/**
	* Stack the user requested predicate to be process.
	*/
//	private func stackRequestedPredicate(_ pred: Predicate) {
//		guard pred.getResult() == nil else {
//			print("Predicate: ", pred, " already evaluated.")
//			return
//		}
//		if _predicates.stack(pred) {
//			_queryToPredMap[pred.getQuery()] = pred
//			stackRequestedQuery(pred.getQuery())
//		}
//	}
	
	/**
	 * Add the (Query, Result) pair to the facts Dictionary. Update the predicates possibly.
	 */
//	private func setEvaluationForQuery(_ query: Query, _ result: Result) {
//		if _facts.hasEvaluatedQuery(query) && _facts.resultForQuery(query) != result {
//			declareContradtion(on: query, with: result)
//		}
//		_facts.addEvaluatedQuery(query, result)
//	}
}

extension LogicSystem {
//	private func evaluateAnd(_ q1: Query, _ q2: Query) {
//		if !_facts.hasEvaluatedQuery(q1) {
//			stackDerivedQuery(q1)
//			return
//		}
//		if !_facts.hasEvaluatedQuery(q2) {
//			stackDerivedQuery(q2)
//			return
//		}
//		_facts.addEvaluatedQuery(_poppedQuery!, _facts.resultForQuery(q1)! & _facts.resultForQuery(q2)!)
//	}
//
//	private func evaluateIs(_ q: Query) {
//		if let res = _facts.resultForQuery(q) {
//			_facts.addEvaluatedQuery(_poppedQuery!, res)
//			return
//		}
//		if let expansion = QueryExander.getExandedQuery(_poppedQuery!) {
//			stackDerivedQuery(expansion)
//			return
//		} else {
//			_shouldEvalute = false
//			print("unexpandable \(_poppedQuery!)")
//		}
//	}
//
//	private func evaluateNot(_ q: Query) {
//		if let res = _facts.resultForQuery(q) {
//			_facts.addEvaluatedQuery(_poppedQuery!, res.opposite(res))
//			return
//		}
//		stackDerivedQuery(q)
//	}
//
//	private func evaluateIsTrue() {
//		if let expansion = QueryExander.getExandedQuery(_poppedQuery!) {
//			if let res = _facts.resultForQuery(expansion) {
//				_facts.addEvaluatedQuery(_poppedQuery!, res)
//				return
//			}
//			stackDerivedQuery(expansion)
//			return
//		} else {
//			_shouldEvalute = false
//			print("unexpandable \(_poppedQuery!)")
//
//		}
//	}
}
