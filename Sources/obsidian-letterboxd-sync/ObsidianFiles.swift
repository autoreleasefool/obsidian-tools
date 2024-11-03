import Foundation
import Synchronization

struct ObsidianFiles {
	let baseDirectory: URL
	let allFiles: [URL]

	init(baseDirectory: URL) async throws {
		self.baseDirectory = baseDirectory
		self.allFiles = try await Self.searchDirectory(baseDirectory)
	}

	private static nonisolated func searchDirectory(_ directory: URL) async throws -> [URL] {
		var foundEntries: [URL] = []

		let children = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
		for child in children {
			if child.hasDirectoryPath {
				let childEntries = try await searchDirectory(child)
				foundEntries.append(contentsOf: childEntries)
			} else {
				foundEntries.append(child)
			}
		}

		return foundEntries
	}
}
