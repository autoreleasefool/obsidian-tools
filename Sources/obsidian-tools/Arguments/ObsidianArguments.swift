import ArgumentParser
import Foundation

struct ObsidianArguments: ParsableArguments {
	@Argument(
		help: "Source directory for Obsidian Vault",
		completion: .file(),
		transform: { URL(filePath: $0, directoryHint: .isDirectory) }
	)
	var sourceVaultUrl: URL
}
