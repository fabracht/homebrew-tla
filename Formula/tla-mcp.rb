class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.9.2"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.9.2/tla-macos-arm64"
      sha256 "6245329edc9e79da13fcd91e993d6175c5aceeeb4de9905140f1653176c45a74"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.9.2/tla-mcp-macos-arm64"
        sha256 "dbf3748b6e666a15ba3f37d829decc7ff463dc3cba13f743a7a6027947a65cba"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.9.2/tla-macos-amd64"
      sha256 "9db7549faf170c9089fa98485a841051cddc0e0bd23ec2ceac1c6a144f9b3147"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.9.2/tla-mcp-macos-amd64"
        sha256 "41f7f5478d19d9230dda5cf83651e1f3f95eb38a863bbf70a5b862fd00e44586"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.9.2/tla-linux-amd64"
    sha256 "374fb62e1746263237ba8ff32ce03129e91533341f5342d47ca16455259bce8a"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.9.2/tla-mcp-linux-amd64"
      sha256 "f39d6886a8cbd54dc568f0f1911d17329286d53d32153316d902fbb62eb8d12c"
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
