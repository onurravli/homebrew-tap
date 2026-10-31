class Voltran < Formula
  desc "Local control room for running many coding agents and terminals at once"
  homepage "https://github.com/onurravli/voltran"
  url "https://registry.npmjs.org/voltran/-/voltran-1.2.0.tgz"
  sha256 "1b8cc372e42d9993ea4c52878db919c610ae8a8145439abc3c6192e11f687404"
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
