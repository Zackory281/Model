//
//  Node.swift
//  Model
//
//  Created by Zackory Cramer on 10/26/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class Node: NSObject {
	
	protected var _x, _y:Int16
	var _meta:NSObject?
	
	init(_ x:Int16, _ y:Int16, meta:NSObject? = nil) {
		_x = x
		_y = y
		_meta = meta
	}
	
	func hasNext() -> Bool {
		return false
	}
	
	func next() -> Node {
		return self
	}
	
}
