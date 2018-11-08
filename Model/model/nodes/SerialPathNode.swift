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
	private let _value:UInt16
	private var _dir:Direction?
	private weak var _meta:AnyObject?

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
	private var _next, _prev: PathNodeAbstract?
	override var _point: Point
	override var _type: NodeType{get{return .Path}}
	override var _color: NSColor{get{return _shapeNode._color}set{print("can't set color")}}
	override var _nexts: [PathNodeAbstract] { get { return [_next] } set{ print("not doing to set _next")}}
	override var _prevs: [PathNodeAbstract] { get { return [_prev] } set{ print("not doing to set _prev")}}
	override var _directions: [Direction]
	override func getNext(_ direction: Direction) -> PathNodeAbstract? {return _next}
	override func getPrev(_ direction: Direction) -> PathNodeAbstract? {return _prev}
	override func getNowUntakeDerivation(ignore direction: Direction) -> LogicDerivation? {fatalError("no")}
}

protocol Node {
	var _point: Point { get set }
	var _type: NodeType { get }
}

protocol PathNode: Node {
	var _nexts: [PathNodeAbstract] { get set }
	var _prevs: [PathNodeAbstract] { get set }
	var _directions: [Direction] { get set }
	var _shapeNode: ShapeNode? { get set }
	var _color: NSColor? { get }
	func getNext(_ direction: Direction) -> PathNodeAbstract?
	func getNowUntakeDerivation(ignore direction: Direction) -> LogicDerivation?
}

class PathNodeAbstract: NSObject, PathNode {
	var _point: Point{get{fatalError("No point get")}set{fatalError("NO point set")}}
	var _type: NodeType{get{fatalError("No type get")}}
	var _color: NSColor? {get{fatalError("No color get!")}}
	var _nexts: [PathNodeAbstract]{get{fatalError("No nothing")}set{fatalError("NO set")}}
	var _prevs: [PathNodeAbstract]{get{fatalError("No nothing")}set{fatalError("NO set")}}
	var _directions: [Direction]{get{fatalError("No nothing")}set{fatalError("NO set")}}
	weak var _shapeNode: ShapeNode?
	func getNext(_ direction: Direction) -> PathNodeAbstract? {fatalError("no getNext from direction"); return nil}
	func getPrev(_ direction: Direction) -> PathNodeAbstract? {fatalError("no getPrev from direction"); return nil}
	func getNowUntakeDerivation(ignore direction: Direction) -> LogicDerivation? {fatalError("no")}
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
