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
	var _toStartAdvanceNodes: Set<ShapeNode>
	var _toFinishAdvanceNodes: Set<ShapeNode>
	var _idleShapeNodes: Set<ShapeNode>
	private var _shapeHeadNodes :Set<ShapeNode>
	private var _shapeNodeTree: NodeTree<ShapeNode>
	
	init() {
		_shapeNodes = Set<ShapeNode>()
		_toStartAdvanceNodes = Set<ShapeNode>()
		_toFinishAdvanceNodes = Set<ShapeNode>()
		_idleShapeNodes = Set<ShapeNode>()
		_shapeHeadNodes = Set<ShapeNode>()
		_shapeNodeTree = NodeTree<ShapeNode>(width: 100, height: 100)
	}
	
	func addShapeNode(_ node: ShapeNode) {
		_shapeNodes.insert(node)
		_idleShapeNodes.insert(node)
		_shapeNodeTree.addNode(node: node)
	}
	
	func addHeadNode(head :ShapeNode) {
		_shapeHeadNodes.insert(head)
		_shapeNodes.insert(head)
		_idleShapeNodes.insert(head)
		_shapeNodeTree.addNode(node: head)
	}
	
	func remove(_ node: ShapeNode) {
		let _ = _shapeNodeTree.remove(node: node)
		_shapeHeadNodes.remove(node)
		_shapeNodes.remove(node)
		_toStartAdvanceNodes.remove(node)
		_toFinishAdvanceNodes.remove(node)
		_idleShapeNodes.remove(node)
	}
	
	func move(_ node: ShapeNode) {
		let _ = _shapeNodeTree.move(node: node)
	}
	
	func hasShapeNodeAt(_ point: Point) -> Bool {
		return !_shapeNodeTree.getNodesAt(point.0, point.1).isEmpty
	}
	
	func hasShapeNodeAt(_ x: IntC, y: IntC) -> Bool {
		return !_shapeNodeTree.getNodesAt(x, y).isEmpty
	}
	
	func tick(_ tick: TickU) {
		for node in _shapeNodes {
			node.tick(tick)
			if node._changedState {
				switch node._state {
				case .Chilling:
					_toFinishAdvanceNodes.insert(node)
				default:
					break
				}
				node._changedState = false
			}
		}
	}
	
}
