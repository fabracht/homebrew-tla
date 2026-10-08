class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.24.2"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.2/tla-macos-arm64"
      sha256 "e361e5aaa4199d45ea8950bbbc990bfdadbb564de80252c58eaa77b0bad3ecb1"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.24.2/tla-mcp-macos-arm64"
        sha256 "459606fbe13b757d6c7d6e4940ff08430d80c2801351bbf85f8985569d7849e4"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.2/tla-macos-amd64"
      sha256 "349eb2161b17492d9299e4d0aa082525b969adf1a00ff63468ecffb0bed2e9e9"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.24.2/tla-mcp-macos-amd64"
        sha256 "80c4de604982b33f8e1ad8fad17da802accc775d9e5895b84c244ce2e8a88ba4"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.24.2/tla-linux-amd64"
    sha256 "244674dce6dcb9639b19d810f3128c69684bea3a4068e22575520f5e3e968a24"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.2/tla-mcp-linux-amd64"
      sha256 "985f74ac797d143f7291d16f2c43f62b0c0d96b060e5ed1433d9282b24be771c"
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
