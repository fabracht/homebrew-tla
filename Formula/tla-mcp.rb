class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.24.9"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.9/tla-macos-arm64"
      sha256 "748ceef9cfaa217f6f8b4eeaec029292f2f97fbc46fb120cdc2402f000377a7d"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.24.9/tla-mcp-macos-arm64"
        sha256 "830e3b71f69c4f0cc53f187db1d54748a402bcc151bf1f1145216f88af83e4f2"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.9/tla-macos-amd64"
      sha256 "d1a5b4b1aeb6f3f82a0611c568b1c89aae9e5297803f26c90361f2e01c8e203a"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.24.9/tla-mcp-macos-amd64"
        sha256 "96bfc54bb07a674a99815724952c3a068d442273a37c718ac48409b53c28365a"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.24.9/tla-linux-amd64"
    sha256 "4ccae69c707cbd4b66cb60e425fd1e8b9eb0f849b2a9377a375f0cdfcd0aed67"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.9/tla-mcp-linux-amd64"
      sha256 "f54da18ff47019e64c8c86a8b3e7d3c40fb783752ea79e9f758a72f7fb3276ce"
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
