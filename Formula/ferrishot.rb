class Ferrishot < Formula
  desc "A cross-platform desktop screenshot app"
  homepage "https://github.com/nik-rev/ferrishot"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nik-rev/ferrishot/releases/download/v0.2.0/ferrishot-aarch64-apple-darwin.tar.xz"
      sha256 "c19f3a8a571109d18a6038b72130dbfb5953fea6e42376d50e58a1933fca412d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik-rev/ferrishot/releases/download/v0.2.0/ferrishot-x86_64-apple-darwin.tar.xz"
      sha256 "50e878be28f3b43d7c995f20439e0b2c5ab9b526cfebcf6a48f821ac9a73b8cc"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/nik-rev/ferrishot/releases/download/v0.2.0/ferrishot-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "b4befbdaeca03e7881985b9568f717631f2a4216bc17f778de8bc64f1f7d241b"
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
