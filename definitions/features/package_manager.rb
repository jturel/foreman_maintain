class Features::PackageManager < ForemanMaintain::Feature
  metadata do
    label :package_manager
  end

  extend Forwardable
  def_delegators :manager, :lock_versions, :unlock_versions,
                 :installed?, :find_installed_package, :install, :update,
                 :version_locking_enabled?, :install_version_locking,
                 :versions_locked?, :clean_cache, :remove, :files_not_owned_by_package

  def self.type
    @type ||= %w[dnf yum apt].find { |manager| command_present?(manager) }
  end

  def type
    self.class.type
  end

  def manager
    @manager ||= case type
                 when 'dnf'
                   ForemanMaintain::PackageManager::Dnf.new
                 when 'yum'
                   ForemanMaintain::PackageManager::Yum.new
                 else
                   raise 'No supported package manager was found'
                 end
  end

  # TODO: DEB  grep ^Package: /var/lib/apt/lists/deb.theforeman.org_dists_*
  # TODO DEB apt-mark hold/unhold <package>
end
