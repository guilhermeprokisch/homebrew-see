class See < Formula
  desc "A cute cat(1)"
  homepage "https://github.com/guilhermeprokisch/see"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/guilhermeprokisch/see/releases/download/v0.5.0/see-cat-aarch64-apple-darwin.tar.xz"
      sha256 "7998f3424be9cb2069fac72c1efb5d1e78854e8ae7e3df4d9fe63d234eb91325"
    end
    if Hardware::CPU.intel?
      url "https://github.com/guilhermeprokisch/see/releases/download/v0.5.0/see-cat-x86_64-apple-darwin.tar.xz"
      sha256 "099f48aa637fceeb1eb2503ba8bb9875300adb0807da0255ce201b35d766b6de"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/guilhermeprokisch/see/releases/download/v0.5.0/see-cat-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "7823de76c26c2528aeb5823a0eb33d8b6b8ee3bf87fa944834c4afa520370179"
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
