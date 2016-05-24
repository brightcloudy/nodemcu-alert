#!/usr/bin/env ruby
require 'json'
require 'dnssd'
require 'highline/import'
@configfile = File.expand_path("~/.alertconfig")
def create_config
  newcfile = File.new(@configfile, "w+", 0644)
  alertnodes = Hash.new
  DNSSD.browse! '_alert._tcp' do |reply|
    DNSSD.resolve! reply do |r|
      alertnodes.store(r.target, r.port)
      break unless reply.flags.more_coming?
    end
    break unless reply.flags.more_coming?
  end
  mynode = choose do |menu|
    menu.prompt = "Please select the device you wish to use with this script."
    alertnodes.each_key { |k| menu.choice k }
  end
  confout = {"target" => mynode, "port" => alertnodes[mynode]}
  newcfile.print(JSON.generate(confout))
  newcfile.close
end
def send_command(confg, cmdstr)
  sock = TCPSocket.new confg["target"], confg["port"]
  sock.puts cmdstr
  sock.close
end

create_config if not File.exists?(@configfile)
config = JSON.parse(File.open(@configfile).readline)
abort "Please specify command to execute and watch." if ARGV.length == 0
cmd = ARGV.join(" ")
send_command config, "running"
ret = system cmd
send_command config, "doneok" if ret
send_command config, "donefail" if not ret
print "Done! --ENTER--"
$stdin.getc
send_command config, "ack"
