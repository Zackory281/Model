//
//  NodeManager.swift
//  Model
//
//  Created by Zackory Cramer on 10/25/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class ShapeNodeController {
	
	var _shapeNodes :Set<ShapeNode>
	private var _shapeHeadNodes :Set<ShapeNode>
	private var _shapeNodeTree: NodeTree<ShapeNode>
	
	init() {
		_shapeNodes = Set<ShapeNode>()
		_shapeHeadNodes = Set<ShapeNode>()
		_shapeNodeTree = NodeTree<ShapeNode>(width: 100, height: 100)
	}
	
	func addShapeNode(_ node: ShapeNode) {
		_shapeNodes.insert(node)
		_shapeNodeTree.addNode(node: node)
	}
	
	func addHeadNode(head :ShapeNode) {
		_shapeHeadNodes.insert(head)
		_shapeNodes.insert(head)
		_shapeNodeTree.addNode(node: head)
	}
	
	func remove(_ node: ShapeNode) {
		let _ = _shapeNodeTree.remove(node: node)
		_shapeHeadNodes.remove(node)
		_shapeNodes.remove(node)
	}
	
	func move(_ node: ShapeNode) {
		let _ = _shapeNodeTree.move(node: node)
	}
	
	func hasShapeNodeAt(_ x: IntC, y: IntC) -> Bool {
		return !_shapeNodeTree.getNodesAt(x, y).isEmpty
	}
	
	func tick() {
		
	}
	
}
