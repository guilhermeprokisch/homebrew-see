class See < Formula
  desc "A cute cat(1)"
  homepage "https://github.com/guilhermeprokisch/see"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/guilhermeprokisch/see/releases/download/v0.7.1/see-cat-aarch64-apple-darwin.tar.xz"
      sha256 "02339dd8cf7664c21f8ae7f9a82e991fd0688701705488b9fcc41a86dd895d3d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/guilhermeprokisch/see/releases/download/v0.7.1/see-cat-x86_64-apple-darwin.tar.xz"
      sha256 "99f6efbfd37ec1346d93c98b44c1396a65934310afe56ddd7e4ccebc739a4c40"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/guilhermeprokisch/see/releases/download/v0.7.1/see-cat-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "44b465a56e1457084419e156be365053679effc46f2363116e6e65e3c4103292"
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
