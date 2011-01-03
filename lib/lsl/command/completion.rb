require 'readline'

Readline.basic_word_break_characters = ""
Readline.completion_proc = lambda do |s|
  #puts [s].inspect
  LSL::Completion::Base.instance.new_instance(:full_command => s).matching_options
end

module LSL
  module Completion
    class Base
      class << self
        fattr(:instance) { new }
      end
      fattr(:mappings) { LSL::Completion::Mappings.new }
      fattr(:instances) { [] }
      include FromHash
      def shell
        LSL::Shell.instance
      end
      def new_instance(ops)
        res = LSL::Completion::Instance.new(ops)
        self.instances << res
        res
      end
    end
    class Mapping
      include FromHash
      fattr(:base) { LSL::Completion::Base.instance }
      attr_accessor :command_matcher, :option_generator
      def options
        [base.shell.run(option_generator).result].flatten.select { |x| x }
      end
      def match?(cmd)
        cmd =~ command_matcher
      end
      class << self
        fattr(:file_matcher) do
          new(:option_generator => "ls")
        end
      end
    end
    class Mappings
      fattr(:all) { [] }
      def add(ops)
        self.all << LSL::Completion::Mapping.new(ops)
      end
      def options(cmd)
        res = all.find { |x| x.match?(cmd) }
        return res.options if res
        LSL::Completion::Mapping.file_matcher.options
      end
      
    end
    class Instance
      include FromHash
      fattr(:base) { LSL::Completion::Base.instance }
      def shell; base.shell; end
      attr_accessor :full_command
      fattr(:options) do
        base.mappings.options(full_command)
      end
      fattr(:prefix) { full_command.split(" ").last }
      fattr(:preceding) { full_command.split(" ")[0..-2].join(" ") }
      
      fattr(:matching_options) do
        options.grep(/^#{prefix}/i).map { |x| "#{preceding} #{x}".strip }
      end
      
    end
  end
end

c = LSL::Completion::Base.instance
#c.option_generator = "ls"
c.mappings.add(:command_matcher => /rake/i, :option_generator => 'rake -T | column _ 5 24')
      