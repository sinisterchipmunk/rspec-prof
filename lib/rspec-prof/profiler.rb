module RSpecProf
  class Profiler
    attr_reader :options
    
    # Possible options:
    #   :min_percent  - Number 0 to 100 that specifes the minimum
    #                   %self (the methods self time divided by the
    #                   overall total time) that a method must take
    #                   for it to be printed out in the report.
    #                   Default value is 0.
    #
    #   :print_file   - True or false. Specifies if a method's source
    #                   file should be printed.  Default value is false.
    #
    #   :printer      - Specifies the output printer.  Valid values include
    #                   :flat, :graph, :graph_html and :call_tree. Defaults
    #                   to :graph_html.
    #
    #   :file         - filename or IO stream to send data to. By default this
    #                   is generated from your spec description and prepended
    #                   with a unique ID. Extension is added automatically if
    #                   one is not already present.
    #
    #   :measure_mode - possible choices are 'wall_time', 'cpu_time',
    #                   'allocations', 'memory', 'process_time'. Defaults
    #                   to 'process_time'
    #
    #   :directory    - the directory in which to place :file. If :file is not
    #                   a String, this is ignored. Defaults to "./profiler"
    #
    def initialize(options)
      @options = default_options.merge(options)
      
      if @options[:file].kind_of?(String)
        case @options[:printer]
          when :graph_html
            ext = "html"
          else
            ext = "txt"
        end
        
        @options[:file] = "#{@options[:file]}.#{ext}" unless @options[:file] =~ /\./
      end

      ENV["RUBY_PROF_MEASURE_MODE"] = options[:measure_mode]
      RubyProf.figure_measure_mode
    end
    
    def start
      RubyProf.start
    end
    
    def stop
      file = options[:file]
      result = RubyProf.stop
      
      printer_class = options[:printer].kind_of?(Class) ? options[:printer] :
                      "RubyProf::#{options[:printer].to_s.camelize}Printer".constantize
      with_io(file) do |out|
        printer = printer_class.new(result)
        printer.print(out, :print_file => options[:print_file], :min_percent => options[:min_percent])
      end
    end
    
    private
    def default_options
    {
      :min_percent => 0,
      :print_file => false,
      :printer => :graph_html,
      :file => "./profile",
      :measure_mode => 'process_time',
      :directory => "./profiles"
    }
    end
    
    def with_io(file)
      if file.respond_to?(:write) && file.respond_to?(:puts)
        yield file
      else
        file = File.expand_path(File.join(options[:directory], file))
        FileUtils.makedirs(File.dirname(file))
        File.open(file, "w") do |out|
          yield out
        end
      end
    end
  end
end
