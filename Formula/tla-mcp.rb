class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.17.2"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.17.2/tla-macos-arm64"
      sha256 "0e54f2295cd63fd4420d1149165fed05f663b834b4cb0f6d8d82bfa8801336eb"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.17.2/tla-mcp-macos-arm64"
        sha256 "07167e4234128c37451ce68785ae1d871466a6f55b5044d1ce86b08d3f5fe240"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.17.2/tla-macos-amd64"
      sha256 "1b434d571ac6a727afe12f6226b3a6e28a8077ae814f8f5eecc934e6797da89f"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.17.2/tla-mcp-macos-amd64"
        sha256 "fd22cc27efe84fd8374ebd2341726b7911100720b63a4248838c197bd85094f6"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.17.2/tla-linux-amd64"
    sha256 "dbe985a658b301d14ae2fa0f765ac2214b24005334ff320acfc0b65cacbfcdb6"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.17.2/tla-mcp-linux-amd64"
      sha256 "56c829829acdf8f9c6a6016e56cde010a19dd46f3ee02b2cd1dcbcca7d06d6da"
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
