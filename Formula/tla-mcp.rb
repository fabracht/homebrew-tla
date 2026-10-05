class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.21.2"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.21.2/tla-macos-arm64"
      sha256 "131ba9ff09cbb92f5f20a2610be3eafabed04eeebc2f150d282752ac2ed8bb0f"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.21.2/tla-mcp-macos-arm64"
        sha256 "208c50f3ee531f0f71061f23c855beec559c8d898f9b0e41580bfac35956244b"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.21.2/tla-macos-amd64"
      sha256 "a27c9af40bde75dd77115337024fd0de07e737a0a5833b7dd9e78bc5fd8442b4"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.21.2/tla-mcp-macos-amd64"
        sha256 "124732613b12adba3ee4bb1eeee8b50fadb2645d0e99ab2094660d298ff3964f"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.21.2/tla-linux-amd64"
    sha256 "972afd258fd94c24c003ab9dd34126aee323e2275f825f0237db826ac29905ab"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.21.2/tla-mcp-linux-amd64"
      sha256 "9fbb21f014cc6a1177f07b44f511bf0cb14c93fd2c2b479157a74e8aae0f8088"
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
