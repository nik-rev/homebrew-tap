class Lumina < Formula
  desc "A program to read and control device brightness"
  homepage "https://github.com/nik-rev/lumina"
  version "0.1.0"
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/nik-rev/lumina/releases/download/v0.1.0/lumina-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "29a0900134abe06db92bd1bbcb24bb2588ff2a4d0484bb6185a76ee49fa88a69"
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
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
    bin.install "lumina" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
