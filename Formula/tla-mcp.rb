class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.24.11"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.11/tla-macos-arm64"
      sha256 "bcec45ce24c6ad3eaf515ec7fac5fb07f5e05f4e472032d4d4f5bc0d2599a402"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.24.11/tla-mcp-macos-arm64"
        sha256 "9dfefa57380fd8679c8ea836d140b19ad06aa7c77a667a178dfcb1985b36d953"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.11/tla-macos-amd64"
      sha256 "ef32b07e61c21a8f21906d8a8ffe2cb81ece71d55a2fd46f825a7b2c1d6879b5"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.24.11/tla-mcp-macos-amd64"
        sha256 "4825054f6040e7fb093c574ed60105f687b8d5ba358e9dc32bb909be36a41045"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.24.11/tla-linux-amd64"
    sha256 "89fb6d988160e40b8c14f45bf05f1502bdb145e4c446b86278a8262130dbe7b3"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.11/tla-mcp-linux-amd64"
      sha256 "2afa5d7629cd5c5d09403dff52c808aea9995a4cb3a29647a46aca7b25ffd27e"
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
