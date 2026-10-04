class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.17.1"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.17.1/tla-macos-arm64"
      sha256 "6e5c20613585d546b833350cefcfd61012aa649766c8d1b0b8446e49b1b2c2ae"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.17.1/tla-mcp-macos-arm64"
        sha256 "76d5df14d0d84a4261d13ab429bd24d50f4fb81f7901848c0cdf2ff6ee1d3158"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.17.1/tla-macos-amd64"
      sha256 "08eda3f6d528d87c42909e60f71d41f5e5d0f35a3fd99f369dfcfd1ad1906d24"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.17.1/tla-mcp-macos-amd64"
        sha256 "6ebb89598f77dc561b43933d2d95854325fa8ae42da3f22553009ce58eb8edc9"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.17.1/tla-linux-amd64"
    sha256 "f6966e4aa8f256e2720a5d05356eb6636bd68d50c0c9ddf30dc59c3dfbae0fba"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.17.1/tla-mcp-linux-amd64"
      sha256 "a30e36d5fdba720a10569250e4f4a4cb6fd52d92233fa4eef900690b187e092c"
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
