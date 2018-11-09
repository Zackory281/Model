//
//  FuckYou.swift
//  Model
//
//  Created by Zackory Cramer on 11/6/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//
//
//  Evaluator.swift
//  Model
//
//  Created by Zackory Cramer on 11/3/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class Evaluator {
	
	private let _facts = Facts()
	private let _premises = SetStack<Premise>()
	private var _toEvaluatePremises = Set<Premise>()
	private let _premiseGraph = TreeGraph<Premise>()
	private let _premiseDirection = PremiseTable()
	
	private var _poppedPremise: Premise?
	private var _shouldEvalute: Bool = false
	
	private var _assertionDelegate: AssertionCurry?
	
	func addFact(_ premise: Premise, _ result: Result) {
		if !_facts.addEvaluatedPremise(premise, result) {
			print("Premise already in factionary. ", premise, result)
		}
	}
	
	@discardableResult
	func addPremise(_ premise: Premise) -> Bool {
		guard _premiseGraph.addElementWithoutParent(premise) else {
			print("Premise is a duplicate in graph: ", premise)
			return true
		}
		guard _toEvaluatePremises.insert(premise).0 else {
			print("Premise is a duplicate in set: ", premise)
			return true
		}
		return false
	}
	
	/// return - Wether the evaluation succeeded.
	func evaluateAll() -> Bool {
		_shouldEvalute = true
		while _shouldEvalute, let toEvalPremise = _toEvaluatePremises.first {
			guard _premises.stack(toEvalPremise) else {
				print("Premises stack should be empty...")
				return false
			}
			while _shouldEvalute, let poppedPremise = _premises.pop() {
				_poppedPremise = poppedPremise
				_evaluations += 1
				if let r = evaluateOnFacts(poppedPremise) {
					imposeResult(premise: poppedPremise, result: r)
					continue
				}
				_delegateChecking += 1
				if let q = poppedPremise.getCustomQuery(), let derivation = _assertionDelegate?.evaluateOnAssertionDelegate(q) {
					switch derivation {
					case let .Result(result):
						imposeResult(premise: poppedPremise, result: result)
					case let .Premise(premise):
						stackDerivedPremises([premise], discardPopped: false)
					}
					continue
				}
				_derivations += 1
				if let derivePremises = QueryExander.getDerivedPremises(poppedPremise, _facts), !derivePremises.isEmpty {
					stackDerivedPremises(derivePremises)
					continue
				}
				print("no derivable premises, ", poppedPremise, " is unevaluatable.")
				_shouldEvalute = false
			}
			_poppedPremise = nil
			_toEvaluatePremises.remove(toEvalPremise)
		}
		return _shouldEvalute
	}
	
	func clearEvaluations() {
		_premiseGraph.clearAll()
		_facts.removeAll()
		_premises.clearAll()
		_evaluations = 0
		_derivations = 0
		_factChecking = 0
		_delegateChecking = 0
	}
	
	func getFactionary() -> Facts {
		return _facts
	}
	
	func printFacts() {
		_facts.printFacts()
	}
	
	func printPremises() {
		print("Premises =====")
		_premises.printStack()
	}
	
	func printUnevaluatedPremises() {
		print("Unevaluated Premises")
		print(_toEvaluatePremises)
	}
	
	func printMeta() {
		print("Evaluations: ", _evaluations)
		print("Derivations: ", _derivations)
		print("Fact Checking: ", _factChecking)
		print("Delegate Checking: ", _delegateChecking)
	}
	
	func evaluateOnFacts(_ premise: Premise) -> Result? {
		_factChecking += 1
		if let res = _facts.resultForPremise(premise) {
			return res
		}
		if let query = premise.getQuery() {
			switch query {
			case let .And(p1, p2):
				let (b1, b2) = (_facts.resultForPremise(p1), _facts.resultForPremise(p2))
				guard b1 != nil && b2 != nil else {
					return nil
				}
				return b1! & b2!
			case let .Or(p1, p2):
				if let b1 = _facts.resultForPremise(p1), b1.getBool() == true {
					return b1
				}
				if let b2 = _facts.resultForPremise(p2), b2.getBool() == true {
					return b2
				}
				return nil
			case let .Not(p):
				return _facts.resultForPremise(p)?.getOppositeClone()
			case .IsTrue:
				if let cond = _premiseGraph.getParents(premise)?.first, let res = _facts.resultForPremise(cond) {
					return res
				}
			default:
				return nil
			}
		}
		if let cond = _premiseGraph.getParents(premise)?.first, let res = _facts.resultForPremise(cond) {
			return res
		}
		return nil
	}
	
	init(_ assertionCurry: AssertionCurry? = nil) {
		_assertionDelegate = assertionCurry
	}
	
	private func imposeResult(premise: Premise, result: Result) {
		if !_facts.addEvaluatedPremise(premise, result) {
			declareContradtion(on: premise, with: result)
		}
	}
	
	/**
	* Recognize the contradtion. Pops off the previous stacked premise
	*/
	private func declareContradtion(on premise: Premise, with result: Result) {
		print("Detected contradting query: ", premise, ", with result: ", result.description)
		print(_premiseGraph.getParentTrace(from: premise))
		_shouldEvalute = false
	}
	
	/**
	* Recognize the contradtion after the pop of the premise
	*/
	private func declareSelfEvaluation(on premise: Premise) {
		//print("Detected self evaluating premise: ", premise)
		if let customQuery = premise._customQuery {
			switch (customQuery) {
			case .ShapeNowMove(_):
				//print("ShapeNowMove loop, assume true with negative grade.")
				imposeResult(premise: premise, result: Result(true, -1))
				return
			default:
				break
			}
		}
		print("Premise Stack Trace")
		_shouldEvalute = false
	}
	
	/**
	* Stack the popped Query on top of the stack.
	* Only call this when you made sure the query
	* to add is unevaluated.
	*/
	private func stackDerivedPremises(_ permises: [Premise], discardPopped: Bool = false) {
		guard _premises.stack(_poppedPremise!) else {
			print("Somehow returne true for popped premise: ", _poppedPremise!)
			return
		}
		for premise in permises {
			_premiseGraph.addElementWithParent(_poppedPremise!, premise)
			guard _premises.stack(premise) else {
				declareSelfEvaluation(on: premise)
				return
			}
		}
	}
	
	// Meta, _drivations, _factChecking
	private var _evaluations:Int = 0
	private var _derivations:Int = 0
	private var _factChecking:Int = 0
	private var _delegateChecking:Int = 0
}
