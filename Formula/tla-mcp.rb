class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.11.0"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.11.0/tla-macos-arm64"
      sha256 "201d4d5ebca424fe24c93319f1924546001339a1a0d723d96beee4231c14f610"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.11.0/tla-mcp-macos-arm64"
        sha256 "957874931a18479f8d0d0399c5f35ee595790da5294f1a3305a181374df9d179"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.11.0/tla-macos-amd64"
      sha256 "d09c1d7807e61fe46e73b3f502c978e68561ec368b5367298e135bc453109dbe"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.11.0/tla-mcp-macos-amd64"
        sha256 "961fce114b95ca095ba68777890ee28e615422dda75aa452015a6341bf23d7c8"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.11.0/tla-linux-amd64"
    sha256 "31f85d62b136f58e4b69b704c0a46756ed1d5e459ac69f8f74a88e52b1b18b47"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.11.0/tla-mcp-linux-amd64"
      sha256 "37f7a7a4862eceff5a1758d232c27dde79498cb612850fe0dd18fb20390dcb7d"
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
