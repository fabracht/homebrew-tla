class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.18.0"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.18.0/tla-macos-arm64"
      sha256 "a45892928e6b994d23871a3380c1a0f27813590fe9312f3c00177f8153a58778"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.18.0/tla-mcp-macos-arm64"
        sha256 "188577843933c94ebc8ff506a0bb76c167495604306a532b5bd2f57e98dbdd48"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.18.0/tla-macos-amd64"
      sha256 "8e4ad892eac6a8c8cfeb2f33ad96667d2a2a562d04cd05041760ae7159bd8135"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.18.0/tla-mcp-macos-amd64"
        sha256 "764117e78de3adbef52deba9dfb1ba1ff177de3c23edc4b24a5dd472eb00baaa"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.18.0/tla-linux-amd64"
    sha256 "b13e30ff5da8e3877facbe763a5fdc5d93f78fa39195c846ef1ac81ebc38df84"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.18.0/tla-mcp-linux-amd64"
      sha256 "af1e18e02fa46eb87e15209e43301d7f7dda8ec5ae2a85fc0b7b6fd61726a547"
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
