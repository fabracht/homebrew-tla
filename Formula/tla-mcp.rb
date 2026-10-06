class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.23.1"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.23.1/tla-macos-arm64"
      sha256 "087c1d19299133d5f9cb4282145ba5ba204765b2e934c2f97c110690057fed6b"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.23.1/tla-mcp-macos-arm64"
        sha256 "f0ffc2f223bc92742fad55f1858fb88ce7bf87ed63d1cee3401bc6cc3a88f5c0"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.23.1/tla-macos-amd64"
      sha256 "677db187d39c14083d98dbadd3be67dea397a7b0ad1269df5dfb8f13f5ed4ec8"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.23.1/tla-mcp-macos-amd64"
        sha256 "cb716b57440577e849b626a04a59104326c854a4e4201bd7f3217e6230b7d41e"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.23.1/tla-linux-amd64"
    sha256 "b02b7771aa828cba7e5954e0d350b084a352cc4964b68e1633173d4b041cfe5a"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.23.1/tla-mcp-linux-amd64"
      sha256 "7d68a97f231f3692097589a6dc0406bf70964bf72189891a373397d49d184550"
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
