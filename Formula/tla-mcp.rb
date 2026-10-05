class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.20.0"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.20.0/tla-macos-arm64"
      sha256 "c5d56b5b56060652632cf2584427bb07afd33dd167b743d20a58cf6ca8caf33e"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.20.0/tla-mcp-macos-arm64"
        sha256 "ef57f9d62c0f9d9be0699db677144e4d6cb277acd024bb22c7cffb81eef49c79"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.20.0/tla-macos-amd64"
      sha256 "9c2d19910e63825082f592de03726aa4a96ca06d9a3d3317483e167bace51e30"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.20.0/tla-mcp-macos-amd64"
        sha256 "ddbb4de2006a305afd690e7dd2d6a4b946665523550078025718902e25a529c4"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.20.0/tla-linux-amd64"
    sha256 "067be38ed44f5b65a71e16fd546aa2fa03420ae312584932b299f368d4cf6e08"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.20.0/tla-mcp-linux-amd64"
      sha256 "c6cde23b0dc4264ea1365b897213879e6edf3a7016784c5b317cc45736382e74"
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
