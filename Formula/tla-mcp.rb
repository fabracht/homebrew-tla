class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.17.0"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.17.0/tla-macos-arm64"
      sha256 "2b8f3b21fcad041845a2451f98230f5383637078df5656e4d54e667de1812aa4"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.17.0/tla-mcp-macos-arm64"
        sha256 "ca686abe62f891a145997dbc13101147ecff7797e4915efd4e048b8020991eb3"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.17.0/tla-macos-amd64"
      sha256 "f3ad3e3065e978b493844b468a8c78a13e9dc077b5b68bc36642fe816242ec75"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.17.0/tla-mcp-macos-amd64"
        sha256 "5fc389c7f80106058fbf5eddcd974988091ff1f7044942242b82ef3b23f154d4"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.17.0/tla-linux-amd64"
    sha256 "3801b797d1dc40c29f88891a15a7b3bd2cb544d4966edc6114ddf269be2d9f20"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.17.0/tla-mcp-linux-amd64"
      sha256 "25766e3487d0ac34a8a9a82ca7462ffec398e83e57af4994a1569c5d52b26452"
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
