class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.24.8"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.8/tla-macos-arm64"
      sha256 "eff43b17a98525a6a226ec8a09f0614f42e56d8dc580bdfe515de3a36635b143"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.24.8/tla-mcp-macos-arm64"
        sha256 "f58e1dde6890eef1cc6fe4f453226cb81b6b8162b1c1871cdd58eae51683ad0f"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.8/tla-macos-amd64"
      sha256 "f79dde8b7c397b182875459efb91eb3d995fea3a58a9b0feec100ca269850fb1"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.24.8/tla-mcp-macos-amd64"
        sha256 "0d640f7fc6fb12b344e8e4f35774e190dd98e8e1ecef306f6b3fb1047adfa85a"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.24.8/tla-linux-amd64"
    sha256 "5a433a3ba82e8255d0f71d2ad9b1cbf074b0e9de0c67c393916cbf497c609bd3"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.8/tla-mcp-linux-amd64"
      sha256 "80f1b12bbc64df131d73b48121600ad694ece86a2ae29606bd6b2a15e2ea935a"
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
