class PatchyBin < Formula
  desc "A tool which makes it easy to declaratively manage personal forks by automatically merging pull requests"
  homepage "https://github.com/NikitaRevenco/patchy"
  version "1.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/NikitaRevenco/patchy/releases/download/v1.2.2/patchy-bin-aarch64-apple-darwin.tar.xz"
      sha256 "74cbbf165bddd471ae50e69b9109c07285f03bffee3c20aaad0c262a3eaeafdc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/NikitaRevenco/patchy/releases/download/v1.2.2/patchy-bin-x86_64-apple-darwin.tar.xz"
      sha256 "ab8d7a8fb93ded28cd369b75135ef238f7f4b07da772999a2e756149bd6844f0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/NikitaRevenco/patchy/releases/download/v1.2.2/patchy-bin-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2cf6caa952b85c890e3f96dc2973556f347f6cbce1a4e20f0692109822fb2573"
    end
    if Hardware::CPU.intel?
      url "https://github.com/NikitaRevenco/patchy/releases/download/v1.2.2/patchy-bin-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "05d26286b8ad3b6e46641bd8d139ecd138e6f1e8e744012a4f222b1c154cde92"
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
