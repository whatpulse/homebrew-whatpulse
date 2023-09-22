class Whatpulse < Formula
  desc 'WhatPulse'
  homepage 'https://whatpulse.org'
  version '5.5.2'

  if Hardware::CPU.arm?
    url 'https://releases.whatpulse.org/latest/macos-arm/whatpulse-mac-arm-latest.dmg'
    sha256 '15e447cfbfa31ea70eefd63433ce5f57f60577069eb0c68c1792a501cbfc3a42'
  else
    url 'https://releases.whatpulse.org/latest/macos/whatpulse-mac-latest.dmg'
    sha256 '857d68a303ca005795cd0a43fbb1d13bed2c9672b740ddc00f2ae9d9a278d86a'
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
    installer_path = "#{prefix}/WhatPulse-#{version}-Installer.app/Contents/MacOS/WhatPulse-#{version}-Installer"
    params = '--root /Applications/WhatPulse552 --accept-messages --accept-licenses --confirm-command install'
    install_command = "#{installer_path} #{params}"

    system(install_command)
  end
end
