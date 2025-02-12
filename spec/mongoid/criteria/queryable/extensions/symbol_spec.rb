# frozen_string_literal: true
# rubocop:todo all

require "spec_helper"

describe Symbol do

  describe ".add_key" do

    before do
      described_class.add_key(:fubar, :union, "$fu", "$bar") do |value|
        value.to_s
      end
    end

    let(:fubar) do
      :testing.fubar
    end

    it "adds the method to symbol" do
      expect(fubar).to be_a(Mongoid::Criteria::Queryable::Key)
    end

    it "sets the key name" do
      expect(fubar.name).to eq(:testing)
    end

    it "sets the key strategy" do
      expect(fubar.strategy).to eq(:__union__)
    end

    it "sets the key operator" do
      expect(fubar.operator).to eq("$fu")
    end

    it "sets the additional key operator" do
      expect(fubar.expanded).to eq("$bar")
    end

    it "sets the transform block" do
      expect(fubar.block).to be
    end
  end

  describe ".evolve" do

    context "when provided nil" do

      it "returns nil" do
        expect(described_class.evolve(nil)).to be_nil
      end
    end

    context "when provided a string" do

      it "returns the string as a symbol" do
        expect(described_class.evolve("test")).to eq(:test)
      end
    end
  end

  describe "#__expr_part__" do

    let(:specified) do
      :field.__expr_part__(10)
    end

    it "returns the string with the value" do
      expect(specified).to eq({ field: 10 })
    end

    context "with a regexp" do

      let(:specified) do
        :field.__expr_part__(/test/)
      end

      it "returns the symbol with the value" do
        expect(specified).to eq({ field: /test/ })
      end

    end

    context "when negated" do

      context "with a regexp" do

        let(:specified) do
          :field.__expr_part__(/test/, true)
        end

        it "returns the symbol with the value negated" do
          expect(specified).to eq({ field: { "$not" => /test/ } })
        end

      end

      context "with anything else" do

        let(:specified) do
          :field.__expr_part__('test', true)
        end

        it "returns the symbol with the value negated" do
          expect(specified).to eq({ field: { "$ne" => "test" }})
        end

      end
    end
  end
end
