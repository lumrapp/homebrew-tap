class Lumr < Formula
  desc "System intelligence for software teams."
  homepage "https://lumr.app"
  version "0.6.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lumrapp/lumr-cli/releases/download/v0.6.10/lumr-cli-aarch64-apple-darwin.tar.xz"
      sha256 "5f356fc4a61a5645961682a107f850c8447ed16c57812c50ecec9be36d4b752f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lumrapp/lumr-cli/releases/download/v0.6.10/lumr-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c4d463052248dad6935ac4cb9f822c6162de4ad8d953e77a677fa171adae4a49"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/lumrapp/lumr-cli/releases/download/v0.6.10/lumr-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "56aad104d664e1130b8072fa5daed6c7d19e30afdcbcfb7e7bd7317ff5e6aa95"
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
