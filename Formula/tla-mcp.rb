class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.11.1"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.11.1/tla-macos-arm64"
      sha256 "11fbbca865e030fa0a6e0182ced339d911a9581ebe1f0e092834955b16f34d5a"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.11.1/tla-mcp-macos-arm64"
        sha256 "66394e90813ff14aaf343bc0a96ba4f8c7206c37a836355beceb11de29955dfe"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.11.1/tla-macos-amd64"
      sha256 "d6d5898ed46b9dd9a5399b441d1a13aab9cf1fa91ea111ef6b992ea6310cb5bc"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.11.1/tla-mcp-macos-amd64"
        sha256 "e56ca773303703fa336a368567aa71741c94a00e43158be51e918acf6e81a197"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.11.1/tla-linux-amd64"
    sha256 "a1a156e90cc0f9a17431fefd1e1a38818d5ee5ef38bbdec06d2c3197b164f588"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.11.1/tla-mcp-linux-amd64"
      sha256 "878e40535f132ab7a96199428d93244e3212bee83d13334fbb1c91cafa4aa2a5"
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
