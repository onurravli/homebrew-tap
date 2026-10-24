class Voltran < Formula
  desc "Local control room for running many coding agents and terminals at once"
  homepage "https://github.com/onurravli/voltran"
  url "https://registry.npmjs.org/voltran/-/voltran-1.1.0.tgz"
  sha256 "4a53b22d2f25fc43cff0ae7b5ac36de1e1ee89115522b7d6a0a8081b2b00bfe1"
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
