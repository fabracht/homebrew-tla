class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.16.0"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.16.0/tla-macos-arm64"
      sha256 "010a3655684e50695c9b24f4e6cfe3dedf8a74af6487ee5be9f6059e23d2fbd4"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.16.0/tla-mcp-macos-arm64"
        sha256 "0a5d77bffe73cd48e78377db80abb6c730ab5470f56d5381377edf19a23bd6a4"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.16.0/tla-macos-amd64"
      sha256 "73ae5d47add0a2d91da1960e0726dd075191a49274c45b2934bec0f2b939a48e"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.16.0/tla-mcp-macos-amd64"
        sha256 "9bba7a8af097dcb2e5b2dab64943da0548da3fe53ce6934574095af65019a6f7"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.16.0/tla-linux-amd64"
    sha256 "fc3b222a233aed8e1e8a6b5bd955d7b4e031470b07c33ec417dceb28d2ddd294"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.16.0/tla-mcp-linux-amd64"
      sha256 "30751d3599ebc8148d8d661ef0dffcd3878463a01abf9ff00cb48721758b6871"
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
