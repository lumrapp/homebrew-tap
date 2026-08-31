class Lumr < Formula
  desc "System intelligence for software teams."
  homepage "https://lumr.app"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lumrapp/lumr-cli/releases/download/v0.5.0/lumr-cli-aarch64-apple-darwin.tar.xz"
      sha256 "308e79925c0185bb6baecacc53ea2140c0ef45dda4539ad7e084eb62146fa3f6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lumrapp/lumr-cli/releases/download/v0.5.0/lumr-cli-x86_64-apple-darwin.tar.xz"
      sha256 "888733594c292bfe4a52a95e12ebfb26879887bde989cdaadc1fc18c99e4676a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/lumrapp/lumr-cli/releases/download/v0.5.0/lumr-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "3aacb050f29909b34ecbea75ce51362d71df72ce7abaea94aa3eac9ccc793f73"
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
