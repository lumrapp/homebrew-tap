class Lumr < Formula
  desc "System intelligence for software teams."
  homepage "https://lumr.app"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lumrapp/lumr-cli/releases/download/v0.4.1/lumr-cli-aarch64-apple-darwin.tar.xz"
      sha256 "7a041cbf0e67c881edec49d16fd5ca7ace5f4075ddd4b962cf9c8c2bd126e5b2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lumrapp/lumr-cli/releases/download/v0.4.1/lumr-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a2fa724c3d78fba470d176527b27fd24f9569d0be0a44ea6c0823e58f78009fa"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/lumrapp/lumr-cli/releases/download/v0.4.1/lumr-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "59fb679a6d5bd4fdc78bf38d7d8080a467642fa5e99516a6600a7b0d33fcaefe"
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
