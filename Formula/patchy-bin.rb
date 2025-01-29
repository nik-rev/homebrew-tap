class PatchyBin < Formula
  desc "A tool which makes it easy to declaratively manage personal forks by automatically merging pull requests"
  homepage "https://github.com/nik-rev/patchy"
  version "1.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nik-rev/patchy/releases/download/v1.3.0/patchy-bin-aarch64-apple-darwin.tar.xz"
      sha256 "c3d233436ffbf91936df193b4aad3832ce52e8196952bbfec241ace6925292f8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik-rev/patchy/releases/download/v1.3.0/patchy-bin-x86_64-apple-darwin.tar.xz"
      sha256 "0a4fdd136ff5b78abff2c4e227b105a6020590cea661ca90b33b1ddeac6bb1bb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nik-rev/patchy/releases/download/v1.3.0/patchy-bin-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e8de9ed37d49cfc4f40dd4d0b11914bf849f3e92c471823ea2e4a9b9ec87da10"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik-rev/patchy/releases/download/v1.3.0/patchy-bin-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c617691593e538fb173482d62afe1bde24c968b13b3f48c845b8282830993f47"
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
