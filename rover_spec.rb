require 'rover'

describe Rover do

    it "should initialise coordinates" do
      r = Rover.new
      expect(r.location).to eq([[r.x, r.y], r.orient])
    end

    it "returns nil if string doesn't start with a direction" do
      r = Rover.new
      expect(r.send('20R')).to eq(nil)
    end

    it "returns nil for empty string" do
      r = Rover.new
      expect(r.send('')).to eq(nil)
    end

    it "accepts lowercase string" do
      r = Rover.new
      expect(r.send('r20')).to eq(r.location)
    end

    it "if letter has no value after it, treat as single unit" do
      r = Rover.new
      expect(r.send('fff')).to eq([[10.0, 13.0], 'N'])
    end

    it "if letter has no value after it, treat as single unit" do
      r = Rover.new
      expect(r.send('lrl10')).to eq([[10.0, 10.0], 'N'])
    end

    it "wraps values great than 100" do
      r = Rover.new
      expect(r.send('f90')).to eq([[10.0, 0.0], 'N'])
    end

    it "detects stops if an obstacle is detected" do
      mars = Planet.new
      r = Rover.new(mars)
      expect(r.send('f20b10r140')).to eq([[10.0, 30.0], 'N'])
    end

end
