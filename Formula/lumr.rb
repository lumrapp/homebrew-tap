class Lumr < Formula
  desc "System intelligence for software teams."
  homepage "https://lumr.app"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lumrapp/lumr-cli/releases/download/v0.7.0/lumr-cli-aarch64-apple-darwin.tar.xz"
      sha256 "9baab3d53984071db7ddca5e32672725a2db40fa1fba1a6c6e9505f2ad70bab4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lumrapp/lumr-cli/releases/download/v0.7.0/lumr-cli-x86_64-apple-darwin.tar.xz"
      sha256 "e65a6de54f41451247c4c5be5f68cbcabffc5bb8bedaeb60cd42e47abd5b23fc"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/lumrapp/lumr-cli/releases/download/v0.7.0/lumr-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "5c8bf7a88fe1cb055a07efcc616c2b9aff80f355ae7313bcb799552ec81cb37d"
  end
  license "UNLICENSED"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "lumr"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "lumr"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "lumr"
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
