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
	private weak var _queue: GUIQueue?
	private weak var _overlayController: UIOverlayController?
	
	// Mark: NodesModelActionDelegate stubs
	func uiAddQueue(_ queue: GUIQueue) {
		_queue = queue
	}
	
	func clickToggleNode(_ x: Int, _ y: Int, type: NodeType) -> Void {
		_nodesModel.addNodeAt(IntC(x), IntC(y), type)
	}
	
	func removeNodesAt(_ x: Int, _ y: Int) -> Bool {
		return _nodesModel.removeNodeAt(IntC(x), IntC(y), .Path)
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
		pushRemoveNodes()
	}
	
	func pushAddNodes() {
		guard let _guiDelegate = _guiDelegate else { return }
		guard let queue = _queue else { return }
		for node in queue._nodesToAdd {
			var s:NodeIterface!
			switch (node._type) {
			case .Shape:
				let shapeNode = (node as! ShapeNode)
				s = NodeIterface(point: node._point, orientations: [], hash: node.hash, nodeType: node._type, color: shapeNode._color ?? .white, radius: nil)
			case .Projectile:
				let node = (node as! ProjectileNode)
				s = NodeIterface(point: node._point, orientations: [], hash: node.hash, nodeType: node._type, color: node._color ?? .white, radius: node._radius)
			case .Path:
				let pathNode = (node as! PathNodeAbstract)
				s = NodeIterface(point: node._point, orientations: pathNode._directions, hash: node.hash, nodeType: node._type, color: pathNode._color ?? .white, radius: nil)
			case .Geometry:
				let node = (node as! GeometryNode)
				s = NodeIterface(point: node._point, color: node._color!, hash: node.hash, health: node._health, geometry: node._geometry)
			}
			_guiDelegate.addNode(s)
		}
		queue._nodesToAdd.removeAll()
	}
	
	func pushUpdateNodes() {
		guard let _guiDelegate = _guiDelegate else { return }
		guard let queue = _queue else { return }
		for node in queue._nodesToUpdate {
			switch (node) {
			case let node as PathNodeAbstract:
				_guiDelegate.updatePosition(NodeUpdateIterface(point: node._point,color: node._color ?? .white, orientation: node._directions, taken: node._taken, hash: node.hash))
			case let node as ShapeNode:
				_guiDelegate.updatePosition(NodeUpdateIterface(point: node._point,color: node._color ?? .white, shapeState: node._state,hash: node.hash))
			case let node as ProjectileNode:
				_guiDelegate.updatePosition(NodeUpdateIterface(fpoint: node._fpoint, hash: node.hash))
			case let node as GeometryNode:
				_guiDelegate.updatePosition(NodeUpdateIterface(health: node._health, hash: node.hash))
			default:
				break
			}
		}
		queue._nodesToUpdate.removeAll()
	}
	
	func pushRemoveNodes() {
		guard let _guiDelegate = _guiDelegate else { return }
		guard let queue = _queue else { return }
		for node in queue._nodesToRemove {
			_guiDelegate.removeNode(node.hash)
		}
		queue._nodesToRemove.removeAll()
	}
	
	func preloadModel() {
		_nodesModel.loadModel()
	}
	
	init(nodesModel:NodesModel, guiDelegate:GUIDelegate, overlayController: UIOverlayController) {
		_nodesModel = nodesModel
		_guiDelegate = guiDelegate
		_overlayController = overlayController
		super.init()
		_nodesModel._modelActionDelegate = self
	}
}

class GUIQueue {
	var _nodesToAdd = Set<NodeAbstract>()
	var _nodesToRemove = Set<NodeAbstract>()
	var _nodesToUpdate = Set<NodeAbstract>()
//	func clearAll() {
//		_nodesToAdd.removeAll()
//		_nodesToUpdate.removeAll()
//	}
	func remove(_ node: NodeAbstract) {
		_nodesToRemove.insert(node)
	}
	
	func add(node: NodeAbstract) {
		_nodesToAdd.insert(node)
	}
	func update(node: NodeAbstract) {
		_nodesToUpdate.insert(node)
	}
}
protocol GUIDelegate: NSObjectProtocol {
	
	func addNode(_ nodeInterface: NodeIterface)
	func updatePosition(_ nodeUpdateInterface: NodeUpdateIterface)
	func removeNode(_ hash: Int)
	func dislayTickNumber(_ tick: Int, _ success: Bool)
	func display(_ string: String)
}

struct NodeIterface {
	var point: Point
	var orientations: [Direction]?
	var hash: Int
	var nodeType: NodeType
	var color: NSColor?
	var radius: Int8?
	var geometry: GeometryType?
	var health: Float?
	init(point: Point, orientations: [Direction]?, hash: Int, nodeType: NodeType, color: NSColor?, radius: Int8?) {
		self.point = point
		self.orientations = orientations
		self.hash = hash
		self.nodeType = nodeType
		self.color = color
		self.radius = radius
	}
	
	init(point: Point, color: NSColor, hash: Int, health: Float, geometry: GeometryType) {
		self.health = health
		self.point = point
		self.color = color
		self.nodeType = .Geometry
		self.hash = hash
		self.geometry = geometry
	}
}

struct NodeUpdateIterface {
	var point: Point?
	var fpoint: FPoint?
	var color: NSColor?
	var orientation: [Direction]?
	var shapeState: ShapeNodeState?
	var taken: Bool?
	var hash: Int
	var health: Float?
	//NodeUpdateIterface(point: node._point,color: node._color ?? .white, orientation: nil, shapeState: node._state, taken: nil,hash: node.hash)
	init(fpoint: FPoint, hash: Int) {
		(self.fpoint, self.hash) = (fpoint, hash)
	}
	init(health: Float, hash: Int) {
		(self.health, self.hash) = (health, hash)
	}
	init(point: Point, color: NSColor, shapeState: ShapeNodeState, hash: Int) {
		(self.point, self.color, self.shapeState, self.hash) = (point, color, shapeState, hash)
	}
	init(point: Point, color: NSColor, orientation: [Direction], taken: Bool, hash: Int) {
		(self.point, self.color, self.orientation, self.taken, self.hash) = (point, color, orientation, taken, hash)
	}
}

enum NodeType {
	case Path
	case Shape
	case Projectile
	case Geometry
}
