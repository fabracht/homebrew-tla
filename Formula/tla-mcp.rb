class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.21.1"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.21.1/tla-macos-arm64"
      sha256 "6423f602b6e7002fc662b7ed708cf8541e89ffcd21f625b88f33bc61739c4688"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.21.1/tla-mcp-macos-arm64"
        sha256 "1ed290d8fad10996bbc96e923a3441d2be4121387fb8504865d5665c0eee1559"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.21.1/tla-macos-amd64"
      sha256 "943610f88c2b7fe6867094afb6c9cc96687c60dec7a3eb8ddbf5ad712cb1ada5"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.21.1/tla-mcp-macos-amd64"
        sha256 "2f7a3535ff099b3b09c7660e479e43f02672db12236659580b91e05d673ed14c"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.21.1/tla-linux-amd64"
    sha256 "840ab49673e7775b7d4aa3cb69bb0bc2a375501b859ed38bc85af6f58c2a4447"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.21.1/tla-mcp-linux-amd64"
      sha256 "845c20f380863fe6f12a38f7144db70ccd75fca118d8c1c9705e76f86df09a2c"
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
