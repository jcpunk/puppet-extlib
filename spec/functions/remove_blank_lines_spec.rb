# frozen_string_literal: true

require 'spec_helper'

describe 'extlib::remove_blank_lines' do
  let(:input) { <<-TEXT }
    string_name: "string_value"

    int_name: 42

    true_name: yes
  TEXT
  let(:output) { <<-TEXT.chomp }
    string_name: "string_value"
    int_name: 42
    true_name: yes
  TEXT

  it { is_expected.to run.with_params(input).and_return(output) }
end
