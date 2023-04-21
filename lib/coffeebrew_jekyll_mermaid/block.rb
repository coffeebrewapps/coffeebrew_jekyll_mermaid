# frozen_string_literal: true

module Coffeebrew
  module Jekyll
    module Mermaid
      class Block < ::Liquid::Block
        def render(context)
          config = use_config(context)

          mermaid_source = config["src"]
          mermaid_theme = config["theme"]
          theme_base = mermaid_theme["base"]
          theme_variables = JSON.pretty_generate(mermaid_theme["variables"])

          <<~HTML
            <script type="module">
              import mermaid from '#{mermaid_source}';
              mermaid.initialize({
                startOnLoad: true,
              });
            </script>
            <pre class="mermaid">
            %%{
              init: {
                'theme': '#{theme_base}',
                'themeVariables': #{theme_variables}
              }
            }%%
            #{super}
            </pre>
          HTML
        end

        private

        def use_config(context)
          {
            "src" => use_source_config(context),
            "theme" => use_theme_config(context)
          }
        end

        def use_source_config(context)
          context_source_config || user_source_config(context) || default_source_config
        end

        def use_theme_config(context)
          ::Jekyll::Utils.deep_merge_hashes(
            default_theme_config,
            ::Jekyll::Utils.deep_merge_hashes(user_theme_config(context), context_theme_config)
          )
        end

        def context_theme_config
          @context_theme_config ||= context_config["theme"].to_h
        end

        def context_source_config
          @context_source_config ||= context_config["src"]
        end

        def context_config
          @context_config ||= @markup.empty? ? {} : JSON.parse(@markup)
        end

        def user_theme_config(context)
          user_site_config(context)["theme"].to_h
        end

        def user_source_config(context)
          user_site_config(context)["src"]
        end

        def user_site_config(context)
          context.registers[:site].config["coffeebrew_jekyll_mermaid"].to_h
        end

        def default_theme_config
          @default_theme_config ||= default_config["theme"].to_h
        end

        def default_source_config
          @default_source_config ||= default_config["src"]
        end

        def default_config
          @default_config ||= YAML.safe_load(File.read(default_config_path))["coffeebrew_jekyll_mermaid"].to_h
        end

        def default_config_path
          @default_config_path ||= File.expand_path("config.yml", __dir__)
        end
      end

      Liquid::Template.register_tag("mermaid", Coffeebrew::Jekyll::Mermaid::Block)
    end
  end
end
