class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.10.0"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.10.0/tla-macos-arm64"
      sha256 "df3bc2e6b47330905992d672f62f68d1d5b74ca21a3f28e7d95110dcbf2fffd9"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.10.0/tla-mcp-macos-arm64"
        sha256 "165c0f97fff0601afef2113131d797762a979f39b8b1aafbd3bd42a4d5e61ffc"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.10.0/tla-macos-amd64"
      sha256 "51533bd3151511784bb398ec73668b5c8edd2765fec874a55b2e7f915f8d39d1"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.10.0/tla-mcp-macos-amd64"
        sha256 "8b5bbe7d125abe89a00241194f6a4dfb00b976b7f8d68a8a231ee7b84d678ec3"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.10.0/tla-linux-amd64"
    sha256 "94f3b2add5a004cae09fbae58c67f12bee89d06cd070466dda784b1c0a8a95d4"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.10.0/tla-mcp-linux-amd64"
      sha256 "7707f7eb9a500401252b8e53e2e852c3ec5c96dbb936396ea33435da8f37736f"
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
