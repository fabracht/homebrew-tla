class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.23.0"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.23.0/tla-macos-arm64"
      sha256 "ec30f701df4ab051e7b236ab535012008b3ddd185b4342053e04b51fb1b97c2d"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.23.0/tla-mcp-macos-arm64"
        sha256 "fe5cf5bef1d070f79a41c07c193fc18203dc2550ca884d86b83163c86afdf226"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.23.0/tla-macos-amd64"
      sha256 "475f12e17d3b4c6ab09b5747c38e6fe224361cde5beb62fe9aa9785bf9811bd9"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.23.0/tla-mcp-macos-amd64"
        sha256 "4d2548a03eba2c37a23035c4e8bfabb9257b5fa625f952684acd56f77633e4b7"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.23.0/tla-linux-amd64"
    sha256 "98e49611439913c48d0b6137f6ac2bddf9bab0593747b10f15dd50f974629547"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.23.0/tla-mcp-linux-amd64"
      sha256 "31c2d825addd74adf8ebe7b5e54feb106e2e8e828f60e25ee4addc84a1ca69f2"
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
