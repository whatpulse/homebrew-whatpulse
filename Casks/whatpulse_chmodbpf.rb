cask 'whatpulse_chmodbpf' do
  desc 'WhatPulse ChmodBPF Installer (required for networking stats)'
  homepage 'https://whatpulse.org'
  version '1.0'

  url 'https://releases.whatpulse.org/latest/macos/install.ChmodBPF.pkg'
  sha256 '739fe63afe689b19de5df1b391ff702fc39f350348c0d05661432bb742e49483'

  pkg 'install.ChmodBPF.pkg'
end
