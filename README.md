# homebrew-tla

Homebrew tap for [`tla-rs`](https://github.com/fabracht/tla-rs) — a TLA+ model checker and Model Context Protocol server written in Rust.

## Install

```bash
brew install fabracht/tla/tla-mcp
```

This installs both binaries:

- `tla` — the model checker CLI
- `tla-mcp` — the MCP server (stdio transport)

## Update

```bash
brew update
brew upgrade tla-mcp
```

## Supported platforms

| Platform | Status |
|---|---|
| macOS arm64 (Apple Silicon) | ✅ |
| macOS x86_64 (Intel) | ✅ |
| Linux x86_64 (via Linuxbrew) | ✅ |

Other platforms: use `cargo install tla-checker --bin tla-mcp` or `cargo install tla-checker` for the full bundle.

## How this tap is maintained

The formula source lives at [`packaging/homebrew/tla-mcp.rb`](https://github.com/fabracht/tla-rs/blob/main/packaging/homebrew/tla-mcp.rb) in the main `tla-rs` repo. On each release:

1. The release workflow attaches a `SHA256SUMS` asset to the GitHub release.
2. The maintainer copies the updated `tla-mcp.rb` into `Formula/` here and pushes.

`brew livecheck tla-mcp` reports when a new upstream release is available.
