class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.22.0"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.22.0/tla-macos-arm64"
      sha256 "7ccdf87abca621b0c1826f506e8c153ced76fd8d247bdb002e3f9f6e54c4e145"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.22.0/tla-mcp-macos-arm64"
        sha256 "82acf8ea75128ca26c78c312e61bc19c12765563654badc09075173f1129fd10"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.22.0/tla-macos-amd64"
      sha256 "d1f98e6f0a3a35c8ab10a1110cccc2c9883ad5d5115034004774848cc7fc4540"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.22.0/tla-mcp-macos-amd64"
        sha256 "3ebe85863d5870fd604e628f9bda3d4d237cc7f5859cf91d1785d402d27b5936"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.22.0/tla-linux-amd64"
    sha256 "5acdff4920362cb5e2f133a1e86b96cd7dc173ae79dcbe89519d15baf6843907"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.22.0/tla-mcp-linux-amd64"
      sha256 "498116fd06c7868e384ee0b668d648ef8524e1e5fb958e9ea046ccca754a3be7"
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
