class WhatpulseChmodbpf < Formula
  desc 'WhatPulse ChmodBPF Installer (required for networking stats)'
  homepage 'https://whatpulse.org'
  version '1.0'

  url 'https://releases.whatpulse.org/latest/macos-arm/whatpulse-mac-arm-latest.dmg'
  sha256 'de24ae635bacdabbd785a6427b37b31bf8802b4ee015f6e417f325adad420139'

  def install
    # No need to perform any installation steps as it's just a package
  end
end
