class PatchyBin < Formula
  desc "A tool which makes it easy to declaratively manage personal forks by automatically merging pull requests"
  homepage "https://github.com/NikitaRevenco/patchy"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/NikitaRevenco/patchy/releases/download/v1.2.0/patchy-bin-aarch64-apple-darwin.tar.xz"
      sha256 "0b540712ed492863e3e7d466c8a77eb87c8eea6fff598ca5367a9551f5c829ef"
    end
    if Hardware::CPU.intel?
      url "https://github.com/NikitaRevenco/patchy/releases/download/v1.2.0/patchy-bin-x86_64-apple-darwin.tar.xz"
      sha256 "ae6f366967d0c35d652db1ec47e7939b65368da0055479af3c3c3ea9cfae3b0b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/NikitaRevenco/patchy/releases/download/v1.2.0/patchy-bin-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "42892dd145125c7cbf91d0fb1ed15f9dd67b5e4772973a8780d7a8b5411ed9fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/NikitaRevenco/patchy/releases/download/v1.2.0/patchy-bin-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8c671e67aa490e40bc2a6af2c67776a72d9fe00ce7a8df00851c451a9a66cc62"
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
