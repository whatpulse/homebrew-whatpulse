cask 'whatpulse' do
  arch arm: 'aarch64', intel: 'x86-64'

  desc 'WhatPulse'
  homepage 'https://whatpulse.org'
  version '5.5.2'
  depends_on cask: 'whatpulse_chmodbpf'

  on_arm do
    url "https://releases.whatpulse.org/latest/macos-arm/whatpulse-mac-arm-#{version}.dmg"
    sha256 '15e447cfbfa31ea70eefd63433ce5f57f60577069eb0c68c1792a501cbfc3a42'
  end
  on_intel do
    url "https://releases.whatpulse.org/latest/macos/whatpulse-mac-#{version}.dmg"
    sha256 '857d68a303ca005795cd0a43fbb1d13bed2c9672b740ddc00f2ae9d9a278d86a'
  end

  livecheck do
    url 'https://whatpulse.org/downloads/'
    # this page has this hidden span to indicate the latest version:
    #  <span style="display: none;" id="latest-client-version" data-version="4.3"></span>
    # extract the data-version attribute from the span
    regex(/data-version='(\d+(?:[._-]\d+)+)'/i)
  end

  installer script: {
    executable: "WhatPulse-#{version}-Installer.app/Contents/MacOS/WhatPulse-#{version}-Installer",
    args: ['--root', '/Applications/WhatPulse', '--accept-messages', '--accept-licenses', '--confirm-command',
           '--cache-path', "#{staged_path}/cache", 'install']
  }

  uninstall script: {
    executable: '/Applications/WhatPulse/WhatPulseMaintenanceTool.app/Contents/MacOS/WhatPulseMaintenanceTool',
    args: ['--confirm-command', 'remove', 'com.whatpulse.client']
  }
end
