class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.9.8"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.9.8/tla-macos-arm64"
      sha256 "27f8d0c22c99d09e53c4a056080af870fb0eb24c63ebfe41dee2fd26385356d1"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.9.8/tla-mcp-macos-arm64"
        sha256 "0484ff4a08b6c5f289b2837aab066727de138776421fe4751833bf9ec996aded"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.9.8/tla-macos-amd64"
      sha256 "9f754dea6042cd81b7f80d3425e7b1842b95226685a6da7a1b53992815758fa6"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.9.8/tla-mcp-macos-amd64"
        sha256 "08192ac195c6069fde35785fe159d8a59e295fcdf1f78c3d54f62cb556735805"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.9.8/tla-linux-amd64"
    sha256 "54f99a7def90e465bc4ed426b5f23336bae544894eb03123af3a19f544da426b"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.9.8/tla-mcp-linux-amd64"
      sha256 "4a9a1a6d8791cb9bae0f6105263679ed62d44347959b6d46fafcef1c431c581a"
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
