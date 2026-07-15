class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.6.10"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.6.10/tla-macos-arm64"
      sha256 "40aa7218531b725a0de6761dfc60f1ef2172dde3bd9593cfa1ed4271b859a6f7"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.6.10/tla-mcp-macos-arm64"
        sha256 "29b7b4cfba0a4203f669028821041607a949b91142328bc76dd884143864bd93"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.6.10/tla-macos-amd64"
      sha256 "59c6ecd276a90124cb3274219eaef9c6444246a3f9e27f77d35fd02ca2f58c68"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.6.10/tla-mcp-macos-amd64"
        sha256 "9fedcce622a016c8baff93ffe428e3547d50067b622fb9c2d6ad6d1b2d6b52f8"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.6.10/tla-linux-amd64"
    sha256 "f2faee1f68d89a2e213b19b9782783f11b442b2a589f7372fef40f75378c76a1"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.6.10/tla-mcp-linux-amd64"
      sha256 "731a0db8e1eae8a5ad66c3c37dfb88b3f19e266c5dceac33ff528ef88390fb43"
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
