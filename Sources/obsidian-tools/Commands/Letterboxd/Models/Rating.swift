enum Rating: Int, Codable {
	case zero = 0
	case one = 1
	case two = 2
	case three = 3
	case four = 4
	case five = 5
	case six = 6
	case seven = 7
	case eight = 8
	case nine = 9
	case ten = 10

	var letterboxdRating: String? {
		switch self {
		case .zero: nil
		case .one: "0.5"
		case .two: "1"
		case .three: "1.5"
		case .four: "2"
		case .five: "2.5"
		case .six: "3"
		case .seven: "3.5"
		case .eight: "4"
		case .nine: "4.5"
		case .ten: "5"
		}
	}
}
