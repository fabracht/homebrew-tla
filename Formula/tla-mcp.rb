class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.9.7"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.9.7/tla-macos-arm64"
      sha256 "8a46bacc432316f4c17a9bddef31a7a9393508ecc3d65d61c08826f4d060a7d8"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.9.7/tla-mcp-macos-arm64"
        sha256 "31338623122ddc3b53792c1f8b0bedd6914cb6c6f016d685bae6863223b9041d"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.9.7/tla-macos-amd64"
      sha256 "8b62d56c03ce849fcbe48006347c7f73bdb4d6c4e6e375d56cfc58e55a4b0796"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.9.7/tla-mcp-macos-amd64"
        sha256 "65ac3d82612e9429d617e89df5aba0b5b33749869dfa71e4297bb10549cedd01"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.9.7/tla-linux-amd64"
    sha256 "b6e28875103cadb33a796cb91dd0e88fcd4f2945d6d32c7e0d4cac92e68416c5"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.9.7/tla-mcp-linux-amd64"
      sha256 "71cc388ff412090398791c14c7dadfb8c03cf9a9419f6f65bbbb6ea684e335d9"
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
