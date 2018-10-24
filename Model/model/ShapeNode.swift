//
//  ShapeNode.swift
//  Model
//
//  Created by Zackory Cramer on 10/24/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class ShapeNode {
	
	private weak var _pathNode:PathNode?
	
	init(pathNode:PathNode?) {
		_pathNode = pathNode
	}
	
	func setPathNode(pathNode:PathNode) {
		_pathNode = pathNode
	}
	
	func advance() -> Bool {
		guard let pathNode = _pathNode else { return false}
		if pathNode.hasNext() {
			let next = pathNode.next()
			if pathNode.next().isFree() {
				pathNode.liftShapeNode()
				next.setShapeNode(node: self)
				_pathNode = next
				return true;
			}
		}
		return false
	}
}
