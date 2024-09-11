class See < Formula
  desc "A cute cat(1)"
  homepage "https://github.com/guilhermeprokisch/see"
  version "0.5.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/guilhermeprokisch/see/releases/download/v0.5.2/see-cat-aarch64-apple-darwin.tar.xz"
      sha256 "d586ade6c46f1c18276e75a71773e655b80d81bff4a818f780d8345fffa4ea8f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/guilhermeprokisch/see/releases/download/v0.5.2/see-cat-x86_64-apple-darwin.tar.xz"
      sha256 "28b945bd4f583ee61e3a95e99dcbf7e962008dbc86751c2046d778400c69fd23"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/guilhermeprokisch/see/releases/download/v0.5.2/see-cat-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "06986b0160edf2b6140c6536f44251a64a2bc01e81e1b35fe64b42e9bd10aa23"
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
