//
//  Utils.swift
//  Model
//
//  Created by Zackory Cramer on 10/24/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

typealias Points = [Int16]

struct Point {
	var _x:Int16
	var _y:Int16
}
func generateNodes(points:Points) -> PathNode? {
	var head:PathNode?
	var tail:PathNode?
	perPointSerial(points: points, {(x: Int16, y: Int16, dir: Direction?) in
		if let headT = head {
			headT.setNext(PathNode(x, y, prev:nil, next:nil, dir:dir))
			head = headT.next()
			return
		}
		head = PathNode(x, y, prev:nil, next:nil, dir:dir)
		tail = head
	})
	return tail
}

func perPointSerial(points:Points, _ function:(_ x:Int16, _ y:Int16, _ dir:Direction?) -> ()) {
	var px, py:Int16!
	if points.count >= 2 {
		px = points[0]
		py = points[1]
	}
	for i in stride(from: 0, to: points.count - 1, by: 2) {
		function(points[i], points[i + 1], DIR_TO_DIR[points[i + 1] - py + 1 + (points[i] - px + 1) * 10])
		(px, py) = (points[i], points[i + 1])
	}
}

func perPoint<T>(points:Points, meta:[T], function:(_ x:Int16, _ y:Int16, _ meta:T) -> ()) {
	for i in stride(from: 0, to: points.count - 1, by: 2) {
		function(points[i], points[i + 1], meta[i / 2])
	}
}

func perPoint(points:Points, function:(_ x:Int16, _ y:Int16) -> ()) {
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

let DIR_TO_DIR:[Int16:Direction] = [
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
