# frozen_string_literal: true

require "spec_helper"

require_relative "./scenarios/default/context"
require_relative "./scenarios/user_config/context"

SUCCESS_EXAMPLE = "generate example pages correctly"

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

  context "with success examples" do
    shared_examples_for SUCCESS_EXAMPLE do
      it do
        site.process
        expect(generated_files).to match_array(expected_files)
        generated_files.each do |generated_file|
          expected_file = generated_file.gsub(DEST_DIR, File.join(SCENARIO_DIR, scenario, "_site"))
          sanitized_generated = sanitize_html(File.read(generated_file))
          sanitized_expected = sanitize_html(File.read(expected_file))
          expect(sanitized_generated).to eq sanitized_expected
        end
      end
    end

    context CONTEXT_DEFAULT do
      include_context CONTEXT_DEFAULT do
        it_behaves_like SUCCESS_EXAMPLE
      end
    end

    context CONTEXT_USER_CONFIG do
      include_context CONTEXT_USER_CONFIG do
        it_behaves_like SUCCESS_EXAMPLE
      end
    end
  end
end
