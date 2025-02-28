class MongodbTestAT36 < Formula
  desc "Test config for Mongodb 3.6 so you can run two DB in parallel"
  homepage "https://github.com/sensorsasha/homebrew-mongodb-test36"
  url "https://raw.githubusercontent.com/sensorsasha/homebrew-mongodb-test36/master/empty", :using => :nounzip
  version "3.6"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"

  depends_on "mongodb@3.6"

  def install
    (buildpath/"mongod-test36.conf").write mongodb_conf
    etc.install "mongod-test36.conf"

    bin.install "empty" # Homebrew requires to download and "install" at least something
  end

  def post_install
    (var/"log/mongodb-test36").mkpath
    (var/"mongodb-test36").mkpath
  end

  def mongodb_conf; <<~EOS
    systemLog:
      destination: file
      path: "/dev/null"
      logAppend: false
      quiet: true
    storage:
      dbPath: #{var}/mongodb-test36
      engine: ephemeralForTest
      journal:
        enabled: false
    net:
      bindIp: 127.0.0.1
      port: 27018
  EOS
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/mongodb@3.6/bin/mongod --config #{HOMEBREW_PREFIX}/etc/mongod-test36.conf"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{HOMEBREW_PREFIX}/opt/mongodb@3.6/bin/mongod</string>
        <string>--config</string>
        <string>#{etc}/mongod-test36.conf</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <false/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/mongodb/output-test.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/mongodb/output-test.log</string>
      <key>HardResourceLimits</key>
      <dict>
        <key>NumberOfFiles</key>
        <integer>4096</integer>
      </dict>
      <key>SoftResourceLimits</key>
      <dict>
        <key>NumberOfFiles</key>
        <integer>4096</integer>
      </dict>
    </dict>
    </plist>
  EOS
  end

  test do
    system "#{bin}/mongod", "--sysinfo"
  end
end
