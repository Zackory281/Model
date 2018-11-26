//
//  Queue.swift
//  Model
//
//  Created by Zackory Cramer on 11/25/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class Queue<T: NSObject> {
	private var arr:[T] = []
	
	func queue(_ item: T) {
		arr.append(item)
	}
	
	func remove() -> T? {
		guard let first = arr.first else { return nil }
	    arr.remove(at: 0)
		return first
	}
//	fileprivate var head = QueueNode<T>()
//	fileprivate var blast: QueueNode<T>? = QueueNode<T>()
//	init() {
//		blast = head
//	}
//
//	func queue(_ item: T) {
//		if blast != nil {
//			blast.next = QueueNodeItem<T>(item: item)
//			blast = blast.next!
//		}
//		blast.o
//	}
//	
//	func remove() -> T? {
//		guard let head = head.next as QueueNodeItem<T>? else { return nil }
//		if head === blast {
//			blast = head.next
//		}
//		self.head.next = head.next
//		guard let item = head.item else { return remove() }
//		return item
//	}
}

private class QueueNodeItem<T: NSObject>: QueueNode<T> {
	weak var item: T?
	weak var prev: QueueNode<T>?
	init(item: T) {
		self.item = item
	}
}


private class QueueNode<T: NSObject> {
	var next: QueueNodeItem<T>?
}
