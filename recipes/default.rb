# Git Annex
# =========

if node['platform'] == 'mac_os_x'
  include_recipe 'dmg'

  case node['platform_version']
  when /^10\.7\./
    dmg_bz2_url_path = '10.7.5_Lion/git-annex.dmg.bz2'
    dmg_bz2_checksum = 'c883b718f4e94f32cf017718259bc71f6536fac025794cb6f8eb3f67105742bf'
  when /^10\.8\./
    dmg_bz2_url_path = '10.8.2_Mountain_Lion/git-annex.dmg.bz2'
    dmg_bz2_checksum = 'fd33a20fbeb714efd2162f83a6f6d2e53d461eca3f82df9587f2b4f786555f8c'
  else
    raise 'Only OSX 10.7 and 10.8 are supported.'
  end

  dmg_path = "#{Chef::Config[:file_cache_path]}/git-annex.dmg"

  execute "bunzip2 -c #{dmg_path}.bz2 > #{dmg_path}.orig" do
    action :nothing
    creates "#{dmg_path}.orig"
  end

  remote_file "#{dmg_path}.bz2" do
    source "http://downloads.kitenet.net/git-annex/OSX/current/#{dmg_bz2_url_path}"
    checksum dmg_bz2_checksum
    notifies :run, "execute[bunzip2 -c #{dmg_path}.bz2 > #{dmg_path}.orig]", :immediately
  end

  dmg_package 'git-annex' do
    action :install
  end

  %w[git-annex git-annex-shell git-annex-webapp runshell].each do |bin|
    link "/usr/local/bin/#{bin}" do
      to "/Applications/git-annex.app/Contents/MacOS/#{bin}"
    end
  end
else
  include_recipe 'apt'
  apt_repository "nginx-php" do
    uri 'http://ppa.launchpad.net/fmarier/git-annex/ubuntu'
    distribution node['lsb']['codename']
    components ["main"]
    keyserver "keyserver.ubuntu.com"
    key "C300EE8C"
    only_if { node['platform'] == 'ubuntu' && node['lsb']['codename'] == 'precise' }
  end
  package 'git-annex'
end
