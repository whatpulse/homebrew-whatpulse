cask 'whatpulse' do
  arch arm: 'aarch64', intel: 'x86-64'

  desc 'WhatPulse'
  homepage 'https://whatpulse.org'
  version '5.11.2'
  depends_on cask: 'whatpulse_chmodbpf'

  on_arm do
    url "https://releases.whatpulse.org/latest/macos-arm/whatpulse-mac-arm-#{version}.dmg"
    sha256 'd1ac5b35d8c6c1706b69e80600061030c2e23ebe8743472f9303a934ff065aa9'
  end
  on_intel do
    url "https://releases.whatpulse.org/latest/macos/whatpulse-mac-#{version}.dmg"
    sha256 '2660c493c4d916bbd75130517c0b4a2b3f595700aed6fddde4ca2b8f2e025128'
  end

  livecheck do
    url 'https://whatpulse.org/downloads/'
    # this page has this hidden span to indicate the latest version:
    #  <span style="display: none;" id="latest-client-version" data-version="4.3"></span>
    # extract the data-version attribute from the span
    regex(/data-version='(\d+(?:[._-]\d+)+)'/i)
  end

  installer manual: true

  postflight do
    maintenance_tool = '/Applications/WhatPulse/WhatPulseMaintenanceTool.app/Contents/MacOS/WhatPulseMaintenanceTool'
    update_script = '/Applications/WhatPulse/noninteractive-update.js'

    if File.exist?(maintenance_tool)
      # Existing installation - update via maintenance tool
      system_command maintenance_tool,
                     args: ['update', '--script', update_script, '--accept-licenses', '--default-answer', '--confirm-command'],
                     print_stderr: true
    else
      # Fresh install
      system_command "#{staged_path}/WhatPulse-#{version}-Installer.app/Contents/MacOS/WhatPulse-#{version}-Installer",
                     args: ['--root', '/Applications/WhatPulse', '--accept-messages', '--accept-licenses',
                            '--confirm-command', '--cache-path', "#{staged_path}/cache", 'install'],
                     print_stderr: true
    end
  end

  uninstall script: {
    executable: '/Applications/WhatPulse/WhatPulseMaintenanceTool.app/Contents/MacOS/WhatPulseMaintenanceTool',
    args: ['--confirm-command', 'remove', 'com.whatpulse.client']
  }
end
