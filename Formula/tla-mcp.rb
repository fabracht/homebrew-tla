class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.13.0"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.13.0/tla-macos-arm64"
      sha256 "22f9b39b32f784769ab72e89b9f3afa2281b351ac1d9a5a9ed8431515b2c490e"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.13.0/tla-mcp-macos-arm64"
        sha256 "597fa18087df9d8e76bfa30ce74e9e76d47f548aeeac8ac907116525b55c510b"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.13.0/tla-macos-amd64"
      sha256 "8276efea9ad3a33b964df8aa7d77c21da17df874e68f078847f78d4c4d6fb427"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.13.0/tla-mcp-macos-amd64"
        sha256 "f42e9fa3deab3813551f40623b6627837ea3e7293167e18547607d602c9ffabb"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.13.0/tla-linux-amd64"
    sha256 "d343d47825eb84b049f959dda48c9130cbacee5029ea9b458adc76c54272e67a"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.13.0/tla-mcp-linux-amd64"
      sha256 "338e036b602e36014e1c2d52d254967e78dc9823bc5e6530a1ba95a41b053a95"
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
