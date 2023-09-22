class WhatpulseChmodbpf < Formula
  desc 'WhatPulse ChmodBPF Installer (required for networking stats)'
  homepage 'https://whatpulse.org'
  version '1.0'

  url 'https://releases.whatpulse.org/latest/macos/install.ChmodBPF.pkg'
  sha256 '739fe63afe689b19de5df1b391ff702fc39f350348c0d05661432bb742e49483'

  def install
    # Install the ChmodBPF package as root
    system 'installer', '-pkg', "#{prefix}/install.ChmodBPF.pkg", '-target', '/'
  end
end
