class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.19.0"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.19.0/tla-macos-arm64"
      sha256 "1a7ecb7485a38d82e9a086ad0d81b21e0c556cce6165a67333dfbca853cb2119"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.19.0/tla-mcp-macos-arm64"
        sha256 "ce61f4cea7bc994937b5a4271662b9e9df821a1d7ef8c3278f01c529c3d90213"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.19.0/tla-macos-amd64"
      sha256 "5da7fff19438758ebaa8dbbf2b9f615459eb138b6febde5316d88a6c95331eb2"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.19.0/tla-mcp-macos-amd64"
        sha256 "7723827c6c3b742e9d06b39acd725bd6ce2e577eba33b2c90fcba8e69f6af04d"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.19.0/tla-linux-amd64"
    sha256 "e094960bc2565aa13dfaca67e570bbb83fc0917397ba351bba0335964e2e2a46"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.19.0/tla-mcp-linux-amd64"
      sha256 "cdc226b41acd5b5509f64574af54ed9c16306d8da038ac98d2525e3f23409381"
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
