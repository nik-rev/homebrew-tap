class PatchyBin < Formula
  desc "A tool which makes it easy to declaratively manage personal forks by automatically merging pull requests"
  homepage "https://github.com/nik-rev/patchy"
  version "1.2.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nik-rev/patchy/releases/download/v1.2.6/patchy-bin-aarch64-apple-darwin.tar.xz"
      sha256 "52d4b78f28e80be255a98e63a9175f30049174c1e2c7a59f56cdc9aaa145b863"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik-rev/patchy/releases/download/v1.2.6/patchy-bin-x86_64-apple-darwin.tar.xz"
      sha256 "4917d39e84acd0cc2edef72067aff0614ee19c63dddf3337781da38589f5ffaa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nik-rev/patchy/releases/download/v1.2.6/patchy-bin-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "abfe311463b893e3802f0c26e6c1d1ec50c4aa045b6a35a8c627b6058471b5a4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik-rev/patchy/releases/download/v1.2.6/patchy-bin-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dbfaa84d5e524b1536c4d25c662df61ac9b59f0114c6706535be8e4264d3c6c7"
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
