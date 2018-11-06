//
//  LogicInterface.swift
//  Logic
//
//  Created by Zackory Cramer on 11/3/18.
//  Copyright © 2018 Zackori Cui. All rights reserved.
//

import Foundation

enum CustomQuery: Hashable {
	case IsUntakenSquare(PathNode, Direction)
	case ShapeNowMove(ShapeNode)
	
	var description: String {
		switch self {
		case let .IsUntakenSquare(pathNode, ed):
			return "Square untaken at \(pathNode) expcept \(ed)"
		case let .ShapeNowMove(shapeNode):
			return "Shape now move at \(shapeNode)"
		}
	}
}

class AssertionCurry {
	weak var _delegate: AssertionDelegate?
	func evaluateOnAssertionDelegate(_ query: CustomQuery) -> LogicDerivation? {
		guard let delegate = _delegate else { return nil }
		switch query {
		case let .IsUntakenSquare(pathNode, ed):
			return delegate.isUntakeSquare(pathNode, ed)
		case let .ShapeNowMove(shapeNode):
			return delegate.shapeNowMove(shapeNode)
		default:
			return nil
		}
	}
	init(_ delegate: AssertionDelegate?) {
		_delegate = delegate
	}
}

extension QueryExander {
	static func getDerivedCustomPremises(_ query: CustomQuery) -> Premise? {
		return nil
//		switch query {
//		case let .
//			switch (d) {
//			case .UP:
//				return Premise(.IsEmptySquare(x, y + 1, d))
//			case .RIGHT:
//				return Premise(.IsEmptySquare(x + 1, y, d))
//			case .DOWN:
//				return Premise(.IsEmptySquare(x, y - 1, d))
//			case .LEFT:
//				return Premise(.IsEmptySquare(x - 1, y, d))
//			}
//		default:
//			return nil
//		}
	}
}

protocol AssertionDelegate: NSObjectProtocol {
	func shapeNowMove(_ shapeNode: ShapeNode) -> LogicDerivation?
	func isUntakeSquare(_ pathNode: PathNode, _ direction: Direction) -> LogicDerivation?
}

enum LogicDerivation {
	case Result(Result)
	case Premise(Premise)
}
