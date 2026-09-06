class DedentPaste < Formula
  desc "Paste clipboard text with common indentation removed"
  homepage "https://dedent-paste.gh.miniasp.com/"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.5.1/dedent-paste-aarch64-apple-darwin.tar.xz"
      sha256 "e0626e24471523ac35196f9d196cacff310d56b874cc8ec154d4a5e17829266d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.5.1/dedent-paste-x86_64-apple-darwin.tar.xz"
      sha256 "2082c4e001b6a44ce0d1468022ce03486bafecdfdcbabe4d96be39cb4056ea58"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.5.1/dedent-paste-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e642d91264d0bd572ba5fd77b68b34f01be1c286dfbf8c3ca92d80ff0a2c4f43"
    end
    if Hardware::CPU.intel?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.5.1/dedent-paste-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e35c3c4b74c233d17c3426f20d340a6cdb80d653f804f9b9fabde6a2223abc38"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
      bin.install "dedent-paste"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "dedent-paste"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "dedent-paste"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "dedent-paste"
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
