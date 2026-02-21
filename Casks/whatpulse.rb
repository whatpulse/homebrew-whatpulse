cask 'whatpulse' do
  arch arm: 'aarch64', intel: 'x86-64'

  desc 'WhatPulse'
  homepage 'https://whatpulse.org'
  version '6.0.1'
  depends_on cask: 'whatpulse_chmodbpf'

  on_arm do
    url "https://releases.whatpulse.org/latest/macos-arm/whatpulse-mac-arm-#{version}.dmg"
    sha256 'b3d44ed969fdd65cf676eba5de597748a31b78beba6ae65b3f52452ac39ee6e7'
  end
  on_intel do
    url "https://releases.whatpulse.org/latest/macos/whatpulse-mac-#{version}.dmg"
    sha256 '00e9b48359eded910c3ec2f24710f36ba8ef7df04c76f0219730be552f069d69'
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
