class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.6.11"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.6.11/tla-macos-arm64"
      sha256 "ae0ef65de9e61d72be35391cc4c3090b84dfedf4bc228288e7d2a690968cefa9"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.6.11/tla-mcp-macos-arm64"
        sha256 "60bc125f8afd4a80f6376a63a55436d482c6a26e5b0fd7a08f4147ba1d832995"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.6.11/tla-macos-amd64"
      sha256 "cf80c794e40fada5c116d7073886f2ec8a4f735c6f325f185b45a84bcf675642"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.6.11/tla-mcp-macos-amd64"
        sha256 "79d7926171c08c16fb607b5c4ca2b5f9cddddc1e5bcff0f81bfc77e54113180b"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.6.11/tla-linux-amd64"
    sha256 "b4a273819473e041ceca0a4809efcd90535d8862d57b48c1611efe53e505278d"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.6.11/tla-mcp-linux-amd64"
      sha256 "ad147aebefcbbe82577025f909dc8af88e7e53a392c76dcb4cbaeb73a630f603"
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
