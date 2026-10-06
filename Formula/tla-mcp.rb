class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.23.2"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.23.2/tla-macos-arm64"
      sha256 "f4894ed3627e0172f53aaae4b60e36fc0955a34cceed55d2b858e3bb08d17af1"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.23.2/tla-mcp-macos-arm64"
        sha256 "1f546709f24fc9cf08d0da9abdc49ccb7007dea0424d155bf3587386ddec9536"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.23.2/tla-macos-amd64"
      sha256 "a73ec19f0fbeadc87db451080405376bb99587878eb4c76c47a6e61a2ca642ff"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.23.2/tla-mcp-macos-amd64"
        sha256 "7cd5da813b33be26ad4cc18a8fedae381ffd280102211aa99be5283f543c0016"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.23.2/tla-linux-amd64"
    sha256 "ae6311b988b7f67caf1b7493ead8b39248031f9696f098c862010246d6635c3b"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.23.2/tla-mcp-linux-amd64"
      sha256 "d369cd2b72073fd429009830961fa7c263d8efbfe547be4b1033e69f56f9b81c"
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
