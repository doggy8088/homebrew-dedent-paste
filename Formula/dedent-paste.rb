class DedentPaste < Formula
  desc "Paste clipboard text with common indentation removed"
  homepage "https://dedent-paste.gh.miniasp.com/"
  version "0.6.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.6.2/dedent-paste-aarch64-apple-darwin.tar.xz"
      sha256 "e5889d7447780fa21392a0156c0bd99dda79a88a689f4a1d7243cbe15d4f17ea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.6.2/dedent-paste-x86_64-apple-darwin.tar.xz"
      sha256 "dd3dce9ec27bd389d882b81a802a20934474b62eb37518e9c37df959aa702f4d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.6.2/dedent-paste-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d608423adf233f2dc6e88cfd71923ce0ec2657b36f491a429e48f2d94255998f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.6.2/dedent-paste-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "193efc8b47cbded3b27bfd5b299e50cfdb5fe1b7f79f72adddb4253d4103f5a7"
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
