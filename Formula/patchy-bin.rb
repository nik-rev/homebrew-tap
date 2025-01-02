class PatchyBin < Formula
  desc "A tool which makes it easy to declaratively manage personal forks by automatically merging pull requests"
  homepage "https://github.com/NikitaRevenco/patchy"
  version "1.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/NikitaRevenco/patchy/releases/download/v1.1.5/patchy-bin-aarch64-apple-darwin.tar.xz"
      sha256 "604da3464be9c1ef62f493f9cd14d51bb96912f563c4efbbec9185d64f4cdc72"
    end
    if Hardware::CPU.intel?
      url "https://github.com/NikitaRevenco/patchy/releases/download/v1.1.5/patchy-bin-x86_64-apple-darwin.tar.xz"
      sha256 "d0a69e85273f8a0aeed4f4ab51d8fc454f0339479e99071907d685161854cd8d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/NikitaRevenco/patchy/releases/download/v1.1.5/patchy-bin-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f2909713e542c68d36afe272d5dbad128064afe64d85b3f21498ff3856350e4e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/NikitaRevenco/patchy/releases/download/v1.1.5/patchy-bin-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2260e1f3d86bb5a361df255fb3e9128afc1509bcadd7d929965a3597de419bbf"
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
