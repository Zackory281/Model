//
//  NodesManager.swift
//  Model
//
//  Created by Zackory Cramer on 11/4/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

class NodesController: NSObject, NodeControlDelegate, QueryNodeDelegate{
	
	weak var _nodeActionDelegate: OutputDelegate?
	
	private var _pathNodeController :PathNodeController = PathNodeController(width: 100, height: 100)
	private var _shapeNodeController :ShapeNodeController = ShapeNodeController()
	
	func addNodeAt(_ point: Point, _ type: NodeType) {
		var addNodes: [Node] = []
		var updateNodes: [Node] = []
		if _pathNodeController.getPathNodeAt(point) == nil {
			guard let _ = _pathNodeController.addPathNode(at: point) else { return }
			addNodes.append(contentsOf: _pathNodeController._nodesToAdd)
			updateNodes.append(contentsOf: _pathNodeController._nodesToUpdate)
			_pathNodeController._nodesToAdd.removeAll()
			_pathNodeController._nodesToUpdate.removeAll()
		} else if let pathNode = _pathNodeController.getPathNodeAt(point), pathNode._shapeNode == nil {
			print("adding a shape")
			let shapeNode = ShapeNode.init(point, direction: pathNode._directions[safe: 0] ?? .UP, pathNode: pathNode, headNode: nil)
			pathNode._shapeNode = shapeNode
			_shapeNodeController.addShapeNode(shapeNode)
			addNodes.append(shapeNode)
			updateNodes.append(pathNode)
		}
		print("not adding a shape")
		if !addNodes.isEmpty {
			_nodeActionDelegate?.uiAddNodes(nodes: addNodes)
		}
		if !updateNodes.isEmpty {
			_nodeActionDelegate?.uiUpdateNodes(nodes: updateNodes)
		}
	}
	
	func addNodeAt(_ x: IntC, _ y: IntC, _ type: NodeType) { addNodeAt((x, y), type) }
	
	func addNodeToadvance(_ node: ShapeNode) {
		_shapeNodeController._toStartAdvanceNodes.insert(node)
	}
	
	func addPathNodesFromHead(_ head: PathNodeAbstract) {
		let ups = _pathNodeController.addHeadNode(head)
		guard !ups.isEmpty else { return }
		_nodeActionDelegate?.uiAddNodes(nodes: ups)
	}
	
	func getQueries() -> Set<CustomQuery> {
		var qs = Set<CustomQuery>()
		for n in _shapeNodeController._shapeNodes {
			if n._state == .CanNowMove {
				qs.insert(.ShapeNowMove(n))
			}
		}
		return qs
	}
	
	func tick(_ tick: TickU) {
		startAdvanceNodes()
		finishAdvanceNodes()
		_shapeNodeController.tick(tick)
	}
	
	func startAdvanceNodes() {
		for node in _shapeNodeController._toStartAdvanceNodes {
			let newPath = node._pathNode!.getNext(node._direction)!
			newPath._shapeNode = node
			node._state = .Moving
			//let newPathNode = node.getPathNode()!.getNext(nil)!
//			node.setPathNode(newPathNode)
//			_shapeNodeController.move(node)
//			newPathNode._shapeNode = node
//			node._state = .Moving
			_nodeActionDelegate?.uiUpdateNodes(nodes: [newPath])
		}
		_shapeNodeController._toStartAdvanceNodes.removeAll()
	}
	
	func finishAdvanceNodes() {
		for node in _shapeNodeController._toFinishAdvanceNodes {
			let oldPath = node._pathNode!
			let newPath = oldPath.getNext(node._direction)!
			if oldPath._shapeNode == node {
				oldPath._shapeNode = nil
			}
			node._pathNode = newPath
			//			node.setPathNode(newPathNode)
			//			_shapeNodeController.move(node)
			//			newPathNode._shapeNode = node
			//			node._state = .Moving
			_nodeActionDelegate?.uiUpdateNodes(nodes: [node, oldPath, newPath])
		}
		_shapeNodeController._toFinishAdvanceNodes.removeAll()
	}
}

protocol NodeControlDelegate: NSObjectProtocol {
	func addNodeAt(_ x: IntC, _ y: IntC, _ type: NodeType)
	func addNodeAt(_ p: Point, _ type: NodeType)
	func addNodeToadvance(_ node: ShapeNode)
}
