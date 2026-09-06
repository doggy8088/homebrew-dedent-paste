class DedentPaste < Formula
  desc "Paste clipboard text with common indentation removed"
  homepage "https://dedent-paste.gh.miniasp.com/"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.4.0/dedent-paste-aarch64-apple-darwin.tar.xz"
      sha256 "ac26b871277c99215e45d33967b1df5acea9d27baf92d27737b1b0743104bf34"
    end
    if Hardware::CPU.intel?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.4.0/dedent-paste-x86_64-apple-darwin.tar.xz"
      sha256 "142e7ee9e1ae2c2429e2de0a680fb4d6fa1836675dcaff282845a464153cf8f1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.4.0/dedent-paste-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6ea37a3c6c99aba81df37bd469ecd77125ec8c05a921fedf8bd9a062f08d13f4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.4.0/dedent-paste-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "05feafc956deed74f05989db60e286c69409c22e1919f51990f5691351aa399c"
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

  def caveats
    <<~EOS
      dedent-paste is installed, but the Option+V hotkey is NOT set up yet.

      1. Install Karabiner-Elements if you have not already:
           brew install --cask karabiner-elements
      2. Register the Option+V rule (your Karabiner profile is backed up first):
           dedent-paste --install
      3. Allow Karabiner-Elements under
           System Settings > Privacy & Security > Accessibility

      To remove the rule later:
           dedent-paste --uninstall
    EOS
  end
end
