import Foundation
import Yams

extension Obsidian {
	struct Document: Equatable {
		let url: URL

		var frontmatter: Frontmatter {
			didSet {
				_contents = replaceFrontmatter(in: contents, with: frontmatter.yaml.string)
			}
		}

		private var _contents: String
		var contents: String {
			get { _contents }
			set {
				_contents = newValue
				frontmatter = Frontmatter(root: extractFrontmatter(from: newValue) ?? .init(""))
			}
		}

		init(url: URL) throws {
			let contents = try String(contentsOf: url, encoding: .utf8)
			let frontmatter = extractFrontmatter(from: contents)

			self.url = url
			self.frontmatter = Frontmatter(root: frontmatter ?? .init(""))
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
			set { yaml["tags"] = try? Yams.Node(newValue) }
		}

		var alias: [String] {
			get { yaml["alias"]?.array(of: String.self) ?? [] }
			set { yaml["alias"] = try? Yams.Node(newValue) }
		}

		var dateCreated: Date {
			get { yaml["date-created"]?.timestamp ?? Date() }
			set { yaml["date-created"] = try? Yams.Node(newValue) }
		}

		var dateModified: Date {
			get { yaml["last-updated"]?.timestamp ?? Date() }
			set { yaml["last-updated"] = try? Yams.Node(newValue) }
		}
	}
}

// MARK: Frontmatter Helpers

fileprivate func replaceFrontmatter(in contents: String, with frontmatter: String?) -> String {
	if let extracted = extractFrontmatter(from: contents)?.string {
		return contents.replacing(extracted, with: frontmatter ?? "")
	} else if let frontmatter {
		return "---\n\(frontmatter)\n---\n\(contents)"
	} else {
		return contents
	}
}

fileprivate func extractFrontmatter(from contents: String) -> Yams.Node? {
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
			return try? Yams.compose(yaml: frontmatter)
		}

		frontmatter += "\(line)\n"
	}

	return nil
}
