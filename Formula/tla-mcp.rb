class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.24.4"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.4/tla-macos-arm64"
      sha256 "abba04d5b69326ea2b2b4f7b278f9951a93c3585308b35df5e73d0c4fe5a0c2b"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.24.4/tla-mcp-macos-arm64"
        sha256 "809d40f1fa7d629925e3b4bae7631531f1355219eb5f3bfed0bfed0a8c984d24"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.4/tla-macos-amd64"
      sha256 "8361813756e4a0f0be93aaf83e9a519686b01c65499ed2bc60f06380ce0f7804"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.24.4/tla-mcp-macos-amd64"
        sha256 "93f970040310a143635c42bf78ffea48c0c1c8597bdb5a8fb5d2de8a10ead3f5"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.24.4/tla-linux-amd64"
    sha256 "089afa912529c922c39818f57ae3b5fba8a0f7c20decaf891c7a409a880a644f"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.4/tla-mcp-linux-amd64"
      sha256 "7046ca4a2373b3d5ef4dc5e5c111698d4c2ce8fbd3de83837a6ed1b78bc55d77"
    end
  end

  def platform_suffix
    if OS.mac?
      Hardware::CPU.arm? ? "macos-arm64" : "macos-amd64"
    else
      "linux-amd64"
    end
  end

  def install
    bin.install "tla-#{platform_suffix}" => "tla"

    resource("tla-mcp-bin").stage do
      bin.install "tla-mcp-#{platform_suffix}" => "tla-mcp"
    end
  end

  test do
    assert_match "tla", shell_output("#{bin}/tla --help", 0)
    # tla-mcp is a stdio server; verify it loads without panic by feeding EOF
    output = shell_output("echo '' | #{bin}/tla-mcp 2>&1", 1)
    assert_match "ConnectionClosed", output
  end
end
