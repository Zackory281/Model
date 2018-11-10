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

	override var description: String { return "PathNode at \(_point.0), \(_point.1)" }
	private let _value:UInt16
	private weak var _meta:AnyObject?
	var _next, _prev: PathNodeAbstract?
	var _direction: Direction?
	
	override var _type: NodeType { get { return .Path}}
	override var _nexts: [PathNodeAbstract]{get{guard let next = _next else {return []}; return [next]}}
	override var _prevs: [PathNodeAbstract]{get{guard let prev = _prev else {return []};  return [prev]}}
	override var _directions: [Direction]{get{guard let direction = _direction else {return []};  return [direction]}}
	override func getNext(_ direction: Direction?) -> PathNodeAbstract? {return _next}
	override func getPrev(_ direction: Direction?) -> PathNodeAbstract? {return _prev}
	override func getNowUntakeDerivation(ignore direction: Direction) -> LogicDerivation? {
		if let shape = _shapeNode { // Assume the querier is the node before
			return PRE(.ShapeNowMove(shape))
		}
		return RES(true, 2)
	}
	override func update(){print("nothing to update for SerialPathNode")}
	init(point: Point, next: PathNodeAbstract?, prev: PathNodeAbstract?, direction: Direction?, shapeNode: ShapeNode?) {
		_value = 0
		super.init(point: point, shapeNode: shapeNode)
		(_next, _prev, _direction) = (next, prev, direction)
	}
	override init(point: Point) {
		_value = 0
		super.init(point: point)
	}
}

protocol Node {
	var _point: Point { get set }
	var _type: NodeType { get }
	var _color: NSColor? { get }
}

class NodeAbstract: NSObject {
	var _point: Point = (0, 0)
	var _type: NodeType { get { return .Shape} }
	var _color: NSColor? { get { return nil} }
}

protocol PathNode: Node {
	var _nexts: [PathNodeAbstract] { get }
	var _prevs: [PathNodeAbstract] { get }
	var _directions: [Direction] { get }
	var _shapeNode: ShapeNode? { get set }
	var _color: NSColor? { get }
	var _taken: Bool { get set }
	func getNext(_ direction: Direction?) -> PathNodeAbstract?
	func getPrev(_ direction: Direction?) -> PathNodeAbstract?
	func getNowUntakeDerivation(ignore direction: Direction) -> LogicDerivation?
	func update()
}

class PathNodeAbstract: NodeAbstract {
	init(point: Point, shapeNode: ShapeNode?){(_point, _shapeNode)=(point, shapeNode)}
	init(point: Point){_point = point}
	var _taken: Bool = false
	weak var _shapeNode: ShapeNode?
	override var _type: NodeType { get { fatalError("No nodetype getter blowa!")}}
	override var _color: NSColor? { return _shapeNode?._color }
	var _nexts: [PathNodeAbstract]{get{fatalError("no _nexts in PathNodeAbstract")}}
	var _prevs: [PathNodeAbstract]{get{fatalError("no _prevs in PathNodeAbstract")}}
	var _directions: [Direction]{get{fatalError("no _directions in PathNodeAbstract")}}
	func getNext(_ direction: Direction?) -> PathNodeAbstract? {fatalError("no getNext from direction")}
	func getPrev(_ direction: Direction?) -> PathNodeAbstract? {fatalError("no getPrev from direction")}
	func getNowUntakeDerivation(ignore direction: Direction) -> LogicDerivation? {fatalError("no")}
	func update() {fatalError("no update")}
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
