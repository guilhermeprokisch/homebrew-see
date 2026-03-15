class See < Formula
  desc "A cute cat(1)"
  homepage "https://github.com/guilhermeprokisch/see"
  version "0.9.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/guilhermeprokisch/see/releases/download/v0.9.1/see-cat-aarch64-apple-darwin.tar.xz"
      sha256 "c3d74bce75fe7c0d3d5a4dfa2b82d50eb577fee5d5baee2a72b7016fdd05371e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/guilhermeprokisch/see/releases/download/v0.9.1/see-cat-x86_64-apple-darwin.tar.xz"
      sha256 "ef621b9efef74e8a270726085917bd53c5daad2c335d3293c8cc42b3b40a101a"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/guilhermeprokisch/see/releases/download/v0.9.1/see-cat-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ba3f72a760d7ddef436c115765df88156d23782fd88efd314256ec61c6940564"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "see"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "see"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "see"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
