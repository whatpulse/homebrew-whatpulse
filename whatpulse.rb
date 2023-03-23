class Whatpulse < Formula
  desc 'WhatPulse'
  homepage 'https://whatpulse.org'
  version '5.3'

  if Hardware::CPU.arm?
    url 'https://releases.whatpulse.org/latest/macos-arm/whatpulse-mac-arm-latest.dmg'
    sha256 '4bf4871277ded9a8ac56503f2997f4c83148d6d1be6623560c631c1237874701'
  else
    url 'https://releases.whatpulse.org/latest/macos/whatpulse-mac-latest.dmg'
    sha256 '8e3481d18402a06fc58177d74ce7fffc4531823727d6f80198f38ef3026c766b'
  end

  def install
    volume = "/Volumes/WhatPulse\ #{version}"
    system 'hdiutil', 'attach', '-quiet', '-nobrowse', cached_download
    cp_r "#{volume}/WhatPulse-#{version}-Installer.app", "#{prefix}/"
    system 'hdiutil', 'detach', "/Volumes/WhatPulse\ #{version}"
  end

  # open the installer. this cannot be an unattended install, as brew launches commands in a
  # headless console, and the installer (even the CLI installer) requires a head. :-(
  def post_install
    system 'open', "#{prefix}/WhatPulse-#{version}-Installer.app"
  end
end
