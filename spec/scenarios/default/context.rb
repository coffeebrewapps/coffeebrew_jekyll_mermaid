# frozen_string_literal: true

CONTEXT_DEFAULT = "when using default config with page specific config"

RSpec.shared_context CONTEXT_DEFAULT do
  let(:scenario) { "default" }
  let(:expected_files) do
    [
      # Posts content pages
      dest_dir("posts", "2021-03-12-test-post-1.html"),
      dest_dir("posts", "2021-03-28-test-post-2.html"),
      dest_dir("posts", "2021-05-03-test-post-3.html"),
      dest_dir("posts", "2021-05-03-test-post-4.html"),
    ]
  end
end
