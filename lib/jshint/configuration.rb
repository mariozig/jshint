require 'yaml'

module Jshint
  # Configuration object containing JSHint lint settings
  class Configuration

    # @return [Hash] the configration options
    attr_reader :options

    # Initializes our configuration object
    #
    # @param path [String] The path to the config file
    def initialize(path = nil)
      @path = path || default_config_path
      @options = parse_yaml_config
    end

    # Returns the value of the options Hash if one exists
    #
    # @param key [Symbol]
    # @return The value of the of the options Hash at the passed in key
    def [](key)
      options["options"][key.to_s]
    end

    # Returns a Hash of global variables if one exists
    #
    # @example
    #   {
    #     "$" => true,
    #     jQuery => true,
    #     angular => true
    #   }
    #
    # @return [Hash, nil] The key value pairs or nil
    def global_variables
      options["options"]["globals"]
    end

    # Returns a Hash of options to be used by JSHint
    #
    # See http://jshint.com/docs/options/ for more config options
    #
    # @example
    #   {
    #     "eqeqeq" => true,
    #     "indent" => 2
    #   }
    # @return [Hash, nil] The key value pairs of options or nil
    def lint_options
      @lint_options ||= options["options"].reject { |key| key == "globals" }
    end

    # Returns the list of files that JSHint should lint over relatives to the Application root
    #
    # @example
    #   [
    #     'angular/controllers/*.js',
    #     'angular/services/*.js'
    #   ]
    #
    # @return [Array<String>] An Array of String files paths
    def files
      options["files"]
    end

    private

    def read_config_file
      @read_config_file ||= File.open(@path, 'r:UTF-8').read
    end

    def parse_yaml_config
      YAML.load(read_config_file)
    end

    def default_config_path
      File.join(Rails.root, 'config', 'jshint.yml')
    end
  end
end
