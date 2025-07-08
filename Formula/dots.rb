class Dots < Formula
  desc "A cozy, simple-to-use dotfiles manager"
  homepage "https://github.com/nik-rev/dots"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nik-rev/dots/releases/download/v0.1.0/dots-aarch64-apple-darwin.tar.xz"
      sha256 "9ea26186e459711c104720acf6ab7e0df9c164a4015bcbd92fb5b4855081d32e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik-rev/dots/releases/download/v0.1.0/dots-x86_64-apple-darwin.tar.xz"
      sha256 "7c5424d8811ed733b1552ea3a8042fb14e7163d7243bf00853ccfdc779d46bcf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nik-rev/dots/releases/download/v0.1.0/dots-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9599f75d5b9ed13f76783408868ef8d792a4a6ffae93049c81f565a395560c85"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik-rev/dots/releases/download/v0.1.0/dots-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "95d9b03c5df946744b232618727420e5995b470b81dce4fac33b6c1235fa79ff"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

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
    bin.install "dots" if OS.mac? && Hardware::CPU.arm?
    bin.install "dots" if OS.mac? && Hardware::CPU.intel?
    bin.install "dots" if OS.linux? && Hardware::CPU.arm?
    bin.install "dots" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
