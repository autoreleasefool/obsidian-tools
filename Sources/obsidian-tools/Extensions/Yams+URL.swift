import Foundation
import Yams

extension Yams.Node {
	var url: URL? {
		guard let string = self.string else { return nil }
		return URL(string: string)
	}
}
