class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.12.0"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.12.0/tla-macos-arm64"
      sha256 "cf8227693def23cb8825ebcca21a1fda4336865d48eb37076c8e78577948dc38"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.12.0/tla-mcp-macos-arm64"
        sha256 "ac5381a906bbf5ab53f2299a7919813588bb8c51db5a838f2f0959299e9e4e10"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.12.0/tla-macos-amd64"
      sha256 "5fca54368cf47f7dcfac3762458720ac0273248f9d301be64cb9c45512ff01e9"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.12.0/tla-mcp-macos-amd64"
        sha256 "23022fdfe6f321451b71ceb016c5b7ca5ac5b5dcfb6bea6065f58a36a3deacf4"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.12.0/tla-linux-amd64"
    sha256 "934d09dc8944fefe5138b3ed48a7d19a8d02ba516da5378410fc743c70aabe4c"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.12.0/tla-mcp-linux-amd64"
      sha256 "4f12b560dc3b6677329f411bf6f3a80df6bacb61b7af092f09714716173e54c9"
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
