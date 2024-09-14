class See < Formula
  desc "A cute cat(1)"
  homepage "https://github.com/guilhermeprokisch/see"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/guilhermeprokisch/see/releases/download/v0.8.1/see-cat-aarch64-apple-darwin.tar.xz"
      sha256 "86670e859d37b6d7f7ec7707c5c0d13e392f0a3616abc39899b052e9fd73d1a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/guilhermeprokisch/see/releases/download/v0.8.1/see-cat-x86_64-apple-darwin.tar.xz"
      sha256 "db11714d1024c07b98415d323caaf9a1bf5ca572447400127cf844dd626ec2b9"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/guilhermeprokisch/see/releases/download/v0.8.1/see-cat-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f79c7bb8154509ba9981a6034420e93733ce000437095178149bdb74ae72a088"
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
