class BrightnessCli < Formula
  desc "A program to read and control device brightness"
  homepage "https://github.com/nik-rev/brightness-cli"
  version "0.1.2"
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/nik-rev/brightness-cli/releases/download/v0.1.2/brightness-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "7f9a1d3965c68646d4bce3d8d9c8dec5394cd3544e9b568657e5a3dd8bf55e77"
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
    bin.install "brightness-cli" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
