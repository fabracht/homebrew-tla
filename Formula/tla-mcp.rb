class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.9.9"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.9.9/tla-macos-arm64"
      sha256 "c64db807362a913d753d14c75835973a3dad0f29b6dfd398e37cc60f28e83d2a"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.9.9/tla-mcp-macos-arm64"
        sha256 "23d313477c2f59a61554cb223ecebc14c488ab67090f9609f34cc9098cdda4dc"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.9.9/tla-macos-amd64"
      sha256 "f1b0df6748e0c927bac097baf5d6e7c94c430ab44ebffbe3ced25f1c34f7fb8f"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.9.9/tla-mcp-macos-amd64"
        sha256 "1af5a50a8f91bf24ee74a359d97b208978d63a277cf542bafa61178f8aaaef36"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.9.9/tla-linux-amd64"
    sha256 "48f73c0ce030c65c46c1cea4bf05bcc7b7fd2fa20bed7e117ad6d15e3633ba08"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.9.9/tla-mcp-linux-amd64"
      sha256 "d574039ce6bb11e8224006ea3bfa671f1b268109acbaa1fb80e54ff201702085"
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
