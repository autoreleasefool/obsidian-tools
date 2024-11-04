import Yams

struct ObsidianEntryImporter {
	func findEntries(in files: ObsidianFiles) async throws -> [ObsidianEntry] {
		var entries: [ObsidianEntry] = []

		for file in files.allFiles {
			print("Processing \(file)")
			guard let contents = try? String(contentsOf: file, encoding: .utf8) else {
				print("Failed to open \(file)")
				continue
			}
			guard let frontmatter = try extractFrontmatter(contents) else {
				print("Failed to read fm \(file)")
				continue
			}

			guard frontmatter.tags.contains("media/movie") else {
				print("not media \(file)")
				continue
			}
			print("Importing \(file)")

			entries.append(
				contentsOf: frontmatter.metrics
					.sorted(by: { $0.date < $1.date })
					.enumerated()
					.map { index, metric in
						ObsidianEntry(
							title: frontmatter.title ?? file.lastPathComponent.replacingOccurrences(of: ".md", with: ""),
							releaseYear: frontmatter.releaseYear,
							date: metric.date,
							rating: metric.rating,
							rewatch: index != 0,
							letterboxdUri: frontmatter.letterboxdUri
						)
					}
			)
		}

		return entries
	}

	private func extractFrontmatter(_ string: String) throws -> ObsidianEntry.Frontmatter? {
		var didStartFrontmatter = false
		var didFinishFrontmatter = false
		var frontmatter = ""
		for line in string.components(separatedBy: .newlines) {
			if !didStartFrontmatter {
				if line == "---" {
					didStartFrontmatter = true
					continue
				} else if line.isEmpty {
					continue
				} else {
					// Non-empty line before frontmatter, discard file
					return nil
				}
			}

			if line == "---" {
				didFinishFrontmatter = true
				break
			}

			frontmatter += "\(line)\n"
		}

		if !didFinishFrontmatter {
			return nil
		}

		let decoder = YAMLDecoder()
		return try? decoder.decode(ObsidianEntry.Frontmatter.self, from: frontmatter)
	}
}
