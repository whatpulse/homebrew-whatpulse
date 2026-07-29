cask 'whatpulse' do
  arch arm: 'aarch64', intel: 'x86-64'

  desc 'WhatPulse'
  homepage 'https://whatpulse.org'
  version '6.3.1'
  depends_on cask: 'whatpulse_chmodbpf'

  on_arm do
    url "https://releases.whatpulse.org/archives/#{version}/macos-arm/whatpulse-mac-arm-#{version}.dmg"
    sha256 '043b6df7f4240e63a9b726e8710197848d6936dcff451c24aa7d976daa425723'
  end
  on_intel do
    url "https://releases.whatpulse.org/archives/#{version}/macos/whatpulse-mac-#{version}.dmg"
    sha256 '9c374ffe7817d8a87775d8ae92d721a9c3a0ffb9942f09185b818b9718729e98'
  end

  livecheck do
    url 'https://whatpulse.org/downloads/'
    # this page has this hidden span to indicate the latest version:
    #  <span style="display: none;" id="latest-client-version" data-version="4.3"></span>
    # extract the data-version attribute from the span
    regex(/data-version='(\d+(?:[._-]\d+)+)'/i)
  end

  installer script: {
    executable: '/bin/bash',
    args: [
      '-c',
      "MAINTENANCE_TOOL='/Applications/WhatPulse/WhatPulseMaintenanceTool.app/Contents/MacOS/WhatPulseMaintenanceTool'; " \
      'if [ -x "$MAINTENANCE_TOOL" ]; then ' \
      '"$MAINTENANCE_TOOL" update --accept-licenses --default-answer --confirm-command; ' \
      'RC=$?; if [ $RC -eq 0 ] || [ $RC -eq 3 ]; then exit 0; else exit $RC; fi; ' \
      'else ' \
      "\"#{staged_path}/WhatPulse-#{version}-Installer.app/Contents/MacOS/WhatPulse-#{version}-Installer\" " \
      '--root /Applications/WhatPulse --accept-messages --accept-licenses --confirm-command ' \
      "--cache-path \"#{staged_path}/cache\" install; " \
      'fi'
    ]
  }

  uninstall script: {
              executable: '/Applications/WhatPulse/WhatPulseMaintenanceTool.app/Contents/MacOS/WhatPulseMaintenanceTool',
              args: ['--confirm-command', 'remove', 'com.whatpulse.client', 'com.whatpulse.maintenancetool']
            },
            delete: '/Applications/WhatPulse'
end
