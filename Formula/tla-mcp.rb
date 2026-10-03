class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.14.0"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.14.0/tla-macos-arm64"
      sha256 "913efa91d6dee63aad34db4536c78aaa80775692bbdbaafc7d866f9dca136b57"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.14.0/tla-mcp-macos-arm64"
        sha256 "d4b0e0048f8058347aab3f338aab4a2f73e5ca2ee03ee0a97af6fc4dbaf9f9aa"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.14.0/tla-macos-amd64"
      sha256 "7dabd0a98bc014441ea9d0d17a31b8b94d76b787dbb888258f3c2410fc3c5501"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.14.0/tla-mcp-macos-amd64"
        sha256 "4fc5916ee1e6ac3a8187d50e02f332381be58e4655c7a029686b0558b6bc1165"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.14.0/tla-linux-amd64"
    sha256 "40a80fe23b35f065a7a2fe0ca8516574d453022fe776dd1cc288a3aad3833f27"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.14.0/tla-mcp-linux-amd64"
      sha256 "eafc75400cfea3fc2a6ff5730a3c28fd21955b4b8ab2779899e7dbd3c4151d0c"
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
