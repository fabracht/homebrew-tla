class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.9.0"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.9.0/tla-macos-arm64"
      sha256 "b231cfe2fbd748a46a46b6927de91faaa3460d424cb9b141e1f62d0ecc2290a8"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.9.0/tla-mcp-macos-arm64"
        sha256 "48a6960104a6cccb1751549ecbcfc5f63f5b68d5549756fd7c54b96df459bea4"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.9.0/tla-macos-amd64"
      sha256 "29d195ba890a4dfd8481747b768087dd5f3fda725eb7d6c8d8c4a5ed8239448b"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.9.0/tla-mcp-macos-amd64"
        sha256 "8f9331ba1b46263741e8b67b22c96c71a693a14138273cf76862228f70dcc149"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.9.0/tla-linux-amd64"
    sha256 "80566f65baa3ee35405bad11c3f94e6054f51bb9dfb249dcfa54eb7f73984177"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.9.0/tla-mcp-linux-amd64"
      sha256 "f07c4172af284953007b9be1865a97af66f514c58fe53e071573da1ba0a8c3bc"
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
