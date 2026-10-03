class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.15.0"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.15.0/tla-macos-arm64"
      sha256 "c13a341dd4a5adf2f889ad99b07c4dc29b522b60abe72926a78667215f041ccb"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.15.0/tla-mcp-macos-arm64"
        sha256 "a749875b2c4e49fc2e9d857d708f09539d13c3a820c0daeef4dc2c86f5a959fa"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.15.0/tla-macos-amd64"
      sha256 "b80c08a5b1a39dff39134c4998fca1097d871a4aa7b815f18c5fc2d07baab05f"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.15.0/tla-mcp-macos-amd64"
        sha256 "6eb65c6c6b17f81c933f3d9432154c2ac1f41367344385409440a527f74edfbb"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.15.0/tla-linux-amd64"
    sha256 "aff9884308fdc29d3c5cf86c4869ddbe06e850f9510d555eb14da1b6c0c91aa6"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.15.0/tla-mcp-linux-amd64"
      sha256 "03dbc5b3f82a2d091f12a2bf0301301a69fecac6b7fe25a45d925e844d179e4b"
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
