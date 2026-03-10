class MyCoolCli < Formula
  desc "My experimental Rust CLI tool"
  homepage "https://github.com/schaudhary2k/my-cool-cli"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/schaudhary2k/my-cool-cli/releases/download/v0.1.8/my-cool-cli-aarch64-apple-darwin.tar.xz"
      sha256 "51cfe7980e4b1e13c8bc8df91c99dd0c5102e35b9d35c64af97d2fd20d564b92"
    end
    if Hardware::CPU.intel?
      url "https://github.com/schaudhary2k/my-cool-cli/releases/download/v0.1.8/my-cool-cli-x86_64-apple-darwin.tar.xz"
      sha256 "e768a9287d47c7356110820df356b734348489f16fc31ab8f1503efe6d01d2aa"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/schaudhary2k/my-cool-cli/releases/download/v0.1.8/my-cool-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "34705df1a8e916519d66e9dae38fb55135c53ccb746457d73d22dae16af27f94"
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
