class Countryfetch < Formula
  desc "A Command-line tool similar to Neofetch for obtaining information about your country"
  homepage "https://github.com/nik-rev/countryfetch"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nik-rev/countryfetch/releases/download/v0.1.7/countryfetch-aarch64-apple-darwin.tar.xz"
      sha256 "5b7416448642ffa6663e59469b31417ba552296932952f4972150a440b3957c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik-rev/countryfetch/releases/download/v0.1.7/countryfetch-x86_64-apple-darwin.tar.xz"
      sha256 "b963c5dc4a76a5bbb354cef92653d23f6257733ef8e3e2228c52004da44963bc"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/nik-rev/countryfetch/releases/download/v0.1.7/countryfetch-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "26be94a07a7924223c47ddf9b42610ee4a9f0d7f10cae0d0a4a62eaca20072ef"
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
