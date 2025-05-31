class OgImageGenerator < Formula
  desc "Pain-free OpenGraph image generation using HTML and CSS for your blog"
  homepage "https://github.com/nik-rev/og-image-generator"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nik-rev/og-image-generator/releases/download/v0.1.0/og-image-generator-aarch64-apple-darwin.tar.xz"
      sha256 "ebc462fe6af75fa3ea16e2deb1abc4790c70399d262dbffbd7fcdcd33171966a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik-rev/og-image-generator/releases/download/v0.1.0/og-image-generator-x86_64-apple-darwin.tar.xz"
      sha256 "3ba56be042a37fc9e08abbfe50a7ef90b90acb5e6914c8cf96ba08136cd38b44"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/nik-rev/og-image-generator/releases/download/v0.1.0/og-image-generator-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "5f4cbb7436706c644a33b6bb3527df89891bd19ae55c79ada8877d6ae65be77c"
  end

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
    bin.install "og-image-generator" if OS.mac? && Hardware::CPU.arm?
    bin.install "og-image-generator" if OS.mac? && Hardware::CPU.intel?
    bin.install "og-image-generator" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
