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
			for document in Obsidian.Vault.enumerateDocuments(in: obsidianArguments.sourceVaultUrl) {
				let documentFrontmatter = try document.frontmatterObject()

				guard documentFrontmatter.isTagged(with: "media/movie") else {
					verboseLog("Document \(document.url) is not a movie entry")
					continue
				}

				verboseLog("Adding movie metrics from \(document.url)")

				guard let movieFrontmatter = Obsidian.Document.MovieEntry.Frontmatter.for(document: document) else {
					verboseLog("Could not parse frontmatter for \(document.url)")
					continue
				}

				obsidianEntries.append(
					contentsOf: movieFrontmatter.metrics?
						.sorted(using: KeyPathComparator(\.date))
						.enumerated()
						.map { index, metric in
							ObsidianMovieEntry(
								title: movieFrontmatter.title ?? document.title,
								releaseYear: movieFrontmatter.releaseYear,
								date: metric.date,
								rating: metric.rating,
								rewatch: index != 0,
								letterboxdUri: movieFrontmatter.letterboxdUri
							)
						} ?? []
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
