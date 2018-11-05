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
	weak var _nodeActionDelegate:OutputDelegate?
	
	init() {
		_shapeNodes = Set<ShapeNode>()
		_shapeHeadNodes = Set<ShapeNode>()
		_shapeNodeTree = NodeTree<ShapeNode>(width: 100, height: 100)
	}
	
	func addShapeNode(_ node: ShapeNode) {
		_shapeNodes.insert(node)
		_shapeNodeTree.addNode(node: node)
		_nodeActionDelegate?.uiAddNodes(nodes: [node])
	}
	
	func addHeadNode(head :ShapeNode) {
		_shapeHeadNodes.insert(head)
		_shapeNodes.insert(head)
		_shapeNodeTree.addNode(node: head)
		_nodeActionDelegate?.uiAddNodes(nodes: [head])
	}
	
	func hasShapeNodeAt(_ x: IntC, y: IntC) -> Bool {
		return !_shapeNodeTree.getNodesAt(x, y).isEmpty
	}
	
	func tick() {
		for head in _shapeHeadNodes {
			let _ = head.advance()
		}
	}
	
}
