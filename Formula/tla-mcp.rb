class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.9.5"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.9.5/tla-macos-arm64"
      sha256 "f5e75a4b1878284c428901914e5615eb97782fcd137767fc24737287e376f09e"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.9.5/tla-mcp-macos-arm64"
        sha256 "00bf5e9731fa7c312b51c430825faf62cada3bc97063ac63557f03a3bfbaa55b"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.9.5/tla-macos-amd64"
      sha256 "4ba91ce4377dc5c4f765e0f02e7dac759529e1b23459980945f26d7c5c06bf92"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.9.5/tla-mcp-macos-amd64"
        sha256 "c02b3ae1c6a04555b207733e6f72f8ce5a0d68ba90387fc5f62f26160a70a847"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.9.5/tla-linux-amd64"
    sha256 "585fb4902490274fb45b2a8d10d8171c9c0647e6ca5330a20767f3ec49301071"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.9.5/tla-mcp-linux-amd64"
      sha256 "5313929e771991bcad578feb5885e040e57a100f975eefee68ab06817cfe3875"
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
