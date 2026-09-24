class TlaMcp < Formula
  desc "TLA+ model checker (tla) and MCP server (tla-mcp)"
  homepage "https://github.com/fabracht/tla-rs"
  version "0.10.1"
  license "MIT OR Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.10.1/tla-macos-arm64"
      sha256 "e806534e56360bfd26e2362c9753cf6a85d41f0b71f67ccb39e992f1535b193c"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.10.1/tla-mcp-macos-arm64"
        sha256 "f50446a20101bc471f9bdcfc4126f77afb340144f53d9d76d7794ab5e3993e08"
      end
    end
    on_intel do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.10.1/tla-macos-amd64"
      sha256 "2b93e2eb1db26ff3741b8e6eba154b222a204c73dd65a34bcd827d0995e70250"

      resource "tla-mcp-bin" do
        url "https://github.com/fabracht/tla-rs/releases/download/v0.10.1/tla-mcp-macos-amd64"
        sha256 "2623b1881000758411140ed1e96096b092564035bce4f54e882c42682c014eaf"
      end
    end
  end

  on_linux do
    url "https://github.com/fabracht/tla-rs/releases/download/v0.10.1/tla-linux-amd64"
    sha256 "5bf228bf6b3c93930afc18c429aae3438ceb5094ee0716e603fee2a514e234b6"

    resource "tla-mcp-bin" do
      url "https://github.com/fabracht/tla-rs/releases/download/v0.10.1/tla-mcp-linux-amd64"
      sha256 "f6fee99bd151ce32711176fa6ddb1a035b78fcbfbe6a85403d448acb99da3b22"
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
