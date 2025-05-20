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

			let encoder = YAMLEncoder()
			let decoder = YAMLDecoder()

			for document in Obsidian.Vault.enumerateDocuments(in: obsidianArguments.sourceVaultUrl) {
//				let documentFrontmatter = try document.frontmatterObject()
//
//				guard documentFrontmatter.isTagged(with: "media/movie") else {
//					verboseLog("Document \(document.url) is not a movie entry")
//					continue
//				}
//
//				guard let movieFrontmatter = Obsidian.Document.MovieEntry.Frontmatter.for(document: document) else {
//					verboseLog("Could not parse movie frontmatter for \(document.url)")
//					continue
//				}
//
//				guard let entries = letterboxdEntries[movieFrontmatter.title ?? document.title] else {
//					verboseLog("No entry for \(document.url)")
//					continue
//				}
			}
		}

		private func verboseLog(_ log: String) {
			if globalArguments.verbose {
				print(log)
			}
		}
	}
}
