//
//  PathNode.swift
//  Model
//
//  Created by Zackory Cramer on 10/24/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import GameplayKit

class SerialPathNode : PathNodeAbstract {

	override var description: String { return "PathNode at \(_x), \(_y)" }
	private let _x, _y:IntC
	private var _next, _prev:SerialPathNode?
	private let _value:UInt16
	private var _dir:Direction?
	private weak var _meta:AnyObject?
	private var _occupacity:Occupacity
	private weak var _shapeNode:ShapeNode?
	private var _orientations: [Direction]

	init(_ x:IntC, _ y:IntC, prev:SerialPathNode? = nil, next:SerialPathNode? = nil, value:UInt16 = 0, dir:Direction? = nil, occupacity:Occupacity = .FREE, shapeNode:ShapeNode? = nil, meta:AnyObject? = nil) {
		_x = x;
		_y = y;
		_prev = prev
		_next = next
		_value = value
		_dir = dir
		_occupacity = occupacity
		_shapeNode = shapeNode
		_meta = meta
		_orientations = []
	}
	
	convenience init(_ x:IntC, _ y:IntC, prev:SerialPathNode?, next:SerialPathNode?, value:UInt16, dir:Direction?) {
		self.init(x, y, prev: prev, next: next, value: value, dir: dir, occupacity:.FREE, shapeNode:nil, meta:nil)
	}
	
	override func getPoint() -> Point {return (_x,_y)}
	override func getOrientations() -> [Direction] {return _orientations}
	override func getType() -> NodeType {return .Path}
	override func getX() -> IntC {return _x}
	override func getY() -> IntC {return _y}
	override func getColorCode() -> NSColor {return _shapeNode?.getColorCode() ?? .white}
	override func next(for meta: PathNodeMeta?) -> PathNodeAbstract? {return _next}
	override func prev(for meta: PathNodeMeta?) -> PathNodeAbstract? {return _prev}
	override func nexts() -> [PathNodeAbstract] {guard let _next = _next else { return [] }; return [_next]}
	override func prevs() -> [PathNodeAbstract] {guard let _prev = _prev else { return [] }; return [_prev]}
	override func setShapeNode(node: ShapeNode) {_shapeNode = node}
	override func getDirection(for meta: PathNodeMeta?) -> Direction? {return _dir}
	override func liftShapeNode(node: ShapeNode) {if _shapeNode == node { _shapeNode = nil }}
	override func getNowUntakeDerivation(ignore meta: PathNodeMeta?) -> LogicDerivation? {
		if _prev?.getDirection(for: nil) == _dir {
			if let shapeNode = _shapeNode {
				return PRE(CustomQuery.ShapeNowMove(shapeNode))
			}
			return RES(true, 3)
		}
		fatalError("we have a problem")
		return nil
	}
}

protocol PathNode: Node {
	func next(for meta: PathNodeMeta?) -> PathNode?
	func prev(for meta: PathNodeMeta?) -> PathNode?
	func nexts() -> [PathNodeAbstract]
	func prevs() -> [PathNodeAbstract]
	func getDirection(for meta: PathNodeMeta?) -> Direction?
	func setShapeNode(node: ShapeNode)
	func liftShapeNode(node: ShapeNode)
	func getNowUntakeDerivation(ignore meta: PathNodeMeta?) -> LogicDerivation?
}

struct PathNodeMeta {
	let direction: Direction?
}

class PathNodeAbstract: NSObject, PathNode {
	func getPoint() -> Point {fatalError("getPoint() -> Point not implemented"); return (0,0)}
	func getOrientations() -> [Direction] {fatalError("getOrientations() -> [Direction] is not implemented"); return []}
	func getType() -> NodeType {fatalError("getType() -> NodeType is not implemented"); return .Shape}
	func getX() -> IntC {fatalError("PathNodeAbstract method is not implemented"); return 0}
	func getY() -> IntC {fatalError("PathNodeAbstract method is not implemented"); return 0}
	func getColorCode() -> NSColor {fatalError("PathNodeAbstract method is not implemented"); return .white}
	func next(for meta: PathNodeMeta?) -> PathNodeAbstract? {fatalError("next(for meta: PathNodeMeta) is not implemented"); return nil}
	func prev(for meta: PathNodeMeta?) -> PathNodeAbstract? {fatalError("PathNodeAbstract method is not implemented"); return nil}
	func nexts() -> [PathNodeAbstract] {fatalError("PathNodeAbstract method is not implemented"); return []}
	func prevs() -> [PathNodeAbstract] {fatalError("PathNodeAbstract method is not implemented"); return []}
	func getDirection(for meta: PathNodeMeta?) -> Direction? {fatalError("PathNodeAbstract method is not implemented"); return nil}
	func setShapeNode(node: ShapeNode) {fatalError("PathNodeAbstract method is not implemented")}
	func liftShapeNode(node : ShapeNode) {fatalError("PathNodeAbstract method is not implemented")}
	func getNowUntakeDerivation(ignore meta: PathNodeMeta?) -> LogicDerivation? {fatalError("PathNodeAbstract method is not implemented"); return nil}
}

enum Occupacity {
	case OCCUPIED
	case FREE
	case HALF_OCCUPIED
}

enum Direction {
	case UP
	case RIGHT
	case DOWN
	case LEFT
	
	func opposite() -> Direction {
		switch (self) {
		case Direction.UP:
			return Direction.DOWN
		case .RIGHT:
			return .LEFT
		case .DOWN:
			return .UP
		case .LEFT:
			return .RIGHT
		}
	}
}
