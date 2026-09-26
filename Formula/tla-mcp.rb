class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.10.2"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.10.2/tla-macos-arm64"
      sha256 "3e7ebdfb31212bc61983a43e059c56b77b7ba2a46ceae051a6bfa641ea4c6ff3"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.10.2/tla-mcp-macos-arm64"
        sha256 "0ed4b15a7970901ceda717790b7bddd55d8561649a3c9e4099347d2abeb99679"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.10.2/tla-macos-amd64"
      sha256 "7570979838f977c6667b3b3b530acb8bb28e284cce9531c8d9891983d45b041d"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.10.2/tla-mcp-macos-amd64"
        sha256 "44eab41556ce7ec4dd8dbcff8de72be07bc530846fbe50f961f94d08c652c38a"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.10.2/tla-linux-amd64"
    sha256 "8ab94ae1db3b58b1a23701e1ff9d6a86f75c90c7880d9d993cd32483c4e326b9"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.10.2/tla-mcp-linux-amd64"
      sha256 "04cdef52de62b71d6dbb742115166eb4bfab0cdd57e0c6cf182966e192115833"
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
