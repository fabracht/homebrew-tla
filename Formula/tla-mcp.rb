class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.8.0"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.8.0/tla-macos-arm64"
      sha256 "cc7eea9198c1a5d8ad27b3529d52c3176716617aed9fcaf08154e2d94c2a9896"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.8.0/tla-mcp-macos-arm64"
        sha256 "10980c01d85e5268a321417c8127cf223eb86824025f6d128a3fd25857be8a97"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.8.0/tla-macos-amd64"
      sha256 "d304ede66681eec94d553ed9ba4bf45a8e810700aad0ea3d7234482d02058b22"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.8.0/tla-mcp-macos-amd64"
        sha256 "19eb5b2bab566bc498b4f0454dd0e9a7091de6d88dfb19132ae52ef1ac1f7496"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.8.0/tla-linux-amd64"
    sha256 "480aa80bcfe5b353ffb5d9f2bc09daed63ebb3b6dbbbd7198f5e08f1239bbfc5"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.8.0/tla-mcp-linux-amd64"
      sha256 "594e493d04c98712bff7ff4bc460f3c4ef75eda173fe667a16873f2ea15d4708"
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
