//
//  Utils.swift
//  Model
//
//  Created by Zackory Cramer on 10/24/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation
import SpriteKit

typealias Points = [IntC]
typealias Point = (IntC, IntC)
typealias IntC = Int16
typealias TickU = Int

func generateNodesHead(points:Points) -> PathNodeAbstract? {
	var tail: SerialPathNode?
	var head: SerialPathNode?
	perPointSerialHTT(points: points, {(point: Point, dir: Direction?) in
		if let headT = tail {
			headT._prev = SerialPathNode(point: point, next: headT, prev: nil, direction: dir, shapeNode: nil)
			tail = headT._prev as! SerialPathNode?
			return
		}
		tail = SerialPathNode(point: point)
		head = tail
	})
	return head
}

func perPointSerialHTT(points:Points, _ function:(_ point: Point, _ dir:Direction?) -> ()) {
	var px, py:IntC!
	if points.count >= 2 {
		px = points[0]
		py = points[1]
	}
	for i in stride(from: 0, to: points.count - 1, by: 2) {
		function((points[i], points[i + 1]), DIR_TO_DIR[points[i + 1] - py + 1 + (points[i] - px + 1) * 10]?.opposite())
		(px, py) = (points[i], points[i + 1])
	}
}

func perPoint<T>(points:Points, meta:[T], function:(_ point: Point, _ meta:T) -> ()) {
	for i in stride(from: 0, to: points.count - 1, by: 2) {
		function((points[i], points[i + 1]), meta[i / 2])
	}
}

func perPoint(points:Points, function:(_ x:IntC, _ y:IntC) -> ()) {
	for i in stride(from: 0, to: points.count - 1, by: 2) {
		function(points[i], points[i + 1])
	}
}

let DIR_TO_IND:[UInt8:Int] = [
	12:0,
	21:1,
	10:2,
	01:3,
]

let DIR_TO_DIR:[IntC:Direction] = [
	12:.UP,
	21:.RIGHT,
	10:.DOWN,
	01:.LEFT,
]

let DIR_TO_STR:[Direction:String] = [
	.UP:"UP",
	.RIGHT:"RIGHT",
	.DOWN:"DOWN",
	.LEFT:"LEFT",
]

extension NSColor {
	
	static func *(_ lhs: NSColor, _ rhs: CGFloat) -> NSColor {
		return NSColor(red: lhs.redComponent + (1 - lhs.redComponent) * rhs,
					   green: lhs.greenComponent + (1 - lhs.greenComponent) * rhs,
					   blue: lhs.blueComponent + (1 - lhs.blueComponent) * rhs,
					   alpha: lhs.alphaComponent + (1 - lhs.alphaComponent) * rhs)
	}
}

func RES(_ bool: Bool, _ grade: Int8) -> LogicDerivation {
	return .Result(Result(bool, grade))
}

func PRE(_ q: CustomQuery) -> LogicDerivation {
	return .Premise(Premise(q))
}

enum MyError: Error {
	case AbstractClassMethodNotOverriden(className: String, methodName: String)
}

extension Collection {
	
	/// Returns the element at the specified index if it is within bounds, otherwise nil.
	subscript (safe index: Index) -> Element? {
		return indices.contains(index) ? self[index] : nil
	}
}

extension Set {
	mutating func append(contentsOf c: [Element]) {
		for t in c {
			insert(t)
		}
	}
}
