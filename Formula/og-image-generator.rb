class OgImageGenerator < Formula
  desc "Pain-free OpenGraph image generation using HTML and CSS for your blog"
  homepage "https://github.com/nik-rev/og-image-generator"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nik-rev/og-image-generator/releases/download/v0.2.0/og-image-generator-aarch64-apple-darwin.tar.xz"
      sha256 "30256ce925af489b14441d09fa01ff8584e9196118368b2c3d4237b5015f29b4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nik-rev/og-image-generator/releases/download/v0.2.0/og-image-generator-x86_64-apple-darwin.tar.xz"
      sha256 "79109c23d01eb9d4335d58f8417b4f3a9bf571229938f153daa4908e3c07e803"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/nik-rev/og-image-generator/releases/download/v0.2.0/og-image-generator-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "88085adfd499c2876037c3036ced9f03b4dc3be5d9f49055e4b4399b85af6493"
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
