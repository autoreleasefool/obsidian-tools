import Foundation
import RegexBuilder
import Yams

extension Obsidian {
	struct Document: Equatable {
		let url: URL

		var frontmatter: Frontmatter {
			didSet {
				_contents = replaceFrontmatter(in: contents, with: try! Yams.serialize(node: frontmatter.yaml))
			}
		}

		private var _contents: String
		var contents: String {
			get { _contents }
			set {
				_contents = newValue
				frontmatter = Frontmatter(root: try! Yams.compose(yaml: extractFrontmatter(from: newValue) ?? "") ?? .init(""))
			}
		}

		init(url: URL) throws {
			let contents = try String(contentsOf: url, encoding: .utf8)
			let frontmatter = extractFrontmatter(from: contents)

			self.url = url
			self.frontmatter = Frontmatter(root: try! Yams.compose(yaml: frontmatter ?? "") ?? .init(""))
			self._contents = contents
		}

		var title: String {
			url.lastPathComponent.replacingOccurrences(of: ".md", with: "")
		}
	}
}

extension Obsidian.Document {
	struct Frontmatter: Equatable {
		var yaml: Yams.Node

		init(root: Yams.Node) {
			self.yaml = root
		}

		var tags: [String] {
			get { yaml["tags"]?.array(of: String.self) ?? [] }
			set { yaml["tags"] = try! Yams.Node(newValue) }
		}

		var alias: [String] {
			get { yaml["alias"]?.array(of: String.self) ?? [] }
			set { yaml["alias"] = try! Yams.Node(newValue) }
		}

		var dateCreated: Date {
			get { Date.obsidianDateFormatter.date(from: yaml["date-created"]?.string ?? "") ?? Date() }
			set { yaml["date-created"] = Yams.Node(newValue.obsidianDate, .init(.str), .singleQuoted) }
		}

		var dateModified: Date {
			get { Date.obsidianDateFormatter.date(from: yaml["last-updated"]?.string ?? "") ?? Date() }
			set { yaml["last-updated"] = Yams.Node(newValue.obsidianDate, .init(.str), .singleQuoted) }
		}
	}
}

// MARK: Frontmatter Helpers

fileprivate func replaceFrontmatter(in contents: String, with frontmatter: String) -> String {
	if let extracted = extractFrontmatter(from: contents)  {
		return contents.replacing(extracted, with: frontmatter)
	} else {
		return "---\n\(frontmatter)\n---\n\(contents)"
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
