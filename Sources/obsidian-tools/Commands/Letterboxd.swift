import ArgumentParser
import Foundation

extension ObsidianTools {
	struct Letterboxd: AsyncParsableCommand {
		static let configuration = CommandConfiguration(
			commandName: "lbx",
			abstract: "Sync between Obsidian and Letterboxd",
			subcommands: [Pull.self, Push.self]
		)
	}
}
