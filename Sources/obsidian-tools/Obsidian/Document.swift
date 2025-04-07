import Foundation
import Yams

extension Obsidian {
	struct Document: Equatable {
		let url: URL
		private var _frontmatter: String?
		var frontmatter: String? {
			get { _frontmatter }
			set {
				_frontmatter = newValue
				_contents = replaceFrontmatter(in: contents, with: newValue)
			}
		}

		private var _contents: String
		var contents: String {
			get { _contents }
			set {
				_contents = newValue
				_frontmatter = extractFrontmatter(from: newValue)
			}
		}

		init(url: URL) throws {
			let contents = try String(contentsOf: url, encoding: .utf8)
			let frontmatter = extractFrontmatter(from: contents)

			self.url = url
			self._frontmatter = frontmatter
			self._contents = contents
		}

		var title: String {
			url.lastPathComponent.replacingOccurrences(of: ".md", with: "")
		}
	}
}

fileprivate func replaceFrontmatter(in contents: String, with frontmatter: String?) -> String {
	if let extracted = extractFrontmatter(from: contents) {
		return contents.replacing(extracted, with: frontmatter ?? "")
	} else if let frontmatter {
		return "---\n\(frontmatter)\n---\n\(contents)"
	} else {
		return contents
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
