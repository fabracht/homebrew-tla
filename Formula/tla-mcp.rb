class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.21.0"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.21.0/tla-macos-arm64"
      sha256 "ce2cc10475d4b5fafafffd804fff02c9755c2cf1d1514a2dbeea26ac47991586"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.21.0/tla-mcp-macos-arm64"
        sha256 "398f37e3e9ba099b4387881bcc40ba60701da86f53c068380b2c4960ff370ee2"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.21.0/tla-macos-amd64"
      sha256 "c9de9e49cd284bb1d760633233ff58f167b0e49490e53bf1f54fc9886fbd7c02"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.21.0/tla-mcp-macos-amd64"
        sha256 "69712499aa6ede6a9ac5e0926f80114cce54fdb86123fd9593bbc1abc4c30365"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.21.0/tla-linux-amd64"
    sha256 "b5c98265c5a598696b4e1fd3245e93bd9b0aeb9221f3fc6cbd11604f2162e5f2"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.21.0/tla-mcp-linux-amd64"
      sha256 "0742079d96b51ae9a44e9c57ca35fe9a45deb2c45dbfa82e02a4afb9fdf38ac0"
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
