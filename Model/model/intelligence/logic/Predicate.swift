//
//  Predicate.swift
//  Logic
//
//  Created by Zackory Cramer on 11/1/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class Predicate: NSObject {
	
	override var description: String {
		var str = "Query: \(String(describing: _query))"
		if let res = _result {
			str.append(", Result: \(String(describing: res))")
		}
		if let tip = _tippingResult {
			str.append(", Tip: \(String(describing: tip))")
		}
		return str
	}
	
	private let _query: Query
	private var _result: Result?
	private let _tippingResult: Result?
	
	func getQuery() -> Query {
		return _query
	}
	
	func getTippingResult() -> Result? {
		return _tippingResult
	}
	
	func getResult() -> Result? {
		return _result
	}
	
	func setResult(_ result: Result) {
		_result = result
	}
	
	func isSolved() -> Bool {
		return _result != nil
	}
	
	init(query: Query, result: Result? = nil, tippingResult: Result? = nil) {
		_query = query
		_tippingResult = tippingResult
		_result = result
	}
}
