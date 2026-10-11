class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.24.5"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.5/tla-macos-arm64"
      sha256 "0c62b19d16e365b8e548ab9dc1128004637f7d5b3647b983cbe90a339c283179"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.24.5/tla-mcp-macos-arm64"
        sha256 "359f5cb470622b7ced9b38b879ffe58859142934c57f8084059fe23605b795c0"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.5/tla-macos-amd64"
      sha256 "fbc86fd2087c0a4b4abf039c6ac3411f5f7946490514a05ba6a066b6e6bb8d53"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.24.5/tla-mcp-macos-amd64"
        sha256 "b87b5e8c9d4c270fac358e9c385263e2a7cca1130c1bf74ef11dcc1984a55c1c"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.24.5/tla-linux-amd64"
    sha256 "789f12251959c8d502687a76e7b75bdf82724e9f85279c4e9d771928f63f95bf"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.5/tla-mcp-linux-amd64"
      sha256 "0dca2343f665383914e941be590452287cf3667bcd35753ce41538999c32d08f"
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
