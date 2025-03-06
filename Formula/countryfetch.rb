class Countryfetch < Formula
  desc "A Command-line tool similar to Neofetch for obtaining information about your country"
  homepage "https://github.com/nik-rev/countryfetch"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nik-rev/countryfetch/releases/download/v0.1.6/countryfetch-aarch64-apple-darwin.tar.xz"
      sha256 "fc02473c632366f7536e2cc2e47879ea4ee6be5f5d16535c7394e814362a1df0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik-rev/countryfetch/releases/download/v0.1.6/countryfetch-x86_64-apple-darwin.tar.xz"
      sha256 "7e2ab886d793079919896c55be138b3b16461ccafece8b917cefa019ccd72642"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/nik-rev/countryfetch/releases/download/v0.1.6/countryfetch-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "24cd0b0c13e140ec5311ede25a1479bc4c60babe4078bc11979952345596d0e5"
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
