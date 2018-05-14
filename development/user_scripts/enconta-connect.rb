#! /usr/bin/env ruby

require 'etc'
require 'yaml'
require 'yaml/store'

class EncontaConfig
	ENCONTA_ENVS = %w[production jobs staging]

	def self.for(environment)
		new.for(environment)
	end

	def self.user_directory
		@user_directory ||= Etc.getpwuid.dir
	end

	def self.servers_file_path
		@servers_file_path ||= "#{user_directory}/.enconta-servers"
	end

	def self.reset
		puts "Reescribiendo archivo de configuración"
		File.delete(servers_file_path)
		new.create_servers_file
	end

	def initialize
		load_servers_file || create_servers_file
	end

	def for(environment)
		servers[environment]
	end

	def create_servers_file
		file = YAML::Store.new(self.class.servers_file_path)

		file.transaction do
			ENCONTA_ENVS.each_with_object(servers) do |environment, hash|
				file[environment] = hash[environment] = server_hostnames_for environment
			end
		end
	end

	private

	def servers
		@servers ||= {}
	end

	def load_servers_file
		@servers = YAML.load_file(self.class.servers_file_path)
	rescue Errno::ENOENT
		false
	end

	def server_hostnames_for(environment)
		%x(enconta-servers #{environment}).split("\n")
	end
end

class EncontaEnvironment
	def self.user_directory
		@user_directory ||= Etc.getpwuid.dir
	end

	def initialize(name)
		@name = name
		@servers = EncontaConfig.for(name)
	end

	attr_reader :name, :servers

	def ssh_key_suffix
		case name
		when 'production', 'jobs' then 'prod'
		when 'staging' then 'stg'
		end
	end

	def ssh_key_path
		"#{self.class.user_directory}/.ssh/encontaapp-#{ssh_key_suffix}.pem"
	end

	def connect(index: false)
		server = index ? servers.fetch(index) : servers.sample
		exec "ssh -i #{ssh_key_path} ec2-user@#{server}"
	end
end

ENCONTA_ENV = ARGV[0] || 'jobs'
return EncontaConfig.reset if ENCONTA_ENV == 'reset'
EncontaEnvironment.new(ENCONTA_ENV).connect
