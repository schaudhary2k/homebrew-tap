class MyCoolCli < Formula
  desc "My experimental Rust CLI tool"
  homepage "https://github.com/schaudhary2k/my-cool-cli"
  version "0.1.32"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/schaudhary2k/my-cool-cli/releases/download/v0.1.32/my-cool-cli-aarch64-apple-darwin.tar.xz"
      sha256 "63c3e32fc67a880f0370280d2a3a7acb13b5465db5265907f3c90bcd50adee1e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/schaudhary2k/my-cool-cli/releases/download/v0.1.32/my-cool-cli-x86_64-apple-darwin.tar.xz"
      sha256 "702d29cf75f863318d078253334cb22eb163cac418aa8d910b77e57a0fec7ab4"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/schaudhary2k/my-cool-cli/releases/download/v0.1.32/my-cool-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9a3b9babf0292a4c2afcc7d6ee21646a033024713f6327dd361c45a06d50eee9"
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
