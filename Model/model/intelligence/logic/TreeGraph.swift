//
//  Forrest.swift
//  Logic
//
//  Created by Zackory Cramer on 11/3/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class TreeGraph<T: Hashable> {
	
	private var _roots: Set<T>
	private var _rootSet: Dictionary<T, Set<T>>
	private var _set: Set<T>
	
	init() {
		_roots = []
		_rootSet = Dictionary<T, Set<T>>()
		_set = Set<T>()
	}
	
	func clearAll() {
		_roots.removeAll()
		_rootSet.removeAll()
		_set.removeAll()
	}
	
	func getParents(_ t: T) -> Set<T>? {
		return _rootSet[t]
	}
	
	/// - returns: whether the item is a duplicate, true if not.
	func addElementWithoutParent(_ t: T) -> Bool {
		guard _set.insert(t).0 else { return false}
		guard _roots.insert(t).0 else { return false}
		return true
	}
	
	@discardableResult
	/// - returns: Means nothin. Duplicates are ignored.
	func addElementWithParent(_ t: T, _ p: T) -> Bool {
		let _ = _roots.remove(p)
		if _set.insert(t).0 {
			_roots.insert(t)
		}
		_set.insert(p)
		if _rootSet[t] != nil {
			_rootSet[t]!.insert(p)
		} else {
			var s = Set<T>()
			s.insert(p)
			_rootSet[t] = s
		}
		if _roots.remove(p) != nil {
			_roots.insert(p)
		}
		return true
	}
	
	func getParentTrace(from element: T) -> Set<T> {
		print(_roots.count)
		let stack = Stack<T>()
		var set = Set<T>()
		stack.stack(element)
		while let e = stack.pop() {
			if !set.insert(e).0 {
				continue
			}
			if let a = _rootSet[e] {
				stack.stack(a)
			}
		}
		return set
	}
	
}

class ForrestNode<T>: NSObject {
	
	private var _left, _right: ForrestNode?
	private var _element: T
	
	func getElement() -> T {
		return _element
	}
	
	init(_ t: T) {
		_element = t
	}
	
	init(_ t: T, _ left: ForrestNode<T>?, _ right: ForrestNode<T>?) {
		_element = t
		_left = left
		_right = right
	}
}

//class ForrstTest: XCTestCase {
//
//	func testFalse() {
//		let graph = TreeGraph<Int>()
//		XCTAssert(graph.addElementWithParent(1, 2))
//		XCTAssert(graph.addElementWithParent(2, 4))
//		XCTAssert(graph.addElementWithParent(4, 1))
//		XCTAssert(graph.addElementWithParent(2, 3))
//		XCTAssert(graph.addElementWithParent(3, 1))
//		XCTAssert(graph.addElementWithoutParent(6))
//		XCTAssertEqual(graph.getParentTrace(from: 1), Set<Int>([1,2,3,4]))
//		XCTAssertEqual(graph.getParentTrace(from: 2), Set<Int>([1,2,3,4]))
//		XCTAssertEqual(graph.getParentTrace(from: 3), Set<Int>([1,2,3,4]))
//		XCTAssertEqual(graph.getParentTrace(from: 4), Set<Int>([1,2,3,4]))
//		XCTAssertEqual(graph.getParentTrace(from: 6), Set<Int>([6]))
//		XCTAssert(graph.addElementWithParent(6, 6))
//		XCTAssertEqual(graph.getParentTrace(from: 6), Set<Int>([6]))
//		XCTAssert(graph.addElementWithParent(6, 2))
//		XCTAssertEqual(graph.getParentTrace(from: 6), Set<Int>([6,1,2,3,4]))
//	}
//}
