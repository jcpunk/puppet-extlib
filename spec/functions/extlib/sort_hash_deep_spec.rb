# frozen_string_literal: true

require 'spec_helper'

describe 'extlib::sort_hash_deep' do
  subject(:result) { scope.call_function('extlib::sort_hash_deep', [input]) }

  context 'with a flat hash' do
    let(:input) do
      {
        'b' => 2,
        'a' => 1,
        'c' => 3,
      }
    end

    it 'sorts keys lexicographically' do
      expect(result.keys).to eq(%w[a b c])
    end
  end

  context 'with nested hashes' do
    let(:input) do
      {
        'z' => {
          'b' => 2,
          'a' => 1,
        },
        'a' => {
          'd' => 4,
          'c' => 3,
        },
      }
    end

    it 'sorts keys at all levels' do
      expect(result.keys).to eq(%w[a z])
      expect(result['a'].keys).to eq(%w[c d])
      expect(result['z'].keys).to eq(%w[a b])
    end
  end

  context 'with arrays containing hashes' do
    let(:input) do
      {
        'a' => [
          { 'b' => 2, 'a' => 1 },
          { 'd' => 4, 'c' => 3 },
        ],
      }
    end

    it 'sorts hashes inside arrays but preserves array order' do
      expect(result['a'][0].keys).to eq(%w[a b])
      expect(result['a'][1].keys).to eq(%w[c d])
    end
  end

  context 'idempotency' do
    let(:input) do
      {
        'b' => { 'y' => 2, 'x' => 1 },
        'a' => 1,
      }
    end

    it 'is stable across repeated application' do
      first  = result
      second = scope.call_function('extlib::sort_hash_deep', [first])

      expect(second).to eq(first)
    end
  end

  context 'with mixed scalar and nested types' do
    let(:input) do
      {
        'b' => true,
        'd' => [
          {
            'f' => [3, 2, 1],
            'g' => { 'l' => false, 'e' => 321 },
          },
        ],
        'a' => 'string',
        'c' => 1.23,
      }
    end

    it 'preserves values and structure while sorting hashes' do
      expect(result).to eq(
        {
          'a' => 'string',
          'b' => true,
          'c' => 1.23,
          'd' => [
            {
              'f' => [3, 2, 1],
              'g' => {
                'e' => 321,
                'l' => false,
              },
            },
          ],
        },
      )
    end

    it 'does not change structure shape' do
      expect(result).to be_a(Hash)
      expect(result['d']).to be_a(Array)
      expect(result['d'][0]).to be_a(Hash)
    end
  end
end
