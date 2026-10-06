class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.23.3"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.23.3/tla-macos-arm64"
      sha256 "adbef3267b95ac74f0fe8cd23fbb3d3e2ea503d1f5c0b307e2c0c896c4c83c65"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.23.3/tla-mcp-macos-arm64"
        sha256 "e6ced4831dc68c90e3703f80da1e07644f2e7a42c06039200b121778f01cc1db"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.23.3/tla-macos-amd64"
      sha256 "d38b6d38d85f3015db8e71482904600bf8fe92902132abe2be9d7e07aa6c805c"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.23.3/tla-mcp-macos-amd64"
        sha256 "8e654818609e39e664ad5e9396909a198ef7a22d99008a5aeaf3a6f27c7f85d2"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.23.3/tla-linux-amd64"
    sha256 "90185d2b86537eae7610f91e18eb71dea64a585eac7b79566ef0440bd5677c24"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.23.3/tla-mcp-linux-amd64"
      sha256 "a9855a8f64c592fec9c418d2d0ea753155b3a66fcceff43d5865580e781e81cd"
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
