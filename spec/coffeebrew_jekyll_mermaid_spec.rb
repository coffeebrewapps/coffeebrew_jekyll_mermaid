# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Coffeebrew::Jekyll::Mermaid) do
  let(:overrides) do
    override_config_file = expected_dir(scenario, "_config.yml")
    return {} unless File.exist?(override_config_file)

    YAML.safe_load(File.read(override_config_file))
  end

  let(:config) do
    Jekyll.configuration(
      Jekyll::Utils.deep_merge_hashes(
        {
          "full_rebuild" => true,
          "source" => source_dir,
          "destination" => dest_dir,
          "show_drafts" => false,
          "url" => "https://coffeebrew-jekyll-mermaid.com",
          "name" => "CoffeeBrewApps Jekyll Mermaid",
          "author" => {
            "name" => "Coffee Brew Apps"
          },
          "collections" => {}
        },
        overrides
      )
    )
  end

  let(:site) { Jekyll::Site.new(config) }
  let(:generated_files) do
    Dir[
      dest_dir("posts", "**", "*.html")
    ]
  end

  after do
    FileUtils.rm_r(dest_dir, force: true)
  end
end
