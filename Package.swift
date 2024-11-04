// swift-tools-version: 6.0

import PackageDescription

let package = Package(
	name: "obsidian-tools",
	platforms: [
		.macOS(.v14),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.2"),
		.package(url: "https://github.com/jpsim/Yams.git", from: "5.1.3"),
	],
	targets: [
		.executableTarget(
			name: "obsidian-tools",
			dependencies: [
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
				.product(name: "Yams", package: "yams"),
			]
		),
		.testTarget(
			name: "obsidian-toolsTests",
			dependencies: [
				"obsidian-tools",
			]
		)
	]
)
