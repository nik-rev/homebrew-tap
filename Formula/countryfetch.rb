class Countryfetch < Formula
  desc "A Command-line tool similar to Neofetch for obtaining information about your country"
  homepage "https://github.com/nik-rev/countryfetch"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nik-rev/countryfetch/releases/download/v0.1.5/countryfetch-aarch64-apple-darwin.tar.xz"
      sha256 "9efc0e0d8491981839f543af60995cc442399a2eca6628578c182e4523f16ed0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik-rev/countryfetch/releases/download/v0.1.5/countryfetch-x86_64-apple-darwin.tar.xz"
      sha256 "d58f556309c33835bba5d0d360a1be930e2fa0c85bc451aa572993a4f2c0ac14"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/nik-rev/countryfetch/releases/download/v0.1.5/countryfetch-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "0ab5983e3b95d869d5f941b4fe56e69c8506220e59a6512d058cb840ac2e6dc8"
  end
  license "MIT"

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
    bin.install "countryfetch" if OS.mac? && Hardware::CPU.arm?
    bin.install "countryfetch" if OS.mac? && Hardware::CPU.intel?
    bin.install "countryfetch" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
