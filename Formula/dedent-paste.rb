class DedentPaste < Formula
  desc "Paste clipboard text with common indentation removed"
  homepage "https://dedent-paste.gh.miniasp.com/"
  version "0.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.6.1/dedent-paste-aarch64-apple-darwin.tar.xz"
      sha256 "842749493cdc4e916880611d2cb522378c788527f2b1854cca583b4fbf19cb4d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.6.1/dedent-paste-x86_64-apple-darwin.tar.xz"
      sha256 "49768020f67d44f751131d300590507ee1da688705c39ad93f6fa94de3921e41"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.6.1/dedent-paste-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d767d6c70b82db18bf4f4c1c946b0e033adbdf19cc490f4ccd05a87cb1cd7b17"
    end
    if Hardware::CPU.intel?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.6.1/dedent-paste-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b9a050c82ed6103c71ab3287be5ea2f6d8d624b67269808aa50e72cd61492fc7"
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
