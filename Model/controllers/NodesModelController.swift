//
//  ModelController.swift
//  Model
//
//  Created by Zackory Cramer on 10/28/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import AppKit

class NodesModelController :NSObject, NodesModelActionDelegate{
	
	private let _nodesModel:NodesModel
	private weak var _guiDelegate:GUIDelegate?
	private var _nodesToUpdate = Set<ShapeNode>()
	private var _pathNodesToUpdate = Set<PathNodeAbstract>()
	private weak var _queue: GUIQueue?
	
	// Mark: NodesModelActionDelegate stubs
	func uiAddQueue(_ queue: GUIQueue) {
		_queue = queue
	}
	
	func clickToggleNode(_ x: Int, _ y: Int, type: NodeType) -> Void {
		_nodesModel.addNodeAt(IntC(x), IntC(y), type)
	}
	
	func addNodes(_ x1: Int, _ y1: Int, _ x2: Int, _ y2: Int)  -> Bool {
		guard x2 - x1 == 0 || y2 - y1 == 0 else {
			print("Stride bad.")
			return false
		}
		var points: Points = []
		
		let (dx, dy) = (IntC(x1 - x2), IntC(y1 - y2))
		var (idx, idy): (IntC, IntC) = (0, 0)
		if dx > 0 {
			idx = 1
		} else if dx < 0 {
			idx = -1
		}
		if dy > 0 {
			idy = 1
		} else if dy < 0 {
			idy = -1
		}
		for i in 0...abs(dx) + abs(dy) {
			points.append(IntC(x2) + i * idx)
			points.append(IntC(y2) + i * idy)
		}
		_nodesModel.addNodeStride(points)
		return true
	}
	
	func tick() {
		let success = _nodesModel.tick()
		_guiDelegate?.dislayTickNumber(Int(_nodesModel.getTick()), success)
		pushAddNodes()
		pushUpdateNodes()
		_queue?.clearAll()
	}
	
	func pushAddNodes() {
		guard let _guiDelegate = _guiDelegate else { return }
		guard let queue = _queue else { return }
		for node in queue._nodesToAdd {
			var s:NodeIterface!
			switch (node._type) {
			case .Shape:
				let shapeNode = (node as! ShapeNode)
				s = NodeIterface(point: node._point, orientations: [], hash: node.hash, nodeType: node._type, color: shapeNode._color ?? .white)
			default:
				let pathNode = (node as! PathNodeAbstract)
				s = NodeIterface(point: node._point, orientations: pathNode._directions, hash: node.hash, nodeType: node._type, color: pathNode._color ?? .white)
			}
			_guiDelegate.addPathNode(s)
		}
	}
	
	func pushUpdateNodes() {
		guard let _guiDelegate = _guiDelegate else { return }
		guard let queue = _queue else { return }
		for node in queue._nodesToUpdate {
			switch (node) {
			case let node as PathNodeAbstract:
				_guiDelegate.updatePosition(NodeUpdateIterface(point: node._point,color: node._color ?? .white, orientation: node._directions, shapeState: nil, taken: node._taken, hash: node.hash))
			case let node as ShapeNode:
				_guiDelegate.updatePosition(NodeUpdateIterface(point: node._point,color: node._color ?? .white, orientation: nil, shapeState: node._state, taken: nil,hash: node.hash))
			default:
				break
			}
		}
		_nodesToUpdate.removeAll()
	}
	
	func preloadModel() {
		_nodesModel.loadModel()
	}
	
	init(nodesModel:NodesModel, guiDelegate:GUIDelegate) {
		_nodesModel = nodesModel
		_guiDelegate = guiDelegate
		super.init()
		_nodesModel._modelActionDelegate = self
	}
}

class GUIQueue {
	var _nodesToAdd = Set<NodeAbstract>()
	var _nodesToUpdate = Set<NodeAbstract>()
	func clearAll() {
		_nodesToAdd.removeAll()
		_nodesToUpdate.removeAll()
	}
	func add(node: NodeAbstract) {
		_nodesToAdd.insert(node)
	}
	func update(node: NodeAbstract) {
		_nodesToUpdate.insert(node)
	}
}
protocol GUIDelegate: NSObjectProtocol {
	
	func addPathNode(_ nodeInterface: NodeIterface)
	func updatePosition(_ nodeUpdateInterface: NodeUpdateIterface)
	func dislayTickNumber(_ tick: Int, _ success: Bool)
}

struct NodeIterface {
	let point: Point
	let orientations: [Direction]
	let hash: Int
	let nodeType: NodeType
	let color: NSColor
}

struct NodeUpdateIterface {
	let point: Point?
	let color: NSColor?
	let orientation: [Direction]?
	let shapeState: ShapeNodeState?
	let taken: Bool?
	let hash: Int
}

enum NodeType {
	case Path
	case Shape
}
