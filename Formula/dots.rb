class Dots < Formula
  desc "A cozy, simple-to-use dotfiles manager"
  homepage "https://github.com/nik-rev/dots"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nik-rev/dots/releases/download/v0.2.0/dots-bin-aarch64-apple-darwin.tar.xz"
      sha256 "40f2fd2d220bbb2875735a3e312ec89869e9221be4a3697920eb9ba089d07734"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik-rev/dots/releases/download/v0.2.0/dots-bin-x86_64-apple-darwin.tar.xz"
      sha256 "ae9c5a4795186479ebeffe169a4e724b599791279b8088c981afeaccbb00779d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nik-rev/dots/releases/download/v0.2.0/dots-bin-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7e6003318cd38ffc498c6cab9c98389d86fc8138ce94d79de71c9df2df6353e7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik-rev/dots/releases/download/v0.2.0/dots-bin-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "44f6d142b6c3cc11d2f6c8e647d7ea8c639b74f7a9638a053382b47f8d64c7a1"
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
    bin.install "dots-bin" if OS.mac? && Hardware::CPU.arm?
    bin.install "dots-bin" if OS.mac? && Hardware::CPU.intel?
    bin.install "dots-bin" if OS.linux? && Hardware::CPU.arm?
    bin.install "dots-bin" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
