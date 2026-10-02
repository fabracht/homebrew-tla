class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.12.1"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.12.1/tla-macos-arm64"
      sha256 "df623365cab303b3b79d5724f718c55a298828923c859929d8d5d7b4b2d1df0a"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.12.1/tla-mcp-macos-arm64"
        sha256 "4250efea655334666eca74eb821bf8aa0252356b161af14febc508d38c89e207"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.12.1/tla-macos-amd64"
      sha256 "635ae1934b00288a47f14c5a628251fd31c909d4b2a6ea473f4adae4409a0d74"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.12.1/tla-mcp-macos-amd64"
        sha256 "0e797d732a39aa0987d667ebd39e3896ff51e9eee6a912e4d9939737b6a7d6e6"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.12.1/tla-linux-amd64"
    sha256 "bae94886acae13ed4b7bc839940c7d9ce0e11c9aedea8758e3d375bfc69a1621"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.12.1/tla-mcp-linux-amd64"
      sha256 "b7836e67d75bffc06ebf89d8eb7c9c27bd1b5fc66268c45a3f4b9d2235bfdc14"
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
