#!/usr/bin/env rspec
# Copyright (c) [2021] SUSE LLC
#
# All Rights Reserved.
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of version 2 of the GNU General Public License as published
# by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, contact SUSE LLC.
#
# To contact SUSE LLC about this file by physical or electronic mail, you may
# find current contact information at www.suse.com.

require_relative "../test_helper"
require "y2issues"

describe Y2Issues::List do
  subject(:list) { described_class.new([issue]) }

  let(:issue) { Y2Issues::Issue.new("Something went wrong") }

  it "returns an array containing added issues" do
    expect(list.to_a).to eq([issue])
  end

  describe "#to_a" do
    context "when list is empty" do
      subject(:list) { described_class.new([]) }

      it "returns an empty array" do
        expect(list.to_a).to eq([])
      end
    end
  end

  describe "#empty?" do
    context "when list is empty" do
      subject(:list) { described_class.new([]) }

      it "returns true" do
        expect(list).to be_empty
      end
    end

    context "when some issue was added" do
      it "returns false" do
        expect(list).to_not be_empty
      end
    end
  end

  describe "#fatal?" do
    context "when contains some fatal error" do
      let(:issue) { Y2Issues::Issue.new("Something went wrong", severity: :fatal) }

      it "returns true" do
        expect(list.fatal?).to eq(true)
      end
    end

    context "when does not contain any fatal error" do
      it "returns false" do
        expect(list.fatal?).to eq(false)
      end

    end
  end
end
