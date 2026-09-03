class Lumr < Formula
  desc "System intelligence for software teams."
  homepage "https://lumr.app"
  version "0.5.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lumrapp/lumr-cli/releases/download/v0.5.4/lumr-cli-aarch64-apple-darwin.tar.xz"
      sha256 "3bdadf51286ae1bab6ef825559ec0cd1a47583aa85940d9aea7f969402a511c6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lumrapp/lumr-cli/releases/download/v0.5.4/lumr-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ecd4869db8b8d2821cad72894863dcc1daee0c4b2c93f90cff8e981d43e25155"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/lumrapp/lumr-cli/releases/download/v0.5.4/lumr-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "5124ab0c8ff29e659a8bebb6c632dc2ddbd0f7073a21283afc5b4f04e936d5f2"
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
