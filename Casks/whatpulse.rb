cask 'whatpulse' do
  desc 'WhatPulse'
  homepage 'https://whatpulse.org'
  version '7.0'
  depends_on cask: 'whatpulse_chmodbpf'

  url "https://releases.whatpulse.org/archives/#{version}/macos/whatpulse-mac-#{version}.dmg"
  sha256 '347d2a61874ecb836d224849fa5d398277c56cd1415aae6f1689e9a8106634ae'

  livecheck do
    url 'https://whatpulse.org/downloads/'
    # this page has this hidden span to indicate the latest version:
    #  <span style="display: none;" id="latest-client-version" data-version="4.3"></span>
    # extract the data-version attribute from the span
    regex(/data-version=["'](\d+(?:[._-]\d+)+)["']/i)
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
      "\"#{staged_path}/Install WhatPulse.app/Contents/MacOS/WhatPulse-#{version}-Installer\" " \
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
