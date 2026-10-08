class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.24.1"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.1/tla-macos-arm64"
      sha256 "5b370a41392f41f928bd4c0e0be76fab17f8609b7c13da193364d275a065f702"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.24.1/tla-mcp-macos-arm64"
        sha256 "0152520f1fd231bdd7f611b395c6cc3c5755b9e0d71aa503194ed036554c47a7"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.1/tla-macos-amd64"
      sha256 "7be337ef321be36f167dee7f263feec2afdb3bab99a53b6a141756f9f8f45516"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.24.1/tla-mcp-macos-amd64"
        sha256 "1d1cb85c9fd1fd5a38a42c879a4f78137e01bcaf8a31c0e43205fa26a5b03085"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.24.1/tla-linux-amd64"
    sha256 "c86461dd50b665a7a755176de51abd5024ea1d175b1b13c400d0b6692453e406"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.1/tla-mcp-linux-amd64"
      sha256 "fc30d04decfab1778f5122c79d172801770abc225533a061ac1a21df4e6e3a56"
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
