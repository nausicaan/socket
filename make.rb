#!/usr/bin/env ruby
$stdin.flush
$stdout.flush
$stdout.sync = true
argument = ARGV
require 'yaml'
domain = (File.readlines(Dir.home + "/plugins/active-plugins-list.txt"))
sites = (YAML.load_file(Dir.home + "/plugins/site-active-plugins.yaml"))

def document(content)
  File.open(Dir.home + "/plugins/domain-active-plugins.yaml", 'a') do |f|
    content.each do |c|
      f.print "#{c}"
    end
  end
end

File.delete(Dir.home + "/plugins/domain-active-plugins.yaml") if File.exist?(Dir.home + "/plugins/domain-active-plugins.yaml")
document(["---\n"])

domain.each do |d|
  vara = []
  sites.each do |s|
    index = 0
    limit = sites["#{s[0]}"].length
    d.chomp!
    while index < limit do
      plugin = sites["#{s[0]}"][index]['Plugin']
      version = sites["#{s[0]}"][index]['Version']
      if sites["#{s[0]}"][index]['Plugin'] == "#{d}"
        vara << "- Plugin: #{plugin}\n" << "  Version: #{version}\n"
        vara.uniq!
        break if index > 0
      end
      index += 1
    end
  end
  document(vara)
end

document(["...\n"])