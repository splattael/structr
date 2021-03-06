# Structr

[<img src="https://travis-ci.org/splattael/structr.png?branch=master"
alt="Build Status" />](https://travis-ci.org/splattael/structr) [<img
src="https://badge.fury.io/rb/structr.png" alt="Gem Version"
/>](http://badge.fury.io/rb/structr) [<img
src="https://codeclimate.com/github/splattael/structr.png"
/>](https://codeclimate.com/github/splattael/structr)

Bind plain text to Ruby classes.

Inspired by ROXML http://github.com/Empact/roxml/tree/master

## Usage

```ruby
require 'structr'

Load = Struct.new(:one, :five, :fifteen)
ProcessItem = Struct.new(:pid, :user)

class Top
  include Structr

  converter :load do |one, five, fifteen|
    Load.new(one.to_f, five.to_f, fifteen.to_f)
  end

  converter :process do |pid, user|
    ProcessItem.new(pid.to_i, user)
  end

  field :uptime, /top - (\d+):(\d+):(\d+)/ do |h, m, s|
    h.to_i * 3600 + m.to_i * 60 + s.to_i
  end
  field :cpu_string, /(Cpu.*?)\n/
  load_accessor :load, /load average: (\d+\.\d+), (\d+\.\d+), (\d+\.\d+)/
  int_accessor :tasks, /Tasks:\s+(\d+)/
  int_accessor :memory, /Mem:\s+(\d+)/
  field :processes, /^\s*(\d+)\s(\S+)/, &converter(:process)

  attr_reader :processes

  def users
    @processes.map(&:user).uniq
  end

  def highest_pid
    @processes.map(&:pid).sort.last
  end
end

top = Top.structr(`top -b -n 1`)

puts "Load is #{top.load.one}"
puts "Up since #{top.uptime} seconds"
puts top.cpu_string
puts "#{top.tasks} Tasks"
puts "#{top.memory / 1024}MB memory available"
puts "Users: #{top.users.join(', ')}"
puts "Highest PID: #{top.highest_pid}"
```

### Examples

See examples/ for further examples

## Installation

### Installation

    gem install structr
