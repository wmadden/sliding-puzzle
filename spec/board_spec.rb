require "spec_helper"
require "board"

describe(Board) do

    describe(".generate") do

        it "should create a new board with a grid of tiles of the specified size" do
            Board.should_receive(:new).with(
                [ [1,2,3],
                  [4,5,6],
                  [7,8,nil] ]
            )
            Board.generate(3)
        end

    end

    context "for a 3x3 board" do
        let(:board) { Board.generate(3) }

        describe("#get") do
            subject { board.get(point) }

            context "for the point (1,1)" do
                let(:point) { Point.new(1,1) }

                it { should == 5 }
            end
        end

        describe("#size") do
            subject { board.size }
            it { should == 3 }
        end

        describe("#dup") do
            subject { board.dup }

            it { should == board }
            it { should_not equal board } # Not same instance
        end

        describe("#movable_tiles") do
            subject { board.movable_tiles }

            it { should == [6, 8] }
        end

        describe("#slide") do
            subject { board.slide(tile) }

            context "when the tile can be moved" do
                let(:tile) { 6 }

                it { should == Board.new([ [1, 2, 3],
                                           [4, 5, nil],
                                           [7, 8, 6] ]) }
            end

            context "when the tile can't be moved" do
                let(:tile) { 1 }

                it "should raise an exception" do
                    lambda { subject() }.should raise_error
                end
            end
        end

        #describe("#slide") do
        #    let(:tile) { 1 }
        #    subject { board.slide(tile) }
        #
        #    context "for tile 6" do
        #        let(:duplicate_board) { Board.generate(3) }
        #
        #        before(:each) do
        #            board.stub(:dup).and_return(duplicate_board)
        #        end
        #
        #        it "should duplicate the board" do
        #            board.should_receive(:dup).and_return(mock(Board, :slide! => nil))
        #            subject()
        #        end
        #
        #        context "when the tile can be moved" do
        #            let(:gap) { mock(Point) }
        #            let(:tile_position) { mock(Point) }
        #
        #            before(:each) do
        #                duplicate_board.stub(:can_slide?).and_return(true)
        #                duplicate_board.stub(:gap).and_return(gap)
        #                duplicate_board.stub(:position_of).and_return(tile_position)
        #            end
        #
        #            it "should set the gap tile to the moving tile" do
        #                duplicate_board.should_receive(:set).with(gap, tile)
        #                subject()
        #            end
        #
        #            it "should set the original tile to be the gap" do
        #                duplicate_board.should_receive(:set).with(tile_position, nil)
        #                subject()
        #            end
        #        end
        #
        #        context "when the tile can't be moved" do
        #            before(:each) do
        #                duplicate_board.stub(:can_slide?).and_return(false)
        #            end
        #
        #            it "should raise an exception" do
        #                lambda { subject() }.should raise_error
        #            end
        #        end
        #    end
        #end
    end

end