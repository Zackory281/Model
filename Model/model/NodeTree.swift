//
//  NodeTree.swift
//  Model
//
//  Created by Zackory Cramer on 10/29/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import GameplayKit

//class NodeTree<T : NodeAbstract> {
//	//<ElementType> : NSObject where ElementType : NSObject
//	private var pathNodeTree:GKQuadtree<T>
//
//	init(width: IntC, height: IntC) {
//		pathNodeTree = GKQuadtree<T>.init(boundingQuad: GKQuad(quadMin: float2(Float(0 - width / 2), Float(0 - height / 2)), quadMax: float2(Float(width / 2), Float(height / 2))), minimumCellSize: 0.7)
//	}
//
//	func exists(node: T) -> Bool {
//		let p = node._point
//		return !pathNodeTree.elements(at: float2(Float(p.0), Float(p.1))).isEmpty
//	}
//
//	func addNode(node:T) {
//		let p = node._point
//		pathNodeTree.add(node, at: float2(Float(p.0), Float(p.1)))
//	}
//
//	func add(node: T, at point: Point) {
//		let p = point
//		pathNodeTree.add(node, at: float2(Float(p.0), Float(p.1)))
//	}
//
//	func move(node: T) -> Bool {
//		guard remove(node: node) else { return false }
//		let pos = node._point
//		pathNodeTree.add(node, at: float2(Float(pos.0), Float(pos.1)))
//		return true
//	}
//
//	func remove(node: T) -> Bool {
//		return pathNodeTree.remove(node)
//	}
//
//	func getNodesIn(_ cx:IntC, _ cy:IntC, _ cw:IntC, _ ch:IntC) -> [T] {
//		return pathNodeTree.elements(in: GKQuad(quadMin: float2(Float(cx - cw/2), Float(cy - ch / 2)), quadMax: float2(Float(cx + cw / 2), Float(cy + ch / 2))))
//	}
//
//	func getNodesAt(_ x:IntC, _ y:IntC) -> [T] {
//		return pathNodeTree.elements(at: float2(Float(x), Float(y)))
//	}
//
//	func getNeibhorNodesAt(_ point: Point) -> [(T, Direction)] {
//		let (x, y) = (Float(point.0), Float(point.1))
//		var a: [(T, Direction)] = []
//		if let right = pathNodeTree.elements(at: float2(x+1, y))[safe: 0] {
//			a.append((right, .RIGHT))
//		}
//		if let left = pathNodeTree.elements(at: float2(x-1, y))[safe: 0] {
//			a.append((left, .LEFT))
//		}
//		if let up = pathNodeTree.elements(at: float2(x, y+1))[safe: 0] {
//			a.append((up, .UP))
//		}
//		if let down = pathNodeTree.elements(at: float2(x, y-1))[safe: 0] {
//			a.append((down, .DOWN))
//		}
//		return a
//	}
//
//	func getNodesAt(_ x:Float, _ y:Float) -> [T] {
//		return pathNodeTree.elements(at: float2(x, y))
//	}
//
//	func isEmpty(at point: Point) -> Bool {
//		return pathNodeTree.elements(at: float2(Float(point.0), Float(point.1))).isEmpty
//	}
//}

class NodeMap {
	private var _quadTree: GKQuadtree<NodeAbstract>
	
	func contains<T: NodeAbstract>(of type: T.Type, at point: Point) -> Bool {
		let nodes = _quadTree.elements(at: float2(Float(point.0)+0.5, Float(point.1)+0.5))
		return nodes.contains {$0 is T}
	}
	
	func containsCollisionNode(_ node: NodeAbstract) -> Bool {
		let nodes = _quadTree.elements(at: float2(Float(node._point.0)+0.5, Float(node._point.1)+0.5))
		let c = node._category
		return nodes.contains{$0._overlap & c != 0}
	}
	
	func getPatternNodes<T: NodeAbstract, W>(of _: T.Type, at point: Point, from delta: [(IntC, IntC, W)]) -> [(T, W)] {
		var nodes: [(T, W)] = []
		for (dx, dy, d) in delta {
			let first = _quadTree.elements(at: float2(Float(point.0 + dx)+0.5, Float(point.1 + dy)+0.5)).filter{$0 is T}.first
			if let node = first as? T {
				nodes.append((node, d))
			}
		}
		return nodes
	}
	
	func getNodes(left: Point, right: Point) -> [NodeAbstract]
	{
		let quad = GKQuad(quadMin:
			float2(Float(left.0), Float(left.1)),
						  quadMax: float2(Float(right.0), Float(right.1)))
		return _quadTree.elements(in: quad)
	}
	
	func getNodes(at point: Point) -> [NodeAbstract] {
		return _quadTree.elements(at: float2(Float(point.0)+0.5, Float(point.1)+0.5))
	}
	
	func getNodes<T:NodeAbstract>(of _: T.Type, at point: Point) -> [T] {
		return _quadTree.elements(at: float2(Float(point.0)+0.5, Float(point.1)+0.5)).filter{$0 is T} as! [T]
	}
	
	func getNodes(of type: NodeType, at point: Point) -> [NodeAbstract] {
		return _quadTree.elements(at: float2(Float(point.0)+0.5, Float(point.1)+0.5)).filter{$0._type == type}
	}
	
	func add(node: NodeAbstract) {
		switch node._type {
		case .Shape, .Path:
			let point = node._point
			_quadTree.add(node, at: float2(Float(point.0)+0.5, Float(point.1)+0.5))
		case .Geometry:
			for point in (node as! GeometryNode)._pointsOccupied {
				_quadTree.add(node, at: float2(Float(point.0)+0.5, Float(point.1)+0.5))
			}
		default:
			fatalError("Can't add \(node)")
		}
	}
	
	func move(node: NodeAbstract) {
		switch node._type {
		case .Shape, .Path:
			_quadTree.remove(node)
			let point = node._point
			_quadTree.add(node, at: float2(Float(point.0)+0.5, Float(point.1)+0.5))
		case .Geometry:
			fatalError("Can't move GeometryNode")
		default:
			fatalError("Can't move such node: \(node)")
		}
	}
	
	func remove(node: NodeAbstract) {
		switch node._type {
		case .Shape, .Path:
			_quadTree.remove(node)
		case .Geometry:
			fatalError("Can't remove GeometryNode")
		default:
			fatalError("Can't remove such node: \(node)")
		}
	}
	
	init(width: IntC, height: IntC) {
		_quadTree = GKQuadtree<NodeAbstract>.init(boundingQuad: GKQuad(quadMin: float2(0, 0), quadMax: float2(Float(width), Float(height))), minimumCellSize: 0.5)
	}
	
}

let GRID_NEIGHBOR:[(IntC, IntC, Direction)] = [
	(1,0,Direction.RIGHT),
	(0,1,Direction.UP),
	(-1,0,Direction.LEFT),
	(0,-1,Direction.DOWN)]

struct NodeUnit {
	var _nodes: [NodeAbstract.Type : Int] = [
		ShapeNode.self : 0
	]
	var _shapeNode: ShapeNode?
	var _categoryBit: INTB = 0
	var _collisionBit: INTB = 0
	init(pathNode: PathNodeAbstract) {
		_pathNode = pathNode
	}
}
