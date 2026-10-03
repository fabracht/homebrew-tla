class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.15.1"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.15.1/tla-macos-arm64"
      sha256 "0ea10f9ba607ec8027788ddafccccb7b72a0321b115149d547fface29b0488cd"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.15.1/tla-mcp-macos-arm64"
        sha256 "b1bca17dc3e6d4276d9779c198846cb6407b2741031f15c3d5eae3d1c7abe313"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.15.1/tla-macos-amd64"
      sha256 "52c0f49608434494a8673e5c6f21bf29daa0aea599f5b1d603d692e546e5f788"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.15.1/tla-mcp-macos-amd64"
        sha256 "231bfd4605a8f73273b8172dd56f11da95a7176f07662b4c1c8b81735fa2f1bb"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.15.1/tla-linux-amd64"
    sha256 "e12d1b8db3c639bf873d669b871f71e978ee8d69341309703bdb4a0d39e2fc90"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.15.1/tla-mcp-linux-amd64"
      sha256 "42867449dcbe541d06f72e352e04e855e3c80a3060b0e69c6994fe852697af66"
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
