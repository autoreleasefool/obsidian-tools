import Foundation
import Yams

extension Obsidian {
	struct Document {
		let url: URL
		let frontmatter: String?
		let contents: String

		init(url: URL) throws {
			let contents = try String(contentsOf: url, encoding: .utf8)
			let frontmatter = extractFrontmatter(from: contents)

			self.url = url
			self.frontmatter = frontmatter
			self.contents = contents
		}

		var title: String {
			url.lastPathComponent.replacingOccurrences(of: ".md", with: "")
		}
	}
}

fileprivate func extractFrontmatter(from contents: String) -> String? {
	var didStartFrontmatter = false
	var frontmatter = ""

	for line in contents.components(separatedBy: .newlines) {
		if !didStartFrontmatter {
			if line == "---" {
				didStartFrontmatter = true
				continue
			} else if line.isEmpty {
				continue
			} else {
				// Non-empty line before frontmatter
				return nil
			}
		}

		if line == "---" {
			return frontmatter
		}

		frontmatter += "\(line)\n"
	}

	return nil
}
