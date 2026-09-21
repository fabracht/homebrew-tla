class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.9.6"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.9.6/tla-macos-arm64"
      sha256 "2d6dcdad2af20b695d9d4591af9d20d0408e1c52bce73a2a15004289d0259b35"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.9.6/tla-mcp-macos-arm64"
        sha256 "f741668cb16c94eaf6297eec33f28a86285fc4a250d5c065d61383a2fd33d528"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.9.6/tla-macos-amd64"
      sha256 "d192a63ac67a4ef1c42fa90543d627898258eaa04350be29d03f5704507db2bd"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.9.6/tla-mcp-macos-amd64"
        sha256 "588f07092c91bae33d23d71f1d634c7ced920106847edc91d8ed6a41d328a7ad"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.9.6/tla-linux-amd64"
    sha256 "589ced97677ac39ff8c01e39066ca96c073c9cd470cfb72cb7f4aebd2ed1d187"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.9.6/tla-mcp-linux-amd64"
      sha256 "49d1a6b2dee0db4986186fe117b5dd88dd9e1bdf681a8bdb434d5916f9b6f3b8"
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
