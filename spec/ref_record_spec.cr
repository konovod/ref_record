require "./spec_helper"

ref_record Point, x : Int32, y : Int32 = -1

describe "ref_record" do
  it "allows to get and set fields" do
    point = Point.new(123, 456)
    p1 = RefPoint.new(pointerof(point))
    p1.x.should eq 123
    p1.y.should eq 456
    p1.y += 1
    p1.y.should eq 457
  end

  it "copies point to same value" do
    point = Point.new(123, 456)
    p1 = RefPoint.new(pointerof(point))
    p2 = p1
    p2.x = 10
    p1.x.should eq 10
  end
end

ref_record Line, start : StructPoint, finish : StructPoint, color : String

describe "ref_record" do
  it "provides accessors to inner members" do
    line = Line.new(Point.new(123, 456), Point.new(789, 1000), "White")
    l1 = RefLine.new(pointerof(line))
    l1.start.x += 1
    l1.start.x.should eq 124
  end

  it "can get pointers to fields" do
    line = Line.new(Point.new(123, 456), Point.new(789, 1000), "White")
    l1 = RefLine.new(pointerof(line))
    ptr = l1.start.ptr_x
    ptr.value += 1
    ptr.value.should eq line.start.x
  end
end

# ref_record SomeStruct, header : UInt32[4], data : UInt8[0]
