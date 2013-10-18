#! /usr/bin/env rspec

ENV["Y2DIR"] = File.expand_path("../../src", __FILE__)

require "yast"
include Yast

Yast.import "Linuxrc"

INSTAL_INF = {
  "Manual" => "0",
  "Locale" => "xy_XY",
  "Display" => "Color",
  "HasPCMCIA" => "0",
  "NoPCMCIA" => "0",
  "Sourcemounted" => "1",
  "SourceType" => "dir",
  "RepoURL" => "cd:/?device=disk/by-id/ata-VBOX_CD-ROM_VB2-01700376",
  "InstsysURL" => "boot/x86_64/root",
  "ZyppRepoURL" => "cd:/?devices=/dev/disk/by-id/ata-VBOX_CD-ROM_VB2-01700376",
  "InstMode" => "cd",
  "Device" => "disk/by-id/ata-VBOX_CD-ROM_VB2-01700376",
  "Cdrom" => "disk/by-id/ata-VBOX_CD-ROM_VB2-01700376",
  "Partition" => "disk/by-id/ata-VBOX_CD-ROM_VB2-01700376",
  "Serverdir" => "/",
  "InitrdModules" => "ata_piix ata_generic cdrom sr_mod st sg thermal_sys thermal",
  "Options" => "thermal tzp=50",
  "UpdateDir" => "/linux/suse/x86_64-13.1",
  "YaST2update" => "0",
  "Textmode" => "0",
  "MemFree" => "989888",
  "VNC" => "0",
  "UseSSH" => "1",
  "InitrdID" => "2013-09-17.8c48b884",
  "WithiSCSI" => "0",
  "WithFCoE" => "0",
  "StartShell" => "0",
  "Y2GDB" => "0",
  "kexec_reboot" => "1",
  "UseSax2" => "0",
  "EFI" => "0",
  "Ignored_featureS" => "import_ssh_keys,import_users",
  "Cmdline" => "splash=silent vga=0x314",
  "Keyboard" => "1",
  "Framebuffer" => "0x0314",
  "X11i" => "",
  "XServer" => "fbdev",
  "XVersion" => "4",
  "XBusID" => "0:2:0",
  "XkbRules" => "xfree86",
  "XkbModel" => "pc104",
  "umount_result" => "0",
  "Console" => "/dev/console",
}

describe "Linuxrc" do
  before(:each) do
    # Default value
    SCR.stub(:Read).and_return nil

    SCR.stub(:Read)
      .with(path(".target.size"))
      .and_return 1

    # Default value
    SCR.stub(:Dir).and_return nil

    SCR.stub(:Dir)
      .with(path(".etc.install_inf"))
      .and_return INSTAL_INF.keys

    INSTAL_INF.keys.each {
      |key|
      SCR.stub(:Read)
        .with(path(".etc.install_inf.#{key}"))
        .and_return INSTAL_INF[key]
    }
  end

  it "returns that serial console is in use if it's in install.inf" do
    expect(Linuxrc.serial_console).to be_true
  end

  it "returns that braille display is not in use if it's not in install.inf" do
    expect(Linuxrc.braille).to be_false
  end

  it "returns that VNC is not in use if it's not in install.inf" do
    expect(Linuxrc.vnc).to be_false
  end

  it "returns that SSH is in use if it's in install.inf" do
    expect(Linuxrc.usessh).to be_true
  end

  it "returns that iSCSI is not in use if it's not in install.inf" do
    expect(Linuxrc.useiscsi).to be_false
  end

  it "returns that text mode is not in use if it's not in install.inf" do
    expect(Linuxrc.text).to be_false
  end

  it "returns locale defined in install.inf" do
    expect(Linuxrc::InstallInf("Locale")).to be_equal(INSTAL_INF["Locale"])
  end
end
