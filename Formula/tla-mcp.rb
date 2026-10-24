class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.24.10"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.10/tla-macos-arm64"
      sha256 "7cf989a2ae6b27fd9118f24dd1910409e2a00fac81e7a54d7dd75e8167321de1"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.24.10/tla-mcp-macos-arm64"
        sha256 "67baf9f580bb649daee528e48fdae7a85bc7a1046c2193ed401355e66699bb00"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.10/tla-macos-amd64"
      sha256 "6d026f27d75f1b9034bd9fb0d624ea7fef77805d76bb1cc221a0121f85ad6ffc"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.24.10/tla-mcp-macos-amd64"
        sha256 "5b92c254b4afc06ead0144320166cff977721dd8137202aa042b5d81df371f2e"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.24.10/tla-linux-amd64"
    sha256 "6572bc12b8f10b8502a430442347b706e185326ff9f30cc24b9826224da6358e"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.10/tla-mcp-linux-amd64"
      sha256 "baeaf36fa8a4a7f82ef2308ea117d2e13309cf21e61a8579be1e43819be49bc1"
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
