import ArgumentParser
import Foundation

@main
struct ObsidianTools: AsyncParsableCommand {
	static let configuration = CommandConfiguration(
		abstract: "A utility for Obsidian",
		subcommands: [Letterboxd.self]
	)
}
