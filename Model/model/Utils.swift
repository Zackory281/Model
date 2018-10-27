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
func generateNodes(points:Points) -> PathNode {
	var head = PathNode(value: 3, occupied: false, pos: [points[0], points[1]], nodes: [])
	var i = 2
	while i + 1 < points.count {
		var nodes:[PathNode?] = [nil, nil, nil, nil]
		let dx = points[i] - points[i - 2], dy = points[i + 1] - points[i - 1]
		nodes[DIR_TO_IND[UInt8(dx + 1 + (dy + 1) * 10)]!] = head
		head = PathNode(value: 3, occupied: false, pos: [points[i], points[i + 1]], nodes: nodes)
		i += 2
	}
	return head
}

let DIR_TO_IND:[UInt8:Int] = [
	12:0,
	21:1,
	10:2,
	01:3,
]
