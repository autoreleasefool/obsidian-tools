# Obsidian Tools

My personal tools for working with Obsidian.

## Blog generation

See [bloggen](https://github.com/autoreleasefool/bloggen)

## Letterboxd Sync

Sync movies between Letterboxd and Obsidian

### Usage

Root command: `obsidian-tools letterboxd`

Sub commands:

- `push`: sync from Obsidian Vault to Letterboxd account
- `pull`: sync from Letterboxd account to Obsidian

### Obsidian Vault Format

Files in Obsidian require 2 elements to be eligible for syncing to Letterboxd:

- Must contain appropriate frontmatter(see below)
- Must be tagged `media/movie`

#### Frontmatter

Frontmatter is a YAML document contained within `---` delimiters at the top and bottom, and must be the first content in the document. Any content following the frontmatter in the document is ignored. Documents with invalid frontmatter are ignored

The following frontmatter content is valid:

- `tags`: **(Required)** an array of strings, one of which must be `media/movie`. Not sent to letterboxd
- `metrics`: **(Required)** an array of objects with the following content:
	- `date`: **(Required)** yyyy-MM-dd formatted watch date
	- `rating`: **(Required)** 1-10 rating
	- `tags`: Comma-separated list of tags
- `title`: Title of the movie. If not specified, title of the document will be used
- `releaseYear`: Year of released, used for disambiguation
- `letterboxd-uri`: Letterboxd URI

### Letterboxd Export Format

Letterboxd CSV files will be generated with the following format:

```csv
Title,Year,LetterboxdURI,WatchedDate,Rating,Rewatch,Tags
```
