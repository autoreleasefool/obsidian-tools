import ArgumentParser
import Foundation
import SwiftCSV
import Yams

extension ObsidianTools.Letterboxd {
	struct Pull: AsyncParsableCommand {
		@OptionGroup var obsidianArguments: ObsidianArguments
		@OptionGroup var globalArguments: GlobalArguments

		@Argument(
			help: "Input CSV file",
			completion: .file(),
			transform: { URL(filePath: $0, directoryHint: .notDirectory) }
		)
		var inputUrl: URL

		mutating func run() async throws {
			let diary = try CSV<Named>(url: inputUrl)

			var letterboxdEntries: [String: [LetterboxdEntry]] = [:]

			for entry in diary.rows {
				guard let letterboxdEntry = LetterboxdEntry(data: entry) else {
					continue
				}

				letterboxdEntries[letterboxdEntry.title, default: []].append(letterboxdEntry)
			}

			for var document in Obsidian.Vault.enumerateDocuments(in: obsidianArguments.sourceVaultUrl) {
				guard document.frontmatter.tags.contains("media/movie") else {
					verboseLog("Document \(document.url) is not a movie entry")
					continue
				}

				guard let entries = letterboxdEntries[document.frontmatter.movieTitle ?? document.title],
							let entry = entries.first else {
					verboseLog("No entry for \(document.url)")
					continue
				}

				print("Adding movie metrics from \(document.url)")

				document.frontmatter.movieTitle = entry.title
				document.frontmatter.movieReleaseYear = entry.releaseYear
				document.frontmatter.movieLetterboxdUri = entry.letterboxdUri
				document.frontmatter.movieMetrics = entries.map {
					ObsidianMovieEntry.Metric(
						date: $0.date,
						rating: $0.rating,
					)
				}

				try document.contents.write(to: document.url, atomically: true, encoding: .utf8)
			}
		}

		private func verboseLog(_ log: String) {
			if globalArguments.verbose && log.lowercased().contains("hunger") {
				print(log)
			}
		}
	}
}
