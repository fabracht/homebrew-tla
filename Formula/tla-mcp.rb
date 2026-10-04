class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.18.1"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.18.1/tla-macos-arm64"
      sha256 "7c33311d74fbc4a72a46ff7a28c98e838106c332285fc93e4659d77d3941318d"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.18.1/tla-mcp-macos-arm64"
        sha256 "8ce02f4d6207932b736018c5082ba6694038318c317b30478b21ff92bae0b4fd"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.18.1/tla-macos-amd64"
      sha256 "eef4bc3875c05961fd6cbe1dab82c7f3bfebce887d40e3073fe20192697ff9d8"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.18.1/tla-mcp-macos-amd64"
        sha256 "4705e8f9fdbfbed0bef37ef140d8f638305022be1323b6d2f576d5f5d99a5a72"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.18.1/tla-linux-amd64"
    sha256 "eee1a193c260019c6d8236da89c29f702f7ada30ca4b98c2bf63e1e467f737de"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.18.1/tla-mcp-linux-amd64"
      sha256 "1a59f6e95119c70410f51b0b311314133063c2f88e71ddcbd0e5a28c531be96f"
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
