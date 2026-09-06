class DedentPaste < Formula
  desc "Paste clipboard text with common indentation removed"
  homepage "https://dedent-paste.gh.miniasp.com/"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.5.0/dedent-paste-aarch64-apple-darwin.tar.xz"
      sha256 "509bafe24695c75856661d73c8e34db2987b580d6f627a1225d31ce5a283f390"
    end
    if Hardware::CPU.intel?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.5.0/dedent-paste-x86_64-apple-darwin.tar.xz"
      sha256 "359ed09ae60bf20f4f5e9eece3f6e6d877679aa9d39fb7170b9c609e0100853c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.5.0/dedent-paste-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "25be8985c2103616c2e7c1df58850578c374c8b67e336f06a1d7cb649c4ad24c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/doggy8088/dedent-paste/releases/download/v0.5.0/dedent-paste-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aeb593a9685c19b4ebd3ef92de9829242b96a3afe199fc7cfa528f0cec53b1ef"
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
