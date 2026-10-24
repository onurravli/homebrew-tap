class Voltran < Formula
  desc "Local control room for running many coding agents and terminals at once"
  homepage "https://github.com/onurravli/voltran"
  url "https://registry.npmjs.org/voltran/-/voltran-1.0.1.tgz"
  sha256 "67746573ec5aa09b5d8e04e9549c0dea8f34c882114cb5a0a82c99d91288e86f"
  license "Apache-2.0"

  depends_on "node"

  on_linux do
    depends_on "python@3.13" => :build
  end

  def install
    # node-pty compiles its terminal support on Linux, and Voltran's postinstall makes node-pty's
    # macOS spawn-helper executable.
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")
  end

  def caveats
    <<~EOS
      To start Voltran whenever you log in:
        voltran autostart on
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/voltran version")
    ENV["VOLTRAN_HOME"] = testpath/"home"
    ENV["VOLTRAN_PORT"] = free_port.to_s
    output = shell_output("#{bin}/voltran doctor")
    assert_match "node-pty starts processes", output
    assert_match "UI           built", output
  end
end
