class DedentPaste < Formula
  desc "Paste clipboard text with common indentation removed"
  homepage "https://dedent-paste.gh.miniasp.com/"
  version "0.5.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.5.4/dedent-paste-aarch64-apple-darwin.tar.xz"
      sha256 "e1f261bc03d75c580d11ec8bd6761ee041f017cb5bd3cc54acc0579543e8d033"
    end
    if Hardware::CPU.intel?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.5.4/dedent-paste-x86_64-apple-darwin.tar.xz"
      sha256 "82c09f2cc9e74245bff35a1ec81486080db4e14ccfbacd42a790c7b2fdd91e6f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.5.4/dedent-paste-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bfe2e9178c0bfd1cf57c0136db1109511f75f8e8698445e51a660ad49b9888d7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.5.4/dedent-paste-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6222edd95863849e7459d14f8e732601b5b2c06b3956c7a9ac1cefd0bed20da0"
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
      dedent-paste is installed, but the Left Option+V hotkey is NOT set up yet.

      1. Install Karabiner-Elements if you have not already:
           brew install --cask karabiner-elements
      2. Register the Left Option+V rule (your Karabiner profile is backed up first):
           dedent-paste --install
      3. Allow Karabiner-Elements under
           System Settings > Privacy & Security > Accessibility

      To remove the rule later:
           dedent-paste --uninstall
    EOS
  end
end
