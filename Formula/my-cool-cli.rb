class MyCoolCli < Formula
  desc "My experimental Rust CLI tool"
  homepage "https://github.com/schaudhary2k/my-cool-cli"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/schaudhary2k/my-cool-cli/releases/download/v0.1.6/my-cool-cli-aarch64-apple-darwin.tar.xz"
      sha256 "7049d5110b843d3a4c53a59fb994bd6e326b32d043eefc043d87469fa65ff195"
    end
    if Hardware::CPU.intel?
      url "https://github.com/schaudhary2k/my-cool-cli/releases/download/v0.1.6/my-cool-cli-x86_64-apple-darwin.tar.xz"
      sha256 "d3cf61bbca4f0cc9255392fd80a99898b5cbf76976929ffd9e218230c6ed9f54"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/schaudhary2k/my-cool-cli/releases/download/v0.1.6/my-cool-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "917fe58bf65207cf23c7cd616e5df38669a09ec8ae413392cb088d84d5fdd66a"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "my-cool-cli" if OS.mac? && Hardware::CPU.arm?
    bin.install "my-cool-cli" if OS.mac? && Hardware::CPU.intel?
    bin.install "my-cool-cli" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
