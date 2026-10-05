class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.22.1"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.22.1/tla-macos-arm64"
      sha256 "173d51793da88ab25850c52118e9d16138e025900fd48578e66d27c9ae34e357"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.22.1/tla-mcp-macos-arm64"
        sha256 "0801c6cea6a1342743b25ac3d8a35fb655541a82303bc77c39127287d756b018"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.22.1/tla-macos-amd64"
      sha256 "3c731cb7f2d587822db673d3b2229efd549291e58f8faef40e9e202e63d4d306"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.22.1/tla-mcp-macos-amd64"
        sha256 "1670723caddf42367bb4a70af629f4e06fa6546ae13f997a8b806f55e8b90a72"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.22.1/tla-linux-amd64"
    sha256 "187260ee8522998143cfdb686b26d6719f2da37d08c9b746594aa8ef11843b64"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.22.1/tla-mcp-linux-amd64"
      sha256 "9fe7facb6dbc95d85bdffa45f81acf10ece4c9cbf953b141ee89541a9344be05"
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
