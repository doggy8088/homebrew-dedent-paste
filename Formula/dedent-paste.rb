class DedentPaste < Formula
  desc "Paste clipboard text with common indentation removed"
  homepage "https://dedent-paste.gh.miniasp.com/"
  version "0.6.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.6.4/dedent-paste-aarch64-apple-darwin.tar.xz"
      sha256 "36b6be57d64b62cb34ee015620dc3f794d1781be73346a20ed8c7a2c4526913c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.6.4/dedent-paste-x86_64-apple-darwin.tar.xz"
      sha256 "11d2fa6fab2634d52b26ea159c9225b682d6f9a0aa87f17afd6dff0a8cc8b259"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.6.4/dedent-paste-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "11709fca74fa06e62338af0c9452b1335d0c8dc33356783597820a855773932e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.6.4/dedent-paste-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "54c38fb22c31051758affdba250f8f53b58300c44de0751de505e6e291f7c7ab"
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
