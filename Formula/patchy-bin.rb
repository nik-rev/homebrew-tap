class PatchyBin < Formula
  desc "A tool which makes it easy to declaratively manage personal forks by automatically merging pull requests"
  homepage "https://github.com/NikitaRevenco/patchy"
  version "1.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/NikitaRevenco/patchy/releases/download/v1.1.4/patchy-bin-aarch64-apple-darwin.tar.xz"
      sha256 "72e542203ecf4441e58ccf42f618c5b3890a0622bb55fc2e12e7ad37be7d67a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/NikitaRevenco/patchy/releases/download/v1.1.4/patchy-bin-x86_64-apple-darwin.tar.xz"
      sha256 "9762eaecc1c9c5cb98317d3dfe278306ed1400d4b12e20f246e202afddea7d61"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/NikitaRevenco/patchy/releases/download/v1.1.4/patchy-bin-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1ee4a5e52d9f30a0eb546c9e7d03d1fa287d40d7a063a6586978c300fef77e37"
    end
    if Hardware::CPU.intel?
      url "https://github.com/NikitaRevenco/patchy/releases/download/v1.1.4/patchy-bin-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b31ac34e4bc96e5f02239c2f1c62ce59b8b08302ce626aaeb7037ecdaeea9720"
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
