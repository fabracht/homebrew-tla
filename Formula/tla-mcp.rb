class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.9.4"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.9.4/tla-macos-arm64"
      sha256 "ecd542a45f71838a241938f9d684182d31d0de4c3c208362f4fa3604b5fe8db7"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.9.4/tla-mcp-macos-arm64"
        sha256 "64f0c4cffb595f959a3e106b963fca79c4b44d5f35402f7de12f41fd51000faa"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.9.4/tla-macos-amd64"
      sha256 "e533bd7f2bfba775dd402191a6ff0dfb521737e1fac60cd0cd9d0e993cbe49fb"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.9.4/tla-mcp-macos-amd64"
        sha256 "1e930bc95ea5f100c8d3dd75a01fe781cceffdc9a28d255f789d5317f39822b0"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.9.4/tla-linux-amd64"
    sha256 "4c4ee053037ae6126b2adfd6179daa08605ba9b8fd5f46aa6a3b0d718f4fbb7d"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.9.4/tla-mcp-linux-amd64"
      sha256 "b8270cb9bf3aff576795f555420cf12301419451b7eac9be1db05c8ff9847538"
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
