class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.24.6"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.6/tla-macos-arm64"
      sha256 "57382d344672e17de6aed8e074c84ff95dfd85ecb5a3d15b1decda6fb99c7368"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.24.6/tla-mcp-macos-arm64"
        sha256 "e8c367ea1cee49b0318663a30ec391c2ea56eebe88dfb2462fd1d57e008467a6"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.6/tla-macos-amd64"
      sha256 "e7d06c4ee1ac9d5b22ec32e9c0850a5054ac6380109463cce160251f3d180dcd"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.24.6/tla-mcp-macos-amd64"
        sha256 "f5ad72d06460a982fd84012b52675eab1d9044173aaaf0e35ef94c4c494858da"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.24.6/tla-linux-amd64"
    sha256 "3d9e1270b7ad9aec1dec87cad4a289c79ad78ca2fe08db2b4e7a8309086e68e2"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.6/tla-mcp-linux-amd64"
      sha256 "d8a222d28e2e0f3fe751aa2918a03dfab97328883f872fcc200908c49fc19ab9"
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
