class Dots < Formula
  desc "A cozy, simple-to-use dotfiles manager"
  homepage "https://github.com/nik-rev/dots"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nik-rev/dots/releases/download/v0.2.1/dots-bin-aarch64-apple-darwin.tar.xz"
      sha256 "d9ea4c65c583a45bebff19c2b95b5b166c8803f9e28acc5c3a45a095d82e9ef0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik-rev/dots/releases/download/v0.2.1/dots-bin-x86_64-apple-darwin.tar.xz"
      sha256 "7ea8273385d17d8e5ee9626cc2534266ad003f46d1311157d6b6d04df198652a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nik-rev/dots/releases/download/v0.2.1/dots-bin-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9c8f41551029a3e2753453036cff19cf86012dda5d96341c3432b9dec46de08d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik-rev/dots/releases/download/v0.2.1/dots-bin-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f7c74e8f327cc1240fa8b773c41df764dd276e4b84a72e9503e6bad4cbcd7211"
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
