class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.24.0"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.0/tla-macos-arm64"
      sha256 "ced466b59d2dd093265d666164e3b3675f879f7f6f08b5e1627d3dc050fc7ca8"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.24.0/tla-mcp-macos-arm64"
        sha256 "3c66400b7cfae308ea232a8a614b4a4fecdb279530dcf47164c100cfd0fdfd93"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.0/tla-macos-amd64"
      sha256 "39994c22d2749a785b2c22eeea5c3a4b71ff7ade7bfeb47c38f251f61182b856"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.24.0/tla-mcp-macos-amd64"
        sha256 "e2a3452c3e139af7d8fd8edd6bd96a29f35fe941e2013d19e22acc1cd11fabf7"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.24.0/tla-linux-amd64"
    sha256 "912218d1809f75b125314292a463660b675356c59d9ba2c03c6a8e99d9805ca6"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.24.0/tla-mcp-linux-amd64"
      sha256 "cb6fb7af4655c2c6bb713712794ba2d4a2ad1415d72111b6e3e608c622f81781"
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
