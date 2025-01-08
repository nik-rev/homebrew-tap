class PatchyBin < Formula
  desc "A tool which makes it easy to declaratively manage personal forks by automatically merging pull requests"
  homepage "https://github.com/nik-rev/patchy"
  version "1.2.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nik-rev/patchy/releases/download/v1.2.5/patchy-bin-aarch64-apple-darwin.tar.xz"
      sha256 "3f854f9957c14e412b3a57372a6a133ce3fc87d48a4a551d360163e6774c8a61"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik-rev/patchy/releases/download/v1.2.5/patchy-bin-x86_64-apple-darwin.tar.xz"
      sha256 "f7582aff709a8eb02ae533e3e520d782902684b3f59383be13ff0aed9e44ebb9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nik-rev/patchy/releases/download/v1.2.5/patchy-bin-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "be02d876fafaf3b44b3eaec9dbad45357793bffc005de59f639696d15e917a0a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik-rev/patchy/releases/download/v1.2.5/patchy-bin-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8db86cbf17c5da379fab0b32ca87efc4920a880e0e30344b5c64c47b570d195a"
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
