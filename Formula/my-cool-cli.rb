class MyCoolCli < Formula
  desc "My experimental Rust CLI tool"
  homepage "https://github.com/schaudhary2k/my-cool-cli"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/schaudhary2k/my-cool-cli/releases/download/v0.1.7/my-cool-cli-aarch64-apple-darwin.tar.xz"
      sha256 "559f83294afb2ef9da1927a14381c754df743cdbffc4fdc1b2ed3d2c59fca187"
    end
    if Hardware::CPU.intel?
      url "https://github.com/schaudhary2k/my-cool-cli/releases/download/v0.1.7/my-cool-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ed57609f78de6e5bddc6e90278fe0fb1378557b38d3e325e246ac27fa34ed01f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/schaudhary2k/my-cool-cli/releases/download/v0.1.7/my-cool-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aceaccf8901a5e84bbecd304f57af323e81f5f4325409ac29ffdf4467b71128d"
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
