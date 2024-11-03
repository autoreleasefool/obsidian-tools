// swift-tools-version: 6.0

import PackageDescription

let package = Package(
	name: "obsidian-letterboxd-sync",
	platforms: [
		.macOS(.v14),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.2"),
		.package(url: "https://github.com/jpsim/Yams.git", from: "5.1.3"),
	],
	targets: [
		.executableTarget(
			name: "obsidian-letterboxd-sync",
			dependencies: [
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
				.product(name: "Yams", package: "yams"),
			]
		),
		.testTarget(
			name: "obsidian-letterboxd-syncTests",
			dependencies: [
				"obsidian-letterboxd-sync",
			]
		)
	]
)
