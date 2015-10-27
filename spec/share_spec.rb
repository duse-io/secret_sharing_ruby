RSpec.describe SecretSharing::Share do
  describe ".from_string" do
    it "creates an instance from a string" do
      share = SecretSharing::Share.from_string("1-2")
      point = share.point
      expect(point.x).to be 1
      expect(point.y).to be 2
    end

    it "correctly converts the y value from hex to integer" do
      share = SecretSharing::Share.from_string("1-1b")
      point = share.point
      expect(point.x).to be 1
      expect(point.y).to be 27
    end

    it "correctly converts paddings" do
      share = SecretSharing::Share.from_string("01-1b")
      point = share.point
      expect(point.x).to be 1
      expect(point.y).to be 27
    end
  end

  describe "#to_s" do
    it "stringifies the share by concatenating the x and y value" do
      point = SecretSharing::Point.new(1, 2)
      expect(SecretSharing::Share.new(point).to_s(1)).to eq("1-2")
    end

    it "converts the y value to hex" do
      point = SecretSharing::Point.new(1, 27)
      expect(SecretSharing::Share.new(point).to_s(1)).to eq("1-1b")
    end

    context "a x point length is specified" do
      it "adds 0 padding so all shares are equal length" do
        point = SecretSharing::Point.new(1, 27)
        expect(SecretSharing::Share.new(point).to_s(2)).to eq("01-1b")
      end
    end
  end
end
