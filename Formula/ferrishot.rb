class Ferrishot < Formula
  desc "A cross-platform desktop screenshot app"
  homepage "https://github.com/nik-rev/ferrishot"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nik-rev/ferrishot/releases/download/v0.1.0/ferrishot-aarch64-apple-darwin.tar.xz"
      sha256 "ece0c2379b4564e96c5a033be469a6207f94019ff69744dee7e0d7b468be0689"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik-rev/ferrishot/releases/download/v0.1.0/ferrishot-x86_64-apple-darwin.tar.xz"
      sha256 "0056576608375d9d05307bd4b45f98955db4b7ac990930251c29e2835b3ca66b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/nik-rev/ferrishot/releases/download/v0.1.0/ferrishot-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "3d4b18b4d3c8913afbf6b68ba897eb68e219e101cf5fe749cff822f04e90691b"
  end
  license any_of: ["MIT", "Apache-2.0"]

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
    bin.install "ferrishot" if OS.mac? && Hardware::CPU.arm?
    bin.install "ferrishot" if OS.mac? && Hardware::CPU.intel?
    bin.install "ferrishot" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
