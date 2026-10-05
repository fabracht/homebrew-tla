class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.21.3"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.21.3/tla-macos-arm64"
      sha256 "fdef6508a644c13881dc07f0177397e67d858f6466cb5348345d3bd678948d4c"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.21.3/tla-mcp-macos-arm64"
        sha256 "8ad28eda47c35922fe6e2271b1fa32499e4cef7797ec2d13e62d908859ffeb98"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.21.3/tla-macos-amd64"
      sha256 "e3cb302facec432968b3269b41417a1c06707c79220868c28d16bb84d1384b8f"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.21.3/tla-mcp-macos-amd64"
        sha256 "b655f56a294541c17f3aad44422170b34c3f7eba38dbcc59fa1968ba1ae9394f"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.21.3/tla-linux-amd64"
    sha256 "199fea38202f65c482adb0e722d3165844ea6cd5f23a11c0bf3bcdc50a329c89"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.21.3/tla-mcp-linux-amd64"
      sha256 "e83111cae5e869ec47363a9433008e2be3f26d79df1f022e0a5791e73a5974ff"
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
