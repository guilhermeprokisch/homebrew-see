class See < Formula
  desc "A cute cat(1)"
  homepage "https://github.com/guilhermeprokisch/see"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/guilhermeprokisch/see/releases/download/v0.8.0/see-cat-aarch64-apple-darwin.tar.xz"
      sha256 "0291cef932e57f13c75ff09ba2329cf2d0d3834a6e4e63466a0abf0d93b79c02"
    end
    if Hardware::CPU.intel?
      url "https://github.com/guilhermeprokisch/see/releases/download/v0.8.0/see-cat-x86_64-apple-darwin.tar.xz"
      sha256 "2f1ca130ef4ffb5fe16030f48a7dd946795a8673df6492a43c66392e9abeefb0"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/guilhermeprokisch/see/releases/download/v0.8.0/see-cat-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "188b094b6987d8a74883f4e2408fe3f737daeee09ab642b68bc6a0c997ec061d"
  end
  license "MIT"

  depends_on "pcre2"

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
    bin.install "see" if OS.mac? && Hardware::CPU.arm?
    bin.install "see" if OS.mac? && Hardware::CPU.intel?
    bin.install "see" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
