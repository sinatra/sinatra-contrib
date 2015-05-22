require 'thor/group'

module Sinatra

  class Generator < Thor::Group
    include Thor::Actions

    argument :name, :optional => false
    argument :target_directory, :optional => true
    argument :ruby_version, :optional => true, :default => '2.0.0'
    argument :ruby_revision, :optional => true, :default => 'p353'

    def self.source_root
      File.expand_path(Dir.getwd)
    end

    def generate
      puts "Creating Sinatra template in #{target}"

      @project_name = name.gsub(/\-/, '_')
      @project_name_camelised = @project_name.camelize

      files = list_files(template_dir)
      files.each do |file|
        process_file(file)
      end
    end
    
    protected

      def target
        @target ||= target_directory || File.expand_path(File.join(".."), Dir.getwd)
      end

      def template_dir
        "#{Generator.source_root}/template"
      end

      def list_files(dirname)
        files = []
        Dir.foreach(dirname) do |dir|
          dirpath = dirname + '/' + dir
          if File.directory?(dirpath)
            next if dir == '.' || dir == '..'
            files << list_files(dirpath)
          else
            files << dirpath
          end
        end
        return files.flatten
      end

      def process_file(file_path)
        target_file = file_path.gsub(/^#{template_dir}/, "#{target}/#{name}")
        target_file = convert(target_file)
        template(file_path, target_file, :force => true)
      end

      def convert(content)
        content.gsub(/template/, @project_name)
      end

  end

end