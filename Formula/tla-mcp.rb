class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.24.7"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.7/tla-macos-arm64"
      sha256 "00145aeb43bb90db0c03979a54ce8a25bf392b1d15e547c8241d64dd6205dd1d"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.24.7/tla-mcp-macos-arm64"
        sha256 "a71e69dadaebe92e6e924ea2b5d1d888027b719f0f69bd94a441f55777885b44"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.7/tla-macos-amd64"
      sha256 "d5837cf08a27fe24209439ca2b439ee9ff88e37ba551eae53d0739473c540b02"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.24.7/tla-mcp-macos-amd64"
        sha256 "dbec8c7c5c365cbb5d8cb65938cbc2b1fd180cfb1fb67b18143112522ea85e0f"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.24.7/tla-linux-amd64"
    sha256 "3e91bd813dfa1542ba2831371c8c9d029ff2e83a19c5aaf766159b71d43643d7"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.7/tla-mcp-linux-amd64"
      sha256 "3594661ecea82fcedcd45823b94700b82d775060274f8cffd130f6ed818afd76"
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
