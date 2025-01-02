class Patchy < Formula
  desc "A tool which makes it easy to declaratively manage personal forks by automatically merging pull requests"
  homepage "https://github.com/NikitaRevenco/patchy"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/NikitaRevenco/patchy/releases/download/v1.1.0/patchy-aarch64-apple-darwin.tar.xz"
      sha256 "a6b07c3ebc75956703c0a838cb971275b620dc9b54babf9ac55d1d6eae9047aa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/NikitaRevenco/patchy/releases/download/v1.1.0/patchy-x86_64-apple-darwin.tar.xz"
      sha256 "61ae54e480b1e00973ba4840a97001031fe9bb4ed3063dc5a15bfe17504d7f05"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/NikitaRevenco/patchy/releases/download/v1.1.0/patchy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "69bc338e2a4ae2e9d1b41c9e4a659bdf176e960740361e96eea5a3aaa63921e0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/NikitaRevenco/patchy/releases/download/v1.1.0/patchy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8159335fdb8c5a44fbadd79f7aad4f04f63af8770f1def6a3c40bd74de626326"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "patchy" if OS.mac? && Hardware::CPU.arm?
    bin.install "patchy" if OS.mac? && Hardware::CPU.intel?
    bin.install "patchy" if OS.linux? && Hardware::CPU.arm?
    bin.install "patchy" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
