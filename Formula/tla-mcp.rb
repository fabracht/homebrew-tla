class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.24.3"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.3/tla-macos-arm64"
      sha256 "e0948d14066f6a18baa56924b1c7a0fad65f6a063719585cc69b130819de1028"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.24.3/tla-mcp-macos-arm64"
        sha256 "f924fef890f5d9adb2bd7e6efd853cff3b5fc5b8726fadbba92457fddf35c8e8"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.3/tla-macos-amd64"
      sha256 "f9ecc27065227a8bf9c67c737ab6ea622cd73c12f8a29dc143406629e7045c08"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.24.3/tla-mcp-macos-amd64"
        sha256 "607e08a3d5f16dcc2818b7c7553db44770aa37d91b9ccbe77b3c7bd3152a941a"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.24.3/tla-linux-amd64"
    sha256 "17a09817691ab3b09e74804add347e2d70790ec0c439c92119c0ea3e962e51ea"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.3/tla-mcp-linux-amd64"
      sha256 "a5a40135e9adf2b79328248784e02d972b5690ae321e8179c1483ad2c0cb2ffd"
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
