//
//  Predicates.swift
//  Logic
//
//  Created by Zackory Cramer on 11/2/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

//class Queries {
//	
//	private var _querySet = Set<Query>()
//	private var _queries:[Query] = []
//	
//	func addQuery(_ query:Query) {
//		guard !existsQuery(query) else {
//			print("Predicate \(query) already exists");
//			return }
//		_queries.append(query)
//		_querySet.insert(query)
//	}
//	
//	func deleteQuery(_ query: Query) {
//		guard existsQuery(query) else { print("query doesn't exist \(query)"); return}
//		_querySet.remove(query)
//		//_queries.remove(at: _queries.firstIndex(of: query)!)
//	}
//	
//	func existsQuery(_ query: Query) -> Bool {
//		return _querySet.contains(query)
//	}
//	
//	func peek() -> Query? {
//		return _queries.last
//	}
//	
//	@discardableResult
//	func pop() -> Query? {
//		guard let pop = _queries.popLast() else { return nil }
//		return _querySet.remove(pop)!
//	}
//	
//	func printQueries() {
//		print("Queries =====")
//		for q in _queries {
//			print(q)
//		}
//	}
//}

public class SetStack<T: Hashable> {
	
	private var _head: StackNode<T>
	private var _set: Set<T>
	private var _toRemove: Set<T>
	private var _size: Int
	
	func stack(_ t: T) -> Bool {
		guard !_set.contains(t) else {
			return false
		}
		if _toRemove.contains(t) {
			clearRemoval(until: t)
		}
		_size += 1
		_set.insert(t)
		_head._next = StackNode(element: t, _head._next)
		return true
	}
	
	func remove(_ t: T) -> Bool {
		guard _set.contains(t) else {
			return false
		}
		let b = _toRemove.insert(t).0
		print(b)
		guard b else {
			return true
		}
		_size -= 1
		_set.remove(t)
		clearRemovalFromHead()
		return true
	}
	
	func pop() -> T? {
		clearRemovalFromHead()
		guard let e = _head._next?.element() else { return nil }
		_size -= 1
		_head._next = _head._next!._next
		_set.remove(e)
		return e
	}
	
	func peek() -> T? {
		clearRemovalFromHead()
		return _head._next?.element()
	}
	
	func contains(_ t: T) -> Bool {
		return _set.contains(t)
	}
	
	func size() -> Int {
		return _size
	}
	
	// TODO: Needs optimization.
	func clearStack(until element: T) -> Bool {
		guard _head._next != nil else { return false }
		while _head._next?.element() != element {
			if _toRemove.contains(_head._next!.element()) {
				clearRemovalFromHead()
			} else {
				let n = _head._next!
				_toRemove.remove(n.element())
				_head._next = _head._next!._next
			}
		}
		if _head._next?.element() == element {
			let n = _head._next!
			_toRemove.remove(n.element())
			_head._next = _head._next!._next
			return true
		}
		return false //no element to remove until
	}
	
	func printStack() {
		var head = _head
		while head._next != nil {
			let e = head._next!.element()
			if _toRemove.remove(e) != nil {
				head._next = head._next?._next ?? nil
			} else {
				print(e)
			}
			head = head._next!
		}
	}
	
	/** Only call if CPU is very free. */
	func clearAllRemovals() {
		var head = _head
		while head._next != nil {
			let e = head._next!.element()
			if _toRemove.remove(e) != nil {
				head._next = head._next?._next ?? nil
			}
			head = head._next!
		}
	}
	
	init() {
		_size = 0
		_head = EmptyStackNode<T>(nil)
		_set = Set<T>()
		_toRemove = Set<T>()
	}
	
	private func clearRemovalFromHead() {
		while let e = _head._next?.element(), _toRemove.contains(e) {
			_head._next = _head._next?._next
			_toRemove.remove(e)
		}
	}
	
	private func clearRemoval(until element: T) {
		var head = _head
		while head._next != nil {
			let e = head._next!.element()
			if _toRemove.remove(e) != nil {
				head._next = head._next?._next ?? nil
				if e == element {
					return
				}
			}
			head = head._next!
		}
		if _size != 0 {
			print("iterated all stack but no remove element: ", element)
		}
	}
}

class Stack<T: Hashable> {
	private var _head:StackNode = EmptyStackNode<T>(nil)
	
	func stack(_ t: T) {
		_head._next = StackNode<T>(element: t, _head._next)
	}
	
	func stack(_ t: [T]) {
		for i in t {
			_head._next = StackNode<T>(element: i, _head._next)
		}
	}
	
	func stack(_ t: Set<T>) {
		for i in t {
			_head._next = StackNode<T>(element: i, _head._next)
		}
	}
	
	func peek() -> T? {
		return _head._next?.element()
	}
	
	func pop() -> T? {
		guard let e = _head._next?.element() else { return nil }
		_head._next = _head._next!._next
		return e
	}
	
	func isEmpty() -> Bool {
		return _head._next == nil
	}
	
	init() {}
	
	init(_ elements: [T]) {
		stack(elements)
	}
}

class StackNode<T> {
	private var _element: T!
	var _next: StackNode<T>?
	
	func element() -> T {
		return _element
	}
	
	init(element: T!, _ next: StackNode<T>?) {
		_next = next
		_element = element
	}
}

class EmptyStackNode<T>: StackNode<T> {
	
	init(_ next: StackNode<T>?) {
		super.init(element: nil, next)
		_next = next
	}
}
