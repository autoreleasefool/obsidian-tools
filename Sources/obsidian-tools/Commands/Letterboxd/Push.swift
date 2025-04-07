import ArgumentParser
import SwiftCSV
import Foundation
import OSLog
import Yams

extension ObsidianTools.Letterboxd {
	struct Push: AsyncParsableCommand {
		@OptionGroup var obsidianArguments: ObsidianArguments
		@OptionGroup var globalArguments: GlobalArguments

		@Argument(
			help: "Output CSV file",
			completion: .file(),
			transform: { URL(filePath: $0, directoryHint: .notDirectory) }
		)
		var outputUrl: URL

		mutating func run() async throws {
			var obsidianEntries: [ObsidianMovieEntry] = []

			let decoder = YAMLDecoder()
			try enumerateDocuments(in: obsidianArguments.sourceVaultUrl) { document in
				verboseLog("Parsing \(document.url)")

				guard let rawFrontmatter = document.frontmatter,
							let frontmatter = try? decoder.decode(ObsidianMovieEntry.Frontmatter.self, from: rawFrontmatter) else {
					verboseLog("Invalid frontmatter \(document.url)")
					return
				}

				guard frontmatter.tags.contains("media/movie") else {
					verboseLog("Document \(document.url) is not a movie")
					return
				}

				print("Adding movie metrics from \(document.url)")

				obsidianEntries.append(
					contentsOf: frontmatter.metrics
						.sorted(using: KeyPathComparator(\.date))
						.enumerated()
						.map { index, metric in
							ObsidianMovieEntry(
								title: frontmatter.title ?? document.title,
								releaseYear: frontmatter.releaseYear,
								date: metric.date,
								rating: metric.rating,
								rewatch: index != 0,
								letterboxdUri: frontmatter.letterboxdUri
							)
						}
				)
			}

			let letterboxdEntries = obsidianEntries
				.sorted(using: KeyPathComparator(\.title))
				.map(LetterboxdEntry.init(obsidianEntry:))

			var csv = "Title,Year,WatchedDate,Rating,Rewatch,Letterboxd URI\n"
			for entry in letterboxdEntries {
				guard let rating = entry.rating.letterboxdRating else { continue }
				csv += "\(entry.title.escapingCommas),\(entry.releaseYear.orEmptyString),\(entry.date.watchDateFormatted),\(rating),\(entry.rewatch),\(entry.letterboxdUri.orEmptyString)\n"
			}

			try csv.write(to: outputUrl, atomically: true, encoding: .utf8)
		}

		private func verboseLog(_ log: String) {
			if globalArguments.verbose {
				print(log)
			}
		}
	}
}

extension String {
	var escapingCommas: String {
		self.contains(",") ? "\"\(self)\"" : self
	}
}

extension Optional {
	var orEmptyString: String {
		if let self {
			"\(self)"
		} else {
			""
		}
	}
}
