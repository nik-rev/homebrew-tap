class Countryfetch < Formula
  desc "A Command-line tool similar to Neofetch for obtaining information about your country"
  homepage "https://github.com/nik-rev/countryfetch"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nik-rev/countryfetch/releases/download/v0.1.8/countryfetch-aarch64-apple-darwin.tar.xz"
      sha256 "314d14a17de447b1979ac57e70eb3e5874aaee37e819784bc758da08e7e4b53f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik-rev/countryfetch/releases/download/v0.1.8/countryfetch-x86_64-apple-darwin.tar.xz"
      sha256 "3dfc05d3f2c848c62f69c973da82bae37be04561993a61001765c63b230a1bb7"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/nik-rev/countryfetch/releases/download/v0.1.8/countryfetch-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "5fc693cf8510b0bba534f5bd8120cde83f954b758112c21875018a66ac4290ab"
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
