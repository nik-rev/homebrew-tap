class PatchyBin < Formula
  desc "A tool which makes it easy to declaratively manage personal forks by automatically merging pull requests"
  homepage "https://github.com/nik-rev/patchy"
  version "1.2.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nik-rev/patchy/releases/download/v1.2.7/patchy-bin-aarch64-apple-darwin.tar.xz"
      sha256 "b3d499c38fd1eb0761fa61b0beb1237eb4475e6a1e9f245bb2d94f9dc57e71ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik-rev/patchy/releases/download/v1.2.7/patchy-bin-x86_64-apple-darwin.tar.xz"
      sha256 "6a56fc1852003f42c6db54b8ea523fe46529da50b8d3fd2ec0126e1dce1db3b9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nik-rev/patchy/releases/download/v1.2.7/patchy-bin-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c5b6b3b2f60a72a1796d147105403919628645558ae8d4d9e03cca0445ea91f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik-rev/patchy/releases/download/v1.2.7/patchy-bin-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4bf7a043b06d6d9b8c58f8fa5fbf2ad863d7aedee6ade5ebb1d98c4f6e52f6a8"
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
